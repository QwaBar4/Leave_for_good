extends TextureRect

@export var dialogPath = "res://dialogues/Dialog_scene5.json"
@export var TextSpeed = float(0.05)
@onready var Marina_sprite: TextureRect = $Marina

var save_p_path = "res://Saves/Save2.save"
var dialog

var x = 340.0
var y = -280.0
var n = 0
var flag1 = false
var flag2 = false
var EndScene = false
var phraseNum = 0
var finished = false
var Person_choice1 = 0

func _ready():
	$Timer.wait_time = TextSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not НАЙДЕН ФААААК")
	var ActionPhase = "0"
	nextPhrase(ActionPhase)

func save_data(Person_choice1):
	var file = FileAccess.open(save_p_path, FileAccess.WRITE)
	file.store_var(Person_choice1)
	
func _process(delta):
	await get_tree().create_timer(0.7).timeout
	print(Person_choice1)
	if EndScene:
		save_data(Person_choice1)
		get_tree().change_scene_to_file('res://Scenes/Day1/Day1_AfterPhylisophy.tscn')
		return
	
func getDialog() -> Array:
	var f = FileAccess.open(dialogPath, FileAccess.READ)
	assert(f.file_exists, "No file named this")
	
	f.open(dialogPath,FileAccess.READ)
	
	var json = f.get_as_text()
	
	var output = JSON.parse_string(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
	
func nextPhrase(ActionPhase):
	if phraseNum >= len(dialog):
		$VBoxContainer2.visible = false
		$VBoxContainer2.position = Vector2(3000, 2000)
		finished = false
		for i in range(200, -1200, -60):
			$In_sc2.position = Vector2(330, i)
			await get_tree().create_timer(0.00000000005).timeout
		await get_tree().create_timer(0.5).timeout
		EndScene = true
		return
	
	finished = false
	$VBoxContainer/Name.bbcode_text = dialog[phraseNum]["Name"]
	$VBoxContainer5/Text.bbcode_text = dialog[phraseNum]["Text"]
	$Action.bbcode_text = dialog[phraseNum]["Action"]
	
	$VBoxContainer5/Text.visible_characters = 0
	if dialog[phraseNum]["Action"] == "1":
		$AudioStreamPlayer2D.play()
		$VBoxContainer2.visible = false
		await get_tree().create_timer(2.5).timeout
		$VBoxContainer2.visible = true
		$AudioStreamPlayer2D.stop()
	elif dialog[phraseNum]["Action"] == "2":
		var i = 1
		$VBoxContainer2/Variant2.visible = false
		while i >= 0:
			await get_tree().create_timer(0.01).timeout
			$CanvasModulate.color = Color(i, i, i)
			i-=0.05
		$CanvasModulate.color = Color(0, 0, 0)
		await get_tree().create_timer(5).timeout
		i = 0
		while i <= 1:
			await get_tree().create_timer(0.01).timeout
			$CanvasModulate.color = Color(i, i, i)
			i+=0.005
		await get_tree().create_timer(0.5).timeout
		$VBoxContainer2/Variant2.visible = true
	elif dialog[phraseNum]["Action"] == "3":
		$VBoxContainer2.visible = false
		$VBoxContainer3.visible = true
		$VBoxContainer4.visible = true
		$VBoxContainer7.visible = true
	
	if dialog[phraseNum]["Action"] == str(ActionPhase) or dialog[phraseNum]["Action"] == "0" or dialog[phraseNum]["Action"] == "10" or dialog[phraseNum]["Action"] == "11":
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
			$VBoxContainer5/Text.visible_characters += 1
			await get_tree().create_timer(0.02).timeout
		if(x > 140 && flag1 == false && flag2 == false):
			n = 1.0
			while n >= 0:
				await get_tree().create_timer(0.03).timeout
				Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
				n -= 0.3
			x -= 40
			Marina_sprite.position = Vector2(x, y)
			while n <= 0:
				await get_tree().create_timer(0.03).timeout
				Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
				n += 0.3
			Marina_sprite.modulate = Color(1.0, 1.0, 1.0)
		elif((x == 140 && flag1 == false && flag2 == false)|| (x == 340 && flag1 == true && flag2 == false)):
			await get_tree().create_timer(0.03).timeout
			n = 1
			while n < 10:
				await get_tree().create_timer(0.03).timeout
				Marina_sprite.position = Vector2(x, y+n)
				n+=1
			n = 1.0
			while n >= 0:
				await get_tree().create_timer(0.03).timeout
				Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
				n -= 0.3
			Marina_sprite.flip_h = true
			while n <= 0:
				await get_tree().create_timer(0.03).timeout
				Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
				n += 0.3
			Marina_sprite.modulate = Color(1.0, 1.0, 1.0)
			n = 10
			while n > 0:
				await get_tree().create_timer(0.03).timeout
				Marina_sprite.position = Vector2(x, y+n)
				n-=1
			n = 1.0
			flag1 = true
		elif(x < 340 && flag1 == true && flag2 == false):
			while n >= 0:
				await get_tree().create_timer(0.03).timeout
				Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
				n -= 0.3
			x += 40
			Marina_sprite.position = Vector2(x, y)
			while n <= 0:
				await get_tree().create_timer(0.03).timeout
				Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
				n += 0.3
			Marina_sprite.modulate = Color(1.0, 1.0, 1.0)
			
	else:
		finished = true
		phraseNum += 1
		nextPhrase(ActionPhase)
		return
	
	if(dialog[phraseNum]["Action"] == "10"):
		flag2 = true
		await get_tree().create_timer(0.03).timeout
		n = 1.0
		while n >= 0:
			await get_tree().create_timer(0.03).timeout
			Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
			n -= 0.3
		Marina_sprite.scale = Vector2(1.5, 1.5)
		Marina_sprite.position = Vector2(350.0, -300.0)
		while n <= 0:
			await get_tree().create_timer(0.03).timeout
			Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
			n += 0.3
		Marina_sprite.modulate = Color(1.0, 1.0, 1.0)
		
		await get_tree().create_timer(0.03).timeout
		n = 1.0
		while n >= 0:
			await get_tree().create_timer(0.03).timeout
			Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
			n -= 0.3
		$HumanFront.show_behind_parent = true
		Marina_sprite.scale = Vector2(3, 3)
		Marina_sprite.position = Vector2(120, -410)
		while n <= 0:
			await get_tree().create_timer(0.03).timeout
			Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
			n += 0.3
		Marina_sprite.modulate = Color(1.0, 1.0, 1.0)
		$AudioStreamPlayer2D2.stop()
	if(dialog[phraseNum]["Action"] == "11"):
		$AudioStreamPlayer2D2.play()
		await get_tree().create_timer(0.03).timeout
		n = 1.0
		while n >= 0:
			await get_tree().create_timer(0.03).timeout
			Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
			n -= 0.3
		Marina_sprite.scale = Vector2(1.5, 1.5)
		Marina_sprite.position = Vector2(350.0, -300.0)
		while n <= 0:
			await get_tree().create_timer(0.03).timeout
			Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
			n += 0.3
		Marina_sprite.modulate = Color(1.0, 1.0, 1.0)
		
		await get_tree().create_timer(0.03).timeout
		n = 1.0
		while n >= 0:
			await get_tree().create_timer(0.03).timeout
			Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
			n -= 0.3
		$HumanFront.show_behind_parent = false
		Marina_sprite.scale = Vector2(1, 1)
		Marina_sprite.position = Vector2(340, -280)
		while n <= 0:
			await get_tree().create_timer(0.03).timeout
			Marina_sprite.modulate = Color(1.0, 1.0, 1.0, n)
			n += 0.3
		Marina_sprite.modulate = Color(1.0, 1.0, 1.0)
		$AudioStreamPlayer2D2.stop()
	
	finished = true
	print(phraseNum," ", dialog[phraseNum]["Action"]) 
	phraseNum += 1
	return

func _on_variant_2_pressed():
	var ActionPhase = "0"
	if finished:
		nextPhrase(ActionPhase)
	elif !finished:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):#Ускорение вывода букв, если не закончено: скорость увеличена
			$VBoxContainer5/Text.visible_characters += 2
			await get_tree().create_timer(0.000000002).timeout
			
