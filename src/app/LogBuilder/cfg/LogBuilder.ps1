<#PSScriptInfo

.VERSION 1.2.0

.GUID e5f0d849-0004-4c6a-b731-2b6bc8364595

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Build-Log App Configuration file

#>

[bool] $appReady = $true
[bool] $appConfirmed = $false

# Trace
$pWriter.separateLine()
$pWriter.notice( "App configuration" )
$pWriter.noticel( "`tDomains: " )
$pWriter.notice( [string] $( $appDomains -join ', ' ) )
$pWriter.notice( "`tExtract archives from " + "`'$($appArchivesInputDir)`'"  + " to " + "`'$($appArchivesOutputDir)`'." )
$pWriter.notice( "`tProcess logs from " + "`'$($appInputLogDir)`'"  + " to " + "`'$($appOutputLogDir)`'." )

# Check path
[Path] $pFilterPath = [Path]::new()
[Dir] $pFilterDir = [Dir]::new()

foreach( $item in @( $appInputLogDir, $appOutputLogDir ) ) {
    if( $pFilterPath.isValid( $item ) ){
        if( ! $pFilterDir.exists( $pFilterPath ) ){
            new-item -Name $item -ItemType Directory -Force | Out-Null
            $pWriter.notice( "`tCreating: " + "`'$($item)`'." )
        }
    } else {
        $pWriter.errot( "`tPath is not valid: " + "`'$($item)`'." )
        $appReady =$false
    }
}

foreach( $sDomain in $appDomains ) {
    if( $pFilterPath.isValid( "$appOutputLogDir\$sDomain" ) ){
        if( ! $pFilterDir.exists( $pFilterPath ) ){
            new-item -Path $appOutputLogDir -Name $sDomain -ItemType Directory -Force | Out-Null
            $pWriter.notice( "`tCreating: " + "`'$appOutputLogDir" + [System.IO.Path]::DirectorySeparatorChar + "$sDomain`'." )
        }
    } else {
        $pWriter.errot( "`tPath is not valid: " + "`'$appOutputLogDir" + [System.IO.Path]::DirectorySeparatorChar + "$sDomain`'." )
        $appReady =$false
    }
}

$pFilterPath = $null
$pFilterDir = $null

# App ready
if( -not $appReady ){
    $pWriter.notice( "Aborting ..." )
    Exit
}

# Ask for confirmation
$pWriter.noticel( "The app is ready." )
if( -Not $bequiet.IsPresent ) {
    $pWriter.notice( " Would you like to continue? (Default is No)" )
    $Readhost = Read-Host "[y/n]"
    Switch( $ReadHost ) {
        Y { $pWriter.notice( "Yes, Processing ...") ; $appConfirmed = $true }
        N { $pWriter.notice( "No, Aborting ...") ; $appConfirmed = $false }
        Default { $pWriter.notice( "Default, Aborting ...") ; $appConfirmed = $false }
    }
} else {
    $appConfirmed = $true
}

# Confirmation
if( -not $appConfirmed ) {
    Exit
}
