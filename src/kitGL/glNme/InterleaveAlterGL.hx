package kitGL.glNme;
import nme.app.NmeApplication;
import nme.app.Window;
import nme.gl.GL;
import nme.gl.GLProgram;
import nme.gl.GLBuffer;
//import nme.gl.Utils;
import kitGL.nme.BufferGL;
import kitGL.nme.ColorPositions;
import kitGL.nme.HelpGL;
import kitGL.nme.Shaders;


class InterleaveAlterGL extends NmeApplication {
   var valid:Bool;
   var program: GLProgram;
   public var buf:    GLBuffer;
   public var interleaveDataGL: InterleaveDataGL;
   public
   function new( window: Window ){
      super( window );
      valid = false;
   }
   override public
   function onRender(_): Void {
      if( !valid ){
          // TODO: check what happens when loose context to see if correct.
         program = programSetup( vertexString0, fragmentString0 );
         draw();
         buf = interleaveXYZ_RGBA( program
                                 , cast interleaveDataGL.data
                                 , 'vertexPosition', 'vertexColor' );
      }
      clearAll( width, height );
      renderDraw();
      GL.bindBuffer( GL.ARRAY_BUFFER, buf );
      GL.bufferSubData( GL.ARRAY_BUFFER, 0, cast interleaveDataGL.data );
      GL.useProgram( program );
      // need to consider bind / unbind VertexAttrib see nme.gl.Buffer
      // especially if you mix it with normal nme?
      GL.drawArrays( GL.TRIANGLES, 0, interleaveDataGL.size );
   }
   // override this for drawing the first frame
   public
   function draw(){
   }
   // override this for drawing every frame or changing the data.
   public
   function renderDraw(){
   }
   override public 
   function onContextLost(): Void valid = false;
}