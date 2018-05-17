<#PSScriptInfo

.VERSION 1.2.0

.GUID b0bbf184-0002-4937-b331-cf11ea6906f3

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
 SystemDiagnosticsProcess data set

#>

Function New-TestExecRobocopyObject( $theInput, $expected ) {
    New-Object -TypeName PsObject -Property @{
        theInput = $theInput
        theExpected = $expected }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestExecRobocopyObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp\robocopy_dell.log';
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theRun = $true;
        theException = $false }

$aTestDataCollection += New-TestExecRobocopyObject `
    @{ theSource = @{ theDrive = 'X:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp\robocopy_dell.log';
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theRun = $false;
        theException = $true }

$aTestDataCollection += New-TestExecRobocopyObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'X:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp\robocopy_dell.log';
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theRun = $false;
        theException = $true }

$aTestDataCollection += New-TestExecRobocopyObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'NOTVALID'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp\robocopy_dell.log';
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theRun = $false;
        theException = $true }

$aTestDataCollection += New-TestExecRobocopyObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'NOTVALID'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp\robocopy_dell.log';
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theRun = $false;
        theException = $true }

$aTestDataCollection += New-TestExecRobocopyObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'doesnotexist' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp\robocopy_dell.log';
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theRun = $false;
        theException = $true }

$aTestDataCollection += New-TestExecRobocopyObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\doesnotexist' };
        theLog = 'C:\Temp\robocopy_dell.log';
        theAdapterStubExitCode = 0 } `
    @{ theExitCode = 0;
        theRun = $false;
        theException = $true }

$aTestDataCollection += New-TestExecRobocopyObject `
    @{ theSource = @{ theDrive = 'C:'; theLabel = 'OS'; theDirectory = 'dell' };
        theDestination = @{ theDrive = 'D:'; theLabel = 'DATA'; theDirectory = 'temp\Transcoded Files Cache\dell' };
        theLog = 'C:\Temp\robocopy_dell.log';
        theAdapterStubExitCode = 10 } `
    @{ theExitCode = 10;
        theRun = $false;
        theException = $false }
