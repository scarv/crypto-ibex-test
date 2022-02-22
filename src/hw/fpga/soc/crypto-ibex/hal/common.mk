PORT   ?= /dev/ttyUSB0
FPGA   ?= $(REPO_HOME)/src/hw/fpga
BIT    ?= $(BUILD)/system_top_wrapper.bit
device ?= xc7k160t_0

HAL_SRCS = $(wildcard $(HAL)/*.c)
INCS := -I$(HAL) -I.
CRT  :=   $(HAL)/crt.S

SRCS = $(PROGRAM).c $(HAL_SRCS) $(EXTRA_SRCS)
C_SRCS = $(filter %.c, $(SRCS))
ASM_SRCS = $(filter %.S, $(SRCS))

CC = $(RISCV)/bin/riscv64-unknown-elf-gcc
CROSS_COMPILE = $(patsubst %-gcc,%-,$(CC))
OBJCOPY ?= $(CROSS_COMPILE)objcopy
OBJDUMP ?= $(CROSS_COMPILE)objdump


ARCH ?= rv32im
CFLAGS ?= -march=$(ARCH) -mabi=ilp32 -static -DPREALLOCATE=1 -mcmodel=medany -std='gnu99' -O2\
	-fno-builtin-printf -nostartfiles -ffreestanding $(PROGRAM_CFLAGS)

OBJS := ${C_SRCS:.c=.o} ${ASM_SRCS:.S=.o} ${CRT:.S=.o}
DEPS  = $(OBJS:%.o=%.d)

OUTFILES := $(PROGRAM).elf $(PROGRAM).bin $(PROGRAM).dis

build: $(OUTFILES)

fpga-download: $(BIT)
	vivado -mode batch -source $(FPGA)/script/program.tcl -tclargs $(device) $(BIT)

fpga-run: build | fpga-download
	$(FPGA)/script/upload.py --port $(PORT) --baud 115200 upload $(PROGRAM).bin --stdout

run: fpga-run
	@mkdir -p $(BUILD)/$(PROGRAM)
	@mv $(OBJS) $(BUILD)/$(PROGRAM)
	@mv $(OUTFILES) $(BUILD)/$(PROGRAM)
	@mv $(DEPS) $(BUILD)/$(PROGRAM)
	@rm -f -r vivado* .Xil

$(PROGRAM).elf: $(OBJS) $(HAL)/lscript.ld
	$(CC) $(CFLAGS) -T $(HAL)/lscript.ld $(OBJS) -o $@ $(LIBS)

%.dis: %.elf
	$(OBJDUMP) -fhSD $^ > $@

%.bin: %.elf
	$(OBJCOPY) -O binary $^ $@

%.o: %.c
	$(CC) $(CFLAGS) -MMD -c $(INCS) -o $@ $<	

%.o: %.S
	$(CC) $(CFLAGS) -MMD -c $(INCS) -o $@ $<

clean:
	@rm -f $(OBJS) $(DEPS)

distclean: clean
	@rm -f $(OUTFILES)
