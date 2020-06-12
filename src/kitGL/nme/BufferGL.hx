package kitGL.nme;
#if (!js)
import nme.gl.GL;
import nme.gl.GLProgram;
import nme.utils.Float32Array;
import nme.gl.GLBuffer;

inline
function bufferSetup( program:      GLProgram
                    , data:         Float32Array
                    , ?isDynamic:    Bool = false ): GLBuffer {
    var buf: GLBuffer = GL.createBuffer();
    GL.bindBuffer( GL.ARRAY_BUFFER, buf );
    if( isDynamic ){
        GL.bufferData( GL.ARRAY_BUFFER, untyped data, GL.DYNAMIC_DRAW );
    } else {
        GL.bufferData( GL.ARRAY_BUFFER, untyped data, GL.STATIC_DRAW );
    }
    return buf;	
}
inline
function interleaveXY_RGB( program:   GLProgram 
                         , data:      Float32Array
                         , inPosName: String
                         , inColName: String
                         , ?isDynamic:    Bool = false ): GLBuffer {
    var vbo      = bufferSetup( program, data );
    var posLoc   = GL.getAttribLocation( program, inPosName );
    var colorLoc = GL.getAttribLocation( program, inColName );
    // X Y   R G B
    GL.vertexAttribPointer(
        posLoc, 
        2, 
        GL.FLOAT, 
        false, 
        5 * Float32Array.SBYTES_PER_ELEMENT, 
        0
    );
    GL.vertexAttribPointer(
        colorLoc,
        3,
        GL.FLOAT, 
        false, 
        5 * Float32Array.SBYTES_PER_ELEMENT,
        2 * Float32Array.SBYTES_PER_ELEMENT
    );
    GL.enableVertexAttribArray( posLoc );
    GL.enableVertexAttribArray( colorLoc );
    return vbo;
}
inline
function interleaveXYZ_RGBA( program:   GLProgram 
                           , data:      Float32Array
                           , inPosName: String
                           , inColName: String
                           , ?isDynamic:    Bool = false ): GLBuffer {
    var vbo      = bufferSetup( program, data, isDynamic );
    var posLoc   = GL.getAttribLocation( program, inPosName );
    var colorLoc = GL.getAttribLocation( program, inColName );
    // X Y Z   R G B A
    GL.vertexAttribPointer(
        posLoc, 
        3, 
        GL.FLOAT, 
        false, 
        7 * Float32Array.SBYTES_PER_ELEMENT, 
        0
    );
    GL.vertexAttribPointer(
        colorLoc,
        4,
        GL.FLOAT, 
        false, 
        7 * Float32Array.SBYTES_PER_ELEMENT,
        3 * Float32Array.SBYTES_PER_ELEMENT
    );
    GL.enableVertexAttribArray( posLoc );
    GL.enableVertexAttribArray( colorLoc );
    return vbo;
}
inline
function colorsXYZ_RGBA( program:   GLProgram 
                       , positions: Float32Array 
                       , colors:    Float32Array
                       , inPosName: String
                       , inColName: String ){
    return posColors( program, positions, colors, inPosName, inColName, 3, 4 );
}
inline
function colorsXY_RGBA( program:   GLProgram 
                      , positions: Float32Array 
                      , colors:    Float32Array
                      , inPosName: String
                      , inColName: String ){
    return posColors( program, positions, colors, inPosName, inColName, 2, 4 );
}
inline
function colorsXYZ_RGB( program:   GLProgram 
                      , positions: Float32Array 
                      , colors:    Float32Array
                      , inPosName: String
                      , inColName: String ){
    return posColors( program, positions, colors, inPosName, inColName, 3, 3 );
}
inline
function colorsXY_RGB( program:   GLProgram 
                     , positions: Float32Array 
                     , colors:    Float32Array
                     , inPosName: String
                     , inColName: String ){
    return posColors( program, positions, colors, inPosName, inColName, 2, 3 );
}
inline
function posColors( program:   GLProgram 
                  , positions: Float32Array 
                  , colors:    Float32Array
                  , inPosName: String
                  , inColName: String
                  , noPos = 3
                  , noCols = 4 ){
    var bufferPos = bufferSetup( program, positions );
    var bufferCol = bufferSetup( program, colors );
    var posLoc   = GL.getAttribLocation( program, inPosName );
    var colorLoc = GL.getAttribLocation( program, inColName );
    // RGBA and XYZ with model view projection
    GL.vertexAttribPointer(
        posLoc, 
        noPos, 
        GL.FLOAT, 
        false, 
        noPos * Float32Array.SBYTES_PER_ELEMENT,
        0
    );
    GL.vertexAttribPointer(
        colorLoc,
        noCols,
        GL.FLOAT, 
        false, 
        noCols * Float32Array.SBYTES_PER_ELEMENT,
        0
    );
    GL.enableVertexAttribArray( posLoc );
    GL.enableVertexAttribArray( colorLoc );
    return { pos: bufferPos, col: bufferCol };
}
#end
