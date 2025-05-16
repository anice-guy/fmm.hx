package;

import sys.io.File;
import flixel.FlxSprite;
import FunkyAssets;
import tjson.TJSON as Json;

enum FunkySpriteType {
    BACKGROUND;
    ITEM;
    CHARACTER;
    ICON;
}

typedef Scale = { var x:Float; var y:Float; }

typedef AnimArray = {
    var offset:Array<Array<Scale>>;
    var scale:Float;
    var loop:Bool;
    var num:Float;
    var spd:Float;
    var spd_fps:Bool;
}

class FunkySprite extends FlxSprite {
    var type:FunkySpriteType = FunkySpriteType.BACKGROUND;

    public function new(name:String, x:Float = 0, y:Float = 0) {
        super();

        var rawJson = File.getContent(FunkyAssets.levelSpriteJson(name, PlayState.levelName));
        changeSprite(Json.parse(rawJson));
    }

    public function changeSprite(json:Dynamic) {
        var animations:Array<AnimArray> = json.data;
        for (anim in animations) {
            trace(anim);
        }
        scale.set(1, 1);

        //frames = FunkyAssets.multiSpritesheet();
    }
}