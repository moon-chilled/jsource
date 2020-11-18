#!/bin/sh

. ./build_common.sh

USE_SLEEF_SRC="${USE_SLEEF_SRC:=1}"
if [ -z "${j64x##*32*}" ]; then
# USE_SLEEF="${USE_SLEEF:=1}"
USE_SLEEF=0
else
USE_SLEEF="${USE_SLEEF:=1}"
fi
if [ $USE_SLEEF -eq 1 ] ; then
CFLAGS="$CFLAGS -DSLEEF=1"
else
USE_SLEEF_SRC=0
fi

if [ -z "${j64x##*32*}" ]; then
USE_EMU_AVX=0
else
USE_EMU_AVX="${USE_EMU_AVX:=1}"
fi
if [ $USE_EMU_AVX -eq 1 ] ; then
CFLAGS="$CFLAGS -DEMU_AVX=1"
fi

NO_SHA_ASM="${NO_SHA_ASM:=0}"

if [ $NO_SHA_ASM -ne 0 ] ; then

CFLAGS="$CFLAGS -DNO_SHA_ASM"

else

SRC_ASM_LINUXISH=" \
 keccak1600-x86_64-elf.o \
 sha1-x86_64-elf.o \
 sha256-x86_64-elf.o \
 sha512-x86_64-elf.o "

SRC_ASM_LINUXISH32=" \
 keccak1600-mmx-elf.o \
 sha1-586-elf.o \
 sha256-586-elf.o \
 sha512-586-elf.o "

SRC_ASM_ARM=" \
 keccak1600-armv8-elf.o \
 sha1-armv8-elf.o \
 sha256-armv8-elf.o \
 sha512-armv8-elf.o "

SRC_ASM_ARM32=" \
 keccak1600-armv4-elf.o \
 sha1-armv4-elf.o \
 sha256-armv4-elf.o \
 sha512-armv4-elf.o "

SRC_ASM_MAC=" \
 keccak1600-x86_64-macho.o \
 sha1-x86_64-macho.o \
 sha256-x86_64-macho.o \
 sha512-x86_64-macho.o "

SRC_ASM_MAC32=" \
 keccak1600-mmx-macho.o \
 sha1-586-macho.o \
 sha256-586-macho.o \
 sha512-586-macho.o "

OBJS_ASM_WIN=" \
 ../../../../openssl-asm/keccak1600-x86_64-nasm.o \
 ../../../../openssl-asm/sha1-x86_64-nasm.o \
 ../../../../openssl-asm/sha256-x86_64-nasm.o \
 ../../../../openssl-asm/sha512-x86_64-nasm.o "

OBJS_ASM_WIN32=" \
 ../../../../openssl-asm/keccak1600-mmx-nasm.o \
 ../../../../openssl-asm/sha1-586-nasm.o \
 ../../../../openssl-asm/sha256-586-nasm.o \
 ../../../../openssl-asm/sha512-586-nasm.o "

fi

OBJS_BASE64=" \
  ../../../../base64/lib/arch/avx2/codec-avx2.o \
  ../../../../base64/lib/arch/generic/codec-generic.o \
  ../../../../base64/lib/arch/neon64/codec-neon64.o \
  ../../../../base64/lib/arch/ssse3/codec-ssse3.o \
  ../../../../base64/lib/arch/sse41/codec-sse41.o \
  ../../../../base64/lib/arch/sse42/codec-sse42.o \
  ../../../../base64/lib/arch/avx/codec-avx.o \
  ../../../../base64/lib/lib.o \
  ../../../../base64/lib/codec_choose.o \
  ../../../../base64/lib/tables/tables.o \
"

OBJS_AESNI=""

TARGET="${libprefix}j.${libsuffix}"

GASM_FLAGS=""
LDFLAGS="$LDFLAGS -lm $LDOPENMP $LDTHREAD"

if [ $j64x = j32 ]; then GASM_FLAGS="$GASM_FLAGS -m32"; fi

if [ $j64x = j32 ] || [ $j64x = j64 ]; then OBJS_AESNI="aes-ni.o"; fi

if $jposix; then LDFLAGS="$LDFLAGS -ldl"; fi

if $jlinuxish; then LDFLAGS="$LDFLAGS -shared -Wl,-soname,libj.so"; fi

if [ $jplatform = darwin ]; then
 LDFLAGS="$LDFLAGS -dynamiclib"
 GASM_FLAGS="$GASM_FLAGS $macmin"
fi

