<#PSScriptInfo

.VERSION 1.2.0

.GUID f2d20462-0001-421e-864b-42cddfa2b4e3

.AUTHOR Olivier Jullien

.COMPANYNAME

.COPYRIGHT MIT License

.TAGS

.LICENSEURI https://github.com/ojullien/powershell/blob/master/LICENSE

.PROJECTURI https://github.com/ojullien/PowerShell

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS src\sys\inc\Exec\Adapter\CallOperator.ps1

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Date: 20180518
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 Exec\Adapter\CallOperator tests

#>

# -----------------------------------------------------------------------------
# Load Exec file
# -----------------------------------------------------------------------------

. ("$m_DIR_SYS\inc\Exec\Adapter\CallOperator.ps1")

# -----------------------------------------------------------------------------
# Load data test
# -----------------------------------------------------------------------------

. ("$m_DIR_TEST_SYS\inc\Exec\Adapter\data.ps1")

# ------------------------------------------------------------------------------
# Test
# ------------------------------------------------------------------------------

foreach( $item in $aTestDataCollection ) {

    $pWriterDecorated.separateLine()
    $pWriterDecorated.notice( "Testing: '$( $item.theInput.theProgram )' $( $item.theInput.theArgs -join ' ' )" )

    try {
        [Path] $pPath = [path]::new( $item.theInput.theProgram )
        [Program] $pProgram = [Program]::new().setProgramPath( $pPath ).setArgument( $item.theInput.theArgs )
        [CallOperator] $pProcess = [CallOperator]::new()
        $null = $pProcess.setProgram( $pProgram )
    } catch {
        $pWriterDecorated.exception( "Exception raised when creating Filter\Path, Exec\Program or Exec\CallOperator:  $_" )
        Exit
    }

    if( $bequiet.IsPresent ) {
        $null = $pProcess.noOutput()
    } else {
        $null = $pProcess.saveOutput()
    }

    try {
        [int] $iExitCode = $pProcess.run()
    } catch {
        $pWriterDecorated.exception( "run() raised an exception:  $_" )
        Continue
    }

    [string] $sBuffer = "`tExitCode: $iExitCode => $( $item.theExpected.theExitCode )"
    if( $iExitCode -eq $item.theExpected.theExitCode ) {
        $pWriterDecorated.success( $sBuffer )
    } else {
        $pWriterDecorated.error( $sBuffer )
    }

    $pWriterDecorated.notice( $pProcess.getOutput() )

    $pProcess = $null
    $pProgram = $null
    $pPath = $null

}
