package;

import flixel.FlxCamera;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import flixel.FlxSprite;
import fmm.systems.FunkyAssets;

class FunkySprite extends FlxSprite {
	var _scaledFrameOffset:FlxPoint;
    public var frameOffset(default, null):FlxPoint;

    var animOffsets:Array<Array<Float>>;
    var animScales:Array<Null<Float>>;
    var animData:Array<Dynamic>;

    var name:String;
    public var type:Int;
    var baseScale:Float;

    public function new(name:String, x:Float = 0, y:Float = 0, scale:Float = 1, ?bpm:Int = 100) {
        super(x, y);
        animOffsets = new Array<Array<Float>>();
        animScales = new Array<Null<Float>>();
        this.name = name;
        this.baseScale = scale;

        var json = FunkyAssets.levelJson('sprites/$name/sprite');
        changeSprite(json, name, bpm);
    }

    private var _frameCount:Map<Int, Int> = new Map<Int, Int>();
    public function changeSprite(json:Dynamic, name:String, ?bpm:Int = 100) {
        animOffsets = [];
        animScales = [];

        scale.set(1, 1);
        updateHitbox();

        animData = json.data;
        if(animData != null && animData.length > 0) {
            var _frames = FunkyAssets.spritesheet('$name/0', '0', Std.int(animData[0].num), true);
            for (i=>anim in animData) {
                if (i > 0) {
                    var original:FunkyFrames = _frames;
                    _frames = new FunkyFrames(_frames.parent);
                    _frames.addAtlas(original, true);
                    var extraFrames:FunkyFrames = FunkyAssets.spritesheet('$name/$i', Std.string(i), Std.int(anim.num), true);
                    if(extraFrames != null)
                        _frames.addAtlas(extraFrames, true);
                }
                _frameCount.set(i, Std.int(anim.num));
            }
            frames = _frames;
            for (i=>anim in animData) {
                var animName = Std.string(i);
                var fps:Float = 24;
                addOffset(anim.offset.x, anim.offset.y);
                addScale(anim.scale);

                if (anim.spd_fps) fps = anim.spd;
                else fps = (_frameCount.get(i) * bpm / 60) / anim.spd;
                animation.addByPrefix(animName, animName, fps, anim.loop);
            }
        }
    }

    public function playAnim(anim:Int, force:Bool = true, reversed:Bool = false, frame:Int = 0) {
        animation.play(Std.string(anim), force, reversed, frame);

        if (animOffsets[anim] != null)
            frameOffset.set(animOffsets[anim][0], animOffsets[anim][1]);

        if (!Math.isNaN(animScales[anim]))
            scale.set(animScales[anim] * baseScale, animScales[anim] * baseScale);

        updateHitbox();

        //trace('[SPRITE] [\"$name\"] playing anim $anim | scale: ${scale.toString()}| offset: ${offset.toString()}');
    }

    public function addOffset(x:Float = 0, y:Float = 0)
		animOffsets.push([x, y]);

    public function addScale(s:Float = 0)
		animScales.push(s);

    override function initVars() {
        super.initVars();

        frameOffset = FlxPoint.get();
        _scaledFrameOffset = new FlxPoint();
    }

    override function destroy() {
        super.destroy();
        frameOffset = FlxDestroyUtil.put(frameOffset);
        _scaledFrameOffset = FlxDestroyUtil.put(_scaledFrameOffset);
    }

    override function drawFrameComplex(frame:FlxFrame, camera:FlxCamera):Void {
		final matrix = this._matrix;
		frame.prepareMatrix(matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
		matrix.translate(-origin.x, -origin.y);

        // muchisimas gracias
        // https://github.com/CodenameCrew/cne-flixel/blob/38c0f548e678714b2885f710c2b4454fa2ce7058/flixel/FlxSprite.hx#L932
        matrix.translate(-frameOffset.x, -frameOffset.y);

		matrix.scale(scale.x, scale.y);
		
		if (bakedRotationAngle <= 0) {
			updateTrig();
			
			if (angle != 0)
				matrix.rotateWithTrig(_cosAngle, _sinAngle);
		}
		
		getScreenPosition(_point, camera).subtract(offset);
		_point.add(origin.x, origin.y);
		matrix.translate(_point.x, _point.y);
		
		if (isPixelPerfectRender(camera)) {
			matrix.tx = Math.floor(matrix.tx);
			matrix.ty = Math.floor(matrix.ty);
		}
		
		camera.drawPixels(frame, framePixels, matrix, colorTransform, blend, antialiasing, shader);
	}

    override function getScreenBounds(?newRect:FlxRect, ?camera:FlxCamera) {
		if (newRect == null)
			newRect = FlxRect.get();
		
		if (camera == null)
			camera = getDefaultCamera();
		
		newRect.setPosition(x, y);
		if (pixelPerfectPosition)
			newRect.floor();
		_scaledOrigin.set(origin.x * scale.x, origin.y * scale.y);
        _scaledFrameOffset.set(frameOffset.x * scale.x, frameOffset.y * scale.y);
		newRect.x += -Std.int(camera.scroll.x * scrollFactor.x) - offset.x + origin.x - _scaledOrigin.x;
		newRect.y += -Std.int(camera.scroll.y * scrollFactor.y) - offset.y + origin.y - _scaledOrigin.y;
		if (isPixelPerfectRender(camera))
			newRect.floor();
		newRect.setSize(frameWidth * Math.abs(scale.x), frameHeight * Math.abs(scale.y));
		return newRect.getRotatedBounds(angle, _scaledOrigin, newRect, _scaledFrameOffset);
	}
}