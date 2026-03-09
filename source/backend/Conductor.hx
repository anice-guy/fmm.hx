package backend;

class Conductor {
    public static var songPosition:Float;
    public static var bpm(default, set):Float = 100;
    public static var crochet:Float = ((60 / bpm) * 1000);
    public static var stepCrochet:Float = crochet / 4;

    static function set_bpm(newBpm:Float) {
        bpm = newBpm;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
        return bpm;
    }

    public function new() {}
}