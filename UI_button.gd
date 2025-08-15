extends TextureButton

@export var target_node: NodePath 
@export var alt_norm: Texture2D
@export var alt_hover: Texture2D
var norm_text
var hover_text
var target_visible := false


func _ready():
	# Initialize target visibility
	if has_node(target_node):
		get_node(target_node).visible = target_visible
		norm_text = texture_normal
		hover_text = texture_hover
		

func _on_pressed():
	# Toggle button texture (alternative method if not using built-in textures)
	#texture_normal = texture_pressed
	
	# Toggle target visibility
	if has_node(target_node):
		target_visible = !target_visible
		get_node(target_node).visible = target_visible
		texture_normal = alt_norm if target_visible else norm_text
		texture_hover = alt_hover if target_visible else hover_text
	
	# Optional: Play sound effect
	$AudioStreamPlayer.play()
