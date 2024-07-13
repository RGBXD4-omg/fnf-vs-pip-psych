package;

import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import sys.FileSystem;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
#if VIDEOS_ALLOWED
import VideoHandler;
#end

class StartupState extends FlxState
{
    public var camHUD:FlxCamera;
    var bg:FlxSprite;
	var skipText:FlxText;
	public var inCutscene:Bool = false;

    override public function create():Void
    {	
	    Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.add(camHUD);

	    super.create();
    }


   public function startVideo(name:String)
    {
		#if VIDEOS_ALLOWED
		inCutscene = true;

		var filepath:String = Paths.video(name);
		#if sys
		if (!FileSystem.exists(filepath))
		#else
		if (!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
			return;
		}

		var video:VideoHandler = new VideoHandler();
		video.playVideo(filepath);
		video.finishCallback = function()
		{
			FlxG.switchState(new TitleState());
			return;
		}
			
                var skipText = new FlxText(0, 0, FlxG.width, "PRESS SPACE OR BACK TO SKIP", 20);
                skipText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                skipText.scrollFactor.set();
                skipText.borderSize = 1.25;
                skipText.y = FlxG.height * 0.89 + 36;
                skipText.visible = false;
	        add(skipText);
	    
		#else
		FlxG.log.warn('Platform not supported!');
		FlxG.switchState(new TitleState());
		return;
		#end
     }
	
     override public function update():Void
     {
		startVideo('Newgrounds');
	     
	     super.update();
     }


}
