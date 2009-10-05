#!/usr/bin/env python

import emit.com.http.common
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

class HTTPSplitTests(unittest.TestCase):
	def setUp(self):
		self.h = emit.com.http.common.RequestHandler()
	
	def testSimple(self):
		r = self.h.split("GET / HTTP/1.1\nHost: foo.example\n\n")
		self.assertEqual(r, ('GET / HTTP/1.1', 'Host: foo.example', ''))
		self.assertEqual(self.h.headerfields(r[1]), [('Host', 'foo.example')])
	
	def testConfused(self):
		r = self.h.split("POST / HTTP/1.1\nHost: foo.example\r\nContent^Type: \t schnitzel\n\r\nWiener")
		self.assertEqual(r, ('POST / HTTP/1.1', "Host: foo.example\r\nContent^Type: \t schnitzel", 'Wiener'))
		self.assertEqual(self.h.headerfields(r[1]), [('Host', 'foo.example'), ('Content^Type', 'schnitzel')])
	
	def testEvil(self):
		r = self.h.split("POST / HTTP/1.1\r\nHost: foo.example\r\r\nContent-Type: \0pizza\r\n\r\r\r\n\rchef\r\n\npwned\r\n")
		self.assertEqual(r, ('POST / HTTP/1.1', "Host: foo.example\r\r\nContent-Type: \0pizza\r\n\r\r\r\n\rchef", "pwned\r\n"))
		self.assertRaises(emit.com.http.common.InvalidRequestError, self.h.headerfields, r[1])

class HTTPHeaderFieldTests(unittest.TestCase):
	def setUp(self):
		self.h = emit.com.http.common.RequestHandler()
	
	def testSimple(self):
		self.assertEqual(self.h.headerfields(self.h.split("GET / HTTP/1.1\nHost: foo.example\n\n")[1]),
			[('Host', 'foo.example')])
	
	def testEvil(self):
		self.assertEqual(self.h.split("POST / HTTP/1.1\r\nHost: foo.example\r\r\nContent-Type: \0pizza\r\n\r\r\r\n\rchef\r\n\npwned\r\n"),
			('POST / HTTP/1.1', "Host: foo.example\r\r\nContent-Type: \0pizza\r\n\r\r\r\n\rchef", "pwned\r\n"))


# If we have been called directly (not imported), run the test.
if __name__ == '__main__':
	unittest.main()
