<#PSScriptInfo

.VERSION 1.2.0

.GUID eb202f80-0004-47c2-9196-01370ebd498f

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS sys\inc\Exec\Adapter\Abstract.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 This class is an adapter to executes a program using Start-Process

#>

class StartProcess : ExecAdapterAbstract {

    # Properties

    # Constructors

    StartProcess() {
        $this.m_bSaveOutput = $false
        $this.m_sOutput = ''
    }

    # Class methods


    [int] run() {
    <#
    .SYNOPSIS
        Runs a program.
        Returns the program exit code.
    .DESCRIPTION
        See synopsis.
    .EXAMPLE
        $instance.run()
    #>
        # Initialize
		[string] $stdOutTempFile = "$env:TEMP\$((New-Guid).Guid)"
        [string] $stdErrTempFile = "$env:TEMP\$((New-Guid).Guid)"
        [int]$iReturn = -1000
        $this.m_sOutput = ''


        # Argument test
        if( $this.m_pProgram -eq $null ) {
            throw 'Program is not set.'
        }

<#
		[hashtable] $aStartProcessParams = @{
			FilePath               = $this.m_pProgram.getProgramPath()
			ArgumentList           = $this.m_pProgram.getArguments()
			RedirectStandardError  = $stdErrTempFile
			RedirectStandardOutput = $stdOutTempFile
			Wait                   = $true;
			PassThru               = $true;
			NoNewWindow            = $true;
        }
#>

        try {
            #$pProcess = Start-Process $aStartProcessParams
            $pProcess = Start-Process $this.m_pProgram.getProgramPath() -ArgumentList $this.m_pProgram.getArguments() -wait -NoNewWindow -PassThru -RedirectStandardOutput $stdErrTempFile -RedirectStandardError $stdOutTempFile
            $pProcess.HasExited
            $iReturn = $pProcess.ExitCode

            if( $this.m_bSaveOutput ) {
                [string] $sBufferOut = Get-Content -Path $stdOutTempFile -Raw
                if( $iReturn -ne 0 ){
                    [string] $sBufferErr = Get-Content -Path $stdErrTempFile -Raw
                    if( $sBufferErr ) {
                        $sBufferOut = $sBufferErr
                    }
                }
                if ([string]::IsNullOrEmpty( $sBufferOut ) -eq $false) {
                    $this.m_sOutput = $sBufferOut.Trim()
                }
            }

        } catch {
            # Bug Unable to load DLL 'api-ms-win-core-job-l2-1-0.dll'.
            # We read the output anyway
            #throw $_
            [string] $sBufferOut = Get-Content -Path $stdOutTempFile -Raw
            [string] $sBufferErr = Get-Content -Path $stdErrTempFile -Raw
            if( $sBufferErr ) {
                $sBufferOut = $sBufferErr
            }
            if ([string]::IsNullOrEmpty( $sBufferOut ) -eq $false) {
                $this.m_sOutput = $sBufferOut.Trim()
            }
        } finally {
            Remove-Item -Path $stdOutTempFile, $stdErrTempFile -Force -ErrorAction Ignore
        }

        return $iReturn
    }

}
