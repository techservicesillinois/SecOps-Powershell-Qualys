<#
.Synopsis
    Adds a new user to Qualys
.DESCRIPTION
    Adds a new user to Qualys
.PARAMETER Credential
    This API call only supports basic HTTP authentication. You must provide your credentials separately for this function.
.PARAMETER Login
    Specifies the Qualys user login of the user account you wish to edit.
.PARAMETER ExternalID
    Set a custom External ID (required for SSO)
.PARAMETER AssetGroups
    Specifies the asset groups assigned to the user, when theuser role is Scanner, Reader or Contact.
.PARAMETER FirstName
    Specifies the user's first name.
.PARAMETER LastName
    Specifies the user's last name
.PARAMETER Title
    Specifies the user's job title.
.PARAMETER Email
    Specifies the user's email address.
.PARAMETER Phone
    Specifies the user’s phone number.
.PARAMETER Address
    Specifies the user’s address.
.PARAMETER City
    Specifies the user’s city.
.PARAMETER Country
    Specifies the user’s country.
.PARAMETER State
    Specifies the user’s state.
.EXAMPLE
    Set-QualysUser -Credential $Credential -Login testuser -AssetGroups TestGroup
.EXAMPLE
    $SetUserSplat = @{
        Login = testuser
        Phone = '555-555-555'
        Address = 'University of Illinois'
        city = 'Urbana'
        country = 'United States of America'
        state = 'Illinois'
        FirstName = 'Jane'
        LastName = 'Doe'
        Title = 'Test User'
        email = 'JaneDoe@test.null'
        Credential = $Credential
    }
    Set-QualysUser @SetUserSplat
#>
function Set-QualysUser{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]$Login,
        [String[]]$AssetGroups,
        [String]$FirstName,
        [String]$LastName,
        [String]$Title,
        [String]$Email,
        [String]$Phone,
        [String]$Address,
        [String]$City,
        [String]$Country,
        [String]$State,
        [String]$ExternalID,
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential
    )

    process{



        $RestSplat = @{
            Method = 'POST'
            RelativeURI = 'msp/user.php'
            Credential = $Credential
            Body = @{
                action = 'edit'
            }
        }

        [String[]]$Exclusions = ('Credential', 'AssetGroups')
        $PSBoundParameters.Keys | Where-Object -FilterScript {($_ -notin $Exclusions) -and $_} | ForEach-Object -Process {
            $RestSplat.Body.$_ = $PSBoundParameters[$_]
        }

        If($AssetGroups){
            $RestSplat.Body['asset_groups'] = (($AssetGroups).Trim() -join ",")
        }

        $Response = Invoke-QualysRestCall @RestSplat
        $Response.USER_OUTPUT.RETURN.MESSAGE

    }
}
