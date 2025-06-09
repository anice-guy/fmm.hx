package;

import flixel.FlxObject;
import flixel.sound.FlxSound;
import flixel.FlxState;
import flixel.FlxG;
import sys.io.File;
import FunkyAssets;
import FunkyBeat;
import FunkySprite;
import haxe.Json;

class PlayState extends FlxState {
	public static var levelName:String;
	var spriteMap:Map<String, FunkySprite> = new Map<String, FunkySprite>();
	var levelSong:FlxSound;
	var camFollow:FlxObject;

	var levelObjs:Array<Dynamic>;
	var levelCams:Array<Dynamic>;

	override public function create() {
		super.create();

		levelName = File.getContent('curLevel.txt');

		var _scene = FunkyAssets.levelJson('scene', levelName);
		var chart = FunkyAssets.levelJson('data', levelName);
		levelObjs = _scene.objects;
		levelCams = _scene.cameras;

		levelSong = new FlxSound();
		levelSong.loadEmbedded(FunkyAssets.levelSong(levelName));
		FlxG.sound.list.add(levelSong);

		for (sprite in levelObjs) {
			var fsprite:FunkySprite = new FunkySprite(sprite.spr, sprite.x, sprite.y);
			fsprite.visible = sprite.visible;
			fsprite.playAnim(0);
			spriteMap.set(sprite.spr, fsprite);
			add(fsprite);
			trace('[STAGE] added sprite "${sprite.spr}" (x: ${sprite.x}, y: ${sprite.y})');
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		FlxG.camera.follow(camFollow);
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
		camFollow.setPosition(levelCams[0].x, levelCams[0].y);
	}

	var key:Int = 1;
	var cam:Int = 0;
	override public function update(elapsed:Float) {
		super.update(elapsed);
		
		/*var _scale:Float = 1;
		_scale = Math.max(FlxG.camera.viewHeight / 1080, FlxG.camera.viewWidth / 1920);
		FlxG.camera.zoom = _scale;*/

		if (FlxG.keys.justPressed.C) {
			if (cam == 0) cam = 1 else cam = 0;
			if (levelCams[cam] != null) camFollow.setPosition(levelCams[cam].x, levelCams[cam].y);
		}

		var testSprite = spriteMap.get('player');

		if (FlxG.keys.justPressed.SPACE)
			@:privateAccess
			FlxG.sound.playMusic(levelSong._sound);

		//testin
		//random anim
		if (FlxG.keys.justPressed.R) {
			key = FlxG.random.int(1,4, [key]);
			testSprite.playAnim(key);
		}
		//same anim
		if (FlxG.keys.justPressed.P)
			testSprite.playAnim(key);
		//idle
		if (FlxG.keys.justPressed.I)
			testSprite.playAnim(0);
		//miss
		if (FlxG.keys.justPressed.M)
			testSprite.playAnim(5);
	}
}
