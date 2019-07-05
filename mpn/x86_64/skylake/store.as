; PROLOGUE(mpn_store)

;  mpn_store

;  Copyright 2009 Jason Moxham

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

;  void mpn_store(mp_ptr, mp_size_t, mp_limb_t)
;                    rdi,       rsi,       rdx
;                    rcx,       rdx,        r8

%include 'yasm_mac.inc'

    CPU  nehalem
    BITS 64

%define	MOVQ	movd

GLOBAL_FUNC mpn_store
	lea     rdi, [rdi-32]
	cmp     rsi, 0
	jz      .4
	MOVQ    xmm0, rdx
	movddup xmm0, xmm0
	test    rdi, 0xF
	jz      .1
	mov     [rdi+32], rdx
	lea     rdi, [rdi+8]
	sub     rsi, 1
.1:	sub     rsi, 4
	jc      .3
	
	align  16
.2:	lea     rdi, [rdi+32]
	sub     rsi, 4
	movdqa  [rdi], xmm0
	movdqa  [rdi+16], xmm0
	jnc     .2
.3:	cmp     rsi, -2
	ja      .5
	jz      .7
	jp      .6
.4:	ret

.5:	movdqa  [rdi+32], xmm0
.6:	mov     [rdi+rsi*8+56], rdx
	ret

.7:	movdqa  [rdi+32], xmm0
	ret
	
	end
