package;

import flixel.FlxBasic;
import flixel.FlxG;
#if VIDEOS_ALLOWED
import VideoHandler;
#end

class FlxVideo extends FlxBasic
{
	public var finishCallback:Void->Void = null;

	public function new(path:String)
	{
		super();

		#if VIDEOS_ALLOWED
		var video:VideoHandler = new VideoHandler();
		video.canSkip = false;
		video.finishCallback = function()
		{
			if (finishCallback != null)
				finishCallback();
		}
		video.playVideo(Generic.returnPath() + path, false, false);
		#else
		if (finishCallback != null)
			finishCallback();
		#end
	}
}
