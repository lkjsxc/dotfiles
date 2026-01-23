# Automation Scripts

Deployment, backup, and maintenance automation for Arch Linux dotfiles.

## Available Scripts

- **[deploy-configs.sh](./deploy-configs.sh)** - Deploy configuration files to system
- **[backup-system.sh](./backup-system.sh)** - System backup and restoration
- **[update-system.sh](./update-system.sh)** - Automated system updates
- **[cleanup-system.sh](./cleanup-system.sh)** - System cleanup and maintenance
- **[sync-repo.sh](./sync-repo.sh)** - Repository synchronization

## Usage

### Deployment

```bash
# Deploy all configurations
./deploy-configs.sh

# Deploy specific category
./deploy-configs.sh --category development

# Dry run deployment
./deploy-configs.sh --dry-run
```

### Maintenance

```bash
# Full system update
./update-system.sh

# System cleanup
./cleanup-system.sh

# Create backup
./backup-system.sh --create

# Restore from backup
./backup-system.sh --restore /path/to/backup
```

### Synchronization

```bash
# Sync with remote repository
./sync-repo.sh

# Push changes to remote
./sync-repo.sh --push

# Pull latest changes
./sync-repo.sh --pull
```

## Automation Features

- **Configuration Deployment** - Automated dotfile deployment with validation
- **System Backup** - Complete system backup with compression
- **Package Management** - Automated updates and cleanup
- **Repository Sync** - Git repository synchronization
- **Health Monitoring** - System health checks and reporting

## Scheduling

Use cron for regular automation:

```bash
# Edit crontab
crontab -e

# Add system update (weekly)
0 3 * * 0 /path/to/dotfiles/automation/update-system.sh

# Add system cleanup (daily)
0 2 * * * /path/to/dotfiles/automation/cleanup-system.sh
```