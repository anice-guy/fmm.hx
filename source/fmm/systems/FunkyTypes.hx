package fmm.systems;

typedef LevelData {
    var name:String;
    var chart:Chart;
    var scene:Scene;
    var events;
    var music:FlxSound;
}

//chart

typedef NoteProps {
    var skin:Float;
    var onPressEvent:Float;
    var onMissEvent:Float; 
}

typedef Note {
    var props:NoteProps;
    var duration:Float;
    var start:Float;
}

typedef Chart {
    var npb:Float;
    var strumLines:Array<Array<Note>>;
    var bpm:Float;
    var version:Float;
}

// scene

typedef Point2D { var x:Float; var y:Float; }
typedef Camera { var x:Float; var y:Float; var scale:Float; }

typedef SceneObject {
    var x:Float;
    var y:Float;
    var strumLine:Float;
    var spr:String;
    var scale:Point2D;
    var fixed:Bool;
}

typedef Scene {
    var landscape:Bool;
    var objects:Array<SceneObject>;
    var icons:Array<String>;
    var cameras:Array<Camera>;
}

// sprite

typedef SpriteData {
    var bilinear:Bool;
    var scale:Float;
    var offset:Point2D;
    var num:Float;
    var spd:Float;
    var spd_fps:Bool;
    var loop:Bool;
}

typedef Sprite { var data:Array<SpriteData>; var type:Float; }