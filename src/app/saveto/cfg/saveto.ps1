<#PSScriptInfo

.VERSION 1.3.0

.GUID 5a516eab-0007-4f39-82f9-f12d189bf98d

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
Date: 20180620
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
[bool] $appConfirmed = $false

# Trace
[Drive] $pSource = $null
[Drive] $pDestination = $null
foreach( $item in $appDrivesCollection ) {
    [Drive] $pSource = [Drive]::new( $item.theSource, $item.theSourceLabel )
    [Drive] $pDestination = [Drive]::new( $item.theDestination, $item.theDestinationLabel )
    $pWriter.noticel( "`tFrom " + "`'$($item.theSource)`'"  + " on " + "`'$($item.theSourceLabel)`'" + " to " + "`'$($item.theDestination)`'" + " on " + "`'$($item.theDestinationLabel)`'." )
    if( !$pSource.isReady() -or !$pSource.testPath()  ) {
        $pWriter.error( "source is missing" )
        $appDrivesReady = $false
    } elseif( !$pDestination.isReady() ) {
        $pWriter.error( "destination is not ready" )
        $appDrivesReady = $false
    } else {
        $pWriter.notice("")
    }
}
$pSource = $null
$pDestination = $null

# Check drives
if( ($appDrivesCollection.count -eq 0) -or ( -not $appDrivesReady ) ){
    $pWriter.notice( "Aborting ..." )
    Exit
}

# Ask for confirmation
$pWriter.noticel( "All drives are ready." )
if( -Not $bequiet.IsPresent ) {
    $pWriter.notice( " Would you like to continue? (Default is No)" )
    $Readhost = Read-Host "[y/n]"
    Switch( $ReadHost ) {
        Y { $pWriter.notice( "Yes, Saving ...") ; $appConfirmed = $true }
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
