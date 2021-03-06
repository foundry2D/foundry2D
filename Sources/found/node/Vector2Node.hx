package found.node;

class Vector2Node extends LogicNode {
	var value = new kha.math.FastVector2();

	public function new(tree:LogicTree, x:Null<Float> = null, y:Null<Float> = null) {
		super(tree);
	}

	override function get(from:Int):Dynamic {
		if(inputs[0] != null && inputs[1] != null){
			value.x = inputs[0].get();
			value.y = inputs[1].get();

			if (from == 0) {
				return value;
			}

			return value.normalized();
		}
		else {
			return null;
		}
		
	}

	override function set(value:Dynamic) {
		inputs[0].set(value.x);
		inputs[1].set(value.y);
	}
}
