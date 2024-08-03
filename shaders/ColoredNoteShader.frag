#pragma header

uniform float r;
uniform float g;
uniform float b;

void main() {
    float red = r / 255;
    float green = g / 255;
    float blue = b / 255;
    vec4 finalColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
    float diff = abs(finalColor.r - ((finalColor.g + finalColor.b) / 2.0));
    gl_FragColor = vec4(((finalColor.g + finalColor.b) / 2.0) + (red * diff), finalColor.g + (green * diff), finalColor.b + (blue * diff), finalColor.a);
}