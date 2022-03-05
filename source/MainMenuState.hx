package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	//var bg:FlxSprite;
	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	public static var finishedFunnyMove:Bool = false;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		//'credits',
		'options'
	];

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var pieChart:FlxSprite;
	var bg:FlxSprite;
	var opitionsBg:FlxSprite;
	var freeplayBg:FlxSprite;

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var amongusTro:FlxSprite;
	var pipdied:FlxSprite;
	var blackBar:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);

		var yellowBg:FlxSprite = new FlxSprite(0, -7.95).loadGraphic(Paths.image('MENU/MainMenuArea'));
		yellowBg.setGraphicSize(1286, 730);
		yellowBg.updateHitbox();
		yellowBg.antialiasing = ClientPrefs.globalAntialiasing;

		bg = new FlxSprite(0, -9.95).loadGraphic(Paths.image('MENU/MainMenuSTORYMODEart'));
		bg.setGraphicSize(1286, 730);
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;

		opitionsBg = new FlxSprite(0, -9.95).loadGraphic(Paths.image('MENU/MainMenuTHEOPTIONSart'));
		opitionsBg.setGraphicSize(1286, 730);
		opitionsBg.updateHitbox();
		opitionsBg.antialiasing = ClientPrefs.globalAntialiasing;
		opitionsBg.visible = false;
		
		freeplayBg = new FlxSprite(0, -9.95).loadGraphic(Paths.image('MENU/MainMenuTHEFREEPLAYart'));
		freeplayBg.setGraphicSize(1286, 730);
		freeplayBg.updateHitbox();
		freeplayBg.antialiasing = ClientPrefs.globalAntialiasing;
		freeplayBg.visible = false;

		pieChart = new FlxSprite(34.5, 217.95);
		pieChart.angle = -20;
		pieChart.frames = Paths.getSparrowAtlas('Piechart');
		pieChart.setGraphicSize(595, 600);
		pieChart.animation.addByPrefix('idle', 'pie instance', 24, false);
		pieChart.animation.addByPrefix('spinDown', 'E-piedown instance', 24, false);
		pieChart.animation.addByPrefix('spinUp', 'F-pieup instance', 24, false);
		pieChart.updateHitbox();
		pieChart.x -= 80;
		pieChart.y -= 30;
		pieChart.antialiasing = ClientPrefs.globalAntialiasing;

		var borders:FlxSprite = new FlxSprite(0.05, -7.95).loadGraphic(Paths.image('MENU/MainMenuBorder'));
		borders.setGraphicSize(1286, 730);
		borders.updateHitbox();
		borders.antialiasing = ClientPrefs.globalAntialiasing;

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		pipdied = new FlxSprite(0, -9.95);
		pipdied.frames = Paths.getSparrowAtlas('MenuShitAssets');
		pipdied.setGraphicSize(203, 360);
		pipdied.setPosition(1024.45, 339.1);
		pipdied.y -= 300;
		pipdied.x -= 180;
		pipdied.animation.addByPrefix('idleGold', 'C-goldpip', 24, true);
		pipdied.animation.addByPrefix('idleStone', 'StonePip', 24, true);
		pipdied.animation.addByPrefix('idle', 'A-lockedtrophy', 24, true);
		pipdied.scrollFactor.set();
		pipdied.antialiasing = ClientPrefs.globalAntialiasing;


		amongusTro = new FlxSprite(0, -9.95);
		amongusTro.frames = Paths.getSparrowAtlas('MenuShitAssets');
		amongusTro.setGraphicSize(203, 360);
		amongusTro.setPosition(1024.45, 339.1);
		amongusTro.y -= 190;
		amongusTro.x -= 500;
		amongusTro.antialiasing = ClientPrefs.globalAntialiasing;
		amongusTro.animation.addByPrefix('idle', 'StonePussy', 24, true);
		amongusTro.animation.addByPrefix('Gold', 'D-goldpussy', 24, true);
		amongusTro.visible = false;
		amongusTro.scrollFactor.set();

		blackBar = new FlxSprite(0,0).loadGraphic(Paths.image('frame'));
		blackBar.setGraphicSize(1286,830);
		blackBar.screenCenter();
		blackBar.scrollFactor.set();
		blackBar.antialiasing = ClientPrefs.globalAntialiasing;

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBGMagenta'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(1286, 730);
		//magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		var menuId = 1;
		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
			switch (menuId)
			{
				case 1:
					//menuItem.angle -= 6;
					menuItem.setPosition(165.9, 355.45);
					menuItem.setGraphicSize(528, 105);

				case 2:
					menuItem.setPosition(34.7, 555.75);
					//menuItem.angle += 6;
					menuItem.alpha = 0.5;
					menuItem.setGraphicSize(414, 104);

				case 3:
					//menuItem.angle += 6;
					menuItem.setGraphicSize(452,104);
					menuItem.setPosition(-527.8,398.2);
					menuItem.alpha = 0.5;
					finishedFunnyMove = true; 
					changeItem();
				case 4:
					menuItem.setPosition(-12.3,170.95);
					menuItem.alpha = 0.5;

			}
			menuId += 1;
		}

		add(bg);
		add(opitionsBg);
		add(freeplayBg);
		add(yellowBg);
		add(pieChart);
		add(borders);
		add(menuItems);
		add(pipdied);
		add(amongusTro);
		//add(blackBar);
		//add(amongusTro);
		//add(pipdied);
		
		if (FlxG.save.data.PipModWeekCompleted == 1)
			pipdied.animation.play('idleStone');
		else
			pipdied.animation.play('idle');
		
		if (FlxG.save.data.PipModWeekCompleted == 1 && FlxG.save.data.PipModFC == 3)
			pipdied.animation.play('idleGold', true);

		if (FlxG.save.data.PussyModWeekCompleted == 1){
			amongusTro.visible = true;
			amongusTro.animation.play('idle', true);
		}

		if (FlxG.save.data.PussyModWeekCompleted == 2){
			amongusTro.visible = true;
			amongusTro.animation.play('Gold', true);
		}
		
		//FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
						FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
						FlxTween.tween(magenta, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
						FlxTween.tween(bg, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
						FlxTween.tween(magenta, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
						//FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
						//FlxFlicker.flicker(magenta, 1.1, 0.15, false);
						//FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
						//FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
						//FlxTween.tween(magenta, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
						//FlxTween.tween(bg, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
						//FlxTween.tween(magenta, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
										function tweenTime(spr:FlxSprite, where:Int) { //this is shit god help me, please improve this, its just so fucking bad
											//	trace(where);
												if (where == 1){ //down
													finishedFunnyMove = false;
										
												switch (spr.health)
												{
													case 1:
													FlxTween.tween(spr, {x:168.7, y: 551}, 0.2, {ease: FlxEase.linear});
													spr.health = 2;
												
													case 2:
													FlxTween.tween(spr, {x:22.9, y: 281.5}, 0.2, {ease: FlxEase.linear});
													spr.health = 3;
										
												
													case 3:
													FlxTween.tween(spr, {x:388.55, y:410.15}, 0.2, {ease: FlxEase.linear});
													spr.health = 1;
												
												}
												finishedFunnyMove = true;
										
											}
											if (where == -1){ //up
										
												
												switch (spr.health)
												{
													case 1:
														FlxTween.tween(spr, {x:22.9, y: 281.5}, 0.2, {ease: FlxEase.linear});
														spr.health = 2;
												
													case 2:
														FlxTween.tween(spr, {x:388.55, y:410.15}, 0.2, {ease: FlxEase.linear});
														spr.health = 3;
												
													case 3:
														FlxTween.tween(spr, {x:168.7, y: 551}, 0.2, {ease: FlxEase.linear});
														spr.health = 1;
										
												
												}
												finishedFunnyMove = true;
											}
										
											}
								}
							});
						}
					});
				}
			}
			
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.alpha = 0.5;
			if (spr.ID == curSelected && finishedFunnyMove)
				{
					camFollow.setPosition(650,370);
	
					spr.animation.play('selected');
					spr.alpha = 1;
	
					if (curSelected == 0){
						bg.visible = true;
						opitionsBg.visible = false;
						freeplayBg.visible = false;
	
						pieChart.angle = -50;
					}
				else if (curSelected == 1){
					bg.visible = false;
					opitionsBg.visible = false;
					freeplayBg.visible = true;
						pieChart.angle = -20;
			}
				else if (curSelected == 2){
					bg.visible = false;
					freeplayBg.visible = false;
					opitionsBg.visible = true;
	
					pieChart.angle = 30;
			}
	
				}
			spr.updateHitbox();
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
