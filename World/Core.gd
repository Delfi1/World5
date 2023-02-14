extends Node

var Version = "0.0.1"

var UUID = null

var Username = null

var WebAPIKey = "AIzaSyAWHS5A70xTul-YML2ZWH7lntxeOxUn7XQ"

var LoginUrl = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=%s" % WebAPIKey

var SignUpUrl = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=%s" % WebAPIKey


func Firebase(url, Request : HTTPRequest, body, headers):
	var error = Request.request(url, headers, HTTPClient.METHOD_POST, body)
	
	if error != OK:
		print(error, "Error")
	
