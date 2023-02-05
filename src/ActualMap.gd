extends Spatial

var tower_points = []

var towers_on: = false

func _ready():
#	var tower_point = {"position": get_node("BaseMapV2/Cylinder002").global_transform.origin, "enabled": false}
#	tower_points.append(tower_point)
#	$ShaderController.add_point(tower_point)
	setTowerFalse(get_node("BaseMapV2/Cylinder002"))

func _process(_delta):
	if Input.is_action_just_pressed("test_btn"):
		toggle_towers()

func toggle_towers() -> void:
	towers_on = not towers_on
	
	if towers_on:
		print("towers on")
	else:
		print("towers off")
	
	for point in tower_points:
		point.enabled = towers_on
	
	$ShaderController.update_points()
	
func setTowerFalse(node):
	var tower_point = {"position": node.global_transform.origin, "enabled": false}
	tower_points.append(tower_point)
	$ShaderController.add_point(tower_point)
