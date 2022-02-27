local xx = 520;
local yy = 580;
local xx2 = 820;
local yy2 = 580;
local ofs = 20;
local followchars = true;
local allowCountdown = false

local usedSpace = false

function onCreate()
	addCharacterToList('violet', 'dad');
	
	makeAnimatedLuaSprite('violet', 'characters/Definitive_Violet_Assets', getProperty('dad2.x'), getProperty('dad2.y'));
	addLuaSprite('violet', false)
	setObjectOrder('violet', getObjectOrder('gfGroup'))
	setProperty('violet.visible', false)
end

function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then
		startVideo('intro');
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end
function onStepHit()
	if curStep == 510 or curStep == 511 then
		setProperty('violet.visible', true)
		setProperty('dad2.visible', false)
		setProperty('dad2.alpha', 0)
	end
end

function onGameOverStart()
	setProperty('camFollow.y', getProperty('camFollow.y') - 300)
end

function onUpdate(elapsed)
	setProperty('violet.x', getProperty('dad2.x'))
	setProperty('violet.y', getProperty('dad2.y') - 50)
	setProperty('violet.scale.x', getProperty('dad2.scale.x'))
	setProperty('violet.scale.y', getProperty('dad2.scale.y'))
	setProperty('violet.offset.x', getProperty('dad2.offset.x'))
	setProperty('violet.offset.y', getProperty('dad2.offset.y'))
	setProperty('violet.animation.frameIndex', getProperty('dad2.animation.frameIndex'))
    if followchars == true then
        if mustHitSection == false then
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
        else
            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
	    if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx2,yy2)
            end
        end
    else
        triggerEvent('Camera Follow Pos','','')
    end
end