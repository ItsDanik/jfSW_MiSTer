#!/bin/sh
# Build static libogg and libvorbis: the game plays its music, the tracks of
# the CD as Ogg Vorbis files, with them.
# Runs inside the toolchain container (see hybrid/docker.sh).
# usage: vorbis.sh <mister|host> <work directory> <prefix to install to>
set -e
TARGET=$1
WORK=$(mkdir -p "$2" && cd "$2" && pwd)
PREFIX=$3
HYBRID=$(cd "$(dirname "$0")/../hybrid" && pwd)

OGG=libogg-1.3.5
VORBIS=libvorbis-1.3.7

[ -f "$PREFIX/lib/libvorbisfile.a" ] && exit 0

fetch() { # <tarball> <url> <sha256>
    [ -f "$WORK/dl/$1" ] || curl -fsSL -o "$WORK/dl/$1" "$2"
    echo "$3  $WORK/dl/$1" | sha256sum -c - > /dev/null
}
mkdir -p "$WORK/dl" "$WORK/src" "$WORK/$TARGET"
fetch $OGG.tar.gz https://downloads.xiph.org/releases/ogg/$OGG.tar.gz \
    0eb4b4b9420a0f51db142ba3f9c64b333f826532dc0f48c6410ae51f4799b664
fetch $VORBIS.tar.gz https://downloads.xiph.org/releases/vorbis/$VORBIS.tar.gz \
    0e982409a9c3fc82ee06e08205b1355e5c6aa4c36bca58146ef399621b0ce5ab
for p in $OGG $VORBIS; do
    [ -d "$WORK/src/$p" ] || tar -xzf "$WORK/dl/$p.tar.gz" -C "$WORK/src"
done

COMMON="-DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_PREFIX_PATH=$PREFIX -DCMAKE_INSTALL_LIBDIR=lib -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=OFF"
if [ "$TARGET" = mister ]; then
    COMMON="$COMMON -DCMAKE_TOOLCHAIN_FILE=$HYBRID/toolchain/mister.cmake -DCMAKE_FIND_ROOT_PATH=$PREFIX"
fi
for p in $OGG $VORBIS; do
    cmake -S "$WORK/src/$p" -B "$WORK/$TARGET/$p" $COMMON -DBUILD_TESTING=OFF > "$WORK/$TARGET/$p.log" 2>&1
    cmake --build "$WORK/$TARGET/$p" -j"$(nproc)" >> "$WORK/$TARGET/$p.log"
    cmake --install "$WORK/$TARGET/$p" >> "$WORK/$TARGET/$p.log"
done
echo "libogg and libvorbis for $TARGET installed in $PREFIX"
