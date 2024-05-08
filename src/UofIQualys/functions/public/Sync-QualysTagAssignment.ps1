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
        $assetTags = @{}
        $InputAsset.tags.list.TagSimple | ForEach-Object {
            $assetTags.Add($_.id, $($tags | Where-Object { $_.Key -eq $_.id }).Value)
        }
        # Loop through each external vtag and compare to Qualys tags
        $InputAsset.vtags | ForEach-Object {
            $vtag = $_
            $QualysTag = $($tags.GetEnumerator() | Where-Object { $_.Value.name -eq "$($InputAsset.prefix)$($vtag.name)" }).Value
            if ($null -eq $QualysTag) {
                $QualysTag = Get-QualysTag -TagName "$($InputAsset.prefix)$($vtag.name)" -InputCredential $InputCredential -InputQualysApiUrl $InputQualysApiUrl
                if ($null -eq $QualysTag) {
                    $responses.Issues.Add("$vtag could not be found in Qualys.")
                    continue
                }
                $tags.Add($QualysTag.id, $QualysTag)
            }
        }




    }

    end {
        return $responses
    }

}