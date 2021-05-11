# GenFibProvider-CW

_Disclaimer: This project(?) is not officially endorsed by Codewars in any manner._

A minor variant of [GenFibProvider](https://github.com/DonaldKellett/GenFibProvider) with Codewars integration in mind

## What are the differences?

The main differences are:

- Use of `bigint` to prevent integer overflow with large sequences
- The sequence is output as a comma-separated list of terms instead of one term per line
- Inclusion of unit tests with [Pester](https://pester.dev/)
- Target environment is Linux since Codewars uses a Linux execution environment

## Usage

Ensure the execution policy is lenient enough. On Linux, the policy is `Unrestricted` and cannot be changed so no modifications are necessary. On the other hand, you may need to set the execution policy appropriately on Windows 10 (see `about_Execution_Policies` for more details), though make sure you understand the security implications.

Make sure [SHiPS](https://www.powershellgallery.com/packages/SHiPS/0.8.1) and [Pester](https://pester.dev/) are installed.

Now set your location to the root of this repo and run:

```powershell
PS> Import-Module Pester
PS> Invoke-Pester ./GenFibProvider.Tests.ps1
```

If all is well, you should see that all tests have passed.

## License

[MIT](./LICENSE)
