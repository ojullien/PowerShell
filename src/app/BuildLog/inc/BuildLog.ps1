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

    [bool] concatFile( [string] $sSource, [string] $sDestination ) {
    <#
    .SYNOPSIS
        Combine source and destination file. Creates the destination file if does not exist.
        Returns false if the source file is missing and true otherwise.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [BuildLog]$instance.concatFile()
    .PARAMETER sSource
        The source file path as string.
    .PARAMETER sDestination
        The destination file path as string.
    #>
        # Check parameters
        if( [string]::IsNullOrWhiteSpace( $sSource ) -or [string]::IsNullOrWhiteSpace( $sDestination ) ) {
            throw 'Usage: [BuildLog]$instance.concatFile( <source file path as [string]>, <destination file path as [string]> )'
        }

        # Initialize
        [bool] $bReturn = $false

        if( Test-Path -LiteralPath $sSource -PathType Leaf ) {
            # Source file exists.

            if( -not $(Test-Path -LiteralPath $sDestination -PathType Leaf) ) {
                # Destination file does not exist. Create it.
                new-item -Force -ItemType File -Path $sDestination | Out-Null
            }

            # Concate
            Get-Content -Force -LiteralPath $sSource | Add-Content -Force -LiteralPath $sDestination | Out-Null
            $bReturn = $true
        }

        return $bReturn
    }

    [bool] concatFiles( [string] $sSource, [string] $sDestination, [int] $iYear, [int] $iMonth ) {
    <#
    .SYNOPSIS
        Combine source and year log file.
        Combine source and month log file.
        Creates the destination file if does not exist.
        Returns false if the source file is missing and true otherwise.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [BuildLog]$instance.concatFiles()
    .PARAMETER source
        The source file path as string.
    .PARAMETER destination
        The destination file path as string.
    .PARAMETER iYear
        The year part of the date as integer.
    .PARAMETER iMonth
        The month part of the date as integer.
    #>
        # Check parameters
        if( [string]::IsNullOrWhiteSpace( $sSource ) -or [string]::IsNullOrWhiteSpace( $sDestination ) `
        -or ( $iYear -eq $null ) -or ( $iMonth -eq $null ) -or ( $iMonth -gt 12 ) -or ( $iMonth -lt 1 ) ) {
            throw 'Usage: [BuildLog]$instance.concatFiles( <source file path as [string]>, <destination file path as [string]>, <year as [int]>, <month as [int]> )'
        }

        # Initialize
        [bool] $bReturn = $false
        [string] $sFile = ""

        # Concat to year log.
        $sFile = "{0}\{1}.log" -f $sDestination, $iYear.ToString()
        if( $this.concatFile( $sSource, $sFile ) ) {
            # Concat month log
            $sFile = "{0}\{1}{2}.log" -f $sDestination, $iYear.ToString(), $iMonth.ToString("0#")
            $bReturn = $this.concatFile( $sSource, $sFile )
        }

        return $bReturn
    }

    [bool] concatLogFiles( [string] $source ) {





        <# Initialize
        [bool] $bReturn = $true
        $this.error.code = 0
        $this.error.message = ''

        # Check parameters
        if( [string]::IsNullOrWhiteSpace( $source )-or [string]::IsNullOrWhiteSpace( $destination ) ) {
            throw 'Usage: [BuildLog]$instance.concatLogFiles( <source path as [string]>, <destination path as [string]> )'
        }
        $sInputFile = "{0}\{1}\var\log\apache2\{2}\access.log" -f $this.m_sInputDir, $sDayLogFolder, $sDomain
        $sOutputPath = "{0}\{1}" -f $this.m_sOutputDir, $sDomain
        $sLogYear = "{0}\{1}.log" -f $sPath, $iYear.ToString()
        $sLogMonth = "{0}\{1}{2}.log" -f $sPath, $iYear.ToString(), $iMonth.ToString("0#")
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
        #>
        return $true
    }

    [bool] buildLogs( [string[]] $collection ) {

        # Initialize
        [bool] $bReturn = $true
        [int] $iYear = $iMonth = $iDay = 0
        #[string] $sAccessLog = ""
        $this.error.code = 0
        $this.error.message = ''

        foreach( $item in $collection ) {

            # Get the date from the name of the folder
            $iYear = [int] $item.Substring(4,4)
            $iMonth = [int] $item.Substring(8,2)
            $iDay = [int] $item.Substring(10,2)
            # Because the log file is saved at 6 AM:
            # the log of the first day of a month contains the data of the last day of the previous month
            if( $iDay -eq 1 ) {
               [datetime] $date =  ( Get-Date -Year $iYear -Month $iMonth -Day $iDay ).adddays(-1)
               $iYear = [int] $date.year
               $iMonth = [int] $date.month
               $iDay = [int] $date.day
            }
            #$sAccessLog = "{0}\{1}\var\log\apache2\{2}\access.log" -f $this.m_sInputDir, $item
        }

        return $bReturn

    }
}
