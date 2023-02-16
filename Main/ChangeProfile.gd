extends Control

@onready
var Account = Network.Account.new()

@onready
var Info = $BackGround/ForeGround/Info

@onready
var PasswordCheck = $BackGround/ForeGround/PasswordCheck

@onready
var UsernameCheck = $BackGround/ForeGround/UsernameCheck

@onready
var SaveButton = $BackGround/ForeGround/SaveButton

func _input(event):
	if Core.Username == null:
		return
	
	if not len(Core.Username) > 4:
		return
	
	if event.is_action("escape"):
		self.queue_free()

func _ready():
	
	if Core.stats != null:
		Info.text = "Username: '%s' \nEmail: '%s' \nCreatedAt: '%s' \nLastLoginAt: '%s' \nUUID: '%s'" % Core.stats
	
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
	
	Core.stats = stats
	
	Info.text = "Username: '%s' \nEmail: '%s' \nCreatedAt: '%s' \nLastLoginAt: '%s' \nUUID: '%s'" % stats
	
	Core.Username = user["displayName"]


func _on_button_pressed():
	SaveButton.disabled = true
	var Username = $BackGround/ForeGround/UsernameText.text
	
	if len(Username) > 4 and UsernameCheck.button_pressed:
		SaveButton.disabled = false
		
		Account.Change_Username(Username, $BackGround/ForeGround/Save)
	elif len(Username) <= 4 and UsernameCheck.button_pressed:
		OS.alert("Username must be more than 4 characters!", "Error")
		
		SaveButton.disabled = false
	
	var password = $BackGround/ForeGround/PasswordText.text
	
	if PasswordCheck.button_pressed and len(password) >= 8:
		print("Change password...")
	elif PasswordCheck.button_pressed and len(password < 8):
		OS.alert("Password must be 8 or more characters long")
		

func _on_save_completed(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code != 200:
		print(result, headers)
		OS.alert(str(response.error), "Error")
		SaveButton.disabled = false
		return
	
	
	print(response)
	Core.Username = response["displayName"]
	Core.UUID = response["localId"]
	SaveButton.disabled = false
	get_parent().queue_free()

func _process(delta):
	Choosen(UsernameCheck, $BackGround/ForeGround/UsernameText)
	Choosen(PasswordCheck, $BackGround/ForeGround/PasswordText)
	

func Choosen(Check : CheckBox,Line : LineEdit):
	Check.button_pressed = (len(Line.text) > 1)


func _on_profile_window_close_requested():
	if len(Core.Username) <= 4:
		return
	
	get_parent().queue_free()
