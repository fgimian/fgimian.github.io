---
title: Setting up Samba on a Ubuntu VM for use With Sublime Text on a Windows Host
date: 2013-01-02T13:04:00+11:00
---

Windows is my desktop OS of choice and until now I have used either
[WinSCP](http://winscp.net/) or [FlashFXP](http://www.flashfxp.com/)
(amazing FTP client by the way) to edit files remotely on any Ubuntu VMs I
connect to.

I recently decided to start using a Samba share instead.  In case you're
unaware, Samba allows Linux distros to create Windows shares which allow one to
directly access the Unix filesystem in Windows.

## Installing & Configuring Samba or Your Ubuntu VM

To begin, install Samba on your VM:

```bash
sudo apt-get install samba
```

Now you'll just have to add a few lines to the Samba configuration file
**/etc/samba/smb.conf** to make everything work:

```cfg
[global]
   ...
# The following property ensures that existing files do not have their
# permissions reset to the "create mask" (defined below) if they are changed
   map archive = no

# Notify upon file changes so that Windows can detect such changes
   change notify = yes

[fots]
   comment = Fotsies Files
   path = /home/fots
   guest ok = no
   browseable = yes
   writable = yes
   create mask = 0664
   directory mask = 0775
```

The last step to get everything working is to add a Samba user and password
identical to your Linux user account:

```bash
sudo smbpasswd fots
```

On some operating systems, you may need to explicitly create the account as
follows:

```bash
sudo smbpasswd -a fots
```

And then restart Samba so that the config can be re-read:

```bash
sudo service smbd restart
```

Your Windows host should now have access to the share via the following UNC
path **\\\\\\\<ip-address>\fots** (e.g. **\\\\\\192.168.172.101\fots**).

## Setting up the Share on your Windows host

I suggest mounting the share to a drive letter so that Sublime Text can add it
as part of a project.

The following instructions are for Windows 8. Windows 7 users should find the
equivalent option under the **Organise** menu.

1. Open **Computer** (Start + E)
2. Select **Computer** / **Map network drive** / **Map network drive**
3. Select any drive letter you wish and place the UNC path in the **Folder**
   field
4. Enter your credentials and click **Finish**

Now to add the directory to your workspace in Sublime Text, simply follow the
steps below:

1. Choose **Project** / **Add Folder to Project**
2. Browse to the project directory on the drive you just mounted via UNC

And the result? ...

![](/img/setting-up-samba-on-a-ubuntu-vm-for-use-with-sublime-text/sublime-text-samba.png)

YAY! Now we can get some work done with ease :)
