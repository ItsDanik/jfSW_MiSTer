# jfSW hybrid core for MiSTer (Shadow Warrior)

@hybrid/CLAUDE.md

## This core

- Name everywhere: `jfSW` (core, folders, release), `jfsw` (game submodule, binary in `build/`, log, lock).
- The game is the `jfsw/` submodule, branch `mister`. Its MiSTer code is behind the `MISTER_HYBRID` build option.
- Build: `./build.sh` (game), `./core/build_core.sh` (FPGA), `./package.sh` (zip in `dist/`), `MISTER=root@<address> tools/deploy.sh`.


<!-- Notes that are only true for this game go below. -->

- The game has no CMake build upstream: `jfsw/CMakeLists.txt` is ours and only builds the hybrid core variant (classic software renderer, no Polymost/OpenGL, no editor). Other platforms keep the Makefiles.
- The MiSTer changes are in two repositories: the game (`jfsw/`, branch `mister`: `src/mister_port.[ch]`, `#ifdef MISTER_HYBRID` in `game.c`, `draw.c`, `config.c`, `_functio.h`, `menus.c`) and the engine, its submodule `jfsw/jfbuild` (branch `mister`: video, clock, joystick and message boxes in `src/sdlayer2.c`, `include/sdlayer.h`). `jfmact` and `jfaudiolib` are upstream's, unchanged.
- Joystick: `joyb` is laid out in the engine (`MISTERJOY_*` in `sdlayer.h`) so that jfmact's menu code needs no change: bits 0 and 1 (its A and B) are Menu OK and Menu Back, bits 2..9 the eight actions of `J1`, bits 11..14 the d-pad. The actions' game functions are `joystickdefaults_mister` in `jfsw/src/_functio.h`; keep it, `J1`/`jn` in `core/jfSW.sv` and `MISTER_HYBRID_JN` in the launch script in step.
- Clock: 120 ticks per second from the core's field counter (`sampletimer()`), the game moves every 3 ticks (40 per second) and interpolates; `gettimerfraction()` gives `draw.c` the part of a tick.
- Music: the CD tracks as `Track02.ogg`..`Track14.ogg` through libvorbis (`tools/vorbis.sh`, built into the SDL prefix). No MIDI synthesizer, so the shareware version has no music.
- Data lookup: the game folder, plus `addons/`, `music/` and `classic/MUSIC/` in it (the layout of Shadow Warrior Classic Redux). Settings and saves are written to the game folder.
- `MISTER_HYBRID_STATS=1` in the environment makes the game print how many fields went by without a new frame, every 600 fields.
