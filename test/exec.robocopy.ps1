<#PSScriptInfo

.VERSION 1.2.0

.GUID b0bbf184-0001-4937-b331-cf11ea6906f3

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer, src\sys\inc\Exec\Robocopy.ps1, src\sys\inc\Exec\Adapter\Stub.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Exec\Robocopy tests

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
. ("$m_DIR_SYS\inc\Exec\Adapter\Abstract.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\Stub.ps1")
. ("$m_DIR_SYS\inc\Exec\Robocopy.ps1")

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

. ("$m_DIR_SCRIPT\test\sys\inc\Exec\Robocopy.ps1")

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

foreach( $item in $aTestDataCollection ) {

    $pWriter.separateLine()

    [hashtable] $hSource = $item.theInput.theSource
    [hashtable] $hDestination = $item.theInput.theDestination
    $pWriter.notice( "Testing`n`t" + `
        "Source`n`t`tDrive: '$( $hSource.theDrive )'`n`t`tLabel: '$( $hSource.theLabel )'`n`t`tDirectory: '$( $hSource.theDirectory )'`n`t"  + `
        "Destination`n`t`tDrive: '$( $hDestination.theDrive )'`n`t`tLabel: '$( $hDestination.theLabel )'`n`t`tDirectory: '$( $hDestination.theDirectory )'`n`t" )

    # Creates Drives
    try {
        [Drive] $pSource = [Drive]::new( [Path]::new( $hSource.theDrive + [System.IO.Path]::DirectorySeparatorChar +  $hSource.theDirectory ), $hSource.theLabel )
        [Drive] $pDestination = [Drive]::new( [Path]::new( $hDestination.theDrive + [System.IO.Path]::DirectorySeparatorChar +  $hDestination.theDirectory) , $hDestination.theLabel )
    } catch {
        $pWriter.exception( "Exception raised when creating Filter\Drive:  $_" )
        Exit
    }

    # Creates log file
    try {
        [Path] $pLog = [Path]::new( $item.theInput.theLog )
    } catch {
        $pWriter.exception( "Exception raised when creating Filter\Path:  $_" )
        Exit
    }

    # Creates Adaptater stub
    try {
        [AdapterStub] $pStub = [AdapterStub]::new()
        $pStub.exitcode = [int]$item.theInput.theAdapterStubExitCode
    } catch {
        $pWriter.exception( "Exception raised when creating Exec\Adapter\AdapterStub:  $_" )
        Exit
    }

    # Creates robocopy
    try {
        [Robocopy] $pRobocopy = [Robocopy]::new( $pSource, $pDestination, $pLog, $pStub )
        $pWriter.notice( [string]$pRobocopy )
    } catch {
        $pWriter.exception( "Exception raised when creating Exec\Robocopy:  $_" )
        Exit
    }

    # Run
    [bool] $bRun = $false
    try {
        $bRun = $pRobocopy.run()
    } catch {
        if( $item.theExpected.theException ) {
            $pWriter.exceptionExpected( "run() raised an expected exception:  $_" )
        } else {
            $pWriter.exception( "run() raised an exception:  $_" )
        }
        continue
    }

    [string] $sBuffer = "`tRun: $bRun => $( $item.theExpected.theRun )"
    if( $bRun -eq $item.theExpected.theRun ) {
        $pWriter.success( $sBuffer )
    } else {
        $pWriter.error( $sBuffer )
    }

    [int] $iExitCode = $pRobocopy.getExitCode()
    $sBuffer = "`tExitCode: $iExitCode => $( $item.theExpected.theExitCode )"
    if( $iExitCode -eq $item.theExpected.theExitCode ) {
        $pWriter.success( $sBuffer )
    } else {
        $pWriter.error( $sBuffer )
    }

    $pRobocopy = $null
    $pStub = $null
    $pLog = $null
    $pSource = $null
    $pDestination = $null

}

$ErrorActionPreference = "Continue"

Set-StrictMode -Off
