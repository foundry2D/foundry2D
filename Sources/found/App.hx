package found;

import kha.Canvas;
import kha.graphics2.ImageScaleQuality;
import kha.Image;
import kha.math.FastMatrix3;
import kha.System;
import kha.Scaler;

class App {

	private var _imageQuality:ImageScaleQuality;
	static var onResets: Array<Void->Void> = null;
	static var onEndFrames: Array<Void->Void> = null;
	static var traitAwakes:Array<Void->Void> = [];
	static var traitInits:Array<Void->Void> = [];
	static var traitUpdates:Array<Float->Void> = [];
	static var traitLateUpdates:Array<Void->Void> = [];
	static var traitRenders:Array<kha.graphics4.Graphics->Void> = [];
	static var traitRenders2D:Array<kha.graphics2.Graphics->Void> = [];

	public static function init(_appReady:Void->Void) {
		new App(_appReady);
	}
	#if editor
	public static var editorui:EditorUi = null;
	#end
	#if tile_editor
	public static var frameCounter:FPS = new FPS();
	#end
	public function new(_appReady:Void->Void){
		_appReady();
		Found.backbuffer = Image.createRenderTarget(Found.BUFFERWIDTH, Found.BUFFERHEIGHT);
		
    	_imageQuality = Found.smooth ? ImageScaleQuality.High:ImageScaleQuality.Low;

		found.State.setup();

		#if editor
		editorui = new EditorUi();
		#end
	}
	@:access(found.object.Executor)
	public static function reset() {
		Scene.ready = false;
		traitInits = [];
		traitUpdates = [];
		traitLateUpdates = [];
		traitRenders = [];
		traitRenders2D = [];

		if (onResets != null) for (f in onResets) f();
		
		for(exe in found.object.Executor.executors){
			var modified:Array<Any> = Reflect.field(found.object.Object,exe.field);
			modified = [];
		}
	}

	public function update(dt:Float):Void {
		if (State.active != null){
			State.active.update(dt);
		}
		#if editor
		editorui.update(dt);
		#end
		#if tile_editor
		Found.tileeditor.update(dt);
		frameCounter.update();
		#end

		if (onEndFrames != null) for (f in onEndFrames) f();
	}
	
