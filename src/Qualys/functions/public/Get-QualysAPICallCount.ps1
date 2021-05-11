<#
.Synopsis
    Returns the number of times Invoke-QualysRestCall is called
.DESCRIPTION
    Returns the number of times Invoke-QualysRestCall is called
.EXAMPLE
    Get-QualysAPICallCount
    #>
function Get-QualysAPICallCount{
    [OutputType([int])]
    [CmdletBinding()]
    param (
    )

    process{
        return $Script:APICallCount
    }
}
