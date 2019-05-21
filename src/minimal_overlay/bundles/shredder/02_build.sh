#!/bin/sh

set -e

. ../../common.sh

echo "Removing previous work area."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir -p $WORK_DIR/overlay/$BUNDLE_NAME
cd $WORK_DIR/overlay/$BUNDLE_NAME

install -d -m755 "$OVERLAY_ROOTFS/etc"
install -d -m755 "$OVERLAY_ROOTFS/etc/autorun"
install -m755 "$SRC_DIR/99_shredder.sh" "$OVERLAY_ROOTFS/etc/autorun/99_shredder.sh"

echo "Shredder scripts have been installed."
