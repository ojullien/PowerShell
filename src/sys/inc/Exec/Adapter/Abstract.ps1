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

.REQUIREDSCRIPTS sys\inc\Exec\Program.ps1, sys\inc\Exec\Program.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Adapter abstract and interface class for Exec programs

#>

class ExecAdapterAbstract {

    # Properties

    [ValidateNotNull()]
    [Program] $m_pProgram

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
            throw("Class $oType must be inherited")
        }
    }

    # Class methods

    [ExecAdapterAbstract] setProgram( [Program] $pProgram ) {
    <#
    .SYNOPSIS
        Set the program path, file name and arguments.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $instance.setProgram( <instance of Exec\Program> )
    .PARAMETER pProgram
        An instance of Exec\Program.
    #>
        if( $pProgram -eq $null ) {
            throw 'Usage: [ExecAdapterAbstract]$instance.pProgram( <path as Exec\Program instance> )'
        }
        $this.m_pProgram = $pProgram
        return $this
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
        throw("This method must be overridden")
    }

}
