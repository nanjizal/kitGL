package kitGL.glWeb;
#if js
import js.html.webgl.RenderingContext;
import js.html.webgl.ContextAttributes;
import js.html.webgl.Texture;
import js.html.webgl.Shader;
import js.html.webgl.UniformLocation;
import js.html.webgl.Program;
import js.html.Image;
import js.lib.Uint16Array;
import js.lib.Uint8Array;
import kitGL.glWeb.GL;
inline
function clearAll( gl: GL, width: Int, height: Int ){
    gl.clearColor( 0.5, 0.0, 0.5, 0.9 );
    gl.enable( RenderingContext.DEPTH_TEST );
    gl.clear( GL.COLOR_BUFFER_BIT );
    //gl.colorMask(true, true, true, false);
    gl.viewport( 0, 0, width, height );
    gl.enable( GL.BLEND);
    //gl.blendFunc( GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
    gl.blendFunc( GL.ONE, GL.ONE_MINUS_SRC_ALPHA );
    //gl.enable( GL.CULL_FACE );
    gl.enable( GL.DEPTH_TEST );
    //gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
    //gl.enable( GL.TEXTURE_2D );
}
inline
function programSetup( gl:          GL
                     , strVertex:   String
                     , strFragment: String ): Program {
     var program: Program = gl.createProgram();
     gl.attachShader( program, shaderSetup( gl, GL.VERTEX_SHADER, strVertex ) );
     gl.attachShader( program, shaderSetup( gl, GL.FRAGMENT_SHADER, strFragment ) );
     gl.linkProgram( program );
     if( !gl.getProgramParameter( program, GL.LINK_STATUS ) ) {
         throw("Error linking program. " + gl.getProgramInfoLog( program ) );
         return null;
     }
     gl.validateProgram( program );
     if( !gl.getProgramParameter( program, GL.VALIDATE_STATUS ) ) {
         throw("Error validating program. " + gl.getProgramInfoLog( program ) );
         return null;
     }
     gl.useProgram( program );
     return program;
}
inline
function shaderSetup( gl: GL
                     , shaderType: Int
                     , str: String ): Shader {
     var shader = gl.createShader( shaderType );
     gl.shaderSource( shader, str );
     gl.compileShader( shader );
     if( !gl.getShaderParameter( shader, GL.COMPILE_STATUS ) ){
         throw("Error compiling shader. " + gl.getShaderInfoLog( shader ) );
         return null;
     }
     return shader;
}
inline 
function passIndicesToShader( gl: GL, indices: Array<Int> ){
        var indexBuffer = gl.createBuffer(); // triangle indicies data 
        gl.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, indexBuffer );
        gl.bufferData( GL.ELEMENT_ARRAY_BUFFER
                     , new Uint16Array( indices )
                     , GL.STATIC_DRAW );
        gl.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, null );
}
// just used for docs
class HelpGL {
    public var clearAll_:( gl: GL, width: Int, height: Int ) -> Void =     clearAll;
    public var programSetup_:    ( gl:           GL
                                 , strVertex:    String
                                 , strFragment:  String ) -> Program = programSetup;
    public var shaderSetup_:     ( gl:           GL
                                 , shaderType:   Int
                                 , str:          String ) -> Shader  =  shaderSetup;
    public var passIndicesToShader_: ( gl:           GL
                            , indices:   Array<Int> ) -> Void = passIndicesToShader;
}
#end