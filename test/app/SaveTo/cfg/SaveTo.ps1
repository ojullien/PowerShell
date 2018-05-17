<#PSScriptInfo

.VERSION 1.2.0

.GUID fb32ddde-0003-4bb7-b887-81ba392263df

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
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 SaveTo data set

#>

Function New-TestSaveToObject( $theInput, $expected ) {
    New-Object -TypeName PsObject -Property @{
        theInput = $theInput
        theExpected = $expected }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestSaveToObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp';
        theAdapterStubExitCode = @{robocopy=0;contig=0}} `
    @{ theRobocopy = @{exitcode=0;value=$true};
        theContig = @{exitcode=0;value=$true};
        theException = $false }

$aTestDataCollection += New-TestSaveToObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp';
        theAdapterStubExitCode = @{robocopy=3;contig=1}} `
    @{ theRobocopy = @{exitcode=3;value=$true};
        theContig = @{exitcode=1;value=$false};
        theException = $false }

$aTestDataCollection += New-TestSaveToObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp';
        theAdapterStubExitCode = @{robocopy=10;contig=0}} `
    @{ theRobocopy = @{exitcode=10;value=$false};
        theContig = @{exitcode=0;value=$true};
        theException = $false }

$aTestDataCollection += New-TestSaveToObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\DoesnotExist';
        theAdapterStubExitCode = @{robocopy=0;contig=0}} `
    @{ theRobocopy = @{exitcode=0;value=$false};
        theContig = @{exitcode=0;value=$true};
        theException = $true }

$aTestDataCollection += New-TestSaveToObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'NODATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp';
        theAdapterStubExitCode = @{robocopy=0;contig=0}} `
    @{ theRobocopy = @{exitcode=0;value=$false};
        theContig = @{exitcode=0;value=$true};
        theException = $true }

$aTestDataCollection += New-TestSaveToObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'NOOS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp';
        theAdapterStubExitCode = @{robocopy=0;contig=0}} `
    @{ theRobocopy = @{exitcode=0;value=$false};
        theContig = @{exitcode=0;value=$true};
        theException = $true }

$aTestDataCollection += New-TestSaveToObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'doesnotexist' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp';
        theAdapterStubExitCode = @{robocopy=0;contig=0}} `
    @{ theRobocopy = @{exitcode=0;value=$false};
        theContig = @{exitcode=0;value=$true};
        theException = $true }

$aTestDataCollection += New-TestSaveToObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'X:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp';
        theAdapterStubExitCode = @{robocopy=0;contig=0}} `
    @{ theRobocopy = @{exitcode=0;value=$false};
        theContig = @{exitcode=0;value=$true};
        theException = $true }
