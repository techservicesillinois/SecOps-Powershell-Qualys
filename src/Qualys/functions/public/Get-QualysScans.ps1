<#
.Synopsis
    List vulnerability scans in the user’s account. By default the output lists scans launched in the past 30 days
.DESCRIPTION
    List vulnerability scans in the user’s account. By default the output lists scans launched in the past 30 days
.PARAMETER ScanRef
    Show only a scan with a certain scan reference code. For a vulnerability scan, the format is: scan/987659876.19876
    For a compliance scan the format is: compliance/98765456.12345
.PARAMETER State
    Show only one or more scan states. A valid value is: Running, Paused, Canceled, Finished, Error, Queued
.PARAMETER Processed
    Specify to show only scans that have been processed
.PARAMETER Type
    Show only a certain scan type. A valid value is: On-Demand, Scheduled, or API
.PARAMETER Target
    Show only one or more target IP addresses. Multiple IP addresses and/or ranges may be entered. Multiple entries are comma separated.
    You may enter an IP address range using the hyphen (-) to separate the start and end IP address, as in:
    10.10.10.1-10.10.10.2
.PARAMETER UserLogin
    Show only scans launched by a particular user login
.PARAMETER LaunchedAfterDate
    Show only scans launched after a certain date and time.
    The date/time is specified in yyyy-MM-dd[THH:mm:ssZ] format (UTC/GMT), like “2007-07-01” or “2007-01-25T23:12:00Z”
.PARAMETER LaunchedBeforeDate
    Show only scans launched before a certain date and time.
    The date/time is specified in yyyy-MM-dd[THH:mm:ssZ] format (UTC/GMT), like “2007-07-01” or “2007-01-25T23:12:00Z”
.EXAMPLE
    Get-QualysScans
#>
function Get-QualysScans{
    [CmdletBinding()]
    param (
        [Alias('scan_ref')]
        [String]$ScanRef,
        [String]$State,
        [Switch]$Processed,
        [String]$Type,
        [String]$Target,
        [Alias('user_login')]
        [String]$UserLogin,
        [Alias('launched_after_datetime')]
        [Datetime]$LaunchedAfterDate,
        [Alias('launched_before_datetime')]
        [Datetime]$LaunchedBeforeDate
    )

    process{

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = 'scan/'
            Body = @{
                action = 'list'
                echo_request = '1'
                processed = [string][int]$Processed.IsPresent
            }
        }

         #Takes any parameter that's set, except excluded ones, and adds one of the same name (or alias name if present) to the API body
         [String[]]$Exclusions = ('Processed')
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
        $Response.SCAN_LIST_OUTPUT.RESPONSE.SCAN_LIST.SCAN
    }
}
