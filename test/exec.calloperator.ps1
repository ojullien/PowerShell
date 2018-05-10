<#PSScriptInfo

.VERSION 1.2.0

.GUID cb98663e-0002-4ceb-92ad-36e9f1eaf33b

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer, src\sys\inc\Exec\Adapter\CallOperator.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Exec\Adapter\CallOperator tests

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
. ("$m_DIR_SYS\inc\Filter\File.ps1")

# -----------------------------------------------------------------------------
# Load Exec file
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Exec\Program.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\Abstract.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\CallOperator.ps1")

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

[string]$sProgramPath =  'C:\Program Files\SysinternalsSuite\hex2dec.exe'
[string[]]$aProgramArgCollection = @( '-nobanner' )

# ------------------------------------------------------------------------------
# Test 01
# ------------------------------------------------------------------------------

$pWriter.separateLine()
$pWriter.notice( "Testing: $sProgramPath $( $aProgramArgCollection -join ' ' )" )

try {
    [Path] $pPath = [path]::new( $sProgramPath )
    [Program] $pProgram = [Program]::new().setProgramPath( $pPath ).setArgument( $aProgramArgCollection )
    [CallOperator] $pProcess = [CallOperator]::new()
    $null = $pProcess.setProgram( $pProgram )
} catch {
    $pWriter.exception( "Exception raised when creating Filter\Path, Exec\Program or Exec\CallOperator:  $_" )
    Exit
}

try {
    [int] $iExitCode = $pProcess.saveOutput().run()
} catch {
    $pWriter.exception( "run() raised an exception:  $_" )
}

[string]$sBuffer = "`tExitCode: $iExitCode => -1"
if( $iExitCode -eq '-1' ) {
    $pWriter.success( $sBuffer )
} else {
    $pWriter.error( $sBuffer )
}

$pWriter.notice( $pProcess.getOutput() )

# ------------------------------------------------------------------------------
# Test 02
# ------------------------------------------------------------------------------

$pWriter.separateLine()
$pWriter.notice( "Testing: $sProgramPath $( $aProgramArgCollection -join ' ' ) 1234" )

try {
    $null = $pProgram.setArgument( $aProgramArgCollection ).addArgument( '1234' )
    $null = $pProcess.setProgram( $pProgram )
} catch {
    $pWriter.exception( "Exception raised when Exec\Program::setArgument() or Exec\CallOperator::setProgram:  $_" )
    Exit
}

try {
    $iExitCode = $pProcess.saveOutput().run()
} catch {
    $pWriter.exception( "run() raised an exception:  $_" )
}

$sBuffer = "`tExitCode: $iExitCode => 1234"
if( $iExitCode -eq '1234' ) {
    $pWriter.success( $sBuffer )
} else {
    $pWriter.error( $sBuffer )
}
$pWriter.notice( $pProcess.getOutput() )

$pProcess = $null
$pProgram = $null
$pPath = $null

$ErrorActionPreference = "Continue"

Set-StrictMode -Off
