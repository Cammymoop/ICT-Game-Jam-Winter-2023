extends Node

var redMat = preload("res://assets/Materials/RedMat.tres")
var greenMat = preload("res://assets/Materials/GreenMat.tres")
var BaseMat = preload("res://assets/Models/Material_002.material")
var attackParticle = preload("res://Scenes/ParticleScenes/AreaEffectParticle.tscn")
var timeWhenLastFired = 0
var FireCooldown = 2000
var health = 3
var maxHealth
var IAmMushroom = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	maxHealth = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var in_range = $"../Area".get_overlapping_bodies()
	
	for body in in_range:
		if timeWhenLastFired + FireCooldown < Time.get_ticks_msec():
			attck(body.get_parent())
			
func attck(node):
	timeWhenLastFired = Time.get_ticks_msec()
	var particle = attackParticle.instance()
	get_parent().add_child(particle)
	#var offset = Vector3.UP * 2 + global_transform.basis.z * -1.6
	particle.global_transform.origin = get_parent().global_transform.origin
	particle.scale = Vector3.ONE * 0.2
	particle.emitting = true
	particle.get_child(0).emitting = true
	particle.get_child(1).emitting = true
	
	node.takeDamage(1)

func alterHealth(Ammount):
	if(Ammount >0):
		heal()
	else:
		flashRed()
	health += Ammount
	if health > maxHealth:
		health = maxHealth
	if(health <= 0):
		queue_free()
		
func heal():
	
	get_parent().get_node("NurbsPath002").set_surface_material(0, greenMat)
	yield(get_tree().create_timer(0.25), "timeout")
	get_parent().get_node("NurbsPath002").set_surface_material(0, BaseMat)
	
func flashRed():
	
	get_parent().get_node("NurbsPath002").set_surface_material(0, redMat)
	yield(get_tree().create_timer(0.25), "timeout")
	get_parent().get_node("NurbsPath002").set_surface_material(0, BaseMat)
	
