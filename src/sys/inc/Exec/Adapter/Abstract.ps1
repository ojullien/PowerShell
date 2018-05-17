<#PSScriptInfo

.VERSION 1.2.0

.GUID eb202f80-0002-47c2-9196-01370ebd498f

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\Exec\Program.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Adapter abstract class

#>

class ExecAdapterAbstract : ExecAdapterInterface {

    # Properties

    [ValidateNotNull()]
    [Program] $m_pProgram

    [ValidateNotNull()]
    [bool] $m_bSaveOutput = $false

    [ValidateNotNull()]
    [string] $m_sOutput = ''

    # Constructors

    ExecAdapterAbstract() {
    <#
    .SYNOPSIS
        Abstract constructor. This class must be overridden.
    .DESCRIPTION
        See synopsis.
    #>
        $oType = $this.GetType()

        if( $oType -eq [ExecAdapterAbstract] )
        {
            throw("Abstract class $oType must be inherited")
        }
    }

    # Class methods

    [ExecAdapterInterface] noOutput() {
    <#
    .SYNOPSIS
        Does not allow the read of the output stream.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [ExecAdapterInterface]$instance.noOutput()
    #>
        $this.m_bSaveOutput = $false
        $this.m_sOutput = ''
        return $this
    }

    [ExecAdapterInterface] saveOutput() {
    <#
    .SYNOPSIS
        Allows the read of the output stream.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [ExecAdapterInterface]$instance.saveOutput()
    #>
        $this.m_bSaveOutput = $true
        $this.m_sOutput = ''
        return $this
    }

    [string] getOutput() {
    <#
    .SYNOPSIS
        Returns the raw program output.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $instance.getOutput()
    #>
        return $this.m_sOutput
    }

    [string[]] getSplitedOutput() {
    <#
    .SYNOPSIS
        Returns a string array that contains the program output
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [ExecAdapterInterface]$instance.getOutput()
    #>
        $this.m_sOutput = $this.m_sOutput -replace "\r\n$", ""
        if ( $this.m_sOutput.Contains( "`r`n" ) ) {
            $this.m_sOutput = $this.m_sOutput -split "`r`n"
        } elseif ( $this.m_sOutput.Contains( "`n" ) ) {
            $this.m_sOutput = $this.m_sOutput -split "`n"
        }
        return $this.m_sOutput
    }

    [ExecAdapterInterface] setProgram( [Program] $pProgram ) {
    <#
    .SYNOPSIS
        Set the program path, file name and arguments.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [ExecAdapterInterface]$instance.setProgram( <instance of Exec\Program> )
    .PARAMETER pProgram
        An instance of Exec\Program.
    #>
        if( $pProgram -eq $null ) {
            throw 'Usage: [ExecAdapterInterface]$instance.pProgram( <path as Exec\Program instance> )'
        }
        $this.m_pProgram = $pProgram
        return $this
    }

}
