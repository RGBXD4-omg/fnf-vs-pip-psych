package;

import flixel.system.FlxSound;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import sys.FileSystem;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

class StartupState extends FlxState
{
    public var camHUD:FlxCamera;
    var bg:FlxSprite;

    override public function create():Void
    {	Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.add(camHUD);


    function startDaVideo(name:String):Void {
            #if VIDEOS_ALLOWED
            var foundFile:Bool = false;
            var fileName:String = "Newgrounds";
            #if sys
            if(FileSystem.exists(fileName)) {
                foundFile = true;
            }
            #end
    
            if(!foundFile) {
                fileName = Paths.video(name);
                #if sys
                if(FileSystem.exists(fileName)) {
                #else
                if(OpenFlAssets.exists(fileName)) {
                #end
                    foundFile = true;
                }
            }
    
            if(foundFile) {
                bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
                bg.scrollFactor.set();
                bg.cameras = [camHUD];
                add(bg);
    
                (new FlxVideo(fileName)).finishCallback = function() {
                    remove(bg);
                    FlxG.switchState(new TitleState());
                }
                return;
            }
            else
            {
                FlxG.log.warn('Couldnt find video file: ' + fileName);
                FlxG.switchState(new TitleState());

            }
            #end
            FlxG.switchState(new TitleState());
        }
        startDaVideo("Newgrounds");

        super.create();
    }

    

    override public function update(elapsed:Float):Void
    {

        super.update(elapsed);
    }
}