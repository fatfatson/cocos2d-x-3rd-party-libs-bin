#!/bin/bash
set -x 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DESTDIR=$DIR/prebuilt/android
NDK=$NDK_ROOT
NDKABI=13

cd src

#x86
NDKP=$NDK/toolchains/x86-4.9/prebuilt/darwin-x86_64/bin/i686-linux-android-
NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-x86"
make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_SYS=Linux TARGET_FLAGS="$NDKF" XCFLAGS="-DLUAJIT_NO_LOG2" clean all
if [ $? -ne 0 ]; then exit 1; fi
cp src/libluajit.a $DESTDIR/x86/

#arm
NDKP=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-
NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-arm"
make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_SYS=Linux TARGET_FLAGS="$NDKF" clean all
if [ $? -ne 0 ]; then exit 1; fi
cp src/libluajit.a $DESTDIR/armeabi/

#arm v7a
NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-arm -march=armv7-a -Wl,--fix-cortex-a8"
make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_SYS=Linux TARGET_FLAGS="$NDKF" clean all
if [ $? -ne 0 ]; then exit 1; fi
cp src/libluajit.a $DESTDIR/armeabi-v7a/
