<#PSScriptInfo

.VERSION 1.3.0

.GUID 90c70f14-f1cf-4c22-9175-fe79514a477d

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\Writer, sys\inc\Filter

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180620
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Main Configuration file for tests

#>

# -----------------------------------------------------------------------------
# Trace
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\cfg\main.ps1")

# -----------------------------------------------------------------------------
# Trace
# -----------------------------------------------------------------------------

[Dir]::new().exists( $pWriter, "`tTest App directory: $m_DIR_TEST_APP ", [Path]::new($m_DIR_TEST_APP) ) > $null
[Dir]::new().exists( $pWriter, "`tTest Log directory: $m_DIR_TEST_LOG ", [Path]::new($m_DIR_TEST_LOG) ) > $null
