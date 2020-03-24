package found.data;

import kha.math.Vector2;
import kha.math.Vector3;

import found.data.SceneFormat;

class Creator {
    public static function createType(name:String,type:String):Null<Any>{
        var data:Null<Any> = null;
        switch(type){
            case "object":
                data = {
                    name: name,
                    type: type,
                    position: new Vector2(),
                    rotation: new Vector3(),
                    width: 0.0,
                    height:0.0,
                    scale: new Vector2(1.0,1.0),
                    center: new Vector2(),
                    depth: 0.0,
                    active: true
                };
            case "sprite_object":
                var sprite:TSpriteData = createType(name,"object");
                sprite.width = 250.0;
                sprite.height = 250.0;
                sprite.imagePath = "basic";
                sprite.c_width = 0.0;
                sprite.c_height = 0.0;
                sprite.c_center = new Vector2();
                sprite.shape = "";
                sprite.anims = [];
                data = sprite;
            case "tilemap_object":
                var tilemap:TTilemapData = createType(name,"object");
                tilemap.width = 1280.0;
                tilemap.height = 960.0;
                tilemap.tileWidth = 64;
                tilemap.tileHeight = 64;
                tilemap.map = [];
                var tile:TTileData = createType("Tile","sprite_object");
                tile.width = 896.0;
                tile.height = 448.0;
                tile.tileWidth = 64;
                tile.tileHeight = 64;
                tile.imagePath = "tilesheet";
                tile.usedIds = [0];

                tilemap.images = [tile];

                data = tilemap;
        }
        Reflect.setField(data,"type",type);
        return data;
    }
}