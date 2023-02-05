extends MeshInstance

func _ready():
	var shader_controller = get_node("../ShaderController")
	
	material_override = shader_controller.shader_resource
