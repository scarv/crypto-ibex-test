#!/bin/bash

source $REPO_HOME/toolchain/share.sh

set -e
set -x

# ------ riscv-arch-test ----------------------------------------------------------

cd           $DIR_ARCH_TEST
git apply    $PATCH_ARCH_TEST --whitespace=nowarn
git add      --all

