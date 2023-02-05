tool
extends Spatial

export var make_bodies: = false setget do_make_bodies

func do_make_bodies(val) -> void:
	if not Engine.editor_hint or not val:
		return
	
	for c in get_children():
		var mesh = c as MeshInstance
		if not mesh:
			continue
		
		for subchild in c.get_children():
			if subchild is StaticBody:
				subchild.queue_free()
				mesh.remove_child(subchild)
		
		mesh.create_trimesh_collision()
		
		var static_body: = mesh.get_child(0) as StaticBody
		if static_body:
			static_body.set_collision_layer_bit(1, true)
		
