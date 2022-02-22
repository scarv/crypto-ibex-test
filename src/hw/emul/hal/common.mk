# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

HAL_SRCS = $(wildcard $(HAL)/*.c)
INCS := -I$(HAL) -I.
CRT  :=   $(HAL)/crt0.S

SRCS = $(PROGRAM).c $(HAL_SRCS) $(EXTRA_SRCS)
C_SRCS = $(filter %.c, $(SRCS))
ASM_SRCS = $(filter %.S, $(SRCS))

CC = $(RISCV)/bin/riscv64-unknown-elf-gcc
CROSS_COMPILE = $(patsubst %-gcc,%-,$(CC))
OBJCOPY ?= $(CROSS_COMPILE)objcopy
OBJDUMP ?= $(CROSS_COMPILE)objdump

EMU ?= $(BUILD)/Vibex_simple_system

ARCH ?= rv32im
CFLAGS ?= -march=$(ARCH) -mabi=ilp32 -static -mcmodel=medany -Wall -g -Os\
	-fvisibility=hidden -nostdlib -nostartfiles -ffreestanding $(PROGRAM_CFLAGS)

OBJS := ${C_SRCS:.c=.o} ${ASM_SRCS:.S=.o} ${CRT:.S=.o}
DEPS  = $(OBJS:%.o=%.d)

OUTFILES := $(PROGRAM).elf $(PROGRAM).vmem $(PROGRAM).bin $(PROGRAM).dis

build: $(OUTFILES)

emulate: build | $(EMU)
	$(EMU) -t --raminit=$(PROGRAM).vmem

run: emulate
	@mkdir -p $(BUILD)/$(PROGRAM)
	@mv $(OBJS) $(BUILD)/$(PROGRAM)
	@mv $(OUTFILES) $(BUILD)/$(PROGRAM)
	@mv $(DEPS) $(BUILD)/$(PROGRAM)
	@mv trace_core_00000000.log ${BUILD}/$(PROGRAM)
	@mv sim.fst ${BUILD}/$(PROGRAM)
	@mv ibex_simple_system.log ${BUILD}/$(PROGRAM)
	@mv ibex_simple_system_pcount.csv ${BUILD}/$(PROGRAM)

$(PROGRAM).elf: $(OBJS) $(HAL)/link.ld
	$(CC) $(CFLAGS) -T $(HAL)/link.ld $(OBJS) -o $@ $(LIBS)

%.dis: %.elf
	$(OBJDUMP) -fhSD $^ > $@

%.vmem: %.bin
	srec_cat $^ -binary -offset 0x0000 -byte-swap 4 -o $@ -vmem

%.bin: %.elf
	$(OBJCOPY) -O binary $^ $@

%.o: %.c
	$(CC) $(CFLAGS) -MMD -c $(INCS) -o $@ $<	

%.o: %.S
	$(CC) $(CFLAGS) -MMD -c $(INCS) -o $@ $<

clean:
	$(RM) -f $(OBJS) $(DEPS)

distclean: clean
	$(RM) -f $(OUTFILES)
