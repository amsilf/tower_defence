-----------------------------------------------------------------------------------------
--
-- music_and_sounds.lua
--
-----------------------------------------------------------------------------------------


local function mainThemeFinished( event )
	print("Main theme fininshed");
end

local backgroundMusicStream = audio.loadStream("resources/music/battle_2.mp3");
local backgroundMusicChannel = audio.play(backgroundMusicStream,	 
	{channel=1, loops=-1, fadein=5000, onComplete=mainThemeFinished});
