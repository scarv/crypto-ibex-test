// Copyright (C) 2021 SCARV project <info@scarv.org>
//
// Use of this source code is restricted per the MIT license, a copy of which 
// can be found at https://opensource.org/licenses/MIT (or should be included 
// as LICENSE.txt within the associated archive or repository).

#ifndef __ZKND_H
#define __ZKND_H

// ============================================================================

// bs[1:0]1 0101 |  rs2   |  rs1  | 000 | rd | 0110011
.macro aes32dsi    rd, rs1, rs2, bs
.insn r 0x33, 0x0, (\bs << 5) + 0x15, \rd, \rs1, \rs2
.endm
// bs[1:0]1 0111 |  rs2   |  rs1  | 000 | rd | 0110011
.macro aes32dsmi    rd, rs1, rs2, bs
.insn r 0x33, 0x0, (\bs << 5) + 0x17, \rd, \rs1, \rs2
.endm
//      001 1101 |  rs2   |  rs1  | 000 | rd | 0110011 
.macro aes64ds   rd, rs1, rs2
.insn r 0x33, 0x0,              0x1D, \rd, \rs1, \rs2
.endm
//      001 1111 |  rs2   |  rs1  | 000 | rd | 0110011 
.macro aes64dsm  rd, rs1, rs2
.insn r 0x33, 0x0,              0x1F, \rd, \rs1, \rs2
.endm
//      0011 0000 0000    |  rs1  | 001 | rd | 0010011 
.macro aes64im   rd, rs1
.insn i 0x13, 0x1,                    \rd, \rs1, 0x300
.endm
#ifndef __ZKNE_H
//      0011 0001 rnum[3:0]|  rs1  | 001 | rd | 0010011
.macro aes64ks1i  rd, rs1, rnum
.insn i 0x13, 0x1,                    \rd, \rs1, (0x31 << 4) + \rnum
.endm
//      011 1111 |  rs2   |  rs1  | 000 | rd | 0110011
.macro aes64ks2 rd, rs1, rs2
.insn r 0x33, 0x0,              0x3F, \rd, \rs1, \rs2
.endm
#endif
// ============================================================================

#endif
