package kitGL.glWeb;
import kitGL.glWeb.Ply;
import kitGL.glWeb.DataGL;
import js.html.ImageElement;
import haxe.io.Float32Array;

import HaxeLogo;
// Not currently used?
class PentagramSample extends Ply {
    var data: Float32Array;
    var x = function( x_: Float ) return x_/500. - 1.;
    var y = function( y_: Float ) return ( 1000. - y_ )/500. -1.;
    var tot: Int = 7;
    var len: Int;
    public function new( width: Int, height: Int ){
        super( width, height );
    }
    override
    public function draw(){
        var s = 2;
        var pentagram = [ // top
                          121*s, 111*s
                        , 150*s, 25*s
                        , 179*s, 111*s
                        // right top
                        , 179*s, 111*s
                        , 269*s, 111*s
                        , 197*s, 165*s
                        // right bottom
                        , 197*s, 165*s
                        , 223*s, 251*s
                        , 150*s, 200*s
                        // bottom left 
                        , 150*s, 200*s
                        , 77*s,  251*s
                        , 103*s, 165*s
                        // top left
                        , 103*s, 165*s
                        , 31*s,  111*s
                        , 121*s, 111*s
                        // middle down
                        , 121*s, 111*s
                        , 179*s, 111*s
                        , 150*s, 200*s
                        // middle right
                        , 197*s, 165*s
                        , 179*s, 111*s
                        , 150*s, 200*s
                        // middle left
                        , 103*s, 165*s
                        , 121*s, 111*s
                        , 150*s, 200*s
                   ];
        len = Std.int( pentagram.length/2 );
        data = new Float32Array( len*tot );
        var j = 0;
        var k = 0;
        var z = 0.;
        // Red
        var r = 1.;
        var g = 0.;
        var b = 0.;
        var a = 0.5;
        for( i in 0...( len + 1 ) ){
            j = i*tot;
            k = i*2;
            data[ j ]     = x( pentagram[ k ] );
            data[ j + 1 ] = y( pentagram[ k + 1 ] );
            data[ j + 2 ] = z;
            data[ j + 3 ] = r;
            data[ j + 4 ] = g;
            data[ j + 5 ] = b;
            data[ j + 6 ] = a;
        }
        prettyAll();
        dataGL           = { get_data: get_data
                           , get_size: get_size };
    }
    public function prettyAll(){
        var str = '';
        for( i in 0...data.length ){
            if( ( i )%tot == 0 ){
                trace( str );
                str = '';
            }
            str += data[ i ] + ', ';
        }
    }
    public function get_data(): Float32Array {
        return data;
    }
    public function get_size(): Int {
        return len;
    }
}