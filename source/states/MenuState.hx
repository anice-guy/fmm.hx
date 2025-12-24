package states;

import flixel.text.FlxInputText;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.FlxState;

class MenuState extends FlxState {
    var menuOptions:Array<String> = [
        'load level',
        'options',
        'quit'
    ];

    var menuButtons:Array<FlxButton>;

    var levelInput:FlxInputText;

    override function create() {
        super();
        for (opt => i in menuOptions) {
            var button:FlxButton = new FlxButton(20, 30 + (10 * i), opt);
            button.scale.set(2, 2);
            button.updateHitbox();
            
            switch(opt) {
                case 'load level':

                case 'options':
                    // FlxG.switchState(OptionsState);

                case 'quit':
                    button.onUp.callback = function() {
                        var fade:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height);
                        fade.alpha = 0.001;
                        add(fade);
                        FlxTween.tween(fade, {alpha: 1}, 1, {onComplete: (_)->{Sys.exit(0);}});
                        trace('see you next time :)');
                    };
            }

            menuButtons.push(button);
            add(button);
        }
    }
}