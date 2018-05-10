<#PSScriptInfo

.VERSION 1.2.0

.GUID 6d318de7-0001-44c9-bc32-312e34784528

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\Filter\Path.ps1, sys\inc\Filter\Dir.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Drive class

#>

class Drive {

    # Properties

    [Path] $m_pPath = $null

    [ValidatePattern('^[\w\d\s]*$')]
    [string] $m_sVolumeLabel = ''

    # Constructors

    Drive() {
        $this.m_pPath = $null
        $this.m_sVolumeLabel = ''
    }

    Drive( [Path] $value ) {
        $this.m_pPath = $value
    }

    # Methods

    [string] getDriveLetter() {
        [string] $sReturn = ''
        if( $this.m_pPath -ne $null ) {
            $sReturn = $this.m_pPath.getPathRoot()
        }
        return $sReturn
    }

    [string] getSubFolder() {
        [string] $sReturn = ''
        if( $this.m_pPath -ne $null ) {
            # Add directory name
            $sReturn = $this.m_pPath.getDirectoryName()
            # Add filename
            [string] $sFilename = $this.m_pPath.getFilename()
            if( ( $sFilename.Length -ne 0 ) -and ( $sReturn.Length -ne 0 ) -and ( !$sReturn.EndsWith( [System.IO.Path]::DirectorySeparatorChar ))){
                $sReturn = $sReturn + [System.IO.Path]::DirectorySeparatorChar
            }
            $sReturn = $sReturn +  $sFilename
        }
        return $sReturn
    }

    [Drive] setVolumeLabel( [string] $value ) {
        if( [string]::IsNullOrWhiteSpace( $value ) ) {
            throw 'Usage: [Drive]$object.setVolumeLabel( <volume label as string> )'
        }
        $this.m_sVolumeLabel = $value.Trim()
        return $this
    }

    [string] getVolumeLabel() {
        return $this.m_sVolumeLabel
    }

    [string] ToString() {
        return "Volume `"" + $this.m_sVolumeLabel + "`" on `"" + $this.getDriveLetter() + [System.IO.Path]::DirectorySeparatorChar + $this.getSubFolder() + "`""
    }

    [bool] testPath()
    {
        # Determines whether all elements of a path exist and whether the path leads to a folder.
        [bool] $bReturn = $false
        if( $this.m_pPath -ne $null ) {
            $bReturn = [Dir]::new().exists( $this.m_pPath )
        }
        return $bReturn
    }

    [bool] isReady()
    {
        # Gets a value that indicates whether a drive is ready.
        $bReturn = $false
        [System.IO.DriveInfo[]] $aDrives = [System.IO.DriveInfo]::GetDrives() | Where-Object { ($_.Name -eq $this.getDriveLetter() + [System.IO.Path]::DirectorySeparatorChar ) -and ($_.VolumeLabel -eq $this.m_sVolumeLabel ) }

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
