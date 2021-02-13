package kitGL.glWeb;
import js.html.Event;
import js.html.KeyboardEvent;
import js.Browser;
// from htmlHelper.tools
// Needs more thought in regard to depreciated but works fine for my needs.
class CharacterInput {
    public var commandSignal:      Void   -> Void;
    public var navSignal:          Void   -> Void;
    public var letterSignal:       String -> Void;
    public var leftDown:           Bool = false;
    public var rightDown:          Bool = false;    
    public var downDown:           Bool = false;
    public var upDown:             Bool = false;
    public var shiftDown:          Bool = false;
    public var enterDown:          Bool = false;
    public var deleteDown:         Bool = false;
    public var tabDown:            Bool = false;
    public var altDown:            Bool = false;
    public var cmdDown:            Bool = false;
    public var spaceDown:          Bool = false;
    public var controlDown:        Bool = false;
    public function new(){
        Browser.document.onkeydown  = keyDown;
        Browser.document.onkeyup    = keyUp;
        // create default key down traces
        navSignal     = function(): Void { trace( navDown() ); }
        commandSignal = function(): Void { trace( commandDown() ); }
        letterSignal  = function( s: String ):Void { trace( 'letter pressed ' + s ); }
    }
    public
    function navDown(): String {
        var str = '';
        if( leftDown )    str += 'left,';
        if( rightDown )   str += 'right,';
        if( downDown )    str += 'down,';
        if( upDown )      str += 'up,';
        return str;
    }
    public
    function commandDown(): String {
        var str = '';
        if( shiftDown )   str += 'shift,';
        if( enterDown )   str += 'enter,';
        if( tabDown )     str += 'tab,';
        if( altDown )     str += 'alt,';
        if( cmdDown )     str += 'cmd,';
        if( spaceDown )   str += 'space,';
        if( controlDown ) str += 'control,'; 
        if( deleteDown )  str += 'delete';
        return str;
    }
    inline
    function keyDown( e: KeyboardEvent ) {
        e.preventDefault();
        var keyCode = e.keyCode;
        switch( keyCode ){
            case KeyboardEvent.DOM_VK_LEFT:
                leftDown    = true;
                navSignal();
            case KeyboardEvent.DOM_VK_RIGHT:
                rightDown   = true;
                navSignal();
            case KeyboardEvent.DOM_VK_UP:
                upDown      = true;
                navSignal();
            case KeyboardEvent.DOM_VK_DOWN:
                downDown    = true;
                navSignal();
            case KeyboardEvent.DOM_VK_SHIFT:
                shiftDown   = true;
                commandSignal();
            case KeyboardEvent.DOM_VK_RETURN:
                enterDown   = true;
                commandSignal();
            case KeyboardEvent.DOM_VK_TAB:
                tabDown     = true;
                commandSignal();
            case KeyboardEvent.DOM_VK_ALT:
                altDown     = true;
                commandSignal();
            case KeyboardEvent.DOM_VK_META:
                cmdDown     = true;
                commandSignal();
            case KeyboardEvent.DOM_VK_SPACE:
                spaceDown   = true;
                commandSignal();
            case KeyboardEvent.DOM_VK_CONTROL:
                controlDown = true;
                commandSignal();
            case KeyboardEvent.DOM_VK_BACK_SPACE:
                deleteDown = true;
                commandSignal();
            default:
                if( e.key != null ) letterSignal( e.key );
        }
    }
    inline
    function keyUp( e: KeyboardEvent ) {
        e.preventDefault();
        var keyCode = e.keyCode;
        switch( keyCode ){
            case KeyboardEvent.DOM_VK_LEFT:
                leftDown    = false;
                navSignal();
            case KeyboardEvent.DOM_VK_RIGHT:
                rightDown   = false;
                navSignal();
            case KeyboardEvent.DOM_VK_UP:
                upDown      = false;
                navSignal();
            case KeyboardEvent.DOM_VK_DOWN:
                downDown    = false;
                navSignal();
            case KeyboardEvent.DOM_VK_SHIFT:
                shiftDown   = false; 
                commandSignal();
            case KeyboardEvent.DOM_VK_RETURN:
                enterDown   = false;
                commandSignal();
            case KeyboardEvent.DOM_VK_TAB:
                tabDown     = false;
                commandSignal();
            case KeyboardEvent.DOM_VK_ALT:
                altDown     = false;
                commandSignal();
            case KeyboardEvent.DOM_VK_META:
                cmdDown     = false;
                commandSignal();
            case KeyboardEvent.DOM_VK_SPACE:
                spaceDown   = false;
                commandSignal();
            case KeyboardEvent.DOM_VK_CONTROL:
                controlDown = false;
                commandSignal();
            case KeyboardEvent.DOM_VK_BACK_SPACE:
                deleteDown = false;
                commandSignal();
            default: 
                
        }
    }
}