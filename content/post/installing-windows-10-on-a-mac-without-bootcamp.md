---
title: Installing Windows 10 on a Mac without Bootcamp
date: 2016-03-12T18:34:00+11:00
---

Installing Windows on a Mac should be a piece of cake with Bootcamp, but that 
rarely is the case.  In fact, I would personally say that Boot Camp Assistant
is one of the worst apps that comes with OS X and unlike the rest, it doesn't
work seamlessly.

A few of its drawbacks:

* It only supports a drive with a single partition.
* It often throws very obscure error messages with limited detail.
* It re-downloads 1.6 GB Windows drivers every single time it runs.  These are 
  placed under `/Library/Application Support/BootCamp/WindowsSupport.dmg` and 
  deleted and re-downloaded each time Boot Camp Assistant starts processing.

This post did take a lot of work to complie and I did bone my hard drive a
few times while trying certain ideas, so please throw out a thanks if it
helped you out :)

**Disclaimer**: This guide below contains procedures which can potentially 
destroy your partitions and data.  I accept no responsibility for such loss so 
please proceed at your own risk.

# What You Will Need #

* An 8 GB or larger USB stick
* A copy of the [Windows 10 ISO](https://www.microsoft.com/en-au/software-download/windows10ISO)
* A valid Windows 10 license
* A downloaded copy of [unetbootin](https://unetbootin.github.io/)
* The latest version of [Boot Camp Support Software 6.0](http://swcdn.apple.com/content/downloads/10/60/031-30899/6u2bha6n3pckjca1j44jw9m28yq72nh6li/AppleBcUpdate.exe) (link courtesy of [this reddit post](https://www.reddit.com/r/apple/comments/3h7zj1/bootcamp_6_download_link/))

# Creating a Bootable USB Windows 10 Installer #

## Formatting Your USB Stick ##

Attach your USB stick and start **Disk Utility**, select your USB drive in the 
left panel under External, click **Erase** and set the options as follows
(exactly) and click **Erase**:

**Name**: FAT32  
**Format**: MS-DOS (FAT)  
**Scheme**: Master Boot Record

![](/img/installing-windows-10-on-a-mac-without-bootcamp/disk-utility-erase-disk.png)

## Turning Your USB Stick into a Windows Installer ##

Open **unetbootin**, enter your password, set the options as follows and 
click **OK**:

**Diskimage**: checked, set to **ISO** and browse to your Windows 10 ISO  
**Type**: USB Drive  
**Drive**: Your USB drive (you should only see one entry here)

![](/img/installing-windows-10-on-a-mac-without-bootcamp/unetbootin.png)

If you see more than one drive listed, you may confirm which is your USB drive 
by opening the **Terminal** and typing:

```bash
diskutil list
```

You'll see your USB drive as part of the output and it should look something
like this:

```
/dev/disk2 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *16.0 GB    disk2
   1:                 DOS_FAT_32 FAT32                   16.0 GB    disk2s1
```

Once you have kicked off unetbootin, grab a snack while the Windows ISO is 
copied to the USB stick. This process takes around 15 minutes to complete.

## Finishing Up ##

When this has completed, you may right click on the USB stick in Finder,
select **Rename "FAT32"** and rename it as you like (I'll call mine
"WINDOWS 10").

Finally, copy the Boot Camp Support Software (AppleBcUpdate.exe) to the
Windows 10 USB stick so it's easy to get to after our installation.

# Partitioning Your Drive #

In **Disk Utility**, select your internal hard drive on the left panel, and
click on **Partition**.

Click the **+** button and create a new partition of your desired size for your
Windows installation and name it as you wish (I'll call mine "BOOTCAMP").  Ensure that the **Format** is set to **MS-DOS (FAT)** and click on **Apply**.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/disk-utility-partition-disk.png)

# Installing Windows #

## Booting from the USB Stick ##

Ensure that the USB stick containing the Windows installer is inserted and 
then restart your Mac while holding down the **option (alt)** key.

You should now be presented with a list of bootable drives. Select the USB 
drive (usually titled "EFI Boot") to begin installing Windows.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/boot-select-device.png)

## Correcting Your Windows Hard Disk Partition ##

When you are asked **Where do you want to install Windows?**, select the 
Windows partition created earlier (which I called "BOOTCAMP") and click
**Delete**.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/windows-install-partition-delete.png)

Next, select the chunk of **Unallocated Space** and click on **New** to create 
a proper Windows NTFS partition.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/windows-install-partition-new.png)

**Note**: OS X only supports creation of FAT filesystems, so this is why we need
to re-create the partition ourselves during install.

## Completing the Installation ##

Allow the installer to complete and boot into Windows.

## Installing Boot Camp Support Software ##

Once Windows is up and running, install the Boot Camp Support software (by 
running AppleBcUpdate.exe from your USB stick).

**Note**: The installer takes a little while to show up, so please be patient.

You may encounter a known issue whereby the Boot Camp Support Software 
installer locks up while installing Realtek audio.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/bootcamp-installer-realtek-freeze.png)

