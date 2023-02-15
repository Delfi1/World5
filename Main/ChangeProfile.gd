extends Control

@onready
var Account = Network.Account.new()

@onready
var Info = $BackGround/ForeGround/Info

func _input(event):
	if Core.Username == null:
		return
	
	if not len(Core.Username) > 4:
		return
	
	if event.is_action("escape"):
		self.queue_free()

func _ready():
	if not Account.IsConnected():
		print("You are not connected!")
		get_tree().change_scene_to_file("res://Login/Login.tscn")
		return
	
	var body = JSON.stringify({"idToken": Core.idToken})
	
	var headers = ['Connect-Type: application/json']
	
	Core.Firebase(Core.GetData, $Get, body, headers)


func _on_request_completed(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code != 200:
		print(result, headers)
		OS.alert(str(response.error), "Error")
		return
	
	var user = response["users"][0] 
	
	change_info(user)

func change_info(user : Dictionary):
	
	if not user.has("displayName"):
		OS.alert("Please enter username", "Alert")
		Info.text = "Username: "
		
		return
	
	var stats = [user["displayName"], user["email"], user["createdAt"], user["lastLoginAt"], Core.UUID]
	
	Info.text = "Username: '%s' \nEmail: '%s' \nCreatedAt: '%s' \nLastLoginAt: '%s' \nUUID: '%s'" % stats
	
	Core.Username = user["displayName"]


func _on_button_pressed():
	
	var Username = $BackGround/ForeGround/UsernameText.text
	
	Account.Change_Username(Username, $BackGround/ForeGround/Save)


func _on_save_completed(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code != 200:
		print(result, headers)
		OS.alert(str(response.error), "Error")
		return
	
	
	print(response)
	Core.Username = response["displayName"]
	Core.UUID = response["localId"]
	
	self.queue_free()
