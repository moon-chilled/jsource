#!/bin/sh

. ./build_common.sh

TARGET="${libprefix}tsdll.${libsuffix}"

LDFLAGS="$LDFLAGS -lm -ldl"
if [ $j64x = j32 ]; then LDFLAGS="$LDFLAGS -m32"; fi
if $linuxish; then
 LDFLAGS="$LDFLAGS -shared -Wl,-soname,libtsdll.so"
elif [ $jplatform = darwin ]; then
 LDFLAGS="$LDFLAGS -dynamiclib"
fi

echo "CFLAGS=$CFLAGS"

mkdir -p ../bin/$jplatform/$j64x
mkdir -p obj/$jplatform/$j64x/
cp makefile-tsdll obj/$jplatform/$j64x/.
export CFLAGS LDFLAGS TARGET jplatform j64x
cd obj/$jplatform/$j64x/
$make -f makefile-tsdll
cd -
