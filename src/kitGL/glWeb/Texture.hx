package kitGL.glWeb;
import js.Browser;
import js.html.Element;
import js.html.CanvasElement;
import js.html.BodyElement;
import js.html.webgl.RenderingContext;
import js.html.CanvasRenderingContext2D;
//import js.html.webgl.WebGL2RenderingContext;
import js.html.webgl.ContextAttributes;
import js.html.CanvasElement;
import js.Browser;
// TODO: change name
class Texture {
    public var width:          Int;
    public var height:         Int;
    public var penX:           Float;
    public var penY:           Float;
    public var dom:            Element;
    public var onReady:        Void->Void;
    public var canvasElement:  CanvasElement;
    public var gl:             RenderingContext;
    public var cx:             CanvasRenderingContext2D;
    public inline function new(){}
    public
    function create( width_: Int = 600, height_: Int = 600, autoChild: Bool = false ){
        width             = width_;
        height            = height_;
        canvasElement            = Browser.document.createCanvasElement();
        canvasElement.width      = width;
        canvasElement.height     = height;
        dom               = cast canvasElement;
        styleZero();
        if( autoChild ) Browser.document.body.appendChild( cast canvasElement );
        gl = canvasElement.getContextWebGL();
        cx = canvasElement.getContext('2d');
    }
    public inline
    function styleZero(){
        var style         = dom.style;
        style.paddingLeft = px( 0 );
        style.paddingTop  = px( 0 );
        style.left        = px( 0 );
        style.top         = px( 0 );
        style.position    = "absolute";
    }
    public inline
    function styleLeft( left: Int ){
        var style      = dom.style;
        style.left     = px( left );
        style.height   = px( 500 );
        style.width    = px( 500 );
        style.zIndex   = '99';
        style.overflow = 'auto';
    }
    public inline
    function draw( texture: Texture, dx: Int = 0, dy: Int = 0 ){
        cx.drawImage( texture.canvasElement, dx, dy, texture.width, texture.height );
    }
    public inline
    function clear(){
        cx.clearRect( 0, 0, width, height );
    }
    inline
    function px( v: Int ): String {
        return Std.string( v + 'px' );
    }
    inline 
    function extractPx( s: String ): Int {
        var len = s.length - 2;
        return Std.parseInt( s.substr( 0, len ) );
    }
    inline
    function rgbaString( col: Int, ?alpha: Float ){
        return if( alpha != null && alpha != 1.0 ){
            var r = (col >> 16) & 0xFF;
            var g = (col >> 8) & 0xFF;
            var b = (col) & 0xFF;
            'rgba($r,$g,$b,$alpha)';
        } else {
            '#' + StringTools.hex( col, 6 );
        }
    }
    public inline
    function rgbaFloat( col: Int, alpha: Float = 1. ):{ r: Float, g: Float, b: Float, alpha: Float }{
        var r = (col >> 16) & 0xFF;
        var g = (col >> 8) & 0xFF;
        var b = (col) & 0xFF;
        return { r: r, g: g, b: b, alpha: alpha }
    }
    public var x( get, set ): Int;
    inline
    function set_x( x_: Int ):Int {
        ( cast this ).style.left = px( x_ );
        return( x_ );
    }
    inline
    function get_x(): Int {
        var style = ( cast this ).style;
        return extractPx( style.left );
    }
    public var y( get, set ): Int;
    inline
    function set_y( y_: Int ):Int {
        ( cast this ).style.left = px( y_ );
        return( y_ );
    }
    inline
    function get_y(): Int {
        var style = ( cast this ).style;
        return extractPx( style.top );
    }
    public inline
    function lineStyle( wid: Float, col: Int, ?alpha: Float ){
        cx.lineWidth = wid;
        cx.strokeStyle = rgbaString( col, alpha );
    }
    public inline
    function beginFill( col: Int, ?alpha:Float ){
        cx.fillStyle = rgbaString( col, alpha );
        cx.beginPath();
    }
    public inline
    function endFill(){
        cx.stroke();
        cx.closePath();
        cx.fill();
    }
    public inline
    function moveTo( x: Float, y: Float ): Void {
        penX = x;
        penY = y;
        cx.moveTo( penX, penY );
    }
    public inline
    function lineTo( x: Float, y: Float ): Void {
        penX = x;
        penY = y;
        cx.lineTo( penX, penY );
    }
    inline
    function midBezier( s: Float, c: Float, e: Float ): Float {
        return 2*c - 0.5*( s + e );
    }
    public inline
    function quadThru( x1: Float, y1: Float
                     , x2: Float, y2: Float ){
        x1 = midBezier( penX, x1, x2 );
        y1 = midBezier( penY, y1, y2 );
        quadTo( x1, y1, x2, y2 );
    }
    public inline
    function quadTo( x1: Float, y1: Float
                          , x2: Float, y2: Float ): Void {
        cx.quadraticCurveTo( x1, y1, x2, y2 );
        penX = x2;
        penY = x2;
    }
    public inline
    function curveTo( x1: Float, y1: Float
                                   , x2: Float, y2: Float
                           , x3: Float, y3: Float ): Void {
        cx.bezierCurveTo( x1, y1, x2, y2, x3, y3 );
        penX = x2;
        penY = x2;
    }
}