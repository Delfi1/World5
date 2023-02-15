extends Control

var ForumWindow = preload("res://Forum/ForumWindow.tscn").instantiate()

@onready
var Account = Network.Account.new()

@onready
var Server = Network.Server.new()

func _ready():
	get_viewport().set_embedding_subwindows(false)
	
	if not Account.IsConnected():
		print("You are not connected!")
		get_tree().change_scene_to_file("res://Login/Login.tscn")
		return
	
	save_version()
	
	$LVersion.text += Core.Version
	
	$Game.disabled = true
	print("\n\nUUID: %s" % Core.UUID)
	
	Server.Check_Update($CheckRequest)

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
	open_window(ForumWindow)
	ForumWindow.min_size = Vector2i(800, 500)
	ForumWindow.max_size = Vector2i(get_viewport().size.x, get_viewport().size.y)


func Profile():
	if Core.Username != null:
		if len(Core.Username) > 4:
			return
		
		var ChangeProfile = preload("res://Main/ChangeProfile.tscn").instantiate()
		self.add_child(ChangeProfile)
	else:
		var ChangeProfile = preload("res://Main/ChangeProfile.tscn").instantiate()
		self.add_child(ChangeProfile)


func save_version():
	
	var path = OS.get_executable_path().get_base_dir() + "\\Version.txt"
	
	print(path)
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	file.store_string(Core.Version)


func _on_request_completed(result, response_code, headers, body):
	var response = body.get_string_from_utf8()
	
	if response_code != 200:
		return
	
	if Core.Version != response:
		OS.alert("Find new version!", "Updater")
		
		var path1 = OS.get_executable_path().get_base_dir() + "\\World.pck"
		var path2 = OS.get_executable_path().get_base_dir() + "\\World_save.pck"
		
		Server.Update($UpdateRequest, path1, path2)
		return
	
	Profile()
	


func _on_update_completed(result, response_code, headers, body):
	if response_code != 200:
		OS.alert("Error")
		var path1 = OS.get_executable_path().get_base_dir() + "\\World.pck"
		var path2 = OS.get_executable_path().get_base_dir() + "\\World_save.pck"
		
		var dir = DirAccess.remove_absolute(path1)
		
		var dir2 = DirAccess.rename_absolute(path2, path1)
		return
	
	var path = OS.get_executable_path().get_base_dir() + "\\World_save.pck"
	
	var dir = DirAccess.remove_absolute(path)
	
	OS.alert("Update was installed!", "Updater")
	get_tree().quit()
