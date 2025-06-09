package;

import haxe.Json;
import sys.io.File;
import flash.media.Sound;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;
import openfl.display.BitmapData;
import sys.FileSystem;

using StringTools;

class FunkyAssets {
    var sprites:Map<String, FlxGraphic>;
    var chartData:Dynamic;
    var sceneData:Dynamic;
    var eventData:Dynamic;
    var music:Sound;
    var level:String;

    public static function loadLevel(lvl:String):Void {
        chartData = levelJson('data');
        level = lvl;
    }

    public static function getPath(file:String = ''):String {
        var request:String = 'assets/';
        request = 'assets/$file';
        trace('[ASSETS] loading: $request');
        return request;
    }

    //welcome to level district
    public static function buildLevelPath(key:String, level:String) {
        return 'levels/$level/$key';
    }

    public static function levelImage(key:String, level:String):FlxGraphic
        return returnImage(key, true, level);

    public static function levelSpriteJson(key:String, level:String):String
        return buildLevelPath('sprites/$key/sprite.json', level);

    public static function levelJson(key:String, level:String):Dynamic {
        var raw:String = File.getContent(buildLevelPath('$key.json', level));
        return Json.parse(raw);
    }

    //next stop is boring built-in assets
    public static function file(file:String):String
        return getPath(file);

    public static function sound(key:String):Sound
        return returnSound('sounds/$key');

    public static function music(key:String):Sound
        return returnSound('music/$key');

    public static function image(key:String):FlxGraphic
        return returnImage('images/$key');

    static public function spritesheet(key:String, anim:String, div:Int, fromLevel:Bool = false, ?level:String = ''):FunkyFrames {
		var imageLoaded:FlxGraphic = null;
        if (fromLevel) imageLoaded = levelImage(key, level);
        else image(key);

		return FunkyFrames.fromStrip(anim, imageLoaded, div);
    }

    public static function returnSound(key:String, fromLevel:Bool = false, ?level:String = '', ?beepOnNull:Bool = true) {
        var file:String;
        if(fromLevel) file = buildLevelPath('$key.ogg', level); 
        else file = getPath('$key.ogg');
        
        var snd:Sound = null;
        if(FileSystem.exists(file))
            snd = Sound.fromFile(file);
        else if(beepOnNull) {
            trace('[ASSETS] SOUND NOT FOUND: $key');
            return FlxAssets.getSound('flixel/sounds/beep');
        }

        return snd;
    }

    public static function returnImage(key:String, fromLevel:Bool = false, ?level:String = ''):FlxGraphic {
        var bitmap:BitmapData = null;
        var file:String;
        if(fromLevel) file = buildLevelPath('sprites/$key.png', level); 
        else file = getPath('$key.png');
        
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