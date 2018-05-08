<#PSScriptInfo

.VERSION 1.2.0

.GUID 323d3bb5-0002-4013-8e9e-142f6d540831

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\Filter\FilterAbstract.ps1

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Path filter class

#>

class Path : FilterAbstract {

    # Properties

    [hashtable] $info

    # Constructors

    Path() {
        $this.info = @{directoryname = ""; filename = ""; basename = ""; extension = ""; pathroot = ""}
    }

    Path( [string] $value ) {
        $null = $this.doFilter( $value )
    }

    # Methods

    [string] ToString() {
        return $this.info.directoryname + [System.IO.Path]::DirectorySeparatorChar + $this.info.filename
    }

    [string] directoryname() {
        return $this.info.directoryname
    }

    [string] filename() {
        return $this.info.filename
    }

    [string] basename() {
        return $this.info.basename
    }

    [string] extension() {
        return $this.info.extension
    }

    [string] pathroot() {
        return $this.info.pathroot
    }

    [bool] isValid() {
    <#
    .SYNOPSIS
        Determines whether the syntax of the path is correct.
        Path with length not greater than 3 is not valid.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        isValid()
    .PARAMETER sPath
        The path to test as string.
    #>

        # Validate using Test-Path
        $sPath = $this.ToString()
        [bool] $bReturn = $( Test-Path -LiteralPath "$sPath" -IsValid )

        # Removes path root from directory name
        if( $bReturn -and ( $sPath.length -gt 3 ) -and ( $sPath[1] -eq ':' ) -and ( $sPath[2] -eq [System.IO.Path]::DirectorySeparatorChar )) {
            $sPath = $sPath.substring(3)
        } else {
            $bReturn = $false
        }

        if( $bReturn ) {

            # Perform extra-check on each path parts looking for ':'.
            # None of .NET or Test-Path functions raise an error if a directory's
            # name contains a ':'.
            $pathParts = $sPath.Split( [System.IO.Path]::DirectorySeparatorChar )
            foreach( $sPart in $pathParts ) {
                if( $sPart.IndexOfAny( [System.IO.Path]::GetInvalidFileNameChars() ) -ne -1 ) {
                    $bReturn = $false
                    break
                } else {
                    continue
                }
            }
        }

        return $bReturn
    }

    [bool] isValid( [string] $value ) {
    <#
    .SYNOPSIS
        Determines whether the syntax of the path is correct.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        isValid( 'path' )
    .PARAMETER value
        The path to test as string.
    #>
        $null = $this.doFilter( $value )
        return $this.isValid()
    }

    [hashtable] doFilter( [string] $value ) {
    <#
    .SYNOPSIS
        Returns information about a file path
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        doFilter( value )
    .PARAMETER value
        The value to filter.
    #>
        # Initialize
        $this.info = @{directoryname = ""; filename = ""; basename = ""; extension = ""; PathRoot = ""}

        # Argument test
        if( [string]::IsNullOrWhiteSpace( $value ) ) {
            throw "Usage: [Path]::doFilter( <path as string> )"
        }

        # Filter
        try {
            $value = [string] $value.Trim().TrimEnd( [System.IO.Path]::DirectorySeparatorChar )
            $this.info = @{
                directoryname = [string][System.IO.Path]::GetDirectoryName( "$value" )
                filename = [string][System.IO.Path]::GetFileName( "$value" )
                basename = [string][System.IO.Path]::GetFileNameWithoutExtension( "$value" )
                extension = [string][System.IO.Path]::GetExtension( "$value" )
                PathRoot = $( [string][System.IO.Path]::GetPathRoot( "$value" ) ).TrimEnd( [System.IO.Path]::DirectorySeparatorChar ) }
        }
        catch {
            $this.info = @{directoryname = ""; filename = ""; basename = ""; extension = ""; PathRoot = ""}
        }

        return $this.info

    }

}
