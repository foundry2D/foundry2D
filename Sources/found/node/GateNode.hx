package found.node;

class GateNode extends LogicNode {

	public var operations: String;

	public function new(tree: LogicTree) {
		super(tree);
    }
    static var operationsNames:Array<String> = ["Or","And","Equal","Less", "Less Equal","Greater", "Greater Equal"];
    public static function getOperationsNames() {
        return operationsNames;
    }
    override function get(from:Int):Dynamic {
        var v1: Dynamic = inputs[0].get();
		var v2: Dynamic = inputs[1].get();
		var cond = false;

		switch (operations) {
            case "Equal":
                cond = v1 == v2;
            case "Greater":
                cond = v1 > v2;
            case "Greater Equal":
                cond = v1 >= v2;
            case "Less":
                cond = v1 < v2;
            case "Less Equal":
                cond = v1 <= v2;
            case "Or":
                for (i in 0...inputs.length) {
                    if (inputs[i].get()) {
                        cond = true;
                        break;
                    }
                }
            case "And":
                cond = true;
                for (i in 0...inputs.length) {
                    if (!inputs[i].get()) {
                        cond = false;
                        break;
                    }
                }
        }
        
        return cond;
    }
}