extends Interactable

func Use(_inp):
	if not Rec_ui_slot.selected:
		return
	if not soda_info.current.craftable:
		soda_info.current.no_ingredients_anim()
		return
	
	Inv_UI.static_inv.add_item(Rec_ui_slot.selected.recipe_product,1)
	for i in Rec_ui_slot.selected.ingredients_items:
		Inv_UI.static_inv.add_item(i,-1)
	soda_info.current.update()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
