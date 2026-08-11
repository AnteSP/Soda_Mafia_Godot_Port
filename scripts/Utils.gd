extends Button

@export var switch_to_scene : PackedScene
@export var screen_material : CanvasItem
@export var mouse_blocked: Control
var flowerwall_node

func _ready():
	# Find the flowerwall_pp node anywhere in the scene
	flowerwall_node = get_tree().root.find_child("flowerwall_crt", true, false)

func _enter_tree() -> void:
	pressed.connect(_on_button_pressed)

func _exit_tree() -> void:
	pressed.disconnect(_on_button_pressed)

func _on_button_pressed() -> void:
	var tweens = [] ; for i in range(18): tweens.append(create_tween())
	get_parent().get_parent().get_parent().get_node("TVSOUND").play()
	# This animates the 'distortion_strength' parameter from 0.0 to 0.5 over 2 seconds
	tweens[0].tween_property(screen_material.material, "shader_parameter/distortion_strength", 0.1, 2)
	tweens[1].tween_property(screen_material.material, "shader_parameter/zoom", 0.9, 2)
	tweens[2].tween_property(flowerwall_node.DITHERING_SHADER,"shader_parameter/downscaling_strength", 1,2)
	tweens[3].tween_property(flowerwall_node.DITHERING_SHADER,"shader_parameter/color_compression",3.8,2)
	tweens[4].tween_property(flowerwall_node.BLURY_SHADER,"shader_parameter/radius", 1,2)
	tweens[5].tween_property(flowerwall_node.BLURX_SHADER,"shader_parameter/radius", 1,2)
	tweens[6].tween_property(flowerwall_node.CRT_SHADER,"shader_parameter/grain_strength", 0.15,2)
	tweens[7].tween_property(flowerwall_node.CRT_SHADER,"shader_parameter/scanline_opacity", 0,2)
	tweens[8].tween_property(flowerwall_node.CRT_SHADER,"shader_parameter/scanline_thickness", 0.1,2)
	tweens[9].tween_property(flowerwall_node.CRT_SHADER,"shader_parameter/scanlines_interval", 0.1 *2,2)
	tweens[10].tween_property(flowerwall_node.CRT_SHADER,"shader_parameter/curve_power", 1.03,2)
	tweens[11].tween_property(flowerwall_node.CRT_SHADER,"shader_parameter/vignette_size", 2,2)
	tweens[12].tween_property(flowerwall_node.CRT_SHADER,"shader_parameter/vignette_smoothness", 0.45,2)
	tweens[13].tween_property(flowerwall_node.CRT_SHADER,"shader_parameter/wiggle", 0.005,2)
	tweens[14].tween_property(flowerwall_node.CRT_SHADER,"shader_parameter/chromatic_aberration_strength", 1,2)
	tweens[15].tween_property(flowerwall_node.CRT_SHADER,"shader_parameter/brightness_multiplier", 1.25,2)
	tweens[16].tween_property(flowerwall_node.BLOOM_SHADER,"shader_parameter/bloom_threshold", 0.18,2)
	tweens[17].tween_property(flowerwall_node.BLOOM_SHADER,"shader_parameter/bloom_intensity", 2,2)
	flowerwall_node.CRT_SHADER.set("shader_parameter/enable_rgb_grid", true)
	await get_tree().create_timer(0.02).timeout
	flowerwall_node._ready()
	#flowerwall_node.should_enable_bloom()
	#flowerwall_node.should_enable_crt()
	#flowerwall_node.should_enable_blur()
	#flowerwall_node.should_enable_dither()

	#flowerwallPP.should_enable_crt()
	#flowerwallPP.should_enable_bloom()
	await tweens[0].finished
	get_tree().change_scene_to_packed(switch_to_scene)

func _on_mouse_entered():
	self_modulate = Color("6ab7ff")
	print("got in")

func _on_mouse_exited():
	self_modulate = Color.WHITE


func _on_button_down() -> void:
	self_modulate = Color("00172dff")


func _on_button_up() -> void:
	self_modulate = Color.WHITE
	mouse_blocked.mouse_filter = Control.MOUSE_FILTER_STOP
