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

    [ValidateNotNull()]
    [hashtable] $info

    # Constructors

    Path() {
        # Attention: directoryname may be empty but pathroot not like for 'c:\' path
        $this.info = @{directoryname = ""; filename = ""; basename = ""; extension = ""; pathroot = ""}
    }

    Path( [string] $value ) {
        $null = $this.doFilter( $value )
    }

    # Methods

    [string] ToString() {

        [string] $sReturn = ""

        # Add path root
        if( $this.info.pathroot.Length -ne 0 ){
            $sReturn = $this.info.pathroot + [System.IO.Path]::DirectorySeparatorChar
        }

        # Add directory name
        $sReturn = $sReturn + $this.info.directoryname

        # Add filename
        if( ($this.info.filename.Length -ne 0) -and ($sReturn.Length -ne 0) -and ( !$sReturn.EndsWith( [System.IO.Path]::DirectorySeparatorChar ))){
            $sReturn = $sReturn + [System.IO.Path]::DirectorySeparatorChar
        }
        $sReturn = $sReturn + $this.info.filename

        return $sReturn
    }

    [string] getDirectoryName() {
        return $this.info.directoryname
    }

    [string] getFilename() {
        return $this.info.filename
    }

    [string] getBasename() {
        return $this.info.basename
    }

    [string] getExtension() {
        return $this.info.extension
    }

    [string] getPathRoot() {
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
    #>
        # Always looking for X:\ path pattern
        [bool] $bReturn = ( ( $this.info.pathroot.Length -ne 0 ) -and ( $this.info.pathroot -match '^[a-zA-Z]:$' ) )

        # Validate filename
        $bReturn = $bReturn -and ( $this.info.filename.IndexOfAny( [System.IO.Path]::GetInvalidFileNameChars() ) -eq -1 )

        # Validate using Test-Path
        $bReturn = $bReturn  -and ( Test-Path -LiteralPath "$( [string]$this )" -IsValid )

        # Validate directory name
        if( $bReturn ) {
            # Perform extra-check on each path parts looking for ':'.
            # None of .NET or Test-Path functions raise an error if a directory's
            # name contains a ':'.
            $pathParts = $this.info.directoryname.Split( [System.IO.Path]::DirectorySeparatorChar )
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
        $this.info = @{directoryname = ""; filename = ""; basename = ""; extension = ""; pathroot = ""}

        # Argument test
        if( [string]::IsNullOrWhiteSpace( $value ) ) {
            throw 'Usage: [Path]$instance.doFilter( <path as string> )'
        }

        # Filter
        try {
            $value = [string] $value.Trim().TrimEnd( [System.IO.Path]::DirectorySeparatorChar )
            $this.info = @{
                directoryname = [string][System.IO.Path]::GetDirectoryName( "$value" )
                filename = [string][System.IO.Path]::GetFileName( "$value" )
                basename = [string][System.IO.Path]::GetFileNameWithoutExtension( "$value" )
                extension = [string][System.IO.Path]::GetExtension( "$value" )
                pathroot = $( [string][System.IO.Path]::GetPathRoot( "$value" ) ).TrimEnd( [System.IO.Path]::DirectorySeparatorChar ) }
        }
        catch {
            $this.info = @{directoryname = ""; filename = ""; basename = ""; extension = ""; pathroot = ""}
        }

        # Remove path root to directory name
        if( ( $this.info.pathroot.length -ne 0 ) -and ( $this.info.directoryname.StartsWith( "$($this.info.pathroot)"))) {
            $this.info.directoryname = $this.info.directoryname.Remove( 0, $this.info.pathroot.length ).TrimStart( [System.IO.Path]::DirectorySeparatorChar )
        }

        return $this.info

    }

}
