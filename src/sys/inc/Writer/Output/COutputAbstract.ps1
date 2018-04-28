<#PSScriptInfo

.VERSION 1.0.0

.GUID 2f89a2a1-6963-4867-a7e6-fc713a2a69a2

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180409
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 Output abstract and interface class

#>

class COutputAbstract {

    # Properties

    hidden [bool] $bActivated = $true

    # Constructors

    COutputAbstract() {
    <#
    .SYNOPSIS
        Abstract constructor. This class must be overridden.
    .DESCRIPTION
        See synopsis.
    #>
        $oType = $this.GetType()

        if( $oType -eq [COutputAbstract] )
        {
            throw("Class $oType must be inherited")
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

    # Child methods

    [void] error( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes an error type message.
        This method must be overridden by a child class.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        error 'This is an error type message'
    .PARAMETER sTxt
        The text to write.
    #>
        throw("This method must be overridden")
    }

    [void] success( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes a success type message.
        This method must be overridden by a child class.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        success 'This is a success type message'
    .PARAMETER sTxt
        The text to write.
    #>
        throw("This method must be overridden")
    }

    [void] notice( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes a message.
        This method must be overridden by a child class.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        notice 'This is a message'
    .PARAMETER sTxt
        The text to write.
    #>
        throw("This method must be overridden")
    }

    [void] noticel( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes a message and does not go to the line.
        This method must be overridden by a child class.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        noticel 'this is a '
    .PARAMETER sTxt
        The text to write.
    #>
        throw("This method must be overridden")
    }
}
