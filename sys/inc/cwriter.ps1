<#PSScriptInfo

.VERSION 1.0.0

.GUID 2f89a2a1-6963-4867-a7e6-fc713a2a69a1

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS .,.

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180409
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 Writer & Output classes

#>

# -----------------------------------------------------------------------------
# Output abstract and interface
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# Log File output
# -----------------------------------------------------------------------------
class COutputLog : COutputAbstract {

    # Properties

    hidden [ValidateNotNullOrEmpty()] [string] $sPath

    # Constructors

    COutputLog( [string] $sPath ) {
        $this.sPath = $sPath
    }

    # Methods

    [void] error( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes a message to the file.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        error 'This is an error type message'
    .PARAMETER sTxt
        The text to write.
    #>
        if( $this.bActivated ) {
            Add-Content -Path $this.sPath -Value "ERROR: $sTxt"
        }
    }

    [void] success( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes a message to the file.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        success 'This is a success type message'
    .PARAMETER sTxt
        The text to write.
    #>
        if( $this.bActivated ) {
            Add-Content -Path $this.sPath -Value "SUCCESS: $sTxt"
        }
    }

    [void] notice( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes a message to the file.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        notice 'This is a message'
    .PARAMETER sTxt
        The text to write.
    #>
        if( $this.bActivated ) {
            Add-Content -Path $this.sPath -Value $sTxt
        }
    }

    [void] noticel( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes a message to the file and does not go to the line.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        noticel 'this is a '
    .PARAMETER sTxt
        The text to write.
    #>
        if( $this.bActivated ) {
            Add-Content -Path $this.sPath -NoNewline $sTxt
        }
    }

}

# -----------------------------------------------------------------------------
# Host output
# -----------------------------------------------------------------------------
class COutputHost : COutputAbstract {

    # Constructors

    COutputHost() {}

    # Methods

    [void] error( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes a message in red color to the host.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        error 'This is an error type message'
    .PARAMETER sTxt
        The text to write.
    #>
        if( $this.bActivated ) {
            Write-Host -BackgroundColor "Black" -ForegroundColor "Red" "ERROR: $sTxt"
        }
    }

    [void] success( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes a message in green color to the host.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        success 'This is a success type message'
    .PARAMETER sTxt
        The text to write.
    #>
        if( $this.bActivated ) {
            Write-Host -BackgroundColor "Black" -ForegroundColor "Green" "SUCCESS: $sTxt"
        }
    }

    [void] notice( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes a message to the host.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        notice 'This is a message'
    .PARAMETER sTxt
        The text to write.
    #>
        if( $this.bActivated ) {
            Write-Host $sTxt
        }
    }

    [void] noticel( [string] $sTxt ) {
    <#
    .SYNOPSIS
        If this writer is activated then writes a message to the host and does not go to the line.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        noticel 'this is a '
    .PARAMETER sTxt
        The text to write.
    #>
        if( $this.bActivated ) {
            Write-Host -NoNewline $sTxt
        }
    }

}

# -----------------------------------------------------------------------------
# Writer
# -----------------------------------------------------------------------------
class CWriter {

    # Properties

    hidden [COutputAbstract[]] $aOutputs = @()

    # Constructors

    CWriter() {}

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

    [void] addOutput( [COutputAbstract] $pOutput ) {
    <#
    .SYNOPSIS
        Add an output to the writer.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        addOutput( [COutputHost]::new() )
    .PARAMETER pOutput
        An instance of COutputAbstract.
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