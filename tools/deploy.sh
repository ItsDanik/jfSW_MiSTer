#!/bin/sh
# Package the build and copy it to a MiSTer over ssh.
# usage: MISTER=root@<address> tools/deploy.sh
# The core is not (re)loaded: load jfSW from the menu afterwards. Run
# /media/fat/Scripts/danik_hybrid_cores.sh on the MiSTer once to set up the launcher.
set -e
cd "$(dirname "$0")/.."
HOST=${MISTER:?set MISTER=root@<address of the MiSTer>}
./package.sh > /dev/null
OUT=dist/jfSW_$(date +%Y%m%d)
G=/media/fat/games/jfSW
ssh "$HOST" "mkdir -p $G && rm -f /media/fat/_Other/jfSW_*.rbf"
# a running game keeps its binary busy: copy next to it, then swap
# (scp would copy into a folder of that name, if something left one behind)
ssh "$HOST" "rm -rf $G/jfSW.new"
scp -q "$OUT/games/jfSW/jfSW" "$HOST:$G/jfSW.new"
ssh "$HOST" "mv -f $G/jfSW.new $G/jfSW"
# everything else of the package (user files on the MiSTer are left alone)
(cd "$OUT/games/jfSW" && tar cf - --exclude=./jfSW .) | ssh "$HOST" "tar xf - --no-same-owner -C $G"
scp -q "$OUT/Scripts/danik_hybrid_cores.sh" "$HOST:/media/fat/Scripts/"
scp -q "$OUT"/_Other/*.rbf "$HOST:/media/fat/_Other/"
ssh "$HOST" "chmod +x $G/jfSW $G/*.sh /media/fat/Scripts/danik_hybrid_cores.sh; ls -la $G /media/fat/_Other/jfSW_*.rbf"
