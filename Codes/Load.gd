extends VBoxContainer


# Signals
# In your game scene, listen for this signal to know when to load the game.
signal game_loaded(data: String)
# This signal is not used in this demo, but you might want to use it for
# something.
signal game_saved()

# Constants
const SAVES_FOLDER := "user://saves/"
const SAVE_ENDING := ".save"

# Normal variables
var save_path = "res://Saves/Save1.save"
var save_files: Array
var in_scene0 = 0
# Every button is added to this group to ensure that only one can be presssed
# at a time.
var save_group := ButtonGroup.new()

# Onready variables
@onready var save_container := %SaveContainer
@onready var load_button := %Load
@onready var delete_button := %Delete


func _ready() -> void:
	load_button.disabled = true
	delete_button.disabled = true
	# PopupPanels show by default.
	save_container.scale = Vector2(6, 6)
	
	save_files = Array(list_saves())
	# Reverse to put in newest first order.
	save_files.reverse()
	for i in range(save_files.size() - 1, -1, -1):
		var text := str(save_files[i]) 
		# If the file is invalid delete it from the save files array.
		if text.is_empty() or text == "save1.save":
			save_files.remove_at(i)
			continue
		make_save_button(text)
	
	#clear_button.disabled = save_files.size() == 0


func list_saves() -> PackedStringArray:
	if not DirAccess.dir_exists_absolute(SAVES_FOLDER):
		DirAccess.make_dir_recursive_absolute(SAVES_FOLDER)
	return DirAccess.get_files_at(SAVES_FOLDER)


func make_save_button(text: String) -> void:
	var b := Button.new()
	b.toggle_mode = true
	b.text = text
	b.button_group = save_group
	save_container.add_child(b)
	# Moves the button to the top of the list, since most recent saves come
	# first.
	save_container.move_child(b, 0)
	b.button_pressed = true
	load_button.disabled = false
	delete_button.disabled = false




func _on_delete_pressed() -> void:
	await get_tree().create_timer(0.00000000005).timeout
	var i := save_group.get_pressed_button().get_index()
	if(not(i)):
		load_button.disabled = true
		delete_button.disabled = true
		await get_tree().create_timer(0.3).timeout
	DirAccess.remove_absolute(SAVES_FOLDER + save_files[i])
	save_files.remove_at(i)
	save_group.get_pressed_button().queue_free()
	load_button.disabled = false
	delete_button.disabled = false

func _on_load_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	var i = save_group.get_pressed_button()
	var file_name = i.get_text()
	var file = FileAccess.open(SAVES_FOLDER + file_name, FileAccess.READ)
	var scene = 0
	scene = file.get_var(scene)
	match scene:
		0:
			return
		1:
			get_tree().change_scene_to_file('res://Scenes/Day1/Day1_dream.tscn')
		2:
			get_tree().change_scene_to_file('res://Scenes/Day1/Day1_WakeUp.tscn')
		3:
			get_tree().change_scene_to_file('res://Scenes/Day1/Day1_InRoad.tscn')
		4:
			get_tree().change_scene_to_file('res://Scenes/Day1/Day1_InUniversity.tscn')
		5:
			get_tree().change_scene_to_file('res://Scenes/Day1/Day1_PhylosophyLesson.tscn')
		6:
			get_tree().change_scene_to_file('res://Scenes/Day1/Day1_AfterPhylisophy.tscn')
		7:
			get_tree().change_scene_to_file('res://Scenes/Day1/Day1_Returned.tscn')
		8:
			get_tree().change_scene_to_file('res://Scenes/Day1/Day1_DayDream.tscn')

	# You want to replace this with your own save decoding function.



func get_text() -> String:
	return $TextEdit.text

func on_game_loaded(text: String) -> void:
	$TextEdit.text = text
