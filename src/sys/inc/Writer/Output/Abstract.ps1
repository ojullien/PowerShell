<#PSScriptInfo

.VERSION 1.2.0

.GUID 73c97ada-0002-4f07-b18f-e1a38ac3a132

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES src\sys\inc\Writer\Output\Interface.ps1

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Output abstract class

#>

class OutputAbstract : OutputInterface {

    # Properties

    hidden [bool] $bActivated = $true

    # Constructors

    OutputAbstract() {
    <#
    .SYNOPSIS
        Abstract constructor. This class must be overridden.
    .DESCRIPTION
        See synopsis.
    #>
        $oType = $this.GetType()

        if( $oType -eq [OutputAbstract] )
        {
            throw("Abstract class $oType must be inherited")
        }
    }

    # Class methods

    [bool] isActivated() {
    <#
    .SYNOPSIS
        Returns true if the writer is activated. False otherwise.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pWriter.isActivated()
    #>
        return $this.bActivated
    }

    [void] activate() {
    <#
    .SYNOPSIS
        Activates the writer.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pWriter.activate()
    #>
        $this.bActivated = $true
    }

    [void] deactivate() {
    <#
    .SYNOPSIS
        Deactivates the writer.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pWriter.deactivate()
    #>
        $this.bActivated = $false
    }

    [String] ToString()
    {
        return "Output " + $this.GetType() + " is activated: " + $this.bActivated + ". "
    }

}
