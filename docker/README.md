# Docker Setup

Complete Docker containerization platform setup for Arch Linux with optimized configurations and development tools.

## Directory Structure

- **[`scripts/`](./scripts/)** - Installation and management scripts
- **[`config-files/`](./config-files/)** - Configuration files and templates
- **[`docs/`](./docs/)** - Documentation and guides
- **[`tests/`](./tests/)** - Validation and testing scripts

## Quick Start

```bash
# Install Docker and Docker Compose
./docker/scripts/install-docker.sh

# Apply Docker daemon configuration
sudo cp docker/config-files/daemon.json /etc/docker/daemon.json
sudo systemctl restart docker

# Test setup with sample services
cd docker/config-files
docker-compose up -d

# Verify installation
./docker/tests/test-docker.sh
```

## Installation

### Automated Installation

The installation script handles:
- Docker engine installation from official repositories
- Docker Compose installation
- User group configuration
- Service enablement and startup
- Installation verification

### Manual Installation

```bash
# Install Docker
sudo pacman -S docker
sudo systemctl enable docker
sudo systemctl start docker

# Install Docker Compose
sudo pacman -S docker-compose

# Add user to docker group
sudo usermod -aG docker "$USER"
```

## Configuration

### Docker Daemon Configuration

- **Log rotation** - 10MB max file size, 3 files retained
- **Storage driver** - overlay2 for optimal performance
- **cgroup driver** - systemd integration
- **Resource limits** - increased file descriptor limits
- **Live restore** - minimize downtime during daemon restarts

### Network Configuration

- Bridge networking for container isolation
- Custom test network for development
- Port mapping for service exposure

## Development Services

### Included Test Stack

- **Nginx** - Web server (port 8080)
- **Redis** - In-memory data store (port 6379)
- **PostgreSQL** - Database (port 5432)

### Service Management

```bash
# Start all services
docker-compose up -d

# View service status
docker-compose ps

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

## Security

### User Permissions

- Docker group membership for non-root container access
- Service isolation using user namespaces
- Resource limits enforcement

### Best Practices

- Regular Docker updates via pacman
- Log file rotation to prevent disk exhaustion
- Network segmentation using custom networks
- Volume data persistence for databases

## Troubleshooting

### Common Issues

**Docker command requires sudo**
```bash
# Add user to docker group and relogin
sudo usermod -aG docker "$USER"
newgrp docker
```

**Container startup failures**
```bash
# Check daemon status
sudo systemctl status docker

# View daemon logs
sudo journalctl -u docker -f
```

**Port conflicts**
```bash
# Check port usage
ss -tulpn | grep :8080
```

## Performance Optimization

### System Settings

- Increase VM max map count for Elasticsearch
- Configure cgroup limits for container constraints
- Enable overlay2 storage driver for better I/O

### Container Optimization

- Use Alpine Linux images for smaller footprints
- Implement health checks in containers
- Configure resource limits in docker-compose

## Integration

### Development Workflow

1. Clone repository and run Docker installation
2. Configure daemon settings for performance
3. Use test stack for development validation
4. Extend docker-compose.yml for project needs

### CI/CD Integration

Docker services integrate with existing automation:
- Automated testing with container validation
- Configuration deployment via automation scripts
- Backup and restore functionality for container data