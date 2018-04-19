<#PSScriptInfo

.VERSION 1.0.0

.GUID 90c70f14-f1cf-4c22-9175-fe79514a477d

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\string.ps1, sys\inc\filesystem.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180409
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 Main Configuration file

#>

# -----------------------------------------------------------------------------
# Trace
# -----------------------------------------------------------------------------
$pWriter.separateLine()
$pWriter.notice( "Script options" )
$pWriter.notice( "`t$pWriter" )

$pWriter.separateLine()
$pWriter.notice( "Main configuration" )
[CValidator]::checkDir( [CWriter] $pWriter, "`tScript directory: $m_DIR_SCRIPT ", $m_DIR_SCRIPT ) > $null
[CValidator]::checkDir( [CWriter] $pWriter, "`tSystem directory: $m_DIR_SYS ", $m_DIR_SYS ) > $null
[CValidator]::checkDir( [CWriter] $pWriter, "`tApp directory: $m_DIR_APP ", $m_DIR_APP ) > $null
[CValidator]::checkDir( [CWriter] $pWriter, "`tLog directory: $m_DIR_LOG ", $m_DIR_LOG ) > $null
[CValidator]::checkFile( [CWriter] $pWriter, "`tLog file is: $m_DIR_LOG_PATH ", $m_DIR_LOG_PATH ) > $null