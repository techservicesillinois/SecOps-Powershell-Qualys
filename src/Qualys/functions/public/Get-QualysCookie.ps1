<#
.Synopsis
   Returns a Cookie to use as the SessionVariable in Qualys REST invocations
.DESCRIPTION
   Returns a Cookie to use as the SessionVariable in Qualys REST invocations
.PARAMETER Credential
    Credentials used to authenticate to Qualys
.EXAMPLE
    $Credential = Get-Credential
    $Cookie = Get-QualysCookie -Credential $Credential
#>
function Get-QualysCookie{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Credential
    )

    process{
        $IVRSplat = @{
            Headers = @{
                "X-Requested-With"="powershell"
            }
            Method = 'POST'
            URI = "$($Script:Settings.BaseURI)session/"
            Body = @{
                action = "login"
                username = $Credential.UserName
                password = $Credential.GetNetworkCredential().Password
            }
            SessionVariable = 'Cookie'
        }

        Write-Verbose -Message "Generating Qualys API cookie for $($Credential.UserName)"
        $Response = Invoke-RestMethod @IVRSplat
        if( $Response.SIMPLE_RETURN.RESPONSE.TEXT -eq 'Logged in' ){
            $Cookie
        }
        else{
            Throw $Response.SIMPLE_RETURN.RESPONSE.TEXT
        }
    }
}