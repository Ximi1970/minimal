#!/bin/sh

set -e

. ../../common.sh

cd $WORK_DIR/overlay/$BUNDLE_NAME

# Change to the bash source directory which ls finds, e.g. 'bash-4.4.18'.
cd $(ls -d bash-*)

if [ -f Makefile ] ; then
  echo "Preparing '$BUNDLE_NAME' work area. This may take a while."
  make -j $NUM_JOBS clean
else
  echo "The clean phase for '$BUNDLE_NAME' has been skipped."
fi

rm -rf $DEST_DIR

echo "Configuring '$BUNDLE_NAME'."
CFLAGS="$CFLAGS" ./configure \
    --prefix=/usr \
    --with-curses\
    --with-afs \
    --with-gnu-ld \
    --enable-job-control \
    --enable-net-redirections \
    --enable-alias \
    --enable-readline \
    --enable-history \
    --enable-bang-history \
    --enable-directory-stack \
    --enable-process-substitution \
    --enable-prompt-string-decoding \
    --enable-select \
    --enable-help-builtin \
    --enable-separate-helpfiles \
    --enable-array-variables \
    --enable-brace-expansion \
    --enable-command-timing \
    --enable-disabled-builtins \
    --enable-glob-asciiranges-default \
    --disable-strict-posix-default \
    --enable-multibyte \
    CFLAGS="-I$WORK_DIR/overlay/ncurses/ncurses_installed/usr/include $CFLAGS" \
    LDFLAGS="-L$WORK_DIR/overlay/ncurses/ncurses_installed/usr/lib"

echo "Building '$BUNDLE_NAME'."
make -j $NUM_JOBS

echo "Installing '$BUNDLE_NAME'."
make -j $NUM_JOBS install DESTDIR=$DEST_DIR

echo "Reducing '$BUNDLE_NAME' size."
reduce_size $DEST_DIR/usr/bin

# With '--remove-destination' all possibly existing soft links in
# '$OVERLAY_ROOTFS' will be overwritten correctly.
cp -r --remove-destination $DEST_DIR/usr/* \
  $OVERLAY_ROOTFS

echo "Bundle '$BUNDLE_NAME' has been installed."

cd $SRC_DIR
