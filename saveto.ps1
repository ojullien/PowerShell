<#PSScriptInfo

.VERSION 1.0.0

.GUID 8c6b4039-3915-45f5-90ad-1b9bc864dd2e

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys,app\saveto

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180409
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 Save data to external disk

#>

Param(
    [switch] $bequiet,
    [switch] $logtofile,
    [switch] $waituser,
    [switch] $f220,
    [switch] $test
)

Set-StrictMode -Version Latest

# -----------------------------------------------------------------------------
#  Script options
# -----------------------------------------------------------------------------
New-Variable -Name m_OPTION_WAIT -Force -Option Constant,AllScope -Value $( if( $waituser.IsPresent ) {1} else {0} )

# -----------------------------------------------------------------------------
#  Include sys files
# -----------------------------------------------------------------------------
. ("$PWD\sys\cfg\constant.ps1")
. ("$PWD\sys\inc\writer.ps1")

try {
    $pWriter = [CWriter]::new()
    if( -Not $bequiet.IsPresent ) {
        $pWriter.addOutput( [COutputHost]::new() )
    }
    if( $logtofile.IsPresent ) {
        $pWriter.addOutput( [COutputLog]::new( $m_DIR_LOG_PATH ) )
    }
}
catch {
    "ERROR: Cannot load writer: $_"
    Exit
}

. ("$PWD\sys\inc\filesystem.ps1")
. ("$PWD\sys\inc\process.ps1")
. ("$PWD\sys\cfg\main.ps1")

# -----------------------------------------------------------------------------
#  Include app files
# -----------------------------------------------------------------------------
. ("$PWD\app\saveto\inc\saveto.ps1")
if( $test.IsPresent ) {
    . ("$PWD\app\saveto\cfg\test.ps1")
} elseif( $f220.IsPresent ) {
    . ("$PWD\app\saveto\cfg\f220.ps1")
} else {
    . ("$PWD\app\saveto\cfg\wd120.ps1")
}
. ("$PWD\app\saveto\cfg\saveto.ps1")

# -----------------------------------------------------------------------------
#  Save to
# -----------------------------------------------------------------------------

$pWriter.separateLine()

# Clean log directory
foreach( $sName in "robocopy", "contig" ) {
    $pWriter.notice( "Cleaning '$sName-*.log' files from '$m_DIR_LOG'" )
    Remove-Item "$m_DIR_LOG\$sName-*.log"
}

# Check source
if( -Not [CValidator]::existsFolder( $pSource.getCheckDir() )) {
    $pWriter.error( "$pSource is missing! Aborting ..." )
    Exit
}

# Check destination
if( -Not [CValidator]::existsFolder( $pDestination.getCheckDir() )) {
    $pWriter.error( "$pDestination is missing! Aborting ..." )
    Exit
}

# Ask for confirmation
$pWriter.notice( "$pSource and $pDestination are ready. " )
if( -Not $bequiet.IsPresent ) {
    $pWriter.notice( "Would you like to continue? (Default is No)" )
    $Readhost = Read-Host "[y/n]"
    Switch( $ReadHost ) {
        Y { $pWriter.notice( "Yes, Saving ...") ; $bConfirmed = $true }
        N { $pWriter.notice( "No, Aborting ...") ; $bConfirmed = $false }
        Default { $pWriter.notice( "Default, Aborting ...") ; $bConfirmed = $false }
    }
} else {
    $bConfirmed = $true
}

# Confirmation
if( -not $bConfirmed ) {
    Exit
}

# Copy
foreach( $sDir in $aLISTDIR ) {
    $pWriter.separateLine()
    $pProcess = [CRobocopy]::new( "$($pSource.get_m_sDrive())\$sDir", "$($pDestination.get_m_sDrive())\$sDir", "$m_DIR_LOG\robocopy-$sDir.log" )
    $bError = $pProcess.setWriter( $pWriter ).run()
    Remove-Variable -Name [Object]$pProcess
    if( -Not $bError ) {
        $pWriter.notice( "Aborting ...")
        Exit
    }
    $pProcess = [CContiger]::new( "$($pDestination.get_m_sDrive())\$sDir" )
    $bError = $pProcess.setWriter( $pWriter ).run()
    Remove-Variable -Name [Object]$pProcess
    if( -Not $bError ) {
        $pWriter.notice( "Aborting ...")
        Exit
    }
}

Set-StrictMode -Off