package kitGL.upkeep;
#if js
import kitGL.glWeb.Texture;
import kitGL.glWeb.DivertTrace;
import js.html.webgl.RenderingContext;
class TestWebGL{
    public static function main() new TestWebGL();
    public var mainTexture: Texture;
    public var gl:          RenderingContext;
    public function new(){
        var divertTrace = new DivertTrace();
        mainTexture = getTexture();
        gl = getGL( mainTexture );
    }
    
    
    public inline
    function getTexture(){
        var texture = new Texture();
        texture.create( 600, 600, true );
        return texture;
    }
    /**
     * <pre><code>
     * >>> ({ 
     * ... var test = new TestWebGL();
     * ... var texture: Texture = test.getTexture();
     * ... var gl = test.getGL( texture );
     * ... Std.string(gl) == '[object WebGLRenderingContext]'; }) == true
     * </code></pre>
     */
    public inline
    function getGL( texture: Texture ): RenderingContext {
        return mainTexture.gl;
    }
    
}
#end