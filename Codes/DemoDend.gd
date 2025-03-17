extends Node2D

@onready var YesButton: VBoxContainer = $VBoxContainer3
# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	while i < 1:
		await get_tree().create_timer(0.01).timeout
		$CanvasModulate.color = Color(i, i, i)
		i+=0.005
	await get_tree().create_timer(7).timeout
	i = 0
	YesButton.visible = true
	while i < 0.35:
		await get_tree().create_timer(0.01).timeout
		YesButton.modulate = Color(1, 1, 1, i)
		i+=0.005
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file('res://Scenes/Menu.tscn')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_variant_1_pressed() -> void:
	$VBoxContainer3/Variant1.disabled = true
	$AudioStreamPlayer2D2.play()
	await get_tree().create_timer(0.00001).timeout
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file('res://Scenes/Day2/Day2_WakeUp.tscn')
