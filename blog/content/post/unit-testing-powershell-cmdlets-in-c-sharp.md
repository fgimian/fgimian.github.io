---
title: Unit Testing Powershell Cmdlets in C#
url: unit-testing-powershell-cmdlets-in-c-sharp
date: 2021-07-11T15:33:05+10:00
---

So you're venturing into PowerShell cmdlet development in C# are you?  Good for you!  But how will
you unit test those little buggers?

Some people write their unit tests in PowerShell using [Pester](https://github.com/pester/Pester)
which seems less ideal to me.  At that point, you are left in an awkward position when it comes to
mocking because all your mockable interfaces will be in C#, so it'll be too late to replace them.
Also it takes you away from the ecosystem you are used to; XUnit, NSubstitute (or Moq) and your
beloved C# of course.

## The Common Solution

Many people take [Daniel Schroeder's documented approach](https://blog.danskingdom.com/Create-and-test-PowerShell-Core-cmdlets-in-CSharp/)
and write a unit test that looks something like this:

```c#
// Ensure you have imported LINQ for this to work
using System.Linq;

[Fact]
public void Invoke_WithRepeats_ShouldRepeatPhraseTheCorrectNumberOfTimes()
{
    // Arrange
    var cmdlet = new GetRepeatedPhraseCmdlet
    {
        Phrase = "A test phrase.",
        NumberOfTimesToRepeatPhrase = 3
    };

    // Act
    var results = cmdlet.Invoke().OfType<string>().ToList();

    // Assert
    Assert.Single(results);
    Assert.Equal("A test phrase.A test phrase.A test phrase.", results[0]);
}
```

This is very neat and seems to work well on the surface, but it's actually not a great solution
when you start dealing with non-terminating errors and trying to measure your code coverage.

Let's get stuck into the details!

## How Cmdlets Actually Work

Let's start by looking at how `Invoke` actually works in the
[abstract Cmdlet class](https://github.com/PowerShell/PowerShell/blob/master/src/System.Management.Automation/engine/cmdlet.cs):

```c#
public IEnumerable Invoke()
{
    using (PSTransactionManager.GetEngineProtectionScope())
    {
        List<object> data = this.GetResults();
        for (int i = 0; i < data.Count; i++)
            yield return data[i];
    }
}

internal List<object> GetResults()
{
    var result = new List<object>();
    if (this.commandRuntime == null)
    {
        this.CommandRuntime = new DefaultCommandRuntime(result);
    }

    this.BeginProcessing();
    this.ProcessRecord();
    this.EndProcessing();

    return result;
}
```

**Note**: I have removed some unnecessary lines and re-arranged the methods for clarity.

So let's break this down:

* `Invoke` simply calls `GetResults` and returns an iterator of all the items returned by it
* `GetResults` creates a default runtime if one isn't provided and passes an empty list of objects
  into its constructor (the purpose of this is so that the command runtime can fill that list up
  with all objects returned by the cmdlet)
* `GetResults` then calls the three processing methods for executing each stage of the cmdlet

Our cmdlet will primarily call three methods to display output; `WriteObject`, `WriteWarning` and
`WriteError` so let's check out what they do (within the same Cmdlet abstract class);

```c#
public void WriteObject(object sendToPipeline)
{
    using (PSTransactionManager.GetEngineProtectionScope())
    {
        commandRuntime.WriteObject(sendToPipeline);
    }
}

public void WriteWarning(string text)
{
    using (PSTransactionManager.GetEngineProtectionScope())
    {
        commandRuntime.WriteWarning(text);
    }
}

public void WriteError(ErrorRecord errorRecord)
{
    using (PSTransactionManager.GetEngineProtectionScope())
    {
        commandRuntime.WriteError(errorRecord);
    }
}
```

**Note**: Once again, I've removed null checks which won't even fail in this case.

So these methods simply call the related method in the command runtime.  This command runtime sure
is looking important hey?

OK!  So let's now look at the `DefaultCommandRuntime` and see what these respective methods do:

```c#
internal class DefaultCommandRuntime : ICommandRuntime2
    private readonly List<object> _output;

    public DefaultCommandRuntime(List<object> outputList)
    {
        _output = outputList;
    }

    public void WriteObject(object sendToPipeline)
    {
        _output.Add(sendToPipeline);
    }

    public void WriteWarning(string text)
    {
    }

    public void WriteError(ErrorRecord errorRecord)
    {
        if (errorRecord.Exception != null)
            throw errorRecord.Exception;
        else
            throw new InvalidOperationException(errorRecord.ToString());
    }
    ...
}
```

So really there's nothing that complex going on here:

* `DefaultCommandRuntime` will fill the `result` list declared in `GetResults` with any objects
  that are written via `WriteObject`
* It will do nothing when `WriteWarning` is called
* It will throw an exception when `WriteError` is called

Now why is this all a problem?

1. We will always need to iterate over the results to run `Invoke` even if we are not expecting
   any at all.  This can be done in many ways, but all of those ways are a bit ugly:

    ```c#
    // Capture the results using a generic object type and store them in a throwaway variable
    var _ = cmdlet.Invoke().OfType<object>().ToList();

    // Loop over all results using a throwaway variable for each item
    foreach (var _ in cmdlet.Invoke()) {}
    ```
2. We won't be able to validate any of warnings as they are not captured at all.
3. And most importantly, if a non-terminating error is written using `WriteError` in your cmdlet,
   an exception will be raised and all other results (created with `WriteObject`) will be lost.
   
   Further to this, [Coverlet](https://github.com/coverlet-coverage/coverlet) and
   [OpenCover](https://github.com/OpenCover/opencover) won't detect the closing braces in your call
   to `WriteError` as covered because the exception is thrown in `WriteError` itself, not your
   code.
   
   See [this issue](https://github.com/coverlet-coverage/coverlet/issues/1183) for more information.

## The Solution

Before I share the solution, I have to give full credit to
[Andrew Theken](https://github.com/atheken) for his
[MockCommandRuntime implementation](https://github.com/atheken/nuget/blob/master/test/PowerShellCmdlets.Test/MockCommandRuntime.cs)
that heavily inspired my simplified implementation.

First, we can completely avoid the use of the iterator in our unit tests by simply creating our
own base class with a method that simply calls the processing methods:

```c#
public abstract class OurCmdlet : Cmdlet
{
    public void Execute()
    {
        BeginProcessing();
        ProcessRecord();
        EndProcessing();
    }
}
```

From this point forward, we will call `Execute` in our tests instead of `Invoke`.  But now, we need
to create our own command runtime that will capture output, errors and warnings without throwing
exceptions.

Due to the fact that output can be any object, we'll make this a generic class so that the calling
test can specify the type it wants to receive for output.

Sadly we can't inherit from `DefaultCommandRuntime` as it is `internal`, however we'll
[use it](https://github.com/PowerShell/PowerShell/blob/master/src/System.Management.Automation/engine/DefaultCommandRuntime.cs)
as our starting point.

I will only show the attributes and methods that differ from this implementation below for clarity.

```c#
// Ensure you have imported LINQ for this to work
using System.Linq;

public class MockCommandRuntime<T> : ICommandRuntime
{
    public List<T> Output
    {
        get { return _output.Cast<T>().ToList(); }
    }

    public List<ErrorRecord> Errors { get; }

    public List<string> Warnings { get; }

    private readonly List<object> _output;

    public MockCommandRuntime()
    {
        _output = new List<object>();
        Errors = new List<ErrorRecord>();
        Warnings = new List<string>();
    }

    public void WriteError(ErrorRecord errorRecord)
    {
        Errors.Add(errorRecord);
    }

    public void WriteWarning(string text)
    {
        Warnings.Add(text);
    }
}
```

Simple right?  So now we simply capture our errors and warnings and help ourselves out by casting
the output to the template type requested when the `MockCommandRuntime` is created in tests.

Furthermore, the attributes that capture all forms of output are marked as `public` so they are
accessible to the test.

## Writing a Unit Test Using MockCommandRuntime

Now, as long as our cmdlet inherits from `OurCmdlet`, our unit test will look something like this:

```c#
[Fact]
public void Invoke_WithRepeats_ShouldRepeatPhraseTheCorrectNumberOfTimes()
{
    // Arrange
    var runtime = new MockCommandRuntime<string>();
    var cmdlet = new GetRepeatedPhraseCmdlet
    {
        CommandRuntime = runtime,
        Phrase = "A test phrase.",
        NumberOfTimesToRepeatPhrase = 3
    };

    // Act
    cmdlet.Execute();

    // Assert
    Assert.Single(runtime.Output);
    Assert.Equal("A test phrase.A test phrase.A test phrase.", runtime.Output[0]);
}
```

And what if the cmdlet throws a non-terminating error?

```c#
[Fact]
public void Invoke_WithInvalidRepeats_ShouldError()
{
    // Arrange
    var runtime = new MockCommandRuntime<string>();
    var cmdlet = new GetRepeatedPhraseCmdlet
    {
        CommandRuntime = runtime,
        Phrase = "A test phrase.",
        NumberOfTimesToRepeatPhrase = -1
    };

    // Act
    cmdlet.Execute();

    // Assert
    Assert.Single(runtime.Errors);
    var exception = runtime.Errors[0].Exception;
    Assert.IsType<ArgumentException>(exception);
    Assert.Equal("Invalid number of times specified.", exception.Message);
}
```

Coverage reporting will work perfectly too and you will also be able to check any combination of
`Output`, `Warnings` and `Erorrs` if your cmdlet intends to return some objects, write some
warnings and write some non-terminating errors too.

## Go Forth and Test

So there you go!  You may now put aside your Pester library and enjoy writing tests with your
favourite C# test and mocking framework!
