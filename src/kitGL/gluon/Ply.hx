package kitGL.gluon;

import gluon.webgl.GLBuffer;
import gluon.webgl.GLContext;
import gluon.webgl.GLProgram;
import gluon.webgl.GLShader;
import typedarray.Float32Array;
// gl stuff
import kitGL.gluon.BufferGL;
import kitGL.gluon.ColorPositions;
import kitGL.gluon.HelpGL;
import kitGL.gluon.Shaders;

class Ply{
    public var dataGL: DataGL;
    public var posLoc:           Int;
    public var colorLoc:         Int;
    final gl:                    GLContext;
    public var program:          GLProgram;
    public var buf:              GLBuffer;
    public
    function new( gl: GLContext ){
        this.gl = gl;
        
    }
    public inline 
    function setup(){
        trace('MinimalGL created');
        program = programSetup( gl, vertexString0, fragmentString0 );
        draw();
        buf = interleaveXYZ_RGBA( gl
                                , program
                                , cast dataGL.data
                                , 'vertexPosition', 'vertexColor', true );
        gl.disable(    CULL_FACE );
        posLoc   = gl.getAttribLocation( program, 'vertexPosition' );
        colorLoc = gl.getAttribLocation( program, 'vertexColor' );
    }
    // override this for drawing initial scene
    public
    function draw(){}
    inline public 
    function render( width: Int, height: Int ) {
        // execute commands on the OpenGL context
        var dim = ( width < height )? width: height;
        clearAll( gl, dim, dim );
        renderDraw();
        gl.bindBuffer( ARRAY_BUFFER, buf ); 
        /*interleaveXYZ_RGBA_reconnect( gl
                                    , program
                                    , 'vertexPosition', 'vertexColor' ); */
        gl.bufferSubData( ARRAY_BUFFER, 0, dataGL.data );
        gl.useProgram( program );
        gl.drawArrays( TRIANGLES, 0,  dataGL.size );
    }
    // override this for drawing every frame or changing the data.
    public
    function renderDraw(){}
}