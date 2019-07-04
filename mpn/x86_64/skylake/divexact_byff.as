; PROLOGUE(mpn_divexact_byff)
;  Copyright 2009 Jason Moxham
;
;  Windows Conversion Copyright 2008 Brian Gladman
;
;  This file is part of the MPIR Library.
;
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
;
;  mp_limb_t mpn_divexact_byff(mp_ptr, mp_ptr, mp_size_t)
;  rax                           rdi     rsi         rdx
;  rax                           rcx     rdx          r8 

%include "yasm_mac.inc"

BITS 64

GLOBAL_FUNC mpn_divexact_byff
	mov     rax, 3
	and     rax, rdx
	mov     [rsp+24], rax
	xor     eax, eax
	shr     rdx, 2
	cmp     rdx, 0
	je      .2
; want carry clear here
	xalign  16
.1:	sbb     rax, [rsi]
	lea     rdi, [rdi+32]
	mov     r9, rax
	sbb     rax, [rsi+8]
	mov     r10, rax
	sbb     rax, [rsi+16]
	mov     r11, rax
	sbb     rax, [rsi+24]
	dec     r8
	mov     [rdi-32], r9
	mov     [rdi-24], r10
	mov     [rdi-16], r11
	mov     [rdi-8], rax
	lea     rsi, [rsi+32]
	jnz     .1
.2:	mov     r8, [rsp+24]
; dont want to change the carry
	inc     r8
	dec     r8
	jz      .3
	sbb     rax, [rsi]
	mov     [rdi], rax
	dec     r8
	jz      .3
	sbb     rax, [rsi+8]
	mov     [rdi+8], rax
	dec     r8
	jz      .3
	sbb     rax, [rsi+16]
	mov     [rdi+16], rax
.3:	sbb     rax, 0
	ret
	
	end
