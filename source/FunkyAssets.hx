package;

import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flash.media.Sound;
import flixel.system.FlxAssets;
import flixel.FlxG;
import sys.FileSystem;

using StringTools;

class FunkyAssets {
    public static function getPath(file:String):String {
        var request:String = '';
        request = assets(file);
        trace('[ASSETS] requested file: $request');
        return request;
    }

    inline static function assets(path:String):String
        return 'assets/$path';

    //welcome to level district
    inline static public function levels(key:String = '')
        return 'levels/$key';

    public static function levelFolders(key:String, level:String) {
        var fileToCheck = levels('$level/$key');
        trace('[ASSETS] requested file: $fileToCheck');
        //if(FileSystem.exists(fileToCheck))
            return fileToCheck; //i hate haxe with all my soul
    }

    public static function levelSong(level:String):Sound 
        return returnSound('music', true, level);

    public static function levelImage(key:String, level:String):FlxGraphic
        return returnImage(key, true, level);

    public static function levelSpriteJson(key:String, level:String):String
        return levelFolders('sprites/$key/sprite.json', level);

    public static function levelJson(key:String, level:String):String
        return levelFolders('$key.json', level);

    //next stop is boring built-in assets
    public static function file(file:String):String
        return getPath(file);

    public static function sound(key:String):Sound
        return returnSound('sounds/$key');

    public static function music(key:String):Sound
        return returnSound('music/$key');

    public static function image(key:String):FlxGraphic
        return returnImage('images/$key');

    static public function multiSpritesheet(keys:Array<String>, anims:Array<String>, divs:Array<Int>, fromLevel:Bool = false, ?level:String = ''):FunkyFrames {
		var parentFrames:FunkyFrames = FunkyAssets.spritesheet(keys[0].trim(), anims[0].trim(), divs[0], fromLevel, level);
		if(keys.length > 1) {
			var original:FunkyFrames = parentFrames;
			parentFrames = new FunkyFrames(parentFrames.parent);
			parentFrames.addAtlas(original, true);
			for (i in 1...keys.length)
			{
				var extraFrames:FunkyFrames = FunkyAssets.spritesheet(keys[i].trim(), anims[i].trim(), divs[i], fromLevel, level);
				if(extraFrames != null)
					parentFrames.addAtlas(extraFrames, true);
			}
		}
		return parentFrames;
	}

    static public function spritesheet(key:String, anim:String, div:Int, fromLevel:Bool = false, ?level:String = ''):FunkyFrames {
		var imageLoaded:FlxGraphic = null;
        if (fromLevel)
            imageLoaded = levelImage(key, level);
        else
            image(key);


		return FunkyFrames.fromStrip(anim, imageLoaded, div);
    }

    public static function returnSound(key:String, fromLevel:Bool = false, ?level:String = '', ?beepOnNull:Bool = true) {
        //made it an if statement for logging purposes
        var file:String;
        if(fromLevel)
            file = levelFolders('$key.ogg', level); 
        else
            file = getPath('$key.ogg');
        var snd:Sound = null;
        if(FileSystem.exists(file))
            snd = Sound.fromFile(file);
        else if(beepOnNull) {
            trace('[ASSETS] SOUND NOT FOUND: $key');
            FlxG.log.error('[ASSETS] SOUND NOT FOUND: $key');
            return FlxAssets.getSound('flixel/sounds/beep');
        }

        return snd;
    }

    public static function returnImage(key:String, fromLevel:Bool = false, ?level:String = ''):FlxGraphic {
        var bitmap:BitmapData = null;
        //made it an if statement for logging purposes
        var file:String;
        if(fromLevel)
            file = levelFolders('sprites/$key.png', level); 
        else
            file = getPath('$key.png');
        
        if (FileSystem.exists(file))
            bitmap = BitmapData.fromFile(file);

        if (bitmap == null) {
            trace('[ASSETS] Bitmap not found: $file | key: $key');
            return null;
        }

        var graph:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, key);
		graph.persist = true;
		graph.destroyOnNoUse = false;

		return graph;
    }
}