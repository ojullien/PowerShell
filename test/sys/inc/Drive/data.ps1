<#PSScriptInfo

.VERSION 1.2.0

.GUID fb32ddde-0002-4bb7-b887-81ba392263df

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
 Drive data set

#>

Function New-TestDriveDriveObject( $theInput, $expected ) {
    New-Object -TypeName PsObject -Property @{
        theInput = $theInput
        theExpected = $expected }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestDriveDriveObject @{ thePath = 'C:\Program Files\PowerShell\6.0.2'; label = 'OS' } @{ driveletter = 'C:'; subfolder = 'Program Files\PowerShell\6.0.2'; volumelabel = "OS"; testPath = $true; isReady = $true; Exception = $false }
$aTestDataCollection += New-TestDriveDriveObject @{ thePath = 'C:\Program Files\PowerShell\6.0.2'; label = 'Invalid label' } @{ driveletter = 'C:'; subfolder = 'Program Files\PowerShell\6.0.2'; volumelabel = "Invalid label"; testPath = $true; isReady = $false; Exception = $false }
$aTestDataCollection += New-TestDriveDriveObject @{ thePath = 'D:\does\not\exist'; label = 'DATA' } @{ driveletter = 'D:'; subfolder = 'does\not\exist'; volumelabel = "DATA"; testPath = $false; isReady = $true; Exception = $false }
