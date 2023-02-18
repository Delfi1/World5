extends Control


func _on_info_pressed():
	if $ProfileWindow != null:
		return
	var window = preload("res://Main/ProfileWindow.tscn").instantiate()
	self.add_child(window)


func _on_close_pressed():
	get_tree().change_scene_to_file("res://Main/main.tscn")
	#get_parent().visible = false


func _on_friends_pressed():
	if $FriendsWindow != null:
		return
	var window = preload("res://Forum/Friends/FriendsWindow.tscn").instantiate()
	self.add_child(window)
