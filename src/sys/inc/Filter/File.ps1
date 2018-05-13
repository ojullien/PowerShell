<#PSScriptInfo

.VERSION 1.2.0

.GUID 323d3bb5-0004-4013-8e9e-142f6d540831

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\Filter\FilterAbstract.ps1, sys\inc\Filter\Path.ps1

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 File filter class

#>

class File : FilterAbstract {

    # Properties

    # Constructors

    File() {}

    # Methods

    [bool] isValid( [Path] $pPath ) {
    <#
    .SYNOPSIS
        Determines whether the syntax of the path is correct.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        isValid( 'path of the file' )
    .PARAMETER pPath
        The path to test as an instance of Filter\Path object.
    #>
        if( $pPath -eq $null ) {
            throw 'Usage: [File]$instance.isValid( <path as Filter\Path instance> )'
        }
        return $pPath.isValid()
    }

    [bool] exists( [Path] $pPath ) {
    <#
    .SYNOPSIS
        Determines whether all elements of a path exist.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        exists( 'path of the file' )
    .PARAMETER pPath
        The path to test as an instance of Filter\Path object.
    #>
        # Initialize
        [bool] $bReturn = $false

        # Argument test
        if( $pPath -eq $null ) {
            throw 'Usage: [File]$instance.exists( <path as Filter\Path instance> )'
        }

        # Test
        try {
            $bReturn = $pPath.isValid() -and $( Test-Path -LiteralPath "$([string]$pPath)" -PathType Leaf )
        }
        catch {
            $bReturn = $false
        }

        return $bReturn
    }

    [bool] exists( [Writer] $pWriter, [string] $sTxt, [Path] $pPath ) {
    <#
    .SYNOPSIS
        Determines verbosely whether all elements of a path exist.
        If the file exits then writes a success type message and returns true.
        If the file does not exit then writes an error type message and returns false.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        exists( <Instance of Writer>, 'Text to display', 'path of the file' )
    .PARAMETER pWriter
        An instance of writer class.
    .PARAMETER sTxt
        The text to write.
    .PARAMETER pPath
        The path to test as an instance of Filter\Path object.
    #>
        $pWriter.noticel( $sTxt )
        if( $this.exists( $pPath )) {
            $pWriter.success( "exists" )
            $bReturn = $true
        } else {
            $pWriter.error( "is missing" )
            $bReturn = $false
        }
        return $bReturn
    }


    [string] doFilter( [Path] $value ) {
    <#
    .SYNOPSIS
        Returns Split-Path -parent $value
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        doFilter( value )
    .PARAMETER value
        The value to filter as an instance of Filter\Path object.
    #>
        if( $value -eq $null ) {
            throw 'Usage: [File]$instance.doFilter( <path as Filter\Path instance> )'
        }

        if( $value.isValid() ) {
            $sReturn = [string] $( Split-Path -parent "$([string]$value)" )
        } else {
            $sReturn = ''
        }
        return $sReturn
    }

}

