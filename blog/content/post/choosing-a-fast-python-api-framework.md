---
title: Choosing a Fast Python API Framework
date: 2018-05-17T10:15:39+10:00
---

This post attempts to highlight my thought process in selecting a suitable stack for developing an API in Python for our current project at work.

Although I have personally benchmarked various combinations, I haven't documented the results for this article, instead merely mentioned which frameworks and WSGI servers were found to be fast or slow.

All tests I performed (after choosing the fastest WSGI server) were done as follows:

* **WSGI Server**: Gunicorn with Meinheld workers
* **Number of Workers**: CPU Count * 2 + 1
* **Load Test Command**:

    ```
    wrk --duration 20s --threads 1 --connections 100 http://localhost:8000
    ```

* **Code Tested**: Hello world! (however note that I also tested a real endpoint of our app too to double check relative speeds between frameworks)
* **Server**: EC2 t2.2xlarge instance (running both wrk and the framework)

Clearly my test setup was not ideal or scientific so please take it with a grain of salt.  In a future post, I'll detail the code and settings used for testing various frameworks.

Our requirements are as follows:

* **Speed**: We plan to serve a huge number of requests and thus speed is critical.
* **Minimal Dependencies**: Ideally the framework would go easy on dependencies so that it can be understood and referenced easily.
* **Proven & Mature**: We're looking for a moderately mature and popular framework that has been tested in production already.
* **WSGI Based**: Most API calls should be moderately quick to return and no long-running processes are expected, so a standard syncronous framework running on top of WSGI is what we're after.
* **Object-oriented Routes**: This is more of a preference as I personally believe that using classes for routes in a REST API is more suitable due the modularity and ability to initialise aspects of the endpoint without placing variables in a global context.  However, this almost always can be worked-around by simply calling the appropriate method if a function/decorator based approach is used by the framework.

# WSGI Servers

