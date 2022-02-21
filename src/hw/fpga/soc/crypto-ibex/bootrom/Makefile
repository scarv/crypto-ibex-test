bootrom_img = bootrom.img
bootrom_hex = bootrom.mem
bootrom_coe = bootrom.coe
bootrom_dum = bootrom.dum

GCC=$(RISCV)/bin/riscv64-unknown-elf-gcc
OBJCOPY=$(RISCV)/bin/riscv64-unknown-elf-objcopy
OBJDUMP=$(RISCV)/bin/riscv64-unknown-elf-objdump

all: $(bootrom_img) $(bootrom_dum) $(bootrom_hex) $(bootrom_coe)

%.dum: %.elf
	$(OBJDUMP) -Dt $< > $@
%.img: %.bin
	dd if=$< of=$@ bs=2048 count=1

%.mem: %.bin 
	od -t x4 -An -w4 -v $< > $@	

%.coe: %.bin 
	python3 gen_coe.py $< $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.elf : %.S bootloader.c linker.ld
	$(GCC) -march=rv32im -mabi=ilp32 -Tlinker.ld $< bootloader.c -nostdlib -static -Wl,--no-gc-sections -o $@
