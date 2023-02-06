extends Spatial

var shootParticle = preload("res://TankParticleShoot.tscn")
var dieParticle = preload("res://Scenes/ParticleScenes/TankDieParticle.tscn")
var redMat = preload("res://assets/Materials/RedMat.tres")
var BaseMat = preload("res://assets/Models/Material_010.material")

#var pole_scn = preload("res://Scenes/pole.tscn")

var target_ref: WeakRef

var turnSpeed = 0.05
var enabled = true
var TankHealth: = 3.0
var IAmTank = true
var timeWhenLastFired = 0
var FireCooldown = 2000

var my_range = 12.5
var max_range = 200.0

var attack_damage = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
#	$KinematicBody.set_collision_layer_bit(6, false)
	pass

func acquire_target() -> void:
	#("a")
	target_ref = null
	var targets = get_tree().get_nodes_in_group("findable")
	
	var min_dist = max_range
	for t in targets:
		var body = t as PhysicsBody
		var dist_to_target = (global_translation - body.global_translation).length()
		
		if dist_to_target > max_range:
			continue
		if dist_to_target > min_dist:
			continue
		
		if "i_am_tower" in body.get_parent():
			var tower = body.get_parent()
			if not tower.activated and not tower.growing:
				continue
		
		min_dist = dist_to_target
		target_ref = weakref(body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !enabled:
		return
	
	if target_ref and not target_ref.get_ref():
		target_ref = null
		return
	
	if !target_ref:
		acquire_target()
		if !target_ref:
			return
	
	
	var target = target_ref.get_ref()
	
	var newTarget = target.global_translation
	newTarget.y = global_translation.y
	
	var dist = (global_translation - newTarget).length()
	#print(global_translation, " ", newTarget)
	if dist <= my_range:
#		var p = pole_scn.instance()
#		get_parent().add_child(p)
#		p.global_translation = global_translation
#		queue_free()
	
		$LookAt.look_at(newTarget,Vector3.UP)
		global_transform = global_transform.interpolate_with($LookAt.global_transform,turnSpeed)
	
		var in_range = $Area.get_overlapping_bodies()
	
		for body in in_range:
			if body == $KinematicBody:
				continue
			if timeWhenLastFired + FireCooldown < Time.get_ticks_msec():
				Fire()
	else:
		$LookAt.look_at(newTarget,Vector3.UP)
		var angle = global_transform.basis.get_rotation_quat().angle_to($LookAt.global_transform.basis.get_rotation_quat())
		if angle > PI/12:
			global_transform = global_transform.interpolate_with($LookAt.global_transform,turnSpeed)
		
		$RayCast.force_raycast_update()
		var new_pos = $RayCast.get_collision_point()
		global_translation = new_pos
		
		
	
	
func Fire():
	timeWhenLastFired = Time.get_ticks_msec()
	var particle = shootParticle.instance()
	get_parent().add_child(particle)
	var offset = Vector3.UP * 2 + global_transform.basis.z * -1.6
	particle.global_transform.origin = global_transform.origin + offset
	particle.global_rotation.y = global_rotation.y
	particle.scale = Vector3.ONE * 0.5
	particle.emitting = true
	
	$AnimationPlayer.play("kickbakc")
	if target_ref and target_ref.get_ref():
		var parent = target_ref.get_ref().get_parent()
		if parent.get_node("Node") != null:
			#mushroom
			parent.get_node("Node").alterHealth(-attack_damage)
		 
		if parent.has_method("take_damage"):
			parent.take_damage(attack_damage)
	target_ref = null
	
func takeDamage(damage):
	TankHealth -= damage
	get_node("Cube").set_surface_material(0, redMat)
	#print(TankHealth)
	if(TankHealth <= 0):
		Die()
		return
	
	yield(get_tree().create_timer(0.25), "timeout")
	get_node("Cube").set_surface_material(0, BaseMat)
		
func Die():
	var particle = dieParticle.instance()
	get_parent().add_child(particle)
	particle.global_transform.origin = global_transform.origin + Vector3.UP * 2
	particle.emitting = true
	queue_free()
