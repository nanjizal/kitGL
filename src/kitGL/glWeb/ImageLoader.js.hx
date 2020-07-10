package kitGL.glWeb;
// taken from my htmlHelper
import js.Lib;
import js.html.ImageElement;
import js.html.Event;
import js.html.Document;
import js.Browser;
typedef Hash<T> = haxe.ds.StringMap<T>;
class ImageLoader{
    public var images:   Hash<ImageElement>;
    public var imageArr: Array<ImageElement>;
    private var loaded:  Void -> Void;
    private var count:   Int;
    public
    function new( imageNames: Array<String>, loaded_: Void -> Void ){
        images = new Hash();
        imageArr = new Array<ImageElement>();
        loaded = loaded_;
        count = imageNames.length;
        for( name in imageNames ) load( name );
    }
    function load( img: String ){ 
        var image: ImageElement     = js.Browser.document.createImageElement();
        var imgStyle                = image.style;
        imgStyle.left               = '0px';
        imgStyle.top                = '0px';
        imgStyle.paddingLeft        = "0px";
        imgStyle.paddingTop         = "0px";
        image.onload                = store.bind( image, img.split('/').pop() );
        imgStyle.position           = "absolute";
        image.src                   = img;
    }
    // for use when images are base64 encoded to a string.
    public
    function loadEncoded( imageEncoded: Array<String>, imageNames: Array<String> ){
        count = imageNames.length;
        for( i in 0...count ){ 
            encodedLoad( imageEncoded[ i ],  imageNames[ i ], i ); 
        }
    }
    // for use when image is base64 encoded to a string.
    function encodedLoad( imgStr: String, name: String, index: Int ){
        var image: ImageElement     = js.Browser.document.createImageElement();
        var imgStyle                = image.style;
        imgStyle.left               = '0px';
        imgStyle.top                = '0px';
        imgStyle.paddingLeft        = "0px";
        imgStyle.paddingTop         = "0px";
        image.onload                = store.bind( image, name, index );
        imgStyle.position           = "absolute";
        image.src                   = imgStr;
    }
    function store( image: ImageElement, name: String, index: Int, e: Event ){
        count--;
        trace( 'store ' + name + ' ' + count );
        images.set( name, image );
        imageArr[ index ] = image;
        if( count == 0 ){
            loaded();
        }
    }
}