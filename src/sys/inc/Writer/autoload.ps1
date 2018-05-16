<#PSScriptInfo

.VERSION 1.2.0

.GUID 73c97ada-0008-4f07-b18f-e1a38ac3a132

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Writer\Output\*.ps1, src\sys\inc\Writer\*.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Writer autoloader. Loads files containing Writer classes according to options.
 The "verbose" switch is only (and must be) used on test.

#>

# Load Output interface and abstract classes files
. ("$m_DIR_SYS\inc\Writer\Output\Interface.ps1")
. ("$m_DIR_SYS\inc\Writer\Output\Abstract.ps1")

# Load Writer interface and concrete classes files
. ("$m_DIR_SYS\inc\Writer\Interface.ps1")
. ("$m_DIR_SYS\inc\Writer\Writer.ps1")

# Instantiate Writer class
try {
    [Writer] $pWriter = [Writer]::new()
} catch {
    Write-Host( "ERROR: Cannot instantiate Writer\Writer class: $_" )
    Exit
}

# Instantiate output classes according to options
try {
    if( -Not $bequiet.IsPresent ) {
        . ("$m_DIR_SYS\inc\Writer\Output\Host.ps1")
        $pWriter.addOutput( [OutputHost]::new() )
    }
    if( $logtofile.IsPresent ) {
        . ("$m_DIR_SYS\inc\Writer\Output\Log.ps1")
        $pWriter.addOutput( [OutputLog]::new( $m_DIR_LOG_PATH ) )
    }
}
catch {
    Write-Host( "ERROR: Cannot instantiate Writer\Output classes: $_" )
    Exit
}

# Instantiate Writer decorator class for test mode
if( $( Test-Path variable:global:$m_MODE_TEST ) ){
    try {
        . ("$m_DIR_SYS\inc\Writer\Verbose.ps1")
        [VerboseDecorator] $pWriterDecorated = [VerboseDecorator]::new( $pWriter, $verbose.IsPresent, 80 )
    } catch {
        Write-Host( "ERROR: Cannot instantiate Writer\VerboseDecorator class: $_" )
        Exit
    }
}
