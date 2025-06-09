package;

import sys.io.File;
import flixel.FlxSprite;
import FunkyAssets;
import haxe.Json;

class FunkySprite extends FlxSprite {
    var animOffsets:Array<Array<Float>>;
    var animScales:Array<Null<Float>>;
    var animData:Array<Dynamic>;

    var name:String;
    var baseScale:Float;

    public function new(name:String, x:Float = 0, y:Float = 0, scale:Float = 1) {
        super(x, y);
        animOffsets = new Array<Array<Float>>();
        animScales = new Array<Null<Float>>();
        this.name = name;
        this.baseScale = scale;

        var json = FunkyAssets.levelJson('sprites/$name/sprite', PlayState.levelName);
        changeSprite(json, name);
    }

    public function changeSprite(json:Dynamic, name:String) {
        animOffsets = [];
        animScales = [];

        scale.set(1, 1);
        updateHitbox();

        animData = json.data;
        if(animData != null && animData.length > 0) {
            var _frames = FunkyAssets.spritesheet('$name/0', '0', Std.int(animData[0].num), true, PlayState.levelName);
            for (i=>anim in animData) {
                if (i > 0) {
                    var original:FunkyFrames = _frames;
                    _frames = new FunkyFrames(_frames.parent);
                    _frames.addAtlas(original, true);
                    var extraFrames:FunkyFrames = FunkyAssets.spritesheet('$name/$i', Std.string(i), Std.int(anim.num), true, PlayState.levelName);
                    if(extraFrames != null)
                        _frames.addAtlas(extraFrames, true);
                }
            }
            frames = _frames;
            for (i=>anim in animData) {
                var animName = Std.string(i);
                var fps = 24;
                addOffset(anim.offset.x, anim.offset.y);
                addScale(anim.scale);

                if (anim.spd_fps)
                    fps = anim.spd;
                animation.addByPrefix(animName, animName, fps, anim.loop);
            }
        }
    }

    public function playAnim(anim:Int, force:Bool = true, reversed:Bool = false, frame:Int = 0) {
        animation.play(Std.string(anim), force, reversed, frame);
        //updateHitbox();

        if (animOffsets[anim] != null)
            offset.set(animOffsets[anim][0], animOffsets[anim][1]);

        if (!Math.isNaN(animScales[anim]))
            scale.set(animScales[anim] * baseScale, animScales[anim] * baseScale);

        //trace('[SPRITE] [\"$name\"] playing anim $anim | scale: ${scale.toString()}| offset: ${offset.toString()}');
    }

    public function addOffset(x:Float = 0, y:Float = 0)
		animOffsets.push([x, y]);

    public function addScale(s:Float = 0)
		animScales.push(s);
}