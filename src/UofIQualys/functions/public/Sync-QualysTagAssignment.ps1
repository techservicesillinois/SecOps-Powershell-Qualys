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
        $InputQualysApiUrl = $QualysApiUrl

    )

    begin {
        # Pull all unique qualys tags from pipelined InputAssets into a hashtable of id and QualysTag object
        $tags = @{}
        $CategoryDefinitions = @{}

        $InputAsset | ForEach-Object {
            $_.tags.list.TagSimple | ForEach-Object {
                if (-not $tags.ContainsKey($_.id)) {
                    $tags.Add($_.id, $(Get-QualysTag -TagId $_.id -InputCredential $InputCredential -InputQualysApiUrl $InputQualysApiUrl -RetrieveParentTag))
                }
            }
            $InputAsset | ForEach-Object {
                $_.vtags | ForEach-Object {
                    if (-not $CategoryDefinitions.ContainsKey($_.Category)) {
                        $CategoryDefinitions.Add($_.Category, $_.Value)
                    }
                    else {
                        if ($CategoryDefinitions[$_.Category] -notcontains $_.Value) {
                            $CategoryDefinitions[$_.Category].Add($_.Value)
                        }
                    }
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
            $QualysTag = $($tags.GetEnumerator() | Where-Object { $_.Value.name -eq $vtag.name }).Value
            if ($null -eq $QualysTag) {
                $QualysTag = Get-QualysTag -TagName $vtag.name -InputCredential $InputCredential -InputQualysApiUrl $InputQualysApiUrl
                if ($null -eq $QualysTag) {
                    $responses.Issues.Add("$vtag could not be found in Qualys.")
                    continue
                }
                $tags.Add($QualysTag.id, $QualysTag)
            }
        }

        #loop over unique Category property values of vtags
        $InputAsset.vtags | Select-Object -ExpandProperty Category -Unique | ForEach-Object {
            # aje4gno8eg58oe54h
        }




    }

    end {
        return $responses
    }

}