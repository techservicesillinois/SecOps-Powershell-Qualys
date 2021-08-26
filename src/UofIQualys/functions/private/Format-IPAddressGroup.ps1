<#
.Synopsis
    Formats a group of IP addresses to be accepted by the API.
.DESCRIPTION
    Formats a group of IP addresses to be accepted by the API.
.PARAMETER IPs
    Group of IPs to format.
.EXAMPLE
    Format-IPAddressGroup -IPs ("192.168.1.1","192.168.1.2")
#>
function Format-IPAddressGroup {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$IPs
    )

    begin {
    }

    process {
        return ($IPs.Trim() -join ", ")
    }

    end {
    }
}
