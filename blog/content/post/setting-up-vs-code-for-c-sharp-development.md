---
title: "Setting Up VS Code for C# Development"
url: setting-up-vs-code-for-c-sharp-development
date: 2021-07-10T20:41:08+10:00
---

Oh hello there, I haven't seen you in a while! :)

So while Python is still my main language at work, I continued to search for a new language that I
would use for hobby projects.  I've been back on Windows for several years and done more Go and a
lot of PowerShell too.  At the end of the day, while I appreciate Go's strengths, it's really not
the end game for me.  Crystal is lovely and has hit 1.0 but is still extremely far from maturity.

Some recent openings in our IoT department were requesting C# skills which I got really excited
about for some reason, and off I went to see what all the fuss was about.  Well, all I can say is,
I get it!  I really wish I had paid attention to the developments since .NET Core, as the language
is now completely cross-platform, evolving constantly and one absolutely incredible language for
developing a very wide variety of apps.

The main IDEs C# developers use are [Microsoft's Visual Studio](https://visualstudio.microsoft.com/)
or [JetBrains Rider](https://www.jetbrains.com/rider/) both which are excellent.  However, I do
feel very far from my comfort zone in Visual Studio and find it very laggy in use.  Rider is much
better but is a paid product which I can't justify while not using the language professionally.

So I went back to my daily driver for Python development, Visual Studio Code.  Being a Microsoft
product, C# is indeed supported rather well in this editor but I didn't find a lot of step by step
guides that one can follow to get started with it, so hopefully my hardships will save someone
else the same challenges I had when starting out.

## Installing .NET

I will admit that the various versions of .NET are a bit confusing, but here's all you need to know:

* **.NET Framework** is the older closed source, Windows only release, skip this one!
* **.NET Core 3.1** is the open source, cross-platform LTS release which is still used widely and
  it supports C# 8.0.
* **.NET 5.0** is the current open source, cross-platform release which offers all the extra
  goodies in C# 9.0

You'll need to start by downloading the relevant release for your OS (I'll be using Windows) from
[Microsoft's Download .NET page](https://dotnet.microsoft.com/download).

Once installed, you'll now have a new command available at your terminal called `dotnet`.

## Installing Visual Studio Code & Extensions

After downloading and installing [Visual Studio Code](https://code.visualstudio.com/), you'll want
to install the following extensions:

* **C#**: The main C# language support which uses OmniSharp to provide IDE-like editing features.
* **Visual Studio IntelliCode**: AI-powered coding assistance while you code.
* **.NET Core Test Explorer**: Makes it easy to see all your tests and run them.
* **Cake** or **NUKE Support**: These are two excellent build systems available for C# so you'll
  need to check them out on their respective websites to see which you like most.  I personally
  choose Cake due to its simpler setup and rich legacy.
* **Nuget Package Manager**: This just makes it easier to install dependencies
  (known as Nuget packages) for your project.  You can do the same thing at the CLI too, so this
  may be something you don't use depending on your workflow.

Now for configuration, I'd recommend the following additions to your existing config:

```js
{
    // Configure ruler markers
    "editor.rulers": [100],

    // Automatically format your code as you type
    "editor.formatOnType": true,

    // Ensure that whitespace is cleaned up when saving
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "files.trimFinalNewlines": true,

    // Enable Roslyn Analyzers which check your code for issues
    "omnisharp.enableRoslynAnalyzers": true
}
```

Please note that I have left coverage reporting out of this post as it deserves its own which I'll
post in the future.

## Creating Your Project

Creating your project must be done at a terminal; we'll be using PowerShell:

```powershell
# Create and open a project directory
mkdir ProjectName
cd ProjectName
code .

# Create a new solution
dotnet new sln -n ProjectName

# Create a gitignore file for the solution
dotnet new gitignore

# Create various C# projects
# (classlib seems to default to netstandard2.0 so it's best that we are explicit)
# You may use -f net5.0 if you wish to work against .NET 5.0
dotnet new console -n ProjectCLI -f netcoreapp3.1
dotnet new classlib -n ProjectLibrary -f netcoreapp3.1
dotnet new xunit -n ProjectLibrary.Tests -f netcoreapp3.1

# Add projects to the solution
dotnet sln ProjectName.sln add (ls *\\*.csproj)

# Add a reference for the library to the CLI project
dotnet add ProjectCLI reference ProjectLibrary/ProjectLibrary.csproj

# Add a reference for the library to the test project
dotnet add ProjectLibrary.Tests reference ProjectLibrary/ProjectLibrary.csproj
```

So let's summarise what we've done here:

* **Create a Solution**: A solution (*.sln) file is one which brings together multiple projects
  that you create into a single unified entity.
* **Create Several Projects**: We can create any number of projects in a solution.  Usually
  you would have a project for your library and a separate project for your tests of that library.
  Similarly, your CLI will typically be a separate project also.  Of course, you may create as
  many projects as you like if you have many libraries that you wish to separate.
* **Add Projects to Solution**: We must explicitly add each project to the solution so that the
  solution knows about them.
* **Add Project References**: In order for one project to use another, you must add a reference
  to the project you wish to use in the project which will be using it.

## Building & Testing Projects

Personally, I do all my builds at the CLI.  There is a mechanism built into VS Code to do this but
it ultimately just runs the command you specify so I just run it myself.

Here are some useful commands you'll need:

```powershell
# Build all projects using the default debug configuration
dotnet build

# Build all projects using a release configuration
dotnet build -c Release

# Build a project ignoring previously built artefacts
dotnet build --no-incremental --force

# Build and run the CLI
dotnet run -p ProjectCLI

# Run the tests
dotnet test

# Run the tests with more detailed output (this is my preferred default)
dotnet test -v normal
```

Debugging is fully supported in Visual Studio Code.  You may simply click the ruler near the line
numbers to add a breakpoint, and hit F5 to start debugging.

## What We Haven't Covered Here

In the interest of keeping this post concise, I have not gone into detail on unit test coverage
or linting configuration.  These are more in-depth topics that deserve their own post.

## Some Limitations of VS Code

Overall, I have found VS Code to be an excellent C# development environment, but it naturally has
various limitations compared to the IDEs mentioned above:

* **Project Types**: Visual Studio Code won't offer you the sort of tools provided with Visual
  Studio for things like desktop and mobile app development.
* **EditorConfig Generation**: Visual Studio offers a very rich way to create an
  [.editorconfig](https://editorconfig.org/) which sets both linting and styling rules for your
  code.  Some of these features are not supported in VS Code and I haven't found any way to
  create this file other than manually in VS Code.
* **Linting Exclusions**: Unfortunately, adding an exclusion for a linting error is not one click
  away as it is in Visual Studio.  Doing this manually is IMHO not so straightforward either, so
  I typically just open Visual Studio to do this at the moment.
* **Organising Imports**: I haven't yet found a way to automatically organise imports
  alphabetically as I would with isort when coding Python.

I'd be happy to be corrected if anyone is aware of a way to accomplish some of these items above.
