![Pester Tests](https://github.com/techservicesillinois/SecOps-Powershell-Qualys/workflows/Pester%20Tests/badge.svg)
![ScriptAnalyzer](https://github.com/techservicesillinois/SecOps-Powershell-Qualys/workflows/ScriptAnalyzer/badge.svg)

# What is This?

This Powershell module acts as a wrapper for the Qualys REST API, allowing you to create scripts that run operations tasks in Qualys

# How do I install it?

1. Save the Qualys folder to your Powershell modules folder
2. Import-Module Qualys

# How does it work?

Get-Help is available for all functions in this module.
You must run New-QualysSession before other functions can be used.

# How do I help?

Submit a PR on GitHub

# To Do

- Add-QualysScanSchedule
- Prod/Dev BaseURI switching
- Example Scripts
- Options for targeting "tags" with scans
