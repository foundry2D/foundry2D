package found.node.data;

import zui.Nodes.TNode;
import kha.math.FastVector2;

class FoundryNode {
	public static var onInitNode:TNode = {
		id: 0,
		name: "On Init",
		type: "InitNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [],
		color: -4962746
	};
	public static var onUpdateNode:TNode = {
		id: 0,
		name: "On Update",
		type: "UpdateNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [],
		color: -4962746
	};
	public static var onMouseNode:TNode = {
		id: 0,
		name: "On Mouse",
		type: "OnMouseNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [
			{
				name: "operations1",
				type: "ENUM",
				data: ["Started", "Down", "Release", "Moved"],
				output: 0,
				default_value: 0
			},
			{
				name: "operations2",
				type: "ENUM",
				data: ["Left", "Middle", "Right"],
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
	public static var mouseCoordNode:TNode = {
		id: 0,
		name: "Mouse Coord",
		type: "MouseCoordNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Position",
				type: "VECTOR2",
				color: -7929601,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Movement",
				type: "VECTOR2",
				color: -7929601,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Wheel Delta",
				type: "VALUE",
				color: -10183681,
				default_value: ""
			}
		],
		buttons: [],
		color: -4962746
	};
	public static var setObjectLocNode:TNode = {
		id: 0,
		name: "Set Object Location",
		type: "SetObjLocNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "In",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "STRING",
				color: -4934476,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var splitVec2Node:TNode = {
		id: 0,
		name: "Split Vec2",
		type: "SplitVec2Node",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "X",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name: "Y",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		buttons: []
	};
	public static var translateObjectNode:TNode = {
		id: 0,
		name: "Translate Object",
		type: "TranslateObjectNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "In",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Object",
				type: "STRING",
				color: -4934476,
				default_value: ""
			},
			{
				id: 0,
				node_id: 0,
				name: "Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: new kha.math.FastVector2(0.0, 0.0)
			},
			{
				id: 0,
				node_id: 0,
				name: "Speed",
				type: "VALUE",
				color: -10183681,
				default_value: 1.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: []
	};
	public static var joinVec2Node:TNode = {
		id: 0,
		name: "Join Vec2",
		type: "JoinVec2Node",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "X",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			},
			{
				id: 0,
				node_id: 0,
				name: "Y",
				type: "VALUE",
				color: -10183681,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Vec2",
				type: "VECTOR2",
				color: -7929601,
				default_value: [0.0, 0.0]
			}
		],
		buttons: []
	};
	public static var onKeyboardNode:TNode = {
		id: 0,
		name: "On Keyboard",
		type: "OnKeyboardNode",
		x: 200,
		y: 200,
		inputs: [],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [
			{
				name: "operations1",
				type: "ENUM",
				data: ["Started", "Down", "Release"],
				output: 0,
				default_value: 0
			},
			{
				name: "operations2",
				type: "ENUM",
				data: [
					"Up", "Down", "Left", "Right", "Space", "Return", "Shift", "Tab", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
					"P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
				],
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
	public static var getObjectNode:TNode = {
		id: 0,
		name: "Get Object",
		type: "GetObjectNode",
		x: 200,
		y: 200,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "In",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Selected Object",
				type: "OBJECT",
				color: 0xffaa4444,
				default_value: ""
			}
		],
		buttons: [
			{
				name: "objectList",
				type: "ENUM",
				data: [""],
				output: 0,
				default_value: 0
			}
		],
		color: -4962746
	};
}
