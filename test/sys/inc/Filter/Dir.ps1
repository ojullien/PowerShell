<#PSScriptInfo

.VERSION 1.2.0

.GUID 969dc39f-0002-4e61-9cfd-8e8df7ebebf6

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
 Dir data set

#>

Function New-TestFilterDirObject( $path, $expected ) {
    New-Object -TypeName PsObject -Property @{
        theInput = $path
        theExpected = $expected }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestFilterDirObject 'C:\does\not\exist' @{ isValid = $true; exists =  $false; doFilter = "C:\does\not"; Exception = $false }
$aTestDataCollection += New-TestFilterDirObject 'C:\Program Files\PowerShell\6.0.2' @{ isValid = $true; exists = $true; doFilter = "C:\Program Files\PowerShell"; Exception = $false }
$aTestDataCollection += New-TestFilterDirObject 'C:\Program Files\PowerShell\6.0.2\pwsh.exe' @{ isValid = $true; exists =  $false; doFilter = "C:\Program Files\PowerShell\6.0.2"; Exception = $false }

$aTestDataCollection += New-TestFilterDirObject 'C:\Program Files\Power|Shell\6.0.2' @{ isValid = $false; exists = $false; doFilter = ""; Exception = $true }
$aTestDataCollection += New-TestFilterDirObject 'C:\Program Files\Power:Shell\6.0.2' @{ isValid = $false; exists = $false; doFilter = ""; Exception = $true }
$aTestDataCollection += New-TestFilterDirObject 'C:\' @{ isValid = $true; exists = $true; doFilter = ""; Exception = $false }
