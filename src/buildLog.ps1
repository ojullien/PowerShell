<#PSScriptInfo

.VERSION 1.2.0

.GUID e5f0d849-0001-4c6a-b731-2b6bc8364595

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
 build consistent log from many apache log files.

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
# Load app files and instanciate Process
# -----------------------------------------------------------------------------

. ("$m_DIR_APP\LogBuilder\inc\LogBuilder.ps1")
. ("$m_DIR_APP\LogBuilder\inc\LogExtractor.ps1")

try {
    [LogExtractor] $pExtractor = [LogExtractor]::new( [SevenZip]::new( [SystemDiagnosticsProcess]::new() ) )
} catch {
    $pWriter.error( "Exception raised while creating LogExtractor:  $_" )
    Exit
}

# -----------------------------------------------------------------------------
# Load config
# -----------------------------------------------------------------------------

$sCfgPath = "$m_DIR_APP\LogBuilder\cfg\$cfg.cfg.ps1"
if( ! [File]::new().exists( [Path]::new( $sCfgPath ))) {
    $pWriter.error( "$sCfgPath is missing! Aborting ..." )
    Exit
} else {
    . ($sCfgPath)
}
. ("$m_DIR_APP\LogBuilder\cfg\LogBuilder.ps1")

if( -not $appConfirmed ) {
    Exit
}

# Extract archives
try {
    $null = $pExtractor.setArchive( $appArchivesInputDir ).setOutputDir( $appArchivesOutputDir )
    $pWriter.notice( [string]$pExtractor )
    if( $pExtractor.extract( $true, "var/log/apache2", $false ) ) {
        $pWriter.success( "Exit code: $( $pExtractor.error.code )" )
    } else {
        $pWriter.error( "Exit code:  $( $pExtractor.error.code ) Message: $( $pExtractor.error.message )" )
    }
}
catch {
    $pWriter.error( "Exception raised while extracting archives:  $_" )
}
$pExtractor = $null

# Build Log
[string[]] $aDirCollection = Get-ChildItem -Path $appInputLogDir -Directory -Name | Sort-Object
$pWriter.notice( "Count: $($aDirCollection.Count)" )

try {
    [LogBuilder] $pBuilder = [LogBuilder]::new( $pWriter )
    $null = $pBuilder.setDomains( $appDomains ).setInputDir( $appInputLogDir ).setOutputDir( $appOutputLogDir )
    $pWriter.notice( [string]$pBuilder )
    if( $pBuilder.build( $aDirCollection ) ) {
        $pWriter.success( "Exit code: $( $pBuilder.error.code )" )
    } else {
        $pWriter.error( "Exit code:  $( $pBuilder.error.code ) Message: $( $pBuilder.error.message )" )
    }
} catch {
    $pWriter.error( "Exception raised in LogBuilder: $_" )
}

$pBuilder = $null

Set-StrictMode -Off
