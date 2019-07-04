; PROLOGUE(mpn_nand_n)

;  mpn_nand_n

;  Copyright 2009 Jason Moxham

;  This file is part of the MPIR Library.

;  The MPIR Library is free software; you can redistribute it and/or modify
;  it under the terms of the GNU Lesser General Public License as published
;  by the Free Software Foundation; either verdxon 2.1 of the License, or (at
;  your option) any later verdxon.

;  The MPIR Library is distributed in the hope that it will be useful, but
;  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
;  License for more details.

;  You should have received a copy of the GNU Lesser General Public License
;  along with the MPIR Library; see the file COPYING.LIB.  If not, write
;  to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;  Boston, MA 02110-1301, USA.

;  void mpn_nand_n(mp_ptr, mp_srcptr, mp_srcptr, mp_size_t)
;                     rcx        rdx         r8         r9
;                     rdi        rsi        rdx        rcx 

%include 'yasm_mac.inc'

BITS 64

GLOBAL_FUNC mpn_nand_n
	movsxd	rcx, ecx
	mov     r10, 3
	lea     rsi, [rsi+rcx*8-24]
	lea     rdx, [rdx+rcx*8-24]
	lea     rdi, [rdi+rcx*8-24]
	pcmpeqb xmm4, xmm4
	sub     r10, rcx
	jnc     .2
	
	xalign  16
.1:	movdqu  xmm0, [rdx+r10*8]
	movdqu  xmm1, [rdx+r10*8+16]
	movdqu  xmm2, [rsi+r10*8]
	add     r10, 4
	movdqu  xmm3, [rsi+r10*8+16-32]
	pand    xmm1, xmm3
	pand    xmm0, xmm2
	pxor    xmm0, xmm4
	movdqu  [rdi+r10*8-32], xmm0
	pxor    xmm1, xmm4
	movdqu  [rdi+r10*8+16-32], xmm1
	jnc     .1
.2:	cmp     r10, 2
	ja      .4
	je      .6
	jp      .5
.3:	movdqu  xmm0, [rdx+r10*8]
	mov     rax, [rdx+r10*8+16]
	movdqu  xmm2, [rsi+r10*8]
	mov     rcx, [rsi+r10*8+16]
	and     rax, rcx
	pand    xmm0, xmm2
	pxor    xmm0, xmm4
	movdqu  [rdi+r10*8], xmm0
	not     rax
	mov     [rdi+r10*8+16], rax
.4:	ret

.5:	movdqu  xmm0, [rdx+r10*8]
	movdqu  xmm2, [rsi+r10*8]
	pand    xmm0, xmm2
	pxor    xmm0, xmm4
	movdqu  [rdi+r10*8], xmm0
	ret

.6:	mov     rax, [rdx+r10*8]
	mov     rcx, [rsi+r10*8]
	and     rax, rcx
	not     rax
	mov     [rdi+r10*8], rax
	ret
	
	end
