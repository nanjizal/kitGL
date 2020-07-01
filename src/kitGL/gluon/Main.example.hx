package;
import kitGL.gluon.Glwrapper;
import kitGL.gluon.Animate;
function main(){
    var animate          = new Animate();
    var glWrapper        = new Glwrapper();
    var example          = new Example( glWrapper.gl );
    example.setup();
    glWrapper.onFrame    = example.render;
    glWrapper.onStop     = animate.stop;
    animate.onEnterFrame = glWrapper.mainLoop;
    animate.start();
}