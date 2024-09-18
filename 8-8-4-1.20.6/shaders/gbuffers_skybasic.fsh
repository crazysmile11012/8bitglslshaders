#version 460 compatibility

uniform float viewHeight;
uniform float viewWidth;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;
uniform vec3 fogColor;
uniform vec3 skyColor;

in vec4 starData; //rgb = star color, a = flag for whether or not this pixel is a star.

float fogify(float x, float w) {
	return w / (x * x + w);
}

vec3 calcSkyColor(vec3 pos) {
	float redsky = round(skyColor.r * 8.0f) / 8.0f;
	float greensky = round(skyColor.g * 8.0f) / 8.0f;
	float bluesky  = round(skyColor.b * 4.0f) / 4.0f;

	float redfog = round(fogColor.r * 8.0f) / 8.0f;
	float greenfog = round(fogColor.g * 8.0f) / 8.0f;
	float bluefog  = round(fogColor.b * 4.0f) / 4.0f;

	float upDot = dot(pos, gbufferModelView[1].xyz); //not much, what's up with you?
	return mix(vec3(redsky,greensky,bluesky), vec3(redfog,greenfog,bluefog), fogify(max(upDot, 0.0), 0.25));
}

vec3 screenToView(vec3 screenPos) {
	vec4 ndcPos = vec4(screenPos, 1.0) * 2.0 - 1.0;
	vec4 tmp = gbufferProjectionInverse * ndcPos;
	return tmp.xyz / tmp.w;
}

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 color;

void main() {
	float redstar = round(starData.r * 8.0f) / 8.0f;
	float greenstar = round(starData.g * 8.0f) / 8.0f;
	float bluestar  = round(starData.b * 4.0f) / 4.0f;
	if (starData.a > 0.5) {
		color = vec4(vec3(redstar,greenstar,bluestar), 1.0);
	} else {
		vec3 pos = screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), 1.0));
		color = vec4(calcSkyColor(normalize(pos)), 1.0);
	}
}