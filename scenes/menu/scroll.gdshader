shader_type canvas_item;

uniform float speed = .03;
void vertex() {
	UV.y += TIME * speed;
	UV.x += TIME * speed;
}
