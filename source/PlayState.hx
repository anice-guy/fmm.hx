package;

import sys.io.File;
import flixel.sound.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import FunkyAssets;
import FunkySprite;
import tjson.TJSON as Json;

class PlayState extends FlxState {
	public static var levelName:String;
	var stageSprites:Map<String, FunkySprite> = new Map<String, FunkySprite>();
	var logo:FlxSprite;
	var musi:FlxSound;

	var funki:FunkySprite;

	var testAnims:Array<String> = ['idle', 'left', 'down', 'up', 'right'];

	override public function create() {
		super.create();
		levelName = File.getContent('curLevel.txt');
		musi = new FlxSound();
		musi.loadEmbedded(FunkyAssets.levelSong(levelName));
		FlxG.sound.list.add(musi);

		funki = new FunkySprite('btboxbf');
		//funki.animation.play('0');
		//add(funki);

		logo = new FlxSprite(FunkyAssets.image('playerLogo'));
		logo.angle = -5;
		FlxTween.tween(logo, {angle: 5}, 3, {type: PINGPONG, ease: FlxEase.quadInOut});
		add(logo);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.justPressed.SPACE)
			@:privateAccess
			FlxG.sound.playMusic(musi._sound);
	}
}
