<#
.Synopsis
    Returns a true or false value if the network is present or not in the Qualys Host Assets
.DESCRIPTION
    Returns a true or false value if the network is present or not in the Qualys Host Assets
.PARAMETER Network
    Network as a range of addresses i.e. "128.174.118.0-128.174.118.255"
.EXAMPLE
    Test-QualysHostAssets -Network "128.174.118.0-128.174.118.255"
    #>
function Test-QualysHostAssets{
    [OutputType([bool])]
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Parameter(Mandatory)]
        [String]$Network
    )

    process{

        $HostAssets = Get-QualysHostAssets
        if ($HostAssets.Contains($Network)){
            return $true
        }
        else{
            return $false
        }
    }
}
