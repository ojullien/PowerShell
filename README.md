# PowerShell

Personal PowerShell scripting projects.

## Table of Contents

- [Setup](#setup) | [Features](#features) | [Test](#test) | [Contributing](#contributing) | [License](#license)

## Setup

Require Powershell version: 6.0.2, .NET Framework 4.7, .NET Core

## Features

### buildLog.ps1

This tool build a consistent yearly apache log file from monthly apache log files.
The tool is very specific to my projects.

Require [7zip](https://www.7-zip.org/)

Find and rename src/app/buildlog/cfg/default.cfg.ps1 to src/app/buildlog/cfg/myconfig.cfg.ps1, then edit the file and add source and destination information.

```powershell
PS C:\PowerShell\src> .\buildLog.ps1 -cfg myconfig [options]

other options

-bequiet    Quiet mode
-logtofile  Log to a file in the log dir
```

### saveto.ps1

Is a command-line directory replication command.

Require robocopy.exe and contig.exe from (sysinternals suite)[https://docs.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite]

Find and rename src/app/saveto/cfg/default.cfg.ps1 to src/app/saveto/cfg/myconfig.cfg.ps1, then edit the file and add source and destination information.

```powershell
PS C:\PowerShell\src> .\saveto.ps1 -cfg myconfig [options]

other options

-bequiet    Quiet mode
-logtofile  Log to a file in the log dir
```

## Test

I write few lines of 'unit test' code.

Each file contains code for one class. It display a dot for a successfull test, an 'X' for a failure and an 'E' when an unexpected exception is raised.
Use the -verbose option to display all the details of the tests.

```powershell
PS C:\PowerShell\test> .\filter.ps1 [options]

Options:

-verbose    Display the details of the tests, in a human readable format.
-bequiet    Quiet mode
-logtofile  Log to a file in the log dir
```

## Contributing

Thanks you for taking the time to contribute.

As this project is a personal project, I do not have time to develop new submitted features or feature requests.
But if you encounter any **bugs**, please open an [issue](https://github.com/ojullien/powershell/issues/new).

Be sure to include a title and clear description,as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## License

This project is open-source and is licensed under the [MIT License](https://github.com/ojullien/powershell/blob/master/LICENSE).