	public function render(canvas:Canvas):Void {

		Found.backbuffer.g2.begin();
		canvas.g2.color = Found.backgroundcolor;
		canvas.g2.fillRect(0, 0, Found.backbuffer.width, Found.backbuffer.height);
		if (State.active != null){
			#if editor
			if(editorui.currentView == 0 && !editorui.isHidden())
			{
				Found.backbuffer.g2.pushTransformation(FastMatrix3.translation(-State.active.cam.position.x,-State.active.cam.position.y));
				EditorTools.drawGrid(Found.backbuffer.g2);
				Found.backbuffer.g2.popTransformation();
				State.active.render(Found.backbuffer);
			}
			else{
			#end
			State.active.render(Found.backbuffer);
			#if editor } #end
		}
		Found.backbuffer.g2.end();
		#if editor
		frameCounter.render(Found.backbuffer);
		frameCounter.addFrame();
		editorui.render(Found.backbuffer);
		if(editorui.currentView == 0 || !editorui.visible){//To avoid calling TileEditor when not in game view
		#end
		#if tile_editor
		#if editor if(editorui.currentView == 0 || editorui.isHidden())#end
			Found.tileeditor.render(Found.backbuffer);
		#end
		#if editor
		}//end
		if(zui.Popup.show) {            
			zui.Popup.render(Found.backbuffer.g2);
		}
		#end
		
		canvas.g2.begin();
		canvas.g2.imageScaleQuality = _imageQuality;
		Scaler.scale(Found.backbuffer, canvas, System.screenRotation);
		canvas.g2.end();
  }

	// Hooks
	public static function notifyOnAwake(f:Void->Void) {
		for(func in traitAwakes){
			if(Reflect.compareMethods(func,f)) return;
		}
		traitAwakes.push(f);
	}

	public static function removeAwake(f:Void->Void) {
		traitAwakes.remove(f);
	}

	public static function notifyOnInit(f:Void->Void) {
		for(func in traitInits){
			if(Reflect.compareMethods(func,f)) return;
		}
		traitInits.push(f);
	}

	public static function removeInit(f:Void->Void) {
		traitInits.remove(f);
	}

	public static function notifyOnUpdate(f:Float->Void) {
		for(func in traitUpdates){
			if(Reflect.compareMethods(func,f)) return;
		}
		traitUpdates.push(f);
	}

	public static function removeUpdate(f:Float->Void) {
		traitUpdates.remove(f);
	}
	
	public static function notifyOnLateUpdate(f:Void->Void) {
		for(func in traitLateUpdates){
			if(Reflect.compareMethods(func,f)) return;
		}
		traitLateUpdates.push(f);
	}

	public static function removeLateUpdate(f:Void->Void) {
		traitLateUpdates.remove(f);
	}

	public static function notifyOnRender(f:kha.graphics4.Graphics->Void) {
		for(func in traitRenders){
			if(Reflect.compareMethods(func,f)) return;
		}
		traitRenders.push(f);
	}

	public static function removeRender(f:kha.graphics4.Graphics->Void) {
		traitRenders.remove(f);
	}

	public static function notifyOnRender2D(f:kha.graphics2.Graphics->Void) {
		for(func in traitRenders2D){
			if(Reflect.compareMethods(func,f)) return;
		}
		traitRenders2D.push(f);
	}

	public static function removeRender2D(f:kha.graphics2.Graphics->Void) {
		traitRenders2D.remove(f);
	}

	public static function notifyOnReset(f:Void->Void) {
		if (onResets == null) onResets = [];
		onResets.push(f);
	}

	public static function removeReset(f:Void->Void) {
		onResets.remove(f);
	}

	public static function notifyOnEndFrame(f:Void->Void) {
		if (onEndFrames == null) onEndFrames = [];
		onEndFrames.push(f);
	}

	public static function removeEndFrame(f:Void->Void) {
		onEndFrames.remove(f);
	}
}

private class FPS {

	public var fps(default, null) = 0;
	var frames = 0;
	var time = 0.0;
	var lastTime = 0.0;
	var ui:zui.Zui;
	public function new() {	}

	public function update():Int {
		var deltaTime = kha.Scheduler.realTime() - lastTime;
		lastTime = kha.Scheduler.realTime();
		time += deltaTime;

		if (time >= 1) {
			fps = frames;
			frames = 0;
			time = 0;
		}
		return fps;
	}
	var lastFps:Int = 0;
	var fpsHandle:zui.Zui.Handle = zui.Id.handle();
	public function render(canvas:kha.Canvas,inEditor = true): Void {
		if(canvas.g2 == null || State.active == null || State.active.cam == null) return;
		if(ui == null)ui = new zui.Zui({font: kha.Assets.fonts.font_default});

		canvas.g2.pushTranslation(State.active.cam.position.x,State.active.cam.position.y);
		var oldScale = ui.SCALE();
		var width = 60;
		var height = 20;
		if(inEditor){
			ui.setScale(2.0);
			width*=2;
			height*=2;
		}
		ui.begin(canvas.g2);
		var accentCol = ui.t.ACCENT_COL;
		var windowBgColor = ui.t.WINDOW_BG_COL;
		ui.t.ACCENT_COL =ui.t.WINDOW_BG_COL= kha.Color.Transparent;
		
		fpsHandle.redraws = lastFps != fps ? 2 : 0;
		if(ui.window(fpsHandle,0,0, width, height,false))ui.text('Fps: $fps');
		canvas.g2.popTransformation();
		ui.end();
		ui.setScale(oldScale);
		ui.t.ACCENT_COL = accentCol;
		ui.t.WINDOW_BG_COL = windowBgColor;
	}

	public inline function addFrame():Void frames++;

}