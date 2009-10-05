#!/usr/bin/env python

import re

class InvalidRequestError(ValueError):
	pass

class RequestHandler:
	def split(self, request):
		(action, rest) = re.split("\r?\n", request, 1)
		(header, body) = re.split("\r?\n\r?\n", rest, 1)
		return (action, header, body)
	
	def headerfields(self, header):
		joined = re.sub("(\r?\n)?[ \t]+", ' ', header)
		lines = re.split("\r?\n", joined)
		fields = []
		for line in lines:
			match = re.match('^([!#$-\'*+.0-9A-Z^_`a-z|~-]+):[ \t](.*)$', line)
			if match == None:
				raise InvalidRequestError('Invalid header line.')
			fields.append((match.group(1), match.group(2)))
		return fields
	
	def handle(self, request):
		(action, header, body) = split(request)
