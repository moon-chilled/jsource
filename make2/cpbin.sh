#!/bin/sh

# copy binaries in bin/ to jlibrary/bin

. build_common.sh

if [ $j64x = arm32 ] || [ $j64x = arm64 ]; then

cp ../bin/${jplatform}/j32/jconsole ../jlibrary/bin32/. || true
cp ../bin/${jplatform}/${j64x}/jconsole ../jlibrary/bin/. || true

cp ../bin/${jplatform}/j32/libtsdll.so ../jlibrary/bin32/. || true
cp ../bin/${jplatform}/${j64x}/libtsdll.so ../jlibrary/bin/. || true

cp ../bin/${jplatform}/j32/libj.so ../jlibrary/bin32/. || true
cp ../bin/${jplatform}/${j64x}/libj.so ../jlibrary/bin/. || true

else

cp ../bin/${jplatform}/j32/jconsole ../jlibrary/bin32/. || true
cp ../bin/${jplatform}/j64/jconsole ../jlibrary/bin/. || true
cp ../bin/${jplatform}/j64avx/jconsole ../jlibrary/bin/. || true
cp ../bin/${jplatform}/j64avx2/jconsole ../jlibrary/bin/. || true

cp ../bin/${jplatform}/j32/libtsdll.so ../jlibrary/bin32/. || true
cp ../bin/${jplatform}/j64/libtsdll.so ../jlibrary/bin/. || true
cp ../bin/${jplatform}/j64avx/libtsdll.so ../jlibrary/bin/. || true
cp ../bin/${jplatform}/j64avx2/libtsdll.so ../jlibrary/bin/. || true

cp ../bin/${jplatform}/j32/libj.so ../jlibrary/bin32/. || true
cp ../bin/${jplatform}/j64/libj.so ../jlibrary/bin/libj-nonavx.so || true
cp ../bin/${jplatform}/j64avx/libj.so ../jlibrary/bin/libjavx.so || true
cp ../bin/${jplatform}/j64avx2/libj.so ../jlibrary/bin/libjavx2.so || true
cp ../bin/${jplatform}/j64avx2/libj.so ../jlibrary/bin/. || true

fi
