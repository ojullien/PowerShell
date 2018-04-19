<#PSScriptInfo

.VERSION 1.0.0

.GUID c903f328-a3bd-4473-82d3-61ee784e41c9

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
Date: 20180409
Powershell Version: 5.1

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
    $sPath = $pSource.getDriveLetter() + "\" + $pSource.getSubFolder() + "\" + $sDir
    if( ! $( Test-Path -LiteralPath $sPath -PathType Container )) {
        $pWriter.noticel( "(!is missing) " )
    }
}
$pWriter.notice( "" )