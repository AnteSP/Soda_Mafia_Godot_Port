extends Node

#use this for static shit. stats keyword is for autoload singleton
class_name Stats

static var current
@export var bg_music: AudioStreamPlayer2D
@export var ambient: AudioStreamPlayer2D
static var start_scene_on_transition: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	
func DO_NOT_USE():
	var new_transition = get_node_or_null("Transition/Transition/AnimationPlayer")
	if new_transition and start_scene_on_transition:
		print("ATTEMPTING RECONNECTING ANIM" , get_node("Transition"))
		get_node("Transition").visible = true
		new_transition.play("Start_CS")
		new_transition.seek(new_transition.get_animation("Start_CS").length-0.9)
		new_transition.speed_scale = -1
		start_scene_on_transition = false
		get_node_or_null("Transition/Transition/RichTextLabel").text = "Byebye cutscene :3"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func bg_music_change(to: float, period: float, new_track: String = "") -> void:
	if new_track == "NONE":
		current.bg_music.stream = null
	elif new_track != "":
		current.bg_music.stream = load("res://sound/" + new_track)
		current.bg_music.play()
	create_tween().tween_property(current.bg_music, "volume_db", to, period)
	pass

func ambient_music_change(to: float, period: float) -> void:
	create_tween().tween_property(current.ambient, "volume_db", to, period)
	pass
