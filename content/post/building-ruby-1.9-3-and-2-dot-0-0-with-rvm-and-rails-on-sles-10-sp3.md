---
title: Building Ruby 1.9.3 and 2.0.0 with RVM and Rails on SLES 10 SP3
date: 2013-05-12T06:18:00+10:00
---

Oh did you say more software builds for SLES 10?  Ok then!  In this post, we
build the much more challenging [Ruby](http://www.ruby-lang.org/en/) 1.9.3
(and the latest 2.0.0) with [RVM](https://rvm.io/) and then we install
[Rails](http://rubyonrails.org/).  Ruby was particularly troublesome, but the
procedure below should get you through unscathed.

First, install the Ruby build dependencies provided by SLES:

``` bash
sudo zypper -n install gcc
sudo zypper -n install sqlite-devel gdbm-devel zlib-devel openssl-devel ncurses-devel readline-devel
sudo zypper -n install tk-devel tcl-devel xorg-x11-devel
sudo zypper -n install bison
```

Build bash 4.2 (required by the RVM installer):

``` bash
wget http://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz
tar xvfz bash-4.2.tar.gz
cd bash-4.2/
./configure
make
sudo make install
cd ..
rm -rfv bash-4.2/
```

Build [LibYAML](http://pyyaml.org/wiki/LibYAML) (required to build Ruby):

``` bash
wget http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz
tar xvfz yaml-0.1.4.tar.gz
cd yaml-0.1.4/
./configure
make
sudo make install
sudo /sbin/ldconfig -v
cd ..
rm -rfv yaml-0.1.4/
```

Build [libffi](http://sourceware.org/libffi/) (required to build Ruby):

``` bash
wget ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz
tar xvfz libffi-3.0.13.tar.gz
cd libffi-3.0.13/
./configure
make
sudo make install
sudo /sbin/ldconfig -v
cd ..
sudo mv -v /usr/local/lib/libffi-3.0.13/include/* /usr/local/include/
sudo rm -rfv /usr/local/lib/libffi-3.0.13/
rm -rfv libffi-3.0.13/
```

Install the required certs to avoid curl complaining during the RVM install:

``` bash
sudo mv -iv /usr/share/curl/curl-ca-bundle.crt /usr/share/curl/curl-ca-bundle.crt.bak
wget http://curl.haxx.se/ca/cacert.pem
sudo bash -c 'cat cacert.pem /usr/share/curl/curl-ca-bundle.crt.bak > /usr/share/curl/curl-ca-bundle.crt'
rm -v cacert.pem
```

Now, install RVM (ensuring that only the SLES default ~/.profile is used):

``` bash
curl -L get.rvm.io | bash -s stable
cat ~/.bash_profile >> ~/.profile
rm -v ~/.bash_profile
source ~/.profile
```

Disable RVM OS library package management (RVM doesn't support SLES):

``` bash
rvm autolibs 0
```

Now build and install Ruby using RVM:

``` bash
rvm install 1.9.3
rvm install 2.0.0
```

You may use whichever version you please:

``` bash
rvm use 1.9.3
```

And finally, install Rails if you like (you must explicitly install rdoc first
to avoid the "File not found: lib" error after Rails installs):

``` bash
gem install rdoc
gem install rails
```

And there you have it, SLES 10 running the latest Ruby and Rails, yay! :)
