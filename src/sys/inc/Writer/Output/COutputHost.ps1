<#PSScriptInfo

.VERSION 1.0.0

.GUID 2f89a2a1-6963-4867-a7e6-fc713a2a69a4

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS COutputAbstract.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180409
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 Host output class

#>

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
