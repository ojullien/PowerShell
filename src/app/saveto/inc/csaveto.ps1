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
        return "[CSaveTo] Configuration`n`tSource: $($this.m_pSource)`n`tDestination: $($this.m_pDestination)"
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

    [void] cleanLog() {
    <#
    .SYNOPSIS
        Deletes old log files.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pSaveTo.cleanLog()
    #>
        foreach( $sName in @( $this.m_sRobocopyLogName, $this.m_sContigerLogName )) {
            $this.m_pWriter.notice( "Cleaning '$sName-*.log' files from $($this.m_sLogPath)" )
            Remove-Item "$($this.m_sLogPath)\$sName-*.log"
        }
    }

    [bool] isReadySource() {
    <#
    .SYNOPSIS
        Return true if the source drive is ready.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pSaveTo.isReadySource()
    #>
        [bool] $bReturn = $false
        if( $this.m_pSource -eq $null ) {
            $this.m_pWriter.error( "Source is not set." )
        } elseif( $this.m_pSource.isReady() -and $this.m_pSource.testPath() ) {
                $bReturn = $true
        } else {
            $this.m_pWriter.error( "$($this.m_pSource) is missing" )
        }
        return $bReturn
    }

    [bool] isReadyDestination() {
    <#
    .SYNOPSIS
        Return true if the destination drive is ready.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pSaveTo.isReadyDestination()
    #>
        [bool] $bReturn = $false
        if( $this.m_pDestination -eq $null ) {
            $this.m_pWriter.error( "Destination is not set." )
        } elseif( $this.m_pDestination.isReady() -and $this.m_pDestination.testPath() ) {
                $bReturn = $true
        } else {
            $this.m_pWriter.error( "$($this.m_pDestination) is missing" )
        }
        return $bReturn
    }

    [bool] robocopy( [string] $sFolder ) {
    <#
    .SYNOPSIS
        Robust file/directory copy. The source and the destination must be set.
        Returns true if the command succeeded.
        Return false if the drives are not ready or the command failed.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pSaveTo.robocopy( <folder name as string> )
    .PARAMETER sFolder
        The folder name
    #>
        if( [string]::IsNullOrWhiteSpace( $sFolder )) {
            throw "Usage: [CSaveTo]::robocopy( <folder name as string> )"
        }

        [bool] $bReturn = $false
        $sFolder = $sFolder.Trim().Trim('\')

        if( $this.isReadySource() -and $this.isReadyDestination() ) {

            # Robocopy
            try {
                $pProcess = [CRobocopy]::new(
                    "$($this.m_pSource.getDriveLetter())\$($this.m_pSource.getSubFolder())\$sFolder",
                    "$($this.m_pDestination.getDriveLetter())\$($this.m_pDestination.getSubFolder())\$sFolder",
                    "$($this.m_sLogPath)\$($this.m_sRobocopyLogName)-$sFolder.log" )

                $bReturn = $pProcess.setWriter( $this.m_pWriter ).run()
            }
            catch {
                $this.m_pWriter.error( "Cannot load or execute CRobocopy: $_" )
            }

            Remove-Variable -Name [CRobocopy]$pProcess

        }
        return $bReturn
    }

    [bool] contig( [string] $sFolder ) {
    <#
    .SYNOPSIS
        Defragments a specified files in folder. The destination must be set.
        Returns true if the command succeeded.
        Return false if the drive is not ready or the command failed.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pSaveTo.contig( <folder name as string> )
    .PARAMETER sFolder
        The folder name
    #>
        if( [string]::IsNullOrWhiteSpace( $sFolder )) {
            throw "Usage: [CSaveTo]::contig( <folder name as string> )"
        }

        [bool] $bReturn = $false
        $sFolder = $sFolder.Trim().Trim('\')

        if( $this.isReadyDestination() ) {

            # Robocopy
            try {
                $pProcess = [CContiger]::new( "$($this.m_pDestination.getDriveLetter())\$($this.m_pDestination.getSubFolder())\$sFolder" )

                $bReturn = $pProcess.setWriter( $this.m_pWriter ).run()
            }
            catch {
                $this.m_pWriter.error( "Cannot load or execute CContiger: $_" )
            }

            Remove-Variable -Name [CContiger]$pProcess

        }
        return $bReturn
    }

}
