#!/usr/bin/env bash
# Rootless Docker setup (Arch Linux) - best-practice, idempotent-ish
#
# Run:
#   chmod +x ./setup-rootless-docker-arch.sh
#   ./setup-rootless-docker-arch.sh
#
# Optional env:
#   FORCE_REINSTALL=1   Reinstall rootless Docker (stops user docker.service and removes ~/bin/dockerd)
#   SKIP_IPTABLES=1     Skip iptables checks in the rootless installer (not recommended unless required)

set -Eeuo pipefail
IFS=$'\n\t'

log() { printf '[%s] %s\n' "$(date +'%F %T')" "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"; }

require_bash() {
  [[ -n "${BASH_VERSION:-}" ]] || die "This script requires bash. Run: bash $0"
}

require_sudo() {
  if ! sudo -n true >/dev/null 2>&1; then
    log "Sudo password may be required."
    sudo -v || die "Failed to obtain sudo privileges."
  fi
}

is_systemd_user_available() {
  systemctl --user show-environment >/dev/null 2>&1
}

ensure_root_owned_file_exists() {
  local path="$1"
  if [[ ! -e "$path" ]]; then
    sudo touch "$path"
  fi
  sudo chown root:root "$path"
  sudo chmod 0644 "$path"
}

# Pick an unused subuid/subgid range start (block=65536), scanning all existing ranges.
pick_subid_start() {
  local file="$1"
  local block=65536
  local max_end=0

  if [[ -s "$file" ]]; then
    max_end="$(
      sudo awk -F: '
        NF>=3 && $2 ~ /^[0-9]+$/ && $3 ~ /^[0-9]+$/ {
          end=$2+$3;
          if (end>max) max=end
        }
        END { print (max==""?0:max) }
      ' "$file"
    )"
  fi

  if [[ "$max_end" -le 0 ]]; then
    echo 100000
    return
  fi

  local next=$(( ( (max_end + block - 1) / block ) * block ))
  echo "$next"
}

ensure_subid_entry() {
  local user="$1"
  local file="$2"
  local start="$3"
  local count="$4"

  ensure_root_owned_file_exists "$file"

  # If any entry exists, do not add another (avoid multiple ranges per user unless explicitly desired).
  if sudo awk -F: -v u="$user" '$1==u { found=1 } END{ exit(found?0:1) }' "$file"; then
    log "Sub-ID entry already present in $file for user '$user' (skipping)"
    return
  fi

  log "Adding sub-ID entry to $file: ${user}:${start}:${count}"
  printf '%s:%s:%s\n' "$user" "$start" "$count" | sudo tee -a "$file" >/dev/null
}

ensure_sysctl_userns_clone() {
  local conf="/etc/sysctl.d/100-rootless-docker.conf"
  local key="kernel.unprivileged_userns_clone"
  local desired="${key}=1"

  ensure_root_owned_file_exists "$conf"

  if sudo grep -Eq "^\s*${key}\s*=\s*1\s*$" "$conf"; then
    log "sysctl already set in $conf (skipping)"
  else
    if sudo grep -Eq "^\s*${key}\s*=" "$conf"; then
      log "Updating existing ${key} value in $conf"
      sudo sed -i -E "s|^\s*${key}\s*=.*$|${desired}|" "$conf"
    else
      log "Appending ${desired} to $conf"
      echo "$desired" | sudo tee -a "$conf" >/dev/null
    fi
  fi

  log "Applying sysctl settings"
  sudo sysctl --system >/dev/null

  local actual
  actual="$(sysctl -n "$key" 2>/dev/null || true)"
  [[ "$actual" == "1" ]] || die "sysctl ${key} is not 1 (actual: '${actual}')"
}

ensure_ip_tables_module() {
  # Rootless installer often requires iptables kernel module checks.
  if [[ "${SKIP_IPTABLES:-0}" == "1" ]]; then
    log "SKIP_IPTABLES=1 is set; skipping ip_tables module load"
    return
  fi

  if lsmod | awk '{print $1}' | grep -qx 'ip_tables'; then
    log "Kernel module ip_tables already loaded (skipping)"
    return
  fi

  log "Loading kernel module ip_tables (required by installer checks)"
  if ! sudo modprobe ip_tables; then
    die "Failed to load ip_tables. If your environment cannot provide it, rerun with SKIP_IPTABLES=1 (not recommended)."
  fi
}

