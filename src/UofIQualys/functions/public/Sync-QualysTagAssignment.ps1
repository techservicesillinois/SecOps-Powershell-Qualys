function Sync-QualysTagAssignment {
    <#
        .SYNOPSIS
            Synchronize tags from an external source of truth to Qualys.
        .DESCRIPTION
            This function synchronizes tags from an external source of truth to Qualys.
        .EXAMPLE
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
        # Pull all unique qualys tags from pipelined InputAssets into a hashtable of id and QualysTag object
        $tags = @{}

        $InputAsset | ForEach-Object {
            $_.tags.list.TagSimple | ForEach-Object {
                if (-not $tags.ContainsKey($_.id)) {
                    $tags.Add($_.id, $(Get-QualysTag -TagId $_.id -InputCredential $InputCredential -InputQualysApiUrl $InputQualysApiUrl -RetrieveParentTag))
                }
            }
        }
        $responses = @{
            Removed  = New-Object 'System.Collections.ArrayList'
            Added    = New-Object 'System.Collections.ArrayList'
            Existing = New-Object 'System.Collections.ArrayList'
            Issues   = New-Object 'System.Collections.ArrayList'
        }
    }

    process {

        # Downselect assetTags from $tags to only those that are in the InputAsset's tags.list.TagSimple array
        # [hashtable](QualysTagID:QualysTag)
        $assetTags = @{}
        $InputAsset.tags.list.TagSimple | ForEach-Object {
            $tagID = $_.id
            $assetTags.Add($tagID, $($tags.GetEnumerator() | Where-Object { $_.Key -eq $tagID }).Value)
        }
        # Loop through each external vtag and compare to Qualys tags
        $InputAsset.vtags | ForEach-Object {
            $vtag = $_
            $QualysTag = $($tags.GetEnumerator() | Where-Object { $_.Value.name -eq "$($InputAsset.prefix)$($vtag.TagName)" }).Value
            if ($null -eq $QualysTag) {
                $QualysTag = Get-QualysTag -TagName "$($InputAsset.prefix)$($vtag.TagName)" -InputCredential $InputCredential -InputQualysApiUrl $InputQualysApiUrl
                if ($null -eq $QualysTag) {
                    $responses.Issues.Add("$($vtag.TagName) could not be found in Qualys.")
                    continue
                }
                $tags.Add($QualysTag.id, $QualysTag)
            }
            if ($CategoryDefinitions.ContainsKey($_.Category)) {
                $category = $_.Category
                # may need slightly more sophisticated matching
                [QualysTag[]]$tagsOfCategory = $assetTags.Values | Where-Object { $_.parentTag.name -match "$($InputAsset.prefix)$($category)" }
                if ($tagsOfCategory.Count -eq 0) {
                    # We need to assign the tag to the asset
                    $InputAsset.AssignTag($QualysTag)
                }
                elseif ($tagsOfCategory.Count -gt 1) {
                    # more than one tag of category $category exists on InputAsset - need to remove incorrect tags
                    $tagsOfCategory | ForEach-Object {
                        if ($_.id -ne $QualysTag.id) {
                            $InputAsset.RemoveTag($_)
                        }
                    }
                }
                else {
                    # Ensure the one tag that exists is correct
                    if ($tagsOfCategory[0].id -ne $QualysTag.id) {
                        $InputAsset.RemoveTag($tagsOfCategory[0])
                        $InputAsset.AssignTag($QualysTag)
                    }
                }
            }

        }

    }

    end {
        return $responses
    }

}
