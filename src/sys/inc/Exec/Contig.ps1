<#PSScriptInfo

.VERSION 1.2.0

.GUID eb202f80-0008-47c2-9196-01370ebd498f

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\Exec\Adapter\Abstract.ps1, sys\inc\Exec\Program.ps1, sys\inc\Filter\Path.ps1, sys\inc\Filter\Dir.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Defragments a specified file or files.

#>

class Contig {

    # Properties

    [ValidateNotNull()]
    [int] $m_iExitCode

    [ValidateNotNull()]
    [Path] $m_pSource

    [ValidateNotNull()]
    [ExecAdapterAbstract] $m_pAdapter

    [ValidateNotNullOrEmpty()]
    hidden [string] $m_ExePath = 'C:\Program Files\SysinternalsSuite\Contig.exe'

    [ValidateNotNullOrEmpty()]
    [string[]] $m_aDefaultArgumentList = @( "-s", "-q", "-nobanner" )

    # Constructors

    Contig() {
        throw "Usage: [Contig]::new( <source as [Filter\Path], adapter as [Exec\Adapter\ExecAdapterAbstract]>"
    }

    Contig ( [Path] $source, [ExecAdapterAbstract] $adapter ) {

        if( ( $source -eq $null ) -or ( $adapter -eq $null )  ) {
            throw "Usage: [Contig]::new( <source as [Filter\Path], adapter as [Exec\Adapter\ExecAdapterAbstract]>"
        }

        $this.m_pSource = $source
        $this.m_pAdapter = $adapter
        $this.m_iExitCode = 0

    }

    # Class methods

    [string] ToString() {
        return "[Contig] Configuration`n" `
            + "`tSource: $([string]$this.m_pSource)`n" `
            + "`tAdapter: $($this.m_pAdapter.GetType())`n" `
            + "`tOptions: $($this.m_aDefaultArgumentList)"
    }

    [int] getExitCode() {
        return $this.m_iExitCode
    }

    [bool] isReadySource() {
    <#
    .SYNOPSIS
        Return true if the path exists.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [Contig]$instance.isReadySource()
    #>
        return [bool] $( ( $this.m_pSource -ne $null ) -and ( [Dir]::new().exists( $this.m_pSource )))
    }

    [bool] run() {
    <#
    .SYNOPSIS
        Contig is a utility that defragments a specified file or files. The source must be set.
        Returns true if the command succeeded.
        Return false if the drive is not ready or the command failed.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        [Contig]$instance.run()
    #>
        # Initialize
        [bool] $bReturn = $false
        $this.m_iExitCode = 0

        # Adapter test
        if( $this.m_pAdapter -eq $null ) {
            throw "Usage: [Contig]::new( <source as [Drive\Drive], adapter as [Exec\Adapter\ExecAdapterAbstract]>"
        }

        # Run
        if( $this.isReadySource() ) {

            # Build the arguments
            [string[]] $aArgumentList = $this.m_aDefaultArgumentList
            $aArgumentList += "`"$([string]$this.m_pSource)" + [System.IO.Path]::DirectorySeparatorChar + "*`""

            # Set the program, the options and run execute the command
            $this.m_iExitCode = $this.m_pAdapter.setProgram( [Program]::new().setProgramPath( [Path]::new( $this.m_ExePath ) ).setArgument( $aArgumentList ) ).run()

            if( $this.m_iExitCode -ne 0 ) {
                $bReturn = $false
            } else {
                $bReturn = $true
            }

        } else {
            throw "Contig: Drive is not ready."
        }

        return $bReturn
    }

}
