package fmm.systems;

import haxe.Json;
import sys.io.File;
import openfl.media.Sound;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;
import openfl.display.BitmapData;
import sys.FileSystem;
import fmm.systems.FunkyTypes;

using StringTools;



class FunkyAssets {
    //public static var sprites:Map<String, FlxGraphic>;

    public static var levelData:LevelData;

    public static function loadLevelData(lvl:String):Void {
        levelData.name = lvl;
        levelData.chart = levelJson('data');
        levelData.scene = levelJson('scene');
        if (FileSystem.exists(getPath('evt.json', true)))
            levelData.events = levelJson('evt');

        levelData.music = returnSound('music', true);
    }

    public static function getPath(key:String = '', ?isLvl:Bool = false):String {
        if (isLvl) 
            return 'levels/$level/$key';

        return 'assets/$key';
    }

    public static function levelImage(key:String):FlxGraphic
        return returnImage('sprites/$key', true);

    public static function levelJson(key:String):Dynamic {
        var raw:String = File.getContent(getPath('$key.json', true));
        return Json.parse(raw);
    }

    public static function file(file:String):String
        return getPath(file);

    static public function spritesheet(key:String, anim:String, div:Int, fromLevel:Bool = false):FunkyFrames {
		var imageLoaded:FlxGraphic = null;
        if (fromLevel) imageLoaded = levelImage(key);
        else image(key);

		return FunkyFrames.fromStrip(anim, imageLoaded, div);
    }

    public static function returnSound(key:String, fromLevel:Bool = false, ?beepOnNull:Bool = true) {
        var file:String = getPath('$key.ogg', fromLevel); 
        
        var snd:Sound = null;
        if(FileSystem.exists(file))
            snd = Sound.fromFile(file);
        else if(beepOnNull) {
            trace('[ASSETS] SOUND NOT FOUND: $key');
            return FlxAssets.getSound('flixel/sounds/beep');
        }

        return snd;
    }

    public static function returnImage(key:String, fromLevel:Bool = false):FlxGraphic {
        var bitmap:BitmapData = null;
        var file:String = getPath('$key.png', fromLevel); 
        
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