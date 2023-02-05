extends RigidBody

var Thingy = preload("res://Scenes/Thingy.tscn")
var grow_this = [preload("res://Scenes/SmallFlowerModel.tscn"),preload("res://Scenes/MushroomModel.tscn")]

var itemToSpawn = 0

func _on_Seed_body_entered(body):
	var new = grow_this[itemToSpawn].instance()
	get_parent().add_child(new)
	new.global_transform.origin = global_transform.origin + (Vector3.UP * 1)
	
	new.global_rotation.y = rand_range(0, PI * 2)
	
	var new2 = Thingy.instance()
	get_parent().add_child(new2)
	new2.global_transform.origin = global_transform.origin + (Vector3.UP * 1)
	
	queue_free()


func _on_DeathTimer_timeout():
	queue_free()
	
func SetItemToSpawnId(ID):
	itemToSpawn = ID

