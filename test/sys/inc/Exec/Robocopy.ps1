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

.REQUIREDSCRIPTS src\sys\inc\Writer\autoload.ps1, src\sys\inc\Exec\Robocopy.ps1, src\sys\inc\Exec\Adapter\Stub.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Exec\Robocopy tests

#>

# -----------------------------------------------------------------------------
# Load Exec files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Exec\Robocopy.ps1")

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

. ("$m_DIR_TEST_SYS\inc\Exec\Robocopy-data.ps1")

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

foreach( $item in $aTestDataCollection ) {

    $pWriterDecorated.separateLine()

    [hashtable] $hSource = $item.theInput.theSource
    [hashtable] $hDestination = $item.theInput.theDestination
    $pWriterDecorated.notice( "Testing`n`t" + `
        "Source`n`t`tDrive: '$( $hSource.theDrive )'`n`t`tLabel: '$( $hSource.theLabel )'`n`t`tDirectory: '$( $hSource.theDirectory )'`n`t"  + `
        "Destination`n`t`tDrive: '$( $hDestination.theDrive )'`n`t`tLabel: '$( $hDestination.theLabel )'`n`t`tDirectory: '$( $hDestination.theDirectory )'`n`t" )

    # Creates Drives
    try {
        [Drive] $pSource = [Drive]::new( [Path]::new( $hSource.theDrive + [System.IO.Path]::DirectorySeparatorChar +  $hSource.theDirectory ), $hSource.theLabel )
        [Drive] $pDestination = [Drive]::new( [Path]::new( $hDestination.theDrive + [System.IO.Path]::DirectorySeparatorChar +  $hDestination.theDirectory) , $hDestination.theLabel )
    } catch {
        $pWriterDecorated.exception( "Exception raised when creating Filter\Drive:  $_" )
        Exit
    }

    # Creates log file
    try {
        [Path] $pLog = [Path]::new( $item.theInput.theLog )
    } catch {
        $pWriterDecorated.exception( "Exception raised when creating Filter\Path:  $_" )
        Exit
    }

    # Creates Adaptater stub
    try {
        [AdapterStub] $pStub = [AdapterStub]::new()
        $pStub.exitcode = [int]$item.theInput.theAdapterStubExitCode
    } catch {
        $pWriterDecorated.exception( "Exception raised when creating Exec\Adapter\AdapterStub:  $_" )
        Exit
    }

    # Creates robocopy
    try {
        [Robocopy] $pRobocopy = [Robocopy]::new( $pSource, $pDestination, $pLog, $pStub )
        $pWriterDecorated.notice( [string]$pRobocopy )
    } catch {
        $pWriterDecorated.exception( "Exception raised when creating Exec\Robocopy:  $_" )
        Exit
    }

    # Run
    [bool] $bRun = $false
    try {
        $bRun = $pRobocopy.run()
    } catch {
        if( $item.theExpected.theException ) {
            $pWriterDecorated.exceptionExpected( "run() raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "run() raised an exception:  $_" )
        }
        continue
    }

    [string] $sBuffer = "`tRun: $bRun => $( $item.theExpected.theRun )"
    if( $bRun -eq $item.theExpected.theRun ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    [int] $iExitCode = $pRobocopy.getExitCode()
    $sBuffer = "`tExitCode: $iExitCode => $( $item.theExpected.theExitCode )"
    if( $iExitCode -eq $item.theExpected.theExitCode ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    $pRobocopy = $null
    $pStub = $null
    $pLog = $null
    $pSource = $null
    $pDestination = $null

}
