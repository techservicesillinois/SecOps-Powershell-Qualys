<#
.Synopsis
    Adds a new user to Qualys
.DESCRIPTION
    Adds a new user to Qualys
.PARAMETER Credential
    This API call only supports basic HTTP authentication. You must provide your credentials separately for this function.
.PARAMETER ExternalID
    Set a custom External ID (required for SSO)
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
        City = 'Urbana'
        Country = 'United States of America'
        State = 'Illinois'
        Role = 'scanner'
        FirstName = 'Jane'
        LastName = 'Doe'
        Title = 'Test User'
        Email = 'JaneDoe@test.null'
        Credential = $Credential
    }
    Add-QualysUser @NewUserSplat
#>
function Add-QualysUser{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSCredential]$Credential,
        [Switch]$SendEmail,
        [Parameter(Mandatory=$true)]
        [Alias('user_role')]
        [String]$Role,
        [Alias('business_unit')]
        [String]$BusinessUnit = 'Unassigned',
        [String[]]$AssetGroups,
        [Parameter(Mandatory=$true)]
        [Alias('first_name')]
        [String]$FirstName,
        [Parameter(Mandatory=$true)]
        [Alias('last_name')]
        [String]$LastName,
        [Parameter(Mandatory=$true)]
        [String]$Title,
        [Parameter(Mandatory=$true)]
        [String]$Email,
        [Parameter(Mandatory=$true)]
        [String]$Phone,
        [Parameter(Mandatory=$true)]
        [Alias('address1')]
        [String]$Address,
        [Parameter(Mandatory=$true)]
        [String]$City,
        [Parameter(Mandatory=$true)]
        [String]$Country,
        [String]$State,
        [Alias('external_id')]
        [String]$ExternalID

    )

    process{

        $RestSplat = @{
            Method = 'POST'
            RelativeURI = 'msp/user.php'
            Credential = $Credential
            Body = @{
                action = 'add'
                business_unit = $BusinessUnit
                send_email = [string][int]$SendEmail.IsPresent
            }
        }

        #Takes any parameter that's set, except excluded ones, and adds one of the same name (or alias name if present) to the API body
        [String[]]$Exclusions = ('Credential', 'AssetGroups', 'SendEmail', 'BusinessUnit', 'Verbose')
        $PSBoundParameters.Keys | Where-Object -FilterScript {($_ -notin $Exclusions) -and $_} | ForEach-Object -Process {
            if($MyInvocation.MyCommand.Parameters[$_].Aliases[0]){
                [String]$APIKeyNames = $MyInvocation.MyCommand.Parameters[$_].Aliases[0]
                $RestSplat.Body.$APIKeyNames = $PSBoundParameters[$_]
            }
            else {
                $RestSplat.Body.$_ = $PSBoundParameters[$_]
            }
        }

        If($AssetGroups){
            $RestSplat.Body['asset_groups'] = (($AssetGroups).Trim() -join ",")
        }

        $Response = Invoke-QualysRestCall @RestSplat
        if ($Response.USER_OUTPUT.RETURN.status -ne 'FAILED') {
            Write-Verbose -Message $Response
        }
        else {
            Write-Error -Exception $Response.USER_OUTPUT.RETURN.MESSAGE.'#cdata-section'
        }
    }
}
