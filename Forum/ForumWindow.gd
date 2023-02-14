extends Window


func _input(event):
	if event.is_action_pressed("F11"):
		change_window_fullscreen(self)
	
	if event.is_action_pressed("escape") and self.visible:
		_on_close_requested()
	


func change_window_fullscreen(window : Window):
	if window.mode == MODE_EXCLUSIVE_FULLSCREEN:
		window.mode = Window.MODE_MAXIMIZED
	else:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN


func _on_close_requested():
	self.visible = false

func show_window(window : Window):
	window.visible = false
	window.position = get_mouse_position()
	window.visible = true
