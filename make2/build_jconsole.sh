#!/bin/sh

. ./build_common.sh

TARGET=jconsole$exesuffix

USE_LINENOISE="${USE_LINENOISE:=1}"

if [ "$USE_LINENOISE" -ne "1" ] ; then
 CFLAGS="$CFLAGS -DREADLINE"
else
 CFLAGS="$CFLAGS -DREADLINE -DUSE_LINENOISE"
 OBJSLN="linenoise.o"
fi

LDFLAGS="$LDFLAGS $LDTHREAD"

if $posix; then LDFLAGS="$LDFLAGS -ldl"; fi

if [ $jplatform = windows ]; then
 LDFLAGS="$LDFLAGS -Wl,--stack=0x1000000,--subsystem,console -static-libgcc"
fi

echo "CFLAGS=$CFLAGS"

if [ ! -f ../jsrc/jversion.h ] ; then
  cp ../jsrc/jversion-x.h ../jsrc/jversion.h
fi

mkdir -p ../bin/$jplatform/$j64x
mkdir -p obj/$jplatform/$j64x/
cp makefile-jconsole obj/$jplatform/$j64x/.
export CFLAGS LDFLAGS TARGET OBJSLN jplatform j64x
cd obj/$jplatform/$j64x/
$make -f makefile-jconsole
cd -
