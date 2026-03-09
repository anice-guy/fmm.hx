package states;

import openfl.Assets;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

class TitleState extends BeatAwareState {
    public var logo:FlxSprite;
    public var scroll:FlxBackdrop;
    public var funny:FlxText;
    public var soundie:FlxSound;

    override public function create() {
        super.create();

        soundie = FlxG.sound.load(FilePaths.getSound('intro-sound'));

        var gridSize:Int = 128;
        scroll = new FlxBackdrop(FlxGridOverlay.createGrid(gridSize, gridSize, gridSize*2, gridSize*2, true, FlxColor.TRANSPARENT, 0x2AFFFFFF));
        scroll.velocity.set(30, 15);
        scroll.alpha = 0;
        add(scroll);

        logo = new FlxSprite().loadGraphic(FilePaths.getImage('yo'));
        logo.scale.set(4, 4);
        logo.updateHitbox();
        logo.screenCenter();
        logo.visible = false;
        add(logo);

        funny = new FlxText(0, 0, FlxG.width * 0.9);
        funny.setFormat(FilePaths.getFont('WenKai-Regular'), 62, FlxColor.GRAY, CENTER, OUTLINE, FlxColor.BLACK);
        funny.borderSize = 2;
        funny.text = getRandomLine();
        funny.y = FlxG.height * 0.8;
        funny.screenCenter(X);
        funny.alpha = 0;
        add(funny);

        // this looks ugly but it works lmao
        FlxTween.tween(scroll, {alpha: 1}, 0.5, {startDelay: 0.5, onComplete: (_)->{
            logo.visible = true;
            soundie.play();
            new FlxTimer().start(1, (_)->{
                FlxTween.tween(funny, {alpha: 1, y: funny.y + 20}, 0.4, {ease: FlxEase.cubeOut});
            });

            new FlxTimer().start(3, (_)->{
                FlxTween.tween(scroll, {alpha: 0}, 1);
                FlxTween.tween(funny, {alpha: 0}, 1);
                FlxTween.tween(logo, {alpha: 0}, 1, {onComplete: (_)->{
                    FlxG.switchState(states.menus.MenuState.new);
                }});
            });
        }});
    }

    private function getRandomLine() {
        var contents:String = Assets.getText(FilePaths.buildPath('data/title-texts.txt'));
        var textArray:Array<String> = contents.split('\n');
        return textArray[FlxG.random.int(0, textArray.length-1)];
    }
    
    override public function update(elapsed) {
        super.update(elapsed);
    }
}