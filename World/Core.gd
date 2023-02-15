extends Node

var Version = "0.0.6"

var UUID = null

var idToken = null

var Username = null

var WebAPIKey = "AIzaSyAWHS5A70xTul-YML2ZWH7lntxeOxUn7XQ"

var projectId = "deworld-a346b"

var FirestoneUrl = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/Users/" % projectId

var LoginUrl = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=%s" % WebAPIKey

var SignUpUrl = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=%s" % WebAPIKey

var ChangeUrl = "https://identitytoolkit.googleapis.com/v1/accounts:update?key=%s" % WebAPIKey

var GetData = "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=%s" % WebAPIKey

var VerUrl = "https://raw.githubusercontent.com/Delfi1/World5/master/Export/version.txt"

var PckUrl = "https://github.com/Delfi1/World5/blob/master/Export/World.pck?raw=true"


func Firebase(url, Request : HTTPRequest, body, headers):
	var error = Request.request(url, headers, HTTPClient.METHOD_POST, body)
	
	if error != OK:
		printerr(error)

