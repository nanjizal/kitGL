package kitGL.glLime.setup;

import lime.graphics.WebGLRenderContext;


interface IAppGL{
    function update():Void;
    function setup( gl: WebGLRenderContext ):Void;
    function draw():Void;
    function render( gl: WebGLRenderContext ):Void;
    function renderDraw():Void;
}