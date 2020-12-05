package kitGL.glWeb;

// webgl gl stuff
import kitGL.glWeb.TextureShader;
import kitGL.glWeb.HelpGL;
import kitGL.glWeb.BufferGL;
import kitGL.glWeb.ImageGL;

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
import kitGL.glWeb.GL;

class PlyUV{
    public var gl:          RenderingContext;
    public var dataGL:      DataGL;
    public var imageLoader: ImageLoader;
    public var program:     Program;
    public var width:       Int;
    public var height:      Int;
    public var buf:         Buffer;
    public var mainSheet:   Sheet;
    var indices           = new Array<Int>();
    public var textureArr = new Array<Texture>();
    final vertexPosition  = 'vertexPosition';
    final vertexColor     = 'vertexColor';
    final vertexTexture   = 'vertexTexture';
    final uniformImage    = 'uImage0';
    final uniformColor    = 'bgColor';
    final uvTransform     = 'uvTransform';
    
    public
    function new( width_: Int, height_: Int ){
        width  = width_;
        height = height_;
        creategl();
        imageLoader = new ImageLoader( [], setup );
    }
    inline
    function creategl( ){
        mainSheet = new Sheet();
        mainSheet.create( width, height, true );
        gl = mainSheet.gl;
    }
    var tex: Texture;
    public var img: Image; 
    inline
    function setup(){
        // don't use projection matrix for now
        program = programSetup( gl, textureVertexString1, textureFragmentString );
        transformUV( gl, program, uvTransform, [ 1.,0.,0.
                                               , 0.,1.,0.
                                               , 0.,0.,1.] );
        draw();
        tex = uploadImage( gl, 0, img );
        imageUniform( gl, program, uniformImage );
        colorUniform( gl, program, uniformColor, 0xFF00FF00 );
        
        buf = interleaveXYZ_RGBA_UV( gl
                        , program
                        , cast dataGL.data
                        , vertexPosition, vertexColor, vertexTexture, true );
        trace(' buffer interleave');
        // reverse order so that it activates image 0 for now.
        var count = 0;
        for( i in 0...dataGL.size ) for( k in 0...3 ) indices.push( count++ );
        passIndicesToShader( gl, indices );
        
        setAnimate();
    }
    
    public function setBackgroundShapeColor( red: Float, green: Float, blue: Float, alpha: Float ){
        rgbaUniform( gl, program, uniformColor, red, green, blue, alpha );
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
        // NOT NEEDED but need to explore code for changing images at runtime most structures done.
        //gl.enable( GL.CULL_FACE );
        //gl.enable( GL.DEPTH_TEST );
        //gl.bindTexture( GL.TEXTURE_2D, tex );
        //gl.texImage2D( GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, img );
        //activateTexture( gl, tex, 1 );
        /*
        // STUFF to use if your testing rendering and not calling 'drawShape'.
        colorUniform( gl, program, uniformColor, 0xFF00FF00 );
        gl.bindBuffer( GL.ARRAY_BUFFER, buf );
        gl.bufferSubData( GL.ARRAY_BUFFER, 0, cast dataGL.data );
        gl.useProgram( program );
        gl.drawArrays( GL.TRIANGLES, 0, Std.int( dataGL.size ) );
        */
    }
    public function drawShape( start: Int, end: Int, bgColor: Int ) {
        colorUniform( gl, program, uniformColor, bgColor );
        
        var partData = dataGL.data.subarray( start*27, end*27 );
        /*
        buf = interleaveXYZ_RGBA_UV( gl
                        , program
                        , partData
                        , vertexPosition, vertexColor, vertexTexture, true );
        */
        gl.bindBuffer( GL.ARRAY_BUFFER, null );
        gl.bindBuffer( GL.ARRAY_BUFFER, buf );
        gl.bufferSubData( GL.ARRAY_BUFFER, 0, cast partData );//cast dataGL.data );
        gl.useProgram( program );
        gl.drawArrays( GL.TRIANGLES, 0, Std.int( (end-start) * 3 ) );
    }
    
    
    public inline
    function withAlpha(){
        setAsRGBA( gl, img );
    }
    
    public inline
    function notAlpha(){
        setAsRGB( gl, img );
    }
    
    // override this for drawing every frame or changing the data.
    public
    function renderDraw(){}
    inline
    function setAnimate(){
        AnimateTimer.create();
        AnimateTimer.onFrame = function( v: Int ) render();
        //render();
    }
}