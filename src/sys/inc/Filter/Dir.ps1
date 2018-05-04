<#PSScriptInfo

.VERSION 1.1.0

.GUID e6b27d66-3c4d-446c-8895-da21d91681a1

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\writer

.RELEASENOTES
Date: 20180501
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 Path filter class

#>

class Dir : FilterAbstract {

    # Properties

    # Constructors

    Dir() {}

    # Methods

    [bool] exists( [string] $sPath ) {
    <#
    .SYNOPSIS
        Determines whether all elements of a path exist.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        exists( 'path of the folder' )
    .PARAMETER sPath
        The path to test.
    #>
        if( [string]::IsNullOrWhiteSpace( $sPath ) ) {
            throw "Usage: [Dir]::exists( <path as string> )"
        }

        $bReturn = $false
        try {
            $bReturn = $( $this.isValid( $sPath ) ) -and $( Test-Path -LiteralPath $sPath -PathType Container )
        }
        catch {
            $bReturn = $false
        }
        return $bReturn
    }

    [bool] isValid( [string] $sPath ) {
    <#
    .SYNOPSIS
        Determines whether the syntax of the path is correct.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        isValid( 'path of the folder' )
    .PARAMETER sPath
        The path to test.
    #>
        if( [string]::IsNullOrWhiteSpace( $sPath ) ) {
            throw "Usage: [Dir]::isValid( <path as string> )"
        }

        # Validate using Test-Path
        $sPath = [string] $sPath.Trim().Trim( [system.io.path]::DirectorySeparatorChar )
        $bReturn = $( Test-Path -LiteralPath $sPath -IsValid )

        if( $bReturn ) {
            # Perform extra-check on each path parts looking for ':'.
            # None of .NET or Test-Path functions raise an error if a directory's
            # name contains a ':'.
            $pathParts = $sPath.Split( [system.io.path]::DirectorySeparatorChar )
            foreach( $sPart in $pathParts ) {
                if( $( $sPart.Length -eq 2 ) -and $( $sPart[1] -eq ':' ) ){
                    # Qualifier / drive
                    continue
                } elseif( $sPart.IndexOfAny( [system.io.path]::GetInvalidFileNameChars() ) -ne -1 ) {
                    $bReturn = $false
                    break
                } else {
                    continue
                }
            }
        }

        return $bReturn
    }

    [bool] exists( [Writer] $pWriter, [string] $sTxt, [string] $sPath ) {
    <#
    .SYNOPSIS
        Determines verbosely whether all elements of a path exist.
        If the folder exits then writes a success type message and returns true.
        If the folder does not exit then writes an error type message and returns false.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        exists( <Instance of Writer>, 'Text to display', 'path of the folder' )
    .PARAMETER pWriter
        An instance of writer class.
    .PARAMETER sTxt
        The text to write.
    .PARAMETER sPath
        The path to test.
    #>
        $pWriter.noticel( $sTxt )
        if( $this.exists( $sPath )) {
            $pWriter.success( "exists" )
            $bReturn = $true
        } else {
            $pWriter.error( "is missing" )
            $bReturn = $false
        }
        return $bReturn
    }

    [string] doFilter( [string] $value ) {
    <#
    .SYNOPSIS
        Returns Split-Path -parent $value
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        doFilter( value )
    .PARAMETER value
        The value to filter.
    #>
        if( [string]::IsNullOrWhiteSpace( $value ) ) {
            throw "Usage: [Dir]::doFilter( <path as string> )"
        }

        if( $this.isValid( $value )) {
            $sReturn = [string] $( Split-Path -parent $value )
        } else {
            $sReturn = ''
        }
        return $sReturn
    }

}
