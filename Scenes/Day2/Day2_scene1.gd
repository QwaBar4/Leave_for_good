extends Node2D 

@export var ColorR = float(0.05)

var in_scene0 = 1 #Нулевая сцена - на нее переходит кнопка продолжить
var in_scene = 1 #Сцена сохранения - на нее ДОЛЖНА переходить кнопка сохранения
var save_path = "res://Saves/Save1.save"

func save_data(in_scene0, in_scene):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(in_scene0)
	file.store_var(in_scene)

func _on_ready():
	save_data(in_scene0, in_scene)#Сохранение нулевой переменной, то есть метки с которой начинается сцена после нажатия продожить
	var screenSize = DisplayServer.screen_get_size()
	#var windowSize = Vector2(screenSize)
	DisplayServer.window_set_size(screenSize)
	
func _process(delta):
	self
	#if $DialogueBox/Exist.visible == true:
		#$Yuri.visible = true
	#else:
		#$Yuri.visible = false

func _on_button_pressed():
	if $DialogueBox.visible == true:
		$DialogueBox.visible = false
	else:
		$DialogueBox.visible = true


func _on_menu_button_pressed():
	$VBoxContainer/Menu_button.visible = false
	$Eye_button.visible = false
	for i in range(-1165, -370, 60):
		$ColorRect3.position = Vector2(-645.61, i)
		await get_tree().create_timer(0.00000000005).timeout

func _on_continue_pressed():
	$VBoxContainer/Menu_button.visible = true
	$Eye_button.visible = true
	for i in range(-370, -1400, -60):
		$ColorRect3.position = Vector2(-645.61, i)
		await get_tree().create_timer(0.00000000005).timeout

func _on_exit_pressed():
	get_tree().change_scene_to_file('res://Scenes/Menu.tscn')

func _on_options_pressed():
		for i in range(-1955.448, -662.874, 60):
			$ColorRect2.position = Vector2(i, -424)
			await get_tree().create_timer(0.00000000005).timeout

func _on_sound_2_pressed():
	for i in range(-662.874, -2000.448, -60):
			$ColorRect2.position = Vector2(i, -424)
			await get_tree().create_timer(0.00000000005).timeout

func _on_load_pressed():
	for i in range(750, -750, -60):
		$ColorRect4.position = Vector2(i, -366)
		await get_tree().create_timer(0.000000000005).timeout


func _on_exitt_pressed():
	for i in range(-750, 750, 60):
		$ColorRect4.position = Vector2(i, -366)
		await get_tree().create_timer(0.000000000005).timeout
