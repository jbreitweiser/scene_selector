@tool
extends HBoxContainer

signal item_selected(int)
signal create_scene

@onready var option_button: OptionButton = $OptionButton
@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.custom_minimum_size = Vector2(size.y, size.y)
	


func _on_button_pressed() -> void:
	create_scene.emit()


func _on_option_button_item_selected(index: int) -> void:
	item_selected.emit(index)

func add_icon_item(tab_icon, text, tab_idx ) -> void:
	option_button.add_icon_item(tab_icon, text, tab_idx )
	get_popup().set_item_as_radio_checkable(tab_idx, false)
	
func clear() -> void:
	option_button.clear()
	
func select(tab_idx) -> void:
	option_button.select(tab_idx)
	
func get_popup()-> PopupMenu:
	return option_button.get_popup()
