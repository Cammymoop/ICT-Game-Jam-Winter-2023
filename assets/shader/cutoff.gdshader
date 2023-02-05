shader_type spatial;

void fragment() {
	vec3 world_pos = (CAMERA_MATRIX * vec4(VERTEX, 1.0)).xyz;
	ALPHA = 1.0-step(0.2, world_pos.y);
}