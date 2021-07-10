---
title: Python API Framework Benchmarks
date: 2018-06-05T21:25:26+10:00
---

With the multitude of awesome Python web frameworks out there today, I thought it would be a fun exercise to perform my own benchmarking against them and several popular WSGI servers.

**Disclaimer**: I'm aware that this test doesn't offer multiple real-life use-cases and may not be a great representation of real-world performance.  However, I still thought it would be fun to share the results.

## Test Environment

Two servers were created in AWS with the following details:

**AMI**: CentOS 7 (x86_64) - with Updates HVM  
**Type**: t2.2xlarge  
**vCPUs**: 8  
**Memory (GiB)**: 32  

One of these servers will run the WSGI server and app while the other will use [wrk](https://github.com/wg/wrk) to perform load testing.

The WSGI server was setup as follows:

```bash
# Install Python 3.6 and useful dependencies for installing packages
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm
sudo yum -y install gcc libev-devel python36u python36u-devel

# Create a virtualenv
python3.6 -m venv ~/venv
source ~/venv/bin/activate

# Install WSGI servers we're going to use for testing
pip install eventlet gevent gunicorn meinheld uwsgi

# Install frameworks we're going to use for testing
pip install apistar bottle falcon flask hug sanic
```

The wrk server was setup as follows:

```bash
# Install requirements for building wrk
sudo yum -y install git gcc

# Build wrk
git clone https://github.com/wg/wrk.git wrk
cd wrk
make

# Install the executable
sudo mv wrk /usr/bin

# Add the local IP address of the WSGI server to /etc/hosts
sudo bash -c 'echo "172.31.4.0  wsgi" >> /etc/hosts'

# Clean up
cd ..
rm -rf wrk
```

## Hello World Benchmarks

### Code

#### API Star

```python
from apistar import App, Route

def hello() -> str:
    return 'Hello World!'

app = App(routes=[
    Route('/', method='GET', handler=hello)
])
```

#### Bottle

```python
import bottle

@bottle.get('/')
def hello():
    return 'Hello World!'

app = bottle.default_app()
```

#### Falcon

```python
import falcon

class HelloResource(object):
    def on_get(self, req, resp):
        resp.body = 'Hello World!'

app = falcon.API()
app.add_route('/', HelloResource())
```

#### Flask

```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello World!'
```

#### hug

```python
import hug

@hug.get("/")
def hello():
    return 'Hello World!'

app = __hug_wsgi__
```

#### Sanic

```python
from sanic import Sanic
from sanic.response import text

app = Sanic()

@app.route('/')
async def hello(request):
    return text('Hello World!')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, access_log=False)
```

### Commands

#### wrk

```bash
wrk --duration 10s --threads 1 --connections 200 http://wsgi:8000
```

Note that 5 - 6 runs were conducted and the most requests/sec from any iteration were recorded.  I also note below if results varied wildly to set appropriate expectations.

#### WSGI Servers

**Note**: I'm using Sanic's inbuilt `run` function instead of its Gunicorn workers as there's [no way to disable to access logging otherwise](https://github.com/channelcat/sanic/issues/1143).

```bash
# Eventlet workers
gunicorn \
  --workers 17 --worker-class=eventlet \
  --bind 0.0.0.0:8000 \
  hello_<framework>:app

# gevent workers
gunicorn \
  --workers 17 --worker-class=gevent \
  --bind 0.0.0.0:8000 \
  hello_<framework>:app

# gunicorn (pure)
gunicorn \
  --workers 17 \
  --bind 0.0.0.0:8000 \
  hello_<framework>:app

# Meinheld workers
gunicorn \
  --workers 17 --worker-class=meinheld.gmeinheld.MeinheldWorker \
  --bind 0.0.0.0:8000 \
  hello_<framework>:app

# wsgi
uwsgi \
  --workers 17 --enable-threads \
  --http 0.0.0.0:8000 \
  --disable-logging \
  --wsgi-file hello_<framework>.py --callable app
```

## Benchmark Results (hello world)

```
           apistar   bottle    falcon     flask      hug      sanic    
--------- --------- --------- --------- --------- --------- --------- 
eventlet     19.34k    18.86k    19.94k    13.53k    17.36k       n/a
gevent       19.28k    18.86k    19.95k    13.51k    17.55k       n/a
gunicorn     12.56k    12.91k    13.28k    11.93k    12.67k       n/a
meinheld     69.70k    68.80k    70.62k    35.51k    70.96k       n/a
uwsgi        errors    errors    errors    errors    errors       n/a
sanic           n/a       n/a       n/a       n/a       n/a    68.02k
```

Clearly I'm missing something important on uWSGI as I was seeing socket errors against all frameworks while testing with it:

e.g.

```
Running 10s test @ http://wsgi:8000
  1 threads and 200 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    11.18ms   45.49ms   1.39s    99.46%
    Req/Sec     3.49k     3.99k    8.71k    64.10%
  14403 requests in 10.02s, 1.25MB read
  Socket errors: connect 0, read 14403, write 0, timeout 62
Requests/sec:   1437.38
Transfer/sec:    127.74KB
```

I attempted tweaks involving the following settings but still failed to succeed with uWSGI:

* `--buffer-size`
* `--harakiri`
* `--http-keepalive`
* `--limit-post`
* `--master`
* `--max-requests`
* `--max-requests`
* `--no-orphans`
* `--so-keepalive`
* `--vacuum`

I'm absolutely happy to take suggestions on what I should tweak to get uWSGI to work but from this point in the article, I'll be excluding it from further tests.

## Benchmark Results (data manipulation / algorithm)

We've developed a codebase at work which uses a reasonably large set of data to make a determination.  This is one of the endpoints that we are exposing in the API we're building.

Clearly, due to the fact that the code is owned by my company, I can't share it here; but wanted to benchmark it against all the frameworks to see if the difference stays relative.

Please note that this endpoint creates a JSON response and I had to increase wkr's timeout to 10 seconds to avoid timeout errors with `--timeout 10`.

In all results below, I have included the min - max requests served per 10 second period.

### Results (Errors)

In all the tests below, at least one socket error was encountered.

```
            apistar    bottle     falcon      flask       hug       sanic    
---------  ---------  ---------  ---------  ---------  ---------  --------- 
eventlet   209 - 485  205 - 488  219 - 492  272 - 481  336 - 484
gevent     332 - 475  337 - 491  278 - 483  271 - 472
gunicorn                                    300 - 454
```

### Results (No Errors)

The following produced no errors at all.

```
            apistar     bottle     falcon     flask      hug        sanic    
---------  ---------  ---------  ---------  ---------  ---------  --------- 
gevent                                                 202 - 483     n/a
gunicorn   462 - 472  348 - 471  385 - 468             291 - 461     n/a
meinheld   465 - 494  461 - 490  461 - 498  450 - 478  461 - 488     n/a
sanic         n/a        n/a        n/a        n/a        n/a     385 - 495
```

### Thoughts

I was amazed at how consistent and solid Meinheld was in all my tests.  It had the least variance and never failed.  The framework here made less of a difference as our bottleneck was now the algorithm being worked through on each request.

As such, I'm only going to proceed testing Gunicorn, Meinheld and Sanic servers from this point forward to make my life easier :)

## Conclusion

Apart from Flask, all frameworks I tested were neck in neck throughout.  There are various benchmarks showing that Flask isn't performant and sadly that was the case here too.

Meinheld definitely stood out as the fastest WSGI server and its easy integration with Gunicorn makes it easy to integrate into existing deployments.
