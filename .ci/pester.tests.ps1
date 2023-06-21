BeforeAll {
    Import-Module -Name "$PSScriptRoot/../PowerVCF.psd1" -Force -ErrorAction Stop
}

Describe -Tag:('ModuleValidation') 'Module Baseline Validation' {

    It 'is present' {
        $module = Get-Module PowerVCF
        $module | Should -Be $true
    }

    It ('passes Test-ModuleManifest') {
        Test-ModuleManifest -Path:("$PSScriptRoot/../PowerVCF.psd1") | Should -Not -BeNullOrEmpty
        $? | Should -Be $true
    }
}
