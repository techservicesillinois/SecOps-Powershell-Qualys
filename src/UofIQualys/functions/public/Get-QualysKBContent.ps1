<#
.Synopsis
    Returns KB information for a specified QID
.DESCRIPTION
    Returns KB information for a specified QID
.EXAMPLE
    Get-QualysKBContent -QID '372305'
    #>
function Get-QualysKBContent{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Parameter(Mandatory=$true)]
        [String]$QID
    )

    process{

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = 'knowledge_base/vuln/'
            Body = @{
                action = 'list'
                echo_request = '1'
                ids = $QID
            }
        }

        $Response = Invoke-QualysRestCall @RestSplat
        $VulnInfo = $Response.KNOWLEDGE_BASE_VULN_LIST_OUTPUT.RESPONSE.VULN_LIST.VULN
        $VulnInfo

    }
}
