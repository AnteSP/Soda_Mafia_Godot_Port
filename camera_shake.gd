extends Node
class_name CameraShake

@export var shake_amount: float = 1.0
@export var decrease_factor: float = 1.0

var shake_duration := 0.0
var _start_duration := 0.0

func start(duration: float,shake_amount_override: float = shake_amount, decrease_factor_override: float = decrease_factor):
	shake_duration = duration
	shake_amount = shake_amount_override
	decrease_factor = decrease_factor_override
	_start_duration = duration
	set_process(true)

func stop():
	shake_duration = 0

func get_offset() -> Vector2:
	if shake_duration <= 0.0:
		return Vector2.ZERO

	var strength := shake_amount * (shake_duration / _start_duration)
	return Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	) * strength

func _process(delta):
	shake_duration -= delta * decrease_factor
	if shake_duration <= 0.0:
		shake_duration = 0.0
		set_process(false)
