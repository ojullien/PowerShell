<#PSScriptInfo

.VERSION 1.3.0

.GUID e5f0d849-0003-4c6a-b731-2b6bc8364595

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys,app\LogExtractor

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180620
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Extract-Log App class

#>

class LogExtractor {

    # Properties

    [ValidateNotNull()]
    hidden [SevenZip] $m_pSevenZip

    [ValidateCount(2,2)]
    [hashtable] $error = @{ code = 0; message = '' }

    # Constructors

    LogExtractor() {
        throw "Usage: [LogExtractor]::new( <program as [Exec\SevenZip]> )"
    }

    LogExtractor ( [SevenZip] $program ) {
        if( $program -eq $null ) {
            throw "Usage: [LogExtractor]::new( <program as [Exec\SevenZip]> )"
        }
        $this.m_pSevenZip = $program
    }

    # Class methods

    [String] ToString() {
        return "[LogExtractor] Configuration`n" + `
        "`tProgram: $( [string]$this.m_pSevenZip )"
    }

    [LogExtractor] setArchive( [string] $archive ) {
    <#
    .SYNOPSIS
        Set the archive file name and path.
        Raises an error if the path is not valid.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [LogExtractor]$instance.setArchive( <archive file as [string]> )
    .PARAMETER archive
        The archive path as string. May be a folder.
    #>
        $this.m_pSevenZip.setArchive( $archive )
        return $this
    }

    [LogExtractor] setOutputDir( [string] $outputdir ) {
    <#
    .SYNOPSIS
        Specifies a destination directory where files are to be extracted.
        Raises an error if the path is not valid.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [LogExtractor]$instance.setOutputDir( <output dir as [string]> )
    .PARAMETER outputdir
        The destination directory as string.
    #>
        $this.m_pSevenZip.setOutputDir( $outputdir )
        return $this
    }

    [bool] extract( [bool]$withfullpaths=$false, [string]$file='', [bool]$recurse=$false ) {
    <#
    .SYNOPSIS
        Extracts files from an archive to the output directory.
        Files on disk with same filenames as in archive will be overwritten.
        $withfullpaths specifies the command extracts files from the archive with their full paths.
        $file specifies the specific file to extract
        $recurse specifies the method of treating wildcards and filenames on the command line.
        Returns true if the command succeeded and false otherwise.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [LogExtractor]$instance.extract()
    .PARAMETER withfullpaths
        If true: extracts files from an archive with their full paths.
    .PARAMETER file
        Specifies the files to extract like *.doc
    .PARAMETER recurse
        Specifies the method of treating wildcards and filenames on the command line.
        if $true: Enable recurse subdirectories.
    #>
        # Initialize
        [bool] $bReturn = $false
        $this.error.code = 0
        $this.error.message = ''

        # Check parameters
        if( $this.m_pSevenZip -eq $null ) {
            throw '[LogExtractor]::extract(). The program is not set.'
        }

        # Extract
        $bReturn = $this.m_pSevenZip.extract( $withfullpaths, $file, $recurse )
        $this.error.code = $this.m_pSevenZip.getExitCode()

        return $bReturn
    }

}
