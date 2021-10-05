<#
.Synopsis
    Stop a vulnerability scan in the user’s account.
.DESCRIPTION
    Stop a vulnerability scan in the user’s account.
.PARAMETER ScanRef
    The target ScanRef for a vulnerability scan.
.EXAMPLE
    Stop-QualysScan -ScanRef 'scan/1633304415.63272'
#>
function Stop-QualysScan{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Alias('scan_ref')]
        [String]$ScanRef
    )

    process{
        if ($PSCmdlet.ShouldProcess("$($ScanRef)","Stop")){
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
