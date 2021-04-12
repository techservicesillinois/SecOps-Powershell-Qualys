<#
.Synopsis
    Edit a VM scan schedule
.DESCRIPTION
    Edit a VM scan schedule
.PARAMETER Identity
    The ID of the scan schedule to edit
.PARAMETER Title
    The title of the scan schedule
.PARAMETER Status
    Specify 0 to deactivate the scan schedule, 1 to activate the scan schedule
.PARAMETER OptionProfile
    The id or title of the option profile to use
.PARAMETER AssetGroups
    The titles or ids of asset groups containing the hosts to be scanned. Multiple titles are comma separated
    Use only IDs or titles, do not mix and match.
.PARAMETER Scanners
    The IDs or friendly names of the scanner appliances to be used or “External” for external scanners. Multiple entries are comma separated.
    Use only IDs or friendly names, do not mix and match
.PARAMETER Priority
    Specify a value of 0 - 9 to set a processing priority level for the scan
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
    The hour when the scan will start. The hour is an integer from 0 - 23, where 0 represents 12AM, 7 represents 7AM, and 22 represents 10PM
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
    Set-QualysScanSchedule -Title 'Test Schedule' -AssetGroups 'My Asset Group' -DefaultScanners -Daily 20 -StartDate "03/01/2021" -StartHour 0 -StartMinute 0 -EndAfterHours 0 -EndAfterMins 20 -OptionProfile 'Recommended Standard Scan'
#>
function Set-QualysScanSchedule{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [String]$Identity,
        [Alias('scan_title')]
        [String]$Title,
        [ValidateRange(0,1)]
        [Alias('active')]
        [Int]$Status,
        [String]$OptionProfile,
        [String[]]$AssetGroups,
        [String]$Scanners,
        [ValidateRange(0,9)]
        [Int]$Priority = 0,
        [ValidateRange(1,365)]
        [Int]$Daily,
        [ValidateRange(1,52)]
        [Int]$Weekly,
        [String]$Weekdays = 'sunday, monday, tuesday, wednesday, thursday, friday, saturday',
        [Alias('start_date')]
        [DateTime]$StartDate,
        [ValidateRange(0,23)]
        [Alias('start_hour')]
        [Int]$StartHour,
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
        if ($PSCmdlet.ShouldProcess("$($Identity)")){
            $RestSplat = @{
                Method = 'POST'
                RelativeURI = 'schedule/scan/'
                Body = @{
                    action = 'update'
                    echo_request = '1'
                    id = $Identity
                }
            }

            if($StartDate){
                $RestSplat.Body['observe_dst'] = 'yes'
                $RestSplat.Body['time_zone_code'] = 'US-IL'
                $RestSplat.Body['set_start_time'] = 1
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
                'OptionProfile', 'Scanners', 'FQDN', 'StartDate','Identity','Verbose'
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
}
