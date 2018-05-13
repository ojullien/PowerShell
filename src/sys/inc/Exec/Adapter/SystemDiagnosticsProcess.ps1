<#PSScriptInfo

.VERSION 1.2.0

.GUID eb202f80-0005-47c2-9196-01370ebd498f

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
 This class is an adapter to executes a program using System.Diagnostics.Process

#>

class SystemDiagnosticsProcess : ExecAdapterAbstract {

    # Properties

    [bool] $m_bUseShellExecute = $false
    [bool] $m_bRedirectStandardOutput = $true

    # Constructors

    SystemDiagnosticsProcess() {
        $this.m_bUseShellExecute = $false
        $this.m_bRedirectStandardOutput = $true
        $this.m_bSaveOutput = $false
        $this.m_sOutput = ''
    }

    # Class methods

    [int] run() {
    <#
    .SYNOPSIS
        Runs a program.
        Returns the program exit code.
    .DESCRIPTIONs
        See synopsis.
    .EXAMPLE
        [SystemDiagnosticsProcess]$instance.run()
    #>
        # Initialize
        $this.m_sOutput = ''
        $OFS = ' '

        # Argument test
        if( $this.m_pProgram -eq $null ) {
            throw '[Program] is not set.'
        }

        # Run
        $pProcess = New-Object System.Diagnostics.Process
        $pProcess.StartInfo.FileName = $this.m_pProgram.getProgramPath()
        $pProcess.StartInfo.Arguments = $this.m_pProgram.getArguments()
        $pProcess.StartInfo.UseShellExecute = $this.m_bUseShellExecute
        $pProcess.StartInfo.RedirectStandardOutput = $this.m_bRedirectStandardOutput

        if( $pProcess.Start() ) {
            # Read output. To avoid deadlocks, always read the output stream first and then wait.
            if( $this.m_bSaveOutput -and $this.m_bRedirectStandardOutput -and !$this.m_bUseShellExecute ) {
                [string] $sBuffer = $pProcess.StandardOutput.ReadToEnd()
                $this.m_sOutput = $sBuffer.Trim()
            }
        }

        $pProcess.WaitForExit()
        [int]$iReturn = $pProcess.ExitCode
        $pProcess.Close();

        return $iReturn
    }

}
