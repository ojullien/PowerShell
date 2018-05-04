<#PSScriptInfo

.VERSION 1.1.0

.GUID e6b27d66-3c4d-446c-8895-da21d91681a0

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
Date: 20180501
Powershell Version: 5.1

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
