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
        .PARAMETER inputCredential
            The credential object to log into Qualys. By default, this is set to the global variable $Credential.
        .PARAMETER inputQualysApiUrl
            The URL of the Qualys API. By default, this is set to the global variable $qualysApiUrl.
        .EXAMPLE
            Get-QualysTag -tagName "Department:IT"
            $tag = Get-QualysTag -tagName "Department:IT" -inputCredential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue) -inputQualysApiUrl "https://qualysapi.qg2.apps.qualys.com"
            $tag.id # returns the tag ID
            $tag = Get-QualysTag -tagId "123456789" -inputCredential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue) -inputQualysApiUrl "https://qualysapi.qg3.apps.qualys.com"
        .NOTES
            Authors:
            - Carter Kindley

    #>
    [CmdletBinding(DefaultParameterSetName = 'name')]
    param (
        [Parameter(ParameterSetName = 'name', Mandatory = $true)]
        [string]
        $TagName,

        [Parameter(ParameterSetName = 'id', Mandatory = $true)]
        [string]
        $TagId,

        [Parameter(ParameterSetName = 'parent', Mandatory = $true)]
        [string]
        $ParentTagId,

        [pscredential]
        $InputCredential = $Credential,

        [string]
        $InputQualysApiUrl = $QualysApiUrl,

        [switch]
        $RetrieveParentTag,

        [switch]
        $RetrieveChildTags,

        [switch]
        $Recursive
    )

    # If any of the non-mandatory parameters are not provided, return error and state which ones are empty
    if ([string]::IsNullOrEmpty($inputQualysApiUrl) -or [string]::IsNullOrEmpty($InputCredential.UserName) -or [string]::IsNullOrEmpty($InputCredential.GetNetworkCredential().Password)) {
        return "One or more of the following parameters are empty: inputCredential, inputQualysApiUrl.
        By default, these parameters are set to the values of the global variables: username, keyVault, secretName, qualysApiUrl.
        Please ensure these global variables are set, or provide the inputs, and try again."
    }

    # Create a hashtable that maps parameter set names to parameter values
    $parameterMap = @{
        'name'   = $TagName
        'id'     = $TagId
        'parent' = $ParentTagId
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
            "Authorization" = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($InputCredential.UserName)`:$($InputCredential.GetNetworkCredential().Password)")))"
            "Content-Type"  = "application/xml"
            "Accept"        = "application/xml"
        } -Body $bodyTag).Content

    if ($null -eq $responseContent.ServiceResponse.data.Tag) {
        return $null
    }

    $responseTags = New-Object System.Collections.Generic.List[QualysTag]

    foreach ($tag in $responseContent.ServiceResponse.data.Tag) {
        $responseTags.Add( [QualysTag]::new($tag) )
    }

    #pull parent tag and add to responseTag
    foreach ($responseTag in $responseTags) {

        if ( [string]::IsNullOrEmpty($responseTags[0].parentTagId) -eq $false -and $RetrieveParentTag ) {
            $params = @{
                TagId             = $responseTags[0].parentTagId
                InputCredential   = $InputCredential
                InputQualysApiUrl = $InputQualysApiUrl
            }
            if ($Recursive) {
                $params.Add("Recursive", $true)
                $params.Add("RetrieveParentTag", $true)
            }
            $ParentTag = Get-QualysTag @params
            foreach ($responseTag in $responseTags) {
                $responseTag.parentTag = $ParentTag
            }
        }

        #pull child tags and add to responseTag
        if ( $RetrieveChildTags ) {
            $params = @{
                ParentTagId       = $responseTags[0].id
                InputCredential   = $InputCredential
                InputQualysApiUrl = $InputQualysApiUrl
            }
            if ($Recursive) {
                $params.Add("Recursive", $true)
                $params.Add("RetrieveChildTags", $true)
            }
            $childTags = Get-QualysTag @params
            # Don't add if there are no child tags
            if ($null -ne $childTags) {
                foreach ($childTag in $childTags) {
                    $childTag.parentTag = $responseTag
                    $responseTag.childTags.Add($childTag)
                }
            }
        }
    }

    # Restore progress preference
    $ProgressPreference = $origProgressPreference

    # Stash non-secret connection info in new object
    foreach ($responseTag in $responseTags) {
        $responseTag.qualysApiUrl = $InputQualysApiUrl
    }

    if ($responseTags.Count -eq 1) {
        return $responseTags[0]
    }

    return $responseTags

}
