package kitGL.gluon;

import gluon.webgl.GLContext;

import gluon.webgl.GLProgram;
import typedarray.Float32Array;
import gluon.webgl.GLBuffer;
    
inline
function bufferSetup( gl:           GLContext
                    , program:      GLProgram
                    , data:         Float32Array
                    , ?isDynamic:    Bool = false ): GLBuffer {
    var buf: GLBuffer = gl.createBuffer();
    gl.bindBuffer( BufferTarget.ARRAY_BUFFER, buf );
    if( isDynamic ){
        gl.bufferData( BufferTarget.ARRAY_BUFFER, untyped data, BufferUsage.DYNAMIC_DRAW );
    } else {
        gl.bufferData( BufferTarget.ARRAY_BUFFER, untyped data, BufferUsage.STATIC_DRAW );
    }
    return buf;	
}
inline
function interleaveXY_RGB(  gl:       GLContext
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
        DataType.FLOAT, 
        false, 
        5 * Float32Array.BYTES_PER_ELEMENT, 
        0
    );
    gl.vertexAttribPointer(
        colorLoc,
        3,
        DataType.FLOAT, 
        false, 
        5 * Float32Array.BYTES_PER_ELEMENT,
        2 * Float32Array.BYTES_PER_ELEMENT
    );
    gl.enableVertexAttribArray( posLoc );
    gl.enableVertexAttribArray( colorLoc );
    return vbo;
}
inline
function interleaveXYZ_RGBA( gl:        GLContext
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
        DataType.FLOAT, 
        false, 
        7 * Float32Array.BYTES_PER_ELEMENT, 
        0
    );
    gl.vertexAttribPointer(
        colorLoc,
        4,
        DataType.FLOAT, 
        false, 
        7 * Float32Array.BYTES_PER_ELEMENT,
        3 * Float32Array.BYTES_PER_ELEMENT
    );
    gl.enableVertexAttribArray( posLoc );
    gl.enableVertexAttribArray( colorLoc );
    return vbo;
}
inline
function colorsXYZ_RGBA(   gl:        GLContext
                       , program:   GLProgram 
                       , positions: Float32Array 
                       , colors:    Float32Array
                       , inPosName: String
                       , inColName: String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 3, 4 );
}
inline
function colorsXY_RGBA( gl:        GLContext
                      , program:   GLProgram 
                      , positions: Float32Array 
                      , colors:    Float32Array
                      , inPosName: String
                      , inColName: String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 2, 4 );
}
inline
function colorsXYZ_RGB( gl:        GLContext
                      , program:   GLProgram 
                      , positions: Float32Array 
                      , colors:    Float32Array
                      , inPosName: String
                      , inColName: String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 3, 3 );
}
inline
function colorsXY_RGB( gl:        GLContext
                     , program:   GLProgram 
                     , positions: Float32Array 
                     , colors:    Float32Array
                     , inPosName: String
                     , inColName: String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 2, 3 );
}
inline
function posColors( gl: GLContext
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
        DataType.FLOAT, 
        false, 
        noPos * Float32Array.BYTES_PER_ELEMENT,
        0
    );
    gl.vertexAttribPointer(
        colorLoc,
        noCols,
        DataType.FLOAT, 
        false, 
        noCols * Float32Array.BYTES_PER_ELEMENT,
        0
    );
    gl.enableVertexAttribArray( posLoc );
    gl.enableVertexAttribArray( colorLoc );
    return { pos: bufferPos, col: bufferCol };
}