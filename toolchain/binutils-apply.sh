#!/bin/bash

source $REPO_HOME/toolchain/share.sh

set -e
set -x

# ------ Binutils ----------------------------------------------------------

cd           $DIR_BINUTILS
git apply    $PATCH_BINUTILS --whitespace=nowarn
git add      --all

