<#PSScriptInfo

.VERSION 1.2.0

.GUID cb98663e-0002-4ceb-92ad-36e9f1eaf33b

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

Function New-TestExecAdapterObject( $theInput, $expected ) {
    New-Object -TypeName PsObject -Property @{
        theInput = $theInput
        theExpected = $expected }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestExecAdapterObject @{ theProgram = 'C:\Program Files\SysinternalsSuite\hex2dec.exe'; theArgs = @( '-nobanner' ) } @{ theExitCode = -1; theException = $false }
$aTestDataCollection += New-TestExecAdapterObject @{ theProgram = 'C:\Program Files\SysinternalsSuite\hex2dec.exe'; theArgs = @( '-nobanner', '1234' ) } @{ theExitCode = 1234; theException = $false }
$aTestDataCollection += New-TestExecAdapterObject @{ theProgram = 'C:\Windows\System32\ping.exe'; theArgs = @( '-n', 1, 'google.fr' ) } @{ theExitCode = 0; theException = $false }
$aTestDataCollection += New-TestExecAdapterObject @{ theProgram = 'C:\Windows\System32\ping.exe'; theArgs = @( '-n', 1, 'googldddd.fr' ) } @{ theExitCode = 1; theException = $false }
