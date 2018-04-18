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
 save-to App functions

#>

# -----------------------------------------------------------------------------
# Drive object
# -----------------------------------------------------------------------------

class CDrive {

    # Properties

    hidden [string] $m_sDriveLetter
    hidden [string] $m_sSubFolder = ''
    hidden [string] $m_sVolumeLabel

    # Constructors

    CDrive() {}

    CDrive( [string] $sDriveLetter, [string] $sVolumeLabel) {
        if( [string]::IsNullOrWhiteSpace( $sDriveLetter ) `
            -Or [string]::IsNullOrWhiteSpace( $sVolumeLabel ) ) {
                throw "Usage: CDrive::new( <Letter of the drive like c:>, <volume label> )"
        }

        $this.m_sDriveLetter = $sDriveLetter.Trim().TrimEnd('\')

        if( ($this.m_sDriveLetter.Length -gt 1) -and ($this.m_sDriveLetter[1] -ne ':') ) {
            throw "The drive letter parameter should be like C:"
        }
        if( ($this.m_sDriveLetter.Length -gt 2) -and( ($this.m_sDriveLetter[1] -ne ':') -or ($this.m_sDriveLetter[2] -ne '\'))) {
            throw "The drive letter parameter should be like C:\folder"
        }
        if( $this.m_sDriveLetter.Length -eq 1 ) {
            $this.m_sDriveLetter += ':'
        }

        $this.m_sVolumeLabel = $sVolumeLabel
    }

    # Methods

    [String] ToString()
    {
        return $this.m_sVolumeLabel + " on " + $this.m_sDriveLetter
    }

    [String] getDriveLetter()
    {
        return $this.m_sDriveLetter
    }

    [String] getVolumeLabel()
    {
        return $this.m_sVolumeLabel
    }

    [bool] isReady()
    {
        $bReturn = $false
        # Case Drive letter is
        if( $this.m_sDriveLetter )
        $pDrives = [System.IO.DriveInfo]::GetDrives() | Where-Object { ($_.Name -eq "c:\") -and ($_.VolumeLabel -eq "os") }
        return $bReturn
    }
}