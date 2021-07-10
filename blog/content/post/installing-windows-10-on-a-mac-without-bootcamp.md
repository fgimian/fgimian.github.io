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

**Update (2016-07-20)**: I have updated this post with further improvements
relating to downloading of Boot Camp drivers and ensuring that a Hybrid MBR is
not used (which would cause issues when installing Windows).

## What You Will Need

* An 8 GB or larger USB stick
* A copy of the [Windows 10 ISO](https://www.microsoft.com/en-au/software-download/windows10ISO)
* A valid Windows 10 license
* A downloaded copy of [unetbootin](https://unetbootin.github.io/)

## Downloading Boot Camp Drivers

1. Start **Boot Camp Assistant**
2. Select **Action** / **Download Windows Support Software**
3. Choose your **Downloads** directory, enter your password and then click
   **Save**

This will be the only step that we will use Boot Camp Assistant for.

## Creating a Bootable USB Windows 10 Installer

### Formatting Your USB Stick

Attach your USB stick and start **Disk Utility**, select your USB drive in the
left panel under External, click **Erase** and set the options as follows
(exactly) and click **Erase**:

**Name**: FAT32  
**Format**: MS-DOS (FAT)  
**Scheme**: Master Boot Record

![](/img/installing-windows-10-on-a-mac-without-bootcamp/disk-utility-erase-disk.png)

### Turning Your USB Stick into a Windows Installer

Open **unetbootin**, enter your password, set the options as follows and
click **OK**:

**Diskimage**: checked, set to **ISO** and browse to your Windows 10 ISO  
**Type**: USB Drive  
**Drive**: Your USB drive (you should only see one entry here)

![](/img/installing-windows-10-on-a-mac-without-bootcamp/unetbootin.png)

If you see more than one drive listed, you may confirm which is your USB drive
by opening the **Terminal** and typing:

```bash
diskutil list FAT32
```

You'll see your USB drive in the output and it should look something like this:

```
/dev/disk2 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *16.0 GB    disk2
   1:                 DOS_FAT_32 FAT32                   16.0 GB    disk2s1
```

Once you have kicked off unetbootin, grab a snack while the Windows ISO is
copied to the USB stick. This process takes around 15 minutes to complete.

### Finishing Up

When this has completed, you may right click on the USB stick in Finder,
select **Rename "FAT32"** and rename it as you like (I'll call mine
"WINDOWS 10").

Finally, copy the **WindowsSupport** in your Downloads directory to
the Windows 10 USB stick so it's easy to get to after our installation.

## Partitioning Your Drive

In **Disk Utility**, select your internal hard drive on the left panel, and
click on **Partition**.

Click the **+** button and create a new partition of your desired size for your
Windows installation and name it as you wish (I'll call mine "BOOTCAMP").  Ensure that the **Format** is set to **MS-DOS (FAT)** and click on **Apply**.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/disk-utility-partition-disk.png)

## Ensuring that a Hybrid MBR is not used

Huge thanks to Rod's post from the superuser post titled
[Windows detects GPT disk as MBR in EFI boot](http://superuser.com/questions/508026/windows-detects-gpt-disk-as-mbr-in-efi-boot).

Once you add a FAT32 partition with either Boot Camp Assistant or Disk Utility,
your disk is converted into a hybrid GPT / MBR disk which is actually not
supported by newer versions of Windows.  In this step, we revert this
additional change made by Disk Utility by switching back to a pure GPT
partition table.

1. Dowload the latest version of
   [GPT fdisk](https://sourceforge.net/projects/gptfdisk/files/gptfdisk/)
   by browsing to the version, then **gdisk-binaries** and clicking the file
   with the ***.pkg** extension (e.g. gdisk-1.0.1.pkg).
2. Install GPT fdisk by running the installer you downloaded
3. Open a Terminal and check the state of your MBR

    ```bash
    sudo gdisk /dev/disk0
    ```

    If your MBR partition is set to **hybrid**, please continue with step 4,
    otherwise if it is set to **protective**, you may skip the rest of this
    section.  Simply type **q** and hit **return** to exit GPT fdisk.

4. Type **p** to view the existing partition table and verify you're working
   on the correct disk
5. Type **x** to enter the expert menu
6. Type **n** to create a fresh protective MBR
7. Type **w** to save your changes and confirm the change when asked
9. Type **q** to exit GPT fdisk
9. Run GPT fdisk to show your disk layout:

    ```bash
    sudo gdisk -l /dev/disk0
    ```

    Your partition table should look something like this:

    ```bash
    GPT fdisk (gdisk) version 1.0.1

    Warning: Devices opened with shared lock will not have their
    partition table automatically reloaded!
    Partition table scan:
      MBR: protective
      BSD: not present
      APM: not present
      GPT: present

    Found valid GPT with protective MBR; using GPT.
    ```

## Installing Windows

### Disconnecting All Devices From USB Ports

This step is critical as I have had rather serious problems during Windows
installation when certain external drives are connected.

Unplug everything from your Mac except your keyboard (if wired) and your
bootable Windows USB stick (which we prepared earlier).

If your Mac contains multiple physical drives, you will need to disconnect
all disks except the one which you intend to install Windows on or you may
encounter the following error:

> Windows could not prepare the computer to boot into the next phase of installation. To install Windows, restart the installation.

### Booting From the USB Stick

Ensure that the USB stick containing the Windows installer is inserted and
then restart your Mac while holding down the **option (alt)** key.

You should now be presented with a list of bootable drives. Select the USB
drive (usually titled "EFI Boot") to begin installing Windows.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/boot-select-device.png)

### Correcting Your Windows Hard Disk Partition

When you are asked **Where do you want to install Windows?**, select the
Windows partition created earlier (which I called "BOOTCAMP") and click
**Delete**.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/windows-install-partition-delete.png)

Next, select the chunk of **Unallocated Space** and click on **New** to create
a proper Windows NTFS partition.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/windows-install-partition-new.png)

**Note**: OS X only supports creation of FAT filesystems, so this is why we need
to re-create the partition ourselves during install.

### Completing the Installation

Allow the installer to complete and boot into Windows.

### Installing Boot Camp Support Software

Once Windows is up and running, install the Boot Camp Support software running
**WindowsSupport/BootCamp/Setup.exe** on your USB stick.

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

## What You Will Need to Configure Windows

* The latest version of [SharpKeys](https://sharpkeys.codeplex.com/)
* The [flipflop-windows-sheel binary](https://github.com/jamie-pate/flipflop-windows-wheel) (see README for a download link)

## Configuring Windows

### Mapping Your Mac Keyboard

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

### Switching to Natural Scrolling

If you wish to flip scrolling direction to match that on OS X, run
**FlipWheel.exe** and then click on **Flip All**.

![](/img/installing-windows-10-on-a-mac-without-bootcamp/flipwheel-configuration.png)

### Enabling Num Lock on Boot

Paste the following into a file named **Enable NumLock on Boot.reg** then
import this into the registry to enable NumLock when Windows boots up
(it doesn't by default).

```
Windows Registry Editor Version 5.00

[HKEY_USERS\.DEFAULT\Control Panel\Keyboard]
"InitialKeyboardIndicators"="80000002"
```

### Completing Configuration

That's it, give your machine one last reboot and you'll have a fully working
Windows 10 installation.

**Note**: I have found Apple's Magic Mouse to be extremely unreliable using
the Boot Camp drivers from Apple.  As such, I recommend purchasing a Logitech
(or similar) mouse for use in Windows.  I have no trouble plugging the
wireless receiver for my Logitech mouse into one of the USB ports of my wired
Apple Keyboard and it's so tiny that you can't see it at all.

## Cleaning up a Windows Installation

### Removing the Windows Partitions

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

### Removing the Boot Entry

Even though we have removed the Windows partition, a boot entry will still be
present when holding down **option (alt)** during boot.

You may remove these items by running the following in your **Terminal**:

```bash
sudo mkdir /Volumes/EFI
sudo mount -t msdos /dev/disk0s1 /Volumes/EFI
sudo rm -rfv /Volumes/EFI/EFI/Boot /Volumes/EFI/EFI/Microsoft
sudo umount /Volumes/EFI
```
