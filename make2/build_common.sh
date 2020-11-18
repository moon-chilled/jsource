# common helper functions and probes for all build scripts

if [ "x$jplatform" = x ]; then
 if [ "`uname`" = "Darwin" ]; then
  jplatform=darwin
 elif [ "`uname`" = "FreeBSD" ]; then
  jplatform=freebsd
 else
  jplatform=linux
 fi
fi

# linuxish = vaguely linux-like system; elf binaries, gcc or clang, binutils or lld, etc.
case $jplatform in
 linux|freebsd) jposix=true; jlinuxish=true ;;
 darwin) jposix=true; jlinuxish=false ;;
 *) jposix=false; jlinuxish=false ;;
esac

if [ "x$j64x" = x ]; then
 if [ "`uname -m`" = "armv6l" ]; then
  j64x=arm32
 elif [ "`uname -m`" = "x86_64" ]; then
  j64x=j64avx
 elif [ "`uname -m`" = "aarch64" ]; then
  j64x=arm64
 else
  j64x=j32
 fi
fi

if [ $jplatform = freebsd ]; then
make="${make:=gmake}"
else
make="${make:=make}"
fi

# gcc 5 vs 4 - killing off linux asm routines (overflow detection)
# new fast code uses builtins not available in gcc 4
# use -DC_NOMULTINTRINSIC to continue to use more standard c in version 4
# too early to move main linux release package to gcc 5

macmin="-mmacosx-version-min=10.6"

if [ "x$CC" = x'' ] ; then
if [ -f "/usr/bin/cc" ]; then
CC=cc
else
if [ -f "/usr/bin/clang" ]; then
CC=clang
else
CC=gcc
fi
fi
export CC
fi
# compiler=`$CC --version | head -n 1`
compiler=$(readlink -f $(command -v $CC) 2> /dev/null || echo $CC)
echo "CC=$CC"
echo "compiler=$compiler"

USE_OPENMP="${USE_OPENMP:=0}"
if [ $USE_OPENMP -eq 1 ] ; then
if [ -z "${jplatform##*darwin*}" ]; then
# assume libomp installed at /usr/local/opt/libomp
OPENMP=" -Xpreprocessor -fopenmp -I/usr/local/opt/libomp/include "
LDOPENMP=" -L/usr/local/opt/libomp/lib -Wl,-rpath,/usr/local/opt/libomp/lib -lomp "
else
OPENMP=" -fopenmp "
LDOPENMP=" -fopenmp "
if [ -z "${compiler##*gcc*}" ] || [ -z "${CC##*gcc*}" ]; then
LDOPENMP32=" -l:libgomp.so.1 "    # gcc
else
if [ -f /etc/redhat-release ] ; then
LDOPENMP32=" -l:libomp.so "     # clang
else
LDOPENMP32=" -l:libomp.so.5 "     # clang
fi
fi
fi
if [ $j64x = j32 ]; then LDOPENMP=LDOPENMP32; fi
fi

if [ -z "${compiler##*gcc*}" ] || [ -z "${CC##*gcc*}" ]; then
# gcc
common="$OPENMP -fPIC -O2 -fvisibility=hidden -fno-strict-aliasing  \
 -Werror -Wextra -Wno-unknown-warning-option \
 -Wno-cast-function-type \
 -Wno-clobbered \
 -Wno-empty-body \
 -Wno-format-overflow \
 -Wno-implicit-fallthrough \
 -Wno-maybe-uninitialized \
 -Wno-missing-field-initializers \
 -Wno-parentheses \
 -Wno-pointer-sign \
 -Wno-shift-negative-value \
 -Wno-sign-compare \
 -Wno-type-limits \
 -Wno-uninitialized \
 -Wno-unused-parameter \
 -Wno-return-local-addr \
 -Wno-unused-value "
else
# clang
common="$OPENMP -fPIC -O2 -fvisibility=hidden -fno-strict-aliasing \
 -Werror -Wextra -Wno-unknown-warning-option \
 -Wsign-compare \
 -Wtautological-constant-out-of-range-compare \
 -Wuninitialized \
 -Wno-char-subscripts \
 -Wno-consumed \
 -Wno-delete-non-abstract-non-virtual-dtor \
 -Wno-empty-body \
 -Wno-implicit-float-conversion \
 -Wno-implicit-int-float-conversion \
 -Wno-int-in-bool-context \
 -Wno-missing-braces \
 -Wno-parentheses \
 -Wno-pass-failed \
 -Wno-pointer-sign \
 -Wno-string-plus-int \
 -Wno-unknown-pragmas \
 -Wno-unsequenced \
 -Wno-unused-function \
 -Wno-unused-parameter \
 -Wno-unused-value \
 -Wno-unused-variable "
fi

if $linuxish; then
 libprefix="lib"
 libsuffix="so"
 exesuffix=""
elif [ $jplatform = darwin ]; then
 libprefix="lib"
 libsuffix="dylib"
 exesuffix=""
elif [ $jplatform = windows ]; then
 libprefix=""
 libsuffix="dll"
 exesuffix=".exe"
fi

CFLAGS="$common"
LDFLAGS=""

if [ $jplatform = darwin ]; then
 CFLAGS="$CFLAGS $macmin"
 LDFLAGS="$LDFLAGS $macmin"
fi

if [ $j64x = j32 ]; then
 # faster, but sse2 not available for 32-bit amd cpu
 # sse does not support mfpmath=sse in 32-bit gcc
 CFLAGS="$CFLAGS -m32 -msse2 -mfpmath=sse"
 # slower, use 387 fpu and truncate extra precision
 # CFLAGS="$CFLAGS -m32 -ffloat-store "

 LDFLAGS="$LDFLAGS -m32"
elif [ $j64x = arm32 ]; then
 CFLAGS="$CFLAGS -marm -march=armv6 -mfloat-abi=hard -mfpu=vfp"
elif [ $j64x = arm64 ]; then
 CFLAGS="$CFLAGS -march=armv8-a+crc -DC_CRC32C=1"
fi
