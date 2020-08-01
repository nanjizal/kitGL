package kitGL.gluon;
import typedarray.Float32Array;
typedef TDataGL = {
    public function get_data(): Float32Array;
    public function get_size(): Int;
}
@:forward
abstract DataGL( TDataGL ) to TDataGL from TDataGL {
    public inline function new( tDataGL: TDataGL ){
        this = tDataGL;
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