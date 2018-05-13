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

    # Constructors

    CallOperator() {
        $this.m_bSaveOutput = $false
        $this.m_sOutput = ''
    }

    # Class methods

    [int] run() {
    <#
    .SYNOPSIS
        Runs a program.
        Returns the program exit code.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [CallOperator]$instance.run()
    #>
        # Initialize
        $this.m_sOutput = ''
        $OFS = ' '

        # Argument test
        if( $this.m_pProgram -eq $null ) {
            throw 'Program is not set.'
        }

        # Run
        if( $this.m_bSaveOutput ) {
            [string] $sBuffer = & $this.m_pProgram.getProgramPath() $this.m_pProgram.getArguments()
            $this.m_sOutput = $sBuffer.Trim()
        } else {
            $null = & $this.m_pProgram.getProgramPath() $this.m_pProgram.getArguments()
        }

        return [int]$LASTEXITCODE
    }

}
