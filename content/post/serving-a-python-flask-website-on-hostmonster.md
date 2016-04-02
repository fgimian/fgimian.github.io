---
title: Serving a Python Flask Website on Hostmonster
date: 2014-02-14T19:40:00+11:00
---

Hey there folks, it's been a while!

In this post, I'll be guiding you through setting up Hostmonster (or similar
shared hosting providers) to serve a Python Flask web application.  I'll be
using my new [Flaskage](https://github.com/fgimian/flaskage) template project
as the application, but naturally you can adapt this solution to work with any
Flask application.

We'll create a temporary build directory to put things in:

```bash
mkdir ~/build
cd ~/build
```

First, start by building and installing Python on the system:

```bash
curl -O http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz
tar xvfz Python-2.7.6.tgz
cd Python-2.7.6
./configure --prefix=$HOME/python
make
make install
cd ..
```

And now, for the sake of having binaries like lessc and coffee available,
we'll also install Node.js:

```bash
curl -O http://nodejs.org/dist/v0.10.25/node-v0.10.25-linux-x64.tar.gz
mkdir ~/nodejs
tar xvfz node-v0.10.25-linux-x64.tar.gz -C ~/nodejs --strip 1
```

Let's now make our new Python and Node.js bin directories the default on the
system.  Just ensure that the PATH variable is set as follows in
**~/.bash_profile**:

```bash
# User specific environment and startup programs
export PATH=$HOME/bin:$HOME/python/bin:$HOME/nodejs/bin:$PATH
```

Source the file again and ensure that the system is using our new python binary
and can also find our node binary too:

```bash
source ~/.bash_profile
which python
which node
```

Now we'll install pip and virtualenv:

```bash
curl -sSL http://peak.telecommunity.com/dist/ez_setup.py | python
easy_install pip
pip install virtualenv
```

Let's create a new virtualenv for our application (Flaskage in this case):

```bash
mkdir ~/.virtualenv/
virtualenv ~/.virtualenv/flaskage
source ~/.virtualenv/flaskage/bin/activate
```

We're now done with our build directory, so let's clean it up:

```bash
cd ~
rm -rfv build/
```

I discovered some dramas when cloning via git:// URLs on Hostmonster and
therefore I suggest you force Git to use HTTPS instead:

```bash
git config --global url."https://".insteadOf git://
```

Ok, we're now ready to clone Flaskage and install all required dependencies:

```bash
git clone https://github.com/fgimian/flaskage.git
cd flaskage/
pip install -r requirements.txt
npm install -g bower less clean-css coffee-script uglify-js
bower install
```

We'll also need **flup** to serve the site via FCGI:

```bash
pip install flup
```

We're getting really close now.  Our application is completely ready to be
served and all dependencies are installed, so all that's left to do is write
a small FCGI script and .htaccess file.

Relative to **~/public_html/**, change into the root directory from which you
wish your website to be served.  If you want the website served starting at /
on your domain, then simply change into public_html, but in my case, I'll serve
the website from /flaskage (e.g. http://www.mydomain.com/flaskage).

```bash
cd ~/public_html/
mkdir flaskage
cd flaskage/
```

In this directory, create an FCGI script (I called mine **flaskage.fcgi**) as
follows:

```python
#!/home/fots/.virtualenv/flaskage/bin/python
import sys

from flup.server.fcgi import WSGIServer

sys.path.insert(0, '/home/fots/flaskage')
from application import create_app

if __name__ == '__main__':
    app = create_app('production')
    WSGIServer(app).run()
```

You'll naturally need to modify this file to suit your application.  The main
things you should modify are as follows:

* The first line should point to the python binary of your virtualenv
* The sys path insert needs to correspond to your application's root directory
  (the location where you can import app or your application factory create_app
  function)
* The lines relating to the import and creation of app need to be modified
  depending on how your application has been built (e.g. if not using
  factories, you may simply import your app object and call it a day)

Ensure you make the FCGI script executable and test that it returns the
homepage of your application:

```bash
chmod +x flaskage.fcgi
./flaskage.fcgi
```

And now for the .htaccess file:

```
AddHandler fcgid-script .fcgi
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.*)$ flaskage.fcgi/$1 [QSA,L]
```

Note the last line which should be modified to include the filename of your
FCGI script above.

Phew, that was a little painful huh?  But you made it!  You should now be able
to browse to
[http://www.yourdomain.com/flaskage](http://www.yourdomain.com/flaskage) and
see the Flaskage landing page.

Keep in mind the complexity behind this landing page.  It has tested that all
the Node.js components and Bower components have worked correctly in addition
to our Python build and virtualenv package setup.

Naturally, I have my reservations about running a site over FCGI instead of
WSGI, but seriously, it should perform as well as any standard PHP site.
Those running bigger and higher-traffic sites likely have a Linode, Amazon EC2
or other dedicated hosting solution and can deploy their site via Nginx and
WSGI anyway.

Have a good one! :)
