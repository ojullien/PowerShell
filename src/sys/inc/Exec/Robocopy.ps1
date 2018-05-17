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

.REQUIREDSCRIPTS sys\inc\Drive\Drive.ps1, sys\inc\Exec\Adapter\Interface.ps1, sys\inc\Exec\Program.ps1, sys\inc\Filter\Path.ps1

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
    [int] $m_iExitCode

    [ValidateNotNull()]
    [Drive] $m_pSource

    [ValidateNotNull()]
    [Drive] $m_pDestination

    [ValidateNotNull()]
    [Path] $m_pLogPath

    [ValidateNotNull()]
    [ExecAdapterInterface] $m_pAdapter

    [ValidateNotNullOrEmpty()]
    hidden [string] $m_ExePath = 'C:\Windows\System32\robocopy.exe'

    [ValidateNotNullOrEmpty()]
    [string[]] $m_aDefaultArgumentList = @( `
        # Copy options
        "/Z", "/MIR", `
        # File options
        "/DST", `
        # Retry options
        "/R:3", "/W:5", `
        # Log options
        "/X", "/V", "/FP", "/NS", "/NP", "/TEE" )

    # Constructors

    Robocopy() {
        throw "Usage: [Robocopy]::new( <source as [Drive\Drive], destination as [Drive\Drive], log path and name as [Filter\Path], adapter as [Exec\Adapter\ExecAdapterInterface]>"
    }

    Robocopy ( [Drive] $source, [Drive] $destination, [Path] $logpath, [ExecAdapterInterface] $adapter ) {

        if( ( $source -eq $null ) -or ( $destination -eq $null ) -or ( $logpath -eq $null ) -or ( $adapter -eq $null )  ) {
            throw "Usage: [Robocopy]::new( <source as [Drive\Drive], destination as [Drive\Drive], log path and name as [Filter\Path], adapter as [Exec\Adapter\ExecAdapterInterface]>"
        }

        if( !$logpath.isValid() ) {
            throw "Robocopy: The log path and name is not valid."
        }

        $this.m_pSource = $source
        $this.m_pDestination = $destination
        $this.m_pAdapter = $adapter
        $this.m_pLogPath = $logpath
        $this.m_iExitCode = 0

    }

    # Class methods

    [string] ToString() {
        return "[Robocopy] Configuration`n" `
            + "`tSource: $($this.m_pSource.getTrace())`n" `
            + "`tDestination: $($this.m_pDestination.getTrace())`n" `
            + "`tLog path: $([string]$this.m_pLogPath)`n" `
            + "`tAdapter: $($this.m_pAdapter.GetType())`n" `
            + "`tOptions: $($this.m_aDefaultArgumentList)"
    }

    [int] getExitCode() {
        return $this.m_iExitCode
    }

    [bool] isReadySource() {
    <#
    .SYNOPSIS
        Return true if the source drive is ready and the path exists.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [Robocopy]$instance.isReadySource()
    #>
        #Initialize
        [bool] $bReturn = $false

        # Test
        if( ( $this.m_pSource -ne $null ) -and ( $this.m_pSource.isReady() ) -and ( $this.m_pSource.testPath() )) {
            $bReturn = $true
        }

        return $bReturn
    }

    [bool] isReadyDestination() {
    <#
    .SYNOPSIS
        Return true if the destination drive is ready and the path exists.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [Robocopy]$instance.isReadyDestination()
    #>
        #Initialize
        [bool] $bReturn = $false

        # Test
        if( ( $this.m_pDestination -ne $null ) -and ( $this.m_pDestination.isReady() ) -and ( $this.m_pDestination.testPath() )) {
            $bReturn = $true
        }

        return $bReturn
    }

    [bool] run() {
    <#
    .SYNOPSIS
        Robust directory copy. The source and the destination must be set.
        Returns true if the command succeeded.
        Return false if the drives are not ready or the command failed.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [Robocopy]$instance.run()
    #>
        # Initialize
        [bool] $bReturn = $false
        $this.m_iExitCode = 0

        # Adapter test
        if( $this.m_pAdapter -eq $null ) {
            throw "Usage: [Robocopy]::new( <source as [Drive\Drive], destination as [Drive\Drive], log dir as [Filter\Path], adapter as [Exec\Adapter\ExecAdapterInterface]>"
        }

        # Run
        if( $this.isReadySource() -and $this.isReadyDestination() ) {

            # Build the arguments
            [string[]] $aArgumentList = @( "`"$([string]$this.m_pSource)`"", "`"$([string]$this.m_pDestination)`"" )
            $aArgumentList += $this.m_aDefaultArgumentList
            $aArgumentList += "/log:`"$($this.m_pLogPath)`""

            # Set the program, the options and run execute the command
            $this.m_iExitCode = $this.m_pAdapter.setProgram( [Program]::new().setProgramPath( [Path]::new( $this.m_ExePath ) ).setArgument( $aArgumentList ) ).run()

            if( $this.m_iExitCode -gt 8 ) {
                $bReturn = $false
            } else {
                $bReturn = $true
            }

        } else {
            throw "Robocopy: Drives are not ready."
        }

        return $bReturn
    }

}
