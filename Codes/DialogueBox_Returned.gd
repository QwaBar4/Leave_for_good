extends TextureRect

@export var dialogPath = "res://dialogues/Dialog_scene7.json"
@export var TextSpeed = float(0.05)

var save_p_path = "res://Saves/Save2.save"
var dialog

var EndScene = false
var phraseNum = 0
var finished = false
var Person_choice1 = 0
var Person_choice2 = 0
var choice1 = 0
var choice2 = 0.0

func _ready():
	choice1 = str(int(load_data_Person1(Person_choice1)))
	choice2 = str(int(load_data_Person2(Person_choice2)))
	print(choice1)
	print(choice2)
	$Timer.wait_time = TextSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not НАЙДЕН ФААААК")
	var ActionPhase = "0"
	nextPhrase(ActionPhase)

func load_data_Person1(Person_choice):
	if FileAccess.file_exists(save_p_path):
		var file = FileAccess.open(save_p_path, FileAccess.READ)
		Person_choice1 = file.get_float()
		return Person_choice1
	else:
		print("No data")
		Person_choice1 = 0
		return Person_choice1
		
func load_data_Person2(Person_choice2):
	if FileAccess.file_exists(save_p_path):
		var file = FileAccess.open(save_p_path, FileAccess.READ)
		Person_choice2 = file.get_double()
		return Person_choice2
	else:
		print("No data")
		Person_choice2 = 0
		return Person_choice2


func _process(delta):
	if EndScene:
		get_tree().change_scene_to_file('res://Scenes/Day1/Day1_DayDream.tscn')
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
		var i = 1
		while i > 0:
			await get_tree().create_timer(0.001).timeout
			$CanvasModulate.color = Color(i, i, i)
			i-=0.015
		await get_tree().create_timer(0.005).timeout
		EndScene = true
		return
	
	finished = false
	$VBoxContainer/Name.bbcode_text = dialog[phraseNum]["Name"]
	$VBoxContainer5/Text.bbcode_text = dialog[phraseNum]["Text"]
	$Action.bbcode_text = dialog[phraseNum]["Action"]
	
	$VBoxContainer5/Text.visible_characters = 0
	
	if dialog[phraseNum]["Action"] == "1":
		$VBoxContainer2.visible = false
		for i in range(-1200, 300, 30):
			$In_sc2.position = Vector2(330, i)
			await get_tree().create_timer(0.005).timeout
		$AudioStreamPlayer2D3.play()
		$AudioStreamPlayer2D.stop()
		$VBoxContainer2.visible = true
	if dialog[phraseNum]["Action"] == "3":
		$AudioStreamPlayer2D2.stop()
	
	if dialog[phraseNum]["Action"] == ActionPhase or dialog[phraseNum]["Action"] == "1" or dialog[phraseNum]["Action"] == "2" or dialog[phraseNum]["Action"] == "3" or dialog[phraseNum]["PersonChoice1"] == choice1 or dialog[phraseNum]["PersonChoice2"] == choice2:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
			$VBoxContainer5/Text.visible_characters += 1
			await get_tree().create_timer(0.02).timeout
		if dialog[phraseNum]["Action"] == "2":
			$VBoxContainer2.visible = false
			$AudioStreamPlayer2D4.play()
			await get_tree().create_timer(0.01).timeout
			$VBoxContainer2.visible = true
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
