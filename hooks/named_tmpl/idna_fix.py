#coding: utf-8

import sys

for line in sys.stdin.readlines():
    print unicode(line.strip(), 'utf-8').encode('idna')
