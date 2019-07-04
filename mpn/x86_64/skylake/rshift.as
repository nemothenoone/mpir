; PROLOGUE(mpn_rshift)

;  Version 1.0.4.
;
;  Copyright 2008 Jason Moxham
;
;  Windows Conversion Copyright 2008 Brian Gladman
;
;  This file is part of the MPIR Library.
;  The MPIR Library is free software; you can redistribute it and/or modify
;  it under the terms of the GNU Lesser General Public License as published
;  by the Free Software Foundation; either version 2.1 of the License, or (at
;  your option) any later version.
;  The MPIR Library is distributed in the hope that it will be useful, but
;  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
;  License for more details.
;  You should have received a copy of the GNU Lesser General Public License
;  along with the MPIR Library; see the file COPYING.LIB.  If not, write
;  to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;  Boston, MA 02110-1301, USA.
;
;  mp_limb_t  mpn_rshift(mp_ptr, mp_ptr, mp_size_t, mp_uint)
;  rax                     rdi      rsi        rdx      rcx
;  rax                     rcx      rdx         r8      r9d

%include "yasm_mac.inc"

CPU  SSE4.2
BITS 64

GLOBAL_FUNC mpn_rshift
    mov     r10, rdi
    mov     edi, ecx
    cmp     rdx, 2
    ja      .3
    jz      .2
.1:	mov     rsi, [rsi]
    mov     rax, rsi
    shr     rsi, cl
    neg     rdi
    shl     rax, cl
    mov     [r10], rsi
    ret

.2:	mov     rdx, [rsi]
    mov     rcx, [rsi+8]
    mov     rax, rdx
    mov     r11, rcx
    shr     rdx, cl
    shr     rcx, cl
    neg     rdi
    shl     r11, cl
    shl     rax, cl
    or      rdx, r11
    mov     [r10], rdx
    mov     [r10+8], rcx
    ret

.3:	mov     r11, rsi
    mov     rsi, rdx

    mov     eax, 64
    lea     rcx, [r11+8]
    sub     rax, rdi
    and     rcx, -16
    movq    xmm0, rdi
    movq    xmm1, rax
    movdqa  xmm5, [rcx]
    movdqa  xmm3, xmm5
    psllq   xmm5, xmm1
    movq    rax, xmm5
    cmp     r11, rcx
    lea     r11, [r11+rsi*8-40]
    je      .4
    movq    xmm2, [rcx-8]
    movq    xmm4, xmm2
    psllq   xmm2, xmm1
    psrlq   xmm4, xmm0
    por     xmm4, xmm5
    movq    [r10], xmm4
    lea     r10, [r10+8]
    dec     rsi
    movq    rax, xmm2
.4: lea     r10, [r10+rsi*8-40]
    psrlq   xmm3, xmm0
    mov     edx, 5
    sub     rdx, rsi
    jnc     .6

    xalign  16
.5: movdqa  xmm2, [r11+rdx*8+16]
    movdqa  xmm4, xmm2
    psllq   xmm2, xmm1
    shufpd  xmm5, xmm2, 1
    por     xmm3, xmm5
    movq    [r10+rdx*8], xmm3
    movhpd  [r10+rdx*8+8], xmm3
    psrlq   xmm4, xmm0
    movdqa  xmm5, [r11+rdx*8+32]
    movdqa  xmm3, xmm5
    psllq   xmm5, xmm1
    shufpd  xmm2, xmm5, 1
    psrlq   xmm3, xmm0
    por     xmm4, xmm2
    movq    [r10+rdx*8+16], xmm4
    movhpd  [r10+rdx*8+24], xmm4
    add     rdx, 4
    jnc     .5
.6: cmp     rdx, 2
    ja      .10
    jz      .9
    jp      .8
.7:	movdqa  xmm2, [r11+rdx*8+16]
    movdqa  xmm4, xmm2
    psllq   xmm2, xmm1
    shufpd  xmm5, xmm2, 1
    por     xmm3, xmm5
    movq    [r10+rdx*8], xmm3
    movhpd  [r10+rdx*8+8], xmm3
    psrlq   xmm4, xmm0
    movq    xmm5, [r11+rdx*8+32]
    movq    xmm3, xmm5
    psllq   xmm5, xmm1
    shufpd  xmm2, xmm5, 1
    psrlq   xmm3, xmm0
    por     xmm4, xmm2
    movq    [r10+rdx*8+16], xmm4
    movhpd  [r10+rdx*8+24], xmm4
    psrldq  xmm5, 8
    por     xmm3, xmm5
    movq    [r10+rdx*8+32], xmm3
    ret

    xalign  16
.8:	movdqa  xmm2, [r11+rdx*8+16]
    movdqa  xmm4, xmm2
    psllq   xmm2, xmm1
    shufpd  xmm5, xmm2, 1
    por     xmm3, xmm5
    movq    [r10+rdx*8], xmm3
    movhpd  [r10+rdx*8+8], xmm3
    psrlq   xmm4, xmm0
    psrldq  xmm2, 8
    por     xmm4, xmm2
    movq    [r10+rdx*8+16], xmm4
    movhpd  [r10+rdx*8+24], xmm4
    ret

    xalign  16
.9:	movq    xmm2, [r11+rdx*8+16]
    movq    xmm4, xmm2
    psllq   xmm2, xmm1
    shufpd  xmm5, xmm2, 1
    por     xmm3, xmm5
    movq    [r10+rdx*8], xmm3
    movhpd  [r10+rdx*8+8], xmm3
    psrlq   xmm4, xmm0
    psrldq  xmm2, 8
    por     xmm4, xmm2
    movq    [r10+rdx*8+16], xmm4
    ret

    xalign  16
.10:psrldq  xmm5, 8
    por     xmm3, xmm5
    movq    [r10+rdx*8], xmm3
    movhpd  [r10+rdx*8+8], xmm3
    ret

    end
