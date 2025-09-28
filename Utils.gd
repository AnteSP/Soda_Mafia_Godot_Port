extends Button

func _enter_tree() -> void:
	pressed.connect(_on_button_pressed)

func _exit_tree() -> void:
	pressed.disconnect(_on_button_pressed)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://playable.tscn")
