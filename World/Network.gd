extends Node


class Account:
	
	func login(url, Request : HTTPRequest, email: String, password: String):
		if len(password) < 8:
			OS.alert("Password must be 8 or more characters long")
			return
		
		var JsonObject = JSON.new()
		var body = JsonObject.stringify({'email' : email, 'password' : password})
		
		var headers = ['Connect-Type: application/json']
		
		await Core.Firebase(url, Request, body, headers)
	
	
	func Get_Username():
		pass
	
	func Get_ID():
		pass
	
	func IsConnected():
		pass


class Groups:
	pass


class Friends:
	pass


class Server:
	pass
