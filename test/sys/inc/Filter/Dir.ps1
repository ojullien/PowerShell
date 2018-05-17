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

.REQUIREDSCRIPTS src\sys\inc\Filter\Dir.ps1, test\sys\inc\Filter\Dir-data.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Filter\Dir tests

#>

# -----------------------------------------------------------------------------
# Load Filter\Dir
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Filter\Dir.ps1")

try {
    $pDir = [Dir]::new()
}
catch {
    $pWriterDecorated.error( "ERROR: Cannot load Filter\Dir module: $_" )
    Exit
}

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

. ("$m_DIR_TEST_SYS\inc\Filter\Dir-data.ps1")

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

foreach( $item in $aTestDataCollection ) {

    $pWriterDecorated.separateLine()
    $pWriterDecorated.notice( "Testing: '$( $item.theInput )'" )

    try {
        $pPath = [Path]::new( $item.theInput  )
    }
    catch {
        $pWriterDecorated.error( "Cannot load Filter\Path module: $_" )
        Exit
    }

    # isValid

    try {
        # isValid
        [bool] $bResult = $pDir.isValid( $pPath )
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriterDecorated.exceptionExpected( "isValid raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "isValid raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`tisValid: '$([string]$bResult)' => '$( $item.theExpected.isValid )'"
    if( $bResult -eq $item.theExpected.isValid ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    # exists
    try {
        [bool] $bResult = $pDir.exists( $pPath )
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriterDecorated.exceptionExpected( "exists raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "exists raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`texists: '$([string]$bResult)' => '$( $item.theExpected.exists )'"
    if( $bResult -eq $item.theExpected.exists ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    # doFilter
    try {
        [string] $result = $pDir.doFilter( $pPath )
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriterDecorated.exceptionExpected( "doFilter raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "doFilter raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`tdoFilter: '$result' => '$( $item.theExpected.doFilter )'"
    if( $result -eq $item.theExpected.doFilter ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

}
