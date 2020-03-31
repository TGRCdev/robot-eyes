shader_type spatial;

uniform float pixel_size = 0.025;

uniform vec2 eye1 = vec2(0.25,0.5);
uniform float eyelid1 : hint_range(0.0,1.0) = 1.0;

uniform vec2 eye2 = vec2(0.75,0.5);
uniform float eyelid2 : hint_range(0.0,1.0) = 1.0;

uniform vec4 eye_color : hint_color = vec4(0.0,0.6,1.0,1.0);
uniform float eye_width : hint_range(0.01,0.25) = 0.15;
uniform float eye_pow : hint_range(0.0, 50.0) = 10.0;

uniform float face_height : hint_range(0.001, 1.0) = 0.25;

void fragment()
{
	if(abs(0.5 - UV.y) > face_height) {discard;}
	if(abs(0.5 - UV.x) > face_height)
	{
		vec2 test_uv = UV;
		if(test_uv.x < 0.5) {test_uv.x += 0.5;}
		float dist = distance(test_uv, vec2(0.75, 0.5));
		if(dist > face_height) {discard;}
	}
	
	//vec2 eye1_offset = eye1 - UV;
	//vec2 eye2_offset = eye2 - UV;
	//eye1_offset -= mod(eye1_offset, pixel_size);
	//eye2_offset -= mod(eye2_offset, pixel_size);
	vec2 uv = (UV - mod(UV, pixel_size));
	vec2 pixel_uv = clamp(mod(UV, pixel_size) / pixel_size, vec2(0.0), vec2(1.0));
	vec2 eye1_offset = eye1 - uv;
	vec2 eye2_offset = eye2 - uv;
	
	//uv.y /= eyelid1;
	
	// Distance to center of eye
	float eye1_dist = max(1.0 - (distance(uv + vec2(0.0, eye1_offset.y / (eyelid1 / 2.0)), eye1) / eye_width), 0.0);
	float eye2_dist = max(1.0 - (distance(uv + vec2(0.0, eye2_offset.y / (eyelid2 / 2.0)), eye2) / eye_width), 0.0);
	
	float eye_dist = max(eye1_dist, eye2_dist);
	
	// Pixel color
	vec3 pixel_color = eye_color.rgb * eye_dist;
	
	// Pixel masking amount
	float brightness = max(0.5 - distance(vec2(0.5,0.5), pixel_uv), 0.0);
	
	// Pixel glow amount
	float glow = 1.0 + (pow(eye_dist, 2.0) * eye_pow);
	
	ALBEDO = vec3(0.0);
	EMISSION = (pixel_color * brightness) * glow;
	//EMISSION = pixel_color * 5000.0;
}