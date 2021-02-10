<#
.Synopsis
    Removes a scan schedule from Qualys
.DESCRIPTION
    Removes a scan schedule from Qualys
.PARAMETER Identity
    The ID of the Scan Schedule to delete. Only one Identity may be provided per API call.
.EXAMPLE
    Remove-QualysScanSchedule -Identity "3848863"
    #>
    function Remove-QualysScanSchedule{
        [CmdletBinding(SupportsShouldProcess)]
        param (
            [Parameter(Mandatory=$true)]
            [String]$Identity
        )

        process{
            if ($PSCmdlet.ShouldProcess($Identity)){
                $RestSplat = @{
                    Method = 'POST'
                    RelativeURI = 'schedule/scan/'
                    Body = @{
                        action = 'delete'
                        echo_request = '1'
                        id = $Identity
                    }
                }

                $Response = Invoke-QualysRestCall @RestSplat
                if ($Response) {
                    Write-Verbose -Message $Response.SIMPLE_RETURN.RESPONSE.TEXT
                }
            }
        }
    }
