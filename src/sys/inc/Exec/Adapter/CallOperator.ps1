<#PSScriptInfo

.VERSION 1.2.0

.GUID eb202f80-0003-47c2-9196-01370ebd498f

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
 This class is an adapter to executes a program using the call operator &

#>

class CallOperator : ExecAdapterAbstract {

    # Properties

    [bool] $m_bSaveOutput = $false
    [string] $m_sOutput = ''

    # Constructors

    CallOperator() {
        $this.m_bSaveOutput = $false
        $this.m_sOutput = ''
    }

    # Class methods

    [CallOperator] noOutput() {
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

    [CallOperator] saveOutput() {
    <#
    .SYNOPSIS
        Allows the read of the output stream.
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

        $this.m_sOutput = & $this.m_pProgram.getProgramPath() $this.m_pProgram.getArguments()
        [int] $iReturn = $LASTEXITCODE

        if( !$this.m_bSaveOutput ) {
            $this.m_sOutput = ''
        }

        return $iReturn
    }

}
