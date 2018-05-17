<#PSScriptInfo

.VERSION 1.2.0

.GUID 51600348-0002-4a99-a11e-cc2920fcefb0

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 File data set

#>

Function New-TestFilterFileObject( $path, $expected ) {
    New-Object -TypeName PsObject -Property @{
        theInput = $path
        theExpected = $expected }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestFilterFileObject 'C:\does\not\exist.txt' @{ isValid = $true; exists =  $false; doFilter = "C:\does\not"; Exception = $false }
$aTestDataCollection += New-TestFilterFileObject 'C:\Program Files\PowerShell\6.0.2' @{ isValid = $true; exists = $false; doFilter = "C:\Program Files\PowerShell"; Exception = $false }
$aTestDataCollection += New-TestFilterFileObject 'C:\Program Files\PowerShell\6.0.2\pwsh.exe' @{ isValid = $true; exists =  $true; doFilter = "C:\Program Files\PowerShell\6.0.2"; Exception = $false }

$aTestDataCollection += New-TestFilterFileObject 'C:\Program Files\Power|Shell\6.0.2\pwsh.exe' @{ isValid = $false; exists = $false; doFilter = ""; Exception = $true }
$aTestDataCollection += New-TestFilterFileObject 'C:\Program Files\Power:Shell\6.0.2\pwsh.exe' @{ isValid = $false; exists = $false; doFilter = ""; Exception = $true }
$aTestDataCollection += New-TestFilterFileObject 'C:\.txt' @{ isValid = $true; exists = $false; doFilter = "C:\"; Exception = $false }
