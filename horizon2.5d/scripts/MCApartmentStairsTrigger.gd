extends Area

signal showupstairs
signal hideupstairs

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		if body.translation.y >= 6:
			emit_signal("showupstairs")
		else:
			emit_signal("hideupstairs")
