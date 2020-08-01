package kitGL.glWeb;

// webgl gl stuff
import kitGL.glWeb.Shaders;
import kitGL.glWeb.HelpGL;
import kitGL.glWeb.BufferGL;

// html stuff
import kitGL.glWeb.Sheet;
import kitGL.glWeb.AnimateTimer;
import kitGL.glWeb.DivertTrace;
import js.html.Image;

// js webgl 
import js.html.webgl.Buffer;
import js.html.webgl.RenderingContext;
import js.html.webgl.Program;
import js.html.webgl.Texture;

class PlyUV{
    public var gl: RenderingContext;
    public var dataGL: DataGL;
    public var imageLoader: ImageLoader;
    public var program: Program;
    public var width:   Int;
    public var height:  Int;
    public var buf:     Buffer;
    public var mainSheet: Sheet;
    public var textureArr = new Array<Texture>();
    final vertexPosition = 'vertexPosition';
    final vertexColor    = 'vertexColor';
    final vertexTexture  = 'vertexTexture';
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
        mainSheet = new Sheet();
        mainSheet.create( width, height, true );
        gl = mainSheet.gl;
    }
    inline
    function setup(){
        // don't use projection matrix for now
        trace( 'setup' );
        program = programSetup( gl, vertexString1, fragmentString2 );
        trace( 'create program' );
        imageUniform( gl, program, 'uImage0' );
        
        draw();
        trace( 'call draw ' );
        
        var len = imageLoader.imageArr.length;
        var j = len - 1;
        for( i in 0...len ){
            textureArr[ j ] = uploadImage( gl, j, cast( imageLoader.imageArr[ j ], Image ) );
            j--;
        }
        buf = interleaveXYZ_RGBA_UV( gl
                        , program
                        , cast dataGL.data
                        , vertexPosition, vertexColor, vertexTexture, true );
        trace(' buffer interleave');
        // reverse order so that it activates image 0 for now.
        

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
        
        buf = interleaveXYZ_RGBA_UV( gl
                        , program
                        , cast dataGL.data
                        , vertexPosition, vertexColor, vertexTexture, true );
        var len = imageLoader.imageArr.length;
        var j = len - 1;
        for( i in 0...len ){
            textureArr[ j ] = uploadImage( gl, j, cast( imageLoader.imageArr[ j ], Image ) );
            j--;
        }
        /*
        var len = imageLoader.imageArr.length;
        var j = len - 1;
        for( i in 0...len ){
            updateTexture( gl, textureArr[ j ], cast( imageLoader.imageArr[ j ] ) );
            j--;
        }
        */
        gl.bindBuffer( RenderingContext.ARRAY_BUFFER, buf );
        gl.bufferSubData(RenderingContext.ARRAY_BUFFER, 0, cast dataGL.data );
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