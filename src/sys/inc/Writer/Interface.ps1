<#PSScriptInfo

.VERSION 1.3.0

.GUID 73c97ada-0005-4f07-b18f-e1a38ac3a132

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
Date: 20180620
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Writer interface

#>

class WriterInterface {

    # Properties

    # Constructors

    WriterInterface() {
    <#
    .SYNOPSIS
        Abstract constructor. This class must be overridden.
    .DESCRIPTION
        See synopsis.
    #>
        $oType = $this.GetType()

        if( $oType -eq [WriterInterface] )
        {
            throw("Interface $oType must be inherited")
        }
    }

    # Methods

    [void] error( [string] $sTxt ) {
    <#
    .SYNOPSIS
        Writes an error type message to the outputs.
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
        Writes a success type message to the outputs.
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
        Writes a message to the outputs.
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
        Writes a message with no new line to the outputs.
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


    [void] separateLine() {
    <#
    .SYNOPSIS
        Writes a line of - to the outputs.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        separateLine
    #>
        throw("This method must be overridden")
    }

}