If this occurs, you will need to open **Task Manager** and kill the
**RealtekSetup.exe** process.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/bootcamp-installer-realtek-end-process.png)

After the installer has completed, answer **No** when prompted to reboot
and install the Realtek drivers manually by running
**%USERPROFILE%\AppData\Local\Temp\RarSFX0\BootCamp\Drivers\RealTek\RealtekSetup.exe**.
If you can't find this file, check any other directories starting with
**RARSFX** under **%USERPROFILE%\AppData\Local\Temp**.

Once complete, reboot Windows.

# What You Will Need to Configure Windows #

* The latest version of [SharpKeys](https://sharpkeys.codeplex.com/)
* The [flipflop-windows-sheel binary](https://github.com/jamie-pate/flipflop-windows-wheel) (see README for a download link)

# Configuring Windows #

## Mapping Your Mac Keyboard ##

Install and run **SharpKeys** and then configure the following mappings to 
correct your Mac keyboard so that it behaves like a regular Windows keyboard:

Function: F13 -> Special: PrtSc  
Special: Left Alt => Special: Left Windows  
Special: Left Windows => Special: Left Alt  
Special: Right Alt => Special: Right Windows  
Special: Right Windows => Special: Right Alt  

![](/img/installing-windows-10-on-a-mac-without-bootcamp/sharpkeys-configuration.png)

**Note**: for F13, you'll need to select **Press a key** and click F13 on your 
keyboard.

## Switching to Natural Scrolling ##

If you wish to flip scrolling direction to match that on OS X, run
**FlipWheel.exe** and then click on **Flip All**.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/flipwheel-configuration.png)

## Enabling Scroll Lock on Boot ##

Paste the following into a file named **Enable NumLock on Boot.reg** then 
import this into the registry to enable NumLock when Windows boots up 
(it doesn't by default).

```
Windows Registry Editor Version 5.00

[HKEY_USERS\.DEFAULT\Control Panel\Keyboard]
"InitialKeyboardIndicators"="80000002"
```

## Completing Configuration ##

That's it, give your machine one last reboot and you'll have a fully working 
Windows 10 installation.

**Note**: I have found Apple's Magic Mouse to be extremely unreliable using 
the Boot Camp drivers from Apple.  As such, I recommend purchasing a Logitech
(or similar) mouse for use in Windows.  I have no trouble plugging the 
wireless receiver for my Logitech mouse into one of the USB ports of my wired
Apple Keyboard and it's so tiny that you can't see it at all.

# Cleaning up a Windows Installation #

## Removing the Windows Partitions ##

If you decide to remove Windows, you may find that Disk Utility doesn't allow 
you to delete the two partitions that have been created by the Windows 
installer.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/disk-utility-delete-partitions.png)

This happens due to the fact that the first small partition created is of a 
type called **Microsoft Reserved** which OS X's Disk Utility doesn't support.

The safest way to delete these partitions is through the Windows installer.  So
simply boot from your USB stick as we did before and when you reach the
**Where do you want to install Windows?** question, you may delete your 
"BOOTCAMP" partition and the small 16 MB partition of type **MSR (Reserved)**  
just above the BOOTCAMP partition.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/windows-install-partition-clean.png)

Once done, simply quit the installer by clicking the X in the top right corner
of each Window and reboot back into OS X.

## Removing the Boot Entry ##

Even though we have removed the Windows partition, a boot entry will still be 
present when holding down **option (alt)** during boot.

You may remove these items by running the following in your **Terminal**:

```bash
sudo mkdir /Volumes/EFI
sudo mount -t msdos /dev/disk0s1 /Volumes/EFI
sudo rm -rfv /Volumes/EFI/EFI/Boot /Volumes/EFI/EFI/Microsoft
sudo umount /Volumes/EFI
```
