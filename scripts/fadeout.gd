extends Control

@export var fade_time := 1.0  # seconds

func _ready():
	modulate.a = 1.0  # full opacity
	# Tween from 1 → 0 opacity over fade_time, then queue_free
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_time)
	tween.tween_callback(self.queue_free)
	tween.tween_callback(TalkerCS.skip_cs_prompt_gone)

func _process(delta: float) -> void:
	$VHS.visible = DialogueManagerExampleBalloon.doing_force_finish
	if DialogueManagerExampleBalloon.doing_force_finish:
		if not $VHS/AudioStreamPlayer2D.playing:
			$VHS/AudioStreamPlayer2D.play()
	else:
		$VHS/AudioStreamPlayer2D.stop()
	
		
