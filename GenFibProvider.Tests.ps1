BeforeAll {
  Import-Module SHiPS
  Move-Item GenFibProvider.ps1 -Destination GenFibProvider.psm1 -Force
  Import-Module ./GenFibProvider.psm1
}

Describe 'GenFibProvider' {
  BeforeEach {
    New-PSDrive -Name GF -Root GenFibProvider#GenFib -PSProvider SHiPS -WarningAction 'SilentlyContinue'
  }
  It 'Default values should be correct' {
    Get-Content GF:\Order | Should -Be '2'
    Get-Content GF:\Start | Should -Be '0'
    Get-Content GF:\Count | Should -Be '10'
    Get-Content GF:\Sequence | Should -Be '0,1,1,2,3,5,8,13,21,34'
  }
  It 'should allow Set-Content on Order, Start and Count' {
    Set-Content GF:\Order -Value 3
    Set-Content GF:\Start -Value 15
    Set-Content GF:\Count -Value 20
    Get-Content GF:\Order | Should -Be '3'
    Get-Content GF:\Start | Should -Be '15'
    Get-Content GF:\Count | Should -Be '20'
    Get-Content GF:\Sequence | Should -Be '1705,3136,5768,10609,19513,35890,66012,121415,223317,410744,755476,1389537,2555757,4700770,8646064,15902591,29249425,53798080,98950096,181997601'
  }
  It 'should prevent setting values less than 0 on Order, Start and Count' {
    Set-Content GF:\Order -Value -1 -ErrorAction 'SilentlyContinue'
    Set-Content GF:\Start -Value -2 -ErrorAction 'SilentlyContinue'
    Set-Content GF:\Count -Value -3 -ErrorAction 'SilentlyContinue'
    Get-Content GF:\Order | Should -Be '2'
    Get-Content GF:\Start | Should -Be '0'
    Get-Content GF:\Count | Should -Be '10'
    Get-Content GF:\Sequence | Should -Be '0,1,1,2,3,5,8,13,21,34'
  }
  AfterEach {
    Remove-PSDrive -Name GF
  }
}

AfterAll {
  Remove-Module GenFibProvider
  Move-Item GenFibProvider.psm1 -Destination GenFibProvider.ps1 -Force
  Remove-Module SHiPS
}
