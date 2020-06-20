package kitGL.gluon;
import typedarray.Float32Array;
typedef TInterleaveDataGL = {
    public function get_data(): Float32Array;
    public function get_size(): Int;
}
@:forward
abstract InterleaveDataGL( TInterleaveDataGL ) to TInterleaveDataGL from TInterleaveDataGL {
    public inline function new( tInterleaveDataGL: TInterleaveDataGL ){
        this = tInterleaveDataGL;
    }
    public var data( get, never ): Float32Array ;
    inline function get_data(): Float32Array {
        return this.get_data();
    }
    public var size( get, never ): Int;
    inline function get_size(): Int {
        return this.get_size();
    }
}