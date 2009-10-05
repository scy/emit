#!/usr/bin/env python

import frqbt.manager
import re
import unittest

class TrackerTests(unittest.TestCase):
	
	def setUp(self):
		self.instance = frqbt.manager.Tracker()
	
	def testVersion(self):
		self.assertTrue(re.match('^0\.0-git$', self.instance.version),
			'Tracker.version is strange.')

# If we have been called directly (not imported), run the test.
if __name__ == '__main__':
	unittest.main()
