<#PSScriptInfo

.VERSION 1.2.0

.GUID eb202f80-0004-47c2-9196-01370ebd498f

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\Exec\Adapter\Abstract.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 This class is an adapter to executes a program using Start-Process

#>

class StartProcess : ExecAdapterAbstract {

    # Properties

    [bool] $m_bSaveOutput = $false
    [string] $m_sOutput = ''

    # Constructors

    SystemDiagnosticsProcess() {
        $this.m_bUseShellExecute = $false
        $this.m_bRedirectStandardOutput = $true
        $this.m_bSaveOutput = $false
        $this.m_sOutput = ''
    }

    # Class methods

    [SystemDiagnosticsProcess] noOutput() {
    <#
    .SYNOPSIS
        Does not allow the read of the output stream.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $instance.noOutput()
    #>
        $this.m_bSaveOutput = $false
        $this.m_sOutput = ''
        return $this
    }

    [SystemDiagnosticsProcess] saveOutput() {
    <#
    .SYNOPSIS
        Allows the read of the output stream.
        Works only if ProcessStartInfo.UseShellExecute = $false and ProcessStartInfo.RedirectStandardOutput = $true.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $instance.saveOutput()
    #>
        $this.m_bSaveOutput = $true
        $this.m_sOutput = ''
        return $this
    }

    [string] getOutput() {
    <#
    .SYNOPSIS
        Returns the program output.
        Works only if ProcessStartInfo.UseShellExecute = $false and ProcessStartInfo.RedirectStandardOutput = $true.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $instance.getOutput()
    #>
        return $this.m_sOutput
    }

    [int] run() {
    <#
    .SYNOPSIS
        Runs a program.
        Returns the program exit code.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $instance.run()
    #>
        if( $this.m_pProgram -eq $null ) {
            throw 'Program is not set.'
        }

        $this.m_sOutput = ''
        $OFS = " "

        $pProcess = New-Object System.Diagnostics.Process
        $pProcess.StartInfo.FileName = $this.m_pProgram.getProgramPath()
        $pProcess.StartInfo.Arguments = $this.m_pProgram.getArguments()
        $pProcess.StartInfo.UseShellExecute = $this.m_bUseShellExecute
        $pProcess.StartInfo.RedirectStandardOutput = $this.m_bRedirectStandardOutput

        if( $pProcess.Start() ) {
            # Read output. To avoid deadlocks, always read the output stream first and then wait.
            if( $this.m_bSaveOutput -and $this.m_bRedirectStandardOutput -and !$this.m_bUseShellExecute ) {
                $this.m_sOutput = $pProcess.StandardOutput.ReadToEnd()
#            $this.m_sOutput = $pProcess.StandardOutput.ReadToEnd() -replace "\r\n$",""
#            if ( $this.m_sOutput ) {
#                if( $this.m_sOutput.Contains("`r`n") ) {
#                    $this.m_sOutput = $this.m_sOutput -split "`r`n"
#                } elseif( $this.m_sOutput.Contains("`n") ) {
#                    $this.m_sOutput = $this.m_sOutput -split "`n"
#                }
#            }
            }
        }

        $pProcess.WaitForExit()
        [int]$iReturn = $pProcess.ExitCode
        $pProcess.Close();

        return $iReturn
    }

}
