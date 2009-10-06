#!/usr/bin/env python

class Persistent:
	issueid = None
	def save(self):
		pass

class Issue(Persistent):

class Tracker:
	version = '0.0-git'
	
	def createIssue(self):
		return Issue()
