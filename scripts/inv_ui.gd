class_name Inv_UI extends Control

@export var InventoryButton: TextureButton
@onready var inv: Inv = preload("res://Prefabs/Items/PlayerInventory.tres")
static var static_inv: Inv
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

@onready var title: RichTextLabel = $Title
@onready var desc: RichTextLabel = $Description

var is_open = false


func _ready():
	update_slots()
	close()
	inv.InventoryButton = InventoryButton
	static_inv = inv

func update_slots():
	for i in range(min(inv.item_pairs.size(),slots.size())):
		slots[i].update(inv.item_pairs[i],self)
	for i in range(inv.item_pairs.size(),slots.size()):
		slots[i].update(null,self)

func display_info_for(item: InvItem) -> void:
	if !item:
		title.text = ""
		desc.text = "..."
	else:
		title.text = item.name
		desc.text = item.desc
	
static func player_has_item(item_name: String,quantity: int):
	return static_inv.item_exists(item_name,quantity)


func _on_visibility_changed() -> void:
	if inv:
		update_slots()

#func _process(_delta: float) -> void:
#	if Input.is_action_just_pressed("e"):
#		if is_open:
#			close()
#		else:
#			open()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