install_rootless_docker() {
  need_cmd curl
  need_cmd mktemp
  need_cmd sh

  # Detect existing rootless install per installer behavior.
  local existing="${HOME}/bin/dockerd"
  if [[ -x "$existing" ]]; then
    if [[ "${FORCE_REINSTALL:-0}" == "1" ]]; then
      log "Existing rootless Docker detected at $existing; FORCE_REINSTALL=1 -> reinstalling"
      systemctl --user stop docker.service >/dev/null 2>&1 || true
      rm -f "$existing"
    else
      log "Existing rootless Docker detected at $existing; skipping installation (set FORCE_REINSTALL=1 to reinstall)"
      return
    fi
  fi

  ensure_ip_tables_module

  local tmp
  tmp="$(mktemp)"
  # Clean up when this function returns (avoids issues with set -u and local vars).
  trap 'rm -f -- "$tmp"' RETURN

  log "Downloading rootless installer"
  curl -fsSL https://get.docker.com/rootless -o "$tmp"

  log "Running rootless installer"
  if [[ "${SKIP_IPTABLES:-0}" == "1" ]]; then
    SKIP_IPTABLES=1 sh "$tmp"
  else
    sh "$tmp"
  fi
}

ensure_user_unit_wantedby_default_target() {
  need_cmd sed

  local unit="${HOME}/.config/systemd/user/docker.service"
  if [[ ! -f "$unit" ]]; then
    log "User unit not found: $unit (installation may not have created it). Skipping unit edit."
    return
  fi

  if [[ ! -f "${unit}.bak" ]]; then
    cp -p "$unit" "${unit}.bak"
    log "Backed up unit file to ${unit}.bak"
  fi

  if grep -Eq '^WantedBy=default\.target$' "$unit"; then
    log "WantedBy already default.target (skipping)"
    return
  fi

  if grep -Eq '^WantedBy=multi-user\.target$' "$unit"; then
    log "Replacing WantedBy=multi-user.target with WantedBy=default.target"
    sed -i 's/^WantedBy=multi-user\.target$/WantedBy=default.target/' "$unit"
  else
    # Fallback: if WantedBy line is unexpected, do not guess aggressively.
    log "WantedBy line is not in the expected form; leaving unit unchanged. You may need to adjust [Install] manually."
  fi
}

enable_user_docker_service() {
  need_cmd systemctl

  if ! is_systemd_user_available; then
    die "systemctl --user is not available (no user session bus). Run from an interactive login session."
  fi

  log "Reloading user systemd"
  systemctl --user daemon-reload

  log "Enabling and starting docker.service"
  systemctl --user enable --now docker.service

  log "docker.service status:"
  systemctl --user status docker.service --no-pager
}

enable_linger() {
  need_cmd loginctl
  log "Enabling linger for user $(whoami)"
  sudo loginctl enable-linger "$(whoami)"
}

main() {
  require_bash
  [[ "$(id -u)" -ne 0 ]] || die "Do not run as root. Run as the target user with sudo privileges."

  need_cmd awk
  need_cmd grep
  need_cmd lsmod
  need_cmd sysctl
  need_cmd tee

  require_sudo

  local user
  user="$(whoami)"

  log "Ensuring /etc/subuid and /etc/subgid exist and contain an entry for current user"
  local count=65536
  local subuid_start subgid_start
  subuid_start="$(pick_subid_start /etc/subuid)"
  subgid_start="$(pick_subid_start /etc/subgid)"
  ensure_subid_entry "$user" /etc/subuid "$subuid_start" "$count"
  ensure_subid_entry "$user" /etc/subgid "$subgid_start" "$count"

  log "Ensuring kernel.unprivileged_userns_clone=1 via /etc/sysctl.d/"
  ensure_sysctl_userns_clone

  log "Installing (or confirming) rootless Docker"
  install_rootless_docker

  log "Ensuring docker.service is enabled on user session start (WantedBy=default.target)"
  ensure_user_unit_wantedby_default_target

  log "Enabling user docker.service"
  enable_user_docker_service

  log "Enabling linger (optional but recommended if you want it to run without login)"
  enable_linger

  log "Done."
  log "If the Docker CLI cannot connect, try:"
  log "  export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock"
}

main "$@"
