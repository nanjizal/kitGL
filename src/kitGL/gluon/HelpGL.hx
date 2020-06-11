package kitGL.gluon;

import gluon.webgl.GLContext;

import gluon.webgl.GLProgram;
import typedarray.Float32Array;
import gluon.webgl.GLBuffer;
import gluon.webgl.GLShader;

inline
function clearAll( gl: GLContext, width: Int, height: Int ){
    gl.viewport( 0, 0, width, height );
    gl.clearColor( 0.0, 0.0, 0.0, 1.0 );
    gl.clear( ClearBufferMask.COLOR_BUFFER_BIT );
}
inline
function programSetup( gl:          GLContext
                     , strVertex:   String
                     , strFragment: String ): GLProgram {
    var program: GLProgram = gl.createProgram();
    gl.attachShader( program, shaderSetup( gl, ShaderType.VERTEX_SHADER, strVertex ) );
    gl.attachShader( program, shaderSetup( gl, ShaderType.FRAGMENT_SHADER, strFragment ) );
    gl.linkProgram( program );
    /*
    if( !gl.getProgramParameter(program, ProgramParameter.LINK_STATUS ) ) {
        throw("Error linking program. " + gl.getProgramInfoLog( program ) );
        return null;
    }
    gl.validateProgram( program );
    if( !gl.getProgramParameter( program, ProgramParameter.VALIDATE_STATUS ) ) {
        throw("Error validating program. " + gl.getProgramInfoLog( program ) );
        return null;
    } */
    gl.useProgram( program );
    return program;
}
inline
function shaderSetup( gl: GLContext
                    , shaderType: Int
                    , str: String ): GLShader {
    var shader = gl.createShader( shaderType );
    gl.shaderSource( shader, str );
    gl.compileShader( shader );
    if( !gl.getShaderParameter( shader, ShaderParameter.COMPILE_STATUS ) ){
        throw("Error compiling shader. " + gl.getShaderInfoLog( shader ) );
        return null;
    }
    return shader;
}