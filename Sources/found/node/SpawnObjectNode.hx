package found.node;

import found.object.Object;
import kha.math.FastVector2;

class SpawnObjectNode extends LogicNode {
	var selectedObjectToSpawn:Object;
	var spawnPosition:FastVector2 = new FastVector2();
	var spawnRotation:Float = 0;
	var spawnedObjects:Array<Object> = new Array<Object>();

	public function new(tree:LogicTree) {
		super(tree);

		tree.notifyOnRemove(function() {
			while (spawnedObjects.length > 0)
				found.State.active.remove(spawnedObjects.pop());
		});
	}

	override function run(from:Int) {
		spawnPosition = inputs[2].get();
		spawnRotation = inputs[3].get();

		if (inputs[1].node != null) {
			selectedObjectToSpawn = cast(inputs[1].get());
			found.State.active.spawn(selectedObjectToSpawn.raw,function(spawnedObject:Object){
				spawnedObjects.push(spawnedObject);

				spawnedObject.activate();
				spawnedObject.translate(moveObjectToSpawnPoint);
				spawnedObject.rotate(rotateObjectToSpawnRotation);
			});
		}
		#if debug
		else {
			error("Spawn Object node needs an object to spawn");
		}
		#end

		runOutput(0);//@TODO: Should we only call this when we actually spawn an object ?
	}

	function moveObjectToSpawnPoint(data:MoveData) {
		data._positions.x = spawnPosition.x - selectedObjectToSpawn.width * 0.5;
		data._positions.y = spawnPosition.y - selectedObjectToSpawn.height * 0.5;
		return data;
	}

	function rotateObjectToSpawnRotation(data:RotateData) {
		data._rotations.z = spawnRotation;
		return data;
	}
}
