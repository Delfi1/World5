extends Window

var start

func _input(event):
	if event.is_action_pressed("F11"):
		change_window_fullscreen(self)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func change_window_fullscreen(window : Window):
	if window.mode == MODE_EXCLUSIVE_FULLSCREEN:
		window.mode = Window.MODE_MAXIMIZED
	else:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN


func _on_close_requested():
	self.queue_free()
