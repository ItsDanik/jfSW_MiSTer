# jfSW for MiSTer: notes

How the port works and how it is built. For playing it, see the [README](README.md).

## Music

**The full game** plays its music from the CD. This build plays the same tracks from Ogg Vorbis files named `Track02.ogg` to `Track14.ogg` (track 1 of the CD is the data). *Classic Redux* comes with them; from an original CD, rip the audio tracks and encode them.

**The shareware version** has no CD: its music is MIDI, written for the sound cards of 1997. With the OSD's *Music* on **MIDI** (the default), the songs' General MIDI tracks are played by a SoundFont 2 synthesizer in the FPGA core, with GeneralUser GS, which comes with the port, or a SoundFont of your own (*SoundFont* 1 to 7, `.sf2` files in `games/dnk/SoundFonts/`). The game's *Music Volume* sets its level.

With *Music* on **FM chip**, it plays as an AdLib or Sound Blaster card did, on a YM3812 (OPL2) in the FPGA core, [JTOPL](https://github.com/jotego/jtopl). The game runs the AdLib driver of the original (the Apogee Sound System's, with the game's own instruments from `swtimbr.tmb`) and sends the core the chip's register writes, each with the audio sample it is due at; the chip's sound is made in the FPGA and mixed with the game's. The music needs the core of the same release: with an older `.rbf` the shareware version stays without music.

**With an [MT32-pi](https://github.com/dwhinham/mt32-pi)** on the MiSTer's user port (an MT32-pi board for the MiSTer, with the firmware's MiSTer support) and *Music* on MIDI, the shareware version's music goes to it instead of the synthesizer. The OSD then shows its lines (they are hidden while no MT32-pi answers): *MT32-pi* **On** (default) or **Off** (the core's synthesizer, as without it), *MT32-pi Synth* **SoundFont** (default) or **MT-32** (it needs the MT-32 ROMs on the MT32-pi's card), *MT32-pi ROM* (MT-32 v1, v2, CM-32L) and *MT32-pi SoundFont* (**Pi's own**, the default: the one the MT32-pi has, as set on it; or one of the first eight on its card, 0 to 7). A box names the synth each time it changes; *Reset Hanging Notes* makes the MT32-pi stop all its notes, and the music goes on (the SoundFont stays). All apply at once; the game's *Music Volume* sets its level.

## Frame pacing

Shadow Warrior moves 40 times per second. A 15kHz picture a TV accepts has about 60 fields per second: the core shows 59.64. This build draws exactly one frame per field, with the game's clock taken from the field counter of the core instead of the system clock, and puts everything that moves between its last two positions for the time of that field, as the game does on any monitor that is faster than 40Hz.

The game holds the full rate of one frame per field at 320x200 and 640x200, in the levels it was measured in.

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
