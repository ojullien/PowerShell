<#PSScriptInfo

.VERSION 1.2.0

.GUID 7740eb76-0001-4413-9707-abd5bdcf0fc9

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer, src\sys\inc\Exec\Program.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Exec\Program tests

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
# Load Exec\Program file
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Exec\Program.ps1")

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

# none

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

$pWriter.separateLine()
$pWriter.notice( 'Testing: setProgramPath($null)' )

try {
    $null = [Program]::new().setProgramPath($null)
    $pWriter.error( 'setProgramPath shall raised an exception' )
} catch {
    $pWriter.exceptionExpected( "setProgramPath raised an expected exception:  $_" )
}

$pWriter.separateLine()
$pWriter.notice( 'Testing: setProgramPath( "does\not\exist" )' )

try {
    $null = [Program]::new().setProgramPath( [Path]::new( 'C:\Program Files\PowerShell\6.0.2\doesnotexist.exe' ) )
    $pWriter.error( 'setProgramPath shall raised an exception' )
} catch {
    $pWriter.exceptionExpected( "setProgramPath raised an expected exception:  $_" )
}

$pWriter.separateLine()
$pWriter.notice( 'Testing: addArgument( $null )' )

try {
    $null = [Program]::new().addArgument( $null )
    $pWriter.error( 'addArgument shall raised an exception' )
} catch {
    $pWriter.exceptionExpected( "addArgument raised an expected exception:  $_" )
}

$pWriter.separateLine()
$pWriter.notice( 'Testing: addArgument( " " )' )

try {
    $null = [Program]::new().addArgument( " " )
    $pWriter.error( 'addArgument shall raised an exception' )
} catch {
    $pWriter.exceptionExpected( "addArgument raised an expected exception:  $_" )
}

$pWriter.separateLine()
$pWriter.notice( 'Testing: setArgument( $null )' )

try {
    $null = [Program]::new().setArgument( $null )
    $pWriter.error( 'setArgument shall raised an exception' )
} catch {
    $pWriter.exceptionExpected( "setArgument raised an expected exception:  $_" )
}

$pWriter.separateLine()
[string[]]$aArguments = @( '-h', '-nol' )
[string]$sArguments = $aArguments -join ' '
[string]$sProgramPath = 'C:\Program Files\PowerShell\6.0.2\pwsh.exe'
$pWriter.notice( "Testing: `"$sProgramPath $sArguments`"" )

try {
    $pPath = [Program]::new().setProgramPath( [Path]::new( $sProgramPath ) ).addArgument( '-h' ).setArgument( $aArguments )
} catch {
    $pWriter.exception( "[Program]::new() raised an exception:  $_" )
    Exit
}

[string]$sResult = $pPath.getProgramPath()
$sBuffer = "`tgetProgramPath: '$sResult' => '$sProgramPath'"
if( $sResult -eq $sProgramPath ) {
    $pWriter.success( $sBuffer )
} else {
    $pWriter.error( $sBuffer )
}

$sResult = $pPath.getArgument()
$sBuffer = "`tgetArgument: '$sResult' => '$sArguments'"
if( $sResult -eq $sArguments ) {
    $pWriter.success( $sBuffer )
} else {
    $pWriter.error( $sBuffer )

}

[string[]]$aResult = $pPath.getArguments()
$sBuffer = "`tgetArguments: '$aResult' => '$aArguments'"
if( $( $aResult -join ' ' ) -eq $sArguments ) {
    $pWriter.success( $sBuffer )
} else {
    $pWriter.error( $sBuffer )

}

#[string]$pPath
$pPath = $null

$ErrorActionPreference = "Continue"

Set-StrictMode -Off
