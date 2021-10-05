<#
.Synopsis
    Launch vulnerability scan in the user’s account. Only targeting asset groups is supported currently. Support for targeting by IPs to be added later.
.DESCRIPTION
    Launch vulnerability scan in the user’s account. Only targeting asset groups is supported currently. Support for targeting by IPs to be added later.
.PARAMETER Title (scan_title)
    The scan title
.PARAMETER IPs
    The IP addresses to be scanned. You may enter individual IP addresses and/or ranges. Multiple entries are comma separated
.PARAMETER AssetGroups
    The titles or ids of asset groups containing the hosts to be scanned. Multiple titles are comma separated
    Use only IDs or titles, do not mix and match.
.PARAMETER ExcludeIPs (exclude_ip_per_scan)
    The IP addresses to be excluded from the scan when the scan target is specified as IP addresses
.PARAMETER Scanners
    The IDs or friendly names of the scanner appliances to be used or “External” for external scanners. Multiple entries are comma separated.
    Use only IDs or friendly names, do not mix and match
.PARAMETER DefaultScanners
    Specify to use the default scanner in each target asset group
.PARAMETER Priority
     Specify a value of 0 - 9 to set a processing priority level for the scan
.PARAMETER OptionPorfile
    The ID or title of the option profile to be used
.PARAMETER FQDN
    The target FQDN for a vulnerability scan. Multiple values are comma separated.
    You can specify FQDNs in combination with IPs and asset groups
.EXAMPLE
    Start-QualysScan -Title 'Test Scan' -AssetGroups 'Test Asset Group'
#>
function Start-QualysScan{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Alias('scan_title')]
        [String]$Title,
        [String[]]$IPs,
        [String[]]$AssetGroups,
        [String[]]$ExcludeIPs,
        [String]$Scanners,
        [Switch]$DefaultScanners,
        [ValidateRange(0,9)]
        [Int]$Priority = 0,
        [String]$OptionProfile,
        [String[]]$FQDN
    )

    process{
        If($AssetGroups){
            $Target = $AssetGroups
        }
        Else{
            $Target = $IPs
        }
        if ($PSCmdlet.ShouldProcess("$($Target)")){
            $RestSplat = @{
                Method = 'POST'
                RelativeURI = 'scan/'
                Body = @{
                    action = 'launch'
                    echo_request = '1'
                    default_scanner = [string][int]$DefaultScanners.IsPresent
                    target_from = 'assets'
                }
            }

            If($IPs){
                $RestSplat.Body['ip'] = (($IPs).Trim() -join ",")
            }

            If($ExcludeIPs){
                $RestSplat.Body['exclude_ip_per_scan'] = (($ExcludeIPs).Trim() -join ",")
            }

            If($FQDN){
                $RestSplat.Body['fqdn'] = (($FQDN).Trim() -join ",")
            }

            If($Scanners){
                If($Scanners -match '\D'){
                    $RestSplat.Body['iscanner_name'] = $Scanners
                }
                Else{
                    $RestSplat.Body['iscanner_id'] = $Scanners
                }
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

            #Takes any parameter that's set, except excluded ones, and adds one of the same name (or alias name if present) to the API body
            [String[]]$Exclusions = ('IPs','DefaultScanners', 'AssetGroups', 'OptionProfile', 'Scanners', 'FQDN', 'Verbose')
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
                Write-Verbose -Message $Response
            }
        }
    }
}
