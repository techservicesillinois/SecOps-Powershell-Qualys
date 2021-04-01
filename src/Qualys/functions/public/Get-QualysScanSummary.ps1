<#
.Synopsis
    List all the scans launched since the date and identifies hosts that were included in the scan target but not scanned for some reason.
.DESCRIPTION
    List all the scans launched since the date and identifies hosts that were included in the scan target but not scanned for some reason.
.PARAMETER ScanDateSince
    Include scans started since a certain date. Specify the date in YYYY-MM-DD format. The date must be less than or equal to today’s date.
.PARAMETER ScanDateTo
    Include scans started up to a certain date. Specify the date in YYYY-MM-DD format. The date must be more than or equal to scan_date_since, and less than or equal to today’s date.
.PARAMETER IncludeDead
    Set to 0 if you do not want to include dead hosts in the output. Dead hosts are included by default.
.PARAMETER IncludeCancelled
    Set to 1 to include cancelled hosts in the output. Cancelled hosts are not included by default.
.EXAMPLE
    Get-QualysScanSummary -ScanDateSince '2021-03-03' -ScanDateTo '2021-03-03' -IncludeCancelled -IncludeDead
#>

function Get-QualysScanSummary{
    [CmdletBinding()]
    param (
        [Alias('scan_date_since')]
        [Parameter(Mandatory=$true)]
        [String]$ScanDateSince,
        [Alias('scan_date_to')]
        [String]$ScanDateTo,
        [Switch]$IncludeDead,
        [Switch]$IncludeCancelled
    )

    process{

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = 'scan/summary/'
            Body = @{
                action = 'list'
                echo_request = '1'
                output_format = 'json'
                include_dead = [string][int]$IncludeDead.IsPresent
                include_cancelled = [string][int]$IncludeCancelled.IsPresent
            }
        }

         #Takes any parameter that's set, except excluded ones, and adds one of the same name (or alias name if present) to the API body
         [String[]]$Exclusions = ('Verbose', 'IncludeCancelled', 'IncludeDead')
         $PSBoundParameters.Keys | Where-Object -FilterScript {($_ -notin $Exclusions) -and $_} | ForEach-Object -Process {
             if($MyInvocation.MyCommand.Parameters[$_].Aliases[0]){
                 [String]$APIKeyNames = $MyInvocation.MyCommand.Parameters[$_].Aliases[0]
                 $RestSplat.Body.$APIKeyNames = $PSBoundParameters[$_]
             }
             else {
                 $RestSplat.Body.$_ = $PSBoundParameters[$_]
             }
         }

        $Response = Invoke-QualysRestCall @RestSplat
        $Response
    }
}

