extends Spatial

var seed_scn = preload("res://Scenes/Seed.tscn")
var flowerScn = preload("res://Scenes/SmallFlowerModel.tscn")
onready var aim = $"../CameraFocus/SpringArm"
onready var player = find_parent("Player")
onready var world: Node = player.get_parent()

onready var mush_view = player.find_node("MushroomModel")
var timeWhenLastFired = -200000
var timeWhenLastFired2 = -200000
export var fireCooldown = 200
export var fire2Cooldown = 6000

var seed_velocity = 48.0

var mush_visible = true

func do_fire(ID) -> void:
	match ID:
		0:
			if timeWhenLastFired + fireCooldown >= Time.get_ticks_msec():
				return
			timeWhenLastFired = Time.get_ticks_msec()
		_:	
			if timeWhenLastFired2 + fire2Cooldown >= Time.get_ticks_msec():
				return
			timeWhenLastFired2 = Time.get_ticks_msec()
				
	var new_seed = seed_scn.instance()
	
	world.add_child(new_seed)
	new_seed.global_transform.origin = global_transform.origin
	
	new_seed.linear_velocity = player.linear_velocity
	new_seed.SetItemToSpawnId(ID)
	
	
	var basis = aim.global_transform.basis
	var aim_vector: Vector3 = -basis.z.normalized()
	if aim_vector.project(Vector3.DOWN).length() < 0.5:
		aim_vector = aim_vector.rotated(basis.x, PI/6)
	
	new_seed.apply_central_impulse(aim_vector * seed_velocity)


func _process(_delta):
	if Input.is_action_pressed("fire1"):
		do_fire(0)
	if Input.is_action_pressed("fire2"):
		do_fire(1)
	
	if not mush_visible and timeWhenLastFired2 + fire2Cooldown < Time.get_ticks_msec():
		mush_visible = true
		$AnimateMush.play("grow")
	if mush_visible and timeWhenLastFired2 + fire2Cooldown >= Time.get_ticks_msec():
		mush_visible = false
		$AnimateMush.play_backwards("grow")
	#mush_view.visible = timeWhenLastFired2 + fire2Cooldown < Time.get_ticks_msec()
