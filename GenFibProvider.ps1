using namespace Microsoft.PowerShell.SHiPS

class GenFib : SHiPSDirectory
{	
  [GenFibOutParam]$Sequence

  GenFib([string]$name): base($name)
  {
    $this.Sequence = $null
  }
    
  [object[]]GetChildItem()
  {
    if ($this.Sequence -eq $null) {
      $order = [GenFibInParam]::new("Order", 2)
      $start = [GenFibInParam]::new("Start", 0)
      $count = [GenFibInParam]::new("Count", 10)
      $this.Sequence = [GenFibOutParam]::new("Sequence", $order, $start, $count)
    }
    return @($this.Sequence.Order, $this.Sequence.Start, $this.Sequence.Count, $this.Sequence)
  }
}

class GenFibInParam : SHiPSLeaf
{
  [int]$Value
  [bool]$Modified

  GenFibInParam([string]$name, [int]$value) : base($name)
  {
    $this.Value = $value
    $this.Modified = $False
  }

  [string]GetContent()
  {
    return [string]$this.Value
  }
	
  [bool]SetContent([string]$content, [string]$path)
  {
    if ([int]$content -lt 0) {
      Write-Error "Expected value to be a non-negative integer!"
      return $False
    }
    $this.Value = [int]$content
    $this.Modified = $True
    return $True
  }
}

class GenFibOutParam : SHiPSLeaf
{
  [GenFibInParam]$Order
  [GenFibInParam]$Start
  [GenFibInParam]$Count
  [bigint[]]$Content

  GenFibOutParam([string]$name, [GenFibInParam]$order, [GenFibInParam]$start, [GenFibInParam]$count) : base($name)
  {
    $this.Order = $order
    $this.Start = $start
    $this.Count = $count
    $this.Content = $null
  }

  [bool]IsCached()
  {
    return -not $this.Order.Modified -and -not $this.Start.Modified -and -not $this.Count.Modified -and $this.Content -ne $null
  }
	
  [string]GetContent()
  {
    if ($this.IsCached()) {
      return $this.Content -join ','
    }
    $this.Order.Modified = $False
    $this.Start.Modified = $False
    $this.Count.Modified = $False
    if ($this.Count.Value -eq 0) {
      $this.Content = @()
      return $this.Content -join ','
    }
    if ($this.Order.Value -eq 0) {
      $this.Content = 1..$this.Count.Value | ForEach-Object { 0n }
      return $this.Content -join ','
    }
    $this.Content = @()
    1..$this.Order.Value | ForEach-Object {
      if ($PSItem -eq $this.Order.Value) {
        $this.Content += 1n
      } else {
        $this.Content += 0n
      }
    }
    while ($this.Content.Count -lt $this.Start.Value + $this.Count.Value) {
      $next = 0n
      1..$this.Order.Value | ForEach-Object {
        $next += $this.Content[-$PSItem]
      }
      $this.Content += $next
    }
    $this.Content = $this.Content[$this.Start.Value..($this.Start.Value + $this.Count.Value - 1)]
    return $this.Content -join ','
  }
}
