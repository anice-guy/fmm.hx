package backend;

class BeatAwareState extends FlxState {
    public var curStep(get, null):Int;
    public var curBeat(get, null):Int;
    public var curStepFloat:Float;
    public var curBeatFloat:Float;
    public var stepCrochet(get, never):Float;
    public var crochet(get, never):Float;

    public function get_stepCrochet() 
        return Conductor.stepCrochet;

    public function get_crochet() 
        return Conductor.crochet;

    public function get_curStep()
        return Math.floor(curStepFloat);

    public function get_curBeat()
        return Math.floor(curBeatFloat);

    override public function create() {
        super.create();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.sound.music != null) 
            Conductor.songPosition = FlxG.sound.music.time;

        var oldStep:Int = curStep;
        var oldBeat:Int = curBeat;

        curStepFloat = Conductor.songPosition / stepCrochet;

        if (oldStep != curStep && curStep > 0)
            stepHit(curStep);

        curBeatFloat = curStepFloat / 4;

        if (oldBeat != curBeat && curBeat > 0)
            beatHit(curBeat);
    }

    // to be overriden on states
    function stepHit(step:Int) {}
    function beatHit(beat:Int) {}
}