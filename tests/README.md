# Test Suite

Validation and testing scripts for the Arch Linux dotfiles repository.

## Available Tests

- **[validate-system.sh](./validate-system.sh)** - Complete system validation
- **[test-packages.sh](./test-packages.sh)** - Package installation verification
- **test-configs.sh** - Configuration file validation
- **test-network.sh** - Network connectivity tests
- **test-development.sh** - Development environment tests

## Running Tests

### Full System Validation

```bash
# Run complete test suite
./validate-system.sh

# Run with verbose output
./validate-system.sh --verbose

# Generate test report
./validate-system.sh --report > test-report.txt
```

### Individual Test Categories

```bash
# Test package installations
./test-packages.sh

# Test configuration files
./test-configs.sh

# Test development setup
./test-development.sh
```

## Test Categories

### System Tests
- Package installation verification
- Service status checks
- Configuration file validation
- Permission and ownership verification

### Development Tests
- Development tools functionality
- Build system validation
- IDE and editor configuration
- Version control setup

### Integration Tests
- Network connectivity
- Application functionality
- Environment variable validation
- Service interaction testing