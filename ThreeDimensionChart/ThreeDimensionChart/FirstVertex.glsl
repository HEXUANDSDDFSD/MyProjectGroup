attribute vec4 Position;
attribute vec4 SourceColor;
uniform mat4 Projection;
uniform mat4 Modelview;

uniform mat3 normalMatrix;
uniform vec3 vLightPosition;
uniform vec4 vAmbientMaterial;
uniform vec4 vSpecularMaterial;
uniform float shininess;

attribute vec3 vNormal;
attribute vec4 vDiffuseMaterial;

varying lowp vec4 DestinationColor;

attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

void main(void) {
    //DestinationColor = SourceColor;
    gl_Position = Projection * Modelview * Position;
    
    vec3 N = vNormal;
    vec3 L = normalize(vLightPosition);
    vec3 E = vec3(0, 0, 1);
    vec3 H = normalize(L + E);
    
    float df = max(0.0, dot(N, L));
    float sf = max(0.0, dot(N, H));
    sf = pow(sf, shininess);
    
    DestinationColor = vAmbientMaterial + df * vDiffuseMaterial + sf * vSpecularMaterial;
    
    TexCoordOut = TexCoordIn;
}