extends TextureRect

@export var dialogPath = "res://dialogues/Dialog_scene6.json"
@export var TextSpeed = float(0.05)
@onready var Yuri_sprite: TextureRect = $Yuri
@onready var Felice_sprite: TextureRect = $Felice

var save_p_path = "res://Saves/Save2.save"
var dialog

var ActionPhase
var n = 0
var EndScene = false
var phraseNum = 0
var finished = false
var flag = false
var ActFlag = false
var dumbFlag = false
var Person_choice1 = 0
var Person_choice2 = 0


func load_data_Person(Person_choice):
	if FileAccess.file_exists(save_p_path):
		var file = FileAccess.open(save_p_path, FileAccess.READ)
		Person_choice = file.get_float()
		return Person_choice
	else:
		print("No data")
		Person_choice = 0
		return Person_choice

func save_data(Person_choice2):
	var file = FileAccess.open(save_p_path, FileAccess.WRITE)
	file.store_double(Person_choice2)

func _ready():
	print("PersonCh1 = ", load_data_Person(Person_choice1))
	$Timer.wait_time = TextSpeed
	dialog = getDialog()
	ActionPhase = str(int(load_data_Person(Person_choice1)))
	nextPhrase(ActionPhase)


func _process(delta):
	if EndScene:
		var file = FileAccess.open(save_p_path, FileAccess.READ_WRITE)
		file.store_float(load_data_Person(Person_choice1))
		save_data(Person_choice2)
		get_tree().change_scene_to_file('res://Scenes/Day1/Day1_Returned.tscn')
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

func nextPhrase(ActPhase):
	if ActFlag == false:
		ActionPhase = str(int(load_data_Person(Person_choice1)))
	else:
		ActionPhase = ActPhase
	if phraseNum >= len(dialog) or dialog[phraseNum]["Action"] == "4":
		$VBoxContainer5/Text.visible = false
		$VBoxContainer2.visible = false
		$VBoxContainer2.position = Vector2(3000, 2000)
		Felice_sprite.visible = false
		finished = false
		$VBoxContainer2/Variant2.visible = false
		var i = 1
		while i > 0:
			await get_tree().create_timer(0.01).timeout
			$CanvasModulate.color = Color(i, i, i)
			i-=0.005
		await get_tree().create_timer(0.05).timeout
		EndScene = true
		return
	
	finished = false
	$VBoxContainer/Name.bbcode_text = dialog[phraseNum]["Name"]
	$VBoxContainer5/Text.bbcode_text = dialog[phraseNum]["Text"]
	$Action.bbcode_text = dialog[phraseNum]["Action"]
	
	
	$VBoxContainer5/Text.visible_characters = 0
	if dialog[phraseNum]["Action"] == "9":
		$VBoxContainer2.visible = false
		$AudioStreamPlayer2D3.play()
		$AudioStreamPlayer2D.stop()
		var i = 0;
		while(i < 800):
			$In_sc2.position = Vector2(340 - i, -650.0)
			$In_sc3.position = Vector2(1345.0 + i, -650.0)
			await get_tree().create_timer(0.000000000005).timeout
			i += 30
		$VBoxContainer2.visible = true
	if dialog[phraseNum]["Action"] == "5":
		$AudioStreamPlayer2D.stop()
	elif dialog[phraseNum]["Text"] == "Отзвенел звонок" && dumbFlag == true:
		$AudioStreamPlayer2D2.play()
		await get_tree().create_timer(0.05).timeout
	elif dialog[phraseNum]["Text"] == "Надо бежать, рад был пообщаться, Фелиция" && dumbFlag == true:
		await get_tree().create_timer(0.05).timeout
		n = -30
		while(n > -60):
			$AudioStreamPlayer2D2.volume_db = n
			await get_tree().create_timer(0.09).timeout
			n-=5
		$AudioStreamPlayer2D.stop()
	elif dialog[phraseNum]["Action"] == "3":
		$VBoxContainer2.visible = false
		$VBoxContainer4.visible = true
		$VBoxContainer7.visible = true
	
	if dialog[phraseNum]["Action"] == ActionPhase or dialog[phraseNum]["Action"] == "0" or dialog[phraseNum]["Action"] == "5" or dialog[phraseNum]["Action"] == "3" or dialog[phraseNum]["Action"] == "6" or dialog[phraseNum]["Action"] == "10" or dialog[phraseNum]["Action"] == "9":
		if ((dialog[phraseNum]["Name"] == "Юра") && (flag == false)):
			n = 0.0
			while n < 1:
				await get_tree().create_timer(0.02).timeout
				Yuri_sprite.modulate = Color(1, 1, 1, n)
				n+=0.2
			flag = true
		if ((dialog[phraseNum]["Name"] == "Юра") && (flag == true)):
			var n = -420
			while(n >= -430):
				await get_tree().create_timer(0.004).timeout
				Yuri_sprite.position = Vector2(140, n)
				n -= 2
			while(n <= -420):
				await get_tree().create_timer(0.004).timeout
				Yuri_sprite.position = Vector2(140, n)
				n += 2
		if dialog[phraseNum]["Action"] == "5":
			n = 1
			while n >= 0:
				await get_tree().create_timer(0.02).timeout
				Yuri_sprite.modulate = Color(1, 1, 1, n)
				n-=0.2
			flag = false
		if dialog[phraseNum]["Action"] == "6":
			ActFlag = true
			n = 0
			while n <= 0.7:
				await get_tree().create_timer(0.02).timeout
				Felice_sprite.modulate = Color(0.7, 0.7, 0.7, n)
				n+=0.1
		if dialog[phraseNum]["Text"] == "Я отправился в кабинет проектной деятельности" && dumbFlag == true:
			n = 1
			while n >= 0:
				await get_tree().create_timer(0.02).timeout
				Felice_sprite.modulate = Color(1, 1, 1, n)
				n-=0.2
			Felice_sprite.modulate = Color(0, 0, 0, 0)
		if dialog[phraseNum]["Action"] == "10" && ActionPhase == "8":
			n = 1
			while n >= 0:
				await get_tree().create_timer(0.02).timeout
				Yuri_sprite.modulate = Color(1, 1, 1, n)
				n-=0.2
		if dialog[phraseNum]["Text"] == "Успешно отсидев лекцию Иннокентия, без каких-либо происшествий, я отправился к гардеробу за курткой ":
			$AudioStreamPlayer2D.play()
			$AudioStreamPlayer2D4.stop()
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
	if finished:
		nextPhrase(ActionPhase)
	elif !finished:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):#Ускорение вывода букв, если не закончено: скорость увеличена
			$VBoxContainer5/Text.visible_characters += 2
			await get_tree().create_timer(0.000000002).timeout
			
