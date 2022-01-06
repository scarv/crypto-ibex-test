// Copyright (C) 2021 SCARV project <info@scarv.org>
//
// Use of this source code is restricted per the MIT license, a copy of which 
// can be found at https://opensource.org/licenses/MIT (or should be included 
// as LICENSE.txt within the associated archive or repository).

#ifndef __ZKS_H
#define __ZKS_H

// ============================================================================

// bs[1:0]1 1000 |  rs2   |  rs1  | 000 | rd | 0110011
.macro sm4ed    rd, rs1, rs2, bs
.insn r 0x33, 0x0, (\bs << 5) + 0x18, \rd, \rs1, \rs2
.endm
// bs[1:0]1 1010 |  rs2   |  rs1  | 000 | rd | 0110011
.macro sm4ks    rd, rs1, rs2, bs
.insn r 0x33, 0x0, (\bs << 5) + 0x1A, \rd, \rs1, \rs2
.endm

//      0001 0000 1000    |  rs1  | 001 | rd | 0010011 
.macro sm3p0    rd, rs1
.insn i 0x13, 0x1,                    \rd, \rs1, 0x108
.endm
//      0001 0000 1001    |  rs1  | 001 | rd | 0010011 
.macro sm3p1    rd, rs1
.insn i 0x13, 0x1,                    \rd, \rs1, 0x109
.endm
// ============================================================================

#endif
