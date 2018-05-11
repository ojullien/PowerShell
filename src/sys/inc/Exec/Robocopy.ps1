<#PSScriptInfo

.VERSION 1.2.0

.GUID eb202f80-0006-47c2-9196-01370ebd498f

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\Drive\Drive.ps1, sys\inc\Exec\Adapter\Abstract.ps1, sys\inc\Exec\Program.ps1, src\sys\inc\Filter\Dir.ps1, sys\inc\Filter\Path.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 This class allows a robust directory copy.

#>

class Robocopy {

    # Properties

    [ValidateNotNull()]
    [Drive] $m_pSource

    [ValidateNotNull()]
    [Drive] $m_pDestination

    [ValidateNotNull()]
    [Path] $m_pLogPath

    [ValidateNotNull()]
    [ExecAdapterAbstract] $m_pAdapter

    [ValidateNotNullOrEmpty()]
    hidden [string] $m_sRobocopyLogName = "robocopy"

    # Constructors

    Robocopy() {
        throw "Usage: [Robocopy]::new( <source as [Drive], destination as [Drive], log dir as [Path], adapter as [ExecAdapterAbstract]>"
    }

    Robocopy ( [Drive] $source, [Drive] $destination, [Path] $logpath, [ExecAdapterAbstract] $adapter ) {

        if( ( $source -eq $null ) -or ( $destination -eq $null ) -or ( $logpath -eq $null ) -or ( $adapter -eq $null )  ) {
            throw "Usage: [Robocopy]::new( <source as [Drive], destination as [Drive], log dir as [Path], adapter as [ExecAdapterAbstract]>"
        }

        if( -Not [Dir]::new().exists( $logpath )) {
            throw "Robocopy: The log path must be valid."
        }

        $this.m_pSource = $source
        $this.m_pDestination = $destination
        $this.m_pAdapter = $adapter
        $this.m_pLogPath = $logpath

    }

    # Class methods

    [string] ToString() {
        return "[Robocopy] Configuration`n`tSource: $($this.m_pSource)`n`tDestination: $($this.m_pDestination)`n`tLog path: $($this.m_pLogPath)`n`tAdapter: $($this.adapter.GetType())"
    }

    [void] cleanLog() {
    <#
    .SYNOPSIS
        Deletes old log files.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [Robocopy]$instance.cleanLog()
    #>
        # Log dir must exist
        if( -Not [Dir]::new().exists( [Path]::new( $this.m_sLogPath ) )) {
            throw "The log path must be valid"
        }
        # Delete
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
            throw "Usage: [SaveTo]::robocopy( <folder name as string> )"
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



}
