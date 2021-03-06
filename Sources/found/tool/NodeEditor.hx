package found.tool;

// Kha
import zui.Themes;
import kha.Color;
// Zui
import zui.Id;
import zui.Zui;
import zui.Nodes;
// Editor
import found.data.SceneFormat.LogicTreeData;
import found.node.data.StdNode;
import found.node.data.MathNode;
import found.node.data.LogicNode;
import found.node.data.NodeCreator;
import found.node.data.VariableNode;
import found.node.data.FoundryNode;
import found.State;

@:access(zui.Zui)
class NodeEditor {
	public var visible:Bool;

	public static var width:Int;
	public static var height:Int;
	public static var x:Int;
	public static var y:Int;

	public function new(ui:zui.Zui, px:Int, py:Int, w:Int, h:Int) {
		this.visible = false;
		setAll(px, py, w, h);
		ui.g.end();
		drawGrid();
		ui.g.begin(false);
	}

	public function setAll(px:Int, py:Int, w:Int, h:Int) {
		x = px;
		y = py;
		width = w;
		height = h;
	}

	public static var nodesArray:Array<LogicTreeData> = [];
	public static var selectedNode:LogicTreeData = null;

	static var panX(get,never):Float;
	static function get_panX() {
		if(NodeEditor.selectedNode != null){
			return NodeEditor.selectedNode.nodes.panX * NodeEditor.selectedNode.nodes.SCALE() % 40 - 40;
		}
		return 0.0;
	}
	static var panY(get,never):Float;
	static function get_panY() {
		if(NodeEditor.selectedNode != null){
			return NodeEditor.selectedNode.nodes.panY * NodeEditor.selectedNode.nodes.SCALE() % 40 - 40;
		}
		return 0.0;
	}

	static var gameplayNodes:Map<String, Array<TNode>> = new Map<String, Array<TNode>>();

	public static function addCustomNode(section:String, node:Dynamic) {
		if (gameplayNodes.exists(section)) {
			gameplayNodes.get(section).push(node);
		} else {
			gameplayNodes.set(section, [node]);
		}
	}

	public var nodeCanvasWindowHandle = Id.handle();
	public var nodeMenuWindowHandle = Id.handle();
	public var nodeMenuTabHandle = Id.handle();

	public function redraw() {
		nodeCanvasWindowHandle.redraws = nodeMenuWindowHandle.redraws = nodeMenuTabHandle.redraws = 2;
	}
	@:access(zui.Zui)
	public function render(ui:zui.Zui) {
		if (!visible)
			return;

		var nodePanX:Float = 0.0;
		var nodePanY:Float = 0.0;
		if (NodeEditor.selectedNode != null) {
			nodePanX += panX;
			nodePanY += panY;
			if (nodePanX > 0.0)
				nodePanX = 0;
			else if (Math.abs(nodePanX) > kha.System.windowWidth() - NodeEditor.width)
				nodePanX = -(kha.System.windowWidth() - NodeEditor.width);
			if (nodePanY > 0.0)
				nodePanY = 0;
			else if (Math.abs(nodePanY) > kha.System.windowHeight() - NodeEditor.height)
				nodePanY = -(kha.System.windowHeight() - NodeEditor.height);

			var updatedObjectList = State.active.getObjectNames();
			var updatedSpriteList = State.active.getObjectNames("sprite_object");
			for (node in NodeEditor.selectedNode.nodes.nodesSelected) {
				if (node.type == "GetObjectNode" || node.type == "GetRandomObjectNode") {
					node.buttons[0].data = updatedObjectList;
				}
				else if (node.type == "FlipSpriteNode") {
					node.buttons[0].data = updatedSpriteList;
				}
				else if(node.type == "GetPropNode" || node.type == "SetPropNode"){
					var props = Trait.getProps(node.buttons[0].data[0]);
					var out = [];
					for(p in props){
						out.push(p.split("~")[0]);
					}
					node.buttons[1].data = out;
				}
			}
		}
		if (ui.window(nodeCanvasWindowHandle, NodeEditor.x, NodeEditor.y, NodeEditor.width, NodeEditor.height)) {
			ui.g.color = kha.Color.White;
			ui.g.drawImage(grid, nodePanX, nodePanY);
			var t = ui.t;
			ui.t = Themes.dark;
			var oldS = ui.ops.scaleFactor;
			ui.setScale(ui.ops.scaleFactor * 1.5);
			renderNodes(ui);
			ui.t = t;
			ui.setScale(oldS);
		}
		renderNodesMenu(ui);
	}

