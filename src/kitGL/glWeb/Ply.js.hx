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
    
    // general inputs
    final vertexPosition         = 'vertexPosition';
    final vertexColor            = 'vertexColor';
    
    // general
    public var width:            Int;
    public var height:           Int;
    public var mainSheet:        Sheet;
    
    // Color
    public var programColor:     Program;
    public var dataGLcolor:      DataGL;
    public var bufColor:         Buffer;
    // maybe not needed
    var indicesColor             = new Array<Int>();
    
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
        setupProgramColor();
        draw();
        setupInputColor();
        setAnimate();
    }
    inline
    function setupProgramColor(){
        programColor = programSetup( gl, vertexString0, fragmentString0 );
    }
    inline
    function setupInputColor(){
        bufColor = interleaveXYZ_RGBA( gl
                                , programColor
                                , cast dataGLcolor.data
                                , vertexPosition, vertexColor, true );
    }
    // override this for drawing initial scene
    public
    function draw(){}
    inline
    function render(){
        clearAll( gl, width, height );
        gl.bindBuffer( RenderingContext.ARRAY_BUFFER, bufColor );
        renderDraw();
    }
    public function drawShape( start: Int, end: Int ) {
        // set uniforms
        drawData( programColor, dataGLcolor, start, end, 21 );
    }
    public inline
    function drawData( program: Program, dataGL: DataGL, start: Int, end: Int, len: Int ){
        var partData = dataGL.data.subarray( start*len, end*len );
        gl.bufferSubData( GL.ARRAY_BUFFER, 0, cast partData );
        gl.useProgram( program );
        gl.drawArrays( GL.TRIANGLES, 0, Std.int( ( end - start ) * 3 ) );
    }
    public function drawAll(){
        gl.bufferSubData( RenderingContext.ARRAY_BUFFER, 0, cast dataGLcolor.data );
        gl.useProgram( programColor );
        gl.drawArrays( RenderingContext.TRIANGLES, 0, dataGLcolor.size );
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