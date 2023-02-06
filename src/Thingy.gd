extends Spatial

var explosive_force = 57.0
var healing = false

var damage_amount: = 1.0
var heal_amount: = 1.0

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
		if body.name == "Player":
			var body_pos: Vector3 = body.global_transform.origin
			var direction = body_pos - $ExplodeArea.global_transform.origin
			
			var dist = direction.length()
			body.apply_central_impulse(direction.normalized() * explosive_force)
		elif "IAmTank" in body.get_parent():
			body.get_parent().takeDamage(damage_amount)
		elif body.get_parent().has_method("heal") and healing:
			if healing:
				body.get_parent().heal(heal_amount)
		elif body.get_parent().get_node("Node") != null:
			if "IAmMushroom" in body.get_parent().get_node("Node"):
				if healing:
					body.get_parent().get_node("Node").alterHealth(heal_amount)
					#print(body.get_parent().get_node("Node").health)
			
		


func _on_Timer_timeout():
	queue_free()

