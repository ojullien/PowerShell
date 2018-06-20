<#PSScriptInfo

.VERSION 1.3.0

.GUID 944d5dbd-0002-4efd-85e2-3a51548593d3

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
 7-Zip data set

#>

Function New-TestExec7ZipObject( $theInput, $expected ) {
    New-Object -TypeName PsObject -Property @{
        theInput = $theInput
        theExpected = $expected }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestExec7ZipObject `
    @{ theArchive = "$m_DIR_TEST_SYS\inc\Exec\7-Zip.7z";
        theOutputDir = "C:\Temp";
        theExtractOptions = @{ withfullpaths=$false;file='';recurse=$false;}
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theExtract = $true;
        theException = $false }

$aTestDataCollection += New-TestExec7ZipObject `
    @{ theArchive = "$m_DIR_TEST_SYS\inc\Exec\7-Zip.7z";
        theOutputDir = "C:\Temp";
        theExtractOptions = @{ withfullpaths=$false;file='';recurse=$false;}
        theAdapterStubExitCode = 2 } `
    @{ theExitCode = 2;
        theExtract = $false;
        theException = $false }

$aTestDataCollection += New-TestExec7ZipObject `
    @{ theArchive = "$m_DIR_TEST_SYS\inc\Exec\doesnotexist.7z";
        theOutputDir = "C:\Temp";
        theExtractOptions = @{ withfullpaths=$false;file='';recurse=$false;}
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theExtract = $true;
        theException = $true }

$aTestDataCollection += New-TestExec7ZipObject `
    @{ theArchive = "$m_DIR_TEST_SYS\inc\Exec\7-Zip.7z";
        theOutputDir = "C:\Doesnotexist";
        theExtractOptions = @{ withfullpaths=$false;file='';recurse=$false;}
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theExtract = $true;
        theException = $true }
