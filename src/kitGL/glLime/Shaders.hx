package kitGL.glLime;

// RGB & XYZ
inline
var vertexSimpleColor = 
    #if( !desktop || rpi )
    "precision mediump float;" +
    "precision mediump int;" + 
    #end
    "attribute vec2 vertexPosition;" +
    "attribute vec3 vertexColor;" +
    'varying vec3 vColor;'+
    "void main() {" +
        "gl_Position = vec4(vertexPosition, 0.0, 1.0);" +
        "vColor = vertexColor;" +
    "}";
inline
var fragmentSimpleColor = 
    #if( !desktop || rpi )
    "precision mediump float;" +
    "precision mediump int;" + 
    #end
    "varying vec3 vColor;" +
    "void main() {" + 
        "gl_FragColor = vec4( vColor, 1.0 );" +
    "}";
// RGBA and XYZ
inline
var vertexString0: String =
#if( !desktop || rpi )
"precision mediump float;" +
"precision mediump int;" + 
#end
    'attribute vec3 vertexPosition;' +
    'attribute vec4 vertexColor;' +
    'varying vec4 vcol;' +
    'void main(void) {' +
        ' gl_Position = vec4(vertexPosition, 1.0);'+
        ' vcol = vertexColor;' +
    '}';
inline
var fragmentString0: String =
#if( !desktop || rpi )
"precision mediump float;" +
"precision mediump int;" + 
#end
    'varying vec4 vcol;' +
    'void main(void) {' +
        ' gl_FragColor = vcol;' +
    '}';
// RGBA and XYZ with model view projection
inline
var vertexColor: String =
    #if( !desktop || rpi )
    "precision mediump float;" +
    "precision mediump int;" + 
    #end
    'attribute vec3 vertexPosition;' +
    'attribute vec4 vertexColor;' +
    'varying vec4 vcol;' +
    'uniform mat4 modelViewProjection;' +
    'void main(void) {' +
        ' gl_Position = modelViewProjection * vec4(vertexPosition, 1.);' +
        ' vcol = vertexColor;' +
    '}';
inline
var fragmentColor: String =
    #if( !desktop || rpi )
    "precision mediump float;" +
    "precision mediump int;" + 
    #end
    'varying vec4 vcol;' +
    'void main(void) {' +
        'gl_FragColor = vcol;' +
    '}';
// XY, UV with model view projection and texture
inline 
var vertexTexture =
    #if( !desktop || rpi )
    "precision mediump float;" +
    "precision mediump int;" + 
    #end
    "attribute vec2 aVertexPosition;" + 
    "attribute vec2 aTexCoord;" + 
    "uniform mat4 uMatrix;" +
    "varying vec2 vTexCoord;" +
        "void main (void) {" +
            "vTexCoord = aTexCoord;" +
            "gl_Position = uMatrix * vec4 (aVertexPosition, 0.0, 1.0);" +
        "}";
inline
var fragmentTexture = 
    #if( !desktop || rpi )
    "precision mediump float;" +
    #end
    "varying vec2 vTexCoord;" +
    "uniform sampler2D uImage0;" + 
    "void main (void) {" +
        "gl_FragColor = texture2D( uImage0, vTexCoord );" +
    "}";
