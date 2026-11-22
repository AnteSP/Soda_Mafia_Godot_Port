class_name Rec_ui_slot extends Panel

@onready var item_visual: TextureRect = $CenterContainer/Panel/recipe_display
@onready var ingredients: Array[TextureRect] = [$CenterContainer/Panel/item_display1,$CenterContainer/Panel/item_display2
	,$CenterContainer/Panel/item_display3,$CenterContainer/Panel/item_display4,$CenterContainer/Panel/item_display5]
@onready var selected_graphic: ColorRect = $SELECTED
@export var recipe_product: InvItem
@export var ingredients_items: Array[InvItem]
var UI: Rec_UI
var inside: bool
static var selected: Rec_ui_slot = null


func update(current_UI: Rec_UI):
	UI = current_UI
	if ingredients_items.is_empty():
		visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
	else:
		item_visual.texture = recipe_product.texture
		item_visual.tooltip_text = recipe_product.name
		var last_item: String = ""
		var item_repeats: int = 0
		for i in range(ingredients_items.size()):
			ingredients[i].texture = ingredients_items[i].texture
			if ingredients_items[i].name == last_item:
				item_repeats += 1
			if Inv_UI.player_has_item(ingredients_items[i].name,item_repeats+1):
				ingredients[i].modulate = Color.WHITE
				ingredients[i].tooltip_text = ingredients_items[i].name
			else:
				ingredients[i].modulate = Color(0.3, 0.3, 0.3, 0.7)
				ingredients[i].tooltip_text = ingredients_items[i].name + "(missing)"
			last_item = ingredients_items[i].name
			
func _on_mouse_entered() -> void:
	if recipe_product:
		UI.display_info_for(recipe_product)
	modulate = Color(0.7, 0.7, 0.7, 1)
	inside = true

func _on_mouse_exited() -> void:
	if UI:
		UI.display_info_for(null)
	modulate = Color(1, 1, 1, 1)
	inside = false

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and inside:
			if event.pressed:
				modulate = Color(0.2, 0.2, 0.2, 1)
			else:
				modulate = Color(0.7, 0.7, 0.7, 1)
				if selected:
					selected.selected_graphic.visible = false
				selected = self
				selected_graphic.visible = true
				UI.sound.play()
				soda_info.current.update()