#Если action phase = 1: создание двух вариантов ответа и исчезновение основной невидимой кнопки
#Код для диалоговых выборов, при нажатии исчезает другой элемент и vbox растягивается на весь экран
func _on_variant_1_pressed():
	$VBoxContainer4.visible = false
	$VBoxContainer7.visible = false
	$VBoxContainer3.modulate = Color(1, 1, 1, 0)
	$VBoxContainer3.size = Vector2(4000, 2500)
	$VBoxContainer3.position = Vector2(-330, -500)
	Person_choice1 = 2
	var ActionPhase = "4"
	$VBoxContainer2.visible = true
	print(phraseNum)
	if finished:
		nextPhrase(ActionPhase)
	elif !finished:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
			$VBoxContainer5/Text.visible_characters += 2
			await get_tree().create_timer(0.000000002).timeout
	

func _on_variant_21_pressed():
	$VBoxContainer7.visible = false
	$VBoxContainer3.visible = false
	$VBoxContainer4.modulate = Color(1, 1, 1, 0)
	$VBoxContainer4.size = Vector2(4000,2500)
	$VBoxContainer4.position = Vector2(-330, -500)
	Person_choice1 = 1
	var ActionPhase = "5"
	$VBoxContainer2.visible = true
	if finished:
		nextPhrase(ActionPhase)
	elif !finished:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):#Ускорение вывода букв, если не закончено: скорость увеличена
			$VBoxContainer5/Text.visible_characters += 2
			await get_tree().create_timer(0.000000002).timeout
	
func _on_variant_3_pressed():
	$VBoxContainer3.visible = false
	$VBoxContainer4.visible = false
	$VBoxContainer7.modulate = Color(1, 1, 1, 0)
	$VBoxContainer7.size = Vector2(4000,2500)
	$VBoxContainer7.position = Vector2(-330, -500)
	
	var ActionPhase = "6"
	$VBoxContainer2.visible = true
	if finished:
		nextPhrase(ActionPhase)
	elif !finished:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):#Ускорение вывода букв, если не закончено: скорость увеличена
			$VBoxContainer5/Text.visible_characters += 2
			await get_tree().create_timer(0.000000002).timeout
