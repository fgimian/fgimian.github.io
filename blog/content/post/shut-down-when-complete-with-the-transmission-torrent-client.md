---
title: Shut Down When Complete with the Transmission Torrent Client
date: 2013-05-12T05:33:00+10:00
---

Hey guys, I recently got this little missing feature working in Transmission.
The following procedure will make your Mac automatically shut down when all
downloads complete.  Linux will be similar except that the shut down command
will differ in the script :)

The following procedure depends on the Transmission API, so be sure turn on the
web admin interface under **Remote** in the Transmission preferences, listening
on (default) port 9091.

Now, create a virtualenv and install **transmissionrpc**:

(Naturally, you'll need to install virtualenv first.  I did this using a
Homebrew install of Python and then simply running pip install virtualenv).

```bash
cd ~
virtualenv .transmission_env
source .transmission_env/bin/activate
pip install transmissionrpc
deactivate
```

**Tip**: Don't create your virtualenv in a directory with spaces, I tried :)

Create the Shut Down script:

```
mkdir ~/Library/Application\ Support/Transmission/Scripts/
vi "Shut Down"
```

Script Contents (update the first line with your username):

```python
#!/Users/fots/.transmission_env/bin/python

import subprocess

import transmissionrpc
from transmissionrpc.error import TransmissionError


def main():
    all_done = True
    try:
        tc = transmissionrpc.Client('localhost', port=9091)
        for torrent in tc.get_torrents():
            if torrent.status == 'downloading':
                all_done = False
                break
        if all_done:
            subprocess.call(['osascript', '-e',
                             'tell application "Finder" to shut down'])
    except TransmissionError:
        pass

if __name__ == "__main__":
    main()
```

Configure Transmission to close without prompting when downloads are complete:

Under **Preferences** / **General**, tick **Quit with active transfers** and
**Only when transfers are downloading** just below it, or alternatively un-tick
both these check boxes:

![](/img/shut-down-when-complete-with-the-transmission-torrent-client/transmission-shutdown-setup-1.png)

Finally, setup the script to run when downloads complete:

Under **Preferences** / **Transfers** / **Management**, tick
**When download completes** and browse to the location of your script.  If you
can't see the Library directory, you may use **Cmd+Shift+G** and enter the path
**~/Library/Application Support/Transmission/Scripts/** to get there.

![](/img/shut-down-when-complete-with-the-transmission-torrent-client/transmission-shutdown-setup-2.png)

Enjoy! :)
