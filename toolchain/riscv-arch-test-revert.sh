#!/bin/bash

source $REPO_HOME/toolchain/share.sh

set -e
set -x

# ------ riscv-arch-test ----------------------------------------------------------

cd           $DIR_ARCH_TEST
git reset HEAD
git checkout .
git clean -df


