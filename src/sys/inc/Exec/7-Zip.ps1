<#PSScriptInfo

.VERSION 1.2.0

.GUID eb202f80-0010-47c2-9196-01370ebd498f

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\Exec\Adapter\Interface.ps1, sys\inc\Exec\Program.ps1, sys\inc\Filter\Path.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 This class is a 7-Zip interface.

#>

class SevenZip {

    # Properties

    [ValidateNotNull()]
    [int] $m_iExitCode

    [ValidateNotNull()]
    [Path] $m_pArchive

    # This is the destination directory path. It's not required to end with a backslash.
    # If you specify *, 7-Zip substitutes that * character to archive name.
    [ValidateNotNullOrEmpty()]
    [string] $m_sOutputDir

    [ValidateNotNull()]
    [ExecAdapterInterface] $m_pAdapter

    [ValidateNotNullOrEmpty()]
    hidden [string] $m_ExePath = 'D:\Program Files\7-Zip\7z.exe'

    # Constructors

    SevenZip() {
        throw "Usage: [SevenZip]::new( adapter as [Exec\Adapter\ExecAdapterInterface] )"
    }

    SevenZip ( [ExecAdapterInterface] $adapter ) {

        if( $adapter -eq $null  ) {
            throw "Usage: [SevenZip]::new( adapter as [Exec\Adapter\ExecAdapterInterface] )"
        }
        $this.m_pAdapter = $adapter
        $this.m_iExitCode = 0
    }

    # Class methods

    [SevenZip]setOutputDir( [string] $outputdir ) {
        if( [string]::IsNullOrWhiteSpace( $outputdir ) ) {
            throw 'Usage: [SevenZip]$instance.setOutputDir( <output directory as [string] )'
        }
        $this.m_sOutputDir = $outputdir
        return $this
    }

    [SevenZip]setArchive( [Path] $archive ) {
        if( $archive -eq $null ) {
            throw 'Usage: [SevenZip]$instance.setArchive( <archive as [Filter\Path] )'
        }
        $this.m_pArchive = $archive
        return $this
    }

    [string] ToString() {
        return "[SevenZip] Configuration`n" `
            + "`tArchive: $([string]$this.m_pArchive)`n" `
            + "`tOutput Directory: $([string]$this.m_sOutputDir)`n" `
            + "`tAdapter: $($this.m_pAdapter.GetType())"
    }

    [int] getExitCode() {
        return $this.m_iExitCode
    }

    [bool] extract( [bool]$withfullpaths=$false, [string]$file='', [bool]$recurse=$false ) {
    <#
    .SYNOPSIS
        Extracts files from the archive to the output directory.
        Files on disk with same filenames as in archive will be overwritten.
        $withfullpaths specifies the command extracts files from the archive with their full paths.
        $file specifies the specific file to extract
        $recurse specifies the method of treating wildcards and filenames on the command line.
        Returns true if the command succeeded.
    .DESCRIPTION
        See synopsis.
    .PARAMETER withfullpaths
        If true: extracts files from an archive with their full paths.
    .PARAMETER file
        Specifies the files to extract like *.doc
    .PARAMETER recurse
        Specifies the method of treating wildcards and filenames on the command line.
        if $true: Enable recurse subdirectories.
    .EXAMPLE
        [SevenZip]$instance.extract($false,'*.doc',$true)
    #>
        # Initialize
        [bool] $bReturn = $false
        $this.m_iExitCode = 0

        # Adapter test
        if( $this.m_pAdapter -eq $null ) {
            throw "Usage: [SevenZip]::new( adapter as [Exec\Adapter\ExecAdapterInterface] )"
        }

        # Output directory should exist
        if( [string]::IsNullOrWhiteSpace( $this.m_sOutputDir ) ) {
            throw 'Usage: [SevenZip]$instance.setOutputDir( <output directory as [string] )'
        }

        # Archive should exist
        if( $this.m_pArchive -eq $null ) {
            throw 'Usage: [SevenZip]$instance.setArchive( <archive as [Filter\Path] )'
        }
        if( ![File]::new().exists( $this.m_pArchive )){
            throw 'SevenZip: The archive does not exist'
        }

        # Build the arguments
        [string[]] $aArgumentList = @()
        if( $withfullpaths ) {
            # Extracts files from an archive with their full paths
            $aArgumentList += @( "x" )
        } else {
            # Extracts files from an archive
            $aArgumentList += @( "e" )
        }
        # Archive, output directory
        $aArgumentList += @( "`"$([string]$this.m_pArchive)`"", "-o`"$([string]$this.m_sOutputDir)`"" )
        # Files to extract if specified.
        if( ![string]::IsNullOrWhiteSpace( $file ) ){
            $aArgumentList += @( "$file" )
        }
        # Recurse option if specified.
        if( $recurse ){
            $aArgumentList += @( "-r" )
        }
        # Assume yes
        $aArgumentList += @( "-y" )

        # Set the program, the options and run execute the command
        $this.m_iExitCode = $this.m_pAdapter.setProgram( [Program]::new().setProgramPath( [Path]::new( $this.m_ExePath ) ).setArgument( $aArgumentList ) ).run()

        if( $this.m_iExitCode -gt 0 ) {
            $bReturn = $false
        } else {
            $bReturn = $true
        }

        return $bReturn
    }

}
