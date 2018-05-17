<#PSScriptInfo

.VERSION 1.2.0

.GUID 7b2e6c14-0001-4ed3-8989-eb37f25c0f8e

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer\autoload.ps1, src\sys\inc\Exec\*

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Exec tests

#>

Param(
    [switch] $verbose,
    [switch] $bequiet,
    [switch] $logtofile
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'

# -----------------------------------------------------------------------------
# Load common sys files
# -----------------------------------------------------------------------------

. ("$PWD\..\src\sys\cfg\constant.ps1")
. ("$m_DIR_SCRIPT\test\sys\cfg\constant.ps1")
. ("$m_DIR_SYS\inc\Writer\autoload.ps1")

# -----------------------------------------------------------------------------
# Load Filter\Path files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Filter\FilterAbstract.ps1")
. ("$m_DIR_SYS\inc\Filter\Path.ps1")
. ("$m_DIR_SYS\inc\Filter\Dir.ps1")
. ("$m_DIR_SYS\inc\Filter\File.ps1")

# -----------------------------------------------------------------------------
# Load Drive\Drive file
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Drive\Drive.ps1")

# -----------------------------------------------------------------------------
# Load Exec files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Exec\Program.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\Interface.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\Abstract.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\Stub.ps1")

# -----------------------------------------------------------------------------
# Test
# -----------------------------------------------------------------------------

. ("$m_DIR_TEST_SYS\inc\Exec\Program.ps1")
. ("$m_DIR_TEST_SYS\inc\Exec\Adapter\CallOperator.ps1")
. ("$m_DIR_TEST_SYS\inc\Exec\Adapter\SystemDiagnosticsProcess.ps1")
#. ("$m_DIR_TEST_SYS\inc\Exec\Adapter\StartProcess.ps1")
. ("$m_DIR_TEST_SYS\inc\Exec\Contig.ps1")
. ("$m_DIR_TEST_SYS\inc\Exec\Robocopy.ps1")

$ErrorActionPreference = "Continue"

Set-StrictMode -Off
