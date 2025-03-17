extends Node2D

func _ready():
	var i = 0
	while i < 1:
		await get_tree().create_timer(0.01).timeout
		$CanvasModulate.color = Color(i, i, i)
		i+=0.005
	await get_tree().create_timer(7).timeout
	get_tree().change_scene_to_file('res://Scenes/Menu.tscn')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
