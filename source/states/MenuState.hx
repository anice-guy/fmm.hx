package states;

import flixel.group.FlxGroup;

class MenuState extends FlxState {
    var entries:Array<String> = [
        'play',
        'options',
        'about',
        'quit'
    ];

    var menuOptions:FlxTypedGroup<FlxText>;
    var selectionIndex:Int = 0;
    var madeSelection:Bool = false;

    var cursor:FlxText;

    var bg:FlxSprite;

    override function create() {
        super.create();

        bg = new FlxSprite(0, 0, FilePaths.engineImage('menuBackground'));
        bg.setGraphicSize(FlxG.width);
        bg.color = FlxColor.ORANGE;
        add(bg);

        menuOptions = new FlxTypedGroup<FlxText>();
        add(menuOptions);

        for (i => option in entries) {
            var opt:FlxText = new FlxText();
            opt.text = option;
            opt.setFormat(FilePaths.engineFont('WenKai-Regular'), 62, FlxColor.WHITE, LEFT);
            opt.y = 600 + ((opt.height + 15) * i);
            opt.x = (FlxG.width - opt.width) - 30;
            opt.ID = i;
            menuOptions.add(opt);
        }

        cursor = new FlxText();
        cursor.text = '> ';
        cursor.setFormat(FilePaths.engineFont('WenKai-Regular'), 62, FlxColor.YELLOW, LEFT);
        cursor.x = (menuOptions.members[selectionIndex].x - cursor.width);
        cursor.y -= cursor.height;
        add(cursor);

        selectItem();
    }

    var cursorTween:FlxTween;
    function selectItem(change:Int = 0) {
        selectionIndex = FlxMath.wrap(selectionIndex + change, 0, entries.length-1);
        var curText:FlxText = menuOptions.members[selectionIndex];

        menuOptions.forEach((item:FlxText)->{
            item.color = item.ID == selectionIndex ? FlxColor.YELLOW : FlxColor.WHITE;
        });

        if (cursorTween != null) cursorTween.cancel();
        cursorTween = FlxTween.tween(cursor, {x: (curText.x - cursor.width), y: curText.y}, 0.3,
        {ease: FlxEase.circOut, onComplete: function(_) { cursorTween = null; }});
    }

    function acceptSelection(selSumthin:Bool) {
        madeSelection = true;

        switch(entries[selectionIndex]) {
            case 'quit':
                if (selSumthin){
                    FlxG.camera.shake(5 / FlxG.camera.width, 0.2);
                    @:privateAccess { // this sucks Idc
                        FlxG.camera._fxFadeDuration = 0;
                        FlxTween.tween(FlxG.camera, {_fxFadeAlpha: 0}, 0.4, {ease: FlxEase.circIn});   
                    }
                    madeSelection = false;
                } else
                    FlxG.camera.fade(FlxColor.BLACK, 0.7, false, function() { Sys.exit(0);});

            default:
                madeSelection = false;
                trace('Function unimplemented lol sorry');
        }
    }


    override function update(elapsed) {
        super.update(elapsed);

        var upJustPressed = FlxG.keys.justPressed.UP;
        var downJustPressed = FlxG.keys.justPressed.DOWN;


        if ((upJustPressed || downJustPressed || FlxG.mouse.wheel != 0) && !madeSelection)
            selectItem((upJustPressed ? -1 : 0) + (downJustPressed ? 1 : 0) - FlxG.mouse.wheel);

        if (FlxG.keys.justPressed.ENTER) acceptSelection(madeSelection);
    }
}