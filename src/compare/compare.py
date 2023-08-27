import numpy as np
from time import time
import functools
from argparse import ArgumentParser
import sys


def measure(func):
    @functools.wraps(func)
    def timer(*args, **kwargs):
        start = time()
        ret = func(*args, **kwargs)
        print(f"Elapsed time: {time() - start:0.4f}s")
        return ret
    return timer


@measure
def run_fast(n=100, size=1000, matmul_func=np.matmul):
    for i in range(0, n):
        mat1 = 2 * np.random.rand(size, size)
        mat2 = 1 * np.random.rand(size, size)
        mat3 = matmul_func(mat1, mat2)
    return mat3[0, 0]


def cli():
    argp = ArgumentParser(description="cli script to run some matrix multiplications of square matrices with a given size and random numbers")
    argp.add_argument("-n", type=int, default=100, help="amount of matrix multiplications to do")
    argp.add_argument("-s", type=int, default=100, help="size of the matrices to multiply (s x s)")

    args = argp.parse_args(sys.argv[1:])

    print(f"latest value: {run_fast(n=args.n, size=args.s)}")


if __name__ == "__main__":
    # value = run_fast()
    # print(f"latest value: {value}")
    cli()
