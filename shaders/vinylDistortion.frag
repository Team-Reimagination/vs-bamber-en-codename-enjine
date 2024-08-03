#pragma header
uniform float distortion;
void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = openfl_TextureCoordv;
    
    //Variables
    float sizeTop = (distortion / 2.0 + 0.5) * 0.8 + 0.2;
    const float sizeBottom = 1.0;
    
    //Distortion
    float size = mix(sizeBottom, sizeTop, uv.y);
    float reciprocal = 1.0 / size;
    uv.x = uv.x * reciprocal + (1.0 - reciprocal) / 2.0;
    float skibidi = (distortion - 1.0) * 3.0;
    uv.y -= skibidi * uv.y - skibidi;
    
    //Texture
    vec4 color = flixel_texture2D( bitmap, uv );
    
    // Output to screen
    if ((uv.x >= 0.0 && uv.x <= 1.0) && (uv.y >= 0.0 && uv.y <= 1.0))
        gl_FragColor = color;
}