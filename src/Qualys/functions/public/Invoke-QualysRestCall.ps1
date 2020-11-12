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
        [Parameter(Mandatory=$true)]
        [String]$Method,
        [Parameter(Mandatory=$true)]
        [hashtable]$Body,
        [System.Management.Automation.PSCredential]$Credential
    )

    begin {
        if($null -eq $Script:Session -and $null -eq $Credential){
            Write-Verbose -Message 'No Qualys session established. Please provide credentials.'
            New-QualysSession
        }
    }

    process {

        if ($RelativeURI.StartsWith('/')){
            $RelativeURI.Substring(1)
        }

        $IVRSplat = @{
            Headers = @{
                "X-Requested-With"="powershell"
            }
            Method = $Method
            URI = [string]::Empty
            Body = $Body
        }

        if($Credential){
            $IVRSplat['Uri'] = 'https://qualysapi.qg3.apps.qualys.com/msp/user.php'
            $BasicAuth = ('Basic {0}' -f ([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Credential.UserName,$Credential.GetNetworkCredential().Password)))))
            $IVRSplat['Headers'].add('Authorization',$BasicAuth)
        }
        else{
            $IVRSplat['Uri'] = "$($Script:Settings.BaseURI)$RelativeURI"
            $IVRSplat.add('WebSession',$Script:Session)
        }

        Invoke-RestMethod @IVRSplat
    }

    end {

    }
}
