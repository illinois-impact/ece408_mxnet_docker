import fileinput
import sys

for line in fileinput.input():
    if line.startswith("====ECE408FORWARD===="):
        pass
    else:
        print line,
    sys.stdout.flush()
