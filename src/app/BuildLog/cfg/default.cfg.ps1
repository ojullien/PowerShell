<#PSScriptInfo

.VERSION 1.2.0

.GUID fe85499f-0002-4ceb-931f-2831b75e3b2d

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Default save-to configuration file

#>

[hashtable[]] $appDrivesCollection = @(
    @{ theSource = 'C:\dir1'; theSourceLabel = 'OS'; theDestination = 'C:\Temp\dir1'; theDestinationLabel = 'OS' },
    @{ theSource = 'C:\dir2'; theSourceLabel = 'OS'; theDestination = 'C:\Temp\dir2'; theDestinationLabel = 'OS' }
)
