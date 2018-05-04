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

Function New-TestPathObject( $path, $expected ) {
    New-Object -TypeName PsObject -Property @{
        thePath = $path
        doFilter = $expected }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestPathObject 'C:\does\not\exist\readme.txt' @{ directoryname = 'C:\does\not\exist'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; PathRoot =  'C:';}
$aTestDataCollection += New-TestPathObject 'C:\does\not\exist\readme' @{ directoryname = 'C:\does\not\exist'; filename = 'readme'; basename =  'readme'; extension =  ''; PathRoot =  'C:';}
$aTestDataCollection += New-TestPathObject 'C:\does\not\exist\.txt' @{ directoryname = 'C:\does\not\exist'; filename = '.txt'; basename =  ''; extension =  '.txt'; PathRoot =  'C:';}
$aTestDataCollection += New-TestPathObject 'C:\readme.txt' @{ directoryname = 'C:\'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; PathRoot =  'C:';}
$aTestDataCollection += New-TestPathObject 'C:\readme' @{ directoryname = 'C:\'; filename = 'readme'; basename =  'readme'; extension =  ''; PathRoot =  'C:';}
$aTestDataCollection += New-TestPathObject 'C:\.txt' @{ directoryname = 'C:\'; filename = '.txt'; basename =  ''; extension =  '.txt'; PathRoot =  'C:';}

if( $PSVersionTable.PSVersion.Major -eq 6 ) {
    $aTestDataCollection += New-TestPathObject 'C:\does\not\ex"st\readme.txt' @{ directoryname = 'C:\does\not\ex"st'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; PathRoot =  'C:';}
    $aTestDataCollection += New-TestPathObject 'C:\does\not\ex<st\readme.txt' @{ directoryname = 'C:\does\not\ex<st'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; PathRoot =  'C:';}
    $aTestDataCollection += New-TestPathObject 'C:\does\not\ex>st\readme.txt' @{ directoryname = 'C:\does\not\ex>st'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; PathRoot =  'C:';}
} else {
    $aTestDataCollection += New-TestPathObject 'C:\does\not\ex"st\readme.txt' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; PathRoot =  '';}
    $aTestDataCollection += New-TestPathObject 'C:\does\not\ex<st\readme.txt' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; PathRoot =  '';}
    $aTestDataCollection += New-TestPathObject 'C:\does\not\ex>st\readme.txt' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; PathRoot =  '';}
}
$aTestDataCollection += New-TestPathObject 'C:\does\not\ex|st\readme.txt' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; PathRoot =  '';}
$aTestDataCollection += New-TestPathObject 'C:\does\not\ex:st\readme.txt' @{ directoryname = 'C:\does\not\ex:st'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; PathRoot =  'C:';}
$aTestDataCollection += New-TestPathObject 'C:\does\not\ex*st\readme.txt' @{ directoryname = 'C:\does\not\ex*st'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; PathRoot =  'C:';}
$aTestDataCollection += New-TestPathObject 'C:\does\not\ex?st\readme.txt' @{ directoryname = 'C:\does\not\ex?st'; filename = 'readme.txt'; basename =  'readme'; extension =  '.txt'; PathRoot =  'C:';}

$aTestDataCollection += New-TestPathObject 'C:\does\not\exist\' @{ directoryname = 'C:\does\not\exist'; filename = ''; basename =  ''; extension =  ''; PathRoot =  'C:';}
$aTestDataCollection += New-TestPathObject 'C:\' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; PathRoot =  'C:';}
$aTestDataCollection += New-TestPathObject 'C:' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; PathRoot =  'C:';}
$aTestDataCollection += New-TestPathObject 'C' @{ directoryname = ''; filename = 'C'; basename =  'C'; extension =  ''; PathRoot =  '';}

$aTestDataCollection += New-TestPathObject $null @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; PathRoot =  'C:';}
$aTestDataCollection += New-TestPathObject ' ' @{ directoryname = ''; filename = ''; basename =  ''; extension =  ''; PathRoot =  'C:';}