#Если action phase = 1: создание двух вариантов ответа и исчезновение основной невидимой кнопки
#Код для диалоговых выборов, при нажатии исчезает другой элемент и vbox растягивается на весь экран

func _on_variant_21_pressed():
	$VBoxContainer7.visible = false
	$VBoxContainer4.modulate = Color(1, 1, 1, 0)
	$VBoxContainer4.size = Vector2(4000,2500)
	$VBoxContainer4.position = Vector2(-330, -500)
	Person_choice2 = 1
	ActionPhase = "7"
	$VBoxContainer2.visible = true
	n = 0.7
	var db = -35
	while n <= 1:
		await get_tree().create_timer(0.02).timeout
		Felice_sprite.modulate = Color(n, n, n, n)
		$AudioStreamPlayer2D4.volume_db = db
		db -= 3
		n+=0.1
	Felice_sprite.modulate = Color(1, 1, 1)
	dumbFlag = true
	if finished:
		nextPhrase(ActionPhase)
	elif !finished:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):#Ускорение вывода букв, если не закончено: скорость увеличена
			$VBoxContainer5/Text.visible_characters += 2
			await get_tree().create_timer(0.000000002).timeout
	
func _on_variant_3_pressed():
	$VBoxContainer4.visible = false
	$VBoxContainer7.modulate = Color(1, 1, 1, 0)
	$VBoxContainer7.size = Vector2(4000,2500)
	$VBoxContainer7.position = Vector2(-330, -500)
	
	ActionPhase = "8"
	$VBoxContainer2.visible = true
	Person_choice2 = 2
	n = 0.7
	while n >= 0:
		await get_tree().create_timer(0.02).timeout
		Felice_sprite.modulate = Color(0.7, 0.7, 0.7, n)
		n-=0.2
	Felice_sprite.modulate = Color(0, 0, 0, 0)
	Felice_sprite.visible = false
	if finished:
		nextPhrase(ActionPhase)
	elif !finished:
		while ($VBoxContainer5/Text.visible_characters < len($VBoxContainer5/Text.text)):#Ускорение вывода букв, если не закончено: скорость увеличена
			$VBoxContainer5/Text.visible_characters += 2
			await get_tree().create_timer(0.000000002).timeout