	public function renderNodes(ui:Zui) {
		if (selectedNode != null)
			selectedNode.nodes.nodeCanvas(ui, selectedNode.nodeCanvas);
	}

	public function renderNodesMenu(ui:Zui) {
		if (selectedNode == null)
			return;
		var numTabs = 3;
		if (ui.window(nodeMenuWindowHandle, NodeEditor.x, NodeEditor.y, Std.int(ui.ELEMENT_W() * 0.5 * numTabs) , Std.int(NodeEditor.height * 0.75), true)) {
			if (ui.tab(nodeMenuTabHandle, "Std")) {
				if (ui.panel(Id.handle(), "Logic")) {
					if (ui.button("Gate"))
						pushNodeToSelectedGroup(LogicNode.gate);
					if (ui.button("Branch"))
						pushNodeToSelectedGroup(LogicNode.branch);
					if (ui.button("Is False"))
						pushNodeToSelectedGroup(LogicNode.isFalse);
					if (ui.button("Is True"))
						pushNodeToSelectedGroup(LogicNode.isTrue);
					if (ui.button("While"))
						pushNodeToSelectedGroup(LogicNode.whileN);
				}
				if (ui.panel(Id.handle(), "Variable")) {
					if (ui.button("String"))
						pushNodeToSelectedGroup(VariableNode.string);
					if (ui.button("Float"))
						pushNodeToSelectedGroup(VariableNode.float);
					if (ui.button("Int"))
						pushNodeToSelectedGroup(VariableNode.int);
					// ui.button("Array");
					if (ui.button("Boolean"))
						pushNodeToSelectedGroup(VariableNode.boolean);
					if (ui.button("Vector2"))
						pushNodeToSelectedGroup(VariableNode.vector2);
					if (ui.button("GetProp")){
						var def = Reflect.copy(VariableNode.getProp);
						var ext = "_vhx";
						def.buttons[0].data = [selectedNode.name+ext];
						pushNodeToSelectedGroup(def);
					}
					if (ui.button("SetProp")){
						var def = Reflect.copy(VariableNode.setProp);
						var ext = "_vhx";
						def.buttons[0].data = [selectedNode.name+ext];
						pushNodeToSelectedGroup(def);
					}
						
				}
				if (ui.panel(Id.handle(), "Std")) {
					if (ui.button("Print"))
						pushNodeToSelectedGroup(StdNode.print);
					if (ui.button("Parse Int"))
						pushNodeToSelectedGroup(StdNode.parseInt);
					if (ui.button("Parse Float"))
						pushNodeToSelectedGroup(StdNode.parseFloat);
					if (ui.button("Float To Int"))
						pushNodeToSelectedGroup(StdNode.floatToInt);
				}
				if (ui.panel(Id.handle(), "Math")) {
					if (ui.button("Maths"))
						pushNodeToSelectedGroup(MathNode.maths);
					if (ui.button("Rad to Deg"))
						pushNodeToSelectedGroup(MathNode.radtodeg);
					if (ui.button("Deg to Rad"))
						pushNodeToSelectedGroup(MathNode.degtorad);
					if (ui.button("Random (Int)"))
						pushNodeToSelectedGroup(MathNode.randi);
					if (ui.button("Random (Float)"))
						pushNodeToSelectedGroup(MathNode.randf);
				}
			}
			if (ui.tab(nodeMenuTabHandle, "Foundry2d")) {
				if (ui.panel(Id.handle(), "Event")) {
					if (ui.button("On Add"))
						pushNodeToSelectedGroup(FoundryNode.onAddNode);
					if (ui.button("On Init"))
						pushNodeToSelectedGroup(FoundryNode.onInitNode);
					if (ui.button("On Update"))
						pushNodeToSelectedGroup(FoundryNode.onUpdateNode);
					if (ui.button("MultiEvent"))
						pushNodeToSelectedGroup(FoundryNode.multiEventNode);
					if (ui.button("Event Listener"))
						pushNodeToSelectedGroup(FoundryNode.eventListenNode);
					if (ui.button("Send Event"))
						pushNodeToSelectedGroup(FoundryNode.sendEventNode);
				}
				if (ui.panel(Id.handle(), "Input")) {
					if (ui.button("On Mouse"))
						pushNodeToSelectedGroup(FoundryNode.onMouseNode);
					if (ui.button("Mouse Coord"))
						pushNodeToSelectedGroup(FoundryNode.mouseCoordNode);
					if (ui.button("On Keyboard"))
						pushNodeToSelectedGroup(FoundryNode.onKeyboardNode);
					if (ui.button("On Gamepad Axis"))
						pushNodeToSelectedGroup(FoundryNode.onGamepadAxisInputNode);
					if (ui.button("On Gamepad Button"))
						pushNodeToSelectedGroup(FoundryNode.onGamepadButtonInputNode);
				}
				if (ui.panel(Id.handle(), "Math")) {
					if (ui.button("Split Vec2"))
						pushNodeToSelectedGroup(FoundryNode.splitVec2Node);
					if (ui.button("Join Vec2"))
						pushNodeToSelectedGroup(FoundryNode.joinVec2Node);
					if (ui.button("Add Vec2"))
						pushNodeToSelectedGroup(FoundryNode.addVec2Node);
					if (ui.button("Multiply Vec2"))
						pushNodeToSelectedGroup(FoundryNode.multiplyVec2Node);
					if (ui.button("Multiply 2 Vec2"))
						pushNodeToSelectedGroup(FoundryNode.multiplyVec2sNode);
				}
				if (ui.panel(Id.handle(), "Time")) {
					if (ui.button("Every X Seconds"))
						pushNodeToSelectedGroup(FoundryNode.everyXNode);
					if (ui.button("Cooldown X Seconds"))
						pushNodeToSelectedGroup(FoundryNode.cooldownNode);
				}

				if (ui.panel(Id.handle(), "Transform")) {
					if (ui.button("Get Position"))
						pushNodeToSelectedGroup(FoundryNode.getPositionNode);
					if (ui.button("Get Center"))
						pushNodeToSelectedGroup(FoundryNode.getCenterNode);
					if (ui.button("Get Forward"))
						pushNodeToSelectedGroup(FoundryNode.getForwardNode);
					if (ui.button("Get Width/Height"))
						pushNodeToSelectedGroup(FoundryNode.getWidthHeightNode);
					if (ui.button("Set Object Location"))
						pushNodeToSelectedGroup(FoundryNode.setObjectLocationNode);
					if (ui.button("Get Rotation"))
						pushNodeToSelectedGroup(FoundryNode.getRotationNode);
					if (ui.button("Translate Object"))
						pushNodeToSelectedGroup(FoundryNode.translateObjectNode);
					if (ui.button("Rotate Toward Position"))
						pushNodeToSelectedGroup(FoundryNode.rotateTowardPositionNode);
				}
				if (ui.panel(Id.handle(), "Object")) {
					if (ui.button("Get Object"))
						pushNodeToSelectedGroup(FoundryNode.getObjectNode);
					if (ui.button("Spawn Object"))
						pushNodeToSelectedGroup(FoundryNode.spawnObjectNode);
					if (ui.button("Is Object Outside View"))
						pushNodeToSelectedGroup(FoundryNode.isObjectOutsideViewNode);
					if (ui.button("Destroy Object"))
						pushNodeToSelectedGroup(FoundryNode.destroyObjectNode);
					if (ui.button("Destroy Object Outside View"))
						pushNodeToSelectedGroup(FoundryNode.destroyObjectOutsideViewNode);
					if (ui.button("Get Random Object from list"))
						pushNodeToSelectedGroup(FoundryNode.getRandomObjectNode);
				}
				if (ui.panel(Id.handle(), "Sprite")) {
					if (ui.button("Flip Sprite"))
						pushNodeToSelectedGroup(FoundryNode.flipSpriteNode);
				}
				if (ui.panel(Id.handle(), "Physics")) {
					if (ui.button("On Collision Event"))
						pushNodeToSelectedGroup(FoundryNode.onCollisionNode);
					if (ui.button("Apply Force To Rigidbody"))
						pushNodeToSelectedGroup(FoundryNode.applyForceToRigidbodyNode);
					if (ui.button("Apply Impulse To Rigidbody"))
						pushNodeToSelectedGroup(FoundryNode.applyImpulseToRigidbodyNode);
				}
				if (ui.panel(Id.handle(), "Controllers")) {
					if (ui.button("Top-down Controller"))
						pushNodeToSelectedGroup(FoundryNode.topDownControllerNode);
					if (ui.button("Platformer 2D Controller"))
						pushNodeToSelectedGroup(FoundryNode.platformer2DControllerNode);
				}
				if (ui.panel(Id.handle(), "Movement")) {
					if (ui.button("Bullet Movement"))
						pushNodeToSelectedGroup(FoundryNode.bulletMovementNode);
				}
				if (ui.panel(Id.handle(), "Camera")) {
					if (ui.button("Set Camera Position"))
						pushNodeToSelectedGroup(FoundryNode.setCameraTargetPositionNode);
					if (ui.button("Set Camera Follow Target"))
						pushNodeToSelectedGroup(FoundryNode.setCameraFollowTargetNode);
				}
				if (ui.panel(Id.handle(), "Animation")) {
					if (ui.button("Play Animation"))
						pushNodeToSelectedGroup(FoundryNode.playAnimationNode);
				}
				// Uncomment when this is done and works
				// if (ui.panel(Id.handle(), "Audio")) {
				// 	if (ui.button("Play Music"))
				// 		pushNodeToSelectedGroup(FoundryNode.playMusicNode);
				// 	if (ui.button("Play Sfx"))
				// 		pushNodeToSelectedGroup(FoundryNode.playSfxNode);
				// }
			}
			if (ui.tab(nodeMenuTabHandle, "Custom")) {
				for (sec in gameplayNodes.keys()) {
					if (ui.panel(Id.handle(), sec)) {
						var nodes = gameplayNodes.get(sec);
						for (node in nodes) {
							if (ui.button(node.name))
								pushNodeToSelectedGroup(node);
						}
					}
				}
			}
		}
	}

