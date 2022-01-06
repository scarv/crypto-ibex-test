# Copyright (C) 2021 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

# =============================================================================

get-arch-test : 
	@${REPO_HOME}/toolchain/riscv-arch-test-clone.sh
	@${REPO_HOME}/toolchain/riscv-arch-test-apply.sh

arch-test-update : 
	@${REPO_HOME}/toolchain/riscv-arch-test-update.sh

get-gnu-toolchain :
	@${REPO_HOME}/toolchain/toolchain-clone.sh
	@${REPO_HOME}/toolchain/binutils-apply.sh
	@${REPO_HOME}/toolchain/toolchain-build.sh
# =============================================================================
