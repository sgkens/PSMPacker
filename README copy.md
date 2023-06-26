[![pongologo](./BuildTVF-logo.svg)](https://gitlab.snowlab.tk/powershell/BuildTVF/-/blob/main/BuildTVF-logo.svg)
--
[![Maintainer](https://img.shields.io/badge/Maintainer-snoonx-blue??&stype=flat&logo=Personio&logoColor=blue)](https://gitlab.snowlab.tk/snoonx)
[![License](https://img.shields.io/gitlab/license/43?gitlab_url=https%3a%2f%2fgitlab.snowlab.tk&logo=unlicense)](https://gitlab.snowlab.tk/powershell/BuildTVF/-/blob/main/LICENSE)
[![Latest Release](https://gitlab.snowlab.tk/powershell/BuildTVF/-/badges/release.svg)](https://gitlab.snowlab.tk/powershell/BuildTVF/-/releases) 
[![Pipeline Status](https://gitlab.snowlab.tk/powershell/BuildTVF/badges/main/pipeline.svg)](https://gitlab.snowlab.tk/powershell/BuildTVF/-/commits/main) 
[![Coverage Report](https://gitlab.snowlab.tk/powershell/BuildTVF/badgesmain/coverage.svg)](https://gitlab.snowlab.tk/powershell/BuildTVF/-/commits/main)
[![Contributors](https://img.shields.io/gitlab/contributors/powershell/BuildTVF?gitlab_url=https%3a%2f%2fgitlab.snowlab.tk)](https://gitlab.snowlab.tk/powershell/BuildTVF/activity)

`PSMPacker` is a powershell utility module to assist with the creating and building of powershell modules, allows streamline generation of BoilderPlate Module Templates and to build module from a provided list of files and folders

## 🧩Features

- Build Powershell Module from a specified list of files and folders to a named `FolderName` or a versioned folder `FolderName_v{0}.{0}.{0}` based on Folder named version folders or `smver`
- Generate Module: `Manifiest` and `ScriptFIleInfo` Boilderplate
- Feature 3

## 🥽Installation

Instructions on how to install and use the project.
1. Open a PowerShell session.
2. Run the following command to register the repository:
```Powershell
Register-PSRepository -Name MyRepository -SourceLocation https://gallary.microsoft/MyRepository -InstallationPolicy Trusted
```
3. Run the following command to install the `PSMPacker` module:
```powershell
Install-Module -Name PSMPacker -Repository MyRepository 
```
4. Import Module
```powershell
Import-Module -Name PSMPacker
# or
Get-Module -ListAvariable | Where-Object {$_.name -eq "PSMPacker"} | Import-Module
```

## ⚡Usage

Detailed usage instructions and examples.

`Full Argument List`
```powershell 
ps2exe [-inputFile] '<file_name>' [[-outputFile] '<file_name>']
       [-prepareDebug] [-x86|-x64] [-lcid <id>] [-STA|-MTA] [-noConsole] 
       [-UNICODEEncoding]
       [-credentialGUI] [-iconFile '<filename>'] [-title '<title>'] 
       [-description '<description>']
       [-company '<company>'] [-product '<product>'] [-copyright '<copyright>'] 
       [-trademark '<trademark>']
       [-version '<version>'] [-configFile] [-noOutput] [-noError] [-noVisualStyles] 
       [-exitOnCancel]
       [-DPIAware] [-winFormsDPIAware] [-requireAdmin] [-supportOS] [-virtualize] 
       [-longPaths]
```

## Contributing

We welcome contributions from the community. To contribute to this project, please follow these guidelines:

1. Fork the repository.
2. Create a new branch.
3. Make your changes and commit them.
4. Push your changes to your forked repository.
5. Submit a pull request detailing your changes.

## 📑License

This project is licensed under the [MIT License](LICENSE).

## 👤Contact

CommitFusion is authored and maintained by snoonx.

We hope CommitFusion enhances your Git commit workflow and brings more clarity to your version control history. If you have any questions or feedback, please don’t hesitate to reach out. Happy coding!

💌 [Email](mailto:your-email@example.com)
💬 [Slack](https://slack.com/your-channel)
🐦 [Twitter](https://twitter.com/your-twitter-handle)
🌐 [Website](https://your-website.com)

💻 [GitHub Repository](https://github.com/your-username/your-repository)