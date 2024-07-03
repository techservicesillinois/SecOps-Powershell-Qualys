<#
.Synopsis
    List reports in the user’s account. By default the output lists all reports.
.DESCRIPTION
    List reports in the user’s account.
.PARAMETER ID
    Specifies a report ID of a saved report. When specified, only information on the selected report will be included.
.PARAMETER State
    Specifies that reports with a certain state will be included in the output. By default, all states are included.
    A valid value is: Running, Finished, Submitted, Canceled, or Errors.
.PARAMETER UserLogin
    This parameter is used to restrict the output to reports launched by the specified user login ID.
.EXAMPLE
    Get-QualysReports
    Get-QualysReports -ID '36775225'
    Get-QualysReports -State 'Finished'
    Get-QualysReports -User 'theun_jd9'
#>
function Get-QualysReports{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [String]$ID,
        [String]$State,
        [Alias('user_login')]
        [String]$UserLogin
    )

    process{

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = 'report/'
            Body = @{
                action = 'list'
                echo_request = '1'
            }
        }

        #Takes any parameter that's set, except excluded ones, and adds one of the same name (or alias name if present) to the API body
        $PSBoundParameters.Keys | Where-Object -FilterScript {($_ -notin $Exclusions) -and $_} | ForEach-Object -Process {
            $Param = $_.ToLower()
            if($MyInvocation.MyCommand.Parameters[$Param].Aliases[0]){
                [String]$APIKeyNames = $MyInvocation.MyCommand.Parameters[$Param].Aliases[0]
                $RestSplat.Body.$APIKeyNames = $PSBoundParameters[$Param]
            }
            else {
                $RestSplat.Body.$_ = $PSBoundParameters[$Param]
            }
        }

        $Response = Invoke-QualysRestCall @RestSplat
        $Response.REPORT_LIST_OUTPUT.RESPONSE.REPORT_LIST.REPORT
    }
}
