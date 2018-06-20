<#PSScriptInfo

.VERSION 1.3.0

.GUID e5f0d849-0005-4c6a-b731-2b6bc8364595

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
Date: 20180620
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Default Build-Log configuration file
 appInputLogDir should contains zip files.
 zip files should contains folder named like log-YYYYMMDD.zip
 log-YYYYMMDD folder should contains var/log/apache2/<domain>/access.log file.
#>

[string[]] $appDomains = @( 'domain1', 'domain2')
[string] $appInputLogDir = 'C:\input'
[string] $appOutputLogDir = 'C:\output'
[string] $appArchivesInputDir = "C:\archives\*.zip"
[string] $appArchivesOutputDir = "$appInputLogDir\*"

# You may write some command here. The code will be executed before the main process.
