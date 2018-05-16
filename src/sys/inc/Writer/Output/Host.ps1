<#PSScriptInfo

.VERSION 1.2.0

.GUID 73c97ada-0003-4f07-b18f-e1a38ac3a132

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
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Host output class

#>

class OutputHost : OutputAbstract {

    # Constructors

    OutputHost() {}

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
