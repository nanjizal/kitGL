package kitGL.glLime;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;
import lime.graphics.opengl.GLBuffer;

typedef Pos_Col = { 
    var pos: GLBuffer;
    var col: GLBuffer;
}

inline
function bufferSetup( gl:           WebGLRenderContext
                    , program:      GLProgram
                    , data:         Float32Array
                    , ?isDynamic:    Bool = false ): GLBuffer {
    var buf: GLBuffer = gl.createBuffer();
    gl.bindBuffer( gl.ARRAY_BUFFER, buf );
    if( isDynamic ){
        gl.bufferData( gl.ARRAY_BUFFER, untyped data, gl.DYNAMIC_DRAW );
    } else {
        gl.bufferData( gl.ARRAY_BUFFER, untyped data, gl.STATIC_DRAW );
    }
    return buf;	
}
inline
function interleaveXY_RGB(  gl:       WebGLRenderContext
                         , program:   GLProgram 
                         , data:      Float32Array
                         , inPosName: String
                         , inColName: String
                         , ?isDynamic:    Bool = false ): GLBuffer {
    var vbo      = bufferSetup( gl, program, data );
    var posLoc   = gl.getAttribLocation( program, inPosName );
    var colorLoc = gl.getAttribLocation( program, inColName );
    // X Y   R G B
    gl.vertexAttribPointer(
        posLoc, 
        2, 
        gl.FLOAT, 
        false, 
        5 * Float32Array.BYTES_PER_ELEMENT, 
        0
    );
    gl.vertexAttribPointer(
        colorLoc,
        3,
        gl.FLOAT, 
        false, 
        5 * Float32Array.BYTES_PER_ELEMENT,
        2 * Float32Array.BYTES_PER_ELEMENT
    );
    gl.enableVertexAttribArray( posLoc );
    gl.enableVertexAttribArray( colorLoc );
    return vbo;
}
inline
function interleaveXYZ_RGBA( gl:        WebGLRenderContext
                           , program:   GLProgram 
                           , data:      Float32Array
                           , inPosName: String
                           , inColName: String
                           , ?isDynamic:    Bool = false ): GLBuffer {
    var vbo      = bufferSetup( gl, program, data, isDynamic );
    var posLoc   = gl.getAttribLocation( program, inPosName );
    var colorLoc = gl.getAttribLocation( program, inColName );
    // X Y Z   R G B A
    gl.vertexAttribPointer(
        posLoc, 
        3, 
        gl.FLOAT, 
        false, 
        7 * Float32Array.BYTES_PER_ELEMENT, 
        0
    );
    gl.vertexAttribPointer(
        colorLoc,
        4,
        gl.FLOAT, 
        false, 
        7 * Float32Array.BYTES_PER_ELEMENT,
        3 * Float32Array.BYTES_PER_ELEMENT
    );
    gl.enableVertexAttribArray( posLoc );
    gl.enableVertexAttribArray( colorLoc );
    return vbo;
}
inline
function colorsXYZ_RGBA(   gl:        WebGLRenderContext
                       , program:   GLProgram 
                       , positions: Float32Array 
                       , colors:    Float32Array
                       , inPosName: String
                       , inColName: String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 3, 4 );
}
inline
function colorsXY_RGBA( gl:        WebGLRenderContext
                      , program:   GLProgram 
                      , positions: Float32Array 
                      , colors:    Float32Array
                      , inPosName: String
                      , inColName: String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 2, 4 );
}
inline
function colorsXYZ_RGB( gl:        WebGLRenderContext
                      , program:   GLProgram 
                      , positions: Float32Array 
                      , colors:    Float32Array
                      , inPosName: String
                      , inColName: String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 3, 3 );
}
inline
function colorsXY_RGB( gl:        WebGLRenderContext
                     , program:   GLProgram 
                     , positions: Float32Array 
                     , colors:    Float32Array
                     , inPosName: String
                     , inColName: String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 2, 3 );
}
inline
function posColors( gl: WebGLRenderContext
                  , program:   GLProgram 
                  , positions: Float32Array 
                  , colors:    Float32Array
                  , inPosName: String
                  , inColName: String
                  , noPos = 3
                  , noCols = 4 ){
    var bufferPos = bufferSetup( gl, program, positions );
    var bufferCol = bufferSetup( gl, program, colors );
    var posLoc   = gl.getAttribLocation( program, inPosName );
    var colorLoc = gl.getAttribLocation( program, inColName );
    // RGBA and XYZ with model view projection
    gl.vertexAttribPointer(
        posLoc, 
        noPos, 
        gl.FLOAT, 
        false, 
        noPos * Float32Array.BYTES_PER_ELEMENT,
        0
    );
    gl.vertexAttribPointer(
        colorLoc,
        noCols,
        gl.FLOAT, 
        false, 
        noCols * Float32Array.BYTES_PER_ELEMENT,
        0
    );
    gl.enableVertexAttribArray( posLoc );
    gl.enableVertexAttribArray( colorLoc );
    return { pos: bufferPos, col: bufferCol };
}


class BufferGL {
    public var bufferSetup_: 
    ( gl:           WebGLRenderContext
    , program:      GLProgram
    , data:         Float32Array
    , ?isDynamic:    Bool ) -> GLBuffer = bufferSetup;
    public var interleaveXY_RGB_:
    (  gl:         WebGLRenderContext
     , program:    GLProgram 
     , data:       Float32Array
     , inPosName:  String
     , inColName:  String
     , ?isDynamic: Bool ) -> GLBuffer = interleaveXY_RGB;
    public var interleaveXYZ_RGBA_:
    ( gl:          WebGLRenderContext
    , program:     GLProgram 
    , data:        Float32Array
    , inPosName:   String
    , inColName:   String
    , ?isDynamic:  Bool ) -> GLBuffer = interleaveXYZ_RGBA; 
    public var colorsXYZ_RGBA_:
    ( gl:          WebGLRenderContext
    , program:     GLProgram 
    , positions:   Float32Array 
    , colors:      Float32Array
    , inPosName:   String
    , inColName:   String ) -> Pos_Col = colorsXYZ_RGBA;
    public var colorsXY_RGBA_:
    ( gl:          WebGLRenderContext
    , program:     GLProgram 
    , positions:   Float32Array 
    , colors:      Float32Array
    , inPosName:   String
    , inColName:   String ) -> Pos_Col = colorsXY_RGBA;
    public var colorsXYZ_RGB_:
    ( gl:          WebGLRenderContext
    , program:     GLProgram 
    , positions:   Float32Array 
    , colors:      Float32Array
    , inPosName:   String
    , inColName:   String ) -> Pos_Col = colorsXYZ_RGB;
    public var colorsXY_RGB_:
    ( gl:          WebGLRenderContext
    , program:     GLProgram 
    , positions:   Float32Array 
    , colors:      Float32Array
    , inPosName:   String
    , inColName:   String ) -> Pos_Col = colorsXY_RGB;
    public var posColors_:
    ( gl: WebGLRenderContext
    , program:     GLProgram 
    , positions:   Float32Array 
    , colors:      Float32Array
    , inPosName:   String
    , inColName:   String
    , noPos:       Int
    , noCols:      Int ) -> Pos_Col =  posColors;
}