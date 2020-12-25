package kitGL.glWeb;
#if js
import js.html.webgl.RenderingContext;
import js.html.webgl.Buffer;
import js.html.webgl.Program;

import haxe.io.Float32Array;
import kitGL.glWeb.BufferGL;
import kitGL.glWeb.GL;

inline
function bufferSetup( gl:           GL
                    , program:      Program
                    , data:         Float32Array
                    , ?isDynamic:    Bool = false ): Buffer {
    var buf: Buffer = gl.createBuffer();
    var staticDraw  = GL.STATIC_DRAW;
    var dynamicDraw = GL.DYNAMIC_DRAW;
    var arrayBuffer = GL.ARRAY_BUFFER;
    gl.bindBuffer( arrayBuffer, buf );
    ( isDynamic )? dataSet( gl, untyped data, dynamicDraw ): dataSet( gl, untyped data, staticDraw );
    //gl.bindBuffer( RenderingContext.ARRAY_BUFFER, null );
    return buf;	
}

inline
function dataSet( gl: GL, data: Float32Array, isDraw: Int ){
    var arrayBuffer = GL.ARRAY_BUFFER;
    gl.bufferData( arrayBuffer, untyped data, isDraw );
}

inline
function inputAttribute( gl: GL, program: Program, name: String ): Int {
    return gl.getAttribLocation( program, name );
}

inline
function inputAttEnable(  gl: GL, program: Program, name: String
                        , size: Int, stride: Int, off: Int ){
    var inp            = inputAttribute( gl, program, name );
    var elementBytes   = Float32Array.BYTES_PER_ELEMENT;
    var fp             = GL.FLOAT;
    var strideBytes    = stride*elementBytes;
    var offBytes       = off*elementBytes;
    gl.vertexAttribPointer( inp, size, fp, false, strideBytes, offBytes );
    gl.enableVertexAttribArray( inp );
    return inp;
}
inline
function interleaveXYZ_RGBA( gl:            GL
                           , program:       Program 
                           , data:          Float32Array
                           , xyzName:       String
                           , rgbaName:      String
                           , ?isDynamic:    Bool = false ): Buffer {
    var vbo          = bufferSetup( gl, program, data, isDynamic ); 
    // X Y Z   R G B A
    inputAttEnable( gl,  program, xyzName, 3, 7, 0 );
    inputAttEnable( gl, program, rgbaName, 4, 7, 3 );
    return vbo;
}
inline
function updateBufferXYZ_RGBA( gl:       GL
                           , program:     Program 
                           , xyzName:     String
                           , rgbaName:    String ){
    inputAttEnable( gl,  program, xyzName, 3, 7, 0 );
    inputAttEnable( gl, program, rgbaName, 4, 7, 3 );
}
inline
function interleaveXYZ_RGBA_UV( gl:       GL
                           , program:     Program 
                           , data:        Float32Array
                           , xyzName:     String
                           , rgbaName:    String
                           , uvName:      String
                           , ?isDynamic:  Bool = false ): Buffer {
    var vbo      = bufferSetup( gl, program, data, isDynamic );
    inputAttEnable( gl, program, xyzName, 3, 9, 0 );
    inputAttEnable( gl, program, rgbaName, 4, 9, 3 );
    inputAttEnable( gl, program, uvName, 2, 9, 7 );
    return vbo;
}
inline
function updateBufferXYZ_RGBA_UV(gl:       GL
                           , program:     Program
                           , xyzName:     String
                           , rgbaName:    String
                           , uvName:      String ){
    inputAttEnable( gl, program, xyzName, 3, 9, 0 );
    inputAttEnable( gl, program, rgbaName, 4, 9, 3 );
    inputAttEnable( gl, program, uvName, 2, 9, 7 );
}
inline
function updateBufferLocations( gl: GL, program: Program, inPosName: String, inColName: String ){
    inputAttribute( gl, program, inPosName );
    inputAttribute( gl, program, inColName );
}
// X Y   R G B
inline
function interleaveXY_RGB( gl:          GL
                         , program:     Program 
                         , data:        Float32Array
                         , xyName:      String
                         , rgbName:     String
                         , ?isDynamic:  Bool = false ): Buffer {
    var vbo      = bufferSetup( gl, program, data, isDynamic );
    inputAttEnable( gl, program, xyName, 2, 5, 0 );
    inputAttEnable( gl, program, rgbName, 3, 5, 2 );
    return vbo;
}
inline
function colorsXYZ_RGBA( gl:         GL
                       , program:    Program 
                       , positions:  Float32Array 
                       , colors:     Float32Array
                       , inPosName:  String
                       , inColName:  String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 3, 4 );
}
inline
function colorsXY_RGBA( gl:         GL
                      , program:    Program 
                      , positions:  Float32Array 
                      , colors:     Float32Array
                      , inPosName:  String
                      , inColName:  String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 2, 4 );
}
inline
function colorsXYZ_RGB( gl:         GL
                      , program:    Program 
                      , positions:  Float32Array 
                      , colors:     Float32Array
                      , inPosName:  String
                      , inColName:  String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 3, 3 );
}
inline
function colorsXY_RGB( gl:         GL
                     , program:    Program 
                     , positions:  Float32Array 
                     , colors:     Float32Array
                     , inPosName:  String
                     , inColName:  String ){
    return posColors( gl, program, positions, colors, inPosName, inColName, 2, 3 );
}
inline
function posColors( gl: GL
                  , program:    Program 
                  , positions:  Float32Array 
                  , colors:     Float32Array
                  , inPosName:  String
                  , inColName:  String
                  , noPos     = 3
                  , noCols    = 4 ){
    var bufferPos = bufferSetup( gl, program, positions );
    var bufferCol = bufferSetup( gl, program, colors );
    inputAttEnable( gl, program, inPosName, noPos, noPos, 0 );
    inputAttEnable( gl, program, inColName, noCols, noCols, 0 );
    var posLoc   = gl.getAttribLocation( program, inPosName );
    var colorLoc = gl.getAttribLocation( program, inColName );
    return { pos: bufferPos, col: bufferCol };
}

