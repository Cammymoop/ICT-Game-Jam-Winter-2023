extends RigidBody

var grow_this = preload("res://Scenes/Thingy.tscn")

func _on_Seed_body_entered(body):
	var new = grow_this.instance()
	get_parent().add_child(new)
	new.global_transform.origin = global_transform.origin - (Vector3.UP * 0.15)
	
	queue_free()


func _on_DeathTimer_timeout():
	queue_free()

