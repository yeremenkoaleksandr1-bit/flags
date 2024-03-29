#version 460 core

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_size;

out vec4 fragColor;

float manhattan(vec2 pos){
    // Calculate the normalized coordinates
    vec2 uv=pos/u_resolution;

    vec2 pixel=uv*u_size;

    return floor(pixel.x)+floor(pixel.y);
}

void main(){
    // Calculate manhatten distance
    float distance=manhattan(gl_FragCoord.xy);
    // Calculate the normalized distance
    float ud=distance/(u_size.x+u_size.y);

    // Calculate the fade value based on time and distance
    float fade=smoothstep(0., 1., u_time-ud);

    // Set the output color with the fade value
    fragColor=vec4(fade, fade, fade, fade);
}