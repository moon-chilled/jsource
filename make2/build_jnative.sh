#!/bin/sh

. build_common.sh

TARGET="${libprefix}jnative.${libsuffix}"

if $linuxish; then
 LDFLAGS="-shared -Wl,-soname,libjnative.so"
elif [ $jplatform = darwin ]; then
 LDFLAGS="$LDFLAGS -dynamiclib"
fi

if $posix; then
 CFLAGS="$CFLAGS -I$JAVA_HOME/include -I$JAVA_HOME/include/$jplatform"
fi

echo "CFLAGS=$CFLAGS"

mkdir -p ../bin/$jplatform/$j64x
mkdir -p obj/$jplatform/$j64x/
cp makefile-jnative obj/$jplatform/$j64x/.
export CFLAGS LDFLAGS TARGET jplatform j64x
cd obj/$jplatform/$j64x/
$make -f makefile-jnative
cd -
