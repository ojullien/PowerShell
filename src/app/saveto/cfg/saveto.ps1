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

$pWriter.separateLine()
$pWriter.notice( "App configuration" )
[bool] $appDrivesReady = $true

foreach( $item in $appDrivesCollection ) {
    $pWriter.noticel( "`tFrom '" + "`'$($item.theSource)`'"  + " on " + "`'$($item.theSourceLabel)`'" + " to " + "`'$($item.theDestination)`'" + " on " + "`'$($item.theDestinationLabel)`'." )
    if( -not [Dir]::new().exists( $item.theSource ) ) {
        $pWriter.error( "source is missing" )
        $appDrivesReady = $false
    }
}

if( ($appDrivesCollection.count -eq 0) -or ( -not $appDrivesReady ) ){
    $pWriter.notice( "Aborting ..." )
    Exit
}
