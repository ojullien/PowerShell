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
[CValidator]::checkDir( [Object] $pWriter, "`tSource: $pSource ", $pSource.getCheckDir() ) > $null
[CValidator]::checkDir( [Object] $pWriter, "`tDestination: $pDestination ", $pDestination.getCheckDir() ) > $null
$pWriter.noticel( "`tList directories: " )
foreach( $sDir in $aLISTDIR) {
    $pWriter.noticel( "$sDir " )
}
$pWriter.notice( "" )