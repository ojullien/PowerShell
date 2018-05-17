<#PSScriptInfo

.VERSION 1.2.0

.GUID 5a516eab-0002-4f39-82f9-f12d189bf98d

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys,app\saveto

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 save-to App class

#>

class SaveTo {

    # Properties

    [ValidateNotNull()]
    hidden [ExecAdapterInterface] $m_pAdapter

    [ValidateNotNull()]
    hidden [Drive] $m_pSource

    [ValidateNotNull()]
    hidden [Drive] $m_pDestination

    [ValidateNotNull()]
    hidden [Path] $m_pDefaultLogDir

    hidden [Path] $m_pRobocopyLog
    hidden [Path] $m_pContigLog

    [ValidateCount(2,2)]
    [hashtable] $error = @{ code = 0; message = '' }

    # Constructors

    SaveTo() {
        throw "Usage: [SaveTo]::new( <adapter as [Exec\Adapter\ExecAdapterInterface]>, <log directory as [Filter\Path]> )"
    }

    SaveTo ( [ExecAdapterInterface] $adapter, [Path] $logdir ) {
        if( ($adapter -eq $null) -or ($logdir -eq $null) -or (![Dir]::new().exists( $logdir )) ) {
            throw "Usage: [SaveTo]::new( <adapter as [Exec\Adapter\ExecAdapterInterface]>, <log directory as [Filter\Path]> )"
        }
        $this.m_pAdapter = $adapter
        $this.m_pDefaultLogDir = $logdir
        $this.m_pRobocopyLog = $null
        $this.m_pContigLog = $null
    }

    # Class methods

    [String] ToString() {
        return "[SaveTo] Configuration`n" + `
        "`tSource: $([string]$this.m_pSource.getTrace())`n" + `
        "`tDestination: $([string]$this.m_pDestination.getTrace())`n" + `
        "`tRobocopy log: $([string]$this.m_pRobocopyLog)`n" + `
        "`tContig log: $([string]$this.m_pContigLog)`n" + `
        "`tAdapter: $( [string]$this.m_pAdapter.GetType() )"
    }

    [SaveTo] setRobocopyLog( [string] $basename ) {
    <#
    .SYNOPSIS
        Set the robocopy log path.
        Throw an error if the path is not valid.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [SaveTo]$instance.setRobocopyLog( <file basename as string> )
    .PARAMETER basename
        File basename as string
    #>
        # Initialize
        $this.m_pRobocopyLog = $null

        # Check parameter
        if( [string]::IsNullOrWhiteSpace( $basename ) ) {
            throw 'Usage: [SaveTo]$instance.setRobocopyLog( <file basename as string> )'
        }

        # Build robocopy log path
        $this.m_pRobocopyLog = [Path]::new( [string]$this.m_pDefaultLogDir + [System.IO.Path]::DirectorySeparatorChar + 'robocopy-' + $basename + ".log"  )
        if( !$this.m_pRobocopyLog.isValid() ){
            throw 'SaveTo: The robocopy log path is not valid.'
        }

        # Delete old log file
        if( [File]::new().exists( $this.m_pRobocopyLog ) ){
            Remove-Item "$([string]$this.m_pRobocopyLog)" | Out-Null
        }

        return $this
    }

    [SaveTo] setContigLog( [string] $basename ) {
    <#
    .SYNOPSIS
        Set the contig log path.
        Throw an error if the path is not valid.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [SaveTo]$instance.setContigLog( <file basename as string> )
    .PARAMETER basename
        File basename as string
    #>
        # Initialize
        $this.m_pContigLog = $null

        # Check parameter
        if( [string]::IsNullOrWhiteSpace( $basename ) ) {
            throw 'Usage: [SaveTo]$instance.setContigLog( <file basename as string> )'
        }

        # Build robocopy log path
        $this.m_pContigLog = [Path]::new( [string]$this.m_pDefaultLogDir + [System.IO.Path]::DirectorySeparatorChar + 'contig-' + $basename + ".log"  )
        if( !$this.m_pContigLog.isValid() ){
            throw 'SaveTo: The contig log path is not valid.'
        }

        # Delete old log file
        if( [File]::new().exists( $this.m_pContigLog ) ){
            Remove-Item "$([string]$this.m_pContigLog)"  | Out-Null
        }

        return $this
    }

