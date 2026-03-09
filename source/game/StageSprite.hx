package game;

typedef Point = {
    var x:Float;
    var y:Float;
}

typedef SpriteAnim = {
    var bilinear:Bool;
    var scale:Float;
    var offset:Point;
    var num:Float;
    var spd:Float;
    var spd_fps:Bool;
    var loop:Bool;
}

typedef SpriteData = {
    var data:Array<SpriteAnim>;
    var type:Float;
}

class StageSprite extend FlxSprite {
    public function new(sprite:String, x:Float, y:Float) {
        super(x, y);
    }
}