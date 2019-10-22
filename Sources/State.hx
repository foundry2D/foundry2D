package ;

import data.SceneFormat.TSceneFormat;
import data.Data;
import kha.Canvas;
import kha.input.KeyCode;
import Scene;

class State extends Scene {
	public static var activeState:State;
	private static var _states:Map<String, String>;

	public function new(raw:TSceneFormat){
		super(raw);
		
	}

	override public function update(){
		super.update();
	}

	override public function render(canvas:Canvas){
		super.render(canvas);
	}

	public function onKeyDown(keyCode:KeyCode){}

	public function onKeyUp(keyCode:KeyCode){}

	public function onMouseDown(button:Int, x:Int, y:Int){}

	public function onMouseUp(button:Int, x:Int, y:Int){}

	public function onMouseMove(x:Int, y:Int, cx:Int, cy:Int){}

	public function onTouchDown(id:Int, x:Int, y:Int){}

	public function onTouchUp(id:Int, x:Int, y:Int){}

	public function onTouchMove(id:Int, x:Int, y:Int){}

	public function onGamepadAxis(axis:Int, value:Float){}

	public function onGamepadButton(button:Int, value:Float){}

	public static function setup(){
		_states = new Map<String, String>();
	}

	public static function addState(name:String, state:String):String {
		_states.set(name, state);
		return state;
	}

	public static function removeState(name:String){
		_states.remove(name);
	}

	public static function set(name:String){
		Scene.ready = false;
		var file = _states.get(name);
		Data.getSceneRaw(file,loadState);
	}
	private static function loadState(raw:TSceneFormat){
		activeState = new State(raw);
	}
	// Hooks
	public function notifyOnInit(f:Void->Void) {
		if (Scene.ready) f(); // Scene already running
		else traitInits.push(f);
	}

	public function removeInit(f:Void->Void) {
		traitInits.remove(f);
	}

	public function notifyOnRemove(f:Void->Void) {
		traitRemoves.push(f);
	}
}