    [SaveTo] setSource( [Path] $path, [string]$label ) {
    <#
    .SYNOPSIS
        Set the source path. Throw an error if the path is not valid or the drive is not ready.
        Create default log files.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [SaveTo]$instance.setSource( <source as [Filter\Path]> )
    .PARAMETER path
        An instance of Filter\Path.
    .PARAMETER label
        Drive label as string
    #>
        # Initialize
        $this.m_pContigLog = $null
        $this.m_pRobocopyLog = $null

        # Check parameters
        if( ($path -eq $null) -or [string]::IsNullOrWhiteSpace( $label ) ) {
            throw 'Usage: [SaveTo]$instance.setSource( <source as [Filter\Path]>; <drive label as string> )'
        }

        # Build source
        $this.m_pSource = [Drive]::new( $path, $label )
        if( !$this.m_pSource.isReady() -or !$this.m_pSource.testPath() ){
            throw 'SaveTo: Source is not valid or the drive is not ready.'
        }

        # Build log paths
        $null = $this.setRobocopyLog( $path.getFilename() )
        $null = $this.setContigLog( $path.getFilename() )

        return $this
    }

    [SaveTo] setDestination( [Path] $path, [string]$label ) {
    <#
    .SYNOPSIS
        Set the destination path. Throw an error if the path is not valid or the drive is not ready.
        Creates the destination folder if it does not exist.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [SaveTo]$instance.setDestination( <destination as [Filter\Path]> )
    .PARAMETER path
        An instance of Filter\Path.
    .PARAMETER label
        Drive label as string
    #>
        # Check parameters
        if( ($path -eq $null) -or [string]::IsNullOrWhiteSpace( $label ) ) {
            throw 'Usage: [SaveTo]$instance.setDestination( <destination as [Filter\Path]>; <drive label as string> )'
        }

        # Build destination
        $this.m_pDestination = [Drive]::new( $path, $label )
        if( !$this.m_pDestination.isReady() ){
            throw 'SaveTo: Destination drive is not ready.'
        }

        # Create destination
        if( ![Dir]::new().exists( $path ) ){
            New-Item -ItemType "directory" -Force -Path "$([string]$path)" | Out-Null
        }

        return $this
    }

    [bool] robocopy() {
    <#
    .SYNOPSIS
        Robust file/directory copy. The source and the destination must be set.
        Returns true if the command succeeded and false otherwise.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [SaveTo]$instance.robocopy()
    #>
        # Initialize
        [bool] $bReturn = $false
        $this.error.code = 0
        $this.error.message = ''

        # Check parameters
        if( $this.m_pAdapter -eq $null ) {
            throw '[SaveTo]::robocopy(). The adapter is not set.'
        }

        if( ($this.m_pSource -eq $null) -or ($this.m_pDestination -eq $null) ) {
            throw '[SaveTo]::robocopy(). The drives are not set or are not valid.'
        }

        if( $this.m_pRobocopyLog -eq $null ) {
            throw '[SaveTo]::robocopy(). The robocopy log path is not set or is not valid.'
        }

        # Robocopy
        [Robocopy] $pProcess = [Robocopy]::new( $this.m_pSource, $this.m_pDestination, $this.m_pRobocopyLog, $this.m_pAdapter )
        $bReturn = $pProcess.run()
        $this.error.code = $pProcess.getExitCode()
        $pProcess = $null

        return $bReturn
    }

    [bool] contig() {
    <#
    .SYNOPSIS
        Defragments a specified files in folder. The destination must be set.
        Returns true if the command succeeded and false otherwise..
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [SaveTo]$instance.contig()
    #>
        # Initialize
        [bool] $bReturn = $false
        $this.error.code = 0
        $this.error.message = ''

        # Check parameters
        if( $this.m_pAdapter -eq $null ) {
            throw '[SaveTo]::contig(). The adapter is not set.'
        }

        if( $this.m_pDestination -eq $null ) {
            throw '[SaveTo]::contig(). The drive is not set or is not valid.'
        }

        if( $this.m_pContigLog -eq $null ) {
            throw '[SaveTo]::contig(). The contig log path is not set or is not valid.'
        }

        # Contig
        [Contig] $pProcess = [Contig]::new( [Path]::new( [string]$this.m_pDestination ), $this.m_pAdapter )
        $bReturn = $pProcess.run()
        $this.error.code = $pProcess.getExitCode()
        $pProcess = $null

        # Write log
        if( $this.m_pAdapter.m_bSaveOutput ){
            Add-Content -Path "$([string]$this.m_pContigLog)" -Value "$([string]$this.m_pAdapter.getOutput())"
        }

        return $bReturn
    }

}
