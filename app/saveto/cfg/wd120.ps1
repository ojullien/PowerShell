<#PSScriptInfo

.VERSION 1.0.0

.GUID 519bda70-b405-4bab-8f15-de6ce8e74deb

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
 save-to WD120 Configuration file

#>

[CDrive] $pSource = [CDrive]::new( "H:", "HITACHI 250Go", "250Go" )
[CDrive] $pDestination = [CDrive]::new( "J:", "WD PASSPORT 120Go", "120Go" )
[string[]] $aLISTDIR = "Docs", "Work", "Ebook", "Design", "Code", "Soft", "Drivers"