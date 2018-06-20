<#PSScriptInfo

.VERSION 1.3.0

.GUID e5f0d849-0002-4c6a-b731-2b6bc8364595

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys,app\LogBuilder

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180620
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Build-Log App class

#>

class LogBuilder {

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

    LogBuilder() {
        throw "Usage: [LogBuilder]::new( <writer as WriterInterface> )"
    }

    LogBuilder ( [WriterInterface] $writer ) {
        if( $writer -eq $null ) {
            throw "Usage: [LogBuilder]::new( <writer as WriterInterface> )"
        }
        $this.m_pWriter = $writer
    }

    # Class methods

    [String] ToString() {
        return "[LogBuilder] Configuration`n" + `
        "`tDomains: $( [string] $( $this.m_aDomainsCollection -join ', ' ) )"
        "`tInput: $( $this.m_sInputDir )"
        "`tOutput: $( $this.m_sOutputDir )"
    }

    [LogBuilder] setDomains( [string[]] $collection ) {
        if( $collection.Count -eq 0 ) {
            throw 'Usage: [LogBuilder]$instance.setDomains( <collection of domain names as [string[]]> )'
        }
        $this.m_aDomainsCollection = $collection
        return $this
    }

    [LogBuilder] setInputDir( [string] $inputDir ) {
        if( [string]::IsNullOrWhiteSpace( $inputDir ) ) {
            throw 'Usage: [LogBuilder]$instance.setInputDir( <input directory as [string]> )'
        }
        $this.m_sInputDir = $inputDir
        return $this
    }

    [LogBuilder] setOutputDir( [string] $outputDir ) {
        if( [string]::IsNullOrWhiteSpace( $outputDir )  ) {
            throw 'Usage: [LogBuilder]$instance.setOutputDir( <output directory as [string]> )'
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
        [LogBuilder]$instance.concatFile()
    .PARAMETER sSource
        The source file path as string.
    .PARAMETER sDestination
        The destination file path as string.
    #>
        # Check parameters
        if( [string]::IsNullOrWhiteSpace( $sSource ) -or [string]::IsNullOrWhiteSpace( $sDestination ) ) {
            throw 'Usage: [LogBuilder]$instance.concatFile( <source file path as [string]>, <destination file path as [string]> )'
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
        [LogBuilder]$instance.concatFiles()
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
            throw 'Usage: [LogBuilder]$instance.concatFiles( <source file path as [string]>, <destination file path as [string]>, <year as [int]>, <month as [int]> )'
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

    [bool] build( [string[]] $collection ) {
    <#
    .SYNOPSIS
        Combine all access.log for by year, month and domain. Creates the destination file if does not exist.
        Assume the access.log file is in $this.m_sInputDir/<log-YYYYMMDD_0625>/var/log/apache2/<domain>/access.log
        Returns false if the source file is missing and true otherwise.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [LogBuilder]$instance.build()
    .PARAMETER collection
        A collection of folder name (from $this.m_sInputDir) like 'log-20170803_0625'
    #>
        # Initialize
        [bool] $bReturn = $false
        [int] $iYear = $iMonth = $iDay = 0
        [string] $sAccessLog = $sDestination = ""
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
            # Concat for each domain
            foreach( $sDomain in $this.m_aDomainsCollection ) {
                # Build source and destination path
                $sAccessLog = "{0}\{1}\var\log\apache2\{2}\access.log" -f $this.m_sInputDir, $item, $sDomain
                $sDestination = "{0}\{1}" -f $this.m_sOutputDir, $sDomain
                # Concat
                if( !$this.concatFiles( $sAccessLog, $sDestination, $iYear, $iMonth ) ){
                    $this.error.code = 1
                    $this.error.message = "Year: $iYear, Month: $iMonth, Day:$iDay, Domain: $sDomain is missing"
                    $this.m_pWriter.error( $this.error.message )
                }
            }
        }

        if( $this.error.code -eq 0 ) { $bReturn = $true }
        return $bReturn
    }
}
