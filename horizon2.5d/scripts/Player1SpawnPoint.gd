extends Position3D

func _ready():
	var player1 = preload("res://horizon2.5d/models/base.tscn").instance()
	player1.global_transform = global_transform
	player1.scale = Vector3(12,12,12)
	get_tree().get_root().call_deferred("add_child", player1)
