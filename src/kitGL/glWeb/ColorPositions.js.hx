package kitGL.glWeb;
#if js
import haxe.io.Float32Array;
//import lime.utils.Float32Array;
inline
function tri2D(): Float32Array {
    return Float32Array.fromArray([
         0.0,  0.5,    1.0,  1.0,  0.4,
        -0.5, -0.5,    0.3,  0.1,  0.8,
         0.5, -0.5,    1.0,  0.0,  0.5	
    ]);
}
// Define points for equilateral triangles.
inline 
function positions(): Float32Array {
    return Float32Array.fromArray([
        // X, Y, Z,
        -0.5, -0.25, 0.0,
        0.5, -0.25, 0.0,
        0.0, 0.559016994, 0.0 ]);
}
inline 
function othogPositions(): Float32Array {
    return Float32Array.fromArray([
        // X, Y, Z,
        300*(1-0.5), 300*(1-0.25), 0.0,
        300*(1+0.5), 300*(1-0.25), 0.0,
        300*(1+0.0), 300*(1+0.559016994), 0.0 ]);
}

// This triangle is red, green, and blue.
inline 
function colors(): Float32Array {
    return Float32Array.fromArray([
        // R, G, B, A
        1.0, 0.0, 0.0, 1.0,
        0.0, 0.0, 1.0, 1.0,
        0.0, 1.0, 0.0, 1.0 ]);
}
// defines 3 tall triangles 
inline 
function positions3(): Float32Array {
     return Float32Array.fromArray([
        // x,    y,   z
         0.0,   0.5,  0.5,
        -0.25, -0.5,  0.5,
         0.25, -0.5,  0.5,
         
         0.0,   0.5, 0.0,
        -0.25, -0.5, 0.0,
         0.25, -0.5, 0.0,

         0.0,   0.5, -0.5,
        -0.25, -0.5, -0.5,
         0.25, -0.5, -0.5 ]);
}
// colors the 3 tall triangles
inline
function colors3(): Float32Array {    
    return Float32Array.fromArray([
                  //r,   g,   b
                  1.0, 0.0, 0.0,
                  1.0, 1.0, 0.0,
                  1.0, 0.0, 1.0,

                  1.0, 1.0, 0.0,
                  0.0, 1.0, 0.0,
                  0.0, 1.0, 1.0,

                  0.0, 0.0, 1.0,
                  1.0, 1.0, 1.0,
                  0.0, 1.0, 1.0 ]);
}

// just used for docs
class ColorPositions {
    public var tri2D_: () -> Float32Array = tri2D;
    public var positions_: () -> Float32Array = positions;
    public var othogPositions_: () -> Float32Array = othogPositions;
    public var colors_: () -> Float32Array = colors;
    public var positions3_: () -> Float32Array = positions3;
    public var colors3_: () -> Float32Array = colors3;
}
#end