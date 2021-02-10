<#
.Synopsis
    Schedule a VM scan. Only targeting asset groups is supported currently. Support for targeting by IPs to be added later.
.DESCRIPTION
    Schedule a VM scan. Only targeting asset groups is supported currently. Support for targeting by IPs to be added later.
.PARAMETER Title
    The title of the scan title
.PARAMETER Active
     Specify to create an active schedule, otherwise the schedule will be created deactivated
.PARAMETER OptionProfile
    The id or title of the option profile to use
.PARAMETER AssetGroups
    The titles or ids of asset groups containing the hosts to be scanned. Multiple titles are comma separated
    Use only IDs or titles, do not mix and match.
.PARAMETER Scanners
    The IDs or friendly names of the scanner appliances to be used or “External” for external scanners. Multiple entries are comma separated.
    Use only IDs or friendly names, do not mix and match
.PARAMETER DefaultScanners
    Specify to use the default scanner in each target asset group
.PARAMETER Priority
    Specify a value of 0 - 9 to set a processing priority level for the scan
.PARAMETER FQDN
    The target FQDN for a vulnerability scan. Multiple values are comma separated
    You can specify FQDNs in combination with IPs and asset groups
.PARAMETER Daily
    Have the scan run every specified number of days. Value is an integer from 1 - 365
.PARAMETER Weekly
    Have the scan run every specified number of weeks. Value is an integer from 1 - 52
.PARAMETER Weekdays
    The scan will run only on specified weekdays. Value is one or more days: sunday, monday, tuesday, wednesday, thursday, friday, saturday.
    Multiple days are comma separated. By default all weekdays are selected
.PARAMETER StartDate
    The start date in mm/dd/yyyy format. By default the start date is the date when the schedule is created
.PARAMETER StartHour
    The hour when the scan will start. The hour is aninteger from 0 - 23, where 0 represents 12AM, 7 represents 7AM, and 22 represents 10PM
.PARAMETER StartMinute
    The minute when a scan will start. A valid value is an integer from 0 - 59
.PARAMETER Recurrence
    The number of times the scan will be run before it is deactivated. By default no value is set. Value is an integer from 1 - 99
.PARAMETER EndAfterHours
    End a scan after some number of hours. A valid value is from 0 - 119
.PARAMETER EndAfterMins
    End a scan after some number of minutes. A valid value is an integer from 0 to 59
.PARAMETER PauseAfterHours
    Pause a scan after some number of hours. A valid value is from 0 - 119
.PARAMETER PauseAfterMins
    Pause a scan after some number of minutes. A valid value is an integer from 0 - 59
.PARAMETER ResumeInDays
    Resume a paused scan in some number of days. A valid value is an integer from 0 - 9
.PARAMETER ResumeInHours
    Resume a paused scan in some number of hours. A valid value is an integer from 0 - 23
.EXAMPLE
    Add-QualysScanSchedule -Title 'Test Schedule' -AssetGroups 'My Asset Group' -DefaultScanners -Daily 20 -StartDate "03/01/2021" -StartHour 0 -StartMinute 0 -EndAfterHours 0 -EndAfterMins 20 -OptionProfile 'Recommended Standard Scan'
#>
function Add-QualysScanSchedule{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [Alias('scan_title')]
        [String]$Title,
        [Switch]$Active,
        [Parameter(Mandatory=$true)]
        [String]$OptionProfile,
        [String[]]$AssetGroups,
        [String]$Scanners,
        [Switch]$DefaultScanners,
        [ValidateRange(0,9)]
        [Int]$Priority = 0,
        [String[]]$FQDN,
        [ValidateRange(1,365)]
        [Int]$Daily,
        [ValidateRange(1,52)]
        [Int]$Weekly,
        [String]$Weekdays = 'sunday, monday, tuesday, wednesday, thursday, friday, saturday',
        [Alias('start_date')]
        [DateTime]$StartDate,
        [Parameter(Mandatory=$true)]
        [ValidateRange(0,23)]
        [Alias('start_hour')]
        [Int]$StartHour,
        [Parameter(Mandatory=$true)]
        [ValidateRange(0,59)]
        [Alias('start_minute')]
        [Int]$StartMinute,
        [ValidateRange(1,99)]
        [Int]$Recurrence,
        [ValidateRange(0,119)]
        [Alias('end_after')]
        [Int]$EndAfterHours,
        [ValidateRange(0,59)]
        [Alias('end_after_mins')]
        [Int]$EndAfterMins,
        [ValidateRange(0,119)]
        [Alias('pause_after_hours')]
        [Int]$PauseAfterHours,
        [ValidateRange(0,59)]
        [Alias('pause_after_mins')]
        [Int]$PauseAfterMins,
        [ValidateRange(0,9)]
        [Alias('resume_in_days')]
        [Int]$ResumeInDays,
        [ValidateRange(0,23)]
        [Alias('resume_in_hours')]
        [Int]$ResumeInHours
    )

    process{
        $RestSplat = @{
            Method = 'POST'
            RelativeURI = 'schedule/scan/'
            Body = @{
                action = 'create'
                echo_request = '1'
                scan_title = $Title
                active = [string][int]$Active.IsPresent
                default_scanner = [string][int]$DefaultScanners.IsPresent
                target_from = 'assets'
                observe_dst = 'yes'
                time_zone_code = 'US-IL'
            }
        }

        If($Daily){
            $RestSplat.Body['occurrence'] = 'daily'
            $RestSplat.Body['frequency_days'] = $Daily
        }

        If($Weekly){
            $RestSplat.Body['occurrence'] = 'weekly'
            $RestSplat.Body['frequency_weeks'] = $Weekly
            $RestSplat.Body['weekdays'] = $Weekdays
        }

        If($AssetGroups){
            If($AssetGroups[0] -match '\D'){
                $RestSplat.Body['asset_groups'] = (($AssetGroups).Trim() -join ",")
            }
            Else{
                $RestSplat.Body['asset_group_ids'] = (($AssetGroups).Trim() -join ",")
            }
        }

        If($OptionProfile){
            If($OptionProfile -match '\D'){
                $RestSplat.Body['option_title'] = $OptionProfile
            }
            Else{
                $RestSplat.Body['option_id'] = $OptionProfile
            }
        }

        If($ExcludeIPs){
            $RestSplat.Body['exclude_ip_per_scan'] = (($ExcludeIPs).Trim() -join ",")
        }

        If($Scanners){
            If($Scanners -match '\D'){
                $RestSplat.Body['iscanner_name'] = $Scanners
            }
            Else{
                $RestSplat.Body['iscanner_id'] = $Scanners
            }
        }

        If($FQDN){
            $RestSplat.Body['fqdn'] = (($FQDN).Trim() -join ",")
        }

        If($StartDate){
            $RestSplat.Body['start_date'] = $StartDate.ToString("MM/dd/yyyy")
        }

        #Takes any parameter that's set, except excluded ones, and adds one of the same name (or alias name if present) to the API body
        [String[]]$Exclusions = (
            'Daily','TimeZoneCode','Weekly','ExcludeIPs','DefaultScanners', 'AssetGroups',
            'OptionProfile', 'Scanners', 'FQDN', 'StartDate','Verbose'
        )
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
        If($Response){
            Write-Verbose -Message $Response.SIMPLE_RETURN.RESPONSE.TEXT
        }
    }
}
