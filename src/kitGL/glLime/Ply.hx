package kitGL.glLime;

import lime.graphics.RenderContext;
import lime.graphics.WebGLRenderContext;
//import lime.Assets;
//import lime.utils.AssetType;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import lime.math.Matrix4;
import lime.graphics.opengl.GLProgram;

import kitGL.glLime.Shaders;
import kitGL.glLime.HelpGL;
import kitGL.glLime.BufferGL;
import kitGL.glLime.setup.IAppGL;
import lime.graphics.opengl.GLBuffer;

class Ply implements IAppGL{
    var program: GLProgram;
    public var dataGL: DataGL;
    public var width:  Int;
    public var height: Int;
    public var buf:    GLBuffer;
    public
    function new( width_: Int, height_: Int ){
        width = width_;
        height = height_;
    }
    // override this
    public
    function update(){}
    public inline
    function setup( gl: WebGLRenderContext ){
        program = programSetup( gl, vertexString0, fragmentString0 );
        draw();
        buf = interleaveXYZ_RGBA( gl
                                , program
                                , cast dataGL.data
                                , 'vertexPosition', 'vertexColor' );
    }
    // override this for drawing the first frame
    public
    function draw(){
    }
    public inline
    function render( gl: WebGLRenderContext ){
        clearAll( gl, width, height );
        renderDraw();
        gl.bindBuffer(gl.ARRAY_BUFFER, buf );
        gl.bufferSubData(gl.ARRAY_BUFFER, 0, cast dataGL.data );
        gl.useProgram( program );
        gl.drawArrays( gl.TRIANGLES, 0, dataGL.size );
    }
    // override this for drawing every frame or changing the data.
    public
    function renderDraw(){}
}