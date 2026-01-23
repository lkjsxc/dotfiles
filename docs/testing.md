# Test Suite Documentation

Validation and testing scripts for the Arch Linux dotfiles repository.

## Available Tests

- **[validate-system.sh](../../src/tests/validate-system.sh)** - Complete system validation
- **[test-packages.sh](../../src/tests/test-packages.sh)** - Package installation verification
- **[test-configs.sh](../../src/tests/test-configs.sh)** - Configuration file validation
- **[test-network.sh](../../src/tests/test-network.sh)** - Network connectivity tests
- **[test-development.sh](../../src/tests/test-development.sh)** - Development environment tests

## Running Tests

### Full System Validation

```bash
# Run complete test suite
./src/tests/validate-system.sh

# Run with verbose output
./src/tests/validate-system.sh --verbose

# Generate test report
./src/tests/validate-system.sh --report > test-report.txt
```

### Individual Test Categories

```bash
# Test package installations
./src/tests/test-packages.sh

# Test configuration files
./src/tests/test-configs.sh

# Test development setup
./src/tests/test-development.sh

# Test network connectivity
./src/tests/test-network.sh
```

## Test Categories

### System Tests
- Package installation verification
- Service status checks
- Configuration file validation
- Permission and ownership verification
- System resource monitoring

### Development Tests
- Development tools functionality
- Build system validation
- IDE and editor configuration
- Version control setup
- Programming language environment

### Integration Tests
- Network connectivity
- Application functionality
- Environment variable validation
- Service interaction testing
- Cross-platform compatibility

## Test Output

### Validation Results
- Pass/Fail status for each test
- Detailed error messages
- Performance metrics
- System health summary

### Reporting
- HTML test reports
- JSON output for automation
- Log file generation
- Email notifications

## Continuous Integration

### Automated Testing
- Pre-commit validation
- Post-deployment verification
- Scheduled health checks
- Performance regression testing

### Test Configuration
- Customizable test parameters
- Environment-specific settings
- Parallel test execution
- Timeout and retry policies