	public static function getNodesArrayNames() {
		var names = [];
		for (nodes in nodesArray)
			names.push(nodes.name);
		return names;
	}

	public static function pushNodeToSelectedGroup(tnode:TNode) {
		var valueX = panX;
		var valueY = panY;
		tnode.x = valueX * -1 + NodeEditor.width * 0.5;
		tnode.y = valueY * -1 + NodeEditor.height * 0.5;
		selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(tnode, selectedNode.nodes, selectedNode.nodeCanvas));
	}

	public static var grid:kha.Image = null;
	public static var gridSize:Int = 20;

	function drawGrid() {
		var doubleGridSize = gridSize * 2;
		var ww = kha.System.windowWidth();
		var wh = kha.System.windowHeight();
		var w = ww + doubleGridSize * 2;
		var h = wh + doubleGridSize * 2;
		grid = kha.Image.createRenderTarget(w, h);
		grid.g2.begin(true, 0xff242424);
		grid.g2.color = 0xff202020;
		grid.g2.fillRect(0, 0, w, h);
		for (i in 0...Std.int(h / doubleGridSize) + 1) {
			grid.g2.color = 0xff282828;
			grid.g2.drawLine(0, i * doubleGridSize, w, i * doubleGridSize, 2);
			grid.g2.color = 0xff323232;
			grid.g2.drawLine(0, i * doubleGridSize + gridSize, w, i * doubleGridSize + gridSize);
		}
		for (i in 0...Std.int(w / doubleGridSize) + 1) {
			grid.g2.color = 0xff282828;
			grid.g2.drawLine(i * doubleGridSize, 0, i * doubleGridSize, h, 2);
			grid.g2.color = 0xff323232;
			grid.g2.drawLine(i * doubleGridSize + gridSize, 0, i * doubleGridSize + gridSize, h);
		}

		grid.g2.end();
	}
}
// Colours
// Bool -> Green -> -10822566
// Float/Int -> Blue -> -10183681
// String -> Grey -> -4934476
// Action type node -> Red -> -4962746
// Variable type node -> Cyan -> -16067936
