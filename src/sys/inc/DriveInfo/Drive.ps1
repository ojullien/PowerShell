<#PSScriptInfo

.VERSION 1.1.0

.GUID c903f328-a3bd-4473-82d3-61ee784e43c9

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\writer

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 Drive classes and functions

#>

# -----------------------------------------------------------------------------
# Drive object
# -----------------------------------------------------------------------------

class Drive {

    # Properties

    [ValidatePattern('^[a-zA-Z]:$')]
    hidden [string] $m_sDriveLetter
    [ValidatePattern('^[^"\*\?<>|:]*$')]
    hidden [string] $m_sSubFolder = ''
    [ValidatePattern('^[\w\d\s]*$')]
    hidden [string] $m_sVolumeLabel = ''

    # Constructors

    Drive() {}

    # Methods

    [Drive] setDriveLetter( [string] $sDriveLetter ) {
        if( [string]::IsNullOrWhiteSpace( $sDriveLetter ) ) {
                throw 'Usage: [Drive]$object.setDriveLetter( <Letter of the drive like c:> )'
        }
        $sDriveLetter = $sDriveLetter.Trim().TrimEnd( [system.io.path]::DirectorySeparatorChar ).ToUpper()
        if( $sDriveLetter.Length -gt 2 ) {
            $sDriveLetter = $sDriveLetter.Substring( 0, 2 )
        }
        if( $sDriveLetter.Length -eq 1 ) {
            $sDriveLetter += ':'
        }
        $this.m_sDriveLetter = $sDriveLetter
        return $this
    }

    [String] getDriveLetter() {
        return $this.m_sDriveLetter
    }

    [Drive] setSubFolder( [string] $sSubFolder ) {
        if( [string]::IsNullOrWhiteSpace( $sSubFolder ) ) {
            throw 'Usage: [Drive]$object.setSubFolder( <folder name or path like windows\system32> )'
        }
        $this.m_sSubFolder = $sSubFolder.Trim().Trim( [system.io.path]::DirectorySeparatorChar )
        return $this
    }

    [String] getSubFolder() {
        return $this.m_sSubFolder
    }

    [Drive] setVolumeLabel( [string] $sVolumeLabel ) {
        if( [string]::IsNullOrWhiteSpace( $sVolumeLabel ) ) {
            throw 'Usage: [Drive]$object.setVolumeLabel( <volume label> )'
        }
        $this.m_sVolumeLabel = $sVolumeLabel.Trim()
        return $this
    }

    [String] getVolumeLabel() {
        return $this.m_sVolumeLabel
    }

    [String] ToString() {
        return "Volume `"" + $this.m_sVolumeLabel + "`" on `"" + $this.m_sDriveLetter + "\" + $this.m_sSubFolder + "`""
    }

    [bool] testPath()
    {
        # Determines whether all elements of a path exist and whether the path leads to a folder.
        [string] $sPath = $this.m_sDriveLetter + "\" + $this.m_sSubFolder
        return $( Test-Path -LiteralPath $sPath -PathType Container )
    }

    [bool] isReady()
    {
        # Gets a value that indicates whether a drive is ready.
        $bReturn = $false
        [System.IO.DriveInfo[]] $aDrives = [System.IO.DriveInfo]::GetDrives() | Where-Object { ($_.Name -eq $this.m_sDriveLetter + "\" ) -and ($_.VolumeLabel -eq $this.m_sVolumeLabel ) }

        if( $aDrives ) {
            if( $aDrives.length -gt 1 ) {
                # This case should not exist
                throw 'Found more than one drive : ' + $this.ToString()
            }

            if( $aDrives.length -eq 1 ) {
                $bReturn = $aDrives[0].IsReady
            }
        }
        return $bReturn
    }
}
