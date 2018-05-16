<#PSScriptInfo

.VERSION 1.0.0

.GUID fb32ddde-0001-4bb7-b887-81ba392263df

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer\autoload.ps1, src\sys\inc\Filter\Path.ps1, src\sys\inc\Filter\Dir.ps1, src\sys\inc\Drive\Drive.ps1, test\sys\inc\Drive\Drive.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Drive\Drive test

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
# Load Filter files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Filter\FilterAbstract.ps1")
. ("$m_DIR_SYS\inc\Filter\Path.ps1")
. ("$m_DIR_SYS\inc\Filter\Dir.ps1")

# -----------------------------------------------------------------------------
# Load Drive\Drive files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Drive\Drive.ps1")

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

. ("$m_DIR_SCRIPT\test\sys\inc\Drive\Drive.ps1")

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

foreach( $item in $aTestDataCollection ) {

    $pWriterDecorated.separateLine()
    $pWriterDecorated.notice( "Testing: '$( $item.theInput.thePath )' on '$( $item.theInput.label )'" )

    try {
        $pPath = [Path]::new( $item.theInput.thePath )
    }
    catch {
        $pWriterDecorated.error( "ERROR: Cannot load Filter\Path module: $_" )
        Exit
    }

    try {
        $pDrive = [Drive]::new( $pPath, $item.theInput.label )
    }
    catch {
        $pWriterDecorated.error( "Cannot load Drive\Drive module: $_" )
        Exit
    }

    # getDriveLetter
    try {
        [string] $sResult = $pDrive.getDriveLetter()
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriterDecorated.exceptionExpected( "getDriveLetter raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "getDriveLetter raised an exception:  $_" )
        }
        continue
    }

    [string] $sBuffer = "`tgetDriveLetter: '$sResult' => '$( $item.theExpected.driveletter )'"
    if( $sResult -eq $item.theExpected.driveletter ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    # getSubFolder
    try {
        $sResult = $pDrive.getSubFolder()
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriterDecorated.exceptionExpected( "getSubFolder raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "getSubFolder raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`tgetSubFolder: '$sResult' => '$( $item.theExpected.subfolder )'"
    if( $sResult -eq $item.theExpected.subfolder ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    # getVolumeLabel
    try {
        $sResult = $pDrive.getVolumeLabel()
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriterDecorated.exceptionExpected( "getVolumeLabel raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "getVolumeLabel raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`tgetVolumeLabel: '$sResult' => '$( $item.theExpected.volumelabel )'"
    if( $sResult -eq $item.theExpected.volumelabel ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    # testPath
    try {
        [bool] $bResult = $pDrive.testPath()
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriterDecorated.exceptionExpected( "testPath raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "testPath raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`ttestPath: '$([string]$bResult)' => '$( $item.theExpected.testPath )'"
    if( $bResult -eq $item.theExpected.testPath ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    # isReady
    try {
        $bResult = $pDrive.isReady()
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriterDecorated.exceptionExpected( "isReady raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "isReady raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`tisReady: '$([string]$bResult)' => '$( $item.theExpected.isReady )'"
    if( $bResult -eq $item.theExpected.isReady ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    # getTrace
    $pWriterDecorated.notice( "Trace: `t`t" + $pDrive.getTrace() )
    $pWriterDecorated.notice( "ToString: `t" + [string]$pDrive )
}

$ErrorActionPreference = "Continue"

Set-StrictMode -Off
