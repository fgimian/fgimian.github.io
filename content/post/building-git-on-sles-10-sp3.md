---
title: Building Git on SLES 10 SP3
date: 2013-05-12T06:31:00+10:00
---

Let's keep the builds going shall we?  This is the last one for today though :)
This time, we're going to build the latest version of essential tool
[Git](http://git-scm.com/) on SLES 10.

**Important**: In order for the steps to work below, you must build and install
Python 2.7 as per
[my earlier post](/blog/2013/05/12/building-python-2-dot-7-4-on-sles-10-sp3/).

Build Git as follows (ensuring that you explicitly set the Python path with the
configure command):

```bash
wget https://git-core.googlecode.com/files/git-1.8.2.3.tar.gz
tar xvfz git-1.8.2.3.tar.gz
cd git-1.8.2.3/
./configure --with-python=/usr/local/bin/python
make
sudo make install
cd ..
rm -rfv git-1.8.2.3/
```

And that's it, easy wasn't it?  Hope this helps someone out there! :)
