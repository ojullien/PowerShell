<#PSScriptInfo

.VERSION 1.2.0

.GUID 73c97ada-0007-4f07-b18f-e1a38ac3a132

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES src\sys\inc\Writer\Interface.ps1

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Writer class for test. This class is a writer decorator.
 Writes a dot '.' for a successful test, an 'X' for a failed test and a 'E' when an unexpected exception is raised.
 The verbose option writes the details.

#>

class VerboseDecorator : WriterInterface {

    # Properties

    [ValidateNotNull()]
    hidden [WriterInterface] $m_pDecorated

    [ValidateNotNull()]
    hidden [bool] $m_bVerbose = $false

    [ValidateRange(0, 120)]
    hidden [int] $m_iCount = 0     # Current position in the line

    [ValidateRange(0, 120)]
    hidden [int] $m_iCountMax = 80 # Max '.' or 'X' and 'E' in a line

    # Constructors

    VerboseDecorator() {
        throw "Usage: [VerboseDecorator]::new( <writer as [Writer\WriterInterface]>, <verbose activated as [bool]>, <max dot per line as [int]> )"
    }

    VerboseDecorator( [WriterInterface] $writer, [bool] $verbose = $false, [int] $max = 80 ){
        if( ($writer -eq $null) -or ($verbose -eq $null) -or ($max -eq $null) -or ($max -lt 1) ) {
            throw "Usage: [VerboseDecorator]::new( <writer as [Writer\WriterInterface]>, <verbose activated as [bool]>, <max dot per line as [int]> )"
        }
        $this.m_pDecorated = $writer
        $this.m_bVerbose = $verbose
        $this.m_iCountMax = $max
    }

    # Class methods

    [void] doVerbose( [char] $cValue ) {

        $this.m_iCount += 1
        if( $this.m_iCount -gt $this.m_iCountMax ) {
            $this.m_pDecorated.notice( $cValue )
            $this.m_iCount = 0
        } else {
            $this.m_pDecorated.noticel( $cValue )
        }

    }

    [void] exceptionExpected( [string] $sTxt ) {

        if( $this.m_bVerbose ) {
            $this.m_pDecorated.success( $sTxt )
        } else {
            $this.doVerbose( '.' )
        }

    }

    [void] exception( [string] $sTxt ) {

        if( $this.m_bVerbose ) {
            $this.m_pDecorated.error( $sTxt )
        } else {
            $this.doVerbose( 'E' )
        }

    }

    # Parent methods

    [void] error( [string] $sTxt ) {

        if( $this.m_bVerbose ) {
            $this.m_pDecorated.error( $sTxt )
        } else {
            $this.doVerbose( 'X' )
        }

    }

    [void] success( [string] $sTxt ) {

        if( $this.m_bVerbose ) {
            $this.m_pDecorated.success( $sTxt )
        } else {
            $this.doVerbose( '.' )
        }

    }

    [void] notice( [string] $sTxt ) {

        if( $this.m_bVerbose ) {
            $this.m_pDecorated.notice( $sTxt )
        }

    }

    [void] noticel( [string] $sTxt ) {

        if( $this.m_bVerbose ) {
            $this.m_pDecorated.noticel( $sTxt )
        }

    }

    [void] separateLine() {

        if( $this.m_bVerbose ) {
            $this.m_pDecorated.separateLine()
        }

    }

}
