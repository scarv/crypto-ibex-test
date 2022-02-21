/* ------------------------------------------------------------*/

.section .text

#
# Whenever the core is reset, we end up here from reset_vector_landing
#
.section .text.riscv_reset
riscv_reset_handler:
    addi  sp,sp,-8
    sw    ra,4(sp)                      # Push current return address

    # Jump to main.
    call   main

    lw    ra,4(sp)                      # get back return address
    addi  sp,sp,8
    ret

#
# We land here after any environment call
#
#.global riscv_irq_handler
#riscv_irq_handler:
#    sw    ra,4(sp)                      # Push current return address
#    addi  sp, sp, 0x4                   # to the stack before call.
#    call  riscv_irq_delegated_handler   # Jump to the delegated handler.
#    mret

