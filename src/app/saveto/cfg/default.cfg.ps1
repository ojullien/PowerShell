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

.REQUIREDSCRIPTS sys

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180409
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 Default save-to configuration file

#>

[CDrive] $pSource = [CDrive]::new().setDriveLetter("C:").setVolumeLabel("OS")
[CDrive] $pDestination = [CDrive]::new().setDriveLetter("C:").setSubFolder('Temp').setVolumeLabel("OS")
[string[]] $aLISTDIR = "dir1", "dir2"