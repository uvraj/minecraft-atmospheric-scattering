#include "/lib/syntaxLib.glsl"

#if defined fsh

uniform sampler2D colortex0;

in vec2 texcoord;

/* DRAWBUFFERS: 0 */
layout (location = 0) out vec4 outColor;

void fragmentMain() {
    outColor = texture(colortex0, texcoord.xy);
} 

#endif


#if defined vsh

out vec2 texcoord;

void vertexMain() {
    texcoord = gl_Vertex.xy;
	gl_Position = ftransform();
}

#endif