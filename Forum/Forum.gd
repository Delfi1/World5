extends Control


func _on_info_pressed():
	var ChangeProfile = preload("res://Main/ProfileWindow.tscn").instantiate()
	self.add_child(ChangeProfile)
	ChangeProfile.popup()


func _on_close_pressed():
	get_tree().change_scene_to_file("res://Main/main.tscn")
	#get_parent().visible = false
