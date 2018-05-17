<#PSScriptInfo

.VERSION 1.2.0

.GUID fb32ddde-0002-4bb7-b887-81ba392263df

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\app\SaveTo\inc\*

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 SaveTo tests

#>

# -----------------------------------------------------------------------------
# Load Exec files
# -----------------------------------------------------------------------------

. ("$m_DIR_APP\SaveTo\inc\SaveTo.ps1")

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

. ("$m_DIR_TEST_APP\SaveTo\cfg\SaveTo.ps1")

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

foreach( $item in $aTestDataCollection ) {

    $pWriterDecorated.separateLine()

    [hashtable] $hSource = $item.theInput.theSource
    [hashtable] $hDestination = $item.theInput.theDestination
    $pWriterDecorated.notice( "Testing`n" + `
        "`tSource`n`t`tDrive: '$( $hSource.theDrive )'`n`t`tLabel: '$( $hSource.theLabel )'`n`t`tDirectory: '$( $hSource.theDirectory )'`n"  + `
        "`tDestination`n`t`tDrive: '$( $hDestination.theDrive )'`n`t`tLabel: '$( $hDestination.theLabel )'`n`t`tDirectory: '$( $hDestination.theDirectory )'`n"  + `
        "`tLog:`t'$( $item.theInput.theLog )'`n" + `
        "`tCode:`t'$( $item.theInput.theAdapterStubExitCode.robocopy)'/'$( $item.theInput.theAdapterStubExitCode.contig)'" )

    # Creates Path
    try {
        [Path] $pSource = [Path]::new( $hSource.theDrive + [System.IO.Path]::DirectorySeparatorChar +  $hSource.theDirectory )
        [Path] $pDestination = [Path]::new( $hDestination.theDrive + [System.IO.Path]::DirectorySeparatorChar +  $hDestination.theDirectory )
        [Path] $pLog = [Path]::new( $item.theInput.theLog )
    } catch {
        $pWriterDecorated.exception( "Exception raised when creating Filter\Path:  $_" )
        Exit
    }

    # Creates Adaptater stub
    try {
        [AdapterStub] $pStub = [AdapterStub]::new()
    } catch {
        $pWriterDecorated.exception( "Exception raised when creating Exec\Adapter\AdapterStub:  $_" )
        Exit
    }

    # Creates SaveTo
    try {
        [SaveTo] $pSaveTo = [SaveTo]::new( $pStub, $pLog )
    } catch {
        if( $item.theExpected.theException ) {
            $pWriterDecorated.exceptionExpected( "new() raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "new() raised an exception:  $_" )
        }
        continue
    }

    # Set source
    try {
        $null = $pSaveTo.setSource( $pSource, $hSource.theLabel )
    } catch {
        if( $item.theExpected.theException ) {
            $pWriterDecorated.exceptionExpected( "setSource() raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "setSource() raised an exception:  $_" )
        }
        continue
    }

    # Set destination
    try {
        $null = $pSaveTo.setDestination( $pDestination, $hDestination.theLabel )
    } catch {
        if( $item.theExpected.theException ) {
            $pWriterDecorated.exceptionExpected( "setDestination() raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "setDestination() raised an exception:  $_" )
        }
        continue
    }

    # Trace
    $pWriterDecorated.notice( [string]$pSaveTo )

    # Initialize
    [hashtable] $hRobocopy = $item.theExpected.theRobocopy
    [hashtable] $hContig = $item.theExpected.theContig
    [hashtable] $hExitCode =  $item.theInput.theAdapterStubExitCode
    [bool] $bRun = $false
    [int] $iRun = 0

    # Robocopy
    try {
        $pStub.exitcode = [int]$hExitCode.robocopy
        $bRun = $pSaveTo.robocopy()
        $iRun = $pSaveTo.error.code
    } catch {
        if( $item.theExpected.theException ) {
            $pWriterDecorated.exceptionExpected( "robocopy() raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "robocopy() raised an exception:  $_" )
        }
        continue
    }

    [string] $sBuffer = "`tRobocopy: $bRun / $iRun => $( $hRobocopy.value ) / $( $hRobocopy.exitcode )"
    if( ($bRun -eq $hRobocopy.value) -and ($iRun -eq $hRobocopy.exitcode) ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    # Contig
    try {
        $pStub.exitcode = [int]$hExitCode.contig
        $bRun = $pSaveTo.contig()
        $iRun = $pSaveTo.error.code
    } catch {
        if( $item.theExpected.theException ) {
            $pWriterDecorated.exceptionExpected( "contig() raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "contig() raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`tContig: $bRun / $iRun => $( $hContig.value ) / $( $hContig.exitcode )"
    if( ($bRun -eq $hContig.value) -and ($iRun -eq $hContig.exitcode) ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    $pSaveTo = $null
    $pStub = $null
    $pLog = $null
    $pSource = $null
    $pDestination = $null

}
