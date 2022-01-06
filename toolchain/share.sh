if [ -z $RISCV_ARCH ] ; then
    export RISCV_ARCH=riscv64-unknown-elf
fi

DIR_ARCH_TEST=$REPO_HOME/build/riscv-arch-test
DIR_TOOLCHAIN=$REPO_HOME/build/riscv-gnu-toolchain
DIR_GCC=$DIR_TOOLCHAIN/riscv-gcc
DIR_BINUTILS=$DIR_TOOLCHAIN/riscv-binutils
DIR_NEWLIB=$DIR_TOOLCHAIN/riscv-newlib

DIR_TOOLCHAIN_BUILD=$DIR_TOOLCHAIN/build

BRANCH_NAME=crypto-ibex

INSTALL_DIR=$RISCV
TARGET_ARCH=$RISCV_ARCH

#
# Patch files
PATCH_ARCH_TEST=$REPO_HOME/toolchain/patch-arch-test.patch
PATCH_BINUTILS=$REPO_HOME/toolchain/patch-binutils.patch

#
# Known good commits

ARCH_TEST_COMMIT=307c77b26e070ae85ffea665ad9b642b40e33c86
BINUTILS_COMMIT=3e5f50f31348d05144966545d862a3172d315230 # Points at riscv-binutils-2.35-rvb
GCC_COMMIT=c3911e6425f

#
# Check that a directory exists and exit if not.
#
function check_dir {
if [ ! -d $1 ]; then
    echo "$1 does not exist." ; exit 1
fi
}

#
# Check if the directory exists. If so, delete it and create fresh.
#
function refresh_dir {
if [ -d $1 ]; then
    rm -rf $1
fi
mkdir -p $1
}
