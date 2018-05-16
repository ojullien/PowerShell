<#PSScriptInfo

.VERSION 1.2.0

.GUID 7b2e6c14-0001-4ed3-8989-eb37f25c0f8e

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer\autoload.ps1, src\sys\inc\Exec\Contig.ps1, src\sys\inc\Exec\Adapter\Stub.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Exec\Contig tests

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
. ("$m_DIR_SYS\inc\Exec\Contig.ps1")

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

. ("$m_DIR_SCRIPT\test\sys\inc\Exec\Contig.ps1")

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

foreach( $item in $aTestDataCollection ) {

    $pWriterDecorated.separateLine()
    $pWriterDecorated.notice( "Testing: '$( $item.theInput.theSource )'" )

    # Creates the source path
    try {
        [Path] $pSource = [Path]::new( $item.theInput.theSource )
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

    # Creates contig
    try {
        [Contig] $pContig = [Contig]::new( $pSource, $pStub )
        $pWriterDecorated.notice( [string]$pContig )
    } catch {
        $pWriterDecorated.exception( "Exception raised when creating Exec\Contig:  $_" )
        Exit
    }

    # Run
    [bool] $bRun = $false
    try {
        $bRun = $pContig.run()
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

    [int] $iExitCode = $pContig.getExitCode()
    $sBuffer = "`tExitCode: $iExitCode => $( $item.theExpected.theExitCode )"
    if( $iExitCode -eq $item.theExpected.theExitCode ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    $pContig = $null
    $pStub = $null
    $pSource = $null

}

$ErrorActionPreference = "Continue"

Set-StrictMode -Off
