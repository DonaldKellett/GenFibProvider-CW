BeforeAll {
  Write-Host "Running BeforeAll"
  Import-Module SHiPS
  Move-Item GenFibProvider.ps1 -Destination GenFibProvider.psm1 -Force
  Import-Module ./GenFibProvider.psm1
  New-PSDrive -Name GF -Root GenFibProvider#GenFib -PSProvider SHiPS
}

Describe 'GenFibProvider' {
  Context 'Defaults' {
    Context 'Order' {
      It 'should default to 2' {
        Get-Content GF:\Order | Should -Be '2'
      }
    }
    Context 'Start' {
      It 'should default to 0' {
        Get-Content GF:\Start | Should -Be '0'
      }
    }
    Context 'Count' {
      It 'should default to 10' {
        Get-Content GF:\Count | Should -Be '10'
      }
    }
    Context 'Sequence' {
      It 'should default to the first 10 terms of the Fibonacci sequence' {
        Get-Content GF:\Sequence | Should -Be '0,1,1,2,3,5,8,13,21,34'
      }
    }
  }
}

AfterAll {
  Write-Host "Running AfterAll"
  Remove-PSDrive -Name GF
  Remove-Module GenFibProvider
  Move-Item GenFibProvider.psm1 -Destination GenFibProvider.ps1 -Force
  Remove-Module SHiPS
}
