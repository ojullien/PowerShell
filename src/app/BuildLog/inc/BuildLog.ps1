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
    [WriterInterface] $m_pWriter

    [ValidateCount(2,2)]
    [hashtable] $error = @{ code = 0; message = '' }

    [ValidateNotNull()]
    hidden [string[]] $m_aDomainsCollection

    [ValidateNotNullOrEmpty()]
    hidden [string] $m_sInputDir

    [ValidateNotNullOrEmpty()]
    hidden [string] $m_sOutputDir

    # Constructors

    BuildLog() {
        throw "Usage: [BuildLog]::new( <writer as WriterInterface> )"
    }

    BuildLog ( [WriterInterface] $writer ) {
        if( $writer -eq $null ) {
            throw "Usage: [BuildLog]::new( <writer as WriterInterface> )"
        }
        $this.m_pWriter = $writer
    }

    # Class methods

    [String] ToString() {
        return "[BuildLog] Configuration`n" + `
        "`tDomains: $( $this.m_aDomainsCollection.ToString() )"
        "`tInput: $( $this.m_sInputDir )"
        "`tOutput: $( $this.m_sOutputDir )"
    }

    [BuildLog] setDomains( [string[]] $collection ) {
        if( $collection.Count -eq 0 ) {
            throw 'Usage: [BuildLog]$instance.setDomains( <collection of domain names as [string[]]> )'
        }
        $this.m_aDomainsCollection = $collection
        return $this
    }

    [BuildLog] setInputDir( [string] $inputDir ) {
        if( [string]::IsNullOrWhiteSpace( $inputDir ) ) {
            throw 'Usage: [BuildLog]$instance.setInputDir( <input directory as [string]> )'
        }
        $this.m_sInputDir = $inputDir
        return $this
    }

    [BuildLog] setOutputDir( [string] $outputDir ) {
        if( [string]::IsNullOrWhiteSpace( $outputDir )  ) {
            throw 'Usage: [BuildLog]$instance.setOutputDir( <output directory as [string]> )'
        }
        $this.m_sOutputDir = $outputDir
        return $this
    }

    [bool] createEmptyLogFiles( [int] $iYear, [int] $iMonth ) {
    <#
    .SYNOPSIS
        Creates year and month files for each domains.
        Returns true if the command succeeded and false otherwise.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [BuildLog]$instance.createEmptyLogFiles()
    .PARAMETER iYear
        The year part of the date as integer.
    .PARAMETER iMonth
        The month part of the date as integer.
    #>
        # Initialize
        [bool] $bReturn = $true
        $this.error.code = 0
        $this.error.message = ''

        # Check parameters
        if( ($iYear -eq $null) -or ($iMonth -eq $null) -or ($iMonth -lt 1) -or ($iMonth -gt 12) ) {
            throw 'Usage: [BuildLog]$instance.createLogFiles( <year as [integer]>, <month as [integer]> )'
        }

        # Create
        [string] $sPath = ''
        [string] $sLogYear = ''
        [string] $sLogMonth = ''
        foreach( $sDomain in $this.m_aDomainsCollection ) {
            $sPath = "{0}\{1}" -f $this.m_sOutputDir, $sDomain
            $sLogYear = "{0}\{1}.log" -f $sPath, $iYear.ToString()
            $sLogMonth = "{0}\{1}{2}.log" -f $sPath, $iYear.ToString(), $iMonth.ToString("0#")
            foreach( $sFile in @( $sLogYear, $sLogMonth ) ) {
                if( -not $(Test-Path -LiteralPath $sFile -PathType Leaf) ) {
                    new-item -Force -ItemType File -Path $sFile -Force | Out-Null
                }
            }
        }

        return $bReturn
    }

    [bool] concatLogFiles( [string] $source, [string] $destination ) {
    <#
    .SYNOPSIS
        Combine source and destination files.
        Returns true if the command succeeded and false otherwise.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [BuildLog]$instance.concatLogFiles()
    .PARAMETER source
        The source file path as string.
    .PARAMETER destination
        The destination file path as string.
    #>
        # Initialize
        [bool] $bReturn = $true
        $this.error.code = 0
        $this.error.message = ''

        # Check parameters
        if( [string]::IsNullOrWhiteSpace( $source )-or [string]::IsNullOrWhiteSpace( $destination ) ) {
            throw 'Usage: [BuildLog]$instance.concatLogFiles( <source path as [string]>, <destination path as [string]> )'
        }

        # Create
        [string] $sPath = ''
        [string] $sLogYear = ''
        [string] $sLogMonth = ''
        foreach( $sDomain in $this.m_aDomainsCollection ) {
            $sPath = "{0}\{1}" -f $this.m_sOutputDir, $sDomain
            $sLogYear = "{0}\{1}.log" -f $sPath, $iYear.ToString()
            $sLogMonth = "{0}\{1}{2}.log" -f $sPath, $iYear.ToString(), $iMonth.ToString("0#")
            foreach( $sFile in @( $sLogYear, $sLogMonth ) ) {
                if( -not $(Test-Path -LiteralPath $sFile -PathType Leaf) ) {
                    new-item -Force -ItemType File -Path $sFile -Force | Out-Null
                }
            }
        }

        return $bReturn
    }

    [bool] buildLogs( [string[]] $collection ) {
    <#
    .SYNOPSIS
        Returns true if the command succeeded and false otherwise.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [BuildLog]$instance.buildLogs()
    .PARAMETER collection
        A collection of folder names as array of string.
    #>
        # Initialize
        [bool] $bReturn = $true
        [int] $iYear = 0
        [int] $iMonth = 0
        [int] $iDay = 0
        $this.error.code = 0
        $this.error.message = ''

        foreach( $sDir in $collection ) {
            #
            $iYear = [int] $sDir.Substring(4,4)
            $iMonth = [int] $sDir.Substring(8,2)
            $iDay = [int] $sDir.Substring(10,2)
            #
            foreach( $sDomain in $this.m_aDomainsCollection ) {
            }
        }

        return $bReturn
    }
}
