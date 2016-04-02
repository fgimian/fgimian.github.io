---
title: Making Windows 8 Work on Your Desktop
date: 2012-10-21T19:34:00+11:00
---

Well, it's almost here folks!  Windows 8 arrives this Friday and many people
are nervous.  I was too the first time I used it; in fact, I hated it!  But
things have changed significantly for me now. I'm currently running Windows 8
Pro RTM (via MSDN) as my main OS and couldn't be happier.  I'd go as far as to
say that I couldn't see myself going back to or missing Windows 7 in the future
at all.

The biggest issue for most people will be the omission of the traditional
Start menu and the addition of a completely new and somewhat oddly fitted
Modern UI which only really makes sense on a tablet.  Even so, I highly suggest
that you try working with the new UI as I will outline below before looking at
Start menu add-on software (which we'll touch on too).

## What are These Tablet Apps Doing on my Desktop?

That's a really good question, and it's really obvious that Microsoft are
force-feeding everyone these apps.  Default file associations push you over
to Modern UI apps and you are booted into the Modern UI without any currently
known built-in method of disabling this.

I will be the first to say that I dislike Modern UI apps on a desktop computer.
Multitasking is severely impaired, the workflow is far too different from
traditional applications and the mouse gestures suck.

### Removing the Modern UI Apps

Right click on each application and click on **Uninstall**.  Be sure you've
uninstall everything by hitting **Ctrl + Tab** to view the **Apps** screen,
and uninstall the rest.  Be sure to leave **Store**, **Internet Explorer** and
**Desktop** alone as they won't get in your way and could be useful later on.

### Disable Notifications

1. Hit **Start + W**, type **notifications** and select **Notifications** on
   the very left
2. Set **Show app notifications** to **Off**

![](/images/making-windows-8-work-on-your-desktop/disable-notifications.png)

## My Fonts Look Big & Weird Man

It seems that Microsoft is attempting to cater for the higher resolutions
available by upping the default DPI in Windows 8, though this doesn't exactly
translate seamlessly to many apps.  It actually leaves Windows looking and
feeling rather strange.

To revert the DPI back to the normal 100%, follow the steps below:

1. Hit **Start + W**, type **dpi** and select **Make text and other items
   larger or smaller**
2. Set the value to **Smaller - 100%** and click **Apply**

![](/images/making-windows-8-work-on-your-desktop/dpi-normal.png)

## Make the Modern UI Your New Start Menu

Your Modern UI Start screen should be looking pretty empty and neat now, so
it's time to start making it useful.

![](/images/making-windows-8-work-on-your-desktop/start-menu-system-favourites.png)

* **Computer**: Open Explorer using **Start + E**, right click on **Computer**
  in the left panel and click on **Pin to Start**
* **Recycle Bin**: Hit **Start + D** to view the desktop, right click on
  **Recycle Bin** and click on **Pin to Start**
* **Control Panel**: Hit **Start** and search for **control**, right click on
  **Control Panel** and then **Pin to Start**
* **Screen Resolution**: This is one of my favourite shortcuts which was added
  using instructions at the awesome
  [Seven Forums](http://www.sevenforums.com/tutorials/24008-screen-resolution-shortcut-create.html)
  website.  All you'll need to do is download or create the shortcut anywhere
  on your hard disk, then right click and select **Pin to Start**.  You may
  then delete the shortcut from the location you created it.
* **Favourite Folders**: Simple browse to these folders in Explorer, right
  click and select **Pin to Start**. Of course, the Dropbox shortcut will be
  created for you when you install the Dropbox application.

To create the **Shut Down** & **Restart** buttons:

1. Grab some good looking icons for your shortcut.  I really love the
   [I like buttons 3a](http://mazenl77.deviantart.com/gallery/?q=i+like#/d1vcljn)
   set by [MazeNL77](http://mazenl77.deviantart.com/).
2. We'll need to have the icons in the ICO format, so use a website such as
   [Converticon](http://converticon.com/) to convert them to this format.
3. Rename the resulting files (if you wish) and place them in **C:\Windows**
   (or similar).
4. Create or download Restart and Shut Down shortcuts using a guide such as the
   ones at the Seven Forums.  Here are the links to the
   [Restart](http://www.sevenforums.com/tutorials/61284-restart-computer-shortcut-create.html)
   and
   [Shut Down](http://www.sevenforums.com/tutorials/61294-shut-down-computer-shortcut-create.html)
   shortcut tutorials.
5. Right click on each of the created shortcuts, select **Properties**, then
   **Shortcut** and then click **Change Icon**.  Browse to the appropriate icon
   you created then click **OK**.
6. Right click on the shortcut and select **Pin to Start**.
7. You may then delete the shortcut from the location you created it.

Here are some others I know many people will want on their Start screen:

* **Devices and Printers**: Hit **Start + W**, type **devices**, right click on
  **Devices and Printers** and then **Pin to Start**
* **Default Programs**: Hit **Start**, type **default**, right click on
  **Default Programs** and then **Pin to Start**
* **Run**: Similar to the Screen Resolution example above, check out the
  [Seven Forums](http://www.sevenforums.com/tutorials/21246-run-command-create-shortcut.html)
  to learn how to do this

## Right Click Your Way to Power

Another handy feature in Windows 8 is the **Win + X** shortcut which can also
be accessed by right-clicking on the bottom left of the screen.

![](/images/making-windows-8-work-on-your-desktop/right-click-start-menu.png)

This gives you access to some commonly used power user shortcuts.

## Grouping & Organising Applications

In the past, I would work in the following way to launch my applications in
Windows 7:

* My most commonly used applications would sit in my Windows Superbar (the
  taskbar at the bottom of the screen)
* All other applications would have desktop shortcuts and be grouped into
  categorised with the use of Stardock's excellent
  [Fences](http://www.stardock.com/products/fences/) application
* The Start menu would rarely be used to launch applications as it required
  more clicks than I thought was necessary

This workflow worked reasonably well, although I would always have to hit
**Ctrl + D** to get to the desktop if I wanted one of the less used
applications which would break my workflow a little.  In addition, my desktop
was very busy.

The Windows 8 Modern UI is (in my opinion) actually superior to my previous
solution as it is always one click away (Start button), doesn't clutter my
desktop or get in the way of my current work and doesn't require the use of
any third party applications.

Here's a sample of many of my grouped applications:

![](/images/making-windows-8-work-on-your-desktop/start-menu-group-display.png)

Placing your shortcuts in groups is a simple matter of drag & drop.

You may name the group as follows:

1. Hit the **Start** key
2. Click on the very bottom right of the screen
3. Right click on a group and select **Name group**

## But ... Where's My Start Menu? :')

I honestly encourage you to try the workflow above for a little while before
looking into a 3rd party solution to provide you a Start menu.  However, if you
feel that you absolutely must have your Start menu back, then I recommend you
check out Stardock's [Start8](http://www.stardock.com/products/start8/)
application.

I highly recommend avoiding ViStart as it's riddled with adware.  A lot of
people seem to like [Classic Shell](http://classicshell.sourceforge.net/) but
I failed to see the appeal myself.

## Windows 8 My Desktop

I hope you've found this little guide handy.  With the great improvements to
Explorer, native ISO mounting, built-in Hyper-V (even though I still prefer
VMware) and other under-the-hood improvements, it's well worth giving Windows 8
a good chance.
