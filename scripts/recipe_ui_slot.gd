class_name Rec_ui_slot extends Panel

@onready var item_visual: TextureRect = $CenterContainer/Panel/recipe_display
@onready var ingredients: Array[TextureRect] = [$CenterContainer/Panel/item_display1,$CenterContainer/Panel/item_display2
	,$CenterContainer/Panel/item_display3,$CenterContainer/Panel/item_display4,$CenterContainer/Panel/item_display5]
@export var recipe_product: InvItem
@export var ingredients_items: Array[InvItem]
var UI: Rec_UI

func update(current_UI: Rec_UI):
	UI = current_UI
	if ingredients_items.is_empty():
		visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
	else:
		item_visual.texture = recipe_product.texture
		for i in range(ingredients_items.size()):
			ingredients[i].texture = ingredients_items[i].texture
	


func _on_mouse_entered() -> void:
	if recipe_product:
		UI.display_info_for(recipe_product)

func _on_mouse_exited() -> void:
	UI.display_info_for(null)
