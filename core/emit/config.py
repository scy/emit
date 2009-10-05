#!/usr/bin/env python

class Config:
	# Default values.
	datadir = os.path.join(os.path.expanduser('~'), '.emit')
	file = os.path.join(datadir, 'config.py')
