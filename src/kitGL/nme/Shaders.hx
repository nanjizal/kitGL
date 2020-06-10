package kitGL.nme;

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
    
// just used for docs
enum abstract Shaders( String ){
    var vertexString0_ = vertexString0;
    var fragmentString0_ = fragmentString0;
}