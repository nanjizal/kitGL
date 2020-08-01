package kitGL.glWeb;

inline
var vertexString0: String =
    'attribute vec3 vertexPosition;' +
    'attribute vec4 vertexColor;' +
    'varying vec4 vcol;' +
    'void main(void) {' +
        ' gl_Position = vec4(vertexPosition, 1.0);'+
        ' vcol = vertexColor;' +
    '}';
inline
var fragmentString0: String =
    'precision mediump float;'+
    'varying vec4 vcol;' +
    'void main(void) {' +
        ' gl_FragColor = vcol;' +
    '}';
inline
var vertexString1: String =

    'attribute vec3 vertexPosition;' +
    'attribute vec4 vertexColor;' +
    'attribute vec2 vertexTexture;' +

    'varying vec4 vcol;' +
    'varying vec2 texture;' +

    'void main(void) {' +
        ' gl_Position = vec4( vertexPosition, 1.0);' +
        ' texture = vec2( vertexTexture.x , 1.-vertexTexture.y );' +
        ' vcol = vertexColor;' +
    '}';
inline
var vertexString2: String =

    'attribute vec3 vertexPosition;' +
    'attribute vec4 vertexColor;' +
    'attribute vec2 vertexTexture;' +
    
    'varying vec4 vcol;' +
    'varying vec2 texture;' +
    
    'uniform mat4 modelViewProjection;' +
    
    'void main(void) {' +
        ' gl_Position = modelViewProjection * vec4( vertexPosition, 1.0);' +
        ' texture = vec2( vertexTexture.x , 1.-vertexTexture.y );' +
        ' vcol = vertexColor;' +
    '}';
inline
var fragmentString2: String =
    'precision mediump float;' +
    
    'varying vec4 vcol;' +
    'varying vec2 texture;' +
    
    'uniform sampler2D uImage0;' +
    
    'void main(void) {' +
    /*'float bound =   step( texture.s, 1. ) *' +
                    'step( texture.t, 1. ) *' +
                ' ( 1. - step( texture.s, 0. ) ) * ' +
                ' ( 1. - step( texture.t, 0. ) );' + 
        'vec2 clampedUv = clamp(texture, 0., 1.);'+*/
        'vec4 texcolor = texture2D( uImage0, vec2( texture.s, texture.t ) ) * vcol;'+
        //'vec4 texcolor = texture2D( image, vec2( clampedUv.s, clampedUv.t + 0.5 ) ) * vcol;'+
        'texcolor.rgb *= vcol.a; ' + 
        'gl_FragColor = texcolor;' + /*bound*texcolor;' + */
    /*
        'float bound =   step( texture.s, 1. ) *' +
                        'step( texture.t, 1. ) *' +
                    ' ( 1. - step( texture.s, 0. ) ) * ' +
                    ' ( 1. - step( texture.t, 0. ) );' + 
                   
        'vec4 texcolor = texture2D( image, vec2( texture.s, texture.t ) ) * vcol;' + 
        'texcolor.rgb *= vcol.a; ' + 
        'gl_FragColor = bound * texcolor;' +*/
    '}';


// just used for docs
enum abstract Shaders( String ){
    var vertexString0_ = vertexString0;
    var fragmentString0_ = fragmentString0;
    var vertexString1_ = vertexString1;
    var vertexString2_ = vertexString2;
    var fragmentString2_ = fragmentString2;
}