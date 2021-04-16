# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

### Changed

### Removed

## [1.2.10] - 2021-04-16

### Changed

- Fixed Set and Add QualysScanSchedule Active/Status parameter

## [1.2.9] - 2021-04-12

### Changed

- Fixed Get-QualysAssetGroups bug that only returned ranges OR single IPs not both

## [1.2.8] - 2021-04-05

### Changed

- Fixed example in Set-QualysAssetGroups
- Fixed type bug in Get-QualysScans
- Fixed bug with parameter name in Add-QualysScanSchedule

## [1.2.7] - 2021-04-01

### Added

- Get-QualysScanSummary.ps1

## [1.2.6] - 2021-03-12

### Added

- Disable-QualysUsers.ps1
- Enable-QualysUsers.ps1

## [1.2.5] - 2021-03-04

### Added

### Changed

- Settings from dev to prod

### Removed

- Nonfunctioning DefaultScanners parameter

## [1.2.4] - 2021-02-16

### Changed

- Status parameter on Set-QualysScanSchedules changed from Switch to Int

## [1.2.3] - 2021-02-11

### Added

- Get-QualysScanSchedules
- Remove-QualysScanSchedule
- Set-QualysScanSchedule

### Changed

### Removed

## [1.2.2] - 2021-02-09

### Added

- Add-QualysScanSchedule

### Changed

- Make ID parameters that are always numbers Ints
- Added appliance_ids to REST body for DefaultScanner params

## [1.2.1] - 2021-02-01

### Added

- DefaultScanner parameter for Add/Set-QualysAssetGroups

### Changed

- Bugfix for Add/Set-QualysUser when error in $Responses
- Parameter set for Active/Deactivated scans in Get-QualysScanSchedule
- Bugfix for Division parameter setting title in body of Set-QualysAssetGroups
- Limit attributes returned by Get-QualysAssetGroups
- Fix IP output for single IPs and add output for defaultscanner in Get-QualysAssetGroups
- Fix bug with verbose parameter on some functions

## [1.2.0] - 2021-01-26

### Added

- Start-QualysScan, Get-QualysScans, Get-QualysScanSchedules, Set-QualysAssetGroups

### Changed

- Fixed incorrect comment-based help
- Bugfix for Remove-QualysAssetGroups identity parameter

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
