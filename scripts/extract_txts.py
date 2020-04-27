#!/usr/bin/env python3

import csv
import sys
import re
import os


datere = re.compile('(?P<dd>[0-3][0-9])/(?P<mm>[01][0-9])/(?P<yyyy>[12][0-9][0-9][0-9])')
csv.field_size_limit(sys.maxsize)

with open(sys.argv[1], 'r') as csvfile:
    reader = csv.DictReader(csvfile, doublequote=True)
    for row in reader:
        d = re.match(datere, row['date'])
        if d:
            datestr = '{0}-{1}-{2}'.format(d.group('yyyy'), d.group('mm'), d.group('dd'))
        else:
            datestr = 'nodate'
        filename = 'c{0}.{1}.{2}.txt'.format(row['convocation'], row['session'], datestr)
        with open(os.path.join(sys.argv[2], filename), 'w') as txtfile:
            txtfile.write(row['test'])
            
