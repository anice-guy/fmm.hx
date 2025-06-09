package;

import flixel.util.FlxSignal;

/*
* gracias por todo https://github.com/FunkinCrew/Funkin/blob/v0.2.7.1/source/MusicBeatState.hx
* y https://github.com/FunkinCrew/Funkin/blob/v0.2.7.1/source/Conductor.hx
*/

class FunkyBeat {
    public var bpm(set, never):Int = 100;
    public var crochet:Float = ((60 / bpm) * 1000);
    public var stepCrochet:Float = crochet / 4;
    public var songPos:Float;

	public var onBeatHit:FlxSignal = new FlxSignal();
	public var onStepHit:FlxSignal = new FlxSignal();
	public var onSectionHit:FlxSignal = new FlxSignal();

    function set_bpm(newBpm:Int) {
        bpm = newBpm;
		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
    }

    public function update(pos:Float) {
		var oldStep:Int = curStep;
		songPos = pos;

		updateCurStep(pos);
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			_onStep();

	}

	private function updateBeat():Void
		curBeat = Math.floor(curStep / 4);

	private function updateCurStep(pos:Float):Void
		curStep = Math.floor(pos / stepCrochet);

	private function _onStep():Void {
		onStepHit.dispatch();
		if (curStep % 4 == 0) _onBeat();
	}

	private function _onBeat():Void {
		onBeatHit.dispatch();
        if (curBeat % 4 == 0) _onSection();
	}

    private function _onSection():Void
		onSectionHit.dispatch();

}