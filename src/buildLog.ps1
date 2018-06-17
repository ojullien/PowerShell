<#PSScriptInfo

.VERSION 1.2.0

.GUID fe85499f-0001-4ceb-931f-2831b75e3b2d

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS .

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 build consistent log from many apache log

#>
[CmdletBinding()]
Param(
    [switch] $bequiet,
    [switch] $logtofile,
    [switch] $waituser,
    [Parameter(Mandatory=$True,Position=1)]
    [ValidateNotNullOrEmpty()]
    [string] $cfg = 'default'
)

Set-StrictMode -Version Latest

# -----------------------------------------------------------------------------
#  Script options
# -----------------------------------------------------------------------------
New-Variable -Name m_OPTION_WAIT -Force -Option Constant,AllScope -Value $( if( $waituser.IsPresent ) {1} else {0} )

# -----------------------------------------------------------------------------
# Load common sys files
# -----------------------------------------------------------------------------

. ("$PWD\..\src\sys\cfg\constant.ps1")
. ("$m_DIR_SYS\inc\Writer\autoload.ps1")

# -----------------------------------------------------------------------------
# Load sys\Filter files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Filter\autoload.ps1")

# -----------------------------------------------------------------------------
# Load sys\Executable files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Exec\Program.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\Interface.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\Abstract.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\SystemDiagnosticsProcess.ps1")
. ("$m_DIR_SYS\inc\Exec\7-Zip.ps1")

# -----------------------------------------------------------------------------
# Load sys config
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\cfg\main.ps1")

# -----------------------------------------------------------------------------
# Load app files and config
# -----------------------------------------------------------------------------

#$sCfgPath = "$m_DIR_APP\BuildLog\cfg\$cfg.cfg.ps1"
#if( ! [File]::new().exists( [Path]::new( $sCfgPath ))) {
#    $pWriter.error( "$sCfgPath is missing! Aborting ..." )
#    Exit
#} else {
#    . ($sCfgPath)
#}
#. ("$m_DIR_APP\BuildLog\cfg\BuildLog.ps1")
. ("$m_DIR_APP\BuildLog\inc\BuildLog.ps1")

# -----------------------------------------------------------------------------
#  Build Log
# -----------------------------------------------------------------------------

[bool] $bRun = $false

# Creates 7-Zip
try {
    [SystemDiagnosticsProcess] $pAdapter = [SystemDiagnosticsProcess]::new()
    [SevenZip] $pSevenZip = [SevenZip]::new( $pAdapter )
    [BuildLog] $pProcess = [BuildLog]::new($pSevenZip)
} catch {
    $pWriter.error( "Exception raised while creating Exec\BuildLog:  $_" )
    Exit
}

# Step 1
try {
    $null = $pProcess.setArchive( "D:\Servers.Online.net\sd-test\download\data\*_0625.tar.bz2" ).setOutputDir( "D:\Servers.Online.net\sd-test\download\data" )
    $pWriter.notice( [string]$pProcess )
    $bRun = $pProcess.extract( $false, "", $false )
} catch {
    $pWriter.exception( "Exception raised while running step 1:  $_" )
}

# Step 2
try {
    $null = $pProcess.setArchive( "D:\Servers.Online.net\sd-test\download\data\*_0625.tar" ).setOutputDir( "D:\Servers.Online.net\sd-test\download\temp" )
    $pWriter.notice( [string]$pProcess )
    $bRun = $pProcess.extract( $false, "*_0625.tar.bz2", $true )
} catch {
    $pWriter.exception( "Exception raised while running step 1:  $_" )
}

$pProcess = $null
$pSevenZip = $null
$pAdapter = $null

Set-StrictMode -Off
