package;

import flixel.util.FlxSignal;

/*
* gracias por todo https://github.com/FunkinCrew/Funkin/blob/v0.2.7.1/source/MusicBeatState.hx
* y https://github.com/FunkinCrew/Funkin/blob/v0.2.7.1/source/Conductor.hx
*/

class FunkyBeat {
    public static var bpm:Int = 0;
    public static var crochet:Float = 0;
    public static var stepCrochet:Float = 0;
    public static var songPos:Float = -4000;

	public static var curStep:Int;
	public static var curBeat:Int;

	public static var onBeatHit:FlxSignal = new FlxSignal();
	public static var onStepHit:FlxSignal = new FlxSignal();
	public static var onSectionHit:FlxSignal = new FlxSignal();

    public static function init(newBpm:Int) {
        bpm = newBpm;
		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
		trace('[BPM] INIT bpm: $bpm | crochet: $crochet');
    }

    public static function update(pos:Float) {
		var oldStep:Int = curStep;
		songPos = pos;

		updateCurStep(pos);
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			_onStep();

	}

	private static function updateBeat():Void
		curBeat = Math.floor(curStep / 4);

	private static function updateCurStep(pos:Float):Void
		curStep = Math.floor(pos / stepCrochet);

	private static function _onStep():Void {
		onStepHit.dispatch();
		if (curStep % 4 == 0) _onBeat();
	}

	private static function _onBeat():Void {
		onBeatHit.dispatch();
        if (curBeat % 4 == 0) _onSection();
	}

    private static function _onSection():Void
		onSectionHit.dispatch();

}