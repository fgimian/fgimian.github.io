---
title: Running nose tests with plugins using the setuptools test command
date: 2014-04-27T11:28:00+10:00
---

The [nose](https://nose.readthedocs.org/en/latest/) Python test framework is a
really good choice for writing and running your tests.  However, it seems that
the author is
[deprecating the use of nose.collector](https://code.google.com/p/python-nose/issues/detail?id=219)
which was used when running the **test** setuptools command:

``` bash
python setup.py test
```

Furthermore, even in its current form, the nose collector doesn't correctly
work with plugins such as
[coverage.py](http://nedbatchelder.com/code/coverage/).

The [recommended way](http://nose.readthedocs.org/en/latest/setuptools_integration.html)
is to use the **nosetests** setuptools command instead.  Though, this presents
several problems:

* The nosetests setuptools command is not recognised unless nose is installed
* The only way to ensure that nose is installed is using the **setup_requires**
  directive

``` python
setup(
    ...
    setup_requires=[
        'nose',
        'coverage',
        'mock'
    ],
    ...
)
```

* Using the setup_requires directive means that every time a user installs your
  package using pip, they must also download all the setup dependencies, which
  they don't actually need to use the library.  The setup_requires dependencies
  are not installed, but is still a waste of time and bandwidth for our users.

So how do we get around this?  We create a custom **test** command!  This is
based on
[py.test's excellent example](https://pytest.org/latest/goodpractises.html#integration-with-setuptools-test-commands).

In **setup.py**:

``` python
from setuptools import setup
from setuptools.command.test import test as TestCommand


# Inspired by the example at https://pytest.org/latest/goodpractises.html
class NoseTestCommand(TestCommand):
    def finalize_options(self):
        TestCommand.finalize_options(self)
        self.test_args = []
        self.test_suite = True

    def run_tests(self):
        # Run nose ensuring that argv simulates running nosetests directly
        import nose
        nose.run_exit(argv=['nosetests'])

setup(
    ...
    tests_require=[
        'nose',
        'coverage',
        'mock'
    ],
    cmdclass={'test': NoseTestCommand},
    ...
)
```

And there we have it, a custom test command which runs our nose tests after
test dependencies are installed.  This combats all the problems mentioned above
and also correctly detects plugins in setup.cfg.

Here's the setup.cfg for my [Painter](https://github.com/fgimian/painter)
project which I tested with:

``` cfg
[nosetests]
detailed-errors=1
with-coverage=1
cover-package=painter
cover-erase=1
verbosity=2
```

In the future, I'll likely be switching to [py.test](http://pytest.org/) as my
test runner anyway due its improved assert introspection.  But for now, this
will get me by.

Hope this is helpful :)
