#version 460

uniform sampler2D gtexture;
uniform sampler2D lightmap;
/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

in vec2 texCoord;
in vec3 foliageColor;
in vec2 lightMapCoords;
void main() {
    vec3 lightColor = texture(lightmap,vec2(lightMapCoords)).rgb;
    vec4 outputColorData = texture(gtexture,texCoord);
    
	float red = round(outputColor.r * 8.0f) / 8.0f;
	float green = round(outputColor.g * 8.0f) / 8.0f;
	float blue  = round(outputColor.b * 4.0f) / 4.0f;
	vec3 outputColor = outputColorData.rgb * foliageColor *lightColor;
    float transparency = outputColorData.a;
    if (transparency < .1){
        discard;
    }
    outColor0 = vec4(red,green,blue,transparency);
}