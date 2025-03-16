extends Node2D

var in_scene0 = 2
var in_scene = 2
var save_path = "res://Saves/Save1.save"

func save_data(in_scene0, in_scene):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(in_scene0)
	file.store_var(in_scene)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Eye_button.visible = false
	in_scene0 = 2
	save_data(in_scene0, in_scene)#Сохранение нулевой переменной, то есть метки с которой начинается сцена после нажатия продожить



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $DialogueBox/In_sc2.position > Vector2(-100, -80):
		$Eye_button.visible = true
	


func _on_menu_button_pressed():
	$VBoxContainer3/Menu_button.visible = false
	for i in range(-1500, 100, 100):
		$ColorRect3.position = Vector2(0, i)
		await get_tree().create_timer(0.000000000005).timeout


func _on_continue_pressed():
	$VBoxContainer3/Menu_button.visible = true
	for i in range(0, -1700, -100):
		$ColorRect3.position = Vector2(0, i)
		await get_tree().create_timer(0.000000000005).timeout


func _on_options_pressed():
	for i in range(-2600, 100, 100):
		$ColorRect2.position = Vector2(i, -5)
		await get_tree().create_timer(0.000000000005).timeout


func _on_sound_2_pressed():
	for i in range(0, -3300, -100):
		$ColorRect2.position = Vector2(i, -5)
		await get_tree().create_timer(0.000000000005).timeout

func _on_exit_pressed():
	get_tree().change_scene_to_file('Menu.tscn')




func _on_eye_button_pressed():
	if $DialogueBox.visible == true:
		$DialogueBox.visible = false
	else:
		$DialogueBox.visible = true
