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

.REQUIREDSCRIPTS sys\inc\Writer, sys\inc\Filter\FilterAbstract.ps1

.RELEASENOTES
Date: 20180501
Powershell Version: 6.0.2

#>

<#

.DESCRIPTION
 Path filter class

#>

class PathInfo : FilterAbstract {

    # Properties

    hidden $aPathInfo = @{
        directoryname = ""
        filename = ""
        basename = ""
        extension = ""
        PathRoot = ""
    }

    # Constructors

    PathInfo() {}

    # Methods

    [array] doFilter( [string] $value ) {
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
