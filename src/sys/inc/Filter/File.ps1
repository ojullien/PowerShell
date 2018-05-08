<#PSScriptInfo

.VERSION 1.1.0

.GUID 323d3bb5-0004-4013-8e9e-142f6d540831

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
 File filter class

#>

class File : FilterAbstract {

    # Properties

    # Constructors

    File() {}

    # Methods

    [bool] isValid( [string] $sPath ) {
    <#
    .SYNOPSIS
        Determines whether the syntax of the path is correct.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        isValid( 'path of the file' )
    .PARAMETER sPath
        The path to test.
    #>
        if( [string]::IsNullOrWhiteSpace( $sPath ) ) {
            throw "Usage: [File]::isValid( <path as string> )"
        }

        # Validate using Test-Path
        $sPath = [string] $sPath.Trim().Trim( [system.io.path]::DirectorySeparatorChar )
        $bReturn = $( Test-Path -LiteralPath $sPath -IsValid )

        if( $bReturn ) {
            # Perform extra-check on each path parts looking for ':'
            $pathParts = $sPath.Split( [system.io.path]::DirectorySeparatorChar )
            foreach( $sPart in $pathParts ) {
                if( $( $sPart.Length -eq 2 ) -and $( $sPart[1] -eq ':' ) ){
                    # Qualifier / drive
                    continue
                } elseif( $sPart.IndexOfAny( [System.IO.Path]::GetInvalidFileNameChars() ) -ne -1 ) {
                    $bReturn = $false
                    break
                } else {
                    continue
                }
            }
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

    static [bool] checkFile( [Writer] $pWriter, [string] $sTxt, [string] $sPath ) {
    <#
    .SYNOPSIS
        Checks if a file exists.
        If the file exits then writes a success type message and returns true.
        If the file does not exit then writes an error type message and returns false.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [CValidator]::checkFile( <Instance of Writer>, 'Text to display', 'path of the file' )
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
