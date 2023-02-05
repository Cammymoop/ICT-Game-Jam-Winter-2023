extends RigidBody


func _on_Area_body_entered(body):
	if body.name == "Player" and not body.has_fruit:
		body.get_seed()
		queue_free()
