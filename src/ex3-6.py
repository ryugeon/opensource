#!/usr/bin/env python3

import sys


def main(argv):
    args = argv[1:]
    if len(args) < 2:
        print(f"Error: at least 2 arguments required, got {len(args)}.", file=sys.stderr)
        print(f"Usage: {argv[0]} arg1 arg2 [arg3 ...]", file=sys.stderr)
        return 2

    print("=== Program Start ===")
    print(f"Number of arguments: {len(args)}")
    for i, a in enumerate(args, start=1):
        print(f"arg{i}: {a}")
    print("=== Program End ===")
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
