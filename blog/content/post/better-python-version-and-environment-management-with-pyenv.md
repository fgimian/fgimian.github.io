---
title: Better Python version and environment management with pyenv
date: 2014-04-20T09:27:00+10:00
---

In the
[Setting up Virtual Development Environments for Python](/blog/2012/12/08/setting-up-virtual-development-environments-for-python/)
post, we discussed the use of
[pythonbrew](https://github.com/utahta/pythonbrew) for managing Python versions
and their related virtualenvs.  If you do enjoy pythonbrew, then be sure to
check out [pythonz](https://github.com/saghul/pythonz) which is now the active
fork of the original project and has resolved almost all issues that I had
originally reported.

However, there is another alternative called
[pyenv](https://github.com/yyuu/pyenv) which has several significant
advantages.  Probably one of the biggest is the fact that pyenv doesn't depend
on Python 2.6+ to be installed.  Many OSs (e.g. SLES 10 and CentOS 5) come with
Python 2.4 pre-installed.  In addition, pyenv implements automatic switching of
Python version or virtualenv based on the directory you're in.

So let's get started!

If you're using **CentOS**, install all build dependencies as follows:

Firstly, ensure you install EPEL if you're on CentOS 5.x:

```bash
curl -O http://mirror.iprimus.com.au/epel/5/i386/epel-release-5-4.noarch.rpm
rpm -Uvh epel-release-5-4.noarch.rpm
```

Now install the build dependencies:

```bash
sudo yum install git gcc zlib-devel bzip2-devel readline-devel sqlite-devel openssl-devel
```

If you're using **Ubuntu Server**, install all build dependencies like this:

```bash
sudo apt-get install curl git-core gcc make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libssl-dev
```

Now install pyenv as a regular user:

```bash
curl -L https://raw.github.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
```

Once installation completes, you'll be presented with some code that should be
added to your **~/.bashrc** file:

```bash
export PYENV_ROOT="${HOME}/.pyenv"

if [ -d "${PYENV_ROOT}" ]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
fi
```

Simply add this code to the end of your ~/.bashrc and then source your profile
to have these additions loaded.

On **CentOS**:

```bash
source ~/.bash_profile
```

On **Ubuntu Server**:

```bash
source ~/.profile
```

**Note**: pyenv fully supports bash completion, so be sure to use your tab key
when typing commands to help auto-complete them.

To list all available Python versions, use:

```bash
pyenv install -l
```

To install a Python version, use:

```bash
pyenv install <version>
```

e.g.

```bash
pyenv install 2.7.6
```

To list the installed Python versions, use:

```bash
pyenv versions
```

**Note**: Virtual environments will also show up as versions after they're
added.

To set the global Python version used for your account, use:

```bash
pyenv global <version>
```

Creating virtualenvs is also easy and extremely well integrated into pyenv:

```bash
pyenv virtualenv <name>
```

You may activate and de-activate virtualenvs using:

```bash
pyenv activate <name>
pyenv deactivate
```

To see all the virtualenvs you have created, you may use:

```bash
pyenv virtualenvs
```

OK here comes the great part.  Suppose we're working on a project which we know
always uses a virtualenv called **project123**.  While in the root of the
project directory, you may set the appropriate Python environment that should
always be used while in the project directory.

```bash
pyenv local <virtualenv or version>
```

Now each time you enter this directory, the chosen virtualenv or Python version
will be activated automatically!  The file that is creatied and specifies the
appropriate environment is named **.python-version** and should be added to
your repository.

At any time, you may view the Python environment being used:

```bash
pyenv version
```

Finally, you can remove a Python version or virtualenv using the uninstall
commend:

```bash
pyenv uninstall <virtualenv or version>
```

Let's walk through an entire example using my
[Flaskage](https://github.com/fgimian/flaskage) project.

```bash
pyenv install 2.7.6
pyenv global 2.7.6
pyenv virtualenv flaskage
cd flaskage/
pyenv local flaskage
pip install -r requirements.txt
git add .python-version
```

This is definitely the way I'll be managing my Python environment from now on
as it's definitely the most elegant solution I have found to date.  Enjoy! :)
