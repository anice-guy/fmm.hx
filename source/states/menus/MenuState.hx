package states.menus;

import flixel.group.FlxGroup;

class MenuState extends BeatAwareState {
    static public var entries:Array<String> = [
        'play',
        'options',
        'about',
        'quit'
    ];

    public var menuOptions:FlxTypedGroup<FlxText>;
    public var selectionIndex:Int = 0;
    public var madeSelection:Bool = false;
    public var cursor:FlxText;
    public var cursorTween:FlxTween;

    override function create() {
        super.create();

        var bg:FlxSprite = new FlxSprite(0, 0, FilePaths.getImage('menuBackground'));
        bg.setGraphicSize(FlxG.width);
        bg.color = FlxColor.ORANGE;
        add(bg);

        menuOptions = new FlxTypedGroup<FlxText>();
        add(menuOptions);

        for (i => option in entries) {
            var opt:FlxText = new FlxText();
            opt.text = option;
            opt.setFormat(FilePaths.getFont('WenKai-Regular'), 62, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            opt.borderSize = 2;
            opt.y = 600 + ((opt.height + 15) * i);
            opt.x = (FlxG.width - opt.width) - 30;
            opt.ID = i;
            menuOptions.add(opt);
        }

        cursor = new FlxText();
        cursor.text = '> ';
        cursor.setFormat(FilePaths.getFont('WenKai-Regular'), 62, FlxColor.YELLOW, LEFT, OUTLINE, FlxColor.BLACK);
        cursor.borderSize = 2;
        cursor.x = (menuOptions.members[selectionIndex].x - cursor.width);
        cursor.y -= cursor.height;
        add(cursor);

        selectItem();

        var black:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
        black.scale.set(FlxG.width, FlxG.height);
        black.updateHitbox();
        add(black);

        FlxTween.tween(black, {alpha: 0}, 1, {onComplete: (_)->{ black.destroy(); }});
    }

    override function beatHit(beat) {
        
    }

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
                trace('${entries[selectionIndex]}: menu aint done yet !');
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