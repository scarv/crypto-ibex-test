
/* Entry point / "main" function for the target program */
ENTRY(main)

/* Valid physical memory regions which can be used by the linker */
MEMORY {
    /* BRAM 
       - Readable
       - Writable
       - Executable */
    PL_BRAM (wx) : ORIGIN = 0x00001000, LENGTH = 252K
}

SECTIONS {
    /* Trampoline for getting to the reset handler */
    .text 0x00001000 : { *(.text.riscv_reset) } > PL_BRAM

    /* Trampoline for getting to the interrupt handler */
    .text 0x00001010 : { *(.text.riscv_irq_handler) } > PL_BRAM

    /* The rest of the program code goes here */
    .text : { *(.text) } > PL_BRAM
    .data : { *(.data) } > PL_BRAM
    .bss  : { *(.bss ) } > PL_BRAM

    /* Don't include the .comment section anywhere */
    /DISCARD/ : { *(.comment) }
}

