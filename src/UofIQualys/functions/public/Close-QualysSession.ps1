<#
.Synopsis
   This function closes the Qualys user session created by New-QualysSession.
.DESCRIPTION
   This function closes the Qualys user session created by New-QualysSession.
.EXAMPLE
    Close-QualysSession
#>
function Close-QualysSession{
    process{
        $IVRSplat = @{
            Headers = @{
                "X-Requested-With"="powershell"
            }
            Method = 'POST'
            URI = "$($Script:Settings.BaseURI)session/"
            Body = @{
                action = "logout"
            }
            WebSession = $Script:Session
        }

        Write-Verbose -Message "Removing Qualys web session."
        $Response = Invoke-RestMethod @IVRSplat
        $Response.SIMPLE_RETURN.RESPONSE.TEXT
    }
}
