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

.REQUIREDSCRIPTS src\sys\inc\Exec\Program.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Exec\Program tests

#>

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

$pWriterDecorated.separateLine()
$pWriterDecorated.notice( 'Testing: setProgramPath($null)' )

try {
    $null = [Program]::new().setProgramPath($null)
    $pWriterDecorated.error( 'setProgramPath shall raised an exception' )
} catch {
    $pWriterDecorated.exceptionExpected( "setProgramPath raised an expected exception:  $_" )
}

$pWriterDecorated.separateLine()
$pWriterDecorated.notice( 'Testing: setProgramPath( "does\not\exist" )' )

try {
    $null = [Program]::new().setProgramPath( [Path]::new( 'C:\Program Files\PowerShell\6.0.2\doesnotexist.exe' ) )
    $pWriterDecorated.error( 'setProgramPath shall raised an exception' )
} catch {
    $pWriterDecorated.exceptionExpected( "setProgramPath raised an expected exception:  $_" )
}

$pWriterDecorated.separateLine()
$pWriterDecorated.notice( 'Testing: addArgument( $null )' )

try {
    $null = [Program]::new().addArgument( $null )
    $pWriterDecorated.error( 'addArgument shall raised an exception' )
} catch {
    $pWriterDecorated.exceptionExpected( "addArgument raised an expected exception:  $_" )
}

$pWriterDecorated.separateLine()
$pWriterDecorated.notice( 'Testing: addArgument( " " )' )

try {
    $null = [Program]::new().addArgument( " " )
    $pWriterDecorated.error( 'addArgument shall raised an exception' )
} catch {
    $pWriterDecorated.exceptionExpected( "addArgument raised an expected exception:  $_" )
}

$pWriterDecorated.separateLine()
$pWriterDecorated.notice( 'Testing: setArgument( $null )' )

try {
    $null = [Program]::new().setArgument( $null )
    $pWriterDecorated.error( 'setArgument shall raised an exception' )
} catch {
    $pWriterDecorated.exceptionExpected( "setArgument raised an expected exception:  $_" )
}

$pWriterDecorated.separateLine()
[string[]]$aArguments = @( '-h', '-nol' )
[string]$sArguments = $aArguments -join ' '
[string]$sProgramPath = 'C:\Program Files\PowerShell\6.0.2\pwsh.exe'
$pWriterDecorated.notice( "Testing: `"$sProgramPath $sArguments`"" )

try {
    $pPath = [Program]::new().setProgramPath( [Path]::new( $sProgramPath ) ).addArgument( '-h' ).setArgument( $aArguments )
} catch {
    $pWriterDecorated.exception( "[Program]::new() raised an exception:  $_" )
    Exit
}

[string]$sResult = $pPath.getProgramPath()
$sBuffer = "`tgetProgramPath: '$sResult' => '$sProgramPath'"
if( $sResult -eq $sProgramPath ) {
    $pWriterDecorated.success( $sBuffer )
} else {
    $pWriterDecorated.error( $sBuffer )
}

$sResult = $pPath.getArgument()
$sBuffer = "`tgetArgument: '$sResult' => '$sArguments'"
if( $sResult -eq $sArguments ) {
    $pWriterDecorated.success( $sBuffer )
} else {
    $pWriterDecorated.error( $sBuffer )

}

[string[]]$aResult = $pPath.getArguments()
$sBuffer = "`tgetArguments: '$aResult' => '$aArguments'"
if( $( $aResult -join ' ' ) -eq $sArguments ) {
    $pWriterDecorated.success( $sBuffer )
} else {
    $pWriterDecorated.error( $sBuffer )

}

#[string]$pPath
$pPath = $null
