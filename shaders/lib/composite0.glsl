//COMPOSITE0 
#if defined fsh

//Fragment shader

uniform sampler2D colortex0;

in vec2 texcoord;

#include "/lib/utilities.glsl"

/* DRAWBUFFERS: 0 */
layout (location = 0) out vec4 outColor;

void main() {
    outColor = texture(colortex0, texcoord.xy);
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