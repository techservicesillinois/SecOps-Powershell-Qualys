[String]$ModuleRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'src\UofIQualys'
Import-Module -Name $ModuleRoot

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        $ManifestPath = Join-Path -Path "$(Split-Path -Path $PSScriptRoot -Parent)" -ChildPath 'src\UofIQualys\UofIQualys.psd1'
        Test-ModuleManifest -Path $ManifestPath | Should -Not -BeNullOrEmpty
    }
}

Describe 'Format-IPAddressGroup' {
    InModuleScope 'UofIQualys' {
        It 'Correctly joins IP addresses' {
            Format-IPAddressGroup -IPs ("192.168.1.1 "," 192.168.1.2") | Should -Be "192.168.1.1, 192.168.1.2"
        }
    }
}
