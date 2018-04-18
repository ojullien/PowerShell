<#PSScriptInfo

.VERSION 1.0.0

.GUID eb469c31-a887-43d2-8148-42f1d026ac74

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
 save-to F220 Configuration file

#>

[CDrive] $pSource = [CDrive]::new( "H:", "HITACHI 250Go", "250Go" )
[CDrive] $pDestination = [CDrive]::new( "K:", "FUJISTU 220Go", "220Go" )
[string[]] $aLISTDIR = "Games", "Systems", "Sport"