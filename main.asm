section .bss
	n: resb 8
	mystr: resb 10
	fr: resb 8
	rr: resb 8
	queue: resq 10005

section .data
	f1: db '%s', 0
	f2: db '%d', 0
	f3: db '%d', 10, 0
	dpush: db 'push', 0
	dpop: db 'pop', 0
	dsize: db 'size', 0
	dempty: db 'empty', 0
	dfront: db 'front', 0
	f4: db '%d %d',10,0

section .text
	global main
	extern scanf
	extern printf

mydbg:
	push rbp
	mov rbp, rsp

	mov rdi, f4
	mov rsi, [rr]
	mov rdx, [fr]
	call printf

	leave
	ret

myprint:
	push rbp
	mov rbp, rsp

	mov rdi, f3
	mov rsi, rbx
	call printf

	leave
	ret

main:
	push rbp
	mov rbp, rsp

	mov rdi, f2
	mov rsi, n
	xor rax, rax
	call scanf

	mov rcx, [n]
	push rcx
	L1:
		push rcx

		mov rdi, f1
		mov rsi, mystr
		call scanf

		mov rsi, mystr
		mov rdi, dpush
		mov rcx, 4 ;SIZEOF 'push'
		cld
		repe cmpsb
		jnz Lpop

		; Push
		mov rdi, f2
		mov rsi, n
		call scanf
		mov rbx, [n]
		mov rdx, [fr]
		mov [queue + rdx*8], rbx
		inc QWORD[fr]
		cmp QWORD[fr], 10002
		jne L1end
		mov QWORD[fr], 0
		jmp L1end

		Lpop:
		mov rsi, mystr
		mov rdi, dpop
		mov rcx, 3 ;SIZEOF 'pop'
		cld
		repe cmpsb
		jnz Lsize

		; Pop
		mov rbx, -1
		mov rdx, [rr]
		cmp rdx, [fr]
		je P1
			mov rbx, QWORD[queue + rdx*8]
			inc QWORD[rr]
			cmp QWORD[rr], 10002
			jne P1
			mov QWORD[rr], 0
		P1:
		call myprint
		jmp L1end

		Lsize:
		mov rsi, mystr
		mov rdi, dsize
		mov rcx, 4 ;SIZEOF 'size'
		cld
		repe cmpsb
		jnz Lempty

		; Size
		mov rbx, [fr]
		sub rbx, [rr]
		jns P1
		add rbx, 10002
		jmp P1

		Lempty:
		mov rsi, mystr
		mov rdi, dempty
		mov rcx, 5 ;SIZEOF 'empty'
		cld
		repe cmpsb
		jnz Lfront

		; Empty
		mov rbx, 0
		mov rdx, [fr]
		cmp rdx, [rr]
		jne P1
		mov rbx, 1
		jmp P1

		Lfront:
		mov rsi, mystr
		mov rdi, dfront
		mov rcx, 5 ;SIZEOF 'front'
		cld
		repe cmpsb
		jnz Lback

		; Front
		mov rbx, -1
		mov rdx, [rr]
		cmp [fr], rdx
		je P1
		mov rbx, [queue + rdx*8]
		jmp P1

		Lback: ;Back
		mov rbx, -1
		mov rdx, [fr]
		cmp rdx, [rr]
		je P1
		mov rbx, [queue + (rdx-1)*8]
		jmp P1

		L1end:
		pop rcx
	dec rcx
	jnz L1
	pop rcx

	xor rax, rax
	ret
