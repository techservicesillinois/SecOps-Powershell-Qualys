<#
.Synopsis
    Purges host assets from Qualys by IP
.DESCRIPTION
    Purges host assets from Qualys by IP
.PARAMETER IPs
    An array of IPs to purge from Qualys
.EXAMPLE
    Remove-QualysHosts -IPs ("192.168.1.1", "192.168.0.0")
#>

function Remove-QualysHosts{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String[]]$IPs
    )

    process{
        $RestSplat = @{
            Method = 'POST'
            RelativeURI = 'asset/host/'
            Body = @{
                action = 'purge'
                ips = ($IPs.Trim() -join ", ")
            }
        }
        $Response = Invoke-QualysRestCall @RestSplat
        $Response.BATCH_RETURN.RESPONSE.BATCH_LIST.BATCH
    }
}
