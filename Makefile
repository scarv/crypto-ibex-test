# Copyright (C) 2021 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

ifndef REPO_HOME
  $(error "execute 'source ./bin/conf.sh' to configure environment")
endif

# =============================================================================

get-gnu-toolchain :
	@make -C toolchain/ get-gnu-toolchain

get-arch-test :
	@make -C toolchain/ get-arch-test

get-crypto-ibex :
	@make -C src/hw/ ibex-clone

# -----------------------------------------------------------------------------

run-zkn-arch-test :
	@make -C src/hw/ -B run-riscv-arch-test IBEX_CONFIG=experimental-maxperf-pmp-zkn 

run-zks-arch-test :
	@make -C src/hw/ -B run-riscv-arch-test IBEX_CONFIG=experimental-maxperf-pmp-zks

run-zkn-random-test :
	@make -C src/hw/ -B build-ibex-simple-system IBEX_CONFIG=experimental-maxperf-pmp-zkn
	@make -C src/sw/test-zkn -B run TARGET=${REPO_HOME}/src/hw/emul

run-zks-random-test :
	@make -C src/hw/ -B build-ibex-simple-system IBEX_CONFIG=experimental-maxperf-pmp-zks
	@make -C src/sw/test-zks -B run TARGET=${REPO_HOME}/src/hw/emul

fpga-zkn-random-test :
	@make -C src/hw/ bitstream RVK=Zkn
	@make -C src/sw/test-zkn -B run TARGET=${REPO_HOME}/src/hw/fpga/soc/crypto-ibex

fpga-zks-random-test :
	@make -C src/hw/ bitstream RVK=Zks
	@make -C src/sw/test-zks -B run TARGET=${REPO_HOME}/src/hw/fpga/soc/crypto-ibex

# -----------------------------------------------------------------------------

clean :
	@rm --force --recursive ${REPO_HOME}/build/*

# =============================================================================
