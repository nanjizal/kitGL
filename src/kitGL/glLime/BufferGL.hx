package kitGL.glLime;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;
import lime.graphics.opengl.GLBuffer;

inline
function bufferSetup( gl:           WebGLRenderContext
                    , program:      GLProgram
                    , data:         Float32Array ): GLBuffer {
    var buf: GLBuffer = gl.createBuffer();
    gl.bindBuffer( gl.ARRAY_BUFFER, buf );
    gl.bufferData( gl.ARRAY_BUFFER, data,  gl.STATIC_DRAW );
    return buf;	
}
inline
function interleaveXY_RGB(  gl:        WebGLRenderContext
                         , program:   GLProgram 
                         , data:      Float32Array
                         , inPosName: String
                         , inColName: String ){
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
}
inline
function colorsXYZ_RGBA(   gl:        WebGLRenderContext
                       , program:   GLProgram 
                       , positions: Float32Array 
                       , colors:    Float32Array
                       , inPosName: String
                       , inColName: String ){
    posColors( gl, program, positions, colors, inPosName, inColName, 3, 4 );
}
inline
function colorsXY_RGBA( gl:        WebGLRenderContext
                      , program:   GLProgram 
                      , positions: Float32Array 
                      , colors:    Float32Array
                      , inPosName: String
                      , inColName: String ){
    posColors( gl, program, positions, colors, inPosName, inColName, 2, 4 );
}
inline
function colorsXYZ_RGB( gl:        WebGLRenderContext
                      , program:   GLProgram 
                      , positions: Float32Array 
                      , colors:    Float32Array
                      , inPosName: String
                      , inColName: String ){
    posColors( gl, program, positions, colors, inPosName, inColName, 3, 3 );
}
inline
function colorsXY_RGB( gl:        WebGLRenderContext
                     , program:   GLProgram 
                     , positions: Float32Array 
                     , colors:    Float32Array
                     , inPosName: String
                     , inColName: String ){
    posColors( gl, program, positions, colors, inPosName, inColName, 2, 3 );
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
    var bufferPos = BufferHelpGL.bufferSetup( gl, program, positions );
    var bufferCol = BufferHelpGL.bufferSetup( gl, program, colors );
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
}

class BufferGL{
    public var bufferSetup_: ( gl: RenderingContext
                             , programe: Program
                             , data: Float32Array )->Buffer = bufferSetup;
    public var interleaveXYZ_RGBA_: ( gl:       RenderingContext
                                    , program:   Program 
                                    , data:      Float32Array
                                    , inPosName: String
                                    , inColName: String )->Void = interleaveXYZ_RGBA;
    public var interleaveXY_RGB_: ( gl:       RenderingContext
                                  , program:   Program 
                                  , data:      Float32Array
                                  , inPosName: String
                                  , inColName: String ) -> Void = interleaveXY_RGB;
    public var colorsXYZ_RGBA_: ( gl:        RenderingContext
                                , program:   Program 
                                , positions: Float32Array 
                                , colors:    Float32Array
                                , inPosName: String
                                , inColName: String ) -> Void = colorsXYZ_RGBA;
    public var colorsXY_RGBA_: ( gl:        RenderingContext
                               , program:   Program 
                               , positions: Float32Array 
                               , colors:    Float32Array
                               , inPosName: String
                               , inColName: String ) -> Void = colorsXY_RGBA;
    public var posColors_: ( gl: RenderingContext
                           , program:   Program 
                           , positions: Float32Array 
                           , colors:    Float32Array
                           , inPosName: String
                           , inColName: String
                           , ?noPos: Int
                           , ?noCols: Int ) -> Void = posColors;
}