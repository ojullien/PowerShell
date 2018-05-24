<#PSScriptInfo

.VERSION 1.2.0

.GUID 944d5dbd-0003-4efd-85e2-3a51548593d3

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer\autoload.ps1, src\sys\inc\Exec\7-Zip.ps1, src\sys\inc\Exec\Adapter\SystemDiagnosticsProcess.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Exec\7-Zip tests

#>

# -----------------------------------------------------------------------------
# Load Exec files
# -----------------------------------------------------------------------------
. ("$m_DIR_SYS\inc\Exec\Adapter\SystemDiagnosticsProcess.ps1")
. ("$m_DIR_SYS\inc\Exec\7-Zip.ps1")

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

. ("$m_DIR_TEST_SYS\inc\Exec\7-Zip-more-data.ps1")

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

foreach( $item in $aTestDataCollection ) {

    $pWriterDecorated.separateLine()
    $pWriterDecorated.notice( "Testing: '$( $item.theInput.theArchive )'" )

    # Clean Output dir
    Remove-Item "$($item.theInput.theOutputDir)\*" | Out-Null
    [int] $iCount = ( Get-ChildItem $item.theInput.theOutputDir | Measure-Object ).Count
    if( $iCount -ne 0 ){
        throw 'The output directory should be empty.'
    }

    # Creates the archive path
    try {
        [Path] $pArchive = [Path]::new( $item.theInput.theArchive )
    } catch {
        $pWriterDecorated.exception( "Exception raised when creating Filter\Path:  $_" )
        Exit
    }

    # Creates Adaptater stub
    try {
        [SystemDiagnosticsProcess] $pStub = [SystemDiagnosticsProcess]::new()
    } catch {
        $pWriterDecorated.exception( "Exception raised when creating Exec\Adapter\SystemDiagnosticsProcess:  $_" )
        Exit
    }

    # Creates 7-Zip
    try {
        [SevenZip] $pSevenZip = [SevenZip]::new( $pStub )
    } catch {
        $pWriterDecorated.exception( "Exception raised when creating Exec\SevenZip:  $_" )
        Exit
    }

    # Archive
    try {
        $null = $pSevenZip.setArchive( $pArchive )
    } catch {
        if( $item.theExpected.theException ) {
            $pWriterDecorated.exceptionExpected( "setArchive() raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "setArchive() raised an exception:  $_" )
        }
        continue
    }

    # Output dir
    try {
        $null = $pSevenZip.setOutputDir( $item.theInput.theOutputDir )
    } catch {
        if( $item.theExpected.theException ) {
            $pWriterDecorated.exceptionExpected( "setOutputDir() raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "setOutputDir() raised an exception:  $_" )
        }
        continue
    }

    # Run
    [bool] $bRun = $false
    try {
        $pWriterDecorated.notice( [string]$pSevenZip )
        $bRun = $pSevenZip.extract( $item.theInput.theExtractOptions.withfullpaths, $item.theInput.theExtractOptions.file, $item.theInput.theExtractOptions.recurse )
    } catch {
        if( $item.theExpected.theException ) {
            $pWriterDecorated.exceptionExpected( "extract() raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "extract() raised an exception:  $_" )
        }
        continue
    }

    [string] $sBuffer = "`textract: $bRun => $( $item.theExpected.theExtract )"
    if( $bRun -eq $item.theExpected.theExtract ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    [int] $iExitCode = $pSevenZip.getExitCode()
    $sBuffer = "`tExitCode: $iExitCode => $( $item.theExpected.theExitCode )"
    if( $iExitCode -eq $item.theExpected.theExitCode ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    $iCount = ( Get-ChildItem $item.theInput.theOutputDir | Measure-Object ).Count
    if( $iCount -eq 0 ){
        $pWriterDecorated.error( "`tCount: $iCount" )
    } else {
        $pWriterDecorated.success( "`tCount: $iCount" )
    }

    $pSevenZip = $null
    $pStub = $null
    $pArchive = $null

}
