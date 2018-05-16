<#PSScriptInfo

.VERSION 1.2.0

.GUID 5a516eab-0002-4f39-82f9-f12d189bf98d

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
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 save-to App classes and functions

#>

class SaveTo {

    # Properties

    [ValidateNotNull()]
    hidden [Drive] $m_pSource

    [ValidateNotNull()]
    hidden [Drive] $m_pDestination

    [ValidateNotNull()]
    hidden [Path] $m_pDefaultLogDir

    hidden [Path] $m_pCurrentLog

    # Constructors

    SaveTo() {
        throw "Usage: [SaveTo]::new( <valid log directory as [Filter\Path]> )"
    }

    SaveTo ( [Path] $logdir ) {
        if( ($logdir -eq $null) -or (![Dir]::new().exists( $logdir )) ) {
            throw "Usage: [SaveTo]::new( <valid log directory as [Filter\Path]> )"
        }
        $this.m_pDefaultLogDir = $logdir
        $this.m_pCurrentLog = $null
    }

    # Class methods

    [String] ToString() {
        return "[SaveTo] Configuration`n`tSource: $($this.m_pSource)`n`tDestination: $($this.m_pDestination)"
    }

    [SaveTo] setSource( [Path] $path, [string]$label ) {
    <#
    .SYNOPSIS
        Set the source path. Throw an error if the path is not valid or the drive is not ready.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [SaveTo]$instance.setSource( <source as [Filter\Path]> )
    .PARAMETER path
        An instance of Filter\Path.
    .PARAMETER label
        Drive label as string
    #>
        # Initialize
        $this.m_pCurrentLog = $null

        # Check parameters
        if( ($path -eq $null) -or [string]::IsNullOrWhiteSpace( $label ) ) {
            throw 'Usage: [SaveTo]$instance.setSource( <source as [Filter\Path]>; <drive label as string> )'
        }

        # Build source
        $this.m_pSource = [Drive]::new( $path, $label )
        if( !$this.m_pSource.isReady() -or !$this.m_pSource.testPath() ){
            throw 'SaveTo: Source is not valid or the drive is not ready.'
        }

        # Build log path
        $this.m_pCurrentLog = [Path]::new( [string]$this.m_pDefaultLogDir + [System.IO.Path]::DirectorySeparatorChar + 'robocopy-' + $path.getFilename() + ".log"  )
        if( !$this.m_pCurrentLog.isValid() ){
            throw 'SaveTo: The log path is not valid.'
        }

        # Delete old log file
        if( [File]::new().exists( $this.m_pCurrentLog ) ){
            Remove-Item "$([string]$this.m_pCurrentLog)"
        }

        return $this
    }

    [SaveTo] setDestination( [Path] $path, [string]$label ) {
    <#
    .SYNOPSIS
        Set the destination path. Throw an error if the path is not valid or the drive is not ready.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [SaveTo]$instance.setDestination( <destination as [Filter\Path]> )
    .PARAMETER path
        An instance of Filter\Path.
    .PARAMETER label
        Drive label as string
    #>
        # Check parameters
        if( ($path -eq $null) -or [string]::IsNullOrWhiteSpace( $label ) ) {
            throw 'Usage: [SaveTo]$instance.setDestination( <destination as [Filter\Path]>; <drive label as string> )'
        }

        # Build destination
        $this.m_pDestination = [Drive]::new( $path, $label )
        if( !$this.m_pDestination.isReady() ){
            throw 'SaveTo: Destination drive is not ready.'
        }

        # Create destination
        if( ![Dir]::new().exists( $this.m_pDestination ) ){
            New-Item -ItemType "directory" -Force -Path "$([string]$this.m_pDestination)" | Out-Null
        }

        return $this
    }

    [bool] robocopy() {
    <#
    .SYNOPSIS
        Robust file/directory copy. The source and the destination must be set.
        Returns true if the command succeeded.
        Return false if the drives are not ready or the command failed.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pSaveTo.robocopy( <folder name as string> )
    #>

        # Parameters
        if( ($source -eq $null) -or ($destination -eq $null) ) {
            throw 'Usage: [SaveTo]$instance.robocopy( <source as [Filter\Path]]>, <destination as [Filter\Path]]> )'
        }

        # Log
        [Path] $pLog = [Path]::new( [string]$this.m_pLogPath + [System.IO.Path]::DirectorySeparatorChar + $source.getFilename()  )





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
            throw "Usage: [SaveTo]::contig( <folder name as string> )"
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
