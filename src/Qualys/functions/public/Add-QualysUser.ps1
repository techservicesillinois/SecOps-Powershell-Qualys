<#
.Synopsis
    Adds a new user to Qualys
.DESCRIPTION
    Adds a new user to Qualys
.PARAMETER Credential
    This API call only supports basic HTTP authentication. You must provide your credentials separately for this function.
.PARAMETER SendEmail
    Specifies whether the new user will receive an email notification with a secure link to their login credentials.
.PARAMETER Role
    Specifies the user role. A valid value is: manager, unit_manager, scanner, reader, contact or administrator.
.PARAMETER BusinessUnit
    Specifies the user’s business unit.
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
    $NewUserSplat = @{
        Phone = '555-555-555'
        Address = 'University of Illinois'
        city = 'Urbana'
        country = 'United States of America'
        state = 'Illinois'
        Role = 'scanner'
        FirstName = 'Jane'
        LastName = 'Doe'
        Title = 'Test User'
        email = 'JaneDoe@test.null'
        Credential = $Credential
    }
    Add-QualysUser @NewUserSplat
#>
function Add-QualysUser{
    [CmdletBinding()]
    param (
        [Switch]$SendEmail,
        [Parameter(Mandatory=$true)]
        [String]$Role,
        [String]$BusinessUnit,
        [String[]]$AssetGroups,
        [Parameter(Mandatory=$true)]
        [String]$FirstName,
        [Parameter(Mandatory=$true)]
        [String]$LastName,
        [Parameter(Mandatory=$true)]
        [String]$Title,
        [Parameter(Mandatory=$true)]
        [String]$Email,
        [Parameter(Mandatory=$true)]
        [String]$Phone,
        [Parameter(Mandatory=$true)]
        [String]$Address,
        [Parameter(Mandatory=$true)]
        [String]$City,
        [Parameter(Mandatory=$true)]
        [String]$Country,
        [String]$State,
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential
    )

    process{

        $Authorization = $Credential

        $RestSplat = @{
            Headers = @{
                "X-Requested-With"="powershell"
                "Authorization"= ('Basic {0}' -f ([Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Authorization.UserName,$Authorization.GetNetworkCredential().Password)))))
            }
            Method = 'POST'
            URI = 'https://qualysapi.qg3.apps.qualys.com/msp/user.php'
            Body = @{
                action = 'add'
                send_email = '0'
                business_unit = 'Unassigned'
                user_role = $Role
                first_name = $FirstName
                last_name = $LastName
                title = $Title
                phone = $Phone
                email = $Email
                address1 = $Address
                city = $City
                country = $Country
                state = $State
            }
        }

        If($SendEmail){
            $RestSplat.Body['send_email'] = '1'
        }

        If($BusinessUnit){
            $RestSplat.Body['business_unit'] = $BusinessUnit
        }

        If($AssetGroups){
            $RestSplat.Body['asset_groups'] = (($AssetGroups).Trim() -join ", ")
        }

        $Response = Invoke-RestMethod @RestSplat
        $Response.USER_OUTPUT.RETURN.MESSAGE

    }
}
