<#
.Synopsis
    Returns a true or false value if the network is present or not in the Qualys Host Assets
.DESCRIPTION
    Returns a true or false value if the network is present or not in the Qualys Host Assets
.PARAMETER Network
    Network(s) as a range of addresses i.e. "128.174.118.0-128.174.118.255"
.EXAMPLE
    Test-QualysHostAssets -Networks "128.174.118.0-128.174.118.255", "192.17.81.64-192.17.81.94"
    #>
function Test-QualysHostAssets{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Array]$Networks
    )

    process{

        $HostAssets = Get-QualysHostAssets
        foreach ($Network in $Networks){
            if ($HostAssets.Contains($Network)){
                write-output "$Network $true"
            }
            else{
                write-output "$Network $false"
            }
        }
    }
}