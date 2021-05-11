BeforeAll {
  Write-Host "Running BeforeAll"
  Import-Module SHiPS
  Move-Item GenFibProvider.ps1 -Destination GenFibProvider.psm1 -Force
  Import-Module ./GenFibProvider.psm1
  New-PSDrive -Name GF -Root GenFibProvider#GenFib -PSProvider SHiPS
}

Describe 'Dummy' {
  It '1 should equal 1' {
    1 | Should -Be 1
  }
}

AfterAll {
  Write-Host "Running AfterAll"
  Remove-PSDrive -Name GF
  Remove-Module GenFibProvider
  Move-Item GenFibProvider.psm1 -Destination GenFibProvider.ps1 -Force
  Remove-Module SHiPS
}
