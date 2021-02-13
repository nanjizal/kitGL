package kitGL.glWeb;
#if js 
import js.Browser;
import js.html.Element;
import js.html.CanvasElement;
import js.html.BodyElement;
import js.html.webgl.RenderingContext;
import js.html.CanvasRenderingContext2D;
import trilateral3.structure.XY;
//import js.html.webgl.WebGL2RenderingContext;
import js.html.webgl.ContextAttributes;
import js.html.CanvasElement;
import js.Browser;
import js.html.MouseEvent;
import js.html.Event;
import js.html.KeyboardEvent;
class Sheet {
    public var pixelRatio:     Float;
    public var width:          Int;
    public var height:         Int;
    public var penX:           Float;
    public var penY:           Float;
    public var domGL:            Element;
    public var domGL2D:           Element;
    public var onReady:        Void->Void;
    public var canvasGL:       CanvasElement;
    public var canvas2D:       CanvasElement;
    public var gl:             RenderingContext;
    public var cx:             CanvasRenderingContext2D;
    public var mouseUpXY:      ( XY ) -> Void;
    public var mouseDownXY:    ( XY ) -> Void;
    public var mouseMoveXY:    ( XY ) -> Void; 
    public inline function new(){}
    public
    function create( width_: Int = 600, height_: Int = 600, autoChild: Bool = false ){
        width               = width_;
        height              = height_;
        canvasGL            = Browser.document.createCanvasElement();
        canvasGL.width      = width;
        canvasGL.height     = height;
        var body = Browser.document.body;
        body.style.overflow = "hidden";
        body.style.position = 'fixed';
        pixelRatio = Browser.window.devicePixelRatio;
        if( pixelRatio == null ) pixelRatio = 1.;
        var bodyEL: Element = cast Browser.document.body;
        styleZero( bodyEL );
        domGL               = cast canvasGL;
        styleZero( domGL );
        if( autoChild ) body.appendChild( cast canvasGL );
        canvas2D            = Browser.document.createCanvasElement();
        canvas2D.width      = width;
        canvas2D.height     = height;
        domGL2D             = cast canvasGL;
        styleZero( domGL );
        if( autoChild ) body.appendChild( cast canvas2D );
        //gl                  = canvasGL.getContextWebGL();
        //gl                  = canvas.getContext("webgl", { alpha: false }};
        gl                  = canvasGL.getContext("webgl", { premultipliedAlpha: false } );
        cx                  = canvas2D.getContext('2d');
    }
    public inline
    function mouseXY( e: Event ): XY {
        var p: MouseEvent = cast e;
        e.stopPropagation();
        e.preventDefault();
        return { x: ( p.pageX - canvasGL.offsetLeft ) * pixelRatio
               , y: ( p.pageY - canvasGL.offsetTop  ) * pixelRatio };
    }
    public inline
    function mouseDownSetup(){
        var body = Browser.document.body;
        body.onmousedown = mouseDown;
        body.onmouseup = mouseUp;
    }
    public inline
    function mouseDragStop(){
        var body = Browser.document.body;
        body.onmousemove = null;
        body.onmousedown = mouseDown;
    }
    public inline
    function mouseDownDisable(){
        Browser.document.body.onmousedown = null;
    }
    public inline
    function mouseMoveSetup(){
        var body = Browser.document.body;
        body.onmousemove = mouseMove;
    }
    inline
    function mouseDown( e: Event ){
        if( mouseDownXY != null ) mouseDownXY( mouseXY( e ) );
    }
    inline 
    function mouseMove( e: Event ){
        if( mouseMoveXY != null ) mouseMoveXY( mouseXY( e ) );
    }
    inline
    function mouseUp( e: Event ){
        if( mouseUpXY != null ) mouseUpXY( mouseXY( e ) );
    }
    public inline
    function keyboardInt( e: KeyboardEvent ): Int {
        e.preventDefault();
        return e.keyCode;
    }
    public inline
    function styleZero( domGL: Element ){
        var style         = domGL.style;
        style.paddingLeft = px( 0 );
        style.paddingTop  = px( 0 );
        style.left        = px( 0 );
        style.top         = px( 0 );
        style.marginLeft  = px( 0 );
        style.marginTop   = px( 0 );
        style.position    = "absolute";
    }
    public inline
    function styleLeft( left: Int ){
        var style      = domGL.style;
        style.left     = px( left );
        style.height   = px( 500 );
        style.width    = px( 500 );
        style.zIndex   = '99';
        style.overflow = 'auto';
    }
    public inline
    function draw( sheet: Sheet, dx: Int = 0, dy: Int = 0 ){
        cx.drawImage( sheet.canvasGL, dx, dy, sheet.width, sheet.height );
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
#end