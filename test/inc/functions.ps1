<#PSScriptInfo

.VERSION 1.1.0

.GUID 8c6b4039-3915-45f5-90ad-1b9bc864dd19

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
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 Common test functions

#>

Function New-TestObject( $value, $expected ) {
    New-Object -TypeName PsObject -Property @{
        theValueToTest = $value;
        theExpectedReturn = $expected }
}
