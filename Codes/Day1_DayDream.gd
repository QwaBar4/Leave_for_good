extends Node2D

var in_scene0 = 8

var save_path = "user://saves/save1.save"

func save_data(in_scene0):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(in_scene0)

# Called when the node enters the scene tree for the first time.
func _ready():
	in_scene0 = 8#Сохранение нулевой переменной, то есть метки с которой начинается сцена после нажатия продожить
	save_data(in_scene0)
	var i = 0
	while i < 1:
		await get_tree().create_timer(0.01).timeout
		$DialogueBox/CanvasModulate.color = Color(i, i, i)
		i+=0.005
	await get_tree().create_timer(0.05).timeout




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self

func _on_menu_button_pressed():
	$ColorRect4/VBoxContainer/HBoxContainer/buttons.play()
	await get_tree().create_timer(0.000000000005).timeout
	$VBoxContainer3/Menu_button.visible = false
	for i in range(-1500, 100, 100):
		$ColorRect3.position = Vector2(0, i)
		await get_tree().create_timer(0.000000000005).timeout


func _on_continue_pressed():
	$ColorRect4/VBoxContainer/HBoxContainer/buttons.play()
	await get_tree().create_timer(0.000000000005).timeout
	$VBoxContainer3/Menu_button.visible = true
	for i in range(0, -1700, -100):
		$ColorRect3.position = Vector2(0, i)
		await get_tree().create_timer(0.000000000005).timeout


func _on_options_pressed():
	$ColorRect4/VBoxContainer/HBoxContainer/buttons.play()
	await get_tree().create_timer(0.000000000005).timeout
	for i in range(-2600, 100, 100):
		$ColorRect2.position = Vector2(i, -5)
		await get_tree().create_timer(0.000000000005).timeout


func _on_sound_2_pressed():
	$ColorRect4/VBoxContainer/HBoxContainer/buttons.play()
	await get_tree().create_timer(0.000000000005).timeout
	for i in range(0, -3300, -100):
		$ColorRect2.position = Vector2(i, -5)
		await get_tree().create_timer(0.000000000005).timeout

func _on_exit_pressed():
	$ColorRect4/VBoxContainer/HBoxContainer/buttons.play()
	await get_tree().create_timer(0.000000000005).timeout
	get_tree().change_scene_to_file('res://Scenes/Menu.tscn')


func _on_load_pressed():
	$ColorRect4/VBoxContainer/HBoxContainer/buttons.play()
	await get_tree().create_timer(0.000000000005).timeout
	for i in range(2600, -100, -100):
		$ColorRect4.position = Vector2(i, -3)
		await get_tree().create_timer(0.000000000005).timeout


func _on_exit_2_pressed():
	$ColorRect4/VBoxContainer/HBoxContainer/buttons.play()
	await get_tree().create_timer(0.000000000005).timeout
	for i in range(-100, 2600, 100):
		$ColorRect4.position = Vector2(i, -3)
		await get_tree().create_timer(0.000000000005).timeout


func _on_sound_pressed() -> void:
	$ColorRect4/VBoxContainer/HBoxContainer/buttons.play()
	if AudioServer.is_bus_mute(0) == false:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		$ColorRect4/VBoxContainer/HBoxContainer/buttons.play()
