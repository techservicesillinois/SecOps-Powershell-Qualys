# Contribution Guidelines

This document aims to outline the requirements for the various forms of contribution for this project.

**ALL** contributions are subject to review via pull request

## New Functions

- Update the "Unreleased" section of the [changelog](/CHANGELOG.md) to reflect what was added
- Use approved Powershell verbs for function names
- Include Comment Based Help for every function
- Update the module version number and include the new function in the FunctionsToExport in UofIQualys.psd1
- Markdown documentation must be placed in the [module's docs folder](/src/help)

## Function Enhancements

- Issue justifying the change should be created and cited in the pull request
- Update the [changelog](/CHANGELOG.md) to reflect the change
- Increment the version number appropriately, there is no proper release for this so it is incremented as it's updated

## Documentation

- Must be in markdown
