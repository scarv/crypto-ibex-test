// Copyright (C) 2021 SCARV project <info@scarv.org>
//
// Use of this source code is restricted per the MIT license, a copy of which 
// can be found at https://opensource.org/licenses/MIT (or should be included 
// as LICENSE.txt within the associated archive or repository).

#ifndef __ZKNH_H
#define __ZKNH_H

// ============================================================================

// 000 1000 | 00000 | rs1 | 001 | rd | 001 0011
.macro sha256sum0 rd, rs1
.insn i 0x13, 0x1, \rd, \rs1, 0x100
.endm
// 000 1000 | 00001 | rs1 | 001 | rd | 001 0011
.macro sha256sum1 rd, rs1
.insn i 0x13, 0x1, \rd, \rs1, 0x101
.endm
// 000 1000 | 00010 | rs1 | 001 | rd | 001 0011
.macro sha256sig0 rd, rs1
.insn i 0x13, 0x1, \rd, \rs1, 0x102
.endm
// 000 1000 | 00011 | rs1 | 001 | rd | 001 0011
.macro sha256sig1 rd, rs1
.insn i 0x13, 0x1, \rd, \rs1, 0x103
.endm
// 000 1000 | 00100 | rs1 | 001 | rd | 001 0011
.macro sha512sum0 rd, rs1
.insn i 0x13, 0x1, \rd, \rs1, 0x104
.endm
// 000 1000 | 00101 | rs1 | 001 | rd | 001 0011
.macro sha512sum1 rd, rs1
.insn i 0x13, 0x1, \rd, \rs1, 0x105
.endm
// 000 1000 | 00110 | rs1 | 001 | rd | 001 0011
.macro sha512sig0 rd, rs1
.insn i 0x13, 0x1, \rd, \rs1, 0x106
.endm
// 000 1000 | 00111 | rs1 | 001 | rd | 001 0011
.macro sha512sig1 rd, rs1
.insn i 0x13, 0x1, \rd, \rs1, 0x107
.endm

// 010 1000 | rs2   | rs1 | 000 | rd | 011 0011
.macro sha512sum0r rd, rs1, rs2
.insn r 0x33, 0x0, 0x28, \rd, \rs1, \rs2
.endm
// 010 1001 | rs2   | rs1 | 000 | rd | 011 0011
.macro sha512sum1r rd, rs1, rs2
.insn r 0x33, 0x0, 0x29, \rd, \rs1, \rs2
.endm
// 010 1010 | rs2   | rs1 | 000 | rd | 011 0011
.macro sha512sig0l rd, rs1, rs2
.insn r 0x33, 0x0, 0x2A, \rd, \rs1, \rs2
.endm
// 010 1011 | rs2   | rs1 | 000 | rd | 011 0011
.macro sha512sig1l rd, rs1, rs2
.insn r 0x33, 0x0, 0x2B, \rd, \rs1, \rs2
.endm
// 010 1110 | rs2   | rs1 | 000 | rd | 011 0011
.macro sha512sig0h rd, rs1, rs2
.insn r 0x33, 0x0, 0x2E, \rd, \rs1, \rs2
.endm

// 010 1111 | rs2   | rs1 | 000 | rd | 011 0011
.macro sha512sig1h rd, rs1, rs2
.insn r 0x33, 0x0, 0x2F, \rd, \rs1, \rs2
.endm


// ============================================================================

#endif
