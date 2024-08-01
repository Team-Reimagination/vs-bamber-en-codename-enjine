// MOVED IT HERE SO IT IS LESS MESSY
public var optionsFile:Array<Dynamic> = [ // god help me
    [ // VIDEO
        // [name, desc, ["params", "leave blank if checkbox"], save name],
        ["Framerate", "", [30, 60, 90, 120, 150, 180, 210, 240], 'framerate'],
        ["Anti-aliasing", "Toggles smoothing jagged edges on curves and diagonal lines", [], 'antialiasing'],
        ["Pixel Perfect", "", [], 'pixelperfect'],
        ["Resolution", "How many pixels the game renders at", ["1280x720"], 'resolution'],
        ["Fullscreen", "Toggles the game filling your screen", [], 'fullscreen'],
        ["Borderless", "Toggles the game window border", [], 'borderless'],
        ["Brightness", "How bright the game is", [], 'brightness'],
        ["Gamma", "", [], 'gamma']
    ],
    [ // SOUND
        ["Music Volume", "How loud the music is", [], 'musicVolume'],
        ["SFX Volume", "How loud sound effects are", [], 'sfxVolume'],
        ["Voice Volume","How loud the character voices are while playing a song", [], 'voiceVolume'], 
        ["Miss Sounds", "Toggles playing a sound effect on miss", [], 'missSounds'],
        ["Copyrighted Bypass", "Toggles replacing copyrighted audio with MIDI covers", [], 'copyrightBypass'],
        ["Subtitles", "Toggles words appearing on screen when spoken lyrics are heard", [], 'subtitles'], // can someone refine this description please
    ],
    [ // VISUAL
        ["Low Memory Mode", "", [], 'lowMemory'],
        ["VRAM Only Sprites", "", [], 'vramSprites'],
        ["Flashing Lights", "Toggles flashes on the screen", [], 'flashingLights'],
        ["Shaders", "What shaders should be shown", ["All", "Some", "None"], 'shaders'],
        ["Botplay UI", "", [], 'botplayUI'],
        ["Background Blur", "", [], 'bgBlur'],
        ["Background Dim", "", [], 'bgDim'],
        ["Rapid Camera", "", [], 'rapidCam'],
        ["Timebar", "Toggles the bar that shows how long of the song is left until the end", [], 'timeBar'],
        ["Combo Pos Percent", "",[], 'comboPosPercent'],
        ["Cinematic Bars", "Toggles the bars seen at the top and bottom of the screen during a song", [], 'cinematicBars'],
        ["Health Icons", "Toggles health bar icons", [], 'healthIcons'],
        ["Song Credits", "Toggles the credits popup at the beginning of a song", [], 'songCredits'],
        ["Stamp Keybinds", "", [], 'stampKeybinds']
    ],
    [ // NOTE OPTIONS
        ["Noteskin", "What the notes appear as", ["Default", "Arrows"], 'noteskin'],
        ["Note Scale", "How big the notes appear in-game (Default is \"1\")", [], 'noteScale'], //#
        ["Note Colors", "What color notes appear as", [], 'noteColors']
    ],
    [ // Controls
        ["Placeholder", "Placeholder", [], 'placeholder']
    ],
    [ // GAMEPLAY
        ["Coloured Healthbar", "", [], 'coloredBar'],
        ["Modcharts", "Toggles the notes moving around during a song", ['Always', 'Sometimes', 'Never'], 'modcharts'],
        ["Custom Scroll Speed", "Toggles using your custom scroll speed", [], 'scrollSpeed'],
        ["Scroll Speed Speed", "How fast the scroll speed should be for a song", [], 'scrollSpeed_Speed'], // 1 - 10?
        ["Pause Countdown", "Toggles the countdown after unpausing", [], 'pausedCountdown'],
        ["Skip Game Over", "", [], 'skipGameOver'],
        ["Skip Song Intro", "", [], 'skipSongIntro'],
        ["Scroll Mode", "Where the notes appear on your screen", ["Top", "Bottom"], 'scrollMode'],
        ["Middle Scroll", "Toggles your strum being centered", [], 'middleScroll'],
        ["Story Mode Dialogue", "Toggles story mode dialogue", [], 'storyDialogue'],
        ["Freeplay Dialogue", "Toggles freeplay dialogue", [], 'freeplayDialogue']
    ],
    [ // MISC
	    ["Reset Scores", "Erases ALL song & week scores/achievements", [""], 'gameStats'],
	    ["Reset Options", "Restores all settings to their default", [""], 'idek']
    ]
];