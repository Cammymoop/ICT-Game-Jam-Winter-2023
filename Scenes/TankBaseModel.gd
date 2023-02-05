extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tank = preload("res://Scenes/TankModel.tscn")
var distance = 26
var offSet = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	MoveUp()
	

func MoveUp():
	SpawnTank()
	var newPos = transform.origin + Vector3.UP * distance
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "transform:origin" ,newPos, 2)
	
	tween.connect("finished",self,"SendTank")
	
func MoveDown():
	var newPos = transform.origin + Vector3.UP * -distance
	var tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "transform:origin" ,newPos, 2)
	
func SpawnTank():
	var newTank = tank.instance()
	add_child(newTank)
	newTank.global_transform.origin = global_transform.origin + Vector3.UP * offSet
	newTank.look_at(global_translation,Vector3.UP)
	newTank.rotate_y(-PI / 2)
	
func SendTank():
	
	#Tank moves away here
	
	yield(get_tree().create_timer(2), "timeout")
	MoveDown()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
