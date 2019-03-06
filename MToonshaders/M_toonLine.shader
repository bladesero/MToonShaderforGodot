shader_type spatial;
render_mode  cull_front;

varying vec2 uv;

uniform float outlineWidth : hint_range(0.0,10.0)=1;
uniform vec4 outlineColor : hint_color=vec4(0,0,0,1);
uniform sampler2D outlineMask : hint_white;


void vertex()
{
	uv = UV;
	vec3 outline_mask = texture(outlineMask, uv).rgb;
	vec3 outline = NORMAL*outline_mask*outlineWidth*0.001;
	VERTEX+=outline;
}

void fragment()
{
	ALBEDO = outlineColor.rgb;
	NORMAL*=vec3(-1,-1,-1);
}