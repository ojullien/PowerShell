<#PSScriptInfo

.VERSION 1.3.0

.GUID 73c97ada-0006-4f07-b18f-e1a38ac3a132

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer\Interface.ps1, src\sys\inc\Writer\Output\OutputAbstract.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180620
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Writer classes

#>

class Writer : WriterInterface {

    # Properties

    [ValidateCount(0,2)]
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
