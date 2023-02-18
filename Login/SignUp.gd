extends Control

var Account = Network.Account.new()

@onready
var Request = $HTTPRequest


func _on_login_button_pressed():
	
	$Foreground/Return.disabled = true
	$Foreground/SignUpButton.disabled = true
	
	Data.reset_data()
	
	Data.current_data["remember"] = $Foreground/Remember.button_pressed
	Data.current_data["AutoLogin"] = $Foreground/AutoLogin.button_pressed
	
	var email = $Foreground/EmailText.text
	
	var username = $Foreground/UsernameText.text
	
	var password = $Foreground/PasswordText.text
	
	if len(username) < 4:
		print("The name must be more than 4 characters long.")
		return
	
	Account.signup(Request, email, password)
	


func clear():
	$Foreground/EmailText.text = ''
	$Foreground/PasswordText.text = ''


#func _process(delta):
#	if Account.IsConnected():
#		var error = get_tree().change_scene_to_file("res://Main/main.tscn")
#
#		if error != OK:
#			printerr(error)
#
#	$Foreground/AutoLogin.disabled = not $Foreground/Remember.button_pressed


func _on_Login(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code != 200:
		clear()
		OS.alert("Can't connect to server! " + str(response), "Error")
		printerr(result, headers)
		$Foreground/SignUpButton.disabled = false
		$Foreground/Return.disabled = false
		return
		
	print(response)
	
	Core.UUID = response["localId"]
	
	Core.idToken = response["idToken"]
	
	var username = $Foreground/UsernameText.text
	
	Account.Change_Username(username, $Username)

func Username():
	pass

func _on_return_pressed():
	get_tree().change_scene_to_file("res://Login/Login.tscn")


func _on_username_request_completed(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code != 200:
		print(result, headers)
		OS.alert(str(response.error), "Error")
		return
	
	
	print(response)
	Core.Username = response["displayName"]
	Core.UUID = response["localId"]
	var error = get_tree().change_scene_to_file("res://Main/main.tscn")
	
	if error != OK:
		printerr(error)
