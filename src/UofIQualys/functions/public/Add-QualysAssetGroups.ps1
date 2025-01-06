<#
.Synopsis
    Adds an Asset Group to Qualys
.DESCRIPTION
    Adds an Asset Group to Qualys
.PARAMETER Title
    The Title of the Asset Group
.PARAMETER IPs
    Comma separated IP ranges to add to new asset group. Ex "128.174.118.0-128.174.118.255", "192.168.0.1/24"
.PARAMETER Comments
    Description or comments about the group; max 255 characters
.PARAMETER Division
    The Division of the Asset Group
.PARAMETER DefaultScanner
    The ID of the scanner to use as the default scanner for this asset group
.PARAMETER Scanners
    Comma separated IDs of the scanners to assign to the asset group. Ex "1578772,1578773"
.EXAMPLE
    Add-QualysAssetGroups -Title "My Asset Group"
.EXAMPLE
    Add-QualysAssetGroups -Title "My Asset Group" -IPs "192.168.0.1/24"
    #>
    function Add-QualysAssetGroups{
        [CmdletBinding()]
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
        param (
            [Parameter(Mandatory=$true)]
            [String]$Title,
            [String[]]$IPs,
            [String]$Comments,
            [String]$Division,
            [String]$DefaultScanner,
            [String]$Scanners
        )

        process{

            $RestSplat = @{
                Method = 'POST'
                RelativeURI = 'asset/group/'
                Body = @{
                    action = 'add'
                    echo_request = '1'
                    title = $Title
                }
            }

            If($IPs){
                $RestSplat.Body['ips'] = Format-IPAddressGroup -IPs $IPs
            }

            If($Comments){
                $RestSplat.Body['comments'] = $Comments
            }

            If($Division){
                $RestSplat.Body['division'] = $Division
            }

            If($DefaultScanner){
                $RestSplat.Body['appliance_ids'] = $DefaultScanner
                $RestSplat.Body['default_appliance_id'] = $DefaultScanner
            }

            If($Scanners){
                If($DefaultScanner){
                    $RestSplat.Body['appliance_ids'] += ",$($Scanners)"
                }
                Else{
                    $RestSplat.Body['appliance_ids'] = $Scanners
                }
            }

            $Response = Invoke-QualysRestCall @RestSplat
            if ($Response) {
                Write-Verbose -Message $Response.SIMPLE_RETURN.RESPONSE.TEXT
            }
        }
    }
