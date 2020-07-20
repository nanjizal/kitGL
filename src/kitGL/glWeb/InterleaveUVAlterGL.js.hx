package kitGL.glWeb;

// webgl gl stuff
import kitGL.glWeb.Shaders;
import kitGL.glWeb.HelpGL;
import kitGL.glWeb.BufferGL;

// html stuff
import kitGL.glWeb.Texture;
import kitGL.glWeb.AnimateTimer;
import kitGL.glWeb.DivertTrace;
import js.html.Image;

// js webgl 
import js.html.webgl.Buffer;
import js.html.webgl.RenderingContext;
import js.html.webgl.Program;

class InterleaveUVAlterGL{
    public var gl: RenderingContext;
    public var interleaveDataGL: InterleaveDataGL;
    public var imageLoader: ImageLoader;
    public var program: Program;
    public var width:   Int;
    public var height:  Int;
    public var buf:     Buffer;
    public var mainTexture: Texture;
    public
    function new( width_: Int, height_: Int ){
        width = width_;
        height = height_;
        creategl();
        trace('InterleavUVAlterGL ');
        imageLoader = new ImageLoader( [], setup );
    }
    inline
    function creategl( ){
        mainTexture = new Texture();
        mainTexture.create( width, height, true );
        gl = mainTexture.gl;
    }
    inline
    function setup(){
        // don't use projection matrix for now
        trace( 'setup' );
        program = programSetup( gl, vertexString1, fragmentString2 );
        trace( 'create program' );
        draw();
        trace( 'call draw ' );
        buf = interleaveXYZ_RGBA_UV( gl
                        , program
                        , cast interleaveDataGL.data
                        , 'vertexPosition', 'vertexColor', 'vertexTexture', true );
                        trace(' buffer interleave');
        // reverse order so that it activates image 0 for now.
        var len = imageLoader.imageArr.length;
        var j = len - 1;
        for( i in 0...len ){
            uploadImage( gl, j, cast( imageLoader.imageArr[ j ], Image ) );
            j--;
        }

        setAnimate();
    }
    // override this for drawing initial scene
    public
    function draw(){
        trace('parent draw');
    }
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