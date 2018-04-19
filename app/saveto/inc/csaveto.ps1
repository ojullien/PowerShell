<#PSScriptInfo

.VERSION 1.0.0

.GUID 12bcc70f-27b5-4663-9551-3012a78db9a8

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys,app\saveto

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180409
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 save-to App classes and functions

#>

class CSaveTo {

    # Properties

    [ValidateNotNull()]
    hidden [CWriter] $m_pWriter

    [ValidateNotNull()]
    hidden [CDrive] $m_pSource

    [ValidateNotNull()]
    hidden [CDrive] $m_pDestination

    [ValidateNotNullOrEmpty()]
    hidden [string] $m_sLogPath = 'c:\Temp'

    [ValidateNotNullOrEmpty()]
    hidden [string] $m_sContigerLogName = "contig"

    [ValidateNotNullOrEmpty()]
    hidden [string] $m_sRobocopyLogName = "robocopy"

    # Constructors

    CSaveTo ( [string] $sPath ) {
        if( [string]::IsNullOrWhiteSpace( $sPath )) {
            throw "Usage: [CSaveTo]::new( <log path as string> )"
        }
        if( -Not $( Test-Path -LiteralPath $sPath -PathType Container )) {
            throw "The log path must be valid"
        }
        $this.m_sLogPath = $sPath.Trim()
    }

    # Class methods

    [String] ToString() {
        return "todo"
    }

    [CSaveTo] setWriter( [CWriter] $pWriter ) {
    <#
    .SYNOPSIS
        Set the writer.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pSaveTo.setWriter( <instance of CWriter> )
    .PARAMETER pWriter
        An instance of CWriter.
    #>
        $this.m_pWriter = $pWriter
        return $this
    }

    [CSaveTo] setSource( [CDrive] $pDrive ) {
    <#
    .SYNOPSIS
        Set the source drive.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pSaveTo.setSource( <instance of CDrive> )
    .PARAMETER pDrive
        An instance of CDrive.
    #>
        $this.m_pSource = $pDrive
        return $this
    }

    [CSaveTo] setDestination( [CDrive] $pDrive ) {
    <#
    .SYNOPSIS
        Set the destination drive.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pSaveTo.setDestination( <instance of CDrive> )
    .PARAMETER pDrive
        An instance of CDrive.
    #>
        $this.m_pDestination = $pDrive
        return $this
    }

    [CSaveTo] cleanLog() {
        foreach( $sName in @( $this.m_sRobocopyLogName, $this.m_sRobocopyLogName )) {
            $this.pWriter.notice( "Cleaning '$sName-*.log' files from '$this.m_sLogPath'" )
            Remove-Item "$this.m_sLogPath\$sName-*.log"
        }
        return $this
    }

    [bool] saveTo() {



        return $false
    }
}
