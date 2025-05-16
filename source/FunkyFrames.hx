package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

using StringTools;

// this class adds a single function to get frames from a strip spritesheet, in subdivisions

class FunkyFrames extends FlxFramesCollection {
    var usedGraphics:Array<FlxGraphic> = [];

    public function new(parent:FlxGraphic, ?border:FlxPoint)
        super(parent, FlxFrameCollectionType.TILES, border);

    public static function fromStrip(animName:String, source:FlxGraphicAsset, divisions:Int) {
        var increment:Int = 0;
        var graphic:FlxGraphic = FlxG.bitmap.add(source);
		if (graphic == null)
			return null;

        var frames:FunkyFrames = new FunkyFrames(graphic);

        for (i in 0...divisions) {
            var name:String = animName + Std.string(increment);
            var rect:FlxRect = FlxRect.get((graphic.width / divisions) * i, 0, graphic.width / divisions, graphic.height);
            var size:FlxRect = FlxRect.get(0, 0, rect.width, rect.height);
            var sourceSize = FlxPoint.get(size.width, size.height);
            trace('[FRAMES] added frame $animName$increment');
            increment++;

            frames.addAtlasFrame(rect, sourceSize, FlxPoint.get(0, 0), name, 0, false, false);
        }

        return frames;
    }

    public function addAtlas(collection:FunkyFrames, overwriteHash = false) {
		for (frame in collection.frames)
			pushFrame(frame, overwriteHash);
		
		if (!usedGraphics.contains(collection.parent)) {
			usedGraphics.push(collection.parent);
			collection.parent.incrementUseCount();
		}
		
		return this;
	}

    override function destroy()
	{
		while (usedGraphics.length > 0)
			usedGraphics.shift().decrementUseCount();
		
		super.destroy();
	}
}