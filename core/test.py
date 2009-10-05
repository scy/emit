#!/usr/bin/env python

import emit.manager
import re
import unittest

class TrackerTests(unittest.TestCase):
	def setUp(self):
		self.instance = emit.manager.Tracker()
	
	def testVersion(self):
		self.assertTrue(re.match('^0\.0-git$', self.instance.version),
			'Tracker.version is strange.')

class CreateTests(unittest.TestCase):
	def setUp(self):
		self.instance = emit.manager.Tracker()
	
	def testCreate(self):
		self.assertTrue(isinstance(self.instance.createIssue(), emit.manager.Issue))

# If we have been called directly (not imported), run the test.
if __name__ == '__main__':
	unittest.main()
