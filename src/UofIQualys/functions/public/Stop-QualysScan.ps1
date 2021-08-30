<#
.Synopsis
    Launch vulnerability scan in the user’s account. Only targeting asset groups is supported currently. Support for targeting by IPs to be added later.
.DESCRIPTION
    Launch vulnerability scan in the user’s account. Only targeting asset groups is supported currently. Support for targeting by IPs to be added later.
.PARAMETER ScanRef
    The target FQDN for a vulnerability scan. Multiple values are comma separated.
    You can specify FQDNs in combination with IPs and asset groups
.EXAMPLE
    Start-QualysScan -Title 'Test Scan' -AssetGroups 'Test Asset Group'
#>
function Stop-QualysScan{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Alias('scan_ref')]
        [String]$ScanRef
    )

    process{
        if ($PSCmdlet.ShouldProcess("$($ScanRef)")){
            $RestSplat = @{
                Method = 'POST'
                RelativeURI = 'scan/'
                Body = @{
                    action = 'cancel'
                    echo_request = '1'
                    scan_ref = $ScanRef
                }
            }

            $Response = Invoke-QualysRestCall @RestSplat
            If($Response){
                Write-Verbose -Message $Response
            }
        }
    }
}
