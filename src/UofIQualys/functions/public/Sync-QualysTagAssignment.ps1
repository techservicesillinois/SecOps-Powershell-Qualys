function Sync-QualysTagAssignment {
    <#
        .SYNOPSIS
            Synchronize tags from an external source of truth to Qualys.
        .DESCRIPTION
            This function synchronizes tags from an external source of truth to Qualys.
        .PARAMETER InputAsset
            The QualysAsset object to synchronize tags for.
        .PARAMETER Credential
            The PSCredential object to use for authentication.
        .PARAMETER CategoryDefinitions
            A hashtable of category definitions of external tags. The key is the category name and the value is the list of possible tag names in the category.
        .EXAMPLE
            Sync-QualysTagAssignment -InputAsset $InputAsset -Credential $credential$QualysApiUrl -CategoryDefinitions $CategoryDefinitions
    #>
    [OutputType('System.Collections.Hashtable')]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (

        [Parameter(ValueFromPipeline, Mandatory = $true)]
        [QualysAsset]
        $InputAsset,

        [Parameter(Mandatory = $true)]
        [pscredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [hashtable]
        $CategoryDefinitions

    )

    begin {
        # Initialize variables
        $Tags = @{}

        # Initialize response object
        $Responses = @{
            Removed  = New-Object 'System.Collections.ArrayList'
            Added    = New-Object 'System.Collections.ArrayList'
            Existing = New-Object 'System.Collections.ArrayList'
            Issues   = New-Object 'System.Collections.ArrayList'
            Caching  = New-Object 'System.Collections.ArrayList'
        }
    }

    process {
        try {
            # Downselect assetTags from $Tags to only those that are in the InputAsset's tags (from Qualys) array
            # [hashtable](QualysTagID:QualysTag)
            $AssetTags = @{}
            $InputAsset.tags | ForEach-Object {
                $TagID = $_.id
                if ($Tags.ContainsKey($TagID)) {
                    # If the tag is already in the cache, add it to the assetTags hashtable
                    $assetTags.Add($TagID, $Tags[$TagID])
                }
                else {
                    # If the tag is not in the cache, retrieve it from Qualys and add it to the cache
                    $Tag = Get-QualysTag -TagId $TagID -Credential $Credential -RetrieveParentTag
                    if ($null -eq $Tag) {
                        # If the tag is not found in Qualys, add it to the Issues array
                        $responses.Issues.Add($(New-Object PSObject -Property @{
                                    TagName   = "$($_.name)"
                                    AssetName = $inputAsset.name
                                    Message   = 'NotFound'
                                })) | Out-Null
                        continue
                    }
                    else {
                        # If the tag is found in Qualys, add it to the cache and the assetTags hashtable
                        $Tags.Add($Tag.id, $Tag) | Out-Null
                        $assetTags.Add($Tag.ID, $Tag)
                        $responses.Caching.Add($(New-Object PSObject -Property @{
                                    TagName   = "$($Tag.name)"
                                    AssetName = $inputAsset.name
                                    Message   = 'Cached'
                                })) | Out-Null
                    }
                }
            }

            $InputAsset.vtags | ForEach-Object {
                $vtag = $_
                if ($CategoryDefinitions.ContainsKey($vtag.Category)) {
                    $category = $vtag.Category
                    # Set QualysTag to the Qualys tag corresponding to the external vtag
                    $QualysTag = $null
                    $QualysTag = $($Tags.GetEnumerator() | Where-Object { $_.Value.name -eq "$($InputAsset.prefix)$($vtag.TagName)" }).Value
                    if ($null -eq $QualysTag) {
                        $QualysTag = Get-QualysTag -TagName "$($InputAsset.prefix)$($vtag.TagName)" -Credential $credential -RetrieveParentTag
                        if ($null -eq $QualysTag) {
                            $responses.Issues.Add($(New-Object PSObject -Property @{
                                        TagName   = "$($InputAsset.prefix)$($vtag.TagName)"
                                        AssetName = $inputAsset.name
                                        Message   = 'NotFound'
                                    })) | Out-Null
                                    return
                        }
                        else {
                            $Tags.Add($QualysTag.id, $QualysTag) | Out-Null
                            $responses.Caching.Add($(New-Object PSObject -Property @{
                                        TagName   = "$($QualysTag.name)"
                                        AssetName = $inputAsset.name
                                        Message   = 'Cached'
                                    })) | Out-Null
                        }
                    }
                    # if ($assetTags.Keys -notcontains $QualysTag.id) {
                    #     $assetTags.Add($QualysTag.id, $QualysTag)
                    # }
                    # may need slightly more sophisticated matching
                    [QualysTag[]]$TagsOfCategory = $assetTags.Values | Where-Object { $_.parentTag.name -match "$($InputAsset.prefix)$($category)" }
                    if ($TagsOfCategory.Count -eq 0) {
                        # We need to assign the tag to the asset
                        $InputAsset.AssignTag($QualysTag, $credential)
                        $responses.Added.Add($(New-Object PSObject -Property @{
                                    TagName   = "$($QualysTag.name)"
                                    AssetName = $inputAsset.name
                                    Message   = 'Added'
                                })) | Out-Null
                    }
                    else {
                        # more than one tag of category $category exists on InputAsset - need to remove incorrect tags
                        $TagsOfCategory | ForEach-Object {
                            if ($_.id -ne $QualysTag.id) {
                                $InputAsset.UnassignTag($_, $credential)
                                $responses.Removed.Add($(New-Object PSObject -Property @{
                                            TagName   = "$($_.name)"
                                            AssetName = $inputAsset.name
                                            Message   = 'Removed'
                                        })) | Out-Null
                            }
                        }
                        if (-not $TagsOfCategory.Contains($QualysTag)) {
                            $InputAsset.AssignTag($QualysTag, $credential)
                            $responses.Added.Add($(New-Object PSObject -Property @{
                                        TagName   = "$($QualysTag.name)"
                                        AssetName = $inputAsset.name
                                        Message   = 'Added'
                                    })) | Out-Null
                        }
                        else {
                            $responses.Existing.Add($(New-Object PSObject -Property @{
                                        TagName   = "$($QualysTag.name)"
                                        AssetName = $inputAsset.name
                                        Message   = 'Exists'
                                    })) | Out-Null
                        }
                    }
                }
            }

            $missingCategories = $CategoryDefinitions.Keys | Where-Object { $_ -notin $InputAsset.vtags.Category }
            $missingCategories | ForEach-Object {
                $responses.Issues.Add($(New-Object PSObject -Property @{
                            TagName   = "$_"
                            AssetName = $inputAsset.name
                            Message   = 'MissingCategoryTag'
                        })) | Out-Null }
        }
        catch {
            try{
            $responses.Issues.Add($(New-Object PSObject -Property @{
                        TagName   = "$($InputAsset.prefix)$($vtag.TagName)"
                        AssetName = $inputAsset.name
                        Message   = "Error: $_"
                    })) | Out-Null
                } catch { Write-Output "Something really broke. Continuing."}
        }
    }

    end {
        return $responses
    }

}
