shader_type canvas_item;

// Declare the uniform for controlling transparency range
uniform sampler2D gradient_alpha;

uniform vec2 sprite_sheet_size = vec2(480, 400);
uniform vec2 frame_size = vec2(40.0, 50.0);

void fragment(){
	// Get the color of the current pixel
	vec4 color = texture(TEXTURE, UV);

    // Calculate the alpha value based on the Y coordinate of the current sprite of the spritesheet
	vec2 current_point = sprite_sheet_size * UV;
	float row = floor(current_point.y / frame_size.y);
	float column = floor(current_point.x / frame_size.x);
	vec2 max_point = (frame_size * vec2(column, row)) + frame_size;
	vec2 new_uv = 1.0 - (max_point - current_point) / frame_size;
    float alpha = texture(gradient_alpha, new_uv).r;

    // Apply the calculated alpha value to the color's alpha channel
    color.a *= alpha;

    // Output the modified color
    COLOR = color;
}