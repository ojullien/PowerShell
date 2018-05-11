<#PSScriptInfo

.VERSION 1.2.0

.GUID eb202f80-0001-47c2-9196-01370ebd498f

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Filter\Path.ps1, src\sys\inc\Filter\File.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Class represents the program to be executed.

#>

class Program {

    # Properties

    [ValidateNotNull()]
    [string[]] $m_aArgumentCollection = @()

    [ValidateNotNull()]
    [string] $m_sProgramPath = ''

    # Constructors

    Program() {
        $this.m_aArgumentCollection = @()
        $this.m_sProgramPath = ''
    }

    # Class methods

    [string] ToString() {
        return "Program: " + $this.m_sProgramPath + "`nArgs: " + $this.m_aArgumentCollection
    }

    [string] getProgramPath() {
        return $this.m_sProgramPath
    }

    [Program] setProgramPath( [Path] $pPath ) {
    <#
    .SYNOPSIS
        Specify the file path and file name of the program to be executed.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [Program]$instance.setExePath( <path as Filter\Path instance> )
    .PARAMETER pPath
        The file path and file name of the program.
    #>
        if( $pPath -eq $null ) {
            throw 'Usage: [Program]$instance.setProgramPath( <path as Filter\Path instance> )'
        }
        if( ![File]::new().exists( $pPath ) ){
            throw "The program '$([string]$pPath)' is missing."
        }
        $this.m_sProgramPath = [string]$pPath
        return $this
    }

    [string] getArgument() {
        return $( $this.m_aArgumentCollection -join ' ' ).Trim()
    }

    [string[]] getArguments() {
        return $this.m_aArgumentCollection
    }

    [Program] addArgument( [string] $value ) {
    <#
    .SYNOPSIS
        Add an argument to the list.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [Program]$instance.addArgument( <argument as string> )
    .PARAMETER value
        An argument as string
    #>
        if( [string]::IsNullOrWhiteSpace( $value )) {
            throw 'Usage: [Program]$instance.addArgument( <argument as string> )'
        }
        $this.m_aArgumentCollection += [string]$value
        return $this
    }

    [Program] setArgument( [string[]] $collection ) {
    <#
    .SYNOPSIS
        Add a list of arguments.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $pProcess.addArgument( <argument as string> )
    .PARAMETER collection
        An array of string.
    #>
        if( $collection -eq $null ) {
            throw 'Usage: [Program]$instance.setArgument( <argument as array of string> )'
        }
        $this.m_aArgumentCollection = [string[]]$collection
        return $this
    }

}
