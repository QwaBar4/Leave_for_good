extends TextureRect

@export var dialogPath = "res://dialogues/Dialog_scene4.json"
@export var TextSpeed = float(0.05)

var save_p_path = "res://Saves/Save2.save"
var dialog

var EndScene = false
var phraseNum = 0
var finished = false
var Alice_choice1 = 0

func load_data_Alice():
	if FileAccess.file_exists(save_p_path):
		var file = FileAccess.open(save_p_path, FileAccess.READ)
		Alice_choice1 = file.get_var(Alice_choice1)
		return Alice_choice1

func _ready():
	Alice_choice1 = load_data_Alice()
	print(Alice_choice1)
	$Timer.wait_time = TextSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not НАЙДЕН ФААААК")
	var ActionPhase = "0"
	nextPhrase(ActionPhase)

func end_scene(EndScene):
	if EndScene:
		get_tree().change_scene_to_file('Game_scene_in_cabinet.tscn')
		return

func _process(delta):
	if EndScene:
		end_scene(EndScene)

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
		EndScene = true
		return
		
	finished = false
	$VBoxContainer/Name.bbcode_text = dialog[phraseNum]["Name"]
	$VBoxContainer5/Text.bbcode_text = dialog[phraseNum]["Text"]
	$Action.bbcode_text = dialog[phraseNum]["Action"]
	
	$VBoxContainer5/Text.visible_characters = 0
	
	if dialog[phraseNum]["Name"] == "Юра":
		$check_Yuri.visible = true
	if dialog[phraseNum]["Name"] == "Алиса":
		$check_Alisa.visible = true
	if dialog[phraseNum]["Name"] == "Марина":
		$check_Marina.visible = true
	
	if $check_Alisa.visible == true or $check_Marina.visible == true:
		$check_Yuri.visible = false
		
	if dialog[phraseNum - 1]["Action"] == "Q":
		$check_Alisa.visible = false
		$check_Marina.visible = false
		$check_Yuri.visible = true
		
	
	if dialog[phraseNum]["Name"] == "  ":
		$AudioStreamPlayer2D2.play()
	
	if dialog[phraseNum]["Name"] == "   ":
		$AudioStreamPlayer2D2.stop()
	
	if dialog[phraseNum]["Action"] == ActionPhase:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
			$VBoxContainer5/Text.visible_characters += 1
			await get_tree().create_timer(0.02).timeout
		ActionPhase = "0"
	elif dialog[phraseNum]["Action"] == "2":
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
			$VBoxContainer5/Text.visible_characters += 1
			await get_tree().create_timer(0.02).timeout
		$VBoxContainer2.visible = false
		$VBoxContainer3.visible = true
		$VBoxContainer4.visible = true
	elif (dialog[phraseNum]["Action"] == "1" or dialog[phraseNum]["Action"] == "End") and (Alice_choice1 == 1):
		print(Alice_choice1)
		if dialog[phraseNum]["Action"] == "1":
			while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
				$VBoxContainer5/Text.visible_characters += 1
				await get_tree().create_timer(0.02).timeout
		elif dialog[phraseNum]["Action"] == "End":
			while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
				$VBoxContainer5/Text.visible_characters += 1
				await get_tree().create_timer(0.02).timeout
			while dialog[phraseNum]["Action"] != "Q":
				finished = true
				phraseNum += 1
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
	$VBoxContainer3.visible = false
	
	var ActionPhase = "3"
	print(phraseNum)
	if finished:
		nextPhrase(ActionPhase)
		$VBoxContainer2.visible = true
	elif !finished:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
			$VBoxContainer5/Text.visible_characters += 2
			await get_tree().create_timer(0.000000002).timeout
	

func _on_variant_11_pressed():
	$VBoxContainer4.visible = false
	$VBoxContainer3.visible = false
	
	var ActionPhase = "4"
	if finished:
		nextPhrase(ActionPhase)
		$VBoxContainer2.visible = true
	elif !finished:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):#Ускорение вывода букв, если не закончено: скорость увеличена
			$VBoxContainer5/Text.visible_characters += 2
			await get_tree().create_timer(0.000000002).timeout





