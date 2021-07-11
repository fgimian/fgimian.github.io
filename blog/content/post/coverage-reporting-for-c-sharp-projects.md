---
title: Coverage Reporting for C# Projects
url: coverage-reporting-for-c-sharp-projects
date: 2021-07-11T14:37:35+10:00
---

Upon beginning my journey into C# development, I started to suspect that coverage reporting was
reserved for paid products only.  Only
[Visual Studio Enterprise](https://visualstudio.microsoft.com/vs/compare/) (the most expensive version)
and the paid [JetBrains Rider](https://www.jetbrains.com/rider/) IDE have coverage reporting
built in.  Rider users must purchase the [dotCover](https://www.jetbrains.com/dotcover/) addon
to obtain this functionality.

However, upon further investigation, I was happy to find that there are several incredible open
source tools which can capture code coverage for C# projects.

## Capturing Code Coverage

### Coverlet

[Coverlet](https://github.com/coverlet-coverage/coverlet) is a fantastic open source coverage
library which integrates seamlessly with Microsoft's MSBuild system (the one used when you call
`dotnet build`).

You'll need to start by adding it as a dependency to your test project

```powershell
# Install Coverlet in your test project
pushd ProjectLibrary.Tests
dotnet add package coverlet.msbuild
popd

# Run tests using the Coverlet MSBuild plugin
dotnet test `
    /p:CollectCoverage=true `
    /p:CoverletOutputFormat=lcov `
    /p:CoverletOutput="..\.coverage\lcov.info"
```

This will create a directory named `.coverage` alongside your solution file and output the coverage
report using the LCOV format with the name **lcov.info**.  Coverlet supports many formats for
coverage reports as found on their excellent
[MSBuild Integration documentation](https://github.com/coverlet-coverage/coverlet/blob/master/Documentation/MSBuildIntegration.md):

* json (default)
* lcov
* opencover
* cobertura
* teamcity

I personally recommend the LCOV format when possible as this integrates well with various VS Code 
extensions which we'll cover below.

Now you may be wondering, how do I visualise the results of this report?  More on that below too!

### OpenCover

[OpenCover](https://github.com/OpenCover/opencover) is another excellent open source coverage
reporting tool for C# projects which provides similar functionality to Coverlet.

You'll first need to install OpenCover using the
[MSI installer](https://github.com/OpenCover/opencover/releases) provided by the project.

You may then set it up to work with your project as follows:

```powershell
# Create a directory for coverage reports
mkdir .coverage

# Run tests using OpenCover (ensuring you replace the assumbly name below)
~\AppData\Local\Apps\OpenCover\OpenCover.Console.exe `
    -target:"dotnet.exe" `
    -targetargs:"test" `
    -output:".coverage\coverage.xml" `
    -register:user -filter:"+[<assembly-name>]*"
```

In the our case, the assembly name will be **ProjectLibrary** and thus the filter should be set to
`"+[ProjectLibrary]*"`.  Please ensure you update this to match your library project name.

OpenCover only outputs files in its own OpenCover XML format.  Sadly
[the LCOV format is not currently supported](https://github.com/OpenCover/opencover/issues/643)
which limits its use with VS Code coverage extensions.

## Visualising Coverage

### ReportGenerator

[ReportGenerator](https://github.com/danielpalme/ReportGenerator) is one of the many gems in the
.NET world.  Its purpose is to take a coverage report and generate a visual representation of it,
primarily in HTML format (although it offers many output formats to choose from.)

So let's get it installed and check it out:

```powershell
# Install ReportGenerator globally
dotnet tool install -g dotnet-reportgenerator-globaltool

# Generate the coverage HTML report for the Coverlet LCOV report
ReportGenerator.exe -reports:".coverage\lcov.info" -targetdir:".coverage"

# Generate the coverage HTML report for the OpenCover report
ReportGenerator.exe -reports:".coverage\coverage.xml" -targetdir:".coverage"

# View the report in your default browser
ii .coverage\index.html
```

I tend to leave this open in my browser while developing and refresh the page each time I rerun my
tests.

### Coverage Gutters (for VS Code)

[Coverage Gutters](https://github.com/ryanluker/vscode-coverage-gutters) is the most popular
extension for viewing lines that are not covered by tests in the gutter within VS Code.

**Important**: Coverage Gutters ONLY supports LCOV coverage reports, so it will only work with
Coverlet at this time.

Coverage Gutters will automatically search for a file named **lcov.info** anywhere in your project,
however the extension won't display coverage automatically.

To activate Coverage Gutters, you must hit **Ctrl+Shift+7** or run the
**Coverage Gutters: Display Coverage** command via the command palette (Ctrl+Shift+P).  You'll need
to do this each time you reopen VS Code.

There is an [open issue](https://github.com/ryanluker/vscode-coverage-gutters/issues/236)
requesting that the extension be activated automatically without intervention which would also be
my preference.

### Code Coverage (for VS Code)

[Code Coverage](https://github.com/markis/vscode-code-coverage) is another great extension for
viewing lines not covered by tests.  Unlike Coverage Gutters, Code Coverage adds squiggly lines
under each line of code that's not covered by tests.

**Important**: Like Coverage Gutters, Code Coverage ONLY supports LCOV coverage reports, so it will
only work with Coverlet at this time.

After installing the Code Coverage extension, you'll just need to configure it to search for
the coverage report as follows in your VS Code settings:

```json
"markiscodecoverage.searchCriteria": ".coverage/lcov.info"
```

## Honourable Mention

JetBrains offer a
[free CLI version of their dotCover](https://www.jetbrains.com/help/dotcover/Running_Coverage_Analysis_from_the_Command_LIne.html)
tool which is included in their Rider IDE.

I haven't explored this to the same level of detail, as the other two options are fully open source
and work extremely well.  However, I really appreciate JetBrains' generosity in providing their
tool for free too and it's definitely worth knowing about if you wish to crosscheck output from
one of the coverage tools above.

## What's Next?

You can integrate Coverlet, OpenCover and ReportGenerator with the various build systems available
for C#, namely [Cake](https://www.google.com/search?client=firefox-b-d&q=cake+build) and
[NUKE](https://nuke.build/).  I hope to cover these in a future blog post.
