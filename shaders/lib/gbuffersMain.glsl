//GBUFFERS_MAIN

/* gbuffers_skybasic */

#if defined skybasic
#if defined fsh 

//skybasic fragment

uniform sampler2D depthtex0;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform vec3 sunPosition;

uniform vec2 viewDimensions;

in vec4 starData;

#include "/lib/shaderConstants.glsl"
#include "/lib/settingsLib/atmosphereConstants.glsl"
#include "/lib/utilities.glsl"
#include "/lib/sky.glsl"

/* DRAWBUFFERS: 0 */
layout (location = 0) out vec4 outColor;

void main() {
	vec2 texcoord 	= gl_FragCoord.xy / viewDimensions.xy;
	float depth 	= texture2D(depthtex0, texcoord.xy).x;
	vec3 wSunPos	= mat3(gbufferModelViewInverse) * sunPosition;
	vec3 screenPos	= vec3(texcoord, depth);
	vec3 viewPos	= calculateViewPosition(screenPos, gbufferProjectionInverse);

	vec3 wDir 		= mat3(gbufferModelViewInverse) * viewPos;
	
	//atmosphere from https://github.com/wwwtyro/glsl-atmosphere

	vec3 skyColor 	= atmosphere(
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

    skyColor 		= 1.0 - exp(-1.0 * skyColor);

	outColor 		= starData.a > 0.5 ? vec4(starData.rgb, 1.0) : vec4(skyColor, 1.0);
}

#endif 

#if defined vsh

//skybasic vertex

out vec4 starData;

void main() {
	gl_Position = ftransform();
    starData = vec4(gl_Color.rgb, float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0));
}

#endif

#endif

/* gbuffers_skytextured */

#if defined skytextured
#if defined fsh

//skytextured fragment

uniform sampler2D texture;

in vec2 texcoord;
in vec4 glcolor;

/* DRAWBUFFERS:0 */
layout (location = 0) out vec4 sunColor;

void main() {
	sunColor = texture2D(texture, texcoord) * glcolor;
}

#endif

#if defined vsh

//skytextured vertex

out vec2 texcoord;
out vec4 glcolor;

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	glcolor = gl_Color;
}

#endif

#endif

/* gbuffers_terrain */

#if defined terrain 
#if defined fsh

//terrain fragment

uniform sampler2D lightmap;
uniform sampler2D texture;

in vec2 lightMapCoord;
in vec2 texcoord;
in vec4 glcolor;

/* DRAWBUFFERS: 0 */
//layout(location = 0) out vec4 terrainColor;
//layout fucks the transparency / alpha of terrain here for some reason (1.17)
//another note: OF 1.16 yells at me if I use texture() here. (or in any gbuffer programs?)

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color *= texture2D(lightmap, lightMapCoord);


    gl_FragData[0] = color; 
}

#endif

#if defined vsh

//terrain vertex

out vec2 lightMapCoord;
out vec2 texcoord;
out vec4 glcolor;

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lightMapCoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;
}

#endif
#endif 

/* gbuffers_clouds */

#if defined clouds 
#if defined fsh

//clouds fragment

uniform sampler2D texture;

in vec2 texcoord;
in vec4 glcolor;

/* DRAWBUFFERS: 0 */
//layout (location = 0) out vec4 cloudColor;
//layout (location = N) fucks the cloud transparency here for some reason...?

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	gl_FragData[0] = color;
    //cloudColor = color;
}

#endif

#if defined vsh

//clouds vertex

out vec2 texcoord;
out vec4 glcolor;

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	glcolor = gl_Color;
}


#endif
#endif 

