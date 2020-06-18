package kitGL.glNme;
#if (!js)
import nme.gl.GL;
import nme.gl.GLProgram;
import nme.utils.Float32Array;
import nme.gl.GLBuffer;
import nme.gl.GLShader;


inline
function clearAll( width: Int, height: Int ){
    GL.viewport( 0, 0, width, height );
    GL.clearColor( 0.0, 0.0, 0.0, 1.0 );
    GL.clear( GL.COLOR_BUFFER_BIT );
}
inline
function programSetup( strVertex:   String, strFragment: String ): GLProgram {
    var program: GLProgram = GL.createProgram();
    GL.attachShader( program, shaderSetup( GL.VERTEX_SHADER, strVertex ) );
    GL.attachShader( program, shaderSetup( GL.FRAGMENT_SHADER, strFragment ) );
    GL.linkProgram( program );
    if( GL.getProgramParameter( program, GL.LINK_STATUS ) == 0 ) {
        throw("Error linking program. " + GL.getProgramInfoLog( program ) );
        return null;
    }
    GL.validateProgram( program );
    if( GL.getProgramParameter( program, GL.VALIDATE_STATUS ) == 0 ) {
        throw("Error validating program. " + GL.getProgramInfoLog( program ) );
        return null;
    }
    GL.useProgram( program );
    return program;
}
inline
function shaderSetup( shaderType: Int, str: String ): GLShader {
    var shader = GL.createShader( shaderType );
    GL.shaderSource( shader, str );
    GL.compileShader( shader );
    if( GL.getShaderParameter( shader, GL.COMPILE_STATUS ) == 0 ){
        throw("Error compiling shader. " + GL.getShaderInfoLog( shader ) );
        return null;
    }
    return shader;
}
#end