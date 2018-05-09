<#PSScriptInfo

.VERSION 1.2.0

.GUID 54ebf841-0001-46f2-ad7c-0e5dd86eeff7

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer, src\sys\inc\Filter\Path.ps1, test\sys\inc\Filter\Path.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Filter\Path tests

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
# Load sys files
# -----------------------------------------------------------------------------

. ("$PWD\..\src\sys\cfg\constant.ps1")
. ("$m_DIR_SYS\inc\Writer\Output\OutputAbstract.ps1")
. ("$m_DIR_SYS\inc\Writer\Writer.ps1")
. ("$m_DIR_SYS\inc\Writer\Verbose.ps1")

try {
    $pWriter = [Verbose]::new( $verbose.IsPresent, 80 )
    if( -Not $bequiet.IsPresent ) {
        . ("$m_DIR_SYS\inc\Writer\Output\OutputHost.ps1")
        $pWriter.addOutput( [OutputHost]::new() )
    }
    if( $logtofile.IsPresent ) {
        . ("$m_DIR_SYS\inc\Writer\Output\OutputLog.ps1")
        $pWriter.addOutput( [OutputLog]::new( $m_DIR_LOG_PATH ) )
    }
}
catch {
    $pWriter.error( "ERROR: Cannot load Writer module: $_" )
    Exit
}

# -----------------------------------------------------------------------------
# Load Filter\Path files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Filter\FilterAbstract.ps1")
. ("$m_DIR_SYS\inc\Filter\Path.ps1")

try {
    $pPath = [Path]::new()
}
catch {
    $pWriter.error( "ERROR: Cannot load Filter\Path module: $_" )
    Exit
}

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

. ("$m_DIR_SCRIPT\test\sys\inc\Filter\Path.ps1")

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

foreach( $item in $aTestDataCollection ) {

    $pWriter.separateLine()
    $pWriter.notice( "Testing: '$( $item.theInput )'" )

    try {
        # isValid use doFilter
        [bool] $bResult = $pPath.isValid( $item.theInput )
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriter.exceptionExpected( "doFilter raised an expected exception:  $_" )
        } else {
            $pWriter.exception( "doFilter raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`tdirectoryname: '$( $pPath.getDirectoryName() )' => '$( $item.theExpected.directoryname )'"
    if( $pPath.getDirectoryName() -eq $item.theExpected.directoryname ) {
        $pWriter.success( $sBuffer )
    } else {
        $pWriter.error( $sBuffer )
    }

    $sBuffer = "`tfilename: '$( $pPath.getFilename() )' => '$( $item.theExpected.filename )'"
    if( $pPath.getFilename() -eq $item.theExpected.filename ) {
        $pWriter.success( $sBuffer )
    } else {
        $pWriter.error( $sBuffer )
    }

    $sBuffer = "`tbasename: '$( $pPath.getBasename() )' => '$( $item.theExpected.basename )'"
    if( $pPath.getBasename() -eq $item.theExpected.basename ) {
        $pWriter.success( $sBuffer )
    } else {
        $pWriter.error( $sBuffer )
    }

    $sBuffer = "`textension: '$( $pPath.getExtension() )' => '$( $item.theExpected.extension )'"
    if( $pPath.getExtension() -eq $item.theExpected.extension ) {
        $pWriter.success( $sBuffer )
    } else {
        $pWriter.error( $sBuffer )
    }

    $sBuffer = "`tpathroot: '$( $pPath.getPathRoot() )' => '$( $item.theExpected.pathroot )'"
    if( $pPath.getPathRoot() -eq $item.theExpected.pathroot ) {
        $pWriter.success( $sBuffer )
    } else {
        $pWriter.error( $sBuffer )
    }

    $sBuffer = "`tisValid: '$([string]$bResult)' => '$( $item.theExpected.isValid )'"
    if( $bResult -eq $item.theExpected.isValid ) {
        $pWriter.success( $sBuffer )
    } else {
        $pWriter.error( $sBuffer )
    }

}

$ErrorActionPreference = "Continue"

Set-StrictMode -Off
