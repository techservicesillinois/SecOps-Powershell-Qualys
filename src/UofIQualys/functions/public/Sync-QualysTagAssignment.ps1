function Sync-QualysTagAssignment {
    <#
        .SYNOPSIS
            Synchronize tags from an external source of truth to Qualys.
        .DESCRIPTION
            This function synchronizes tags from an external source of truth to Qualys.
        .PARAMETER InputAsset
            The QualysAsset object to synchronize tags for.
        .PARAMETER InputCredential
            The PSCredential object to use for authentication.
        .PARAMETER InputQualysApiUrl
            The URL of the Qualys API.
        .PARAMETER CategoryDefinitions
            A hashtable of category definitions of external tags. The key is the category name and the value is the list of possible tag names in the category.
        .EXAMPLE
            Sync-QualysTagAssignment -InputAsset $InputAsset -InputCredential $credential -InputQualysApiUrl $QualysApiUrl -CategoryDefinitions $CategoryDefinitions
        .NOTES
            Authors:
            - Carter Kindley
            - Jack Nemitz

    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (

        [Parameter(ValueFromPipeline, Mandatory = $true)]
        [QualysAsset]
        $InputAsset,

        [pscredential]
        $InputCredential = $Credential,

        [string]
        $InputQualysApiUrl = $QualysApiUrl,

        [hashtable]
        $CategoryDefinitions

    )

    begin {
        # Initialize variables
        $tags = @{}

        # Initialize response object
        $responses = @{
            Removed  = New-Object 'System.Collections.ArrayList'
            Added    = New-Object 'System.Collections.ArrayList'
            Existing = New-Object 'System.Collections.ArrayList'
            Issues   = New-Object 'System.Collections.ArrayList'
        }
    }

    process {


        # Loop through each external vtag and ensure we cached it in $tags
        $InputAsset.vtags | ForEach-Object {
            $vtag = $_
            $QualysTag = $null
            $QualysTag = $($tags.GetEnumerator() | Where-Object { $_.Value.name -eq "$($InputAsset.prefix)$($vtag.TagName)" }).Value
            if ($null -eq $QualysTag) {
                $QualysTag = Get-QualysTag -TagName "$($InputAsset.prefix)$($vtag.TagName)" -InputCredential $InputCredential -InputQualysApiUrl $InputQualysApiUrl -RetrieveParentTag
                if ($null -eq $QualysTag) {
                    $responses.Issues.Add("$($vtag.TagName) could not be found in Qualys") | Out-Null
                }
                else {
                    $tags.Add($QualysTag.id, $QualysTag) | Out-Null
                }
            }
        }

        # Downselect assetTags from $tags to only those that are in the InputAsset's tags.list.TagSimple array
        # [hashtable](QualysTagID:QualysTag)
        $assetTags = @{}
        $InputAsset.tags.list.TagSimple | ForEach-Object {
            $tagID = $_.id
            $assetTags.Add($tagID, $($tags.GetEnumerator() | Where-Object { $_.Key -eq $tagID }).Value)
        }

        $InputAsset.vtags | ForEach-Object {
            $vtag = $_
            if ($CategoryDefinitions.ContainsKey($vtag.Category)) {
                $category = $vtag.Category
                # Set QualysTag to the Qualys tag corresponding to the external vtag
                $QualysTag = $null
                $QualysTag = $($tags.GetEnumerator() | Where-Object { $_.Value.name -eq "$($InputAsset.prefix)$($vtag.TagName)" }).Value
                # may need slightly more sophisticated matching
                [QualysTag[]]$tagsOfCategory = $assetTags.Values | Where-Object { $_.parentTag.name -match "$($InputAsset.prefix)$($category)" }
                if ($tagsOfCategory.Count -eq 0) {
                    # We need to assign the tag to the asset
                    $InputAsset.AssignTag($QualysTag, $InputCredential)
                    $responses.Added.Add("$($QualysTag.name) assigned to $($InputAsset.name)") | Out-Null
                } else {
                    # more than one tag of category $category exists on InputAsset - need to remove incorrect tags
                    $tagsOfCategory | ForEach-Object {
                        if ($_.id -ne $QualysTag.id) {
                            $InputAsset.UnassignTag($_, $InputCredential)
                            $responses.Removed.Add("$($_.name) removed from $($InputAsset.name)") | Out-Null
                        }
                    }
                    if (-not $tagsOfCategory.Contains($QualysTag)) {
                        $InputAsset.AssignTag($QualysTag, $InputCredential)
                        $responses.Added.Add("$($QualysTag.name) assigned to $($InputAsset.name)") | Out-Null
                    } else {
                        $responses.Existing.Add("$($QualysTag.name) already assigned to $($InputAsset.name)") | Out-Null
                    }
                }
            }

        }

    }

    end {
        return $responses
    }

}
