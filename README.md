# PowerShell

Personal PowerShell scripting projects.

## Setup & usage

Require Powershell version: 5.1

### saveto.ps1

Is a command-line directory replication command.
Require robocopy.exe and contig.exe from sysinternals suite.
Find and rename PowerShell/app/saveto/cfg/default.cfg.ps1 to PowerShell/app/saveto/cfg/myconfig.cfg.ps1, then edit the file and add source and destination information.

```
PS C:\PowerShell> .\saveto.ps1 -cfg myconfig
```

## Contributing

Thanks you for taking the time to contribute.
As this project is a personal project, I do not have time to develop new submitted features or feature requests.
But if you encounter any **bugs**, please open an [issue](https://github.com/ojullien/powershell/issues/new). Be sure to include a title and clear description,as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## License

This project is open-source and is licensed under the [MIT License](https://github.com/ojullien/powershell/blob/master/LICENSE).