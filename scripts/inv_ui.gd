extends Control

@onready var inv: Inv = preload("res://Prefabs/Items/PlayerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false


func _ready():
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.item_pairs.size(),slots.size())):
		slots[i].update(inv.item_pairs[i])
	for i in range(inv.item_pairs.size(),slots.size()):
		slots[i].update(null)


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
