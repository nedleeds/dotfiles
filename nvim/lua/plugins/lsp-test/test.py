"""test python script for checking lint, formmating and debugging"""

import os
import time

n_time = time.time()

try:
    pass
except IOError as e:
    print(f"{e}")
except NameError as e:
    print(f"{e}")
else:
    pass


def hello() -> None:
    """test hello func"""
    return None


X = 0


def check_func() -> bool:
    """test function to check"""
    for _ in range(3):
        for _ in range(2):
            pass
    # x = 1
    a = 123
    print(a)
    return True


if __name__ == "__main__":
    print(f"{os.getcwd()}")

    a = [i for i in range(10)]
    b = a[-3]
    c = a[-3:-1]

    check_func()

    print(f"{time.time() - n_time} has been spent.")
    print(f"{time.time() - n_time} has been spent.")
    print(f"{time.time() - n_time} has been spent.")
