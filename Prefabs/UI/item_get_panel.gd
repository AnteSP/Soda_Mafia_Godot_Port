extends TextureRect


var ref: TextureRect
var stay_len: float = 2
var dif
var starting_y: float = 999999
var starting_x: float = 999999
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if starting_y == 999999:
		starting_y = position.y
	if starting_x == 999999:
		starting_x = position.x
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if position.x > ref.position.x and stay_len > 0:
		#print("ENTERING pos: " , position.x , "ref x: " , ref.position.x)
		position.x -= dif/10
		return
	if stay_len > 0:
		#print("STAYING pos: " , position.x , "ref x: " , ref.position.x , "stay_len : " , stay_len)
		position.x = ref.position.x
		stay_len -= delta
		return
	position.x += dif/40
	#print("WITHDRAWING pos: " , position.x , "ref x: " , ref.position.x, "stay_len : " , stay_len)
	if position.x > ref.position.x + dif:
		process_mode = Node.PROCESS_MODE_DISABLED
		stay_len = 2
		name = name.replace("anim","ready")
		
func start_anim(item_name: String,item_text: Texture,quantity: int = 1):
	name = name.replace("ready","anim")
	position.y = starting_y
	position.x = starting_x
	get_node("Title").text = item_name
	get_node("Item_Frame").get_node("Item_Frame2").texture = item_text
	if quantity == 1:
		get_node("Quantity_Back").visible = false
	else:
		get_node("Quantity_Back").visible = true
		get_node("Quantity_Back/Quantity").text = str(quantity)
	dif = position.x - ref.position.x
	process_mode = PROCESS_MODE_ALWAYS
	stay_len = 2

func _on_mouse_entered() -> void:
	#print("MOUSE IN")
	position.x = ref.position.x
	stay_len = 999
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	stay_len = 1
	pass # Replace with function body.
