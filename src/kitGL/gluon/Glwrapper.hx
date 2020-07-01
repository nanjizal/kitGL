package kitGL.gluon;

import glfw.GLFW.*;
import cpp.Pointer;
import cpp.Float32;
import gluon.webgl.native.GLContext;
import glfw.GLFW.GLFWwindow;
/**
 *  Creates a glfw window and uses Demo to call OpenGL commands
 *  created by haxiomic, formatting and modifications by nanjizal
 **/
class Glwrapper {
    final startupFullscreen = false;
    var window:         Pointer<GLFWwindow>;
    var pixelRatio:     Float = 1;
    //var demo:           Demo;
    var initFail        =  "Could not initialize GLFW";
    var windowFail      =  "Could not create GLFW window";
    public var onFrame: ( Int, Int )-> Void;
    public var onStop: Void -> Void;
    public var gl: GLContext;
    public function new() {
        glfwSetErrorCallback( onGLFWError );
        if( glfwInit() == 0 ) throw initFail;
        glfwHints();
        var monitor   = glfwGetPrimaryMonitor();
        var videoMode = glfwGetVideoMode( monitor );
        // examine video modes
        trace( 'VideoMode: ${videoMode.value.width}x${videoMode.value.height} @ ${videoMode.value.refreshRate}' );
        trace( glfwGetVideoModes( monitor ).map( 
            m -> '${m.width}x${m.height} @ ${m.refreshRate}'));
        var dim = videoMode.value;
        var windowWidth  = Std.int( dim.width );
        var windowHeight = Std.int( dim.height );
        window = glfwCreateWindow( windowWidth
                                 , windowHeight
                                 , "Gluon Demo"
                                 , startupFullscreen ? glfwGetPrimaryMonitor() : null, null );
        if( window == null ){
            glfwTerminate();
            throw windowFail;
        }
        glfwMakeContextCurrent( window ); // context settings
        glfwSwapInterval( 1 );            // add event bindings
        glfwSetWindowSizeCallback(  window, onResize );
        glfwSetCursorPosCallback(   window, onMousePosChange );
        glfwSetMouseButtonCallback( window, onMouseButton );
        glfwSetKeyCallback(         window, onKey);
        gl = new GLContext();
        var videoMode        = glfwGetVideoMode( monitor );
        var videoMode = glfwGetVideoMode(monitor);
        var videoModeSize = '${videoMode.value.width}x${videoMode.value.height}';
        #if macos
            pixelRatio       = getPixelRatio();
        #end
        trace( videoModeSize
             , getScreenBufferSize()
             , getWindowSize()
             , pixelRatio );
    }
    inline
    function videoSizeString( videoMode_ ){
        var videoMode = videoMode_;
        return '${videoMode.value.width}x${videoMode.value.height}';
    }
    inline 
    function refreshString( videoMode_ ){
        var videoMode = videoMode_; 
        return '${videoMode.value.refreshRate}';
    }
    inline
    function glfwHints(){
        glfwWindowHint( GLFW_CONTEXT_VERSION_MAJOR,    2 );
        glfwWindowHint( GLFW_CONTEXT_VERSION_MINOR,    1 );
        glfwWindowHint( GLFW_SAMPLES,                  0 );
        glfwWindowHint( GLFW_REFRESH_RATE,             60 ); // use highest
        glfwWindowHint( GLFW_RESIZABLE,                GLFW_TRUE );
        glfwWindowHint( GLFW_AUTO_ICONIFY,             GLFW_TRUE );
        glfwWindowHint( GLFW_COCOA_RETINA_FRAMEBUFFER, GLFW_TRUE );
        glfwWindowHint( GLFW_SCALE_TO_MONITOR,         GLFW_TRUE );
    }
    function terminate() {
        onStop();
        glfwDestroyWindow( window );
        glfwTerminate();
    }
    public function mainLoop() {
        if( glfwWindowShouldClose( window ) == 1 ) {
            terminate();
            return;
        }
        // pause all rendering the window is size 0,0
        var screenBufferSize = getScreenBufferSize();
        if( screenBufferSize.width > 0 && screenBufferSize.height > 0 ) {
            onFrame( screenBufferSize.width, screenBufferSize.height );
            // swap buffers blocks until the next frame sync
            // a better approach might be to handle rendering and windowing on a separate thread
            // the problem with blocking like this is it means we can't asynchronously schedule work that requires the GL context as this guy will prevent any work running until the next frame
            // we can resolve this by using non-blocking swapBuffers and OpenGL sync points and fences
            glfwSwapBuffers( window );
        }
        // give glfw a change to fire events for the next frame
        glfwPollEvents();
    }
    function onGLFWError( code: Int, message: String ) trace( 'GLFW Error: $message ($code)' );
    function onResize( window: Pointer<glfw.GLFW.GLFWwindow>
                     , width:  Int
                     , height: Int ){
        var screenBufferSize = getScreenBufferSize();
        trace( 'Resizing window to ' +
               '${screenBufferSize.width}x${screenBufferSize.height}' );
    }
    function onKey( key: Int, scanCode: Int, action: Int, mods: Int ){}
    function onMousePosChange( x: Float, y: Float ){}
    function onMouseButton(button: Int, action: Int, mods: Int){}
    inline
    function getWindowSize() {
        var width:  Int = -1;
        var height: Int = -1;
        glfwGetWindowSize( window
                         , Pointer.addressOf( width )
                         , Pointer.addressOf( height ) );
        return {
            width: width,
            height: height
        }
    }
    inline
    function getScreenBufferSize() {
        var width:  Int = -1;
        var height: Int = -1;
        glfwGetFramebufferSize( window
                              , Pointer.addressOf( width )
                              , Pointer.addressOf( height ) );
        return {
            width: width,
            height: height
        }
    }
    inline
    function getPixelRatio() {
        var xScale: Float32 = 0;
        var yScale: Float32 = 0;
        glfwGetWindowContentScale( window
                                 , Pointer.addressOf( xScale )
                                 , Pointer.addressOf( yScale ) );
        return xScale;
    }
}