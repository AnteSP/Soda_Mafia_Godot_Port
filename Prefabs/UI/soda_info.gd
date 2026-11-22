class_name soda_info extends ColorRect

@export var Recipe_Button: TextureButton
static var current: soda_info
var craftable: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	pass # Replace with function body.

var pairs: Array[InvPair]
var repeats: Dictionary[String, int]
var craftable_pairs: Dictionary[String, float]
func update():
	if not Rec_ui_slot.selected:
		if Recipe_Button:
			Recipe_Button.visible = true
			Recipe_Button.get_node("AnimationPlayer").play("Menu_Button_Blip")
			$WARNING.visible = true
		return
	$WARNING.visible = false
	repeats.clear()
	craftable_pairs.clear()
	pairs.clear()
	#Rec_ui_slot.selected
	
	$Panel/recipe_display.texture = Rec_ui_slot.selected.recipe_product.texture
	$Panel/recipe_label.text = "SELECTED RECIPE: " + Rec_ui_slot.selected.recipe_product.name
	pairs.assign(Rec_ui_slot.selected.ingredients_items.map(Inv_UI.static_inv.find_pair_z))
	craftable_pairs.assign( {pairs[0].item.name:pairs[0].quantity} )
	for p in range(1, pairs.size()):
		craftable_pairs.set( pairs[p].item.name,pairs[p].quantity )
		if pairs[p-1].item.name == pairs[p].item.name:
			if repeats.has(pairs[p].item.name):
				repeats.set(pairs[p].item.name,repeats[pairs[p].item.name]+1)
			else:
				repeats.assign({pairs[p].item.name:2})
	for r in repeats:
		craftable_pairs.set(r,craftable_pairs[r]/repeats[r])#divide each quantity by # of repeats
	$Panel/craftable_label.text = "ABLE TO MAKE: " + str( int(floor(craftable_pairs.values().min())) )
	craftable = int(floor(craftable_pairs.values().min())) > 0

	var max_count: float = craftable_pairs.values().max()
	$Panel/TOP_num.text = str( int(floor(max_count)) )
	var count = 5
	for p in craftable_pairs:
		var node = get_node("Panel/item_display" + str(count))
		node.visible = true
		node.texture = Inv.find_inv_item("res://Prefabs/Items",p).texture
		count -= 1
		var p_bar: Control = node.get_node("Progress_bar")
		p_bar.size.y = 0
		p_bar.position.y = -10
	if int(floor(max_count)) > 0:
		$Panel/MIDDLE_num.text = ""
		if int(floor(max_count)) > 1:
			$Panel/MIDDLE_num.text = str( int(floor(max_count/2)) )
		count = 5
		for p in craftable_pairs:
			var node = get_node("Panel/item_display" + str(count))
			count -= 1
			var perc: float = craftable_pairs[p]/max_count
			var p_bar: Control = node.get_node("Progress_bar")
			p_bar.size.y = 120.0*perc
			p_bar.position.y = -(120.0*perc) - 10
			print(p_bar.size, p_bar.position, perc)
	
func no_ingredients_anim():
	$WARNING2/AnimationPlayer.play("pop_in")


func _on_visibility_changed() -> void:
	update()
	pass # Replace with function body.
