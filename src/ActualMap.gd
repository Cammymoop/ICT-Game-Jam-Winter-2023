extends Spatial

var tower_points = []

var towers_on: = false

var tower_radius = 120.0;

var totalTowers = 7

func _ready():
#	var tower_point = {"position": get_node("BaseMapV2/Cylinder002").global_transform.origin, "enabled": false}
#	tower_points.append(tower_point)
#	$ShaderController.add_point(tower_point)
	#setTowerFalse(get_node("BaseMapV2/Cylinder002"))
	
	for tower in $Towers.get_children():
		setTowerFalse(tower)
		tower.connect("activated", self, "tower_activated")
		
func count_towers_on():
	var count = 0
	for p in tower_points:
		if p.enabled:
			count += 1
	if count >= totalTowers:
		get_node("CanvasLayer").get_child(0).visible = true
	

func tower_activated(tower) -> void:
	var point = {}
	for p in tower_points:
		if p.object == tower:
			point = p
	
	if not point:
		return
	point.enabled = true
	print(tower_points)
	
	$ShaderController.update_points()
	
	count_towers_on()

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
	var tower_point = {"object": node, "position": node.global_transform.origin, "enabled": false}
	tower_points.append(tower_point)
	$ShaderController.add_point(tower_point)
