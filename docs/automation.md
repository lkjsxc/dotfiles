# Automation Scripts Documentation

Deployment, backup, and maintenance automation for Arch Linux dotfiles.

## Available Scripts

- **[deploy-configs.sh](../../src/automation/deploy-configs.sh)** - Deploy configuration files to system
- **[backup-system.sh](../../src/automation/backup-system.sh)** - System backup and restoration
- **[update-system.sh](../../src/automation/update-system.sh)** - Automated system updates
- **[cleanup-system.sh](../../src/automation/cleanup-system.sh)** - System cleanup and maintenance
- **[sync-repo.sh](../../src/automation/sync-repo.sh)** - Repository synchronization

## Usage

### Deployment

```bash
# Deploy all configurations
./src/automation/deploy-configs.sh

# Deploy specific category
./src/automation/deploy-configs.sh --category development

# Dry run deployment
./src/automation/deploy-configs.sh --dry-run
```

### Maintenance

```bash
# Full system update
./src/automation/update-system.sh

# System cleanup
./src/automation/cleanup-system.sh

# Create backup
./src/automation/backup-system.sh --create

# Restore from backup
./src/automation/backup-system.sh --restore /path/to/backup
```

### Synchronization

```bash
# Sync with remote repository
./src/automation/sync-repo.sh

# Push changes to remote
./src/automation/sync-repo.sh --push

# Pull latest changes
./src/automation/sync-repo.sh --pull
```

## Automation Features

### Configuration Deployment
- Automated dotfile deployment with validation
- Configuration file backup before deployment
- Permission and ownership management
- Rollback capability

### System Backup
- Complete system backup with compression
- Incremental backup support
- Scheduled backup automation
- Restoration verification

### Package Management
- Automated system updates
- Package cleanup and optimization
- Dependency management
- Security updates monitoring

### Repository Sync
- Git repository synchronization
- Conflict resolution
- Branch management
- Remote synchronization

### Health Monitoring
- System health checks
- Performance monitoring
- Error reporting
- Maintenance scheduling

## Scheduling

Use cron for regular automation:

```bash
# Edit crontab
crontab -e

# Add system update (weekly)
0 3 * * 0 /home/user/dotfiles/src/automation/update-system.sh

# Add system cleanup (daily)
0 2 * * * /home/user/dotfiles/src/automation/cleanup-system.sh

# Add backup (weekly)
0 1 * * 0 /home/user/dotfiles/src/automation/backup-system.sh --create
```