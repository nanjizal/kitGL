package kitGL.util;

inline
function toHexInt( c: Float ): Int
        return Math.round( c * 255 );
inline
function toHexColor( alpha: Float, red: Float, green: Float, blue: Float ): Int
    return( toHexInt( alpha ) << 24 ) 
        | ( toHexInt( red ) << 16 ) 
        | ( toHexInt( green ) << 8 ) 
        |   toHexInt( blue );
inline
function hexToFloat( int: Int ):{ a: Float, r: Float, g: Float, b: Float }{
    var a = ((int >> 24) & 255) / 255;
    var r = ((int >> 16) & 255) / 255;
    var g = ((int >> 8) & 255) / 255;
    var b = (int & 255) / 255;
    return { a: a, r: r, g: g, b: b };
}