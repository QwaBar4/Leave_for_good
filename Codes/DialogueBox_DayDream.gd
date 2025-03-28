extends TextureRect

@export var dialogPath = "res://dialogues/Dialog_scene8.json"
@export var TextSpeed = float(0.05)

var save_p_path = "user://saves/Save2.save"
var dialog

var EndScene = false
var phraseNum = 0
var finished = false
var Person_choice1 = 0


func _ready():
	$AudioStreamPlayer2D.play()
	$Timer.wait_time = TextSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not НАЙДЕН ФААААК")
	nextPhrase("0")


func _process(delta):
	if EndScene:
		get_tree().change_scene_to_file('res://Scenes/EndDemo.tscn')
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
	var flag = false
	ActionPhase = "0"

	
	finished = false
	$VBoxContainer/Name.bbcode_text = dialog[phraseNum]["Name"]
	$VBoxContainer5/Text.bbcode_text = dialog[phraseNum]["Text"]
	$Action.bbcode_text = dialog[phraseNum]["Action"]
	
	$VBoxContainer5/Text.visible_characters = 0
	
	if dialog[phraseNum]["Action"] == "2":
		$AudioStreamPlayer2D3.play()
	if dialog[phraseNum]["Action"] == "3":
		$AudioStreamPlayer2D4.play()
	
	
	if dialog[phraseNum]["Action"] == "0" or dialog[phraseNum]["Action"] == "2" or dialog[phraseNum]["Action"] == "3":
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
			$VBoxContainer5/Text.visible_characters += 1
			await get_tree().create_timer(0.02).timeout
	elif dialog[phraseNum]["Action"] == "1":
		finished = false
		var i = 1
		$VBoxContainer2.visible = false
		while i > 0.5:
			await get_tree().create_timer(0.01).timeout
			$CanvasModulate.color = Color(i, i, i)
			i-=0.005
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):
				$VBoxContainer5/Text.visible_characters += 1
				await get_tree().create_timer(0.02).timeout
		while i >= 1:
			await get_tree().create_timer(0.01).timeout
			$CanvasModulate.color = Color(i, i, i)
			i-=0.02
		$AudioStreamPlayer2D2.play()
		await get_tree().create_timer(0.35).timeout
		$VBoxContainer5/Text.visible = false
		$VBoxContainer2.visible = false
		$VBoxContainer.visible = false
		EndScene = true
		return
		
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
