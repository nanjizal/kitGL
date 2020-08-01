package kitGL.glWeb;

// webgl gl stuff
import kitGL.glWeb.Shaders;
import kitGL.glWeb.HelpGL;
import kitGL.glWeb.BufferGL;

// html stuff
import kitGL.glWeb.Sheet;
import kitGL.glWeb.AnimateTimer;
import kitGL.glWeb.DivertTrace;

// js webgl 
import js.html.webgl.Buffer;
import js.html.webgl.RenderingContext;
import js.html.webgl.Program;

class Ply{
    public var gl: RenderingContext;
    public var dataGL: DataGL;
    public var program: Program;
    public var width:  Int;
    public var height: Int;
    public var buf: Buffer;
    final vertexPosition = 'vertexPosition';
    final vertexColor    = 'vertexColor';
    public
    function new( width_: Int, height_: Int ){
        width = width_;
        height = height_;
        creategl();
        setup();
    }
    inline
    function creategl( ){
        var mainSheet = new Sheet();
        mainSheet.create( width, height, true );
        gl = mainSheet.gl;
    }
    inline
    function setup(){
        program = programSetup( gl, vertexString0, fragmentString0 );
        draw();
        buf = interleaveXYZ_RGBA( gl
                                , program
                                , cast dataGL.data
                                , vertexPosition, vertexColor, true );
        setAnimate();
    }
    // override this for drawing initial scene
    public
    function draw(){}
    inline
    function render(){
        clearAll( gl, width, height );
        renderDraw();
        gl.bindBuffer( RenderingContext.ARRAY_BUFFER, buf );
        gl.bufferSubData( RenderingContext.ARRAY_BUFFER, 0, cast dataGL.data );
        gl.useProgram( program );
        gl.drawArrays( RenderingContext.TRIANGLES, 0, dataGL.size );
    }
    // override this for drawing every frame or changing the data.
    public
    function renderDraw(){}
    inline
    function setAnimate(){
        AnimateTimer.create();
        AnimateTimer.onFrame = function( v: Int ) render();
    }
}