<#PSScriptInfo

.VERSION 1.2.0

.GUID 30891815-e728-475b-81c3-eeaf2bbf81df

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
 Sys constants for tests.

#>

# Test mode
New-Variable -Name m_MODE_TEST -Force -Option Constant,AllScope -Value $true

# Directory holds test system files
New-Variable -Name m_DIR_TEST_SYS -Force -Option Constant,AllScope -Value "$m_DIR_SCRIPT\test\sys"

# Directory holds test app files
New-Variable -Name m_DIR_TEST_APP -Force -Option Constant,AllScope -Value "$m_DIR_SCRIPT\test\app"
