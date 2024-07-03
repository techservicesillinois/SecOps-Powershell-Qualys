<#
.Synopsis
    Download a saved Qualys report in the user’s account.
.DESCRIPTION
    Download a saved Qualys report in the user’s account.
.PARAMETER ID
    Specifies the report ID of a saved report that you want to download. The status of the report must be “finished”.
    IDs can be obtained from Get-QualysReports
.EXAMPLE
    Save-QualysReport -ID '36743223'
#>
function Save-QualysReport{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Parameter(Mandatory=$true)]
        [String]$ID
    )

    process{

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = 'report/'
            Body = @{
                action = 'fetch'
                echo_request = '1'
                id = $ID
            }
        }

        $Response = Invoke-QualysRestCall @RestSplat
        $Response
    }
}
