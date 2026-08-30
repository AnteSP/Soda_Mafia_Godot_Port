extends Panel

@onready var item_visual: TextureRect = $CenterContainer/Panel/item_display
@onready var item_quantity: RichTextLabel = $CenterContainer/Panel/Quantity
var current_item: InvPair
var UI: Inv_UI

func update(ItemPair: InvPair,current_UI: Inv_UI):
	if !ItemPair || !ItemPair.item:
		item_visual.visible = false
		item_quantity.text = ""
		current_item = null
	else:
		item_visual.visible = true
		item_visual.texture = ItemPair.item.texture
		item_quantity.text = str(ItemPair.quantity)
		current_item = ItemPair
	UI = current_UI


func _on_mouse_entered() -> void:
	if current_item:
		UI.display_info_for(current_item.item)

func _on_mouse_exited() -> void:
	UI.display_info_for(null)
