package kitGL.glWeb;
import js.html.webgl.RenderingContext;
import js.html.webgl.ContextAttributes;
import js.html.webgl.Shader;
import js.html.webgl.Program;
import js.html.webgl.UniformLocation;

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

// just used for docs
class HelpGL {
    public var clearAll_:( gl: RenderingContext, width: Int, height: Int ) -> Void = clearAll;
    public var programSetup_:(  gl:          RenderingContext
                              , strVertex:   String
                              , strFragment: String ) -> Program = programSetup;
    public var shaderSetup_: ( gl:           RenderingContext
                             , shaderType:   Int
                             , str:          String ) -> Shader = shaderSetup;
}