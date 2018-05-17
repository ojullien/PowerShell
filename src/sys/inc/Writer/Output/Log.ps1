<#PSScriptInfo

.VERSION 1.2.0

.GUID 73c97ada-0004-4f07-b18f-e1a38ac3a132

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer\Output\Abstract.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

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
