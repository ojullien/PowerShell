<#PSScriptInfo

.VERSION 1.2.0

.GUID 323d3bb5-0001-4013-8e9e-142f6d540831

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Filter abstract and interface class

#>

class FilterAbstract {

    # Properties

    # Constructors

    FilterAbstract() {
    <#
    .SYNOPSIS
        Abstract constructor. This class must be overridden.
    .DESCRIPTION
        See synopsis.
    #>
        $oType = $this.GetType()

        if( $oType -eq [FilterAbstract] )
        {
            throw("Class $oType must be inherited")
        }
    }

    # Methods

    [string] doFilter( [string] $value ) {
    <#
    .SYNOPSIS
        Returns the result of filtering $value.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        doFilter( value )
    .PARAMETER value
        The value to test.
    #>
        throw("This method must be overridden")
    }

}
