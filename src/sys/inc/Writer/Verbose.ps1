<#PSScriptInfo

.VERSION 1.2.0

.GUID 73c97ada-0005-4f07-b18f-e1a38ac3a132

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer\Writer.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Writer class for test

#>

class Verbose : Writer {

    # Properties

    hidden [bool] $m_bVerbose = $false
    hidden [int] $m_iCount = 0
    hidden [int] $m_iCountMax = 80

    # Constructors

    Verbose() {}

    Verbose( [bool] $bVerbose = $false, [int] $iCountMax = 80 ) {
        $this.m_bVerbose = $bVerbose
        $this.m_iCountMax = $iCountMax
    }

    # Class methods

    [void] doVerbose( [char] $cValue ) {

        $this.m_iCount += 1
        if( $this.m_iCount -gt $this.m_iCountMax ) {
            ([Writer]$this).notice( $cValue )
            $this.m_iCount = 0
        } else {
            ([Writer]$this).noticel( $cValue )
        }

    }

    [void] exception( [string] $sTxt ) {

        if( $this.m_bVerbose ) {
            ([Writer]$this).error( $sTxt )
        } else {
            $this.doVerbose( 'E' )
        }

    }

    # Parent methods

    [void] error( [string] $sTxt ) {

        if( $this.m_bVerbose ) {
            ([Writer]$this).error( $sTxt )
        } else {
            $this.doVerbose( 'X' )
        }

    }

    [void] success( [string] $sTxt ) {

        if( $this.m_bVerbose ) {
            ([Writer]$this).success( $sTxt )
        } else {
            $this.doVerbose( '.' )
        }

    }

    [void] notice( [string] $sTxt ) {

        if( $this.m_bVerbose ) {
            ([Writer]$this).notice( $sTxt )
        }

    }

    [void] noticel( [string] $sTxt ) {

        if( $this.m_bVerbose ) {
            ([Writer]$this).noticel( $sTxt )
        }

    }

    [void] separateLine() {

        if( $this.m_bVerbose ) {
            ([Writer]$this).separateLine()
        }

    }

}
