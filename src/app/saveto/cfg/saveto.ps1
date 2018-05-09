<#PSScriptInfo

.VERSION 1.2.0

.GUID 5a516eab-0007-4f39-82f9-f12d189bf98d

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys,app\saveto

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 save-to App Configuration file

#>

# -----------------------------------------------------------------------------
# Trace
# -----------------------------------------------------------------------------
$pWriter.separateLine()

$pWriter.notice( "App configuration" )
$pWriter.noticel( "`tSource: $pSource " )
if( $pSource.testPath() -and $pSource.isReady() ) {
    $pWriter.success( "exists" )
} else {
    $pWriter.error( "is missing" )
}

$pWriter.noticel( "`tDestination: $pDestination " )
if( $pDestination.testPath() -and $pDestination.isReady() ) {
    $pWriter.success( "exists" )
} else {
    $pWriter.error( "is missing" )
}

$pWriter.noticel( "`tList directories: " )
foreach( $sDir in $aLISTDIR) {
    $pWriter.noticel( "$sDir " )
    if( ! [Dir]::new().exists( [Path]::new( $pSource.getDriveLetter() + [System.IO.Path]::DirectorySeparatorChar + $pSource.getSubFolder() + [System.IO.Path]::DirectorySeparatorChar + $sDir ) )) {
        $pWriter.noticel( "(!is missing) " )
    }
}
$pWriter.notice( "" )
