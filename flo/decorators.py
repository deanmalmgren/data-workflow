import functools

from .types import FrozenDict

class memoize(object):
    """Decorator. Caches a function's return value each time it is called.
    If called later with the same arguments, the cached value is returned
    (not reevaluated).

    adapted from https://wiki.python.org/moin/PythonDecoratorLibrary#Memoize
    """

    def __init__(self, func):
        self.func = func
        self.cache = {}

    def __call__(self, *args, **kwargs):       

        # cast kwargs as an immutable dictionary so this caching works
        frozen_kwargs = FrozenDict(kwargs)        

        # return the stored value if it exists. otherwise call the
        # function with the passed in parameters and store the result
        lookup = (args, frozen_kwargs)
        if lookup in self.cache:
            return self.cache[lookup]
        else:
            value = self.func(*args, **kwargs)
            self.cache[lookup] = value
            return value

    def __repr__(self):
        '''Return the function's docstring.'''
        return self.func.__doc__

    def __get__(self, obj, objtype):
        '''Support instance methods.'''
        return functools.partial(self.__call__, obj)


if __name__ == '__main__':

    @memoize
    def fibonacci(n=1):
        "Return the nth fibonacci number."
        if n in (0, 1):
            return n
        return fibonacci(n-1) + fibonacci(n-2)

    import time
    def timed_fibonacci(n):
        t = time.time()
        print fibonacci(n=n)
        print time.time() - t

    timed_fibonacci(20)
    timed_fibonacci(20)
    timed_fibonacci(21)
