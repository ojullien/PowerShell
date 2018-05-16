<#PSScriptInfo

.VERSION 1.2.0

.GUID 5a516eab-0001-4f39-82f9-f12d189bf98d

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys/Writer,app/saveto

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Save data to external disk

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
. ("$m_DIR_SCRIPT\test\sys\cfg\constant.ps1")
. ("$m_DIR_SYS\inc\Writer\autoload.ps1")

# -----------------------------------------------------------------------------
# Load sys\Filter files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Filter\FilterAbstract.ps1")
. ("$m_DIR_SYS\inc\Filter\Path.ps1")
. ("$m_DIR_SYS\inc\Filter\Dir.ps1")
. ("$m_DIR_SYS\inc\Filter\File.ps1")

# -----------------------------------------------------------------------------
# Load sys\Drive files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Drive\Drive.ps1")

# -----------------------------------------------------------------------------
# Load sys\Executable files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Exec\Program.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\Abstract.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\SystemDiagnosticsProcess.ps1")
. ("$m_DIR_SYS\inc\Exec\Robocopy.ps1")

# -----------------------------------------------------------------------------
# Load sys config
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\cfg\main.ps1")

# -----------------------------------------------------------------------------
# Load app files and config
# -----------------------------------------------------------------------------

#. ("$m_DIR_APP\saveto\inc\SaveTo.ps1")
$sCfgPath = "$m_DIR_APP\saveto\cfg\$cfg.cfg.ps1"
if( ! [File]::new().exists( [Path]::new( $sCfgPath ))) {
    $pWriter.error( "$sCfgPath is missing! Aborting ..." )
    Exit
} else {
    . ($sCfgPath)
}
. ("$m_DIR_APP\saveto\cfg\SaveTo.ps1")

exit
# -----------------------------------------------------------------------------
#  Save to
# -----------------------------------------------------------------------------

$pWriter.separateLine()

try {
    $pSaveTo = [SaveTo]::new( [string] $m_DIR_LOG ).setWriter( [Writer] $pWriter ).setSource( [Drive] $pSource ).setDestination( [Drive] $pDestination )
}
catch {
    $pWriter.error( "Cannot load SaveTo: $_" )
    Exit
}

# Clean log directory
$pSaveTo.cleanLog()






# Copy
foreach( $sDir in $aLISTDIR ) {

    $pWriter.separateLine()

    if( !$pSaveTo.robocopy( $sDir ) -or !$pSaveTo.contig( $sDir ) ) {
        $pWriter.notice( "Aborting ...")
        break
    }

}

Remove-Variable -Name [SaveTo]$pSaveTo
Remove-Variable -Name [Drive]$pSource
Remove-Variable -Name [Drive]$pDestination
Remove-Variable -Name [Writer]$pWriter

Set-StrictMode -Off
