package;

import flixel.util.FlxSort;
import flixel.math.FlxMath;
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
	var spriteMap:Map<Int, FunkySprite> = new Map<Int, FunkySprite>();
	var levelSong:FlxSound;
	var camFollow:FlxObject;

	var levelObjs:Array<Dynamic>;
	var levelCams:Array<Dynamic>;
	var levelChart:Dynamic;
	var levelEvents:Dynamic;
	var songNotes:Dynamic = [];
	var songEvents:Dynamic = [];

	override public function create() {
		super.create();
		FlxG.camera.bgColor = 0; //trans

		levelName = File.getContent('curLevel.txt');
		FunkyAssets.loadLevelData(levelName);

		var _scene = FunkyAssets.sceneData;
		levelChart = FunkyAssets.chartData;
		levelEvents = FunkyAssets.eventData;
		levelObjs = _scene.objects;
		levelCams = _scene.cameras;

		levelSong = new FlxSound();
		levelSong.loadEmbedded(FunkyAssets.lvlMusic);
		FlxG.sound.list.add(levelSong);

		FunkyBeat.init(levelChart.bpm);
		FunkyBeat.onSectionHit.add(onSectionHit);

		var increment:Int = 0;
		for (sprite in levelObjs) {
			var fsprite:FunkySprite = new FunkySprite(sprite.spr, sprite.x, sprite.y, sprite.scale.x, levelChart.bpm);
			fsprite.visible = sprite.visible;
			fsprite.type = sprite.type;
			fsprite.playAnim(0);
			spriteMap.set(increment, fsprite);
			add(fsprite);
			increment++;
			trace('[STAGE] added sprite "${sprite.spr}" (x: ${sprite.x}, y: ${sprite.y}, type: ${sprite.type})');
		}

		for (dir in 0...4)
			for (note in 0...Std.int(levelChart.notes[dir].length))
				reparseNote(levelChart.notes[dir][note].start, dir, false);

		for (dir in 4...8)
			for (note in 0...Std.int(levelChart.notes[dir].length))
				reparseNote(levelChart.notes[dir][note].start, dir-4, true);

		songNotes.sort(function(p1, p2) {
			return FlxSort.byValues(FlxSort.ASCENDING, p1.strumTime, p2.strumTime);
		});

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		FlxG.camera.follow(camFollow, LOCKON, 0.1);
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		var idx:Int = levelCams[1] != null ? 1 : 0;
		camFollow.setPosition(levelCams[idx].x, levelCams[idx].y);
		FlxG.camera.snapToTarget();
		FlxG.camera.zoom = curZoom = 1 / Math.max(0, levelCams[idx].scale);


		if (songNotes.length < 1) noteCheck();
	}

	private function reparseNote(time:Float, id:Int, ms:Bool) {
		var parsed = {
			strumTime: time * 1000,
			id: id,
			mustHit: ms
		};
		songNotes.push(parsed);
	}


	public function onSectionHit() {
		FlxG.camera.zoom += 0.02;
	}

	function playAnimType(type, anim) {
		for (sprite in spriteMap) {
			if (sprite.type == type)
				sprite.playAnim(anim);
		}
	}

	private function noteHit(note)
		playAnimType(1,note.id+1); 

	private function oppHit(note)
		playAnimType(2,note.id+1); 

	private function noteCheck() {
		while(songNotes.length > 0) {
			var leStrumTime:Float = songNotes[0].strumTime;
			if(FunkyBeat.songPos < leStrumTime) 
				return;

			if (songNotes[0].mustHit)
					noteHit(songNotes[0]);
				else
					oppHit(songNotes[0]);
			songNotes.shift();
		}
	}

	private function eventCheck() {
		while(levelEvents.length > 0) {
			var leStrumTime:Float = levelEvents[0].time * 1000;
			if(FunkyBeat.songPos < leStrumTime) 
				return;

			executeEvent(levelEvents[0].type, levelEvents[0].args);
			levelEvents.shift();
		}
	}

	private function executeEvent(type:String, args:Array<String>) {
		trace('executing event ${type} ${args}');
		switch (type) {
			case 'flash':
				FlxG.camera.flash(0x80FFFFFF, FunkyBeat.crochet/1000, null, true);
			case 'shake':
				FlxG.camera.shake(0.003, FunkyBeat.crochet/1000, null, true);
			case 'camera':
				switch (args[0]) {
					case 'auto':
						//none yet
					case 'left':
						camFollow.setPosition(levelCams[0].x, levelCams[0].y);
						curZoom = 1 / Math.max(0, levelCams[0].scale);
					case 'right':
						camFollow.setPosition(levelCams[1].x, levelCams[1].y);
						curZoom = 1 / Math.max(0, levelCams[1].scale);
					default:
						camFollow.setPosition(levelCams[Std.parseInt(args[0])].x, levelCams[Std.parseInt(args[0])].y);
						curZoom = 1 / Math.max(0, levelCams[Std.parseInt(args[0])].scale);
				}

			case 'changesprite':
				var json = FunkyAssets.levelJson('sprites/${args[1]}/sprite');
				var id:Int = Std.parseInt(args[0]);
				if (spriteMap.exists(id)) spriteMap.get(id).changeSprite(json, args[1], levelChart.bpm);
				else trace('sprite $id doesnt exist wtffff');

			case 'changetype':
				var id:Int = Std.parseInt(args[0]);
				if (spriteMap.exists(id)) spriteMap.get(id).type = Std.parseInt(args[1]);
				else trace('sprite $id doesnt exist wtffff');

			case 'changeanim':
				var id:Int = Std.parseInt(args[0]);
				if (spriteMap.exists(id)) spriteMap.get(id).playAnim(Std.parseInt(args[1]));
				else trace('sprite $id doesnt exist wtffff');

			case 'visible':
				var id:Int = Std.parseInt(args[0]);
				if (spriteMap.exists(id)) {
					spriteMap.get(id).visible = (args[1] == 'yes');
					trace(args[1] == 'yes');
				} else trace('sprite $id doesnt exist wtffff');

			default:
				trace('unimplemented event $type');
		}
	}

	var cam:Int = 0;
	var curZoom:Float = 1;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, curZoom, 0.1);
		//trace(curZoom);
		if (FlxG.sound.music != null)
			FunkyBeat.update(FlxG.sound.music.time);

		noteCheck();
		eventCheck();

		//EVERYTHING BELOW THIS LINE IS JUST FOR TESTING PURPOSES

		if (FlxG.keys.justPressed.SPACE)
			@:privateAccess
			FlxG.sound.playMusic(levelSong._sound);
	}
}
