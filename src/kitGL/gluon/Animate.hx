package kitGL.gluon;

import haxe.MainLoop;
import haxe.Timer;
class Animate{
    public var speedDelta: Float = 0.01;
    public var onEnterFrame: Void -> Void;
    public var onStop:       Void -> Void;
    public var onStart:      Void -> Void;
    public var lastT:        Float = 0;
    public 
    var mainLoopHandle: MainEvent;
    public function new(){
        onEnterFrame = function(){ /*   */ };
        onStop     = function(){ /*   */ };
        onStart    = function(){ /*   */ };
    }
    public function start(){
        mainLoopHandle = MainLoop.add( mainLoop );
        onStart();
    }
    public function mainLoop(){
        var t_s = haxe.Timer.stamp();
        if( t_s - lastT > speedDelta ){
            onEnterFrame();
            lastT = t_s;
        }
    }
    public function stop(){
        mainLoopHandle.stop();
        onStop();
    }
}