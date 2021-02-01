# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

### Changed

### Removed

## [1.2.1] - 2020-01-28

### Added

- DefaultScanner parameter for Add/Set-QualysAssetGroups

### Changed

- Bugfix for Add-QualysUser when error in $Responsess
- Parameter set for Active/Deactivated scans in Get-QualysScanSchedule

### Removed

## [1.2.0] - 2020-01-26

### Added

- Start-QualysScan, Get-QualysScans, Get-QualysScanSchedules, Set-QualysAssetGroups

### Changed

- Fixed incorrect comment-based help
- Bugfix for Remove-QualysAssetGroups identity parameter

### Removed

## [1.1.4] - 2020-12-21

### Changed

- Fixed bug with verbose mode erroring when there is no response output

## [1.1.3] - 2020-12-10

### Changed

- Add, Remove and Set functions now only display console output when specifying -Verbose

## [1.1.2] - 2020-11-23

### Changed

- Bugfix for adding multiple assetgroups when adding a user.

## [1.1.1] - 2020-11-23

### Changed

- Update User functions ExternalID to match API External_ID
- Made Credential first parameter of User functions
- Fixed bug with parameter mismatches in Set-QualysUser, added aliases
- Changed other User functions to match Set-QualysUser's aliases

## [1.1.0] - 2020-11-17

### Added

- Added function to list Users
- Added production URLs to settings
- Added function to set Users

### Changed

- ExternalID parameter added to Add-QualysUser

## [1.0.2] - 2020-11-16

### Changed

- Fixed bug with identity matching in Get-QualysAssetGroups

## [1.0.1] - 2020-11-16

### Added

- Added function for creating new Users
- Added alternate base URL in settings

### Changed

- Invoke-QualysRestCall can now make rest calls using basic authentication

## [1.0.0] - 2020-11-06

### Added

- Added functions for manipulating Host Assets
- Added help docs generated from PlatyPS using the comment-based help.

### Changed

- QOL improvement to functions that take subnets as a parameter. Parameters now expect a string array.
- All functions now using Invoke-QualysRestCall as a helper function.
