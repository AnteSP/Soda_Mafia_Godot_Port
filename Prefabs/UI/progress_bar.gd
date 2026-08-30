extends Control

signal progress_completed

@onready var fill: ColorRect = $Fill
@onready var timer: Timer = $Timer

var progress_duration: float = 0.0
var cached_interactable: Interactable
var original_material = null

func _ready() -> void:
	if original_material == null:
		original_material = fill.material
	self.visible = false

func start_progress(duration: float, interactable: Interactable):
	cached_interactable = interactable
	if duration == 0:
		_on_timer_timeout()
		return
	
	self.visible = true
	progress_duration = duration
	fill.material = original_material
	fill.material.set("shader_parameter/progress", 0.0)
	timer.wait_time = duration
	timer.start()
	
	# Create tween for smooth progress animation
	var tween = create_tween()
	tween.tween_method(_update_progress, 0.0, 1.0, duration)

func _update_progress(value: float):
	if fill.material != null:
		fill.material.set("shader_parameter/progress", value)

func _on_timer_timeout():
	emit_signal("progress_completed")
	cached_interactable.Use(1)
	#queue_free()

func reset_timer():
	timer.stop()
	fill.material = null
	self.visible = false
