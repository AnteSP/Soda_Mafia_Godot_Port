extends Node2D

class_name Interactable
@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var has_use_anim: bool = animated_sprite and $AnimatedSprite2D.sprite_frames.has_animation("Use")
@onready var has_use_audio: bool = get_node_or_null("AudioStreamPlayer") != null

@export var use_time: float = 0
@export var item_get: InvItem
@export var invis_player_while_using: bool = false
@export var always_in_focus: bool = false
@export var fun_threshold: int = 0
#MIN-MAX    [XXYY]XX is min YY is max. 2 digit number means max only. XX99 means min only [1-4 digit num]
#EVEN/ODD   [11111]Means even [22222]Means odd [33333]Means %10 [44444] Angel
var use_len: float = 0

static func fun_threshold_to_true_value(fun_t: int) -> bool:
	if fun_t < 9999:#MIN-MAX
		var max_val = fun_t%100
		@warning_ignore("integer_division")
		var min_val = fun_t/100
		if fun_t < 1000:# one digit min. 2 digit max XYY
			max_val = fun_t%10
			@warning_ignore("integer_division")
			min_val = fun_t/10
		if fun_t < 100:#only max YY
			max_val = fun_t
			min_val = 0
		return stats.fun_value > min_val and stats.fun_value < max_val
	elif fun_t == 11111:#ODD
		return stats.fun_value%2 == 1
	elif fun_t == 22222:#EVEN
		return stats.fun_value%2 == 0
	elif fun_t == 33333:
		return stats.fun_value%10 == 0
	elif fun_t == 44444:
		@warning_ignore("integer_division")
		return stats.fun_value%10 == stats.fun_value/10
	else:
		return false

func _ready():
	if not fun_threshold_to_true_value(fun_threshold):
		visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
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
