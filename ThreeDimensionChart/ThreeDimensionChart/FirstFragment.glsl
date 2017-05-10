varying lowp vec4 DestinationColor;

uniform bool useTexture;
varying lowp vec2 TexCoordOut;
uniform sampler2D Texture;

void main (void) {
    if (useTexture) {
        gl_FragColor = texture2D(Texture, TexCoordOut);
    }else {
        gl_FragColor = DestinationColor;
    }
}