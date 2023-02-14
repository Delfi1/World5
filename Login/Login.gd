extends Control

var Account = Network.Account.new()

@onready
var Request = $HTTPRequest

var WebAPIKey = "AIzaSyAWHS5A70xTul-YML2ZWH7lntxeOxUn7XQ"

var LoginUrl = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=%s" % WebAPIKey

func _ready():
	Data.load_data(Data.account_path)
	if Data.current_data.is_empty():
		print("restore..")
		Data.reset_data()
	
	Data.load_data(Data.account_path)
	$Foreground/Remember.button_pressed = Data.current_data["remember"]
	
	$Foreground/AutoLogin.button_pressed = Data.current_data["AutoLogin"]
	
	if $Foreground/Remember.button_pressed:
		$Foreground/EmailText.text = Data.current_data["email"]
		$Foreground/PasswordText.text = Data.current_data["password"]
		if $Foreground/AutoLogin.button_pressed:
			_on_login_button_pressed()
	else:
		Data.current_data["remember"] = false
		Data.current_data["AutoLogin"] = false
		Data.reset_data()

func _on_login_button_pressed():
	
	$Foreground/LoginButton.disabled = true
	
	Data.current_data["remember"] = $Foreground/Remember.button_pressed
	Data.current_data["AutoLogin"] = $Foreground/AutoLogin.button_pressed
	
	var email = $Foreground/EmailText.text
	
	var password = $Foreground/PasswordText.text
	
	Account.login(LoginUrl, Request, email, password)
	


func clear():
	$Foreground/EmailText.text = ''
	$Foreground/PasswordText.text = ''


func _process(delta):
	if Account.IsConnected():
		var error = get_tree().change_scene_to_file("res://Main/main.tscn")
		
		if error != OK:
			printerr(error)
	
	$Foreground/AutoLogin.disabled = not $Foreground/Remember.button_pressed


func _on_Login(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code != 200:
		clear()
		OS.alert(str(response.error), "Error")
		$Foreground/LoginButton.disabled = false
		return
		
	print(response)
	
	get_tree().change_scene_to_file("res://Main/main.tscn")

