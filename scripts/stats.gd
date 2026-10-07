extends Node

#use this for static shit. stats keyword is for autoload singleton
class_name Stats

static var current
@export var bg_music: AudioStreamPlayer2D
@export var ambient: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func bg_music_change(to: float, period: float, new_track: String = "") -> void:
	if new_track != "":
		current.bg_music.stream = load("res://sound/" + new_track)
		current.bg_music.play()
	elif new_track == "NONE":
		current.bg_music.stream = null
	create_tween().tween_property(current.bg_music, "volume_db", to, period)
	pass

func ambient_music_change(to: float, period: float) -> void:
	create_tween().tween_property(current.ambient, "volume_db", to, period)
	pass
