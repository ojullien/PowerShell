<#PSScriptInfo

.VERSION 1.2.0

.GUID 969dc39f-0001-4e61-9cfd-8e8df7ebebf6

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer, src\sys\inc\Filter\Path.ps1, src\sys\inc\Filter\Dir.ps1, test\sys\inc\Filter\Dir.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Filter\Dir tests

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

try {
    $pDir = [Dir]::new()
}
catch {
    $pWriter.error( "ERROR: Cannot load Filter\Dir module: $_" )
    Exit
}

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

. ("$m_DIR_SCRIPT\test\sys\inc\Filter\Dir.ps1")

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

foreach( $item in $aTestDataCollection ) {

    $pWriter.separateLine()
    $pWriter.notice( "Testing: '$( $item.theInput )'" )

    try {
        $pPath = [Path]::new( $item.theInput  )
    }
    catch {
        $pWriter.error( "Cannot load Filter\Path module: $_" )
        Exit
    }

    # isValid

    try {
        # isValid
        [bool] $bResult = $pDir.isValid( $pPath )
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriter.exceptionExpected( "isValid raised an expected exception:  $_" )
        } else {
            $pWriter.exception( "isValid raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`tisValid: '$([string]$bResult)' => '$( $item.theExpected.isValid )'"
    if( $bResult -eq $item.theExpected.isValid ) {
        $pWriter.success( $sBuffer )
    } else {
        $pWriter.error( $sBuffer )
    }

    # exists
    try {
        [bool] $bResult = $pDir.exists( $pPath )
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriter.exceptionExpected( "exists raised an expected exception:  $_" )
        } else {
            $pWriter.exception( "exists raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`texists: '$([string]$bResult)' => '$( $item.theExpected.exists )'"
    if( $bResult -eq $item.theExpected.exists ) {
        $pWriter.success( $sBuffer )
    } else {
        $pWriter.error( $sBuffer )
    }

    # doFilter
    try {
        [string] $result = $pDir.doFilter( $pPath )
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriter.exceptionExpected( "doFilter raised an expected exception:  $_" )
        } else {
            $pWriter.exception( "doFilter raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`tdoFilter: '$result' => '$( $item.theExpected.doFilter )'"
    if( $result -eq $item.theExpected.doFilter ) {
        $pWriter.success( $sBuffer )
    } else {
        $pWriter.error( $sBuffer )
    }

}

$ErrorActionPreference = "Continue"

Set-StrictMode -Off
