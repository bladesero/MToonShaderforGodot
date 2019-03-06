shader_type spatial;

uniform sampler2D light_Texture : hint_albedo;
uniform vec4 light_Color : hint_color=vec4(1,1,1,1);

uniform sampler2D shadow_Texture : hint_albedo;
uniform vec4 shadow_Color : hint_color=vec4(0,0,0,1);

uniform sampler2D normalTexture : hint_albedo;
uniform float normal_scale : hint_range(-5.0,5.0)=0;

uniform float shadeShift : hint_range(-1.0, 1.0)=0;
uniform float shadeToony : hint_range(0, 1.0)=0.9;

uniform sampler2D MatCap : hint_black;

varying vec2 uv;
varying vec4 color;

void vertex()
{
	uv = UV;
	color = COLOR;
}

void fragment()
{
	ALBEDO = texture(light_Texture, uv).rgb*light_Color.rgb;
	NORMALMAP=texture(normalTexture,uv).rgb;
	NORMALMAP_DEPTH = normal_scale;
}

void light()
{
	vec3 light = normalize(LIGHT);
	float lightIntensity = dot(light, NORMAL)*0.5+0.5;
	lightIntensity = lightIntensity * 2.0 - 1.0;
    lightIntensity = smoothstep(shadeShift, shadeShift + (1.01 - shadeToony), lightIntensity);
	
	vec3 shadow = texture(shadow_Texture, uv).rgb*shadow_Color.rgb;
	vec3 finalColor = mix(shadow, ALBEDO.rgb, lightIntensity*ATTENUATION);
	finalColor *= LIGHT_COLOR.rgb;
	
	vec2 vN = NORMAL.xy/2.0 + vec2(0.5,0.5);
	vN.y = vN.y*(-1.0)+1.0;
	
	vec3 matcapadd = texture(MatCap,vN).rgb;
	finalColor += (LIGHT_COLOR.rgb*matcapadd);

	DIFFUSE_LIGHT=finalColor;

}