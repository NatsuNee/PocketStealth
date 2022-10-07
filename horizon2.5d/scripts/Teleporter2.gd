extends Area

#signal example
#emit_signal("example")

func _on_HometoVillage_body_entered(body):
	if body.is_in_group("player"):
		body.emit_signal("transistion","Home","home")



