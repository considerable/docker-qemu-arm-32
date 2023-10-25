.global _start

.text

.set uart_base, 0x09000000

_start:
    ldr r0, =uart_base  /* data register is at the uart base address */
    ldr r1, =message    /* pointer to first character */
    ldr r2, =#0         /* loop counter */

loop:
    ldrb r3, [r1, r2]   /* load byte from address r1 + offset r2 in r3 */
    cmp r3, #0          /* check for end of string */
    beq halt            /* stop when finished */
    str r3, [r0]        /* else, write byte from r3 to uart data register */
    add r2, r2, #1      /* increment counter */
    b loop              /* loop */

halt:
    b halt

.data
message: .asciz "Hello, world!\n"

