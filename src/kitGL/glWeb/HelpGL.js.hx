package kitGL.glWeb;
#if js
import js.html.webgl.RenderingContext;
import js.html.webgl.ContextAttributes;
import js.html.webgl.Texture;
import js.html.webgl.Shader;
import js.html.webgl.Program;
import js.html.webgl.UniformLocation;
import js.html.Image;

inline
function clearAll( gl: RenderingContext, width: Int, height: Int ){
    gl.viewport( 0, 0, width, height );
    gl.clearColor( 0.0, 0.0, 0.0, 1.0 );
    gl.clear( RenderingContext.COLOR_BUFFER_BIT );
}
inline
function programSetup( gl:          RenderingContext
                     , strVertex:   String
                     , strFragment: String ): Program {
     var program: Program = gl.createProgram();
     gl.attachShader( program, shaderSetup( gl, RenderingContext.VERTEX_SHADER, strVertex ) );
     gl.attachShader( program, shaderSetup( gl, RenderingContext.FRAGMENT_SHADER, strFragment ) );
     gl.linkProgram( program );
     if( !gl.getProgramParameter(program, RenderingContext.LINK_STATUS ) ) {
         throw("Error linking program. " + gl.getProgramInfoLog( program ) );
         return null;
     }
     gl.validateProgram( program );
     if( !gl.getProgramParameter( program, RenderingContext.VALIDATE_STATUS ) ) {
         throw("Error validating program. " + gl.getProgramInfoLog( program ) );
         return null;
     }
     gl.useProgram( program );
     return program;
}
inline
function shaderSetup( gl: RenderingContext
                     , shaderType: Int
                     , str: String ): Shader {
     var shader = gl.createShader( shaderType );
     gl.shaderSource( shader, str );
     gl.compileShader( shader );
     if( !gl.getShaderParameter( shader, RenderingContext.COMPILE_STATUS ) ){
         throw("Error compiling shader. " + gl.getShaderInfoLog( shader ) );
         return null;
     }
     return shader;
}
inline
function uploadImage( gl: RenderingContext, imageIndex: Int, image: Image ){
    var _2D     = RenderingContext.TEXTURE_2D;
    var rgba    = RenderingContext.RGBA;
    var texture = gl.createTexture();
    activateTexture( gl, imageIndex );
    gl.bindTexture( _2D, texture );
    textureStandard( gl ); // hard coded for now
    gl.texImage2D( _2D, 0, rgba, rgba, RenderingContext.UNSIGNED_BYTE, image );
    return texture;
}
inline
function activateTexture( gl: RenderingContext, imageIndex: Int ){
    switch( imageIndex ){
        case 0:
            gl.activeTexture( RenderingContext.TEXTURE0 );
        case 1:
            gl.activeTexture( RenderingContext.TEXTURE1 );
        case 2:
            gl.activeTexture( RenderingContext.TEXTURE2 );
        case 3:
            gl.activeTexture( RenderingContext.TEXTURE3 );
        case 4:
            gl.activeTexture( RenderingContext.TEXTURE4 );
        case 5: 
            gl.activeTexture( RenderingContext.TEXTURE5 );
        case 6:
            gl.activeTexture( RenderingContext.TEXTURE6 );
        default:
            gl.activeTexture( RenderingContext.TEXTURE7 );
    }
}
inline
function textureStandard( gl: RenderingContext ){
    var _2D     = RenderingContext.TEXTURE_2D;
    var clamp   = RenderingContext.CLAMP_TO_EDGE;
    var nearest = RenderingContext.NEAREST;
    gl.pixelStorei( RenderingContext.UNPACK_FLIP_Y_WEBGL, 1 );
    gl.texParameteri( _2D, RenderingContext.TEXTURE_WRAP_S, clamp );
    gl.texParameteri( _2D, RenderingContext.TEXTURE_WRAP_T, clamp );
    gl.texParameteri( _2D, RenderingContext.TEXTURE_MIN_FILTER, nearest );
    gl.texParameteri( _2D, RenderingContext.TEXTURE_MAG_FILTER, nearest );
}
// just used for docs
class HelpGL {
    public var clearAll_:( gl: RenderingContext, width: Int, height: Int ) -> Void = clearAll;
    public var programSetup_:(  gl:          RenderingContext
                              , strVertex:   String
                              , strFragment: String ) -> Program = programSetup;
    public var shaderSetup_: ( gl:           RenderingContext
                             , shaderType:   Int
                             , str:          String ) -> Shader  = shaderSetup;
    public var uploadImage_: ( gl:           RenderingContext
                             , imageIndex:   Int
                             , image:        Image ) -> Texture   = uploadImage;
    public var activateTexture_: ( gl: RenderingContext, imageIndex: Int ) -> Void = activateTexture;
    public var textureStandard_: ( gl: RenderingContext ) -> Void = textureStandard;
}
#end