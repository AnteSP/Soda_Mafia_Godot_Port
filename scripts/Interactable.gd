extends Node

class_name Interactable
@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var has_use_anim: bool = animated_sprite and $AnimatedSprite2D.sprite_frames.has_animation("Use")
@onready var has_use_audio: bool = get_node_or_null("AudioStreamPlayer") != null

@export var use_time: float = 0
@export var item_get: InvItem
@export var invis_player_while_using: bool = false
@export var always_in_focus: bool = false
var use_len: float = 0


func _ready():
	if animated_sprite and has_use_anim:
		use_len = duration(animated_sprite.sprite_frames,"Use")
		if $AnimatedSprite2D.sprite_frames.get_animation_loop("Use"):
			push_warning("The 'Use' animation on " + name + " has looping enabled! If you keep it like this, it will loop forever when the player uses it")

func Use(_inp):
	if item_get:
		Stats.current.inventory.add_item(item_get,1)
	if use_time != 0:
		$AnimatedSprite2D.play("default")
		player.current.sbp.progress_bar.reset_timer()
		player.current.sbp.reset_spacebar()

func Using_anim():
	if animated_sprite:
		if use_len < use_time:
			if has_use_anim:
				$AnimatedSprite2D.play("Using")
			if has_use_audio:
				$AudioStreamPlayer.play()
			if invis_player_while_using:
				player.current.get_node("AnimatedSprite2D").visible = false
				player.start_stop_movement(false,"tree")
			await get_tree().create_timer(use_time-use_len).timeout
			if has_use_anim:
				$AnimatedSprite2D.play("Use")
			if invis_player_while_using:
				player.current.get_node("AnimatedSprite2D").visible = true
				player.start_stop_movement(true,"tree")
			if has_use_audio:
				$AudioStreamPlayer.stop()
		elif use_time == 0:
			if has_use_anim:
				$AnimatedSprite2D.stop()
				$AnimatedSprite2D.play("Use")
			if has_use_audio:
				$AudioStreamPlayer.play()
		else:#When you need to rush Use animation
			if has_use_anim:
				SetAnimationDuration("Use",use_time)
				$AnimatedSprite2D.play("Use")

func duration(frames: SpriteFrames,animation_name: String):
	return float(frames.get_frame_count(animation_name)) / frames.get_animation_speed(animation_name)

func SetAnimationDuration(animation_name: String, intended_duration: float):
	var frames = animated_sprite.sprite_frames
	var frame_count = frames.get_frame_count(animation_name)
	var animation_speed = frames.get_animation_speed(animation_name)

	animated_sprite.speed_scale = float(frame_count) / (animation_speed * intended_duration)
