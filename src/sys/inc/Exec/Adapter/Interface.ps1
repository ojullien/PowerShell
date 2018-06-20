<#PSScriptInfo

.VERSION 1.3.0

.GUID eb202f80-0009-47c2-9196-01370ebd498f

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
Date: 20180620
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Adapter interface

#>

class ExecAdapterInterface {

    # Constructors

    ExecAdapterInterface() {
    <#
    .SYNOPSIS
        Abstract constructor. This class must be overridden.
    .DESCRIPTION
        See synopsis.
    #>
        $oType = $this.GetType()

        if( $oType -eq [ExecAdapterInterface] )
        {
            throw("Interface $oType must be inherited")
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
        throw("This method must be overridden")
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
        throw("This method must be overridden")
    }

    [string] getOutput() {
    <#
    .SYNOPSIS
        Returns the raw program output.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [ExecAdapterInterface]$instance.getOutput()
    #>
        throw("This method must be overridden")
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
        throw("This method must be overridden")
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
        throw("This method must be overridden")
    }

    [int] run() {
    <#
    .SYNOPSIS
        Runs a program.
        Returns the program exit code.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [ExecAdapterInterface]$instance.run()
    #>
        throw("This method must be overridden")
    }

}
