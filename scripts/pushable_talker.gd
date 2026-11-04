extends Talker
@export var push_speed_reduction: float= 0 #can be 0 for no pushing to 1 for maintaining push speed when pushing
@export var item_to_crush_prefix: String = ""
var moving: bool = false
var OG_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_node(".") is not RigidBody2D:
		push_warning(name + " is pushable and needs to be a rigidbody2D but it doesnt")

func _physics_process(_delta: float) -> void:
	
	if OG_position != self.position and not moving and push_speed_reduction != 0:
		player.current.change_speed(push_speed_reduction,name)
		moving = true
	
	if OG_position == self.position and moving:
		player.current.change_speed(-1,name)
		moving = false
	OG_position = self.position
	
	for body in get_node(".").get_colliding_bodies():
		if body.name.begins_with(item_to_crush_prefix) and not body.name.ends_with("_crushed"):
			var new_name: String = body.name + "_crushed"
			body.get_parent().get_node(new_name).visible = true
			body.get_parent().get_node(new_name).process_mode = PROCESS_MODE_INHERIT
			body.queue_free()
			
