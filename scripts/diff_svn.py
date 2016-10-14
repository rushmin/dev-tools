#!/usr/bin/python

import sys
import os

os.system('meld "%s" "%s"' % (sys.argv[6], sys.argv[7]))
