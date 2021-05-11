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
	
	[int]GetContent()
	{
		return $this.Value
	}
	
	[bool]SetContent([int]$content, [string]$path)
	{
		if ($content -lt 0) {
			Write-Error "Expected value to be a non-negative integer!"
			return $False
		}
		$this.Value = $content
		$this.Modified = $True
		return $True
	}
}

class GenFibOutParam : SHiPSLeaf
{
	[GenFibInParam]$Order
	[GenFibInParam]$Start
	[GenFibInParam]$Count
	[int[]]$Content
	
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
	
	[int[]]GetContent()
	{
		if ($this.IsCached()) {
			return $this.Content
		}
		$this.Order.Modified = $False
		$this.Start.Modified = $False
		$this.Count.Modified = $False
		if ($this.Count.Value -eq 0) {
			$this.Content = @()
			return $this.Content
		}
		if ($this.Order.Value -eq 0) {
			$this.Content = 1..$this.Count.Value | ForEach-Object { 0 }
			return $this.Content
		}
		$this.Content = @()
		1..$this.Order.Value | ForEach-Object {
			if ($PSItem -eq $this.Order.Value) {
				$this.Content += 1
			} else {
			    $this.Content += 0
			}
		}
		while ($this.Content.Count -lt $this.Start.Value + $this.Count.Value) {
			$next = 0
			1..$this.Order.Value | ForEach-Object {
				$next += $this.Content[-$PSItem]
			}
			$this.Content += $next
		}
		$this.Content = $this.Content[$this.Start.Value..($this.Start.Value + $this.Count.Value - 1)]
		return $this.Content
	}
}