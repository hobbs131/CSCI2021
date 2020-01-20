	.file	"thermo_update.c"
	.text
	.globl	set_temp_from_ports
	.type	set_temp_from_ports, @function
set_temp_from_ports:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movzwl	THERMO_SENSOR_PORT(%rip), %eax
	cmpw	$-1536, %ax
	ja	.L2
	movzbl	THERMO_STATUS_PORT(%rip), %eax
	cmpb	$1, %al
	jbe	.L3
.L2:
	movl	$1, %eax
	jmp	.L4
.L3:
	movzwl	THERMO_SENSOR_PORT(%rip), %eax
	shrw	$6, %ax
	movzwl	%ax, %eax
	subl	$500, %eax
	movl	%eax, -4(%rbp)
	movzwl	THERMO_SENSOR_PORT(%rip), %eax
	andl	$63, %eax
	cmpw	$31, %ax
	jbe	.L5
	movzwl	THERMO_SENSOR_PORT(%rip), %eax
	andl	$63, %eax
	testw	%ax, %ax
	je	.L5
	addl	$1, -4(%rbp)
.L5:
	movzbl	THERMO_STATUS_PORT(%rip), %eax
	cmpb	$1, %al
	jne	.L6
	movl	-4(%rbp), %edx
	movl	%edx, %eax
	sall	$3, %eax
	leal	(%rax,%rdx), %ecx
	movl	$1717986919, %edx
	movl	%ecx, %eax
	imull	%edx
	sarl	%edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	addl	$320, %eax
	movl	%eax, -4(%rbp)
.L6:
	movl	-4(%rbp), %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movw	%dx, (%rax)
	movzbl	THERMO_STATUS_PORT(%rip), %eax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movb	%dl, 2(%rax)
	movl	$0, %eax
.L4:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	set_temp_from_ports, .-set_temp_from_ports
	.globl	thermo_update
	.type	thermo_update, @function
thermo_update:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -12(%rbp)
	leaq	-12(%rbp), %rax
	movq	%rax, %rdi
	call	set_temp_from_ports
	movl	%eax, -16(%rbp)
	cmpl	$1, -16(%rbp)
	jne	.L8
	movl	$1, %eax
	jmp	.L11
.L8:
	movl	$0, -20(%rbp)
	leaq	-20(%rbp), %rdx
	movl	-12(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	set_display_from_temp@PLT
	movl	%eax, -16(%rbp)
	cmpl	$0, -16(%rbp)
	je	.L10
	movl	$1, %eax
	jmp	.L11
.L10:
	movl	-20(%rbp), %eax
	movl	%eax, THERMO_DISPLAY_PORT(%rip)
	movl	$0, %eax
.L11:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L12
	call	__stack_chk_fail@PLT
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	thermo_update, .-thermo_update
	.ident	"GCC: (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0"
	.section	.note.GNU-stack,"",@progbits
