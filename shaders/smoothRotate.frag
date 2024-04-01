#pragma header

uniform float uTime = 0.0;

const float pi = 3.14159265358979323846264338327950;

void main() {
    vec2 uv = openfl_TextureCoordv;

    float theta = uTime * 2.0 * pi;

    vec2 rotUV = vec2((uv.x - 0.5) * cos(theta) - (uv.y - 0.5) * sin(theta) + 0.5,  (uv.x - 0.5) * sin(theta) + (uv.y - 0.5) * cos(theta) + 0.5);

    vec4 texCol = flixel_texture2D(bitmap, rotUV);
    vec3 col = texCol.xyz;

    gl_FragColor = vec4(col, texCol.a);
}