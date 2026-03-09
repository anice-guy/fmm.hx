package states;

class PlayState extends BeatAwareState {
	override public function create() {
		super.create();

		var uhm:FlxText = new FlxText();
		uhm.text = 'theres nothing here,,, yet!!';
		uhm.screenCenter();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
