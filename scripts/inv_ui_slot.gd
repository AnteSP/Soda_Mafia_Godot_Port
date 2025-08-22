extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var item_quantity: RichTextLabel = $CenterContainer/Panel/Quantity

func update(ItemPair: InvPair):
	if !ItemPair || !ItemPair.item:
		item_visual.visible = false
		item_quantity.text = ""
	else:
		item_visual.visible = true
		item_visual.texture = ItemPair.item.texture
		item_quantity.text = str(ItemPair.quantity)
		
