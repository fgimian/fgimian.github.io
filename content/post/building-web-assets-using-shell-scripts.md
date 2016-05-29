---
title: Building Web Assets Using Shell Scripts
date: 2016-04-03T19:21:21+10:00
---

With the various pre-processed languages used for web (e.g. Coffeescript,
LESS .etc), we often reach for tools like [Gulp](http://gulpjs.com/),
[Grunt](http://gruntjs.com/) and [Brunch](http://brunch.io/).  However,
what if we could just strip it back to basics and use a shell script?
This could potentially save you the entire Node.js stack if you only plan to
use SCSS (via LibSass).

Firstly, we're going to need to run both our development server (for the
respective framework) and one or more other commands to watch and pre-process
files.

```bash
# Convert SIGINT and SIGTERM to an EXIT signal to avoid duplicate traps
trap 'exit' INT TERM

# Kill all processes in the current process group
trap 'kill 0' EXIT

# Run the web server in the background (e.g. Hugo)
hugo server &

# Run various commands to watch and compile files
# TODO: add appropriate commands here

# Wait for all background processes to complete
wait
```

This solution will allow us to run as many processes as required
and see their output all combined in one window.  As soon as you
hit Ctrl+C, all background processes will be stopped automatically.

Now we're going to need a tool which can watch for changes in files
and compile them when they change.  For this, we'll use
[fswatch](http://emcrisostomo.github.io/fswatch/) which is written
in C, extremely fast and easy to install on OS X with
[Homebrew](http://brew.sh/).

```bash
brew install fswatch
```

For the sake of this demonstration, I'm going to use sassc to
compile Twitter's Bootstrap.  So let's install this first:

```bash
brew install sassc
```

Using fswatch is extremely easy, for example:

```bash
fswatch -0 vendor/bootstrap-sass/assets/stylesheets | while IFS= read -r -d "" path
do
  echo "Re-building Bootstrap CSS (due to change in ${path})"
  sassc --style compressed \
    vendor/bootstrap-sass/assets/stylesheets/_bootstrap.scss \
    public/css/bootstrap.css
done &
```

So let's break this down.  We start by watching the stylsheets directory for
any changes and output null separated filenames when they change.

```bash
fswatch -0 vendor/bootstrap-sass/assets/stylesheets
```

Next up, we read entry by entry separated by null and save the result into the
shell script variable `$path`:

```bash
while IFS= read -r -d "" path
```

We can make this even a little neater using an alias and little bash function:

```bash
# Helpers
shopt -s expand_aliases
alias on_change="while IFS= read -r -d ''"
monitor()
{
  [[ $1 == "-i" ]] && { echo -n -e "\0"; shift; }
  fswatch -0 "$@"
}
```

I have implemented a little extra feature above.  As well as running fswatch,
you may optionally specify `-i` to the `monitor` function and this will trigger
a refresh as soon as you start your script to ensure everything is up to date
before you start developing.

Now, we can write watchers as follows:

```bash
monitor -i vendor/bootstrap-sass/assets/stylesheets | on_change path
do
  echo "Re-building Bootstrap CSS (due to change in ${path})"
  sassc --style compressed \
    vendor/bootstrap-sass/assets/stylesheets/_bootstrap.scss \
    public/css/bootstrap.css
done &
```

Of course, if you're using a tool that contains a watch option, you may
simply add that command followed by an & to run that in the background too.

Each one of these commands will create a sub-process to the shell script and
be terminated when you hit Ctrl-C.

Have fun bashing away :)
