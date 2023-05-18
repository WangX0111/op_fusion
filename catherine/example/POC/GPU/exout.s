	.text
	.file	"LLVMDialectModule"
	.globl	matmul_linalg                   # -- Begin function matmul_linalg
	.p2align	4, 0x90
	.type	matmul_linalg,@function
matmul_linalg:                          # @matmul_linalg
# %bb.0:
	pushq	%rbx
	movq	88(%rsp), %rax
	movq	32(%rsp), %rcx
	xorl	%edx, %edx
	.p2align	4, 0x90
.LBB0_1:                                # %.preheader1
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
	imulq	$8000, %rdx, %rdi               # imm = 0x1F40
	movq	%rcx, %r8
	xorl	%r9d, %r9d
	.p2align	4, 0x90
.LBB0_2:                                # %.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
	leaq	(%r9,%rdi), %r10
	movss	(%rax,%r10,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	movq	$-1, %r11
	movq	%r8, %rbx
	.p2align	4, 0x90
.LBB0_3:                                #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movss	4(%rsi,%r11,4), %xmm1           # xmm1 = mem[0],zero,zero,zero
	mulss	(%rbx), %xmm1
	addss	%xmm1, %xmm0
	movss	%xmm0, (%rax,%r10,4)
	incq	%r11
	addq	$32000, %rbx                    # imm = 0x7D00
	cmpq	$7999, %r11                     # imm = 0x1F3F
	jb	.LBB0_3
# %bb.4:                                #   in Loop: Header=BB0_2 Depth=2
	addq	$4, %r8
	cmpq	$7999, %r9                      # imm = 0x1F3F
	leaq	1(%r9), %r9
	jb	.LBB0_2
# %bb.5:                                #   in Loop: Header=BB0_1 Depth=1
	addq	$32000, %rsi                    # imm = 0x7D00
	cmpq	$7999, %rdx                     # imm = 0x1F3F
	leaq	1(%rdx), %rdx
	jb	.LBB0_1
# %bb.6:
	popq	%rbx
	retq
.Lfunc_end0:
	.size	matmul_linalg, .Lfunc_end0-matmul_linalg
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	subq	$168, %rsp
	.cfi_offset %rbx, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movl	$256000000, %edi                # imm = 0xF424000
	callq	malloc@PLT
	movq	%rax, %rbx
	movl	$256000000, %edi                # imm = 0xF424000
	callq	malloc@PLT
	movq	%rax, %r15
	movl	$256000000, %edi                # imm = 0xF424000
	callq	malloc@PLT
	movq	%rax, %r14
	movq	%rbx, -192(%rbp)
	movq	%rbx, -184(%rbp)
	movq	$0, -176(%rbp)
	movq	$8000, -168(%rbp)               # imm = 0x1F40
	movq	$8000, -160(%rbp)               # imm = 0x1F40
	movq	$8000, -152(%rbp)               # imm = 0x1F40
	movq	$1, -144(%rbp)
	movq	%r15, -136(%rbp)
	movq	%r15, -128(%rbp)
	movq	$0, -120(%rbp)
	movq	$8000, -112(%rbp)               # imm = 0x1F40
	movq	$8000, -104(%rbp)               # imm = 0x1F40
	movq	$8000, -96(%rbp)                # imm = 0x1F40
	movq	$1, -88(%rbp)
	movq	%rax, -80(%rbp)
	movq	%rax, -72(%rbp)
	movq	$0, -64(%rbp)
	movq	$8000, -56(%rbp)                # imm = 0x1F40
	movq	$8000, -48(%rbp)                # imm = 0x1F40
	movq	$8000, -40(%rbp)                # imm = 0x1F40
	movq	$1, -32(%rbp)
	leaq	-192(%rbp), %rsi
	movl	$2, %edi
	movl	$4, %edx
	callq	mgpuMemHostRegisterMemRef@PLT
	leaq	-136(%rbp), %rsi
	movl	$2, %edi
	movl	$4, %edx
	callq	mgpuMemHostRegisterMemRef@PLT
	leaq	-80(%rbp), %rsi
	movl	$2, %edi
	movl	$4, %edx
	callq	mgpuMemHostRegisterMemRef@PLT
	xorl	%eax, %eax
	movq	%rbx, %rcx
	.p2align	4, 0x90
.LBB1_1:                                # %.preheader44
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
	movq	$-1, %rdx
	.p2align	4, 0x90
.LBB1_2:                                #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	$1065353216, 4(%rcx,%rdx,4)     # imm = 0x3F800000
	incq	%rdx
	cmpq	$7999, %rdx                     # imm = 0x1F3F
	jb	.LBB1_2
# %bb.3:                                #   in Loop: Header=BB1_1 Depth=1
	addq	$32000, %rcx                    # imm = 0x7D00
	cmpq	$7999, %rax                     # imm = 0x1F3F
	leaq	1(%rax), %rax
	jb	.LBB1_1
# %bb.4:                                # %.preheader42.preheader
	xorl	%eax, %eax
	movq	%r15, %rcx
	.p2align	4, 0x90
.LBB1_5:                                # %.preheader42
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_6 Depth 2
	movq	$-1, %rdx
	.p2align	4, 0x90
.LBB1_6:                                #   Parent Loop BB1_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	$1065353216, 4(%rcx,%rdx,4)     # imm = 0x3F800000
	incq	%rdx
	cmpq	$7999, %rdx                     # imm = 0x1F3F
	jb	.LBB1_6
# %bb.7:                                #   in Loop: Header=BB1_5 Depth=1
	addq	$32000, %rcx                    # imm = 0x7D00
	cmpq	$7999, %rax                     # imm = 0x1F3F
	leaq	1(%rax), %rax
	jb	.LBB1_5
# %bb.8:                                # %.preheader.preheader
	xorl	%eax, %eax
	movq	%r14, %rcx
	.p2align	4, 0x90
.LBB1_9:                                # %.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_10 Depth 2
	movq	$-1, %rdx
	.p2align	4, 0x90
.LBB1_10:                               #   Parent Loop BB1_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	$1065353216, 4(%rcx,%rdx,4)     # imm = 0x3F800000
	incq	%rdx
	cmpq	$7999, %rdx                     # imm = 0x1F3F
	jb	.LBB1_10
# %bb.11:                               #   in Loop: Header=BB1_9 Depth=1
	addq	$32000, %rcx                    # imm = 0x7D00
	cmpq	$7999, %rax                     # imm = 0x1F3F
	leaq	1(%rax), %rax
	jb	.LBB1_9
# %bb.12:                               # %.preheader1.i.preheader
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB1_13:                               # %.preheader1.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_14 Depth 2
                                        #       Child Loop BB1_15 Depth 3
	imulq	$8000, %rax, %rcx               # imm = 0x1F40
	movq	%r15, %rdx
	xorl	%esi, %esi
	.p2align	4, 0x90
.LBB1_14:                               # %.preheader.i
                                        #   Parent Loop BB1_13 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_15 Depth 3
	leaq	(%rsi,%rcx), %rdi
	movss	(%r14,%rdi,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	movq	$-1, %r8
	movq	%rdx, %r9
	.p2align	4, 0x90
.LBB1_15:                               #   Parent Loop BB1_13 Depth=1
                                        #     Parent Loop BB1_14 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movss	4(%rbx,%r8,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	mulss	(%r9), %xmm1
	addss	%xmm1, %xmm0
	incq	%r8
	addq	$32000, %r9                     # imm = 0x7D00
	cmpq	$7999, %r8                      # imm = 0x1F3F
	jb	.LBB1_15
# %bb.16:                               #   in Loop: Header=BB1_14 Depth=2
	movss	%xmm0, (%r14,%rdi,4)
	addq	$4, %rdx
	cmpq	$7999, %rsi                     # imm = 0x1F3F
	leaq	1(%rsi), %rsi
	jb	.LBB1_14
# %bb.17:                               #   in Loop: Header=BB1_13 Depth=1
	addq	$32000, %rbx                    # imm = 0x7D00
	cmpq	$7999, %rax                     # imm = 0x1F3F
	leaq	1(%rax), %rax
	jb	.LBB1_13
# %bb.18:                               # %matmul_linalg.exit
	movq	%rsp, %rax
	leaq	-64(%rax), %rsi
	movq	%rsi, %rsp
	movq	%r14, -64(%rax)
	movq	%r14, -56(%rax)
	movq	$0, -48(%rax)
	movq	$8000, -40(%rax)                # imm = 0x1F40
	movq	$8000, -32(%rax)                # imm = 0x1F40
	movq	$8000, -24(%rax)                # imm = 0x1F40
	movq	$1, -16(%rax)
	movl	$2, %edi
	callq	printMemrefF32@PLT
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
