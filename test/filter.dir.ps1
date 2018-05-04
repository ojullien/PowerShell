<#PSScriptInfo

.VERSION 1.1.0

.GUID 8c6b4039-3915-45f5-90ad-1b9bc864dd23

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\Writer, sys\Filter

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Powershell Version: 5.1
.NET Framework 4.7

#>

<#

.DESCRIPTION
 Filter\Dir tests

#>

Param(
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

try {
    $pWriter = [Writer]::new()
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
# Load Filter\Dir files
# -----------------------------------------------------------------------------
. ("$m_DIR_SCRIPT\test\sys\Filter\dir.ps1")
. ("$m_DIR_SYS\inc\Filter\FilterAbstract.ps1")
. ("$m_DIR_SYS\inc\Filter\Dir.ps1")

try {
    $pDir = [Dir]::new()
}
catch {
    $pWriter.error( "ERROR: Cannot load Filter\Dir module: $_" )
    Exit
}

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------
foreach( $item in $aTestDataCollection ) {

    $pWriter.separateLine()
    $pWriter.notice( "Testing: '$( $item.thePath )'" )

    try {

        $pWriter.noticel( "`tisValid: " )
        $result = $pDir.isValid( $item.thePath )
        if( $result -eq $item.isValid ) {
            $pWriter.success( "got: $result, expected:  $( $item.isValid )" )
        } else {
            $pWriter.error( "got: $result, expected:  $( $item.isValid )" )
        }

    } catch {

        if( "Exception" -eq $item.isValid ) {
            $pWriter.success( "got: Exception, expected:  $( $item.isValid )" )
        } else {
            $pWriter.error( "got: Exception, expected:  $( $item.isValid )" )
        }
    }

    try {

        $pWriter.noticel( "`texists: " )
        $result = $pDir.exists( $item.thePath )
        if( $result -eq $item.exists ) {
            $pWriter.success( "got: $result, expected:  $( $item.exists )" )
        } else {
            $pWriter.error( "got: $result, expected:  $( $item.exists )" )
        }

    } catch {

        if( "Exception" -eq $item.exists ) {
            $pWriter.success( "got: Exception, expected:  $( $item.exists )" )
        } else {
            $pWriter.error( "got: Exception, expected:  $( $item.exists )" )
        }
    }

    try {

        $pWriter.noticel( "`tdoFilter: " )
        $result = $pDir.doFilter( $item.thePath )
        if( $result -eq $item.doFilter ) {
            $pWriter.success( "got: $result, expected:  $( $item.doFilter )" )
        } else {
            $pWriter.error( "got: $result, expected:  $( $item.doFilter )" )
        }

    } catch {

        if( "Exception" -eq $item.doFilter ) {
            $pWriter.success( "got: Exception, expected:  $( $item.doFilter )" )
        } else {
            $pWriter.error( "got: Exception, expected:  $( $item.doFilter )" )
        }
    }

}

$ErrorActionPreference = "Continue"

Set-StrictMode -Off
