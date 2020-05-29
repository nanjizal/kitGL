package kitGL.upkeep;
#if !notKitGLDoc
import utest.Runner;
import utest.Test;
import utest.ui.Report;
import equals.Equal;
import utest.Assert;
// subfolders
import kitGL.glWeb.*;
import kitGL.glLime.*;
import kitGL.upkeep.TestLime;
import kitGL.upkeep.TestWebGL;

@:build(hx.doctest.DocTestGenerator.generateDocTests())
@:build(utest.utils.TestBuilder.build())
class Test extends utest.Test {
    public static function main() {
        var runner = new Runner();
        runner.addCase( new Test() );
        Report.create(runner);
        runner.run();
    }
    function new() {
        super();
    }
}
#end