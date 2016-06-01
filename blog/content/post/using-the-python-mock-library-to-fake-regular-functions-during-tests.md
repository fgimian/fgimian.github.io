---
title: Using the Python mock library to fake regular functions during tests
date: 2014-04-10T19:00:00+10:00
---

While writing unit tests in Python, there will often be times where you'll need
to fake the result of a function as testing against the actual function may be
impossible.  A simple example is a random function since one can't predict what
it will return.  Another could be a database call for a database that's only
available in certain environments.

Python's [mock](https://pypi.python.org/pypi/mock) library is the de facto
standard when mocking functions in Python, yet I have always struggled to
understand it from the official documentation.

In this post, I'm going to focus on regular functions.  We'll take a look at
mocking classes and their related properties some time in the future.

## Mocking Functions Using Decorators

Let's start with the **os.urandom** function.  We'll begin by writing a mock
function that will act similarly to urandom:

```python
def simple_urandom(length):
    return 'f' * length
```

OK, so now let's use it!

```python
import unittest
import os
import mock


def simple_urandom(length):
    return 'f' * length


class TestRandom(unittest.TestCase):
    @mock.patch('os.urandom', side_effect=simple_urandom)
    def test_urandom(self, urandom_function):
        assert os.urandom(5) == 'fffff'
```

The **side_effect** keyword argument simply allows you to replace an entire
function with another.  Please also notice that the decorator now adds an
additional argument to the function that it wraps which I've called
**urandom_function**.  We'll discuss some of the things you can do with this
later on.

The code above also works if we were importing a function that used
**os.urandom** too.

OK, but what if we imported the urandom function using a from statement?
Well this is a special case where you can use **\_\_main\_\_** to mock the
function:

```python
import unittest
from os import urandom
import mock


def simple_urandom(length):
    return 'f' * length


class TestRandom(unittest.TestCase):
    @mock.patch('__main__.urandom', side_effect=simple_urandom)
    def test_urandom(self, urandom_function):
        assert urandom(5) == 'fffff'
```

Great stuff!  But in many cases, we would be importing a function from a module
that calls urandom directly using a from import.  For example, let's say we had
this function in a module called **fots**:

```python
from os import urandom


def abc_urandom(length):
    return 'abc' + urandom(length)
```

In this case, we can mock the urandom function in the fots module like this:

```python
import unittest
import mock

from fots import abc_urandom


class TestRandom(unittest.TestCase):
    @mock.patch('fots.urandom', side_effect=simple_urandom)
    def test_abc_urandom(self, abc_urandom_function):
        assert abc_urandom(5) == 'abcfffff'
```

At this point, we know how to mock the various types of function calls that may
occur.

If you would like to perform a much simpler mock and just replace the return
value of the function with a simple expression, you may do this:

```python
@mock.patch('os.urandom', return_value='pumpkins')
```

## Mocking Functions Using Context Managers

For more granular control over when mocking should take place within a test
case, you may use a with statement instead of a decorator as shown below.

```python
with mock.patch('os.urandom', return_value='pumpkins') as abc_urandom_function:
    assert abc_urandom(5) == 'abcpumpkins'
```

As you can see, the syntax really doesn't change all that much and once again
you'll have the function available within the with statement's scope for
manipulation.

## Using the Mocked Function During Tests

As mentioned above, using the decorator or context manager provides access to
the mocked function via an additional variable.

Firstly, we can change the mock function on the fly throughout the test like
this:

```python
import unittest
import mock
import os


class TestRandom(unittest.TestCase):
    @mock.patch('os.urandom')
    def test_abc_urandom(self, urandom_function):
        urandom_function.return_value = 'pumpkins'
        assert os.urandom(5) == 'pumpkins'
        urandom_function.return_value = 'lemons'
        assert os.urandom(5) == 'lemons'
        urandom_function.side_effect = (
            lambda l: 'f' * l
        )
        assert os.urandom(5) == 'fffff'
```

We can also determine if the mock function was called and how many times it was
called.  These particular statistics can be reset using the **reset_mock**
function.  Please see an example below:

```python
import unittest
import mock
import os


class TestRandom(unittest.TestCase):
    @mock.patch('os.urandom', return_value='pumpkins')
    def test_abc_urandom(self, urandom_function):
        # The mock function hasn't been called yet
        assert not urandom_function.called

        # Here we call the mock function twice and assert that it has been
        # called and the number of times called is 2
        assert os.urandom(5) == 'pumpkins'
        assert os.urandom(5) == 'pumpkins'
        assert urandom_function.called
        assert urandom_function.call_count == 2

        # Finally, we can reset all function call statistics as though the
        # mock function had never been used
        urandom_function.reset_mock()
        assert not urandom_function.called
        assert urandom_function.call_count == 0
```

You may even determine exactly what parameters the mocked function was called
with:

```python
import unittest
import mock
import os


class TestRandom(unittest.TestCase):
    @mock.patch('os.urandom', return_value='pumpkins')
    def test_abc_urandom(self, urandom_function):
        assert os.urandom(1) == 'pumpkins'
        assert os.urandom(3) == 'pumpkins'
        assert os.urandom(10) == 'pumpkins'

        # Function was last called with argument 10
        args, kwargs = urandom_function.call_args
        assert args == (10,)
        assert kwargs == {}

        # All function calls were called with the following arguments
        args, kwargs = urandom_function.call_args_list[0]
        assert args == (1,)
        assert kwargs == {}
        args, kwargs = urandom_function.call_args_list[1]
        assert args == (3,)
        assert kwargs == {}
        args, kwargs = urandom_function.call_args_list[2]
        assert args == (10,)
        assert kwargs == {}
```

Pretty cool huh?

## Conclusion

It's easy to see how awesome this library is and why it's now part of the
standard library.  Its implementation is also very Pythonic and elegant.
Hopefully this little guide has gotten you over the hurdles that I first had
to go through while learning it.  Happy mocking! :)
