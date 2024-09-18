//#include "basic_frag.glsl"
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
    float redlight = round(lightColor.r * 3.0f) / 3.0f;
	float greenlight = round(lightColor.g * 3.0f) / 3.0f;
	float bluelight  = round(lightColor.b * 2.0f) / 2.0f;

    float redgrass = round(foliageColor.r * 3.0f) / 3.0f;
	float greengrass = round(foliageColor.g * 3.0f) / 3.0f;
	float bluegrass  = round(foliageColor.b * 2.0f) / 2.0f;

	float red = round(outputColorData.r * 3.0f) / 3.0f;
	float green = round(outputColorData.g * 3.0f) / 3.0f;
	float blue  = round(outputColorData.b * 2.0f) / 2.0f;
	vec3 outputColor = vec3(red,green,blue) * vec3(redgrass,greengrass,bluegrass) *vec3(redlight,greenlight,bluelight);
    float transparency = outputColorData.a;
    if (transparency < .1){
        discard;
    }
    outColor0 = vec4(outputColor,transparency);
}