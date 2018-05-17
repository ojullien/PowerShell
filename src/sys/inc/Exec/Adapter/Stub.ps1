<#PSScriptInfo

.VERSION 1.2.0

.GUID eb202f80-0007-47c2-9196-01370ebd498f

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
Date: 20180501
Require Powershell Version: 6.0.2
Require .NET Framework 4.7
Require .NET Core

#>

<#

.DESCRIPTION
 This class is an adapter stub.

#>

class AdapterStub : ExecAdapterAbstract {

    # Properties
    [int] $exitcode = 0

     # Constructors

    AdapterStub() {
        $this.m_bSaveOutput = $false
        $this.m_sOutput = ''
    }

    # Class methods

    [int] run() {
        return $this.exitcode
    }

}
