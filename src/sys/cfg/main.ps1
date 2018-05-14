<#PSScriptInfo

.VERSION 1.2.0

.GUID 90c70f14-f1cf-4c22-9175-fe79514a477d

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\Writer, sys\inc\Filter

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

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

[Dir]::new().exists( $pWriter, "`tScript directory: $m_DIR_SCRIPT ", [Path]::new($m_DIR_SCRIPT) ) > $null
[Dir]::new().exists( $pWriter, "`tSystem directory: $m_DIR_SYS ", [Path]::new($m_DIR_SYS) ) > $null
[Dir]::new().exists( $pWriter, "`tApp directory: $m_DIR_APP ", [Path]::new($m_DIR_APP) ) > $null
[Dir]::new().exists( $pWriter, "`tLog directory: $m_DIR_LOG ", [Path]::new($m_DIR_LOG) ) > $null
[File]::new().exists( $pWriter, "`tLog file: $m_DIR_LOG_PATH ", [Path]::new($m_DIR_LOG_PATH) ) > $null
