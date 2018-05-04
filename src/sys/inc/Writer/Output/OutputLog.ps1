<#PSScriptInfo

.VERSION 1.1.0

.GUID 2f89a2a1-6963-4867-a7e6-fc713a2a69a3

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
 Log File output class

#>

class OutputLog : OutputAbstract {

    # Properties

    hidden [ValidateNotNullOrEmpty()] [string] $sPath

    # Constructors

    OutputLog( [string] $sPath ) {
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
