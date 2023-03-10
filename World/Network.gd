extends Node


class Account:
	
	func login(Request : HTTPRequest, email: String, password: String):
		if len(password) < 8:
			OS.alert("Password must be 8 or more characters long")
			return
		
		if IsConnected():
			print("You alredy Login!")
			return
		
		
		Data.current_data["email"] = email
		Data.current_data["password"] = password
		
		print(Data.current_data["email"])
		print(Data.current_data["password"])
		
		Data.save_data(Data.account_path)
		
		var body = JSON.stringify({'email' : email, 'password' : password})
		
		var headers = ['Connect-Type: application/json']
		
		Core.Firebase(Core.LoginUrl, Request, body, headers)


	func signup(Request : HTTPRequest, email: String, password: String):
		if len(password) < 8:
			OS.alert("Password must be 8 or more characters long")
			return
		
		if IsConnected():
			print("You alredy Login!")
			return
		
		
		Data.current_data["email"] = email
		Data.current_data["password"] = password
		
		Data.save_data(Data.account_path)
		
		var body = JSON.stringify({'email' : email, 'password' : password})
		
		var headers = ['Connect-Type: application/json']
		
		Core.Firebase(Core.SignUpUrl, Request, body, headers)


	func Change_Username(Username : String, Request : HTTPRequest):
		if len(Username) < 4:
			print("The name must be more than 4 characters long.")
			return
		
		
		var body = JSON.stringify({"idToken":Core.idToken, "displayName": Username, "returnSecureToken":false })
		var headers = ['Connect-Type: application/json']
		
		Core.Firebase(Core.ChangeUrl, Request, body, headers)
		
		

	func LoadSaveUser():
		pass


	func IsConnected():
		return Core.UUID != null


class Groups:
	pass


class Friends:
	func load_list():
		var headers = [
			"Content-Type: application/json",
			"Authorization: Bearer %s" % Core.idToken
		]
		pass
	


class Server:
	func Check_Update(Request : HTTPRequest):
		print("Check for updates...")
		Request.request(Core.VerUrl)
	
	func Update(Request : HTTPRequest, path1, path2):
		
		DirAccess.rename_absolute(path1, path2)
		
		Request.set_download_file("World.pck")
		Request.request(Core.PckUrl)
	