case $j64x in
 j32)
 FLAGS_SLEEF="-DENABLE_SSE2"
 FLAGS_BASE64=""
 ;;
 j64)
 CFLAGS="$CFLAGS -msse3"
 FLAGS_SLEEF="-DENABLE_SSE2"
 FLAGS_BASE64=""
 ;;
 j64avx)
 CFLAGS="$CFLAGS -DC_AVX=1"
 CFLAGS_SIMD="-mavx"
 FLAGS_SLEEF="-DENABLE_AVX"
 FLAGS_BASE64=" -DHAVE_SSSE3=1 -DHAVE_AVX=1 "
 OBJS_FMA="gemm_int-fma.o"
 ;;
 j64avx2)
 CFLAGS="$CFLAGS -DC_AVX=1 -DC_AVX2=1"
 CFLAGS_SIMD="-mavx2 -mfma"
 FLAGS_SLEEF=" -DENABLE_AVX2 "
 FLAGS_BASE64=" -DHAVE_AVX2=1 "
 OBJS_FMA="gemm_int-fma.o"
 ;;
 arm32)
 FLAGS_SLEEF=" -DENABLE_VECEXT "    # ENABLE_NEON32 single precision, useless
 FLAGS_BASE64=""
 ;;
 arm64)
 FLAGS_SLEEF=" -DENABLE_ADVSIMD "
 FLAGS_BASE64=" -DHAVE_NEON64=1 "
 ;;
esac

if $jlinuxish; then
 case $j64x in
  j32) SRC_ASM="$SRC_ASM_LINUXISH32" ;;
  j64|j64avx|j64avx2) SRC_ASM="$SRC_ASM_LINUXISH" ;;
  arm32)
  SRC_ASM="$SRC_ASM_ARM32"
  ;;
  arm64)
  SRC_ASM="$SRC_ASM_ARM"
  OBJS_AESARM="aes-arm.o"
  ;;
 esac
elif [ $jplatform = darwin ]; then
 if [ $j64x = j32 ]; then SRC_ASM="$SRC_ASM_MAC32"
 else SRC_ASM="$SRC_ASM_MAC"
 fi
 if [ $j64x = j64avx ] || [ $j64x = j64avx2 ]; then OBJS_FMA="gemm_int-fma.o"; fi
elif [ $jplatform = windows ]; then
 jolecom="${jolecom:=0}"
 if [ $jolecom -eq 1 ]; then DOLECOM="-DOLECOM"; fi
 CFLAGS="$CFLAGS $DOLECOM -D_FILE_OFFSET_BITS=64 -D_JDLL "
 LDFLAGS="$LDFLAGS -shared -Wl,--enable-stdcall-fixup -static-libgcc -static-libstdc++"
 if [ $jolecom -eq 1 ]; then
  DLLOBJS=" jdll.o jdllcomx.o "
  LIBJDEF=" ../../../../dllsrc/jdll.def "
 else
  DLLOBJS=" jdll.o "
  LIBJDEF=" ../../../../dllsrc/jdll2.def "
 fi
 LIBJRES=" jdllres.o "
 if [ $j64x = j32 ]; then
  SRC_ASM="$SRC_ASM_WIN32"
  OBJS_ASM="$OBJS_ASM_WIN32"
 else
  SRC_ASM="$SRC_ASM_WIN"
  OBJS_ASM="$OBJS_ASM_WIN"
 fi
fi

if [ $USE_SLEEF -eq 1 ] ; then
if [ $USE_SLEEF_SRC -eq 1 ] ; then
OBJS_SLEEF=" \
 ../../../../sleef/src/common/arraymap.o \
 ../../../../sleef/src/common/common.o \
 ../../../../sleef/src/libm/rempitab.o \
 ../../../../sleef/src/libm/sleefsimddp.o \
 "
fi
fi

echo "CFLAGS=$CFLAGS"

if [ ! -f ../jsrc/jversion.h ] ; then
  cp ../jsrc/jversion-x.h ../jsrc/jversion.h
fi

mkdir -p ../bin/$jplatform/$j64x
mkdir -p obj/$jplatform/$j64x/
cp makefile-libj obj/$jplatform/$j64x/.
export CFLAGS LDFLAGS TARGET CFLAGS_SIMD GASM_FLAGS FLAGS_SLEEF FLAGS_BASE64 DLLOBJS LIBJDEF LIBJRES OBJS_BASE64 OBJS_FMA OBJS_AESNI OBJS_AESARM OBJS_SLEEF OBJS_ASM SRC_ASM jplatform j64x
cd obj/$jplatform/$j64x/
$make -f makefile-libj
