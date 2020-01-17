package found;

import kha.Framebuffer;
import kha.Scheduler;
import kha.Assets;
import kha.System;
import kha.Color;
import kha.Image;

#if (kha_html5 &&js)
import js.html.CanvasElement;
import js.Browser.document;
import js.Browser.window;
#end

class Found {
  private static var _app:App;
  
  public static var WIDTH(default, null):Int = 1280;
  public static var HEIGHT(default, null):Int = 720;

  public static var GRID:Int = 64;

  public static var backbuffer:Image;
  #if editor
  public static var scenebuffer:Image;
  public static var renderfunc:kha.graphics2.Graphics->Void;
  public static var fullscreen:Bool = false;
  
  public static var BUFFERWIDTH(default, default):Int = WIDTH;
  public static var BUFFERHEIGHT(default, default):Int = HEIGHT;
  #else 
  public static var BUFFERWIDTH(default, null):Int = WIDTH;
  public static var BUFFERHEIGHT(default, null):Int = HEIGHT;
  #end

  #if tile_editor
  public static var ui:found.zui.Zui;
  public static var uiHandle = found.zui.Id.handle();
  public static var tileeditor:found.tool.TileEditor;
  #end

  #if debug
  public static var collisionsDraw:Bool = true;
  #end

  public static var mouseX:Int = 0;
	public static var mouseY:Int = 0;

  public static var sceneX:Float=0.0;
  public static var sceneY:Float=0.0;
  public static var backgroundcolor:Color;

  public static var smooth:Bool;

  private static var _fps:Float;

  public static function setup(config:FoundConfig){
    if (config.width == null) config.width = WIDTH;
    if (config.height == null) config.height = HEIGHT;
    if (config.bufferwidth == null) config.bufferwidth = WIDTH;
    BUFFERWIDTH = config.bufferwidth;
    if (config.bufferheight == null) config.bufferheight = HEIGHT;
    BUFFERHEIGHT = config.bufferheight;

    if (config.fps == null) config.fps = 60;
    _fps = config.fps;

    if (config.backgroundcolor == null) config.backgroundcolor = Color.Black;
    backgroundcolor = config.backgroundcolor;

    if (config.smooth == null) config.smooth = true;
    smooth = config.smooth;

    html();

    System.start({
			title:config.title,
			width:config.width,
			height:config.height
		},
		function(_){
			Assets.loadEverything(function(){
				Scheduler.addTimeTask(update, 0, 1 / _fps);
        resize(System.windowWidth(),System.windowHeight());
        _app = Type.createInstance(config.app, []);
        kha.Window.get(0).notifyOnResize(resize);
				System.notifyOnFrames(function(framebuffer){
				  render(framebuffer[0]);
				});
        #if tile_editor
        ui = new found.zui.Zui({font: kha.Assets.fonts.font_default});
        tileeditor = new found.tool.TileEditor();
        #end
			});
		});
  }
  static function resize(width:Int,height:Int){
    Reflect.setField(Found,"WIDTH",width);
    Reflect.setField(Found,"HEIGHT",height);
    BUFFERWIDTH = WIDTH;
    BUFFERHEIGHT = HEIGHT;
  }
  static function update(){
    Timer.update();
    _app.update(Timer.delta);
  }

  static function render(framebuffer:Framebuffer){
    _app.render(framebuffer);
  }

  static function html(){
    #if (kha_html5 && js)
    document.documentElement.style.padding = '0';
    document.documentElement.style.margin = '0';
    document.body.style.padding = '0';
    document.body.style.margin = '0';

    var canvas = cast(document.getElementById('khanvas'), CanvasElement);
    canvas.style.display = 'block';

    var resize = function(){
      canvas.width = Std.int(window.innerWidth * window.devicePixelRatio);
      canvas.height = Std.int(window.innerHeight * window.devicePixelRatio);
      canvas.style.width = document.documentElement.clientWidth + 'px';
      canvas.style.height = document.documentElement.clientHeight + 'px';
    }
    window.onresize = resize;
    resize();
    #end
  }
}

typedef FoundConfig = {
  app:Class<App>,
  ?timer:Timer,
  ?title:String,
  ?width:Int,
  ?height:Int,
  ?bufferwidth:Int,
  ?bufferheight:Int,
  ?backgroundcolor:Color,
  ?smooth:Bool,
  ?fps:Float
}