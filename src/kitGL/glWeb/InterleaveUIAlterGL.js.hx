package kitGL.glWeb;

// webgl gl stuff
import kitGL.glWeb.Shaders;
import kitGL.glWeb.HelpGL;
import kitGL.glWeb.BufferGL;

// html stuff
import kitGL.glWeb.Texture;
import kitGL.glWeb.AnimateTimer;
import kitGL.glWeb.DivertTrace;

// js webgl 
import js.html.webgl.Buffer;
import js.html.webgl.RenderingContext;
import js.html.webgl.Program;

class InterleaveUVAlterGL{
    public var gl: RenderingContext;
    public var interleaveDataGL: InterleaveDataGL;
    public var program: Program;
    public var width:  Int;
    public var height: Int;
    public var buf: Buffer;
    public
    function new( width_: Int, height_: Int ){
        width = width_;
        height = height_;
        creategl();
        setup();
    }
    inline
    function creategl( ){
        var mainTexture = new Texture();
        mainTexture.create( width, height, true );
        gl = mainTexture.gl;
    }
    inline
    function setup(){
        program = programSetup( gl, vertexString1, fragmentString1 );
        draw();
        buf = interleaveXYZ_RGBA( gl
                                , program
                                , cast interleaveDataGL.data
                                , 'vertexPosition', 'vertexColor', vertexTexture, true );
        setAnimate();
    }
    // override this for drawing initial scene
    public
    function draw(){}
    inline
    function render(){
        clearAll( gl, width, height );
        renderDraw();
        gl.bindBuffer(RenderingContext.ARRAY_BUFFER, buf );
        gl.bufferSubData(RenderingContext.ARRAY_BUFFER, 0, cast interleaveDataGL.data );
        gl.useProgram( program );
        gl.drawArrays( RenderingContext.TRIANGLES, 0, interleaveDataGL.size );
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