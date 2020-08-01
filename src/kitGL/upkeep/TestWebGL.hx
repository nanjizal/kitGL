package kitGL.upkeep;
#if js
import kitGL.glWeb.Sheet;
import kitGL.glWeb.DivertTrace;
import js.html.webgl.RenderingContext;
class TestWebGL{
    public static function main() new TestWebGL();
    public var mainSheet: Sheet;
    public var gl:          RenderingContext;
    public function new(){
        var divertTrace = new DivertTrace();
        mainSheet = getSheet();
        gl = getGL( mainSheet );
    }
    
    
    public inline
    function getSheet(){
        var texture = new Sheet();
        texture.create( 600, 600, true );
        return texture;
    }
    /**
     * <pre><code>
     * >>> ({ 
     * ... var test = new TestWebGL();
     * ... var texture: Sheet = test.getSheet();
     * ... var gl = test.getGL( texture );
     * ... Std.string(gl) == '[object WebGLRenderingContext]'; }) == true
     * </code></pre>
     */
    public inline
    function getGL( texture: Sheet ): RenderingContext {
        return mainSheet.gl;
    }
    
}
#end