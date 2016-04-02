---
title: Headless Browser Testing with Chrome & Firefox
date: 2014-04-06T21:38:00+10:00
---

When utilising [Selenium](http://docs.seleniumhq.org/) to test web
applications, I was always under the impression that
[PhantomJS](http://phantomjs.org/) was the only option for servers without an
X server.  I have nothing but good things to say about PhantomJS and have used
it successfully for testing in the past.  However, while working on some pull
requests for [splinter](https://github.com/cobrateam/splinter) recently, I
discovered that Chrome and Firefox can also be configured to do the same thing.

To begin with, download the
[Google Chrome debian package](https://www.google.com/intl/en/chrome/browser/?platform=linux)
using a regular PC and upload it to your server.

Install Chrome as follows:

``` bash
sudo apt-get install xdg-utils
sudo dpkg -i google-chrome-stable_current_amd64.deb
```

In addition to Chrome, you'll also need the
[Chrome Driver](https://code.google.com/p/selenium/wiki/ChromeDriver).
Download this on a regular PC and upload the zip file to your server.

Now extract it to /usr/bin and set appropriate permissions:

``` bash
sudo unzip chromedriver_linux64.zip -d /usr/bin/
sudo chmod 755 /usr/bin/chromedriver
```

Next up, we'll install Firefox:

``` bash
sudo apt-get install firefox
```

To make use of a regular browser in Selenium sessions, we need to install the
[X Virtual Framebuffer](http://en.wikipedia.org/wiki/Xvfb) and related fonts:

``` bash
sudo apt-get install xvfb x11-xkb-utils 
sudo apt-get install xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic
```

Now that everything's installed, you may start up a virtual display.  Each
virtual display has a number.  I'll use display number 99 below to setup our
example display.

``` bash
Xvfb :99 &
export DISPLAY=:99
```

An even better way of starting and stopping an xvfb session in your Python code
is with the use of [xvfbwrapper](https://github.com/cgoldberg/xvfbwrapper).

Install it as follows in your virtualenv:

``` bash
pip install xvfbwrapper
```

And here's some sample code to get you started:

``` python
from xvfbwrapper import Xvfb

def main():
    # TODO create your Selenium object and initialise the browser
    xvfb = Xvfb()
    try:
        xvfb.start()
        # TODO run some selenium tests here
        xvfb.stop()
    except OSError:
        print(
            'Error: xvfb cannot be found on your system, please install '
            'it and try again')
        exit(1)
    finally:
        # TODO clean up Selenium browser

if __name__ == '__main__':
    main()
```

Another popular option is
[PyVirtualDisplay](https://github.com/ponty/PyVirtualDisplay) but I couldn't
get that working when I tried it.  I'll need to look into why soon.

xvfbwrapper is robust and has no dependencies so I honestly had no reason to
really pursue PyVirtualDisplay but it's a similar library and worth a look too.

One of the biggest challenges one may face when testing like this is the
multitude of OS and browser combinations.  On bigger projects where browser and
OS compatibility are very important, you may wish to use a service such as
[Sauce](https://saucelabs.com/selenium) to perform your testing. Their service
gives access to over 300 browser/OS combinations and is free for open source
projects.

Have fun! :)
