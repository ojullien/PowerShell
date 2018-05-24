<#PSScriptInfo

.VERSION 1.2.0

.GUID 944d5dbd-0004-4efd-85e2-3a51548593d3

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
 7-Zip data set

#>

Function New-TestExec7ZipMoreObject( $theInput, $expected ) {
    New-Object -TypeName PsObject -Property @{
        theInput = $theInput
        theExpected = $expected }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestExec7ZipMoreObject `
    @{ theArchive = "$m_DIR_TEST_SYS\inc\Exec\7-Zip.7z";
        theOutputDir = "C:\Temp";
        theExtractOptions = @{ withfullpaths=$false;file='';recurse=$false;} } `
    @{ theExitCode = 0;
        theExtract = $true;
        theException = $false }

$aTestDataCollection += New-TestExec7ZipMoreObject `
    @{ theArchive = "$m_DIR_TEST_SYS\inc\Exec\7-Zip.7z";
        theOutputDir = "C:\Temp";
        theExtractOptions = @{ withfullpaths=$true;file='';recurse=$false;} } `
    @{ theExitCode = 0;
        theExtract = $true;
        theException = $false }