// just used for docs
class BufferGL{
    public var bufferSetup_: ( gl: GL
                             , program: Program
                             , data: Float32Array
                             , ?isDynamic: Bool )->Buffer = bufferSetup;
    public var interleaveXYZ_RGBA_: ( gl:       RenderingContext
                                    , program:   Program 
                                    , data:      Float32Array
                                    , inPosName: String
                                    , inColName: String
                                    , ?isDynamic: Bool )->Buffer = interleaveXYZ_RGBA;
    public var interleaveXYZ_RGBA_UV_: 
                   ( gl:         GL
                   , program:    Program 
                   , data:       Float32Array
                   , inPosName:  String
                   , inColName:  String
                   , inUVName:   String
                   , ?isDynamic: Bool ) -> Buffer = interleaveXYZ_RGBA_UV;
    public var interleaveXY_RGB_: ( gl:       GL
                                  , program:   Program 
                                  , data:      Float32Array
                                  , inPosName: String
                                  , inColName: String
                                  , ?isDynamic: Bool ) ->Buffer = interleaveXY_RGB;
    public var colorsXYZ_RGBA_: ( gl:        GL
                                , program:   Program 
                                , positions: Float32Array 
                                , colors:    Float32Array
                                , inPosName: String
                                , inColName: String ) -> Void = colorsXYZ_RGBA;
    public var colorsXY_RGBA_: ( gl:        GL
                               , program:   Program 
                               , positions: Float32Array 
                               , colors:    Float32Array
                               , inPosName: String
                               , inColName: String ) -> Void = colorsXY_RGBA;
    public var posColors_: ( gl: GL
                           , program:   Program 
                           , positions: Float32Array 
                           , colors:    Float32Array
                           , inPosName: String
                           , inColName: String
                           , ?noPos: Int
                           , ?noCols: Int ) -> Void = posColors;
}
#end
