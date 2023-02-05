extends RigidBody

var grow_this = preload("res://Scenes/SmallFlowerModel.tscn")
var grow_this2 = preload("res://Scenes/Thingy.tscn")

func _on_Seed_body_entered(body):
	var new = grow_this.instance()
	get_parent().add_child(new)
	new.global_transform.origin = global_transform.origin + (Vector3.UP * 1)
	
	var new2 = grow_this2.instance()
	get_parent().add_child(new2)
	new2.global_transform.origin = global_transform.origin + (Vector3.UP * 1)
	
	queue_free()


func _on_DeathTimer_timeout():
	queue_free()

