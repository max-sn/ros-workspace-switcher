#!/usr/bin/python3

import sys
import os


def completion_hook(cmd, curr_word, prev_word):
    potential_matches = [d[:-3] for d in os.listdir(os.getenv('HOME'))
                         if d.endswith('_ws')] + ['-h']
    return [k for k in potential_matches
            if k.lower().startswith(curr_word.lower())]


if __name__ == "__main__":
    matches = completion_hook(*sys.argv[1:])
    if matches:
        print("\n".join(matches))
