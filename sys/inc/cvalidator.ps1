<#PSScriptInfo

.VERSION 1.0.0

.GUID e6b27d66-3c4d-446c-8895-528e4358f765

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\writer.ps1

.RELEASENOTES
Date: 20180409
Powershell Version: 5.1

#>

<#

.DESCRIPTION
 File System functions

#>

class CValidator {

    # Properties

    # Constructors

    CValidator() {}

    # Methods

    static [bool] existsFolder( [string] $sPath ) {
    <#
    .SYNOPSIS
        Checks if a directory exists.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [CValidator]::existsFolder( 'path of the folder' )
    .PARAMETER sTxt
        The path to test.
    #>
        if( [string]::IsNullOrWhiteSpace( $sPath ) ) {
            throw "Usage: [CValidator]::existsFolder( <path as string> )"
        }
        return $( Test-Path -LiteralPath $sPath -PathType Container )
    }

    static [bool] checkDir( [CWriter] $pWriter, [string] $sTxt, [string] $sPath ) {
    <#
    .SYNOPSIS
        Checks if a directory exists.
        If the folder exits then writes a success type message and returns true.
        If the folder does not exit then writes an error type message and returns false.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [CValidator]::checkDir( <Instance of CWriter>, 'Text to display', 'path of the folder' )
    .PARAMETER pWriter
        An instance of writer.
    .PARAMETER sTxt
        The text to write.
    .PARAMETER sTxt
        The path to test.
    #>
        $pWriter.noticel( $sTxt )
        if( [CValidator]::existsFolder( $sPath ) ) {
            $pWriter.success( "exists" )
            $bReturn = $true
        } else {
            $pWriter.error( "is missing" )
            $bReturn = $false
        }
        return $bReturn
    }

    static [bool] existsFile( [string] $sPath ) {
    <#
    .SYNOPSIS
        Checks if a file exists.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [CValidator]::existsFile( 'path of the file' )
    .PARAMETER sTxt
        The path to test.
    #>
        if( [string]::IsNullOrWhiteSpace( $sPath ) ) {
            throw "Usage: [CValidator]::existsFile <path as string>"
        }
        return $( Test-Path -LiteralPath $sPath -PathType Leaf )
    }

    static [bool] checkFile( [CWriter] $pWriter, [string] $sTxt, [string] $sPath ) {
    <#
    .SYNOPSIS
        Checks if a file exists.
        If the file exits then writes a success type message and returns true.
        If the file does not exit then writes an error type message and returns false.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [CValidator]::checkFile( <Instance of CWriter>, 'Text to display', 'path of the file' )
    .PARAMETER pWriter
        An instance of writer.
    .PARAMETER sTxt
        The text to write.
    .PARAMETER sTxt
        The path to test.
    #>
        $pWriter.noticel( $sTxt )
        if( [CValidator]::existsFile( $sPath ) ) {
            $pWriter.success( "exists" )
            $bReturn = $true
        } else {
            $pWriter.error( "is missing" )
            $bReturn = $false
        }
        return $bReturn
    }
}