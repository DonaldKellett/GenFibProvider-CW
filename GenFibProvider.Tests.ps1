Describe 'GenFibProvider' {
  BeforeEach {
    Write-Host "Running BeforeEach"
    Import-Module SHiPS
    Move-Item GenFibProvider.ps1 -Destination GenFibProvider.psm1 -Force
    Import-Module ./GenFibProvider.psm1
    New-PSDrive -Name GF -Root GenFibProvider#GenFib -PSProvider SHiPS
  }
  It 'Default values should be correct' {
    Get-Content GF:\Order | Should -Be '2'
    Get-Content GF:\Start | Should -Be '0'
    Get-Content GF:\Count | Should -Be '10'
    Get-Content GF:\Sequence | Should -Be '0,1,1,2,3,5,8,13,21,34'
  }
  AfterEach {
    Write-Host "Running AfterEach"
    Remove-PSDrive -Name GF
    Remove-Module GenFibProvider
    Move-Item GenFibProvider.psm1 -Destination GenFibProvider.ps1 -Force
    Remove-Module SHiPS
  }
}
