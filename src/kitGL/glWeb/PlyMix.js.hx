package kitGL.glWeb;

// webgl gl stuff
import kitGL.glWeb.TextureShader;
import kitGL.glWeb.Shaders;
import kitGL.glWeb.HelpGL;
import kitGL.glWeb.BufferGL;
import kitGL.glWeb.ImageGL;
import kitGL.util.ARGB;

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
enum abstract ProgramMode(Int) {
  var ModeNone;
  var ModeColor;
  var ModeTexture;
}
class PlyMix{
    public var gl:               RenderingContext;
    
        // general inputs
    final vertexPosition         = 'vertexPosition';
    final vertexColor            = 'vertexColor';
    
    // general
    public var width:            Int;
    public var height:           Int;
    public var mainSheet:        Sheet;
    
    // Texture
    public var programTexture:   Program;
    public var dataGLtexture:    DataGL;
    public var imageLoader:      ImageLoader;
    public var bufTexture:       Buffer;
    var indicesTexture           = new Array<Int>();
    public var img:              Image;
    public var tex:              Texture;
    public var textureArr        = new Array<Texture>();
    public var transformUVArr    = [ 1.,0.,0.
                                   , 0.,1.,0.
                                   , 0.,0.,1.];
    // texture inputs
    final vertexTexture          = 'vertexTexture';
    // Texture uniforms
    final uniformImage           = 'uImage0';
    final uniformColor           = 'bgColor';
    final uvTransform            = 'uvTransform';
    
    // Color
    public var programColor:     Program;
    public var dataGLcolor:      DataGL;
    public var bufColor:         Buffer;
    
    public var mode: ProgramMode = ModeNone;
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
    public function setProgramMode( modeNew: ProgramMode ): Bool {
        // returns if it changes
        if( mode == modeNew ){
            // do nothing
            return false;
        } else {
            gl.bindBuffer( GL.ARRAY_BUFFER, null );
            switch( modeNew ) {
                case ModeColor: 
                    gl.useProgram( programColor );
                    gl.bindBuffer( GL.ARRAY_BUFFER, bufColor );
                    updateBufferXYZ_RGBA( gl, programColor, vertexPosition, vertexColor );
                    mode = ModeColor;
                case ModeTexture:
                    gl.useProgram( programTexture );
                    gl.bindBuffer( GL.ARRAY_BUFFER, bufTexture );
                    updateBufferXYZ_RGBA_UV( gl, programTexture, vertexPosition, vertexColor, vertexTexture );
                    mode = ModeTexture;
                default:
                    mode = ModeNone;
            }
            return true;
        }
    }
    inline
    function setup(){
        trace(' setup ');
        // don't use projection matrix for now
        setupProgramTexture();
        setupProgramColor();
        draw();
        setupInputTexture();
        setupInputColor();
        setAnimate();
    }
    inline
    function setupProgramColor(){
        programColor = programSetup( gl, vertexString0, fragmentString0 );
    }
    inline
    function setupProgramTexture(){
        programTexture = programSetup( gl, textureVertexString1, textureFragmentString );
    }
    inline
    function setupInputColor(){
         bufColor = interleaveXYZ_RGBA( gl
                        , programColor
                        , cast dataGLcolor.data
                        , vertexPosition, vertexColor, true );
    }
    inline
    function setupInputTexture(){
        tex = uploadImage( gl, 0, img );
        bufTexture = interleaveXYZ_RGBA_UV( gl
                        , programTexture
                        , cast dataGLtexture.data
                        , vertexPosition, vertexColor, vertexTexture, true );
        var count = 0;
        for( i in 0...dataGLtexture.size ) for( k in 0...3 ) indicesTexture.push( count++ );
        passIndicesToShader( gl, indicesTexture );
    }
    public function changeImage( img_: Image ){
        updateAsARGB( gl, tex, img_ );
    }
    public function setBackgroundShapeColor( red: Float, green: Float, blue: Float, alpha: Float ){
        rgbaUniform( gl, programTexture, uniformColor, red, green, blue, alpha );
    }
    // override this for drawing initial scene
    public
    function draw(){
        trace('parent draw');
    }
    inline
    function render(){
        clearAll( gl, width, height );
        gl.bindBuffer( RenderingContext.ARRAY_BUFFER, bufColor );
        renderDraw();
    }
    public
    function drawTextureShape( start: Int, end: Int, bgColor: Int ) {
        var modeChange = setProgramMode( ModeTexture );
        colorUniform( gl, programTexture, uniformColor, bgColor );
        if( modeChange ) {
            imageUniform( gl, programTexture, uniformImage );
            transformUV( gl, programTexture, uvTransform, transformUVArr );
        }
        drawData( programTexture, dataGLtexture, start, end, 27 );
    }
    public
    function drawColorShape( start: Int, end: Int ) {
        setProgramMode( ModeColor );
        drawData( programColor, dataGLcolor, start, end, 21 );
    }
    public
    function drawData( program: Program, dataGL: DataGL, start: Int, end: Int, len: Int ){
        var partData = dataGL.data.subarray( start*len, end*len );
        gl.bufferSubData( GL.ARRAY_BUFFER, 0, cast partData );
        gl.useProgram( program );
        gl.drawArrays( GL.TRIANGLES, 0, Std.int( ( end - start ) * 3 ) );
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
    }
}