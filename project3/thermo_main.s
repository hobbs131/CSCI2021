	.file	"thermo_main.c"
	.text
	.section	.rodata
	.align 8
.LC0:
	.string	"usage: %s {sensor_val} {C | F}\n"
	.align 8
.LC1:
	.string	"  sensor_val: positive integer"
	.align 8
.LC2:
	.string	"THERMO_SENSOR_PORT set to: %u\n"
	.align 8
.LC3:
	.string	"Sensor value %u exceeds max %u\n"
.LC4:
	.string	"Unknown display mode: '%s'\n"
.LC5:
	.string	"Should be 'C' or 'F'"
	.align 8
.LC6:
	.string	"set_temp_from_sensors(&temp );"
.LC7:
	.string	"temp is {"
.LC8:
	.string	"  .tenths_degrees = %d\n"
.LC9:
	.string	"  .is_fahrenheit  = %d\n"
.LC10:
	.string	"}"
.LC11:
	.string	"deg F"
.LC12:
	.string	"deg C"
.LC13:
	.string	"Simulated temp is: %d.%d %s\n"
	.align 8
.LC14:
	.string	"set_temp_from_ports() returned non-zero: %d\n"
	.align 8
.LC15:
	.string	"\nChecking results for display bits"
	.align 8
.LC16:
	.string	"set_display_from_temp(temp, &display);"
.LC17:
	.string	"\ndisplay is:"
	.align 8
.LC18:
	.string	"        3         2         1         0"
	.align 8
.LC19:
	.string	"index: 10987654321098765432109876543210"
.LC20:
	.string	"bits:  "
	.align 8
.LC21:
	.string	"guide:  |    |    |    |    |    |    |"
	.align 8
.LC22:
	.string	"index:  30        20        10        0"
	.align 8
.LC23:
	.string	"set_display_from_temp() returned non-zero: %d\n"
.LC24:
	.string	"\nRunning thermo_update()"
.LC25:
	.string	"\nTHERMO_DISPLAY_PORT is:"
	.align 8
.LC26:
	.string	"index:  3         2         1    0    0"
.LC27:
	.string	"\nThermometer Display:"
	.text
	.globl	main
	.type	main, @function
main:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$2, -52(%rbp)
	jg	.L2
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L15
.L2:
	movq	-64(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi@PLT
	movw	%ax, THERMO_SENSOR_PORT(%rip)
	movzwl	THERMO_SENSOR_PORT(%rip), %eax
	movzwl	%ax, %eax
	movl	%eax, %esi
	leaq	.LC2(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$128000, -32(%rbp)
	movzwl	THERMO_SENSOR_PORT(%rip), %eax
	movzwl	%ax, %eax
	cmpl	%eax, -32(%rbp)
	jnb	.L4
	movzwl	THERMO_SENSOR_PORT(%rip), %eax
	movzwl	%ax, %eax
	movl	-32(%rbp), %edx
	movl	%eax, %esi
	leaq	.LC3(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %eax
	jmp	.L15
.L4:
	movq	-64(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$67, %al
	je	.L5
	movq	-64(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$99, %al
	jne	.L6
.L5:
	movzbl	THERMO_STATUS_PORT(%rip), %eax
	movb	%al, THERMO_STATUS_PORT(%rip)
	jmp	.L7
.L6:
	movq	-64(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$70, %al
	je	.L8
	movq	-64(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$102, %al
	jne	.L9
.L8:
	movzbl	THERMO_STATUS_PORT(%rip), %eax
	orl	$1, %eax
	movb	%al, THERMO_STATUS_PORT(%rip)
	jmp	.L7
.L9:
	movq	-64(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC4(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	leaq	.LC5(%rip), %rdi
	call	puts@PLT
	movl	$1, %eax
	jmp	.L15
.L7:
	movl	$0, -20(%rbp)
	leaq	-20(%rbp), %rax
	movq	%rax, %rdi
	call	set_temp_from_ports@PLT
	movl	%eax, -28(%rbp)
	leaq	.LC6(%rip), %rdi
	call	puts@PLT
	leaq	.LC7(%rip), %rdi
	call	puts@PLT
	movzwl	-20(%rbp), %eax
	cwtl
	movl	%eax, %esi
	leaq	.LC8(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movzbl	-18(%rbp), %eax
	movsbl	%al, %eax
	movl	%eax, %esi
	leaq	.LC9(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	leaq	.LC10(%rip), %rdi
	call	puts@PLT
	movzwl	-20(%rbp), %eax
	movswl	%ax, %edx
	imull	$26215, %edx, %edx
	shrl	$16, %edx
	sarw	$2, %dx
	sarw	$15, %ax
	subl	%eax, %edx
	movl	%edx, %eax
	cwtl
	movl	%eax, -24(%rbp)
	movzwl	-20(%rbp), %ecx
	movswl	%cx, %eax
	imull	$26215, %eax, %eax
	shrl	$16, %eax
	movl	%eax, %edx
	sarw	$2, %dx
	movl	%ecx, %eax
	sarw	$15, %ax
	subl	%eax, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movswl	%dx, %eax
	movl	%eax, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jns	.L10
	negl	-36(%rbp)
.L10:
	movzbl	-18(%rbp), %eax
	testb	%al, %al
	je	.L11
	leaq	.LC11(%rip), %rax
	jmp	.L12
.L11:
	leaq	.LC12(%rip), %rax
.L12:
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rcx
	movl	-36(%rbp), %edx
	movl	-24(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC13(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	cmpl	$0, -28(%rbp)
	je	.L13
	movl	-28(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC14(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %eax
	jmp	.L15
.L13:
	leaq	.LC15(%rip), %rdi
	call	puts@PLT
	movl	$0, -40(%rbp)
	leaq	-40(%rbp), %rdx
	movl	-20(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	set_display_from_temp@PLT
	movl	%eax, -28(%rbp)
	leaq	.LC16(%rip), %rdi
	call	puts@PLT
	leaq	.LC17(%rip), %rdi
	call	puts@PLT
	leaq	.LC18(%rip), %rdi
	call	puts@PLT
	leaq	.LC19(%rip), %rdi
	call	puts@PLT
	leaq	.LC20(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-40(%rbp), %eax
	movl	%eax, %edi
	call	showbits@PLT
	movl	$10, %edi
	call	putchar@PLT
	leaq	.LC21(%rip), %rdi
	call	puts@PLT
	leaq	.LC22(%rip), %rdi
	call	puts@PLT
	cmpl	$0, -28(%rbp)
	je	.L14
	movl	-28(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC23(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %eax
	jmp	.L15
.L14:
	leaq	.LC24(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	call	thermo_update@PLT
	leaq	.LC25(%rip), %rdi
	call	puts@PLT
	leaq	.LC26(%rip), %rdi
	call	puts@PLT
	leaq	.LC19(%rip), %rdi
	call	puts@PLT
	leaq	.LC20(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	THERMO_DISPLAY_PORT(%rip), %eax
	movl	%eax, %edi
	call	showbits@PLT
	movl	$10, %edi
	call	putchar@PLT
	leaq	.LC21(%rip), %rdi
	call	puts@PLT
	leaq	.LC22(%rip), %rdi
	call	puts@PLT
	leaq	.LC27(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	call	print_thermo_display@PLT
	movl	$0, %eax
.L15:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L16
	call	__stack_chk_fail@PLT
.L16:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0"
	.section	.note.GNU-stack,"",@progbits
