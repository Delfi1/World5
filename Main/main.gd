extends Control

var ForumWindow = preload("res://Forum/ForumWindow.tscn").instantiate()

func _ready():
	$Game.disabled = true
	get_viewport().set_embedding_subwindows(false)
	print("\n\nUUID: %s" % Core.UUID)

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
	
