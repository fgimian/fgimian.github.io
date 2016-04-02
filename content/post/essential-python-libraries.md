---
title: Essential Python Libraries
date: 2014-03-04T21:11:00+11:00
---

So in case you haven't noticed ... I'm a little (VERY) in love with Python as
a programming language.  I use it for everything now, from web development,
to scripting and everything in between.

As such, I thought I'd put together an article of the many amazing libraries
that I think every Python programmer needs to know about.  Now there's no doubt
in my mind that there are heaps that I've missed, but we have to start
somewhere.  I'll try to keep revising this article as I come across more great
libraries.

## Web Development

* [Flask](https://pypi.python.org/pypi/Flask): My web framework of choice right
  now.  Don't be fooled by the word "micro", this bad boy can do everything
  under the sun once you plug in the necessary components.  Be sure to also
  check out [Werkzeug](https://pypi.python.org/pypi/Werkzeug) and
  [Jinja2](https://pypi.python.org/pypi/Jinja2) libraries that Flask depends
  on.  Werkzeug is a very extensive set of WSGI tools including a full caching
  implementation.  Jinja2 is an extremely elegant templating language (and my
  personal favourite in Python).
* [Django](https://pypi.python.org/pypi/Django): A quality full-stack web
  framework with awesome documentation and everything you could need included.
  The upcoming addition of database migrations take Django to the next level.
* [SQLAlchemy](https://pypi.python.org/pypi/SQLAlchemy): An incredible database
  ORM which plugs beautifully into Flask.
* [Alembic](https://pypi.python.org/pypi/alembic/0.6.3): Database migrations
  for SQLAlchemy written by the developer of SQLAlchemy itself.
* [WTForms](https://pypi.python.org/pypi/WTForms): An excellent form validation
  library which plugs really nicely into Flask.
* [dogpile.cache](https://pypi.python.org/pypi/dogpile.cache): Another
  excellent caching library by the author of SQLAlchemy.  Much like Werkzeug,
  this supports the [redis-py](https://pypi.python.org/pypi/redis),
  [python-memcached](https://pypi.python.org/pypi/python-memcached) and
  [pylibmc](https://pypi.python.org/pypi/pylibmc) libraries.  For use with
  memcache, the preference seems to be pylibmc which is mainly written in C
  and performs around twice as fast as python-memcached.
* [Gunicorn](https://pypi.python.org/pypi/gunicorn): My first choice for
  serving WSGI applications.  Absolutely rock solid and performs great.
  Also worth checking out are [gevent](https://pypi.python.org/pypi/gevent)
  and [uWSGI](https://pypi.python.org/pypi/uWSGI).

## Web Interaction

* [Selenium](https://pypi.python.org/pypi/selenium): A library that allows
  you to automate interaction with websites.  I highly recommend the
  [PhantomJS](http://phantomjs.org/) web browser for use with Selenium on
  servers.
* [splinter](https://pypi.python.org/pypi/splinter): Although Selenium is
  excellent, its API can be quite low level when writing tests.  The splinter
  library sits on top of Selenium and provides a clean and simple API for
  interacting with websites.
* [Beautiful Soup](https://pypi.python.org/pypi/beautifulsoup4): A really easy
  to use XML / HTML parsing library.
* [lxml](https://pypi.python.org/pypi/lxml): A similar library to Beautiful
  Soup but with much better performance and arguably a cleaner API.
* [Requests](https://pypi.python.org/pypi/requests): The most elegant way to
  make requests to websites and retrieve responses.  Great for interacting with
  APIs and similar.

## Automation

* [Ansible](https://pypi.python.org/pypi/ansible): An absolutely awesome build
  automation tool which compares favourably to Puppet in many important areas.
* [Salt](https://pypi.python.org/pypi/salt): Another Python-based build
  automation tool which competes with Puppet and Chef.
* [Fabric](https://pypi.python.org/pypi/Fabric): An amazing automation tool for
  deploying code, running tasks and interacting with servers.
* [Invoke](https://pypi.python.org/pypi/invoke): By the developers who brought
  us Fabric comes Invoke which will be used by Fabric 2.0 when it's released.
  Invoke itself is a very clean and powerful make file replacement in Python
  (the equivalent of Rake in Ruby).
* [BuildBot](https://pypi.python.org/pypi/buildbot): A build automation system
  similar to Jenkins.

## Testing Tools

* [Coverage.py](https://pypi.python.org/pypi/coverage): Allows you to examine
  what lines of your code are missing unit tests.  This blew my mind the first
  time I came across it! :)
* [mock](https://pypi.python.org/pypi/mock): Mock allows you to replace bits of
  your system to help with simulating necessary conditions in unit tests.
* [nose](https://pypi.python.org/pypi/nose): Enhances the included unittest to
  make written tests more elegant and easier to run.
* [pytest](https://pypi.python.org/pypi/pytest): Another Python unit test
  enhancer which adds some helpful features and functionality.
* [factory_boy](https://pypi.python.org/pypi/factory_boy): Database fixtures
  for testing web applications.
* [fake-factory](https://pypi.python.org/pypi/fake-factory): An awesome library
  for generating fake data for testing purposes.
* [behave](https://pypi.python.org/pypi/behave): A fantastic BDD tool for
  Python very similar to [Cucumber](http://cukes.info/).
* [sure](https://pypi.python.org/pypi/sure): Provides a very human-friendly way
  to write tests.
* [pyshould](https://pypi.python.org/pypi/pyshould): Very similar to sure but
  can also be extended with custom assertions.

## Miscellaneous

* [Flake8](https://pypi.python.org/pypi/flake8): A great tool which combines
  PEP8 and PyFlakes to help validate your code.  I use this religiously.
* [IPython](https://pypi.python.org/pypi/ipython): A significantly improved
  Python shell.
* [pandas](https://pypi.python.org/pypi/pandas): A library providing a range
  of tools for data analysis.
* [Pygments](https://pypi.python.org/pypi/Pygments): The reference for syntax
  highlighting of code.
* [python-daemon](https://pypi.python.org/pypi/python-daemon): A library which
  makes it much easier to implement a daemon in Python.
* [python-dateutil](https://pypi.python.org/pypi/python-dateutil): Some very
  handy functions which make working with dates a lot easier.
* [PyYAML](https://pypi.python.org/pypi/PyYAML): Allows you to read and write
  YAML files seamlessly.  YAML is my preferred format for storing
  configurations where possible.
* [Sentry](https://pypi.python.org/pypi/sentry): A powerful realtime log
  aggregation system which collects logs from multiple places and makes them
  available via a web interface.
* [six](https://pypi.python.org/pypi/six): A very handy library for making code
  compatible with both Python 2 and Python 3
* [Watchdog](https://pypi.python.org/pypi/watchdog): A library that can watch
  for changes to files and take chosen actions when a change is detected.
* [Supervisor](https://pypi.python.org/pypi/supervisor): A neat little system
  which keeps track of running daemons or processes and takes action if any
  failures occur.

Please let me know if I've missed anything obvious guys! :)
