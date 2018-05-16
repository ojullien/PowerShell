<#PSScriptInfo

.VERSION 1.2.0

.GUID 7bde70cf-c91a-43b1-86e9-0b4e13c33db7

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
 Sys constants

#>

# -----------------------------------------------------------------------------
# Date
# -----------------------------------------------------------------------------

New-Variable -Name m_DATE -Force -Option Constant,AllScope -Value (Get-Date -format 'FileDateTime')

# -----------------------------------------------------------------------------
# Main Directories
# -----------------------------------------------------------------------------

# Directory holds scripts
New-Variable -Name m_DIR_SCRIPT -Force -Option Constant,AllScope -Value (get-item $PWD).Parent.Fullname
# Directory holds system files
New-Variable -Name m_DIR_SYS -Force -Option Constant,AllScope -Value "$m_DIR_SCRIPT\src\sys"
# Directory holds app files
New-Variable -Name m_DIR_APP -Force -Option Constant,AllScope -Value "$m_DIR_SCRIPT\src\app"
# Directory holds log
New-Variable -Name m_DIR_LOG -Force -Option Constant,AllScope -Value "C:\Temp"

# -----------------------------------------------------------------------------
# Files
# -----------------------------------------------------------------------------
New-Variable -Name m_DIR_LOG_PATH -Force -Option Constant,AllScope -Value "$m_DIR_LOG\$m_DATE`_$(split-path $MyInvocation.PSCommandPath -Leaf).log"
