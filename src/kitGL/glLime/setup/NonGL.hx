package kitGL.glLime.setup;
import lime.graphics.RenderContext;

class NonGL{
    var width: Int;
    var height: Int;
    public function new( width_: Int, height_: Int ){
        width = width_;
        height = height_;
    }
    public inline
    function update(){
        // NOT YET IMPLEMENTED
    }
    public inline
    function setup( context: RenderContext ){
        switch( context.type ){
            case CAIRO, CANVAS, DOM, FLASH:
            // NOT YET IMPLEMENTED
            default:
        }
    }
    public inline
    function render( context: RenderContext ){
        switch( context.type ){
            case CAIRO, CANVAS, DOM, FLASH:
            // NOT YET IMPLEMENTED
            default:
        }
    }
}