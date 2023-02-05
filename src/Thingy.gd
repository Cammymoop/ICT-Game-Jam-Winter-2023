extends Spatial

var explosive_force = 57.0

func _ready():
	$Particles.emitting = false
	$Particles.one_shot = true
	$Particles2.emitting = false
	$Particles2.one_shot = true
	
	esplode()

func esplode():
	$MeshInstance.visible = false
	
	$Particles.emitting = true
	$Particles2.emitting = true
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	call_deferred("launch")

func launch():
	var in_range = $ExplodeArea.get_overlapping_bodies()
	
	for body in in_range:
		print(body.name)
		var body_pos: Vector3 = body.global_transform.origin
		var direction = body_pos - $ExplodeArea.global_transform.origin
		
		var dist = direction.length()
		body.apply_central_impulse(direction.normalized() * explosive_force)


func _on_Timer_timeout():
	queue_free()

