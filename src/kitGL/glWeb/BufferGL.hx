package kitGL.glWeb;
import js.html.webgl.RenderingContext;
import js.html.webgl.Buffer;
import haxe.io.Float32Array;
import js.html.webgl.Program;
import kitGL.glWeb.BufferGL;
inline
function bufferSetup( gl:           RenderingContext
                    , program:      Program
                    , data:         Float32Array ): Buffer {
    var buf: Buffer = gl.createBuffer();
    gl.bindBuffer( RenderingContext.ARRAY_BUFFER, buf );
    gl.bufferData( RenderingContext.ARRAY_BUFFER, untyped data, RenderingContext.STATIC_DRAW );
    return buf;	
}
inline
function interleaveXYZ_RGBA( gl:       RenderingContext
                           , program:   Program 
                           , data:      Float32Array
                           , inPosName: String
                           , inColName: String ){
    var vbo      = bufferSetup( gl, program, data );
    var posLoc   = gl.getAttribLocation( program, inPosName );
    var colorLoc = gl.getAttribLocation( program, inColName );
    // X Y Z   R G B A
    gl.vertexAttribPointer(
        posLoc, 
        3, 
        RenderingContext.FLOAT, 
        false, 
        7 * Float32Array.BYTES_PER_ELEMENT, 
        0
    );
    gl.vertexAttribPointer(
        colorLoc,
        4,
        RenderingContext.FLOAT, 
        false, 
        7 * Float32Array.BYTES_PER_ELEMENT,
        3 * Float32Array.BYTES_PER_ELEMENT
    );
    gl.enableVertexAttribArray( posLoc );
    gl.enableVertexAttribArray( colorLoc );
}
inline
function interleaveXY_RGB( gl:       RenderingContext
                         , program:   Program 
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
        RenderingContext.FLOAT, 
        false, 
        5 * Float32Array.BYTES_PER_ELEMENT, 
        0
    );
    gl.vertexAttribPointer(
        colorLoc,
        3,
        RenderingContext.FLOAT, 
        false, 
        5 * Float32Array.BYTES_PER_ELEMENT,
        2 * Float32Array.BYTES_PER_ELEMENT
    );
    gl.enableVertexAttribArray( posLoc );
    gl.enableVertexAttribArray( colorLoc );
}
inline
function colorsXYZ_RGBA( gl:        RenderingContext
                       , program:   Program 
                       , positions: Float32Array 
                       , colors:    Float32Array
                       , inPosName: String
                       , inColName: String ){
    posColors( gl, program, positions, colors, inPosName, inColName, 3, 4 );
}
inline
function colorsXY_RGBA( gl:        RenderingContext
                      , program:   Program 
                      , positions: Float32Array 
                      , colors:    Float32Array
                      , inPosName: String
                      , inColName: String ){
    posColors( gl, program, positions, colors, inPosName, inColName, 2, 4 );
}
inline
function colorsXYZ_RGB( gl:        RenderingContext
                      , program:   Program 
                      , positions: Float32Array 
                      , colors:    Float32Array
                      , inPosName: String
                      , inColName: String ){
    posColors( gl, program, positions, colors, inPosName, inColName, 3, 3 );
}
inline
function colorsXY_RGB( gl:        RenderingContext
                     , program:   Program 
                     , positions: Float32Array 
                     , colors:    Float32Array
                     , inPosName: String
                     , inColName: String ){
    posColors( gl, program, positions, colors, inPosName, inColName, 2, 3 );
}
inline
function posColors( gl: RenderingContext
                  , program:   Program 
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
        RenderingContext.FLOAT, 
        false, 
        noPos * Float32Array.BYTES_PER_ELEMENT,
        0
    );
    gl.vertexAttribPointer(
        colorLoc,
        noCols,
        RenderingContext.FLOAT, 
        false, 
        noCols * Float32Array.BYTES_PER_ELEMENT,
        0
    );
    gl.enableVertexAttribArray( posLoc );
    gl.enableVertexAttribArray( colorLoc );
}

// just used for docs
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
