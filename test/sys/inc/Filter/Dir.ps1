<#PSScriptInfo

.VERSION 1.1.0

.GUID 8c6b4039-3915-45f5-90ad-1b9bc864dd20

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
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 Common Path and filename data set

#>

Function New-TestDirObject( $path, $isvalid, $exists, $filter ) {
    New-Object -TypeName PsObject -Property @{
        thePath = $path;
        isValid = $isvalid;
        exists = $exists;
        doFilter = $filter }
}

$aTestDataCollection = @()

$aTestDataCollection += New-TestDirObject 'C:\Program Files\Windows"PowerShell' $false $false ""
$aTestDataCollection += New-TestDirObject "C:\Program Files\Windows<PowerShell" $false $false ""
$aTestDataCollection += New-TestDirObject "C:\Program Files\Windows>PowerShell" $false $false ""
$aTestDataCollection += New-TestDirObject "C:\Program Files\Windows|PowerShell" $false $false ""
$aTestDataCollection += New-TestDirObject "C:\Program Files\Windows:PowerShell" $false $false ""
$aTestDataCollection += New-TestDirObject "C:\Program Files\Windows*PowerShell" $false $false ""
$aTestDataCollection += New-TestDirObject "C:\Program Files\Windows?PowerShell" $false $false ""

$aTestDataCollection += New-TestDirObject "C:\Program Files\WindowsPowerShell\" $true $true "C:\Program Files"
$aTestDataCollection += New-TestDirObject "C:\Program Files\WindowsPowerShell" $true $true "C:\Program Files"
$aTestDataCollection += New-TestDirObject "C:\Program Files\" $true $true "C:\"
$aTestDataCollection += New-TestDirObject "C:\Program Files" $true $true "C:\"
$aTestDataCollection += New-TestDirObject "C:\Program Files\doesnotexist" $true $false "C:\Program Files"
$aTestDataCollection += New-TestDirObject "C:\doesnotexist" $true $false "C:\"

$aTestDataCollection += New-TestDirObject "C:\" $true $true ""
$aTestDataCollection += New-TestDirObject "C:" $true $true "Exception"
$aTestDataCollection += New-TestDirObject "C" $true $false ""

$aTestDataCollection += New-TestDirObject $null "Exception" "Exception" "Exception"
$aTestDataCollection += New-TestDirObject "" "Exception" "Exception" "Exception"
$aTestDataCollection += New-TestDirObject " " "Exception" "Exception" "Exception"
