# jfSW for MiSTer

Shadow Warrior and its addons Wanton Destruction and Twin Dragon on [MiSTer FPGA](https://github.com/MiSTer-devel/Main_MiSTer/wiki) as a hybrid port.

The game is [JFShadowWarrior](https://github.com/jonof/jfsw), Jonathon Fowler's port of 3D Realms' Shadow Warrior (1997) on his port of Ken Silverman's Build engine, with the engine's classic software renderer. It runs on the MiSTer's ARM CPU. The jfSW FPGA core provides native 15kHz video (CRT, VGA and HDMI) at 320x200, 640x200, 320x240 or 640x240, 44.1kHz audio, an FM chip for the AdLib music of the shareware version, and keyboard, mouse and gamepad input. The two halves talk through shared DDR3 memory.

> **Beta.** Expect rough edges and please report problems in the issues.

Disclaimer: AI is being used to speed up development of this project.

## Requirements

- **danik_hybrid_ports**, the launcher (`Scripts/danik_hybrid_ports.sh`): run it **once** from the MiSTer's `Scripts` menu. It starts the game whenever its menu entry is loaded, keeps running after a reboot, and serves all our hybrid ports; its screen picks which ports and games to have, and can keep them up to date through `update_all`. It replaces `danik_hybrid_cores`, the launcher before it, and moves ports installed the old way (`games/jfSW/`) into the new folders by itself. Without it the core says "Game not running".
- **Game data**, which is not included: `SW.GRP` of Shadow Warrior 1.2, from the original CD or from *Shadow Warrior Classic Complete* / *Classic Redux* (GOG, Steam), or of the shareware version. The addons *Wanton Destruction* (`WT.GRP`) and *Twin Dragon* (`TD.GRP`, which needs the full game's `SW.GRP` as well) are optional.

## Installation

With `update_all` (Downloader 2.4 or newer, which update_all keeps up to date):

1. Copy [`downloader_danik_hybrid_ports.ini`](https://raw.githubusercontent.com/ItsDanik/Hybrid_MiSTer/main/launcher/downloader_danik_hybrid_ports.ini) to the root of your SD card (`/media/fat`).
2. Run `update_all`. That installs the launcher, **danik_hybrid_ports**, in `Scripts`.
3. Run **danik_hybrid_ports** from the `Scripts` menu, tick the games you want and press *X: Apply*. They are installed, and update_all keeps them up to date.

By hand:

1. Download the newest `jfSW_YYYYMMDD.zip` from [releases](releases/) and extract it to the root of your SD card (`/media/fat`). That gives you:
   - `_Other/dnk-Shadow Warrior.mgl`, `_Other/dnk-SW Wanton Destruction.mgl` and `_Other/dnk-SW Twin Dragon.mgl`, the games' entries in the `Other` menu
   - `_Other/dnk/dnk-jfSW_YYYYMMDD.rbf`, the FPGA core
   - `games/dnk/jfSW/`, the game binary and its launch script
   - `Scripts/danik_hybrid_ports.sh`, the launcher (from [Hybrid_MiSTer](https://github.com/ItsDanik/Hybrid_MiSTer))
   - `downloader_danik_hybrid_ports.ini`, with which `update_all` keeps the ports up to date from then on
2. Copy **everything** in the game's folder (the one with `SW.GRP`) to `/media/fat/games/dnk/jfSW/`, with its folders as they are, and leave nothing out (files the port does not use do no harm). The port finds in it:
   - `SW.GRP`
   - the music, which is the audio of the game's CD: `Track02.ogg` to `Track14.ogg`, there or in a folder `music`. Without them the full game has no music, only its sound effects (see [Music](#music)). The shareware version needs none: its music is in its `SW.GRP`.
   - optional: `WT.GRP` and `TD.GRP`, there or in a folder `addons`.

   The whole folder of *Shadow Warrior Classic Redux* (the one with `SW.GRP`, `addons` and `classic`) can be copied as it is: the addons and the music (`classic/MUSIC`) are found in it.
3. Run **danik_hybrid_ports** from the `Scripts` menu, if you have not done so before (see Requirements).
4. Load the game from the `Other` menu, e.g. **dnk-Shadow Warrior**.

The game data can go on a USB drive instead, into the same folder there (`/media/usb0/games/dnk/jfSW/`): the game looks for it there first, and then keeps its settings and saved games there as well. Everything else stays on the SD card.

The game files are known by their contents, whatever their names. The menu entry of Shadow Warrior starts the shareware when the full game is not there. When a game's files are missing, the core says which files to copy where. Each game keeps its own OSD settings and button mappings. The core file itself (`_Other/dnk/dnk-jfSW_*.rbf`, or from *Recent*) lists the games that are there to pick from; quitting a game then returns to the list. The game's log is in `/media/fat/logs/dnk/jfSW/jfsw.log`. Settings (`sw.cfg`) and saved games (`game0.sav` to `game9.sav`) are in `/media/fat/games/dnk/jfSW/` (on the USB drive, if the game data is there).

## OSD options

| Option | |
|---|---|
| Aspect ratio, Scale, Scandoubler Fx, Stereo Mix | as in other cores |
| FPS Counter | shows the pictures per second in the top left corner |
| HDMI Only | **Yes** if no CRT is connected: resolutions of 640x400 and more are then progressive instead of interlaced, and the analog output is switched off while one is shown, so that a 15kHz screen can never get such a signal. This game has no such resolution, so nothing changes. Not there with `direct_video=1` |
| CRT Options | for a 15kHz screen: *Horizontal Size*, *Horizontal Pos* and *Vertical Pos* fit the picture to it. The pixels stay as they are; HDMI is not affected. The size is for the game's picture: the core's own, with its messages, keeps its width. Not there with `forced_scandoubler=1`. *HUD (Bottom)*: in the 240-line resolutions, how many lines the status bar (or the mini bar) sits above the bottom edge of the screen, 0 to 24 (0 by default), so that a CRT's overscan does not hide it; greyed out at 200 lines. *HUD (Top)* is always greyed out: the game has nothing at the top edge |
| Resolution | what the game renders and the core puts out, always at 15kHz: **320x200** (default, as the original), **640x200**, **320x240** or **640x240**. 640 across is twice the detail in the same place: every pixel becomes two. 240 lines are square pixels at 320 across: the view fills all of them, from the top edge to the bottom one, with the status bar drawn over it at the *HUD (Bottom)* margin and the weapon on top of the bar; the menus and pictures keep their 200 lines in the middle. The artwork is never stretched. Applies at once in the game and its menu |
| L. Stick Sensitivity, R. Stick Sensitivity | how fast the gamepad's left stick (walk, strafe) and right stick (turn, look) move the player, 25% to 300%. At 100% a full tilt walks and turns about as fast as the keys do when running. They apply at once and take the place of the axis scale in the game's own menu |
| Limit Vertical Look | how far the view tilts up and down. The Build engine does not turn the camera, it shifts the picture, which distorts it the further you look up or down. **On** (default) leaves half of the game's own range in both directions, **Off** is the whole range. It holds for the keys, the mouse and the gamepad alike |
| Music | for the shareware version's music, which is MIDI (the full game's is the CD's, see [Music](#music)): **MIDI** (default), played by the core's synthesizer with a SoundFont, or by an MT32-pi when one is connected and on; **FM chip**: on the FM chip, as an AdLib card played it. *SoundFont*: **Default** is GeneralUser GS, which comes with the port (`games/dnk/SoundFonts/GeneralUser-GS.sf2`); 1 to 7 are your own `.sf2` files in that folder, in the order of their names, or as the MIDI Player core sets them. A SoundFont that is missing, damaged or too big (over 64 MB of samples) is said in the MiSTer's info box, and the music goes to the FM chip. Applies at once |
| MT32-pi | only there while an MT32-pi answers on the user port: see [Music](#music) |
| Cheats | **God Mode**: nothing hurts you while it is on. **No Clipping**: you walk through walls while it is on. **Give All**: every weapon with full ammo, armor, the inventory items and all keys, once each time it is selected. **Next Level**: the level counts as completed, as at its exit, and the next one starts (not on the last level) |
| Save Diagnostic Report | the last line: see [If something is wrong](#if-something-is-wrong) |

## Controls

- **Keyboard and mouse:**

| Key | Action |
|---|---|
| W, S (or up, down) | Walk forward, back |
| A, D | Sidestep left, right |
| Mouse (or left, right) | Turn. Moving the mouse up and down looks up and down |
| Left mouse button (or right Ctrl) | Fire |
| E (or right mouse button) | Open, use |
| Space | Jump |
| Left Ctrl | Crouch |
| Shift | Run (Caps Lock: always run) |
| 1 - 0 | Weapons |
| R, Q (or mouse wheel) | Next, previous weapon |
| F (or Enter), `[`, `]` | Use the inventory item, previous and next item |
| Page Up, Page Down, Home, End | Look and aim up and down |
| Tab | Map |
| Esc | Menu |

This is a modern scheme, the default of this build; with the arrows and the right Ctrl the game can be played on a keyboard alone. *Options* in the game's menu changes keys, mouse and gamepad assignments, and has the keys of the original game (*Apply Classic Defaults*: arrows, Ctrl fires, Space opens, A and Z jump and crouch). They are saved in `sw.cfg`, so a `sw.cfg` from an earlier release keeps its keys until *Apply Modern Defaults* is chosen there.

- **Gamepad** (default mapping):

| Button | Action |
|---|---|
| Left stick | Walk and strafe |
| Right stick | Turn, look up and down |
| D-pad | Walk and turn |
| R (RB / R1) | Fire |
| B (Xbox A / PlayStation Cross) | Open, use |
| A (Xbox B / PlayStation Circle) | Jump |
| L (LB / L1) | Crouch |
| Y (Xbox X / PlayStation Square) | Next weapon |
| X (Xbox Y / PlayStation Triangle) | Use the inventory item |
| Select | Map |
| Start | Menu |

In the game's menus the buttons that confirm and go back are the ones of your MiSTer menu, whatever they do in the game: its *Menu OK* / *Menu Back* if you set them in *Define joystick buttons*, else its A / B. A controller never set up in MiSTer confirms and goes back as on its console: Cross / Circle on PlayStation, A / B on Xbox and on Nintendo.

Change the buttons in the OSD under *Define jfSW buttons*. *Menu OK* and *Menu Back* there are only needed for a spare button without a game function. While the OSD is open, the game gets no input.

Naming a saved game without a keyboard: up/down changes the last letter, right adds a letter, left removes one, Menu OK confirms.

## Music

**The full game** plays its music from the CD. This build plays the same tracks from Ogg Vorbis files named `Track02.ogg` to `Track14.ogg` (track 1 of the CD is the data). *Classic Redux* comes with them; from an original CD, rip the audio tracks and encode them.

**The shareware version** has no CD: its music is MIDI, written for the sound cards of 1997. With the OSD's *Music* on **MIDI** (the default), the songs' General MIDI tracks are played by a SoundFont 2 synthesizer in the FPGA core, with GeneralUser GS, which comes with the port, or a SoundFont of your own (*SoundFont* 1 to 7, `.sf2` files in `games/dnk/SoundFonts/`). The game's *Music Volume* sets its level.

With *Music* on **FM chip**, it plays as an AdLib or Sound Blaster card did, on a YM3812 (OPL2) in the FPGA core, [JTOPL](https://github.com/jotego/jtopl). The game runs the AdLib driver of the original (the Apogee Sound System's, with the game's own instruments from `swtimbr.tmb`) and sends the core the chip's register writes, each with the audio sample it is due at; the chip's sound is made in the FPGA and mixed with the game's. The music needs the core of the same release: with an older `.rbf` the shareware version stays without music.

**With an [MT32-pi](https://github.com/dwhinham/mt32-pi)** on the MiSTer's user port (an MT32-pi board for the MiSTer, with the firmware's MiSTer support) and *Music* on MIDI, the shareware version's music goes to it instead of the synthesizer. The OSD then shows its lines (they are hidden while no MT32-pi answers): *MT32-pi* **On** (default) or **Off** (the core's synthesizer, as without it), *MT32-pi Synth* **SoundFont** (default) or **MT-32** (it needs the MT-32 ROMs on the MT32-pi's card), *MT32-pi ROM* (MT-32 v1, v2, CM-32L) and *MT32-pi SoundFont* (**Pi's own**, the default: the one the MT32-pi has, as set on it; or one of the first eight on its card, 0 to 7). A box names the synth each time it changes; *Reset Hanging Notes* makes the MT32-pi stop all its notes, and the music goes on (the SoundFont stays). All apply at once; the game's *Music Volume* sets its level.

## Frame pacing

Shadow Warrior moves 40 times per second. A 15kHz picture a TV accepts has about 60 fields per second: the core shows 59.64. This build draws exactly one frame per field, with the game's clock taken from the field counter of the core instead of the system clock, and puts everything that moves between its last two positions for the time of that field, as the game does on any monitor that is faster than 40Hz.

The game holds the full rate of one frame per field at 320x200 and 640x200, in the levels it was measured in.

## If something is wrong

If the game stutters, the sound breaks up or something else is wrong, open the OSD while it happens and pick **Save Diagnostic Report**, the last line of the menu. The game keeps running; MiSTer's info box says the report is saved in `games/dnk/diagnostics/` on the SD card. Send that file (`jfSW_<date>_<time>.zip`) with a few words on what went wrong.

The report has the setup (versions, the video and audio lines of `MiSTer.ini`, the OSD settings), how the last 60 seconds went, the game's log and a screenshot. Nothing else: no network settings, addresses, saved games or lists of your files.

## Building

Everything builds in Docker on a Linux PC.

```sh
git clone --recursive https://github.com/ItsDanik/jfSW_MiSTer.git
cd jfSW_MiSTer
./build.sh              # ARM game binary  -> build/mister/jfsw
./core/build_core.sh    # FPGA core (Quartus Lite 17.0.2) -> core/output_files/jfSW.rbf
./package.sh            # release zip      -> dist/jfSW_YYYYMMDD.zip
```

The toolchain image (Debian bullseye, glibc 2.31 to match the MiSTer) is built from `hybrid/toolchain/` on first use. The first build also downloads and builds SDL2, SDL2_mixer and SDL2_net, and libogg and libvorbis for the music.

### Repository layout

| Path | |
|---|---|
| `hybrid/` | submodule: [ItsDanik/Hybrid_MiSTer](https://github.com/ItsDanik/Hybrid_MiSTer), what all our hybrid ports share: the FPGA host module, the ARM side library, SDL2 drivers, the launcher (`danik_hybrid_ports.sh`), toolchain and conventions. See its README. |
| `core/` | FPGA core, based on [Template_MiSTer](https://github.com/MiSTer-devel/Template_MiSTer): `jfSW.sv` (OSD and button names) around `hybrid/rtl/hybrid_host.sv` |
| `jfsw/` | submodule: [ItsDanik/jfsw](https://github.com/ItsDanik/jfsw) branch `mister`, [JFShadowWarrior](https://github.com/jonof/jfsw) with the MiSTer changes (`CMakeLists.txt`, `src/mister_port.c` and a few `#ifdef MISTER_HYBRID`). Two of its own submodules have the rest: `jfbuild/`, the Build engine ([ItsDanik/jfbuild](https://github.com/ItsDanik/jfbuild) branch `mister`), with video, clock and joystick in `src/sdlayer2.c`, and `jfaudiolib/`, the sound library ([ItsDanik/jfaudiolib](https://github.com/ItsDanik/jfaudiolib) branch `mister`), with the MIDI driver for the core's FM chip in `src/driver_misterfm.c` |
| `package/` | files shipped in the release next to the binary (`danik_hybrid_launch.sh`, README), and `games.txt`: the games and their menu entries |
| `releases/` | release packages |

### Development notes

- `./build.sh host` builds the same game for the PC. It runs against `hybrid/tools/fakecore`, a stand-in for the FPGA core that takes scripted input and saves screenshots and audio:
  ```sh
  gcc -O2 -o build/host/fakecore hybrid/tools/fakecore.c
  build/host/fakecore /tmp/shm script.txt audio.raw &
  cd <data folder> && MISTER_HYBRID_SHM=/tmp/shm <repository>/build/host/jfsw
  ```
- `MISTER=root@<address> tools/test_on_mister.sh SW` tries the build on a MiSTer next to what is installed there, without installing it: from `/tmp`, with the installed game's folder mirrored there (what the game writes stays in `/tmp`) and its own OSD settings. `WT`, `TD` for the addons, `list` and `nodata` for the core started by itself and without data, `log` for the game's log, `stop` to remove all of it again.
- `touch /tmp/jfsw_nolaunch` on the MiSTer keeps the core loaded without starting the game, so you can start a development binary by hand (set `MISTER_HYBRID_CORE=jfSW`, and `MISTER_HYBRID_SET` for a game's set name, e.g. `jfSW_WT`). `/tmp/danik_hybrid_ports.log` shows what the launcher daemon did.

## Support

If you enjoy this project, you can support my work on [Patreon](https://www.patreon.com/itsdanik).

## Credits

- **[JFShadowWarrior](https://github.com/jonof/jfsw)**, **[JFBuild](https://github.com/jonof/jfbuild)**, JFAudioLib and JFMACT by Jonathon Fowler and contributors.
- **Shadow Warrior** by 3D Realms Entertainment, who released its source code in 2005.
- **Build engine** by Ken Silverman.
- **Apogee Sound System** by James R. Dose: its AdLib MIDI driver, in the form [EDuke32](https://www.eduke32.com) keeps it in, is the one that plays the music on the FM chip.
- **[JTOPL](https://github.com/jotego/jtopl)** by Jose Tejada (jotego): the FM chip in the core.
- **[GeneralUser GS](https://www.schristiancollins.com/generaluser.php)** by S. Christian Collins: the SoundFont of the core's MIDI synthesizer, which comes with the port, its licence next to it.
- **[libogg and libvorbis](https://xiph.org)** by the Xiph.Org Foundation.
- **[SDL](https://libsdl.org)** by Sam Lantinga and contributors.
- **[MiSTer](https://github.com/MiSTer-devel)** by Sorgelig and the MiSTer-devel contributors: the framework and Template_MiSTer.
- **[MiSTer Frontier](https://github.com/MiSTerOrganize/MiSTer_Frontier)** by MiSTer Organize: thank you for the inspiration. Hybrid cores on the MiSTer, and the way their game is launched (a daemon that watches the loaded core and runs a script from its games folder), come from MiSTer Frontier. Our launcher is a separate implementation and does not need MiSTer Frontier installed.

This project and its maintainers are in no way associated with or endorsed by 3D Realms, Devolver Digital or any other holder of rights in Shadow Warrior. It does not include any game data.

## License

The top-level scripts, tools and documentation are licensed under the [GPL-3.0](LICENSE). The components keep their own licenses: the shared framework in `hybrid/` is GPL-3.0 except where its files say otherwise, JFShadowWarrior is GPL-2.0-or-later (`jfsw/GPL.TXT`) and the Build engine in it is under Ken Silverman's Build license (`jfsw/jfbuild/buildlic.txt`: free of charge, no commercial use), libogg and libvorbis are BSD, SDL and the SDL drivers in `hybrid/sdl2` are zlib, the FPGA core and the MiSTer framework are GPL-2.0 (`core/LICENSE`, with the core's own sources GPL-2.0-or-later), JTOPL in it is GPL-3.0 (`hybrid/rtl/jtopl/LICENSE`).
