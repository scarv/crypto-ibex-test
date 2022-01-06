# Copyright (C) 2021 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

ifndef REPO_HOME
  $(error "execute 'source ./bin/conf.sh' to configure environment")
endif
ifndef REPO_VERSION
  $(error "execute 'source ./bin/conf.sh' to configure environment")
endif

ifndef RISCV
  $(error "set RISCV environment variable to point at the Risc-V toolchain installation")
endif

ifndef IBEX_REPO
  $(error "set IBEX_REPO environment variable to point at the Ibex reposistory")
endif

export SW_DIR = ${REPO_HOME}/src/sw
export TARGET_SIM = ${IBEX_REPO}/build/lowrisc_ibex_ibex_riscv_compliance_0.1/sim-verilator/Vibex_riscv_compliance

SW ?= test-zkn
IBEX_CONFIG ?= experimental-maxperf-pmp-zkn

sw-program = ${REPO_HOME}/build/$(SW)/$(SW).vmem
sw: $(sw-program)

.PHONY: $(sw-program)
$(sw-program):
	cd $(SW_DIR)/$(SW) && $(MAKE) SW=$(SW)

Vibex_simple_system=$(IBEX_REPO)/build/lowrisc_ibex_ibex_simple_system_0/sim-verilator/Vibex_simple_system
$(Vibex_simple_system):
	make -C ${IBEX_REPO} build-simple-system IBEX_CONFIG=$(IBEX_CONFIG)

build-ibex-simple-system: $(Vibex_simple_system)

run-sw: sw | $(Vibex_simple_system)
	$(Vibex_simple_system) -t --raminit=$(sw-program)
	@mv trace_core_00000000.log ${REPO_HOME}/build/$(SW)
	@mv sim.fst ${REPO_HOME}/build/$(SW)
	@mv ibex_simple_system.log ${REPO_HOME}/build/$(SW)
	@mv ibex_simple_system_pcount.csv ${REPO_HOME}/build/$(SW)

Vibex_arch_test=$(TARGET_SIM)
$(Vibex_arch_test):
	make -C ${IBEX_REPO} build-riscv-compliance IBEX_CONFIG=$(IBEX_CONFIG)

build-arch-test-target: $(Vibex_arch_test)

run-riscv-arch-test: $(Vibex_arch_test)
	make -C ${REPO_HOME}/build/riscv-arch-test/ -B RISCV_TARGET=ibex RISCV_DEVICE=K RISCV_ISA=rv32i RISCV_PREFIX=$(RISCV)/bin/riscv64-unknown-elf-
