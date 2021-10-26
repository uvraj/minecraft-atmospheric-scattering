#if defined fsh

//Fragment shader

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform vec3 sunPosition, moonPosition;
uniform vec3 cameraPosition;

in vec2 texcoord;

#include "/lib/shaderConstants.glsl"
#include "/lib/settingsLib/atmosphereConstants.glsl"
#include "/lib/sky.glsl"
#include "/lib/utilities.glsl"

/* DRAWBUFFERS: 0 */
layout (location = 0) out vec4 outColor;

void main() {
    vec3 wSunPos = mat3(gbufferModelViewInverse) * sunPosition;

    float depth = texture(depthtex0, texcoord.xy).x;
	vec3 screenPos = vec3(texcoord, depth);
	vec3 viewPos = calculateViewPosition(screenPos);

    vec3 wDir = mat3(gbufferModelViewInverse) * viewPos;

    //atmosphere taken from https://github.com/wwwtyro/glsl-atmosphere

    vec3 skyColor = atmosphere(
        wDir,                           // normalized ray direction
        vec3(0,6372e3,0),               // ray origin
        wSunPos,                   // position of the sun
        sunIntensity,                           // intensity of the sun
        6371e3,                         // radius of the planet in meters
        6471e3,                         // radius of the atmosphere in meters
        vec3(5.5e-6, 13.0e-6, 22.4e-6), // Rayleigh scattering coefficient
        21e-6,                          // Mie scattering coefficient
        8e3,                            // Rayleigh scale height
        1.2e3,                          // Mie scale height
        0.758                           // Mie preferred scattering direction
    );

    skyColor = 1.0 - exp(-1.0 * skyColor);

    outColor = texture(colortex0, texcoord.xy);

    outColor.rgb = depth >= 1.0 ? outColor.rgb + skyColor : outColor.rgb;
} 

#endif


#if defined vsh

//Vertex shader

out vec2 texcoord;

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}


#endif