function Get-QualysTag {
    <#
        .SYNOPSIS
            Gets a tag from Qualys.
        .DESCRIPTION
            This function takes a tag name or ID and returns the tag object.
        .PARAMETER tagName
            The name of the tag to be retrieved.
        .PARAMETER tagId
            The ID of the tag to be retrieved.
        .PARAMETER inputUsername
            The username to log into Qualys. By default, this is set to the global variable $username.
        .PARAMETER inputKeyvault
            The name of the keyvault where the Qualys password is stored. By default, this is set to the global variable $keyvault.
        .PARAMETER inputSecretName
            The name of the secret in the keyvault where the Qualys password is stored. By default, this is set to the global variable $secretName.
        .PARAMETER inputQualysApiUrl
            The URL of the Qualys API. By default, this is set to the global variable $qualysApiUrl.
        .EXAMPLE
            Get-QualysTag -tagName "Department:IT"
            $tag = Get-QualysTag -tagName "Department:IT" -inputUsername "admin" -inputKeyvault "MyAzKeyVault" -inputSecretName "qualys-password" -inputQualysApiUrl "https://qualysapi.qg2.apps.qualys.com"
            $tag.id # returns the tag ID
            $tag = Get-QualysTag -tagId "123456789" -inputUsername "admin" -inputKeyvault "MyAzKeyVault" -inputSecretName "qualys-password" -inputQualysApiUrl "https://qualysapi.qg3.apps.qualys.com"
        .NOTES
            Authors:
            - Carter Kindley

    #>
    [CmdletBinding(DefaultParameterSetName='name')]
    param (
        [Parameter(ParameterSetName='name', Mandatory=$true)]
        [string]
        $TagName,

        [Parameter(ParameterSetName='id', Mandatory=$true)]
        [string]
        $TagId,

        [string]
        $InputUsername = $Username,
        [string]
        $InputKeyVault = $KeyVault,
        [string]
        $InputSecretName = $SecretName,
        [string]
        $InputQualysApiUrl = $QualysApiUrl
    )

    # If any of the non-mandatory parameters are not provided, return error and state which ones are empty
    if ([string]::IsNullOrEmpty($inputUsername) -or [string]::IsNullOrEmpty($inputKeyvault) -or [string]::IsNullOrEmpty($inputSecretName) -or [string]::IsNullOrEmpty($inputQualysApiUrl)) {
        return "One or more of the following parameters are empty: inputUsername, inputKeyVault, inputSecretName, inputQualysApiUrl.
        By default, these parameters are set to the values of the global variables: username, keyVault, secretName, qualysApiUrl.
        Please ensure these global variables are set, or provide the inputs, and try again."
    }

# Create a hashtable that maps parameter set names to parameter values
$parameterMap = @{
    'name' = $TagName
    'id' = $TagId
}

# Get the value for the current parameter set
$parameterValue = $parameterMap[$PSCmdlet.ParameterSetName]

# Build bodyTag, filtering on either tagName or tagId, depending on which was provided
$bodyTag = "<ServiceRequest>
    <filters>
        <Criteria field=""$($PSCmdlet.ParameterSetName)"" operator=""EQUALS"">$parameterValue</Criteria>
    </filters>
</ServiceRequest>"

    Write-Verbose "Making API request for tag."

    # Store progress preference and set to SilentlyContinue
    $origProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    $responseContent = [xml](Invoke-WebRequest -UseBasicParsing -Uri "$inputQualysApiUrl/qps/rest/2.0/search/am/tag" -ErrorAction Continue -Method Post -Headers @{
        "Authorization" = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$inputUsername`:$(([PSCredential]::new('admin', ((Get-AzKeyVaultSecret -VaultName $inputKeyvault -Name "$inputSecretName").SecretValue)).GetNetworkCredential().Password))")))"
        "Content-Type"  = "application/xml"
        "Accept"        = "application/xml"
    } -Body $bodyTag).Content

    if ($null -eq $responseContent.ServiceResponse.data.Tag) {
        return $null
    }

    $responseTag = [QualysTag]::new($responseContent.ServiceResponse.data.Tag)

    # Restore progress preference
    $ProgressPreference = $origProgressPreference

    # Stash non-secret connection info in new object
    $responseTag.username = $inputUsername
    $responseTag.keyvault = $inputKeyvault
    $responseTag.qualysApiUrl = $inputQualysApiUrl
    $responseTag.secretName = $inputSecretName

    return $responseTag

}
