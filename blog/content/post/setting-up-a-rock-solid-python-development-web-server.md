---
title: Setting up a Rock Solid Python Development Web Server
date: 2012-12-08T21:54:00+11:00
---

So you want to start developing a Python application do ya?  Let's assume we
are planning to use a smaller framework like [Flask](http://flask.pocoo.org/)
which is a framework I'm really loving at the moment.

**Update (6th of April 2014)**: In the past, I had found Flask's in-built
development server to be a bit unstable which is why I put together this entry
but this is no longer the case.  As such, I now recommend using the dev server
that comes with Flask for development purposes.  However, if you prefer to use
another server instead, please read on.

In this article, I'll show you how to setup various web servers to serve Flask
applications using WSGI which may also be suitable for production use later on.

The requirements I have for a development server are as follows:

* It must print access and error log output to stdout in realtime
* It must display stdout when the print function is used in the code (which is
  really handy for debugging)
* The server should reliably reload automatically when any code is changed
* Exceptions should be printed to stderr or the browser if something goes wrong
* The web server needs to be easy to setup
* (Bonus) It would be ideal if the web server works with Jython 2.5.x too

So let's get into it.

## CherryPy

[CherryPy](http://www.cherrypy.org/)'s web server is very well regarded and was
one of the first I looked at.  My main criticism of CherryPy was its
documentation which I found extremely difficult to read through and grasp.
With a bit of digging around, I managed to get everything to work.  You must
use the Paste library for logging.

Installation of CherryPy is super easy:

```bash
pip install cherrypy paste
```

And here's the Flask script:

```python
#!/usr/bin/env python

from flask import Flask
import cherrypy
from paste.translogger import TransLogger

app = Flask(__name__)
app.debug = True


@app.route("/")
def hello():
    return "Hello World!"


def run_server():
    # Enable WSGI access logging via Paste
    app_logged = TransLogger(app)

    # Mount the WSGI callable object (app) on the root directory
    cherrypy.tree.graft(app_logged, '/')

    # Set the configuration of the web server
    cherrypy.config.update({
        'engine.autoreload_on': True,
        'log.screen': True,
        'server.socket_port': 5000,
        'server.socket_host': '0.0.0.0'
    })

    # Start the CherryPy WSGI web server
    cherrypy.engine.start()
    cherrypy.engine.block()

if __name__ == "__main__":
    run_server()
```

With a bit of extra effort, we can customise the access logging from Paste to
be consistent with CherryPy if desired:

```python
#!/usr/bin/env python

import time

from flask import Flask
import cherrypy
from paste.translogger import TransLogger

app = Flask(__name__)
app.debug = True


@app.route("/")
def hello():
    return "Hello World!"


class FotsTransLogger(TransLogger):
    def write_log(self, environ, method, req_uri, start, status, bytes):
        """ We'll override the write_log function to remove the time offset so
        that the output aligns nicely with CherryPy's web server logging

        i.e.

        [08/Jan/2013:23:50:03] ENGINE Serving on 0.0.0.0:5000
        [08/Jan/2013:23:50:03] ENGINE Bus STARTED
        [08/Jan/2013:23:50:45 +1100] REQUES GET 200 / (192.168.172.1) 830

        becomes

        [08/Jan/2013:23:50:03] ENGINE Serving on 0.0.0.0:5000
        [08/Jan/2013:23:50:03] ENGINE Bus STARTED
        [08/Jan/2013:23:50:45] REQUES GET 200 / (192.168.172.1) 830
        """

        if bytes is None:
            bytes = '-'
        remote_addr = '-'
        if environ.get('HTTP_X_FORWARDED_FOR'):
            remote_addr = environ['HTTP_X_FORWARDED_FOR']
        elif environ.get('REMOTE_ADDR'):
            remote_addr = environ['REMOTE_ADDR']
        d = {
            'REMOTE_ADDR': remote_addr,
            'REMOTE_USER': environ.get('REMOTE_USER') or '-',
            'REQUEST_METHOD': method,
            'REQUEST_URI': req_uri,
            'HTTP_VERSION': environ.get('SERVER_PROTOCOL'),
            'time': time.strftime('%d/%b/%Y:%H:%M:%S', start),
            'status': status.split(None, 1)[0],
            'bytes': bytes,
            'HTTP_REFERER': environ.get('HTTP_REFERER', '-'),
            'HTTP_USER_AGENT': environ.get('HTTP_USER_AGENT', '-'),
        }
        message = self.format % d
        self.logger.log(self.logging_level, message)


def run_server():
    # Enable custom Paste access logging
    log_format = (
        '[%(time)s] REQUES %(REQUEST_METHOD)s %(status)s %(REQUEST_URI)s '
        '(%(REMOTE_ADDR)s) %(bytes)s'
    )
    app_logged = FotsTransLogger(app, format=log_format)

    # Mount the WSGI callable object (app) on the root directory
    cherrypy.tree.graft(app_logged, '/')

    # Set the configuration of the web server
    cherrypy.config.update({
        'engine.autoreload_on': True,
        'log.screen': True,
        'server.socket_port': 5000,
        'server.socket_host': '0.0.0.0'
    })

    # Start the CherryPy WSGI web server
    cherrypy.engine.start()
    cherrypy.engine.block()

if __name__ == "__main__":
    run_server()
```

## Gevent

[http://www.gevent.org/](Gevent) appears to be one of the fastest WSGI web
servers out there and provides all the features we are after too!

Installing Gevent is a bit more of a pain due to the libevent dependency:

```bash
sudo apt-get install build-essential python-dev libevent-dev
pip install gevent
```

And here's the Flask script:

```python
#!/usr/bin/env python

from flask import Flask
import gevent.wsgi
import gevent.monkey
import werkzeug.serving

gevent.monkey.patch_all()
app = Flask(__name__)
app.debug = True


@app.route("/")
def hello():
    return "Hello World!"


@werkzeug.serving.run_with_reloader
def run_server():
    ws = gevent.wsgi.WSGIServer(listener=('0.0.0.0', 5000),
                                application=app)
    ws.serve_forever()

if __name__ == "__main__":
    run_server()
```

## Gunicorn

[Gunicorn](http://gunicorn.org/) is a production-ready web server for Python.
I must commend the designer of the site who shows that even Python-related
sites can look beautiful!  Unfortunately, Gunicorn (being a server aimed at
production use) makes it a lot harder to get auto-restart capabilities as this
functionality is not natively included.

Installing Gunicorn is painless:

```bash
pip install gunicorn
```

To make it all happen with Gunicorn, we're going to need
[supervisor](http://supervisord.org/) and
[watchdog](http://packages.python.org/watchdog/) to monitor for changes and
trigger a restart of Gunicorn.

These tools rely on several C libraries, so there's a bit more to it than just
using pip:

```bash
sudo apt-get install build-essential python-dev libyaml-dev
pip install supervisor watchdog
```

The supervisor configuration is as follows:

```ini
[supervisord]
logfile=test.log
loglevel=debug
nodaemon=true

[program:test]
autostart=true
command=gunicorn --pid /tmp/flask-project.pid --workers 4 --log-level debug -b 0.0.0.0:5000 test:app

[program:test-reloader]
autostart=true
autorestart=false
command=watchmedo shell-command --patterns="*.py;*.html;*.css;*.js" --recursive --command='kill -HUP $(cat /tmp/flask-project.pid)'
```

The Python script stays super clean and simple which is nice:

```python
#!/usr/bin/env python

from flask import Flask

app = Flask(__name__)
app.debug = True


@app.route("/")
def hello():
    return "Hello World!"
```

We can now launch the web server using supervisor as follows:

```bash
supervisord -c test.conf
```

Overall though, I don't see myself using Gunicorn for development purposes due
to the added complexity involved.  Another point worth noting is that
**print statements to stdout do not appear on the console with Gunicorn**,
unlike the rest of the web servers tested here.

## Rocket

[Rocket](https://launchpad.net/rocket) is a newer pure Python WSGI web server
which is also production ready.  I thought it would be worth giving it a try
too.

Installing Rocket is very simple

```bash
pip install rocket
```

And here's the Flask script:

```python
#!/usr/bin/env python

import logging
import sys

from flask import Flask
from rocket import Rocket

app = Flask(__name__)
app.debug = True


@app.route("/")
def hello():
    return "Hello World!"


def run_server():
    # Setup logging
    log = logging.getLogger('Rocket')
    log.setLevel(logging.INFO)
    log.addHandler(logging.StreamHandler(sys.stdout))

    # Set the configuration of the web server
    server = Rocket(interfaces=('0.0.0.0', 5000), method='wsgi',
                    app_info={"wsgi_app": app})

    # Start the Rocket web server
    server.start()

if __name__ == "__main__":
    run_server()
```

Unfortunately, Rocket (much like Gunicorn) is primarily aimed at production
deployments, so it doesn't include an auto-restart feature.

To restart it, you may send a **SIGUSR1** to the pid:

```bash
kill -SIGUSR1 <pid>
```

You may shutdown the process using **SIGTERM**:

```bash
kill -SIGTERM <pid>
```

## Tornado

[Tornado](http://www.tornadoweb.org/) appears to be well respected too and has
no C dependencies.

**Note**: The latest Tornado 3.x has a significantly changed API and therefore
the code below will not work with it.  I may look into rewriting the code below
to work with Tornado 3.x when I have a spare moment.

Installing Tornado is as easy as CherryPy:

```bash
pip install tornado==2.4
```

And here's the Flask script:

```python
#!/usr/bin/env python

from flask import Flask
import tornado.wsgi
import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.autoreload

app = Flask(__name__)
app.debug = True


@app.route("/")
def hello():
    return "Hello World!"


def run_server():
    # Create the HTTP server
    http_server = tornado.httpserver.HTTPServer(
        tornado.wsgi.WSGIContainer(app)
    )
    http_server.listen(5000)

    # Reads args given at command line (this also enables logging to stderr)
    tornado.options.parse_command_line()

    # Start the I/O loop with autoreload
    io_loop = tornado.ioloop.IOLoop.instance()
    tornado.autoreload.start(io_loop)
    try:
        io_loop.start()
    except KeyboardInterrupt:
        pass

if __name__ == "__main__":
    run_server()
```

## Further WSGI Debugging with Werkzeug

Flask's Werkzeug has an awesome debugging module which you will lose access to
when not using the default web server.  But don't fear, we can add it back in!

```python
...
from werkzeug.debug import DebuggedApplication
...

def run_server():
    # Enable the Werkzeug Debugger
    app_debug = DebuggedApplication(app, evalex=True)
    ...
```

Now simply ensure that you pass **app_debug** into sebsequent functions instead
of **app** as we did above.

## Further WSGI Logging with wsgilog

An additional module you can plug in into your application is
[wsgilog](http://pypi.python.org/pypi/wsgilog/) which provides further logging
options for capturing output of WSGI applications.

Installation goes something like this:

```bash
pip install wsgilog
```

You may use it as follows:

```python
...
import wsgilog

app = Flask(__name__)
app.debug = True

app_logged_wsgi = wsgilog.WsgiLog(app, tohtml=True, tofile='wsgi.log',
                                  tostream=True, toprint=True)
...
```

Now when initialising the web server, pass in **app_logged_wsgi** instead of
**app**.

## Final Words

To summarise, the following web servers failed to meet one or more criteria
above:

* **Gunicorn**: Does not display stdout via the print statement.  Gunicorn is
  also more work to setup for a development server compared to the rest.
* **Rocket**: Doesn't include auto-restart ability, but is less troublesome to
  work with in comparison to Gunicorn.

As far as Jython is concerned, I'm sorry to say that none of the web servers
worked with it.  I also tried them with 2.7b1 and still no dice.
