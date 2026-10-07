jfSW for MiSTer - Shadow Warrior as a hybrid core
====================================================

The game (JFShadowWarrior, Jonathon Fowler's port of 3D Realms' Shadow
Warrior) runs on the MiSTer's ARM CPU; the jfSW FPGA core provides native
15kHz video (CRT, VGA and HDMI) at 320x200, 640x200, 320x240 or 640x240,
audio and input.

Disclaimer: AI is being used to speed up development of this project.

Requirements
  - danik_hybrid_cores, the launcher that comes with this release
    (Scripts/danik_hybrid_cores.sh): copy it to /media/fat/Scripts/ and run
    it ONCE from the MiSTer's Scripts menu. It starts the game whenever
    the core is loaded, keeps running after a reboot, and serves all our
    hybrid cores. Every hybrid core brings the launcher along and the
    newest version is the one that runs, so it never has to be run again
    after an update. Without it the core only shows the MiSTer logo.
  - Game data. It is not included: SW.GRP of Shadow Warrior 1.2, from the
    original CD or from Shadow Warrior Classic Complete / Classic Redux
    (GOG, Steam), or of the shareware version. The addons Wanton
    Destruction (WT.GRP) and Twin Dragon (TD.GRP) are optional.

Install
  1. Copy _Other/jfSW_*.rbf to /media/fat/_Other/
  2. Copy games/jfSW/ to /media/fat/games/jfSW/
  3. Copy the game data to /media/fat/games/jfSW/
       SW.GRP
       Track02.ogg ... Track14.ogg, the music (the audio of the game's
         CD), there or in a folder "music". Without them the game is
         silent but for its sound effects.
       optional: WT.GRP and TD.GRP, there or in a folder "addons". With
         more than one game in the folder, a list to pick from comes up
         when the core is loaded. Twin Dragon needs SW.GRP as well.
     The whole folder of Shadow Warrior Classic Redux (the one with
     SW.GRP, "addons" and "classic") can be copied as it is: the addons
     and the music (classic/MUSIC) are found in it.
  4. Run danik_hybrid_cores from the Scripts menu, if you have not done so
     before (see Requirements).
  5. Load jfSW from the Other menu.

OSD options
  Aspect ratio, Scale, Scandoubler Fx, Stereo Mix as in other cores.
  HDMI Only     Yes if no CRT is connected: resolutions of 640x400 and
                more are then progressive instead of interlaced, and the
                analog output is switched off while one is shown, so that a
                15kHz screen can never get such a signal. This game has no
                such resolution, so nothing changes. Not there with
                direct_video=1.
  CRT Options   for a 15kHz screen: Horizontal Size, Horizontal Pos and
                Vertical Pos fit the picture to it. The pixels stay as they
                are; HDMI is not affected. Not there with
                forced_scandoubler=1.
  Resolution    what the game renders and the core puts out, always at
                15kHz: 320x200 (default, as the original), 640x200,
                320x240 or 640x240. 640 across is twice the detail in the
                same place. 240 lines are square pixels at 320 across:
                the 3D view gets a fifth more lines, while everything
                that was drawn for 200 lines keeps its pixels. Menus and
                full screen pictures are in the middle of the screen with
                20 black lines above and below, the status bar and the
                weapon are at the bottom, never stretched.
                Applies at once in the game and its menu.
  L. Stick Sensitivity, R. Stick Sensitivity
                how fast the gamepad's left stick (walk, strafe) and right
                stick (turn, look) move the player, 25% to 300%. At 100% a
                full tilt walks and turns about as fast as the keys do
                when running. They apply at once and take the place of
                the axis scale in the game's own menu.
  Limit Vertical Look
                how far the view tilts up and down. The Build engine
                shifts the picture instead of turning the camera, which
                distorts it the further you look up or down. Off (default)
                is the game's own range; On leaves half of it in both
                directions, for the keys, the mouse and the gamepad
                alike.
  Menu OK, Menu Back
                the gamepad button that confirms / goes back in the game's
                menus, whatever it does in the game. MiSTer (default) uses
                the OK/Back buttons of your MiSTer menu.

