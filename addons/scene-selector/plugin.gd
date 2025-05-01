@tool
extends EditorPlugin

var scene_selector_scene = preload("res://addons/scene-selector/scene_selector.tscn")
var _editor_scene_container
var _scene_doc
var _scene_selector: Container
var _scene_tabbar: TabBar
var _scene_tabbar_new_scene: Button

func _enter_tree() -> void:
	var top_level = get_editor_interface().get_base_control()
	_editor_scene_container = first_or_null(
		top_level.find_children("*", "EditorSceneTabs", true, false)
	)
	
	_scene_tabbar = first_or_null(
		_editor_scene_container.find_children("*", "TabBar", true, false)
	)
	
	main_screen_changed.connect(main_screen_print)
	
	var script_editor = get_editor_interface().get_script_editor().get_parent()
	if script_editor.visible == true:
		main_screen_print("Script")
	else:
		main_screen_print("")
	
	var _scene_doc = first_or_null(
		top_level.find_children("", "SceneTreeDock", true, false)
	)
	
	_create_scene_selector()
	_scene_doc.add_child(_scene_selector)
	_scene_doc.move_child(_scene_selector, 0)


func _exit_tree() -> void:
	_scene_selector.free()
	_editor_scene_container.visible = true


func _create_scene_selector() -> void:
	_scene_selector = scene_selector_scene.instantiate()
	
	_scene_tabbar = first_or_null(
		_editor_scene_container.find_children("*", "TabBar", true, false)
	)
	
	_scene_tabbar_new_scene = first_or_null(
		_scene_tabbar.find_children("*", "Button", true, false)
	) 
	 
	_scene_tabbar.tab_changed.connect(_set_scene_selector)
	_scene_tabbar.tab_selected.connect(_set_scene_selector)
	_scene_tabbar.resized.connect(_size_changed)
	_scene_tabbar.tab_close_pressed.connect(_set_scene_selector)
	_scene_tabbar_new_scene.pressed.connect(_set_scene_selector_delayed)
	
	_populate_scene_selector(_scene_selector) 
	_scene_selector.create_scene.connect(_create_new_scene)
	_scene_selector.item_selected.connect(_scene_selected)


func _size_changed():
	# used to capture files getting opened at the start of godot 
	# editor that do not emit signals
	_populate_scene_selector(_scene_selector) 


func _populate_scene_selector(scene_selector) -> void:
	await get_tree().create_timer(0.2).timeout
	scene_selector.clear()
	
	for tab_idx in _scene_tabbar.tab_count:
		var text = _scene_tabbar.get_tab_title(tab_idx)
		var tab_icon = _scene_tabbar.get_tab_icon(tab_idx)
		scene_selector.add_icon_item(tab_icon, text, tab_idx )
		
		if _scene_tabbar.current_tab == tab_idx:
			scene_selector.select(tab_idx)


func _set_scene_selector_delayed() -> void:
	_populate_scene_selector(_scene_selector)


func _set_scene_selector(tab_idx):
	_populate_scene_selector(_scene_selector)


func _scene_selected(selection_idx) -> void:
	_scene_tabbar.current_tab = selection_idx


func _create_new_scene() -> void:
	_scene_tabbar_new_scene.pressed.emit()


func main_screen_print(screen_name) -> void:
	if screen_name == "Script":
		_editor_scene_container.visible = false
	else:
		_editor_scene_container.visible = true


static func first_or_null(arr):
	if len(arr) == 0:
		return null
	return arr[0]
