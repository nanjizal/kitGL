package kitGL.glWeb;
#if js
import js.html.DivElement;
import js.Browser;
class DivertTrace {
    var traceString:            String = '';
    var traceDiv:               DivElement;
    var textStyle0 = '<span style="font-size:12px; color:Silver">';
    var textStyle1 = '<span style="font-size:14px; color:Grey">';
    var left: Int;
    public function new( left_: Int = 610 ){
        var doc        = Browser.document;
        traceDiv       = doc.createDivElement();
        doc.body.appendChild( cast traceDiv );
        var dom        = cast traceDiv;
        var style      = dom.style;
        style.position = 'absolute';
        style.top      = px( 0 );
        style.left     = px( left_ );
        style.height   = px( 500 );
        style.width    = px( 500 );
        style.zIndex   = '99';
        style.overflow = 'auto';
        haxe.Log.trace = myTrace;
    }
    inline
    function px( v: Int ): String {
        return Std.string( v + 'px' );
    }
    function myTrace( v : Dynamic, ?inf : haxe.PosInfos ) {
        if( Std.string( v ) == '' ) return;
        traceString += textStyle0
            	    + inf.className
                    + '.' + inf.methodName 
                    + ' ( ' + Std.string( inf.lineNumber ) + ' )'
                    + '</span>'
                    + '<br> - '
                    + textStyle1
                    + Std.string( v ) 
                    + '</span>'
                    + '<br>';
        traceDiv.innerHTML = traceString;
    }
}
#end