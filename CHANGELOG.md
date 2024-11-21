# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

### Changed

### Removed

## [1.8.2] - 2024-11-21

### Added

- Remove-QualysHosts: Purges hosts based on IP from Qualys.

### Changed

- Set-QualysAssetGroups: Add Scanners parameter so you can add non-default scanners to asset groups
- Add-QualysAssetGroups: Add Scanners parameter so you can add non-default scanners to asset groups

## [1.8.1] - 2024-07-15

### Added

- Get-QualysAMUser: function that gets user information from the administration module. This supporting function is necessary for Add-QualysUserTagAssignment after discovering VMDR User IDs and Administration User IDs are not the same.
- Invoke-QualysTagRestCall was missing from the module's functions to export.

### Changed

- Add-QualysUserTagAssignment: Now takes a User Login instead of ID and gets the AM ID by using the Get-QualysAMUser function.

## [1.8.0] - 2024-07-08

### Added

- Add-QualysAssetTagAssignment: This function takes an asset ID and a tag ID and adds the tag to the asset.
- Get-QualysAsset: This function takes an asset name or ID and returns the asset object.
- Get-QualysAssetInventory: Fetches all Qualys host asset objects.
- Get-QualysTag: This function takes a tag name or ID and returns the tag object.
- Remove-QualysTagAssignment: This function takes an asset ID and a tag ID and removes the tag from the asset.
- QualysAsset class: This class defines objects with properties that include all details returned by the QPS API about a host asset, plus optional metadata for function and method use.
- QualysTag class: This class defines objects with properties that include all details returned by the QPS API about a tag, plus optional metadata and parent tag.
- Invoke-QualysTagRestCall: The new tagging functions use this modified version of Invoke-QualysRestCall. The BaseURI for tagging endpoints is different from User Basic auth endpoints and there is nothing to clearly distinguish the two.
- Added the tagging Base URI to the settings.json
- Added Add-QualysUserTagAssignment: this function adds tag assignments to users.
- Added functions Get-QualysReports and Save-QualysReport

### Changed

- Support using environment variables to automatically override settings.json script-scoped parameters.

## [1.6.0] - 2023-05-02

### Added

- Function to get vulnerability information from Qualys KB. Get-QualysKBContent
- Generated new markdown help

## [1.5.0] - 2022-09-09

### Changed

- Added retry to Invoke-QualysRestCall to compensate for short periods where the Qualys api is unreachable

## [1.4.5] - 2022-01-07

### Changed

- Minimum Powershell version set to 5.1

### Removed

- Comments removed from json file for Powershell 5.1 compatability
- Ternary operator from Start-QualysScan for Powershell 5.1 compatability
- UofI specific language in a comment

## [1.4.4] - 2021-12-22

### Changed

- Minimum Powershell version set to 7

## [1.4.3] - 2021-11-23

### Changed

- IP logic in Get-QualysAssetGroups sometimes resulted in a string being returned instead of a string array for the IPs property

## [1.4.2] - 2021-10-14

### Added

- Added DefaultParameterSetName to Cmdletbindings for Add and Set-QualysScanSchedule

## [1.4.1] - 2021-10-05

### Added

- New function Close-QualysSession

### Changed

- Add-QualysScanSchedule & Set-QualysScanSchedule parameter sets and fix example

## [1.4.0] - 2021-10-05

### Added

- New function Stop-QualysScan

### Changed

- Added blank scriptanalyzer param for 'CheckID' on all scripts using the 'PSUseSingularNouns' attribute as this was causing errors
- Update all Markdown Help

## [1.3.4] - 2021-08-26

### Added

- New private function Format-IPAddressGroup created to centralize logic for formatting IP addresses for API calls.

### Changed

- Added scriptanalyzer exceptions for "PSUseSingularNouns" per [issue #40](https://github.com/techservicesillinois/SecOps-Powershell-Qualys/issues/40)

## [1.3.3] - 2021-08-26

### Added

- New private function Format-IPAddressGroup created to centralize logic for formatting IP addresses for API calls.

### Changed

- Added scriptanalyzer exceptions for "PSUseSingularNouns" per [issue #40](https://github.com/techservicesillinois/SecOps-Powershell-Qualys/issues/40)

## [1.3.2] - 2021-08-17

### Changed

- Description in Get-QualysScans regarding 'Processed' parameter
- Error handling for when no asset group is returned by Get-QualysAssetGroups
- Fix icon URL to point to raw image

## [1.3.1] - 2021-08-17

### Added

- feature_request template and bug_report template
- Publishtogallery script and github action

## [1.3.0] - 2021-08-16

### Added

- Code of Conduct, Contributing, Security docs and a Pull Request Template
- Icon for module

### Changed

- Module name from Qualys to UofIQualys

## [1.2.12] - 2021-05-07

### Changed

- Added function to support returning the script variable APICallCount

## [1.2.11] - 2021-05-07

### Changed

- Added script scope variable to count API calls

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
