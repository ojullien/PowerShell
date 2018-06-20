<#PSScriptInfo

.VERSION 1.3.0

.GUID 7b2e6c14-0002-4ed3-8989-eb37f25c0f8e

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
 Contig data set

#>

Function New-TestExecContigObject( $theInput, $expected ) {
    New-Object -TypeName PsObject -Property @{
        theInput = $theInput
        theExpected = $expected }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestExecContigObject `
    @{ theSource = 'C:\Windows';
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theRun = $true;
        theException = $false }

$aTestDataCollection += New-TestExecContigObject `
    @{ theSource = 'C:\doesnotexist';
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theRun = $false;
        theException = $true }

$aTestDataCollection += New-TestExecContigObject `
    @{ theSource = 'C:\Windows';
        theAdapterStubExitCode = 10 } `
    @{ theExitCode =10;
        theRun = $false;
        theException = $true }
