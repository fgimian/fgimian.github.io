---
title: Setting up Virtual Development Environments for Ruby
date: 2012-12-08T19:00:00+11:00
---

In this article, I'll be going through the creation of virtual Ruby development
environments.  Using this sort of approach when developing applications allows
you to start from a clean state at any time and also have vastly different
environments setup for various projects on the same server.

I must say that the brilliant [RVM](https://rvm.io/) is about as good as it
gets when it comes to virtual development environments.  RVM can install Ruby
for you and contains a very complete virtual environment experience with bash
completion and even automatic switching of environments based on the project
directory you are in.

## RVM Installation & Usage

You may install RVM, the latest Ruby and rubygems as follows:

```bash
curl -L https://get.rvm.io | bash -s stable --ruby
```

This may be installed an root (to /usr/local/rvm) or as a user (to ~/.rvm)

Now enable bash completion as follows:

```bash
echo "[[ -r $rvm_path/scripts/completion ]] && source $rvm_path/scripts/completion" >> ~/.bashrc
source ~/.bashrc
```

You may uninstall RVM at any time using the command:

```bash
rvm implode
```

View the Ruby version and any other installed versions as follows:

```bash
rvm list
```

To install an older Ruby version, simply run install:

```bash
rvm install 1.8.7
```

You may now use the version:

```bash
rvm use 1.8.7
```

You may check what version you are on at any time by simply using:

```bash
rvm use
```

To upgrade RVM to the latest version at any time, simply use:

```bash
rvm get stable
```

## RVM Environments

Environments are created against specific Ruby versions.  So for example, one
could have two environments called "project1" as long as they are created
against a different version of Ruby.

To create a virtual environment and install some gems (Ruby modules) in it,
switch to the Ruby version you are interested in and create a gemset:

```bash
rvm use 1.9.3
rvm gemset create project1
```

You may switch to the new gemset using any of the following commands (take
your pick):

```bash
rvm gemset use project1
rvm @project1
rvm 1.9.3@project1
```

And naturally, you may install gems in that gemset as follows:

```bash
gem install redcarpet
```

To list all created gemsets (environments), use:

```bash
rvm gemset list
```

To force a particular environment for a project, you may create a **.rvmrc**
file in the project folder with the appropriate commands needed to run the
project:

e.g.

```bash
rvm use 1.9.3
rvm gemset use project1
```

For further information about RVM, be sure to check out the official site.
This is a must-have for any Ruby developer.
