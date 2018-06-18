<#PSScriptInfo

.VERSION 1.2.0

.GUID fe85499f-0001-4ceb-931f-2831b75e3b2d

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS .

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 build consistent log from many apache log files.

#>
[CmdletBinding()]
Param(
    [switch] $bequiet,
    [switch] $logtofile,
    [switch] $waituser,
    [Parameter(Mandatory=$True,Position=1)]
    [ValidateNotNullOrEmpty()]
    [string] $cfg = 'default'
)

Set-StrictMode -Version Latest

# -----------------------------------------------------------------------------
#  Script options
# -----------------------------------------------------------------------------
New-Variable -Name m_OPTION_WAIT -Force -Option Constant,AllScope -Value $( if( $waituser.IsPresent ) {1} else {0} )

# -----------------------------------------------------------------------------
# Load common sys files
# -----------------------------------------------------------------------------

. ("$PWD\..\src\sys\cfg\constant.ps1")
. ("$m_DIR_SYS\inc\Writer\autoload.ps1")

# -----------------------------------------------------------------------------
# Load sys\Filter files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Filter\autoload.ps1")

# -----------------------------------------------------------------------------
# Load sys\Executable files
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Exec\Program.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\Interface.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\Abstract.ps1")
. ("$m_DIR_SYS\inc\Exec\Adapter\SystemDiagnosticsProcess.ps1")
. ("$m_DIR_SYS\inc\Exec\7-Zip.ps1")

# -----------------------------------------------------------------------------
# Load sys config
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\cfg\main.ps1")

# -----------------------------------------------------------------------------
# Load app files and instanciate Process
# -----------------------------------------------------------------------------

. ("$m_DIR_APP\BuildLog\inc\ExtractLog.ps1")

try {
    [ExtractLog] $pProcess = [ExtractLog]::new( [SevenZip]::new( [SystemDiagnosticsProcess]::new() ) )
} catch {
    $pWriter.error( "Exception raised while creating ExtractLog:  $_" )
    Exit
}

# -----------------------------------------------------------------------------
# Load config
# -----------------------------------------------------------------------------

$sCfgPath = "$m_DIR_APP\BuildLog\cfg\$cfg.cfg.ps1"
if( ! [File]::new().exists( [Path]::new( $sCfgPath ))) {
    $pWriter.error( "$sCfgPath is missing! Aborting ..." )
    Exit
} else {
    . ($sCfgPath)
}
. ("$m_DIR_APP\BuildLog\cfg\BuildLog.ps1")

if( -not $appConfirmed ) {
    Exit
}

# Extract archives
<#
$pWriter.notice( $appArchivesOutputDir )
try {
    $null = $pProcess.setArchive( $appArchivesInputDir ).setOutputDir( $appArchivesOutputDir )
    $pWriter.notice( [string]$pProcess )
    [bool] $bRun = $pProcess.extract( $true, "var/log/apache2", $false )
}
catch {
    $pWriter.error( "Exception raised while extracting archives:  $_" )
}
#>

# Build logs
try {
    [BuildLog] $pProcess = [BuildLog]::new( $pWriter )
    $null = $pProcess.setDomains( $appDomains ).setInputDir( $appInputLogDir ).setOutputDir( $appOutputLogDir )
} catch {
    $pWriter.error( "Exception raised while creating BuildLog: $_" )
    Exit
}

[string[]] $aDirCollection = Get-ChildItem -Path $appInputLogDir -Directory -Name | Sort-Object
[int] $iCount = $aDirCollection.Count
$pWriter.notice("count:$iCount")

<#
foreach ($sDir in $aDirCollection) {

    $iYear = [int] $sDir.Substring(4,4)
    $iMonth = [int] $sDir.Substring(8,2)
    $iDay = [int] $sDir.Substring(10,2)

    # Create log files


    if( $iDay -gt 1 ){

        foreach( $sDomain in $appDomains ) {
            #[string] $sBuffer = "log-{0}{1}{2}_0625" -f $iFirstYear, $iCurrentMonth.ToString("0#"), $iCurrentDay.ToString("0#")
            $sPath = "{0}\{1}" -f $appOutputLogDir, $sDomain
            $sLogYear = "{0}\{1}.log" -f $sPath, $iYear.ToString()
            $sLogMonth = "{0}\{1}{2}.log" -f $sPath, $iYear.ToString(), $iMonth.ToString("0#")
            $pWriter.notice("path:$sPath")
            $pWriter.notice("year:$sLogYear")
            $pWriter.notice("month:$sLogMonth")
            new-item -Force -ItemType File -Path $sLogYear, $sLogMonth | Out-Null
            break
        }


    }else{

    }
break
}
#>





<#
[datetime] $pDateTime = (get-date -Year $iFirstYear -Month $iFirstMonth -Day $iFirstDay)
$pWriter.notice( "date: " + $pDateTime.ToShortDateString() )


$pWriter.notice( "year: $iFirstYear" )
for( [int]$iCurrentMonth = $iFirstMonth; $iCurrentMonth -lt 13; $iCurrentMonth++ ) {^
    $pWriter.notice( "`tmonth: $iCurrentMonth" )
    for( [int]$iCurrentDay = $iFirstDay; $iCurrentDay -lt 31; $iCurrentDay++ ) {
        $pWriter.notice( "`t`tday: $iCurrentDay" )
        $sDir = "log-{0}{1}{2}_0625" -f $iFirstYear, $iCurrentMonth.ToString("0#"), $iCurrentDay.ToString("0#")
        if( -not (Test-Path -LiteralPath $sDir -PathType Container) ) {
            $pWriter.notice( "$sDir is missing" )
            continue
        }
    }
}
#>

$pProcess = $null
Set-StrictMode -Off
