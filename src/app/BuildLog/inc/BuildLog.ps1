<#PSScriptInfo

.VERSION 1.2.0

.GUID fe85499f-0003-4ceb-931f-2831b75e3b2d

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys,app\BuildLog

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Build-Log App class

#>

class BuildLog {

    # Properties

    [ValidateNotNull()]
    hidden [SevenZip] $m_pSevenZip

    [ValidateCount(2,2)]
    [hashtable] $error = @{ code = 0; message = '' }

    # Constructors

    BuildLog() {
        throw "Usage: [BuildLog]::new( <program as [Exec\SevenZip]> )"
    }

    BuildLog ( [SevenZip] $program ) {
        if( $program -eq $null ) {
            throw "Usage: [BuildLog]::new( <program as [Exec\SevenZip]> )"
        }
        $this.m_pSevenZip = $program
    }

    # Class methods

    [String] ToString() {
        return "[SevenZip] Configuration`n" + `
        "`tProgram: $( [string]$this.m_pSevenZip )"
    }

    [BuildLog] setArchive( [string] $archive ) {
    <#
    .SYNOPSIS
        Set the archive file name and path.
        Raises an error if the path is not valid.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [BuildLog]$instance.setArchive( <archive file as [string]> )
    #>
        $this.m_pSevenZip.setArchive( $archive )
        return $this
    }

    [BuildLog] setOutputDir( [string] $outputdir ) {
    <#
    .SYNOPSIS
        Specifies a destination directory where files are to be extracted.
        Raises an error if the path is not valid.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [BuildLog]$instance.setOutputDir( <output dir as [string]> )
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
        [BuildLog]$instance.extract()
    #>
        # Initialize
        [bool] $bReturn = $false
        $this.error.code = 0
        $this.error.message = ''

        # Check parameters
        if( $this.m_pSevenZip -eq $null ) {
            throw '[BuildLog]::extract(). The program is not set.'
        }

        # Extract
        $bReturn = $this.m_pSevenZip.extract( $withfullpaths, $file, $recurse )
        $this.error.code = $this.m_pSevenZip.getExitCode()

        # Write log
#        if( $this.m_pAdapter.m_bSaveOutput ){
#            Add-Content -Path "$([string]$this.m_pContigLog)" -Value "$([string]$this.m_pAdapter.getOutput())"
#        }

        return $bReturn
    }

}
