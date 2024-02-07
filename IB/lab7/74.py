import functools
def memoize(func):
    cache = {}
    @functools.wraps(func)
    def memoized_func(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]
    return memoized_func
@memoize
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
print(fibonacci(10))
def play(n, sourse, receiver, storage):
    if n == 0:return
    play(n-1, sourse, storage, receiver)
    print("Диск ", n, " : ", sourse, " --> ", receiver)
    play(n-1, storage, receiver, sourse)
play(5,'a','b','c')
