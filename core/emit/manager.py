#!/usr/bin/env python

class Issue:
	def save(self):
		pass

class Tracker:
	version = '0.0-git'
	
	def createIssue(self):
		return Issue()
