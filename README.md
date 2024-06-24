![Pester Tests](https://github.com/techservicesillinois/SecOps-Powershell-Qualys/workflows/Pester%20Tests/badge.svg)
![ScriptAnalyzer](https://github.com/techservicesillinois/SecOps-Powershell-Qualys/workflows/ScriptAnalyzer/badge.svg)

# What is This?

This Powershell module acts as a wrapper for the Qualys REST API, allowing you to create scripts that run operations tasks in Qualys

# How do I install it?

The latest stable release is always available via the [PSGallery](https://www.powershellgallery.com/packages/UofIQualys).
```powershell
# This will install on the local machine
Install-Module -Name 'UofIQualys'
```

# How does it work?

Get-Help is available for all functions in this module.
You must run New-QualysSession before other functions can be used.

If in a different Qualys Region than US1, please see [this page](https://www.qualys.com/platform-identification/) to determine your base URIs.
You should set $env:QualysSettings to a JSON-formatted string containing BaseURI and BasicAuthURI properties (see settings.json for example).

# How do I help?

Submit a PR on GitHub

# To Do

- Support for targeting by IPs with Scan functions
- Prod/Dev BaseURI switching
- Example Scripts
