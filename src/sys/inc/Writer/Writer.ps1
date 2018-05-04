<#PSScriptInfo

.VERSION 1.1.0

.GUID 2f89a2a1-6963-4867-a7e6-fc713a2a69a1

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS Writer/Output/OutputAbstract.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 Writer classes

#>

class Writer {

    # Properties

    hidden [OutputAbstract[]] $aOutputs = @()

    # Constructors

    Writer() {}

    # Methods

    [String] ToString()
    {
        $sReturn = "Writer contains " + $this.aOutputs.Length + " output(s). "
        foreach( $pOutput in $this.aOutputs )
        {
            $sReturn += $pOutput
        }
        return $sReturn
    }

    [void] addOutput( [OutputAbstract] $pOutput ) {
    <#
    .SYNOPSIS
        Add an output to the writer.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        addOutput( [OutputHost]::new() )
    .PARAMETER pOutput
        An instance of OutputAbstract.
    #>
        $this.aOutputs += $pOutput
    }

    [void] error( [string] $sTxt ) {
    <#
    .SYNOPSIS
        Writes an error type message to the outputs.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        error 'This is an error type message'
    .PARAMETER sTxt
        The text to write.
    #>
        foreach( $pOutput in $this.aOutputs )
        {
            $pOutput.error( $sTxt )
        }
    }

    [void] success( [string] $sTxt ) {
    <#
    .SYNOPSIS
        Writes a success type message to the outputs.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        success 'This is a success type message'
    .PARAMETER sTxt
        The text to write.
    #>
        foreach( $pOutput in $this.aOutputs )
        {
            $pOutput.success( $sTxt )
        }
    }

    [void] notice( [string] $sTxt ) {
    <#
    .SYNOPSIS
        Writes a message to the outputs.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        notice 'This is a message'
    .PARAMETER sTxt
        The text to write.
    #>
        foreach( $pOutput in $this.aOutputs )
        {
            $pOutput.notice( $sTxt )
        }
    }

    [void] noticel( [string] $sTxt ) {
    <#
    .SYNOPSIS
        Writes a message with no new line to the outputs.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        noticel 'this is a '
    .PARAMETER sTxt
        The text to write.
    #>
        foreach( $pOutput in $this.aOutputs )
        {
            $pOutput.noticel( $sTxt )
        }
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
        $this.notice( "---------------------------------------------------------------------------" )
    }

}
