<#PSScriptInfo

.VERSION 1.2.0

.GUID 54ebf841-0002-46f2-ad7c-0e5dd86eeff7

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
 Path data set

#>

Function New-TestFilterPathObject( $path, $expected ) {
    New-Object -TypeName PsObject -Property @{
        theInput = $path
        theExpected = $expected }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestFilterPathObject 'C:\does\not\exist\readme.txt' @{ directoryname = 'does\not\exist'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; pathroot =  'C:'; isValid = $true; Exception = $false}
$aTestDataCollection += New-TestFilterPathObject 'C:\does\not\exist\readme' @{ directoryname = 'does\not\exist'; filename = 'readme'; basename =  'readme'; extension =  ''; pathroot =  'C:'; isValid = $true; Exception = $false}
$aTestDataCollection += New-TestFilterPathObject 'C:\does\not\exist\.txt' @{ directoryname = 'does\not\exist'; filename = '.txt'; basename =  ''; extension =  '.txt'; pathroot =  'C:'; isValid = $true; Exception = $false}
$aTestDataCollection += New-TestFilterPathObject 'C:\readme.txt' @{ directoryname = ''; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; pathroot =  'C:'; isValid = $true; Exception = $false}
$aTestDataCollection += New-TestFilterPathObject 'C:\readme' @{ directoryname = ''; filename = 'readme'; basename =  'readme'; extension =  ''; pathroot =  'C:'; isValid = $true; Exception = $false}
$aTestDataCollection += New-TestFilterPathObject 'C:\.txt' @{ directoryname = ''; filename = '.txt'; basename =  ''; extension =  '.txt'; pathroot =  'C:'; isValid = $true; Exception = $false}

if( $PSVersionTable.PSVersion.Major -eq 6 ) {
    $aTestDataCollection += New-TestFilterPathObject 'C:\does\not\ex"st\readme.txt' @{ directoryname = 'does\not\ex"st'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; pathroot =  'C:'; isValid = $false; Exception = $false}
    $aTestDataCollection += New-TestFilterPathObject 'C:\does\not\ex<st\readme.txt' @{ directoryname = 'does\not\ex<st'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; pathroot =  'C:'; isValid = $false; Exception = $false}
    $aTestDataCollection += New-TestFilterPathObject 'C:\does\not\ex>st\readme.txt' @{ directoryname = 'does\not\ex>st'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; pathroot =  'C:'; isValid = $false; Exception = $false}
} else {
    $aTestDataCollection += New-TestFilterPathObject 'C:\does\not\ex"st\readme.txt' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; pathroot =  ''; isValid = $false; Exception = $false}
    $aTestDataCollection += New-TestFilterPathObject 'C:\does\not\ex<st\readme.txt' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; pathroot =  ''; isValid = $false; Exception = $false}
    $aTestDataCollection += New-TestFilterPathObject 'C:\does\not\ex>st\readme.txt' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; pathroot =  ''; isValid = $false; Exception = $false}
}

$aTestDataCollection += New-TestFilterPathObject 'C:\does\not\ex|st\readme.txt' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; pathroot =  ''; isValid = $false; Exception = $true}
$aTestDataCollection += New-TestFilterPathObject 'C:\does\not\ex:st\readme.txt' @{ directoryname = 'does\not\ex:st'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; pathroot =  'C:'; isValid = $false; Exception = $false}
$aTestDataCollection += New-TestFilterPathObject 'C:\does\not\exist\r*adme.txt' @{ directoryname = 'does\not\exist'; filename = 'r*adme.txt'; basename =  'r*adme'; extension =  '.txt'; pathroot =  'C:'; isValid = $false; Exception = $false}
$aTestDataCollection += New-TestFilterPathObject 'C:\does\not\exist\r?adme.txt' @{ directoryname = 'does\not\exist'; filename = 'r?adme.txt'; basename =  'r?adme'; extension =  '.txt'; pathroot =  'C:'; isValid = $false; Exception = $false}

$aTestDataCollection += New-TestFilterPathObject 'C:\does\not\exist\' @{ directoryname = 'does\not'; filename = 'exist'; basename =  'exist'; extension =  ''; pathroot =  'C:'; isValid = $true; Exception = $false}
$aTestDataCollection += New-TestFilterPathObject 'C:\' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; pathroot =  'C:'; isValid = $true; Exception = $false}
$aTestDataCollection += New-TestFilterPathObject 'C:' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; pathroot =  'C:'; isValid = $true; Exception = $false}
$aTestDataCollection += New-TestFilterPathObject 'C' @{ directoryname = ''; filename = 'C'; basename =  'C'; extension =  ''; pathroot =  ''; isValid = $false; Exception = $false}

$aTestDataCollection += New-TestFilterPathObject $null @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; pathroot =  ''; isValid = $false; Exception = $true}
$aTestDataCollection += New-TestFilterPathObject ' ' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; pathroot =  ''; isValid = $false; Exception = $true}

$aTestDataCollection += New-TestFilterPathObject '.\does\not\exist.txt' @{ directoryname = '.\does\not'; filename = 'exist.txt'; basename =  'exist'; extension =  '.txt'; pathroot =  ''; isValid = $false; Exception = $false}
$aTestDataCollection += New-TestFilterPathObject '\does\not\exist.txt' @{ directoryname = '\does\not'; filename = 'exist.txt'; basename =  'exist'; extension =  '.txt'; pathroot =  ''; isValid = $false; Exception = $false}

