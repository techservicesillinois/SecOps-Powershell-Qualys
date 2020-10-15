<#
.Synopsis
    Makes a REST method call on the given relative URI for Qualys. Utilizes credentials created with New-QualysSession.
.DESCRIPTION
    Makes a REST method call on the given relative URI for Qualys. Utilizes credentials created with New-QualysSession.
.PARAMETER RelativeURI
    The relativeURI you wish to make a call to. Ex: asset/ip/
.PARAMETER Method
    Method of the REST call Ex: GET
.PARAMETER Body
    Body of the REST call as a hashtable
.EXAMPLE
   $Body = @{
                action = 'list'
                echo_request = '1'
            }
    Invoke-QualysRestCall -RelativeURI asset/ip/ -Method GET -Body $Body
    This will return an array of all host assets (IPs) in Qualys
#>
function Invoke-QualysRestCall {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]$RelativeURI,
        [String]$Method,
        [hashtable]$Body

    )

    begin {
        if($null -eq $Script:Session){
            Write-Verbose -Message 'No Qualys session established. Please provide credentials.'
            New-QualysSession
        }
    }

    process {

        $IVRSplat = @{
            Headers = @{
                "X-Requested-With"="powershell"
            }
            Method = $Method
            URI = "$($Script:Settings.BaseURI)$RelativeURI"
            Body = $Body
            WebSession = $Script:Session
        }
        Invoke-RestMethod @IVRSplat
    }

    end {

    }
}