* [Gunicorn](http://gunicorn.org): This is my favourite WSGI server and has pluggable runners which can improve performance (see Meinheld below).  

    ```
    gunicorn [MODULE:APP] --workers=17
    ```

* [Meinheld (offers workers for Gunicorn)](http://meinheld.org): In my tests, this was the best performer and is a great combo with Gunicorn.

    ```
    gunicorn [MODULE:APP] --workers=17 --worker-class=meinheld.gmeinheld.MeinheldWorker
    ```

* [uWSGI](http://uwsgi-docs.readthedocs.io/): This WSGI server is definitely worth considering but the insane amount of options (834 to be exact) it offers make it difficult to understand and setup.

    ```
    uwsgi -p 17 --http 0.0.0.0:8000 --wsgi-file [MODULE] --callable [APP]
    ```

## Others (Ruled Out)

* [bjoern](https://github.com/jonashaag/bjoern): Very fast but also extremely minimal, you must implement logging and workers yourself.
* [CherryPy](https://cherrypy.org): Not fast enough in my testing.
* [Tornado](http://www.tornadoweb.org/): Not fast enough in my testing.
* [Eventlet](http://eventlet.net): Not fast enough in my testing.
* [gevent](http://www.gevent.org): Not fast enough in my testing.  I would use gevent for async tasks in our code though, it just didn't perform as well as Meinheld for WSGI purposes.
* [Chaussette](https://chaussette.readthedocs.io/): Seemed unstable (crashed with Meinheld) and no better than gunicorn in my testing.

## Conclusion

Gunicorn with Meinheld workers seems like the best option here.  It was the fastest in the tests I ran and is simple to setup and configure.

# WSGI Frameworks

## Ruled Out

* [Django](https://github.com/django/django): Too big and with batteries included (contains an ORM, templating .etc); is clearly intended for full-stack as well as APIs
* [Tornado](https://github.com/tornadoweb/tornado): Mostly intended for long-running endpoints (async)
* [Japronto](https://github.com/squeaky-pl/japronto): This is an early preview with alpha quality implementation
* [Pyramid](https://github.com/Pylons/pyramid): Very mature, but also a little bigger, not popular enough
* [weppy](https://github.com/gi0baro/weppy): Not popular enough yet
* [Muffin](https://github.com/klen/muffin): Not popular enough yet
* [Morepath](https://github.com/morepath/morepath): Not popular enough yet

## Considered (But Ruled Out)

* [Flask](https://github.com/pallets/flask): 
    - Very popular
    - Decorator-based
    - Medium sized framework with a few dependencies (6 in total) (it can go well beyond APIs)
    - All dependencies are developed by the same author (and organisation)
    - Performance is greatly lacking and this is ultimately the reason it is ruled out
* [Bottle](https://github.com/bottlepy/bottle):
    - Decorator-based
    - No dependencies
    - Very similar to Flask but a lot faster
    - Performance is excellent: 104,000 req/sec (hello world)
    - Really isn't easy to build larger applications with due to its architecture
    - No new releases for over a year (maybe a concern?)
* [AIOHTTP](https://github.com/aio-libs/aiohttp):
    - Function-based
    - Decent amount of dependencies (8 in total)
    - Mostly focusod on async
    - Didn't actually perform that great in my testing (likely due to the use case)
* [hug](https://github.com/timothycrosley/hug):
    - Decorator-based (similar to Flask and bottle)
    - Lots of dependencies (9 in total)
    - Built on Falcon
    - Very fast (but in my testing, not as fast as Falcon)
    - Note that you must use the special `__hug_wsgi__` object to access the WSGI app
    - Cute logo and name!
* [Quart](https://gitlab.com/pgjones/quart):
    - Decorator-based (similar to Flask and bottle)
    - Lots of dependencies (14 in total)
    - Async only (no WSGI)
* [Sanic](https://github.com/channelcat/sanic):
    - Concerning issue (https://github.com/channelcat/sanic/issues/1176)
    - Please note that you must use sanic workers (`sanic.worker.GunicornWorker`) with gunicorn
    - Still not popular or mature enough
* [API Star](https://github.com/encode/apistar):
    - Function-based
    - Lots of dependencies (12 in total)
    - Can do both sync and async (using WSGI and ASGI respectively)
    - Uses type annotations for type checking
    - Attempts to self-document APIs and make API specs available easily
    - Overall, not really what we are after I think, a bit too much magic here and too many dependencies
    - Performance is amazing though: 116,500 req/sec (hello world)
    - Still not popular enough but worth keeping an eye on!
* [wheezy.web](https://bitbucket.org/akorn/wheezy.web):
    - Seems intended for full-stack development and frontend work (includes templating)
    - Decent amount of dependencies (8 in total)
    - Appears to be a young project (version 0.1)
    - I didn't spend as much time testing this, so it may be worth revisiting

## The Choice / Conclusion

There was one framework that stood out amongst them all (for me), and that is Falcon.  Please find my notes below:

* [Falcon](https://github.com/falconry/falcon):
    - Class-based (a great advantage for REST APIs)
    - Only 2 minor dependencies
    - Performance is amazing: 109,000 req/sec (hello world)
    - Intended only for APIs which makes it more focused and minimal
    - Excellent design, documentation and codebase

# Load Testing Tools

* [wrk](https://github.com/wg/wrk): This was the main tool I personally used while testing and found it great.

    ```
    wrk --duration 20s --threads 10 --connections 200 [URL]
    ```

* [Apache HTTP Server Benchmarking Tool](https://httpd.apache.org/docs/2.4/programs/ab.html): Used this too, it worked well enough but I ended up testing mostly with wrk.

    ```
    ab -c 500 -n 5000 -s 90 [URL]
    ```

* [Siege](https://github.com/JoeDog/siege): I haven't yet had the opportunity to test siege but found it while finishing up my analysis so I thought it was worth including here.

    ```
    siege -c2 -t2m [URL]
    ```

# Final Thoughts

It's been a few years since I looked at Python web frameworks and the landscape has changed dramatically.  I really love the way frameworks like apistar are incorporating type annotations, and also am impressed by the focus on async processing too (which is of great importance to many).

At this point, I think Gunicorn / Meinheld along with Falcon makes an awesome combo for APIs.  For load testing, I had no issues with wrk, but nothing would stop you using all the benchmarking tools mentioned to validate your results.

Hope this has been useful to someone out there :)
