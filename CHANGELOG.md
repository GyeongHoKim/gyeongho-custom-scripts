# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-05-23

### Added

- Initial release
- Unix-style commands for PowerShell:
  - `rm` - Remove files and directories with Unix-style options (-r, -f, -rf)
  - `touch` - Create empty files or update timestamps
  - `grep` - Search text in files with pattern matching
  - `which` - Find command locations
  - `tail` - Display last lines of files (with -f follow option)
  - `head` - Display first lines of files
  - `du` - Display disk usage
  - `ln` - Create symbolic/hard links
- Scoop package manifest for easy installation
- Automatic PowerShell profile integration
- Comprehensive test suite
- Installation and uninstallation scripts
