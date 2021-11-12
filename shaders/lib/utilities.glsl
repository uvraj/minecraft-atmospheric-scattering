vec3 calculateViewPosition(vec3 screenPosition, mat4 gbufferProjectionInverse) {
    vec3 clipPosition = screenPosition * 2.0 - 1.0;
    vec4 temp = gbufferProjectionInverse * vec4(clipPosition, 1.0);
    return temp.xyz / temp.w;
}