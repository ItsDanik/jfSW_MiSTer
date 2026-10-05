#!/bin/sh
# Assemble the MiSTer release in dist/jfSW_<date>/ from the build outputs
set -e
cd "$(dirname "$0")"
DATE=$(date +%Y%m%d)
OUT=dist/jfSW_$DATE
rm -rf "$OUT"
mkdir -p "$OUT/_Other" "$OUT/games/jfSW" "$OUT/Scripts"
cp hybrid/launcher/danik_hybrid_cores.sh "$OUT/Scripts/danik_hybrid_cores.sh"
# a copy with the game too: the daemon installs the newest one it finds
cp hybrid/launcher/danik_hybrid_cores.sh "$OUT/games/jfSW/danik_hybrid_cores.sh"
cp core/output_files/jfSW.rbf "$OUT/_Other/jfSW_$DATE.rbf"
cp -r package/games/jfSW/. "$OUT/games/jfSW/"
cp build/mister/jfsw "$OUT/games/jfSW/jfSW"
hybrid/docker.sh arm-linux-gnueabihf-strip "$OUT/games/jfSW/jfSW"
chmod +x "$OUT/games/jfSW/jfSW" "$OUT"/games/jfSW/*.sh "$OUT/Scripts/danik_hybrid_cores.sh"
cp jfsw/GPL.TXT "$OUT/games/jfSW/LICENSE-jfsw.txt"
cp jfsw/jfbuild/buildlic.txt "$OUT/games/jfSW/BUILDLIC.TXT"
cp build/vorbis/src/libvorbis-*/COPYING "$OUT/games/jfSW/LICENSE-vorbis.txt"
cp build/sdl/src/SDL2-*/LICENSE.txt "$OUT/games/jfSW/LICENSE-sdl.txt"
cp LICENSE "$OUT/games/jfSW/LICENSE-gpl3.txt"
rm -f "dist/jfSW_$DATE.zip"
(cd "$OUT" && python3 -m zipfile -c "../jfSW_$DATE.zip" _Other games Scripts)
find "$OUT" -type f | sort
ls -la "dist/jfSW_$DATE.zip"