Controls
  Keyboard and mouse:
    Up, down                            Walk forward, back
    Left, right (or mouse)              Turn
    Mouse up, down                      Look up, down
    Alt (or right mouse button)         Strafe: hold to sidestep with
                                        left and right (, and . sidestep
                                        directly)
    Ctrl (or left mouse button)         Fire
    Space                               Open, use
    Shift                               Run (Caps Lock: always run)
    A, Z                                Jump, crouch
    1 - 0                               Weapons
    Enter, [, ]                         Use the inventory item, previous
                                        and next item
    Page Up, Page Down, Home, End       Look and aim up and down
    Tab                                 Map
    Esc                                 Menu
    These are the keys of the original game. "Options" in the game's
    menu changes keys, mouse and gamepad assignments; they are saved in
    sw.cfg.
  Gamepad (default mapping):
    Left stick                          Walk and strafe
    Right stick                         Turn, look up and down
    D-pad                               Walk and turn
    R (RB / R1)                         Fire
    B (Xbox A / PlayStation Cross)      Open, use
    A (Xbox B / PlayStation Circle)     Jump
    L (LB / L1)                         Crouch
    Y (Xbox X / PlayStation Square)     Next weapon
    X (Xbox Y / PlayStation Triangle)   Use the inventory item
    Select                              Map
    Start                               Menu
  Change the buttons in the OSD under "Define jfSW buttons". "Menu OK" and
  "Menu Back" there are only needed for a button without a game function;
  MiSTer doesn't let you assign a button twice, so to confirm with a button
  that also has a game function, pick it in the OSD's Menu OK/Menu Back
  options instead.
  Naming a saved game without a keyboard: up/down changes the last
  letter, right adds a letter, left removes one, Menu OK confirms.

Music
  Shadow Warrior plays its music from the CD. This build plays the same
  tracks from Ogg Vorbis files named Track02.ogg to Track14.ogg (track 1
  of the CD is the data). Classic Redux comes with them; from an original
  CD, rip the audio tracks and encode them. The MIDI music of the
  shareware version is not played.

Files
  /media/fat/games/jfSW/sw.cfg       settings
  /media/fat/games/jfSW/game*.sav    saved games
  /media/fat/logs/jfSW/jfsw.log   the game's log

Credits
  JFShadowWarrior, JFBuild, JFAudioLib and JFMACT by Jonathon Fowler and
  contributors (https://github.com/jonof/jfsw).
  Shadow Warrior by 3D Realms Entertainment.
  Build engine by Ken Silverman.
  // "Build Engine & Tools" Copyright (c) 1993-1997 Ken Silverman
  // Ken Silverman's official web site: "http://www.advsys.net/ken"
  // See the included license file "BUILDLIC.TXT" for license info.
  libogg and libvorbis by the Xiph.Org Foundation.
  SDL by Sam Lantinga and contributors.
  MiSTer by Sorgelig and the MiSTer-devel contributors.
  MiSTer Frontier by MiSTer Organize
  (https://github.com/MiSTerOrganize/MiSTer_Frontier): thank you for the
  inspiration. Hybrid cores on the MiSTer, and the way their game is
  launched, come from MiSTer Frontier. Our launcher is a separate
  implementation and does not need MiSTer Frontier installed.

License
  JFShadowWarrior: GPL-2.0-or-later (LICENSE-jfsw.txt)
  The Build engine in it: Ken Silverman's Build license (BUILDLIC.TXT),
  free of charge, no commercial use
  libogg, libvorbis: BSD (LICENSE-vorbis.txt)
  SDL: zlib (LICENSE-sdl.txt)
  The launcher scripts: GPL-3.0 (LICENSE-gpl3.txt)
  The FPGA core: GPL-2.0
  Source: https://github.com/ItsDanik/jfSW_MiSTer
          https://github.com/ItsDanik/Hybrid_MiSTer (launcher, framework)
