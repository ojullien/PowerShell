<#PSScriptInfo

.VERSION 1.2.0

.GUID 54ebf841-0001-46f2-ad7c-0e5dd86eeff7

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Filter\Path.ps1, test\sys\inc\Filter\Path-data.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Filter\Path tests

#>


# -----------------------------------------------------------------------------
# Load Filter\Path files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Filter\Path.ps1")

try {
    $pPath = [Path]::new()
}
catch {
    $pWriterDecorated.error( "ERROR: Cannot load Filter\Path module: $_" )
    Exit
}

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

. ("$m_DIR_TEST_SYS\inc\Filter\Path-data.ps1")

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

foreach( $item in $aTestDataCollection ) {

    $pWriterDecorated.separateLine()
    $pWriterDecorated.notice( "Testing: '$( $item.theInput )'" )

    try {
        # isValid use doFilter
        [bool] $bResult = $pPath.isValid( $item.theInput )
    } catch {
        if( $item.theExpected.Exception ) {
            $pWriterDecorated.exceptionExpected( "doFilter raised an expected exception:  $_" )
        } else {
            $pWriterDecorated.exception( "doFilter raised an exception:  $_" )
        }
        continue
    }

    $sBuffer = "`tdirectoryname: '$( $pPath.getDirectoryName() )' => '$( $item.theExpected.directoryname )'"
    if( $pPath.getDirectoryName() -eq $item.theExpected.directoryname ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    $sBuffer = "`tfilename: '$( $pPath.getFilename() )' => '$( $item.theExpected.filename )'"
    if( $pPath.getFilename() -eq $item.theExpected.filename ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    $sBuffer = "`tbasename: '$( $pPath.getBasename() )' => '$( $item.theExpected.basename )'"
    if( $pPath.getBasename() -eq $item.theExpected.basename ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    $sBuffer = "`textension: '$( $pPath.getExtension() )' => '$( $item.theExpected.extension )'"
    if( $pPath.getExtension() -eq $item.theExpected.extension ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    $sBuffer = "`tpathroot: '$( $pPath.getPathRoot() )' => '$( $item.theExpected.pathroot )'"
    if( $pPath.getPathRoot() -eq $item.theExpected.pathroot ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    $sBuffer = "`tisValid: '$([string]$bResult)' => '$( $item.theExpected.isValid )'"
    if( $bResult -eq $item.theExpected.isValid ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

}
