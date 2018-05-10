<#PSScriptInfo

.VERSION 1.0.0

.GUID eb202f80-12ad-47c2-9196-01370ebd498f

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180409
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 System process classes and functions

#>

# -----------------------------------------------------------------------------
# Process abstract and interface
# -----------------------------------------------------------------------------

class CProcess {

    # Properties

    hidden [string[]] $m_aArguments = @()
    hidden [string]   $m_sExePath
    hidden [bool]     $m_bUseShellExecute = $false
    hidden [bool]     $m_RedirectStandardOutput = $true
    hidden [Writer]  $m_pWriter

    # Constructors

    CProcess() {
    <#
    .SYNOPSIS
        Abstract constructor. This class must be overridden.
    .DESCRIPTION
        See synopsis.
    #>
        $oType = $this.GetType()

        if( $oType -eq [CProcess] )
        {
            throw("Class $oType must be inherited")
        }
    }

    # Class methods

    [String] ToString() {
        return "Command: " + $this.m_sExePath + "`nOptions: " + $this.m_aArguments
    }

    [CProcess] setWriter( [Writer] $pWriter ) {
    <#
    .SYNOPSIS
        Set the writer.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pProcess.setWriter( <instance of Writer> )
    .PARAMETER pWriter
        An instance of Writer.
    #>
        $this.m_pWriter = $pWriter
        return $this
    }

    [CProcess] setExePath( [string] $sPath ) {
    <#
    .SYNOPSIS
        Set the executable path.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pProcess.setExePath( <path as string> )
    .PARAMETER sPath
        The path of the exe.
    #>
        if( [string]::IsNullOrWhiteSpace( $sPath )) {
            throw "Usage: CProcess::setExePath( <path as string> )"
        }
        $this.m_sExePath = $sPath
        return $this
    }

    [CProcess] addArgument( [string] $sArgument ) {
    <#
    .SYNOPSIS
        Add an argument to the list.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pProcess.addArgument( <argument as string> )
    .PARAMETER sArgument
        An argument.
    #>
        if( [string]::IsNullOrWhiteSpace( $sArgument )) {
            throw "Usage: CProcess::addArgument( <argument as string> )"
        }
        $this.m_aArguments += $sArgument
        return $this
    }

    [CProcess] setArgument( [string[]] $aArguments ) {
    <#
    .SYNOPSIS
        Add a list of arguments.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pProcess.addArgument( <argument as string> )
    .PARAMETER sArgument
        An array of argument.
    #>
        $this.m_aArguments = $aArguments
        return $this
    }

    [int] run() {
    <#
    .SYNOPSIS
        Runs a command.
        Returns the Process exit code.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pProcess.run()
    #>
        # Trace
        $this.m_pWriter.notice( $this )

        # Execute
        $OFS = " "
        $pProcess = New-Object System.Diagnostics.Process
        $pProcess.StartInfo.FileName = $this.m_sExePath
        $pProcess.StartInfo.Arguments = $this.m_aArguments
        $pProcess.StartInfo.UseShellExecute = $this.m_bUseShellExecute
        $pProcess.StartInfo.RedirectStandardOutput = $this.m_RedirectStandardOutput

        if( $pProcess.Start() ) {
            $output = $pProcess.StandardOutput.ReadToEnd() -replace "\r\n$",""
            if ( $output ) {
                if( $output.Contains("`r`n") ) {
                    $output -split "`r`n"
                } elseif( $output.Contains("`n") ) {
                    $output -split "`n"
                } else {
                  $output
                }
            }
        }

        $pProcess.WaitForExit()

        & "$Env:SystemRoot\system32\cmd.exe" /c exit $pProcess.ExitCode

        return $pProcess.ExitCode
    }

}

# -----------------------------------------------------------------------------
# Robocopy process
# -----------------------------------------------------------------------------

class CRobocopy : CProcess {

    # Properties

    # Constructors

    CRobocopy( [string] $sSource, [string] $sDestination, [string] $sLogFile ) {
        if( [string]::IsNullOrWhiteSpace( $sSource ) `
            -Or [string]::IsNullOrWhiteSpace( $sDestination ) `
            -Or [string]::IsNullOrWhiteSpace( $sLogFile )) {
            throw "Usage: [CRobocopy]::new( <source as string>, <destination as string>, <log file path as string> )"
        }

        # Exec
        $this.setExePath( "robocopy.exe" )

        # Arguments list
        $this.setArgument( @( `
        # Source
        "`"$sSource`"", `
        # Destination
        "`"$sDestination`"", `
        # Copy options
        "/Z /MIR", `
        # File options
        "/DST", `
        # Retry options
        "/R:3 /W:5", `
        # Log options
        "/X /V /FP /NS /NP /TEE", `
        # Log file
        "/log:`"$sLogFile`"" ))
    }

    [bool] run() {
    <#
    .SYNOPSIS
        Run a robocopy command.
        Returns true if the command succeeded, false otherwise
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pProcess.run()
    #>
        # Execute
        $iExitCode = ([CProcess]$this).Run()

        # Analyse error exit code
        $this.m_pWriter.noticel( "Exit code: " )
        if( $iExitCode -gt 8 ) {
            $this.m_pWriter.error( "NOK code: " + $iExitCode )
            $bReturn = $false
        } else {
            $this.m_pWriter.success( "OK code: " + $iExitCode )
            $bReturn = $true
        }

        return $bReturn
    }
}

# -----------------------------------------------------------------------------
# Defragments a specified file or files
# -----------------------------------------------------------------------------

class CContiger : CProcess {

    # Properties

    # Constructors

    CContiger( [string] $sPath ) {
        if( [string]::IsNullOrWhiteSpace( $sPath )) {
            throw "Usage: [CContiger]::new( <path as string> )"
        }

        # Exec
        $this.setExePath( "`"C:\Program Files\SysinternalsSuite\Contig.exe`"")

        # Arguments list
        $this.setArgument( @( `
        # Options
        "-s -q -nobanner"
        # Path
        "`"$sPath\*`"" ))

    }

    [bool] run() {
    <#
    .SYNOPSIS
        Run a robocopy command.
        Returns true if the command succeeded, false otherwise
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pProcess.run()
    #>

        # Execute
        $iExitCode = ([CProcess]$this).Run()

        # Analyse error exit code
        $this.m_pWriter.noticel( "Exit code: " )
        if( $iExitCode -ne 0 ) {
            $this.m_pWriter.error( "NOK code: " + $iExitCode )
            $bReturn = $false
        } else {
            $this.m_pWriter.success( "OK code: " + $iExitCode )
            $bReturn = $true
        }

        return $bReturn
    }

}