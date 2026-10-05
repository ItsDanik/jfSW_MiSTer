# jfSW for MiSTer

Shadow Warrior on [MiSTer FPGA](https://github.com/MiSTer-devel/Main_MiSTer/wiki) as a hybrid core.

The game is [JFShadowWarrior](https://github.com/jonof/jfsw), Jonathon Fowler's port of 3D Realms' Shadow Warrior (1997) on his port of Ken Silverman's Build engine, with the engine's classic software renderer. It runs on the MiSTer's ARM CPU. The jfSW FPGA core provides native 15kHz video (CRT, VGA and HDMI) at 320x200, 44.1kHz audio and keyboard, mouse and gamepad input. The two halves talk through shared DDR3 memory.

> **Beta.** Expect rough edges and please report problems in the issues.

## Requirements

- **danik_hybrid_cores**, the launcher that comes in the release zip (`Scripts/danik_hybrid_cores.sh`): run it **once** from the MiSTer's `Scripts` menu. It starts the game whenever the core is loaded, keeps running after a reboot, and serves all our hybrid cores. Every hybrid core brings the launcher along and the newest version is the one that runs, so it never has to be run again after an update. Without it the core only shows colour bars.
- **Game data**, which is not included: `SW.GRP` of Shadow Warrior 1.2, from the original CD or from *Shadow Warrior Classic Complete* / *Classic Redux* (GOG, Steam), or of the shareware version. The addons *Wanton Destruction* (`WT.GRP`) and *Twin Dragon* (`TD.GRP`) are optional.

## Installation

1. Download the newest `jfSW_YYYYMMDD.zip` from [releases](releases/) and extract it to the root of your SD card (`/media/fat`). That gives you:
   - `_Other/jfSW_YYYYMMDD.rbf`, the FPGA core
   - `games/jfSW/`, the game binary and its launcher
   - `Scripts/danik_hybrid_cores.sh`, the launcher (from [Hybrid_MiSTer](https://github.com/ItsDanik/Hybrid_MiSTer), which can also keep it up to date through `update_all`)
2. Copy the game data to `/media/fat/games/jfSW/`:
   - `SW.GRP`
   - the music, which is the audio of the game's CD: `Track02.ogg` to `Track14.ogg`, there or in a folder `music`. Without them the game is silent but for its sound effects (see [Music](#music)).
   - optional: `WT.GRP` and `TD.GRP`, there or in a folder `addons`. With more than one game in the folder, a list to pick from comes up when the core is loaded. Twin Dragon needs `SW.GRP` as well.

   The whole folder of *Shadow Warrior Classic Redux* (the one with `SW.GRP`, `addons` and `classic`) can be copied as it is: the addons and the music (`classic/MUSIC`) are found in it.
3. Run **danik_hybrid_cores** from the `Scripts` menu, if you have not done so before (see Requirements).
4. Load **jfSW** from the `Other` menu.

The game's log is in `/media/fat/logs/jfSW/jfsw.log`. Settings (`sw.cfg`) and saved games (`game0.sav` to `game9.sav`) are in `/media/fat/games/jfSW/`.

## OSD options

| Option | |
|---|---|
| Aspect ratio, Scale, Scandoubler Fx, Stereo Mix | as in other cores |
| Menu OK, Menu Back | the gamepad button that confirms / goes back in the game's menus, whatever it does in the game. **MiSTer** (default) uses the OK/Back buttons of your MiSTer menu |

## Controls

- **Keyboard and mouse:**

| Key | Action |
|---|---|
| Up, down | Walk forward, back |
| Left, right (or mouse) | Turn |
| Alt (or right mouse button) | Strafe: hold to sidestep with left and right. `,` and `.` sidestep directly |
| Ctrl (or left mouse button) | Fire |
| Space | Open, use |
| Shift | Run (Caps Lock: always run) |
| A, Z | Jump, crouch |
| 1 - 0 | Weapons |
| Enter, `[`, `]` | Use the inventory item, previous and next item |
| Page Up, Page Down, Home, End | Look and aim up and down |
| Tab | Map |
| Esc | Menu |

These are the keys of the original game. *Options* in the game's menu changes keys, mouse and gamepad assignments and has the mouse aiming switch; they are saved in `sw.cfg`.

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

Change the buttons in the OSD under *Define jfSW buttons*. *Menu OK* and *Menu Back* there are only needed for a button without a game function; MiSTer doesn't let you assign a button twice, so to confirm with a button that also has a game function, pick it in the OSD's Menu OK/Menu Back options instead.

Naming a saved game without a keyboard: up/down changes the last letter, right adds a letter, left removes one, Menu OK confirms.

## Music

Shadow Warrior plays its music from the CD. This build plays the same tracks from Ogg Vorbis files named `Track02.ogg` to `Track14.ogg` (track 1 of the CD is the data). *Classic Redux* comes with them; from an original CD, rip the audio tracks and encode them. The MIDI music of the shareware version is not played: there is no synthesizer in this build.

## Frame pacing

Shadow Warrior moves 40 times per second. A 15kHz picture a TV accepts has about 60 fields per second: the core shows 59.64. This build draws exactly one frame per field, with the game's clock taken from the field counter of the core instead of the system clock, and puts everything that moves between its last two positions for the time of that field, as the game does on any monitor that is faster than 40Hz.

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
| `hybrid/` | submodule: [ItsDanik/Hybrid_MiSTer](https://github.com/ItsDanik/Hybrid_MiSTer), what all our hybrid cores share: the FPGA host module, the ARM side library, SDL2 drivers, the launcher (`danik_hybrid_cores.sh`), toolchain and conventions. See its README. |
| `core/` | FPGA core, based on [Template_MiSTer](https://github.com/MiSTer-devel/Template_MiSTer): `jfSW.sv` (OSD and button names) around `hybrid/rtl/hybrid_host.sv` |
| `jfsw/` | submodule: [ItsDanik/jfsw](https://github.com/ItsDanik/jfsw) branch `mister`, [JFShadowWarrior](https://github.com/jonof/jfsw) with the MiSTer changes (`CMakeLists.txt`, `src/mister_port.c` and a few `#ifdef MISTER_HYBRID`). Its own submodule `jfbuild/`, the Build engine ([ItsDanik/jfbuild](https://github.com/ItsDanik/jfbuild) branch `mister`), has the rest: video, clock and joystick in `src/sdlayer2.c` |
| `package/` | files shipped in the release next to the binary (`danik_hybrid_launch.sh`, README) |
| `releases/` | release packages |

### Development notes

- `./build.sh host` builds the same game for the PC. It runs against `hybrid/tools/fakecore`, a stand-in for the FPGA core that takes scripted input and saves screenshots and audio:
  ```sh
  gcc -O2 -o build/host/fakecore hybrid/tools/fakecore.c
  build/host/fakecore /tmp/shm script.txt audio.raw &
  cd <data folder> && MISTER_HYBRID_SHM=/tmp/shm <repository>/build/host/jfsw
  ```
- `touch /tmp/jfsw_nolaunch` on the MiSTer keeps the core loaded without starting the game, so you can start a development binary by hand (set `MISTER_HYBRID_CORE=jfSW`). `/tmp/danik_hybrid_cores.log` shows what the launcher daemon did.

## Credits

- **[JFShadowWarrior](https://github.com/jonof/jfsw)**, **[JFBuild](https://github.com/jonof/jfbuild)**, JFAudioLib and JFMACT by Jonathon Fowler and contributors.
- **Shadow Warrior** by 3D Realms Entertainment, who released its source code in 2005.
- **Build engine** by Ken Silverman.
- **[libogg and libvorbis](https://xiph.org)** by the Xiph.Org Foundation.
- **[SDL](https://libsdl.org)** by Sam Lantinga and contributors.
- **[MiSTer](https://github.com/MiSTer-devel)** by Sorgelig and the MiSTer-devel contributors: the framework and Template_MiSTer.
- **[MiSTer Frontier](https://github.com/MiSTerOrganize/MiSTer_Frontier)** by MiSTer Organize: thank you for the inspiration. Hybrid cores on the MiSTer, and the way their game is launched (a daemon that watches the loaded core and runs a script from its games folder), come from MiSTer Frontier. Our launcher is a separate implementation and does not need MiSTer Frontier installed.

This project and its maintainers are in no way associated with or endorsed by 3D Realms, Devolver Digital or any other holder of rights in Shadow Warrior. It does not include any game data.

## License

The top-level scripts, tools and documentation are licensed under the [GPL-3.0](LICENSE). The components keep their own licenses: the shared framework in `hybrid/` is GPL-3.0 except where its files say otherwise, JFShadowWarrior is GPL-2.0-or-later (`jfsw/GPL.TXT`) and the Build engine in it is under Ken Silverman's Build license (`jfsw/jfbuild/buildlic.txt`: free of charge, no commercial use), libogg and libvorbis are BSD, SDL and the SDL drivers in `hybrid/sdl2` are zlib, the FPGA core and the MiSTer framework are GPL-2.0 (`core/LICENSE`, with the core's own sources GPL-2.0-or-later).
