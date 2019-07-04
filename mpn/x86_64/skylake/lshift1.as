; PROLOGUE(mpn_lshift1)

;  Copyright 2008 Jason Moxham
;
;  Windows Conversion Copyright 2008 Brian Gladman
;
;  This file is part of the MPIR Library.
;
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
;  mp_limb_t mpn_lshift1(mp_ptr, mp_ptr, mp_size_t)
;  rax                      rdi     rsi        rdx
;  rax                      rcx     rdx         r8

%include "yasm_mac.inc"

BITS 64

GLOBAL_FUNC mpn_lshift1
    mov     rax, rdx
	and     rdx, 7
	inc     rdx
	mov     [rsp+0x18], rdx
	shr     rax, 3
	cmp     rax, 0
	jz      .2
	
	xalign  16
.1:	mov     rdx, [rsi]
	mov     r9, [rsi+8]
	mov     r10, [rsi+16]
	mov     r11, [rsi+24]
	adc     rdx, rdx
	adc     r9, r9
	adc     r10, r10
	adc     r11, r11
	mov     [rdi], rdx
	mov     [rdi+8], r9
	mov     [rdi+16], r10
	mov     [rdi+24], r11
	mov     rdx, [rsi+32]
	mov     r9, [rsi+40]
	mov     r10, [rsi+48]
	mov     r11, [rsi+56]
	adc     rdx, rdx
	adc     r9, r9
	adc     r10, r10
	adc     r11, r11
	mov     [rdi+32], rdx
	mov     [rdi+40], r9
	mov     [rdi+48], r10
	mov     [rdi+56], r11
	lea     rdi, [rdi+64]
	dec     rax
	lea     rsi, [rsi+64]
	jnz     .1
.2:	mov     rax, [rsp+0x18]
	dec     rax
	jz      .3
;	Could still have cache-bank conflicts in this tail part
	mov     rdx, [rsi]
	adc     rdx, rdx
	mov     [rdi], rdx
	dec     rax
	jz      .3
	mov     rdx, [rsi+8]
	adc     rdx, rdx
	mov     [rdi+8], rdx
	dec     rax
	jz      .3
	mov     rdx, [rsi+16]
	adc     rdx, rdx
	mov     [rdi+16], rdx
	dec     rax
	jz      .3
	mov     rdx, [rsi+24]
	adc     rdx, rdx
	mov     [rdi+24], rdx
	dec     rax
	jz      .3
	mov     rdx, [rsi+32]
	adc     rdx, rdx
	mov     [rdi+32], rdx
	dec     rax
	jz      .3
	mov     rdx, [rsi+40]
	adc     rdx, rdx
	mov     [rdi+40], rdx
	dec     rax
	jz      .3
	mov     rdx, [rsi+48]
	adc     rdx, rdx
	mov     [rdi+48], rdx
.3:	sbb     rax, rax
	neg     rax
	ret

	end
