---
title: Setting up Virtual Development Environments for Python
date: 2012-12-08T19:47:00+11:00
---

Setting up virtual environments for Python is always a great way to keep your
projects and their related Python packages independent.

## Virtualenv ##

[Virtualenv](http://www.virtualenv.org) is the de-facto standard choice for
Python environments.  It's capable of creating independent Python module
groupings which you can switch to and from using commands.  Unfortunately,
virtualenv does not install and manage multiple versions of Python, but we'll
get to a solution for that with pythonbrew later.

To install virtualenv, simply use pip:

``` bash
sudo pip install virtualenv
```

If you would like bash completion, you can use the script created by Eugene
Kalinin:

``` bash
git clone git://github.com/ekalinin/virtualenv-bash-completion.git
sudo cp ./virtualenv-bash-completion/virtualenv /etc/bash_completion.d/
source ~/bashrc
```

You may now use virtualenv and install packages within environments as either
root or an ordinary user on the system.

Create an environment as follows:

``` bash
virtualenv python-env
```

You now have a local instance of Python which can be found at
**./python-env/bin/python**

You may then go ahead and install packages in the current directory by using
the virtualenv's pip executable.

``` bash
./python-env/bin/pip install Flask
```

All packages will placed in the local virtualenv under
**./python-env/lib/python2.7/site-packages/**

Rather than having to type such nasty pathnames to get to pip and python,
virtualenv has a cool little activate script which will alter your entire
working environment so that you can use all tools as you would if they were
installed on the system.

``` bash
source ./python-env/bin/activate
```

You may now use the tools as per usual:

``` bash
(python-env)fots@fotsies-ubprecise-01:~$ which python
/home/fots/python-env/bin/python
(python-env)fots@fotsies-ubprecise-01:~$ which pip
/home/fots/python-env/bin/pip
```

To return to your normal environment, simply type deactivate:

``` bash
deactivate
```

I suggest adding the following to the end of your .bashrc to help simplify
activation of virtualenvs:

``` bash
# Switch to a Python virtual environment
activate()
{
    source "$1/bin/activate"
}
```

You may now type the following to activate a virtual environment for Python:

``` bash
activate ./python-env
```

## Pythonbrew Installation & Usage ##

[Pythonbrew](https://github.com/utahta/pythonbrew) takes virtualenv a lot
further, allowing for installation of various Python versions and management
more akin to the amazing RVM for Ruby.

Install pythonbrew as follows:

``` bash
curl -kL http://xrl.us/pythonbrewinstall | bash
echo "[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc" >> ~/.bashrc
source ~/.bashrc
```

Since pythonbrew will build Python from source, we need to be prepared:

``` bash
sudo apt-get install build-essential zlib1g-dev
```

Installing Python versions may be done as follows:

``` bash
pybrew install 2.7.3
```

It's a good idea to switch on verbose mode if you want to see what's going on:

``` bash
pybrew install --verbose 2.7.2
```

To view the newest Python version for each sub-version and get an idea what you
can install:

``` bash
pybrew list -k
```

Permanently switch to a Python version as follows:

``` bash
pybrew switch 2.7.2
```

Or temporarily switch to a Python version in the current session:

``` bash
pybrew use 2.7.3
```

Jump back to the system's Python version by using:

``` bash
pybrew off
```

You may also view all installed Python versions:

``` bash
pybrew list
```

Uninstall a version of Python as follows:

``` bash
pybrew uninstall 2.7.2
```

To upgrade pythonbrew to the newest version:

``` bash
pybrew update
```

You may run your Python script against all installed versions of Python using:

``` bash
pybrew py -v test.py
```

## Pythonbrew Environments Using Virtualenv ##

Pythonbrew can now use virtualenv to create environments.  Install virtualenv
for pythonbrew as follows:

``` bash
pybrew venv init
```

Creating a project:

``` bash
pybrew venv create proj
```

Much like RVM, projects are related to each version of Python that's installed.
Thus, you may have a project called "hello" twice, one against version 2.7.3
and one against 3.2.3 if you like.

List your projects

``` bash
pybrew venv list
```

To switch to a project, type:

``` bash
pybrew venv use proj
```

To de-activate the environment:

``` bash
deactivate
```

To delete an environment:

``` bash
pybrew venv delete proj
```

You may install packages using pip which is available independently for each
environment automatically.

## Pythonbrew Shortcomings ##

Pythonbrew has so much potential and could easily be as good as RVM, but there
are a few problems:

* [Lack of bash completion](https://github.com/utahta/pythonbrew/issues/91)
* [No auto-switching of profiles](https://github.com/utahta/pythonbrew/issues/48)
* [Lack of support for PyPy and Jython](https://github.com/utahta/pythonbrew/issues/32):
  Although there's a fork of the project
  ([pythonz](https://github.com/saghul/pythonz)) which adds this support, the
  fork is based on a very old version of pythonbrew.  PyPy is the future of
  Python and Jython is really handy when you need Java integration with Python,
  so this functionality would be great.
* Project abandoned?: Check out the
  [number of pull requests pending at Github](https://github.com/utahta/pythonbrew/pulls)
  (many of which are really useful).

If I have some spare time one day, I'll attempt to tackle these problems so
that us Python-heads can have all bells and whistles in this otherwise
excellent application.
