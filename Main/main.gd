extends Control

var ForumWindow = preload("res://Forum/ForumWindow.tscn").instantiate()

var Forum = preload("res://Forum/Forum.tscn")

@onready
var Account = Network.Account.new()

@onready
var Server = Network.Server.new()

var ProfileWindow = preload("res://Main/ProfileWindow.tscn").instantiate()

func _ready():
	get_viewport().set_embedding_subwindows(false)
	
	if not Account.IsConnected():
		print("You are not connected!")
		get_tree().change_scene_to_file("res://Login/Login.tscn")
		return
	
	save_version()
	
	$LVersion.text = "Server Version: Loading...\nLauncher Version: " + str(Core.Version)
	
	$Game.disabled = true
	print("\n\nUUID: %s" % Core.UUID)
	
	Profile()
	
	$Timer.start(10)

func open_window(window : Window):
	if window.visible:
		add_child(window)
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	
	window.visible = true
	print(window.mode)
	window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN

func _on_game_pressed():
	var GameWindow = preload("res://Game/GameWindow.tscn").instantiate()
	open_window(GameWindow)
	GameWindow.min_size = Vector2i(1280, 720)
	GameWindow.max_size = Vector2i(get_viewport().size.x, get_viewport().size.y)
	

func _on_exit_pressed():
	get_tree().quit()


func _on_forum_pressed():
	get_tree().change_scene_to_packed(Forum)
	#open_window(ForumWindow)
	#ForumWindow.min_size = Vector2i(800, 500)
	#ForumWindow.max_size = Vector2i(get_viewport().size.x, get_viewport().size.y)


func Profile():
	if Core.Username == null:
		Core.Username = ""
	if len(Core.Username) > 4:
		return
	
	
	$Timer.queue_free()
	self.add_child(ProfileWindow)


func save_version():
	
	var path = OS.get_executable_path().get_base_dir() + "\\Version.txt"
	var path2 = OS.get_executable_path().get_base_dir() + "\\World.bat"
	
	print(path)
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	file.store_string(Core.Version)
	
	var info = "@echo off \nStart \"\" \"%s/World.exe\"" % OS.get_executable_path().get_base_dir()
	
	file = FileAccess.open(path2, FileAccess.WRITE)
	
	file.store_string(info)
	


func _on_request_completed(result, response_code, headers, body):
	var response = body.get_string_from_utf8()
	
	if response_code != 200:
		print(result, headers)
		return
	
	$LVersion.text = "Server Version: " + str(response)
	$LVersion.text += "\nLauncher Version: " + str(Core.Version)
	
	var ver = int(Core.Version[0]) * 1000 + int(Core.Version[2]) * 100 + int(Core.Version[4]) * 10 + int(Core.Version[6])
	
	var server_ver = int(response[0]) * 1000 + int(response[2]) * 100 + int(response[4]) * 10 + int(response[6])
	
	print("Ver: '%s'\nServer_Ver: '%s'" % [ver, server_ver])
	
	if ver < server_ver:
		OS.alert("Find new version: %s !" % response, "Updater")
		
		var path1 = OS.get_executable_path().get_base_dir() + "\\World.pck"
		var path2 = OS.get_executable_path().get_base_dir() + "\\World_save.pck"
		
		Server.Update($UpdateRequest, path1, path2)
		return
	


func _on_update_completed(result, response_code, headers, body):
	if response_code != 200:
		print(result, headers, body)
		OS.alert("Error " + response_code)
		var path1 = OS.get_executable_path().get_base_dir() + "\\World.pck"
		var path2 = OS.get_executable_path().get_base_dir() + "\\World_save.pck"
		
		DirAccess.remove_absolute(path1)
		
		DirAccess.rename_absolute(path2, path1)
		
		return
	
	save_version()
	
	var path = OS.get_executable_path().get_base_dir() + "\\World_save.pck"
	
	DirAccess.remove_absolute(path)
	
	OS.alert("Update was installed! Restarting...", "Updater")
	get_tree().quit()
	
	var path2 = OS.get_executable_path().get_base_dir() + "\\World.bat"
	
	OS.execute(path2, [])


func _on_timer_timeout():
	$Timer.stop()
	Server.Check_Update($CheckRequest)
	$Timer.start(60)
