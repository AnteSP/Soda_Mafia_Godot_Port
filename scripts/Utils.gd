extends Button

@export var switch_to_scene : PackedScene

func _enter_tree() -> void:
	pressed.connect(_on_button_pressed)

func _exit_tree() -> void:
	pressed.disconnect(_on_button_pressed)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(switch_to_scene)
