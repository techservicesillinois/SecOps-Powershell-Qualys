<#
.Synopsis
    List schedules for vulnerability scans
.DESCRIPTION
    List schedules for vulnerability scans
.PARAMETER ID
    The ID of the scan schedule you want to display.
.PARAMETER Active
    Specify for active schedules only
.PARAMETER Deactivated
    Specify for deactivated schedules only
.EXAMPLE
    Get-QualysScanSchedules -Active
#>
function Get-QualysScanSchedules{
    [CmdletBinding()]
    param (
        [String]$ID,
        [Switch]$Active,
        [Switch]$Deactivated
    )

    process{

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = 'schedule/scan/'
            Body = @{
                action = 'list'
                echo_request = '1'
                show_notifications = '1'
            }
        }

        If($Active){
            $RestSplat.Body['active'] = '1'
        }
        If($Deactivated){
            $RestSplat.Body['active'] = '0'
        }
        If($ID){
            $RestSplat.Body['id'] = $ID
        }

        $Response = Invoke-QualysRestCall @RestSplat
        $Response.SCHEDULE_SCAN_LIST_OUTPUT.RESPONSE.SCHEDULE_SCAN_LIST.SCAN
    }
}
