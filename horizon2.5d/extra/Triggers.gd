extends Area

#signal example
#emit_signal("example")

func _on_ExampleTrigger_body_entered(body):
	if body.is_in_group("player"):
		if body.translation.y >= 6:
			print("do stuff")
		else:
			print("do stuff")

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		if body.translation.y >= 6:
			print("do stuff")
		else:
			print("do stuff")



