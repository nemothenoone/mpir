; PROLOGUE(mpn_lshift)

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
;  mp_limb_t  mpn_lshift(mp_ptr, mp_ptr, mp_size_t, mp_uint)
;  rax                     rdi      rsi        rdx      rcx
;  rax                     rcx      rdx         r8      r9d

%include "yasm_mac.inc"

BITS 64

GLOBAL_FUNC mpn_lshift
    mov     r10, rdi
    mov     edi, ecx
    cmp     rdx, 2
    ja      .3
    jz      .2
.1:	mov     rdx, [rdx]
    mov     rax, rdx
    shl     rsi, cl
    neg     rdi
    shr     rax, cl
    mov     [r10], rsi
    ret

.2:	mov     rdx, [rsi]
    mov     rcx, [rsi+8]
    mov     r11, rdx
    mov     rax, rcx
    shl     rdx, cl
    shl     rcx, cl
    neg     rdi
    shr     r11, cl
    shr     rax, cl
    or      rcx, r11
    mov     [r10], rdx
    mov     [r10+8], rcx
    ret

.3:	mov     eax, 64
    sub     rax, rcx
    movq    xmm0, rcx
    movq    xmm1, rax
    lea     rcx, [rsi+rdx*8-16]
    mov     r11, rcx
    and     rcx, -16
    movdqa  xmm3, [rcx]
    movdqa  xmm5, xmm3
    psrlq   xmm3, xmm1
    pshufd  xmm3, xmm3, 0x4e
    movq    rax, xmm3
    cmp     r11, rcx
    je      .4
    movq    xmm2, [rsi+rdx*8-8]
    movq    xmm4, xmm2
    psrlq   xmm2, xmm1
    movq    rax, xmm2
    psllq   xmm4, xmm0
    por     xmm4, xmm3
    movq    [r10+rdx*8-8], xmm4
    dec     rdx
.4:	sub     rdx, 5
    jle     .6

    align  16
.5: movdqa  xmm2, [rsi+rdx*8+8]
    movdqa  xmm4, xmm2
    psllq   xmm5, xmm0
    psrlq   xmm2, xmm1
    movhlps xmm3, xmm2
    por     xmm5, xmm3
    movq    [r10+rdx*8+24], xmm5
    pshufd  xmm2, xmm2, 0x4e
    movhpd  [r10+rdx*8+32], xmm5
    movdqa  xmm3, [rsi+rdx*8-8]
    movdqa  xmm5, xmm3
    psrlq   xmm3, xmm1
    movhlps xmm2, xmm3
    psllq   xmm4, xmm0
    pshufd  xmm3, xmm3, 0x4e
    por     xmm4, xmm2
    movq    [r10+rdx*8+8], xmm4
    movhpd  [r10+rdx*8+16], xmm4
    sub     rdx, 4
    jg      .5
.6: cmp     rdx, -1
    je      .9
    jg      .8
    jp      .10
.7:	pxor    xmm2, xmm2
    psllq   xmm5, xmm0
    movhlps xmm3, xmm2
    por     xmm5, xmm3
    movq    [r10+rdx*8+24], xmm5
    movhpd  [r10+rdx*8+32], xmm5
    ret

    align  16
.8:	movdqa  xmm2, [rsi+rdx*8+8]
    movdqa  xmm4, xmm2
    psllq   xmm5, xmm0
    psrlq   xmm2, xmm1
    movhlps xmm3, xmm2
    por     xmm5, xmm3
    movq    [r10+rdx*8+24], xmm5
    pshufd  xmm2, xmm2, 0x4e
    movhpd  [r10+rdx*8+32], xmm5
    movq    xmm3, [rsi+rdx*8]
    pshufd  xmm3, xmm3, 0x4e
    movdqa  xmm5, xmm3
    psrlq   xmm3, xmm1
    movhlps xmm2, xmm3
    psllq   xmm4, xmm0
    por     xmm4, xmm2
    movq    [r10+rdx*8+8], xmm4
    movhpd  [r10+rdx*8+16], xmm4
    psllq   xmm5, xmm0
    movhpd  [r10+rdx*8], xmm5
    ret

    align  16
.9:	movdqa  xmm2, [rsi+rdx*8+8]
    movdqa  xmm4, xmm2
    psllq   xmm5, xmm0
    psrlq   xmm2, xmm1
    movhlps xmm3, xmm2
    por     xmm5, xmm3
    movq    [r10+rdx*8+24], xmm5
    pshufd  xmm2, xmm2, 0x4e
    movhpd  [r10+rdx*8+32], xmm5
    pxor    xmm3, xmm3
    movhlps xmm2, xmm3
    psllq   xmm4, xmm0
    por     xmm4, xmm2
    movq    [r10+rdx*8+8], xmm4
    movhpd  [r10+rdx*8+16], xmm4
    ret

    align  16
.10:movq    xmm2, [rsi+rdx*8+16]
    pshufd  xmm2, xmm2, 0x4e
    movdqa  xmm4, xmm2
    psllq   xmm5, xmm0
    psrlq   xmm2, xmm1
    movhlps xmm3, xmm2
    por     xmm5, xmm3
    movq    [r10+rdx*8+24], xmm5
    movhpd  [r10+rdx*8+32], xmm5
    psllq   xmm4, xmm0
    movhpd  [r10+rdx*8+16], xmm4
    ret

    end
