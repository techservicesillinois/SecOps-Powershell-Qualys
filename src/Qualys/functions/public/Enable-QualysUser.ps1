<#
.Synopsis
    Activates a user in Qualys
.DESCRIPTION
    Activates a user in Qualys
.PARAMETER Credential
    This API call only supports basic HTTP authentication. You must provide your credentials separately for this function.
.PARAMETER Login
    The login of the Qualys user account you wish to activate
.EXAMPLE
    Enable-QualysUser -Credential $Credential -Login "theun_tu0"
    #>
    function Enable-QualysUser{
        [CmdletBinding(SupportsShouldProcess)]
        param (
            [Parameter(Mandatory=$true)]
            [System.Management.Automation.PSCredential]$Credential,
            [Parameter(Mandatory=$true)]
            [String]$Login
        )

        process{
            if ($PSCmdlet.ShouldProcess($Login)){
                $RestSplat = @{
                    Method = 'POST'
                    RelativeURI = 'msp/user.php'
                    Credential = $Credential
                    Body = @{
                        action = 'activate'
                        login = $Login
                    }
                }

                $Response = Invoke-QualysRestCall @RestSplat
                if ($Response) {
                    Write-Verbose -Message $Response.USER_OUTPUT.RETURN.MESSAGE
                }
            }
        }
    }
