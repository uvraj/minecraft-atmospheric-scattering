#include "/lib/syntaxLib.glsl"

/* gbuffers_skybasic */

#if defined skybasic
#if defined fsh 

in vec4 starData;

/* DRAWBUFFERS: 0 */
layout (location = 0) out vec4 skyColor;

void fragmentMain() {
	skyColor = starData.a > 0.5 ? vec4(starData.rgb, 1.0) : vec4(0.0, 0.0, 0.0, 1.0);
}

#endif 

#if defined vsh

out vec4 starData;

void vertexMain() {
	gl_Position = ftransform();
    starData = vec4(gl_Color.rgb, float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0));
}

#endif
#endif




/* gbuffers_skytextured */

#if defined skytextured
#if defined fsh

uniform sampler2D texture;

in vec2 texcoord;
in vec4 glcolor;

/* DRAWBUFFERS:0 */
layout (location = 0) out vec4 sunColor;

void fragmentMain() {
	sunColor = texture2D(texture, texcoord) * glcolor;
}

#endif

#if defined vsh

out vec2 texcoord;
out vec4 glcolor;

void vertexMain() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	glcolor = gl_Color;
}

#endif
#endif




/* gbuffers_terrain */

#if defined terrain 
#if defined fsh

uniform sampler2D lightmap;
uniform sampler2D texture;

in vec2 lightMapCoord;
in vec2 texcoord;
in vec4 glcolor;

/* DRAWBUFFERS: 0 */
//layout(location = 0) out vec4 terrainColor;
//layout fucks the transparency / alpha of terrain here for some reason (1.17)

void fragmentMain() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color *= texture2D(lightmap, lightMapCoord);


    gl_FragData[0] = color; 
}

#endif

#if defined vsh

out vec2 lightMapCoord;
out vec2 texcoord;
out vec4 glcolor;

void vertexMain() {
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

uniform sampler2D texture;

in vec2 texcoord;
in vec4 glcolor;

/* DRAWBUFFERS: 0 */
//layout (location = 0) out vec4 cloudColor;
//layout (location = N) fucks the cloud transparency here for some reason...?

void fragmentMain() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	gl_FragData[0] = color;
    //cloudColor = color;
}

#endif

#if defined vsh

out vec2 texcoord;
out vec4 glcolor;

void vertexMain() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	glcolor = gl_Color;
}

#endif
#endif 

