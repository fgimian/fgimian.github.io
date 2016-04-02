---
title: Building Python 2.7.4 on SLES 10 SP3
date: 2013-05-12T06:07:00+10:00
---

In this post, we'll be building the latest revision of
[Python](http://www.python.org/) 2.7 on SLES 10 SP3.  Please note that this
procedure may also work on other versions of SLES and OpenSUSE too.

First, install the Python build dependencies:

```bash
sudo zypper -n install gcc
sudo zypper -n install sqlite-devel gdbm-devel zlib-devel openssl-devel ncurses-devel readline-devel
sudo zypper -n install tk-devel tcl-devel xorg-x11-devel
```

Download and extract Python:

```bash
wget http://www.python.org/ftp/python/2.7.4/Python-2.7.4.tgz
tar xvfz Python-2.7.4.tgz
cd Python-2.7.4/
```

Patch the sqlite module to work correctly with the sqlite libraries on SLES:

```bash
sed -i 's/sqlite3_int64/sqlite_int64/' ./Modules/_sqlite/*
```

Build Python with shared libraries (shared libraries ensure that Python works
correctly with libraries like [rubypython](http://rubypython.rubyforge.org/)):

```bash
./configure --enable-shared
make
```

The following output is expected as the remaining modules are all pretty much
useless and deprecated as per the official documentation:

```
Python build finished, but the necessary bits to build these modules were not found:
_bsddb             bsddb185           dl
imageop            sunaudiodev
To find the necessary bits, look in setup.py in detect_modules() for the module's name.
```

Finally, install Python to **/usr/local**:

```bash
sudo make install
```

Update the available libraries in the OS (so that the newly created libpython
is available):

```bash
sudo /sbin/ldconfig -v
```

Clean up:

```bash
cd ..
rm -rfv Python-2.7.4
```

Install easy install (I could only get this working reliably by switching to
root):

```bash
sudo su -
wget http://peak.telecommunity.com/dist/ez_setup.py
python ez_setup.py
rm -v ez_setup.py
```

Now install pip and distribute:

```bash
easy_install pip
pip install distribute
```

Drop out of root:

```bash
exit
```

Hope this helps! :)
