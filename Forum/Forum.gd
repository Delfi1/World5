extends Control


func _on_info_pressed():
	var ChangeProfile = preload("res://Main/ChangeProfile.tscn").instantiate()
	self.add_child(ChangeProfile)


func _on_close_pressed():
	get_parent().visible = false
