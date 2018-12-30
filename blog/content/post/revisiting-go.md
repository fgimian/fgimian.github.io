---
title: Revisiting Go
date: 2018-12-30T06:41:36+11:00
---

Several months ago I wrote about Crystal and its potential, but also spoke about why Go was not a language I was interested in.

In my post, I originally stated the following:

> No keyword arguments, no exceptions, no classes, no generics and awful naming styles all led to me saying no to Go (although perhaps this simplicity is what attracts many to it).  I have actually spent quite some time learning and coding in Go and found it frustrating at best ... C++ is a far better language!  Having Google behind the language has ultimately resulted in its success even though it really takes us back to the days of C...

Understandably and rightly so, these statements did cause some controversy when one of the Crystal advocates published the post to Hacker News (which I wasn't anticipating).  I will absolutely admit that I was way too opinionated on the language at that point and will be more mindful when being so critical in the future.  That particular blog post was just a dump of ideas I had at the time while trying to find a new language to learn for hobby projects at home.

Although I spent quite a lot of time on Crystal and am still very fond of it, I had to abandon it for the current time due to its lack of maturity.  I realised that although I could use it for little things here and there at home, I would never be able to use it in production at work until it matures.  The state of libraries is also very touch and go in Crystal and I found myself only trusting that the included standard libraries would be stable and refined.

So it's time to revisit Go and attempt to make sense of my thoughts about the language 6 months ago.  It is also the time to consider that I may have been incorrect about many of my sentiments.

# Current Work Project

## Maintaining a Large C++ Codebase

This begins several months after my post where I've been moved onto a project at work which is primarily developed in C++ and with some minor tooling in Python and one tiny HTTP upload server in Go.  The application primarily works by exposing an API which reads and writes from a PostgreSQL database in addition to running various background tasks that ship data in and out of MQTT topics.  The app also implements a custom communication specification over UDP and TCP for devices to communicate with.

I went through the C++ code in quite a lot of detail to understand the app's functionality and I along with several others in the team agreed that the code would be hard if not impossible to maintain long term.  The developer who wrote the code had really tried to use C++ in areas where it really isn't usually used (e.g. API development) and developed so many libraries himself with few unit tests.  Further to this, the few third party library dependencies were simply copied into the Git repository itself, a common problem seen in C++ projects due to lack of a standardised dependency management system.

Having not done any serious coding in C++ for the better part of a decade, I also started to see how varied people's coding styles could be and how huge the C++ language has become over the years with the various iterations.  In a team of primarily Python and JavaScript developers, and with the lack of focus on APIs in the C++ world, would C++ be a viable choice if the application were to be rewritten?

## Thoughts About Rewriting The Application

Due to the fact performance was a requirement for the app, my colleague and I discussed what language we would rewrite the app in if we were given the chance in 2019.

This app would need to be running in production on a stable and mature language and assuming we didn't go with C++, our choices were really just Go and Rust.

I spent some time reading about Rust and trying to reason about why we should use it.  The language is intriguing but a rather complex one and although it's gaining popularity, it's still has nowhere near the following of Go when it comes to libraries and community discussion.  My colleague who had tried Rust previously explained to me that although he loved the language, it was a rather difficult language to get to grips with, approaching the complexity of C++.

## Go Makes An Appearance

Several weeks ago, I found myself in a situation where I had to debug that little HTTP upload component developed in Go.  Having only played with Go once well over a ago, I found it surprisingly easy to read the code and get it building and running on my dev server.  I made various changes to the codebase while troubleshooting which all went quite seamlessly.

## Developing Something New In Go

As I was finishing the year, I was asked to develop a monitoring API which would expose details about server health in an endpoint which would be consumed by a dashboard.

I designed this in a client / server model (using SSH as the communication between both) and developed the initial version of both the client and server in Python.

The client app would need to be deployed to all of our production servers and as we were nearing our Christmas embargo, this would need to happen fast!  I realised that getting the app deployed with Python would be rather painful as I would need to either Dockerise it (in which case I would need to install Docker everywhere) or install Python 3.6 with all dependent packages everywhere.

So, I decided to rewrite the client in Rust or Go so I could ship a single binary instead.  I had already leveraged the awesome [psutil](https://github.com/giampaolo/psutil) library in Python which I then started searching for in the two languages I had to choose from.  Go had a very mature and fully featured port called [gopsutil](https://github.com/shirou/gopsutil) while Rust had a very incomplete [rust-psutil](https://github.com/borntyping/rust-psutil) so decided to write the client in Go.  Doing this was surprisingly easy.  It took me only a few hours to do and I had only a single binary to deploy to all my servers which ran incredibly fast.

After these experiences, more thought and a discussion with the developer in the team that had also used Go on that little HTTP upload server, I started to believe that Go would be the perfect choice for rewriting our app moving forward.

## Personal Projects In Go

During the Christmas holiday season, I decided to rewrite various other CLI utilities that I've developed for automating some activities on my Mac in Go to see if I would hit any roadblocks.

Once again, porting the code from Python was surprisingly easy.  I also spent more time learning about the Go tooling and setting up Visual Studio Code as a proper Go IDE and realised just how rich the Go ecosystem actually is.  Development is very fluid and polished in comparison to a language like Crystal for example, where the ecosystem is still mostly in an alpha state.

So I have now almost rewritten all my scripts in Go and really enjoyed the process with pretty much all my questions answered via Google or in the Go docs along the day.

# Original Gripes

## Keyword Arguments

This was definitely something I was nervous about coming from Python, but in practice I didn't find this to be a huge problem.

While in Python I would write:

```python
greet(name='Fotis', industry='IT')
```

In Go, I could write the following if I wanted a similar effect:

```go
name := "Fotis"
industry := "IT"
greet(name, industry)
```

## Default Arguments

Another concern was the fact that there were no default values for arguments.  This meant that all arguments must always be passed to a function call.

In practice, I actually found this behaviour to be more of a positive than a negative as it made the code more explicit and clear to read.

In the case where a huge number of arguments are required, Go often leverages structs which easily allow fields to be excluded.

For example, here's how [cobra](https://github.com/spf13/cobra) does it:

```go
func main() {
    var genre, defaultArtist string

    var cmd = &cobra.Command{
        Use:   "sonic-element-encode [flags] <filename>",
        Short: "Encodes and tags a render to a 320 kbps MP3 using LAME",
        Args:  cobra.ExactArgs(1),
        Run: func(cmd *cobra.Command, args []string) {
            ...
        },
    }

    flags := cmd.Flags()
    flags.StringVarP(
        &genre, "genre", "g", "Trance", "the genre to use in the tags",
    )
    flags.StringVarP(
        &defaultArtist, "default-artist", "a", "Sonic Element",
        "the artist name to use when it is missing in the filename",
    )

    if err := cmd.Execute(); err != nil {
        os.Exit(1)
    }
}
```

Note that when creating the cobra `Command`, [various additional struct fields are possible](https://godoc.org/github.com/spf13/cobra#Command) but have simply been excluded above.

## Generics

This hasn't hurt me so much thus far, but do still think it would resolve some frustrations while implementing functionality that can work across types.

As an example, I had to implement a function to sort keys of a map, but due to the lack of generics, I needed to explicitly specify the key and value types (specifically `map[string]string)`) in the parameter of my function:

```go
func SortedMapKeysString(data map[string]string) []string {
    keys := make([]string, 0, len(data))
    for key := range data {
        keys = append(keys, key)
    }
    sort.Strings(keys)
    return keys
}
```

I would need to re-approach this problem by leveraging [reflect](https://golang.org/pkg/reflect/) similar to the Go [sort library](https://golang.org/pkg/sort/) to make this work with maps containing any value type:

```go
func SortedMapKeysString(data interface{}) ([]string, error) {
    rv := reflect.ValueOf(data)

    fmt.Println(reflect.TypeOf(rv))
    if rv.Kind() != reflect.Map || rv.Type().Key().Kind() != reflect.String {
        return nil, errors.New("data must be a map with keys as strings")
    }

    keys := make([]string, 0, rv.Len())
    for _, key := range rv.MapKeys() {
        keys = append(keys, key.String())
    }
    sort.Strings(keys)
    return keys, nil
}
```

## Error Handling

Every Go developer is now very accustomed to seeing `if err != nil` quite a lot in their codebase:

e.g.

```go
// Open and parse the Cubase information plist
infoFile, err := os.Open(cubaseInfoPath)
if err != nil {
    fmt.Fprintln(
        os.Stderr,
        "ERROR: Unable to open the Cubase information plist -", err,
    )
    os.Exit(1)
}
defer infoFile.Close()

cubaseInfoBytes, err := ioutil.ReadAll(infoFile)
if err != nil {
    fmt.Fprintln(
        os.Stderr,
        "ERROR: Unable to read the Cubase information plist -", err,
    )
    os.Exit(1)
}

var data map[string]interface{}
_, err = plist.Unmarshal(cubaseInfoBytes, &data)
if err != nil {
    fmt.Fprintln(
        os.Stderr,
        "ERROR: Unable to parse the Cubase information plist -", err,
    )
    os.Exit(1)
}
```

This is certainly quite a big mindset shift when coming from the world of exceptions and it can sometimes be a little too verbose.

However, on the plus side, I find that Go really forces developers to think about how to handle every possible error that could occur.  It is also a lot harder to miss an error in Go compared to Python or Crystal where catching exceptions is essentially optional.  Often in Python, people resort to `except Exception` because they simply don't know what exception to catch (especially when working with 3rd party libraries that may themselves fail to catch all possible exceptions themselves).

As such, this has actually been one of my favourite things about Go.  I really feel that I am writing robust software that will rarely panic unless I explicitly ignore an error or panic myself.

It would be ideal if there was a way to fall-through to a certain code block when attempting a large amount of operations that can throw errors through:

e.g.

```go
loudness.Integrated, err = strconv.ParseFloat(matches[1], 64)
if err != nil {
    return nil, err
}
loudness.IntegratedThreshold, err = strconv.ParseFloat(matches[2], 64)
if err != nil {
    return nil, err
}
loudness.LRA, err = strconv.ParseFloat(matches[3], 64)
if err != nil {
    return nil, err
}
loudness.LRAThreshold, err = strconv.ParseFloat(matches[4], 64)
if err != nil {
    return nil, err
}
loudness.LRALow, err = strconv.ParseFloat(matches[5], 64)
if err != nil {
    return nil, err
}
loudness.LRAHigh, err = strconv.ParseFloat(matches[6], 64)
if err != nil {
    return nil, err
}
loudness.TruePeak, err = strconv.ParseFloat(matches[7], 64)
if err != nil {
    return nil, err
}
```

There are current [proposals](https://go.googlesource.com/proposal/+/master/design/go2draft-error-handling.md) to improve this in upcoming versions of Go. I'm personally not so fond of the proposed design change as it makes the language less explicit (e.g. the `check` statement means that you unwrap return values but exclude the last return value assuming it will be an `error` type).  I can't really think of a better approach either, so I'm tempted to say that the current approach is still more clear, albeit verbose.

## Lack of Classes

Although Go doesn't have classes per se, it does have structs which can have methods created on them.  These work very similarly to classes in use.

Inheritance is replaced with composition which would hopefully result in clearer code in a large project. However, I have not yet written anything big enough in Go to see how composition works in practice.

## Strange Naming Styles

So firstly, I should get this out of the way.  I do find `camelCase` less clear that `snake_case`.  I realise this is personal preference, and it is something that hasn't been nearly as bad in practice as I had thought it would be.  As such, this particular aspect is not a deal breaker, but it is a bit of a shame that Go didn't go with `snake_case` for clarity.

The bigger problem I'm facing is the fact that it is hard to see the difference between constants, variables, functions and structs all of which use the exact same convention.  `camelCase` is used for local or "private" items while `TitleCase` is used for "public" items.

So let's suppose we have an exported name such as **Download**:

```go
type Download struct {
    MetadataPath string
    Filename     string
    Size         int
    MD5          string
    SHA256       string
    URL          string
}
```

I can now easily write:

```go
download := Download{
    MetadataPath: "/var/test/download.meta",
    Filename:     "hello.txt",
    Size:         659,
    MD5:          "9bba825bbe9c53ae1fe1df99fa5aef3e",
    SHA256:       "b922835c1753a6bd28d90db8d2b9d47fb3ad9455317178c0ea04aa522a673257",
    URL:          "http://example.com/hello.txt"
}
```

But what if it was private?

```go
type download struct {
    MetadataPath string
    Filename     string
    Size         int
    MD5          string
    SHA256       string
    URL          string
}
```

I would now need to be more inventive with my variable name since **download** is already the name of the struct.

Many would just use `d`, or shorten it to `dwnld` or similar.

This is a relatively minor gripe in the greater scheme of things but I will admit that i would just prefer a `export` keyword in front of items that are to be available outside and naming conventions such as these below used all the time:

```go
export const MY_CONSTANT = "Hello"

export type DownloadItem struct {
    ...
}

func main() {
    variableName := 5
}
```

# Little Frustrations With Go

Naturally, while actually coding in Go, I've discovered a few additional things that I found a bit frustrating thus far.

## Lack of Sets

Sets in Python are very useful for creating a collection of unique items but also for easily comparing two sets of data too.

There are some libraries that implement this functionality, but more commonly, you would create a set in Go as follows:

```go
set := map[string]struct{}{}
for _, i := range items {
    set[i] = struct{}{}
}
```

Using `struct{}` as the value is efficient since this is an empty data structure.

You would then be responsible for implementing functions for comparing such items.  For example, you can see [this stackoverflow post](https://stackoverflow.com/questions/19374219/how-to-find-the-difference-between-two-slices-of-strings-in-golang) for ideas.

## Lack of Sorting for Maps

There's currently no built-in way to sort keys of a map.  Instead, you would typically create a slice containing the keys, sort that and then use it to iterate over the map:

Using the function defined above under **Generics**, we could then do something like this:

```go
data := map[string]string{
    "key2": "value2",
    "key1": "value1",
    "key4": "value4",
    "key3": "value3"
}
keys := SortedMapKeysString(data)
for _, key := range keys {
    value := data[key]
    fmt.Println(key, ":", value)
}
```

This is not really a big deal, but does result in more code for fairly trivial actions.

## Lack of Search for Slices & Arrays

I was a bit surprised to find that there's no built in way to search a slice in Go.  Instead, you must resort to a for loop for a linear search, or sort your slice and use [sort.Search](https://golang.org/pkg/sort/#SearchStrings) instead.

A typical linear search is written as follows:

```go
// Check if the item should be ignored
ignore := false
for _, ignoredName := range ignoredNames {
    if name == ignoredName {
        ignore = true
        break
    }
}
```

Once again, not a deal breaker, but functionality I would have loved to see available in the standard library.

## Tabs vs Spaces

I realise this is a topic that often makes developers very *passionate* but I personally have no problem with tabs in theory.

The real problem is the way code appears on sites like GitHub and GitLab, along with various tools on Unix based systems.  In the browser, tabs almost always appear as 8 spaces which look seriously ugly.

Fortunately, it is possible to remedy such problems on your own system for tools like `git diff`, `less` and `cat`:

```bash
# Update your bash profile to setup less and cat
cat >> ~/.bash_profile << EOF
# Ensure that Go is displayed with 4 spaces per tab in less and cat
export LESS="x4"
tabs -4
EOF

# Explicitly set the Git pager to ensure it works well with the LESS env variable
git config --global core.pager "less -FRX"
```

# Great Things About Go

Along the way, I've discovered various aspects of Go that I really loved.

## Ecosystem, Community & Development Experience

It really is wonderful to work on a language which is so widely supported and discussed.

The library ecosystem is rich and covers a lot of territory, editor integration is fantastic and there's even a fully fledged JetBrains [GoLand](https://www.jetbrains.com/go/) IDE if you are so inclined.  The Visual Studio Code Go extension is officially developed by Microsoft and is amazing and more than enough for me personally.

Tools like gofmt and golint are very refined and helpful too and ensure good code quality and consistency.

## Automatic Formatting

The Visual Studio Code Go extension (along with various others) automatically format your code upon save using a tool such as gofmt.  I initially was nervous about this but actually find it liberating and great. Fortunately the styles imposed by the Go tooling are very reasonable and easy to adapt to.

This ultimately means that I can spend less time worrying about aesthetics and just focus on functionality and code quality.

## Static Typing & Data Marshalling

This was one of the points that drew me to a language like Crystal and C++ in the past.  Go's implementation of the empty interface `interface{}` and the reflect package really make it possible to do very dynamic things if you wish.  However, most code follows more rigid typing practices which make everything much clearer to debug and result in much more robust and solid apps.

Using typed structs to marshal and unmarshal JSON and other data means extremely robust parsing and interpretation of data; an advantage mostly found in many statically typed languages.  Fortunately, I recently discovered libraries like [alchemize](https://github.com/jmvrbanac/alchemize) do something similar in Python.

## Simplicity & Readability

Clearly this is the biggest selling point of Go for most people and one of the driving forces that the inventors of the language were keen to impart on the language.

Go is extremely easy to read, absolutely as easy if not easier than a language like Python.  There are very few "tricks" up Go's sleeve compared to languages like Ruby, Python, Crystal and JavaScript.

On the downside, this can lead to extra verbosity (as discussed above) which is the tradeoff here.  But overall, I think Go code would be much easier for a large team to maintain than many other languages.

## Explicit Nature

One of the Zen of Python items is:

```
Explicit is better than implicit.
```

Interestingly, Go is about as explicit as a language can get.  This is an area where Crystal wasn't quite as good.

For example, I found a little bug in the Crystal standard library in the following function:

```crystal
def flags : ::File::Flags
  flags = ::File::Flags::None
  flags |= ::File::Flags::SetUser if @stat.st_mode.bits_set? LibC::S_ISUID
  flags |= ::File::Flags::SetGroup if @stat.st_mode.bits_set? LibC::S_ISGID
  flags |= ::File::Flags::Sticky if @stat.st_mode.bits_set? LibC::S_ISVTX
end
```

Crystal has inferred return types in functions which caused a problem in the function above.  The function is missing a return statement to return the flags that were created, so instead, it inferred a nil return value.  This would thankfully never happen in Go.

In Go, all parameter and return value types must be specified in functions.

Further to this, the explicit nature of handling errors makes Go feel very upfront as a language.

# Conclusion

Congratulations for reading this far (assuming you didn't just scroll down to the bottom) :)  Clearly, I've only spent a short time with Go and am sure to discover many more things I love and don't love about the language.

I hope to use it more extensively for real applications at work in the coming year to see how well it works in our team (assuming I can convince the guys that it's the right choice).

It's also great to see that the Go designers are improving the language with a native module system being added to Go 1.11 and hopefully generics on the horizon too.
