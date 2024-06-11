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
        .PARAMETER parentTagId
            The ID of the parent tag to be retrieved.
        .PARAMETER Credential
            The credential object to log into Qualys.
        .EXAMPLE
            Get-QualysTag -tagName "Department:IT"
            $tag = Get-QualysTag -tagName "Department:IT" -Credential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue)
            $tag.id # returns the tag ID
            $tag = Get-QualysTag -tagId "123456789" -Credential [PSCredential]::new("qapiuser", (Get-AzKeyVaultSecret -VaultName "MyAzKeyVault" -Name "qualys-password").SecretValue)
    #>
    [CmdletBinding(DefaultParameterSetName = 'name')]
    param (
        [Parameter(ParameterSetName = 'name', Mandatory = $true)]
        [string]
        $TagName,

        [Parameter(ParameterSetName = 'id', Mandatory = $true)]
        [Int32]
        $TagId,

        [Parameter(ParameterSetName = 'parent', Mandatory = $true)]
        [Int32]
        $ParentTagId,

        [Parameter(Mandatory = $true)]
        [pscredential]
        $Credential,

        [switch]
        $RetrieveParentTag,

        [switch]
        $RetrieveChildTags,

        [switch]
        $Recursive
    )

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

    # Use Invoke-QualysRestCall to make the API request
    $RestSplat = @{
        Method      = 'POST'
        RelativeURI = 'qps/rest/2.0/search/am/tag'
        Credential  = $Credential
        XmlBody     = $bodyTag
    }

    $ResponseContent = [xml](Invoke-QualysRestCall @RestSplat)

    if ($null -eq $responseContent.ServiceResponse.data.Tag) {
        return $null
    }

    $responseTags = New-Object System.Collections.Generic.List[QualysTag]

    foreach ($tag in $responseContent.ServiceResponse.data.Tag) {
        $responseTags.Add( [QualysTag]::new($tag) )
    }

    #pull parent tag and add to responseTag
    foreach ($responseTag in $responseTags) {

        if ( [string]::IsNullOrEmpty($responseTag.parentTagId) -eq $false -and $RetrieveParentTag ) {
            $params = @{
                TagId      = $responseTag.parentTagId
                Credential = $credential
            }
            if ($Recursive) {
                $params.Add("Recursive", $true)
                $params.Add("RetrieveParentTag", $true)
            }
            $responseTag.parentTag = Get-QualysTag @params
        }

        #pull child tags and add to responseTag
        if ( $RetrieveChildTags ) {
            $params = @{
                ParentTagId = $responseTag.id
                Credential  = $credential
            }
            if ($Recursive) {
                $params.Add("Recursive", $true)
                $params.Add("RetrieveChildTags", $true)
            }
            $resonseTag.childTags = Get-QualysTag @params
            # Don't add if there are no child tags
        }
    }

    # Restore progress preference
    $ProgressPreference = $origProgressPreference

    if ($responseTags.Count -eq 1) {
        return $responseTags[0]
    }

    return $responseTags

}
