---
title: Building an RPM of the Latest OpenSSH on SLES 10 SP3
date: 2013-05-12T08:45:00+10:00
---

Several years ago, we needed a newer version of OpenSSH on a system we were
building with SLES 10 to enable jailrooting of user accounts.  In this post,
we're going to be building an RPM of the latest OpenSSH for SLES 10 SP3 (and
similar) servers.

Install the required packages to build OpenSSH as follows:

```bash
sudo zypper -n install gcc
sudo zypper -n install tcpd-devel zlib-devel openssl-devel pam-devel
```

Grab the current OpenSSH source:

```bash
cd /usr/src/packages/SOURCES/
wget http://mirror.aarnet.edu.au/pub/OpenBSD/OpenSSH/portable/openssh-6.2p1.tar.gz
```

Extract the OpenSSH spec from the archive:

```bash
tar zxvf openssh-6.2p1.tar.gz --strip 3 -C /usr/src/packages/SPECS/ openssh-6.2p1/contrib/suse/openssh.spec
```

Update the spec to skip x11 askpass functionality (which we don't need in a
server build without a GUI):

```bash
sed "s/\(%define build_x11_askpass.*\)1$/\10/" /usr/src/packages/SPECS/openssh.spec > /usr/src/packages/SPECS/openssh.spec.tmp
mv /usr/src/packages/SPECS/openssh.spec.tmp /usr/src/packages/SPECS/openssh.spec
```

Now build the RPM:

```bash
rpmbuild -bb /usr/src/packages/SPECS/openssh.spec
```

Ensure the build ends successfully:

```
...
+ umask 022
+ cd /usr/src/packages/BUILD
+ cd openssh-6.2p1
+ rm -rf /var/tmp/openssh-6.2p1-buildroot
+ exit 0
```

And finally you should have a new RPM under **/usr/src/packages/RPMS/x86_64/**:

```bash
fots@fotsies-sles-testlab:/usr/src/packages/SOURCES> ls -l /usr/src/packages/RPMS/x86_64/
total 965
-rw-r--r-- 1 fots users 984924 2013-05-12 20:11 openssh-6.2p1-1.x86_64.rpm
```

All the best! :)
