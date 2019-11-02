#!/bin/sh
python -c "
import sys
import json
for _ in map(str.strip, sys.stdin):
 $@
"