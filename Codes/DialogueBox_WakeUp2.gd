extends TextureRect

@export var dialogPath = "res://dialogues/Dialog_scene9.json"
@export var TextSpeed = float(0.05)
@onready var Yuri_sprite: TextureRect = $Yuri

var save_p_path = "user://saves/Save2.save"
var dialog

var n
var EndScene = false
var phraseNum = 0
var finished = false

func _ready():
	$Timer.wait_time = TextSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not НАЙДЕН ФААААК")
	var ActionPhase = "0"
	nextPhrase(ActionPhase)

func save_data(Alice_choice1):
	var file = FileAccess.open(save_p_path, FileAccess.WRITE)
	file.store_var(Alice_choice1)

func _process(delta):
	if EndScene:
		get_tree().change_scene_to_file('res://Scenes/ToBeContinued.tscn')
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
	
	if dialog[phraseNum]["Text"] == "Я выключил его и встал с дивана":
		$AudioStreamPlayer2D4.stop()
	if dialog[phraseNum]["Text"] == "Ххххаах":
		$AudioStreamPlayer2D5.play()
	if dialog[phraseNum]["Text"] == "Проснулся?":
		$AudioStreamPlayer2D2.stop()
	if dialog[phraseNum]["Text"] == "Я оделся и вышел из общежития?":
		$AudioStreamPlayer2D6.play()
	
	finished = false
	$VBoxContainer/Name.bbcode_text = dialog[phraseNum]["Name"]
	$VBoxContainer5/Text.bbcode_text = dialog[phraseNum]["Text"]
	$Action.bbcode_text = dialog[phraseNum]["Action"]
	
	$VBoxContainer5/Text.visible_characters = 0
	if dialog[phraseNum]["Action"] == "1":
		$VBoxContainer2.visible = false
		$AudioStreamPlayer2D4.play()
		n = -100
		while(n <= -25):
			$AudioStreamPlayer2D4.volume_db = n
			await get_tree().create_timer(0.2).timeout
			n += 11
		$VBoxContainer2.visible = true
	elif dialog[phraseNum]["Action"] == "3":
		$AudioStreamPlayer2D6.play()
	elif dialog[phraseNum]["Action"] == "4":
		n = -40
		while(n <= -20):
			$AudioStreamPlayer2D3.volume_db = n
			await get_tree().create_timer(0.0002).timeout
			n += 10
		$AudioStreamPlayer2D3.play()
	elif dialog[phraseNum]["Action"] == "5":
			$AudioStreamPlayer2D2.play()
			n = -100
			while(n <= -25):
				$AudioStreamPlayer2D2.volume_db = n
				await get_tree().create_timer(0.0002).timeout
				n += 10
	
	if (dialog[phraseNum]["Action"] == "0") or (dialog[phraseNum]["Action"] == "1") or (dialog[phraseNum]["Action"] == "2") or (dialog[phraseNum]["Action"] == "3") or (dialog[phraseNum]["Action"] == "4")  or (dialog[phraseNum]["Action"] == "5"):
		if dialog[phraseNum]["Action"] == "2":
			$AudioStreamPlayer2D6.play()
			await get_tree().create_timer(0.002).timeout
			Yuri_sprite.self_modulate = Color.hex(0xffffff28)
			await get_tree().create_timer(0.002).timeout
			Yuri_sprite.self_modulate = Color.hex(0xffffff50)
			await get_tree().create_timer(0.002).timeout
			Yuri_sprite.self_modulate = Color.hex(0xffffff78)
			await get_tree().create_timer(0.002).timeout
			Yuri_sprite.self_modulate = Color.hex(0xffffffa0)
			await get_tree().create_timer(0.002).timeout
			Yuri_sprite.self_modulate = Color.hex(0xffffffc8)
			await get_tree().create_timer(0.002).timeout
			Yuri_sprite.self_modulate = Color.hex(0xffffff)
		if dialog[phraseNum]["Action"] == "3":
			Yuri_sprite.self_modulate = Color.hex(0xffffffc8)
			await get_tree().create_timer(0.0002).timeout
			Yuri_sprite.self_modulate = Color.hex(0xffffffa0)
			await get_tree().create_timer(0.0002).timeout
			Yuri_sprite.self_modulate = Color.hex(0xffffff78)
			await get_tree().create_timer(0.0002).timeout
			Yuri_sprite.self_modulate = Color.hex(0xffffff28)
			await get_tree().create_timer(0.0002).timeout
			Yuri_sprite.self_modulate = Color.hex(0xffffff00)
			await get_tree().create_timer(0.0002).timeout
		if dialog[phraseNum]["Action"] == "4":
			$VBoxContainer2.visible = false
			$VBoxContainer2.position = Vector2(3000, 2000)
			finished = false
			for i in range(200, -1200, -60):
				$In_sc2.position = Vector2(330, i)
				await get_tree().create_timer(0.00000000005).timeout
			await get_tree().create_timer(0.5).timeout
			EndScene = true
			return
			#The most badass code i've ever created
		if dialog[phraseNum]["Name"] == "Юра":
			var n = -420
			while(n >= -430):
				await get_tree().create_timer(0.004).timeout
				Yuri_sprite.position = Vector2(140, n)
				n -= 2
			while(n <= -420):
				await get_tree().create_timer(0.004).timeout
				Yuri_sprite.position = Vector2(140, n)
				n += 2
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
			$VBoxContainer5/Text.visible_characters += 1
			await get_tree().create_timer(0.02).timeout
	else:
		finished = true
		phraseNum += 1
		nextPhrase(ActionPhase)
		return
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
	$VBoxContainer3.modulate = Color(1, 1, 1, 0)
	$VBoxContainer3.size = Vector2(4000, 2500)
	$VBoxContainer3.position = Vector2(-330, -500)
	
	var ActionPhase = "2"
	
	print(phraseNum)
	if finished:
		nextPhrase(ActionPhase)
	elif !finished:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
			$VBoxContainer5/Text.visible_characters += 2
			await get_tree().create_timer(0.000000002).timeout
	

func _on_variant_11_pressed():
	$VBoxContainer3.visible = false
	$VBoxContainer4.modulate = Color(1, 1, 1, 0)
	$VBoxContainer4.size = Vector2(4000,2500)
	$VBoxContainer4.position = Vector2(-330, -500)
	
	var ActionPhase = "0"
	
	if finished:
		nextPhrase(ActionPhase)
	elif !finished:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):#Ускорение вывода букв, если не закончено: скорость увеличена
			$VBoxContainer5/Text.visible_characters += 2
			await get_tree().create_timer(0.000000002).timeout
