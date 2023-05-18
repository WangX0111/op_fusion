	.text
	.file	"LLVMDialectModule"
	.globl	matmul                          # -- Begin function matmul
	.p2align	4, 0x90
	.type	matmul,@function
matmul:                                 # @matmul
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$200, %rsp
	movq	%rsi, 40(%rsp)                  # 8-byte Spill
	movq	328(%rsp), %r14
	xorl	%eax, %eax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	.p2align	4, 0x90
.LBB0_1:                                # %.preheader7
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #           Child Loop BB0_5 Depth 5
                                        #             Child Loop BB0_6 Depth 6
                                        #               Child Loop BB0_7 Depth 7
                                        #                 Child Loop BB0_8 Depth 8
                                        #                   Child Loop BB0_9 Depth 9
	movq	272(%rsp), %rcx
	xorl	%eax, %eax
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	.p2align	4, 0x90
.LBB0_2:                                # %.preheader6
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #           Child Loop BB0_5 Depth 5
                                        #             Child Loop BB0_6 Depth 6
                                        #               Child Loop BB0_7 Depth 7
                                        #                 Child Loop BB0_8 Depth 8
                                        #                   Child Loop BB0_9 Depth 9
	movq	40(%rsp), %rdx                  # 8-byte Reload
	movq	%rcx, 72(%rsp)                  # 8-byte Spill
	movq	%rcx, 48(%rsp)                  # 8-byte Spill
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB0_3:                                # %.preheader5
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #           Child Loop BB0_5 Depth 5
                                        #             Child Loop BB0_6 Depth 6
                                        #               Child Loop BB0_7 Depth 7
                                        #                 Child Loop BB0_8 Depth 8
                                        #                   Child Loop BB0_9 Depth 9
	movq	%rax, 80(%rsp)                  # 8-byte Spill
	movq	%rdx, 88(%rsp)                  # 8-byte Spill
	movq	%rdx, 56(%rsp)                  # 8-byte Spill
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB0_4:                                # %.preheader4
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB0_5 Depth 5
                                        #             Child Loop BB0_6 Depth 6
                                        #               Child Loop BB0_7 Depth 7
                                        #                 Child Loop BB0_8 Depth 8
                                        #                   Child Loop BB0_9 Depth 9
	movq	16(%rsp), %rax                  # 8-byte Reload
	movq	%rcx, 96(%rsp)                  # 8-byte Spill
	addq	%rcx, %rax
	movq	%rax, 136(%rsp)                 # 8-byte Spill
	movq	48(%rsp), %rcx                  # 8-byte Reload
	xorl	%edx, %edx
	.p2align	4, 0x90
.LBB0_5:                                # %.preheader3
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        #         Parent Loop BB0_4 Depth=4
                                        # =>        This Loop Header: Depth=5
                                        #             Child Loop BB0_6 Depth 6
                                        #               Child Loop BB0_7 Depth 7
                                        #                 Child Loop BB0_8 Depth 8
                                        #                   Child Loop BB0_9 Depth 9
	movq	24(%rsp), %rax                  # 8-byte Reload
	movq	%rdx, 104(%rsp)                 # 8-byte Spill
	addq	%rdx, %rax
	movq	%rax, 152(%rsp)                 # 8-byte Spill
	movq	56(%rsp), %rbx                  # 8-byte Reload
	movq	%rcx, 112(%rsp)                 # 8-byte Spill
	movq	%rcx, 64(%rsp)                  # 8-byte Spill
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB0_6:                                # %.preheader2
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        #         Parent Loop BB0_4 Depth=4
                                        #           Parent Loop BB0_5 Depth=5
                                        # =>          This Loop Header: Depth=6
                                        #               Child Loop BB0_7 Depth 7
                                        #                 Child Loop BB0_8 Depth 8
                                        #                   Child Loop BB0_9 Depth 9
	movq	%rax, 120(%rsp)                 # 8-byte Spill
	movq	%rbx, 128(%rsp)                 # 8-byte Spill
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB0_7:                                # %.preheader1
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        #         Parent Loop BB0_4 Depth=4
                                        #           Parent Loop BB0_5 Depth=5
                                        #             Parent Loop BB0_6 Depth=6
                                        # =>            This Loop Header: Depth=7
                                        #                 Child Loop BB0_8 Depth 8
                                        #                   Child Loop BB0_9 Depth 9
	movq	136(%rsp), %rax                 # 8-byte Reload
	movq	%rcx, 144(%rsp)                 # 8-byte Spill
	addq	%rcx, %rax
	shlq	$13, %rax
	movq	%rax, 160(%rsp)                 # 8-byte Spill
	movq	64(%rsp), %r15                  # 8-byte Reload
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB0_8:                                # %.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        #         Parent Loop BB0_4 Depth=4
                                        #           Parent Loop BB0_5 Depth=5
                                        #             Parent Loop BB0_6 Depth=6
                                        #               Parent Loop BB0_7 Depth=7
                                        # =>              This Loop Header: Depth=8
                                        #                   Child Loop BB0_9 Depth 9
	movq	152(%rsp), %rax                 # 8-byte Reload
	movq	%rcx, 168(%rsp)                 # 8-byte Spill
	leaq	(%rax,%rcx), %rbp
	addq	160(%rsp), %rbp                 # 8-byte Folded Reload
	movd	(%r14,%rbp,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	movq	$-1, %r12
	movq	%r15, %r13
	.p2align	4, 0x90
.LBB0_9:                                #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        #         Parent Loop BB0_4 Depth=4
                                        #           Parent Loop BB0_5 Depth=5
                                        #             Parent Loop BB0_6 Depth=6
                                        #               Parent Loop BB0_7 Depth=7
                                        #                 Parent Loop BB0_8 Depth=8
                                        # =>                This Inner Loop Header: Depth=9
	movd	%xmm0, 12(%rsp)                 # 4-byte Folded Spill
	pinsrw	$0, 2(%rbx,%r12,2), %xmm0
	pinsrw	$0, (%r13), %xmm1
	movdqa	%xmm1, 176(%rsp)                # 16-byte Spill
	callq	__extendhfsf2@PLT
	movd	%xmm0, 36(%rsp)                 # 4-byte Folded Spill
	movaps	176(%rsp), %xmm0                # 16-byte Reload
	callq	__extendhfsf2@PLT
	mulss	36(%rsp), %xmm0                 # 4-byte Folded Reload
	callq	__truncsfhf2@PLT
	callq	__extendhfsf2@PLT
	movss	12(%rsp), %xmm1                 # 4-byte Reload
                                        # xmm1 = mem[0],zero,zero,zero
	addss	%xmm0, %xmm1
	movss	%xmm1, 12(%rsp)                 # 4-byte Spill
	movss	12(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, (%r14,%rbp,4)
	incq	%r12
	addq	$16384, %r13                    # imm = 0x4000
	cmpq	$31, %r12
	jb	.LBB0_9
# %bb.10:                               #   in Loop: Header=BB0_8 Depth=8
	addq	$2, %r15
	movq	168(%rsp), %rax                 # 8-byte Reload
	cmpq	$63, %rax
	leaq	1(%rax), %rcx
	jb	.LBB0_8
# %bb.11:                               #   in Loop: Header=BB0_7 Depth=7
	addq	$16384, %rbx                    # imm = 0x4000
	movq	144(%rsp), %rax                 # 8-byte Reload
	cmpq	$63, %rax
	leaq	1(%rax), %rcx
	jb	.LBB0_7
# %bb.12:                               #   in Loop: Header=BB0_6 Depth=6
	addq	$524288, 64(%rsp)               # 8-byte Folded Spill
                                        # imm = 0x80000
	movq	128(%rsp), %rbx                 # 8-byte Reload
	addq	$64, %rbx
	movq	120(%rsp), %rax                 # 8-byte Reload
	cmpq	$8160, %rax                     # imm = 0x1FE0
	leaq	32(%rax), %rax
	jb	.LBB0_6
# %bb.13:                               #   in Loop: Header=BB0_5 Depth=5
	movq	112(%rsp), %rcx                 # 8-byte Reload
	subq	$-128, %rcx
	movq	104(%rsp), %rax                 # 8-byte Reload
	cmpq	$8128, %rax                     # imm = 0x1FC0
	leaq	64(%rax), %rdx
	jb	.LBB0_5
# %bb.14:                               #   in Loop: Header=BB0_4 Depth=4
	addq	$1048576, 56(%rsp)              # 8-byte Folded Spill
                                        # imm = 0x100000
	movq	96(%rsp), %rax                  # 8-byte Reload
	cmpq	$8128, %rax                     # imm = 0x1FC0
	leaq	64(%rax), %rcx
	jb	.LBB0_4
# %bb.15:                               #   in Loop: Header=BB0_3 Depth=3
	addq	$1048576, 48(%rsp)              # 8-byte Folded Spill
                                        # imm = 0x100000
	movq	88(%rsp), %rdx                  # 8-byte Reload
	subq	$-128, %rdx
	movq	80(%rsp), %rax                  # 8-byte Reload
	cmpq	$8128, %rax                     # imm = 0x1FC0
	leaq	64(%rax), %rax
	jb	.LBB0_3
# %bb.16:                               #   in Loop: Header=BB0_2 Depth=2
	movq	72(%rsp), %rcx                  # 8-byte Reload
	addq	$256, %rcx                      # imm = 0x100
	movq	24(%rsp), %rax                  # 8-byte Reload
	cmpq	$8064, %rax                     # imm = 0x1F80
	leaq	128(%rax), %rax
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	jb	.LBB0_2
# %bb.17:                               #   in Loop: Header=BB0_1 Depth=1
	addq	$2097152, 40(%rsp)              # 8-byte Folded Spill
                                        # imm = 0x200000
	movq	16(%rsp), %rax                  # 8-byte Reload
	cmpq	$8064, %rax                     # imm = 0x1F80
	leaq	128(%rax), %rax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	jb	.LBB0_1
# %bb.18:
	addq	$200, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end0:
	.size	matmul, .Lfunc_end0-matmul
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function main
.LCPI1_0:
	.quad	0x426dcd6500000000              # double 1.024E+12
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$216, %rsp
	.cfi_def_cfa_offset 272
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movl	$134217728, %edi                # imm = 0x8000000
	callq	malloc@PLT
	movq	%rax, %rbx
	movl	$134217728, %edi                # imm = 0x8000000
	callq	malloc@PLT
	movq	%rax, 8(%rsp)                   # 8-byte Spill
	movl	$268435456, %edi                # imm = 0x10000000
	callq	malloc@PLT
	movq	%rax, %rbp
	xorl	%eax, %eax
	movq	%rbx, %rcx
	.p2align	4, 0x90
.LBB1_1:                                # %.preheader6
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
	movq	$-16384, %rdx                   # imm = 0xC000
	.p2align	4, 0x90
.LBB1_2:                                # %vector.body
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	$1006648320, 16384(%rcx,%rdx)   # imm = 0x3C003C00
	addq	$4, %rdx
	jne	.LBB1_2
# %bb.3:                                # %middle.block
                                        #   in Loop: Header=BB1_1 Depth=1
	addq	$16384, %rcx                    # imm = 0x4000
	cmpq	$8191, %rax                     # imm = 0x1FFF
	leaq	1(%rax), %rax
	jb	.LBB1_1
# %bb.4:                                # %.preheader4.preheader
	xorl	%eax, %eax
	movq	8(%rsp), %rcx                   # 8-byte Reload
	.p2align	4, 0x90
.LBB1_5:                                # %.preheader4
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_6 Depth 2
	movq	$-16384, %rdx                   # imm = 0xC000
	.p2align	4, 0x90
.LBB1_6:                                # %vector.body12
                                        #   Parent Loop BB1_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	$1006648320, 16384(%rcx,%rdx)   # imm = 0x3C003C00
	addq	$4, %rdx
	jne	.LBB1_6
# %bb.7:                                # %middle.block7
                                        #   in Loop: Header=BB1_5 Depth=1
	addq	$16384, %rcx                    # imm = 0x4000
	cmpq	$8191, %rax                     # imm = 0x1FFF
	leaq	1(%rax), %rax
	jb	.LBB1_5
# %bb.8:                                # %.preheader.preheader
	xorl	%eax, %eax
	movq	%rbp, %rcx
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
	cmpq	$8191, %rdx                     # imm = 0x1FFF
	jb	.LBB1_10
# %bb.11:                               #   in Loop: Header=BB1_9 Depth=1
	addq	$32768, %rcx                    # imm = 0x8000
	cmpq	$8191, %rax                     # imm = 0x1FFF
	leaq	1(%rax), %rax
	jb	.LBB1_9
# %bb.12:
	xorl	%eax, %eax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	callq	rtclock@PLT
	movsd	%xmm0, 72(%rsp)                 # 8-byte Spill
	movq	%rbx, 80(%rsp)                  # 8-byte Spill
	movq	%rbx, 40(%rsp)                  # 8-byte Spill
	movq	%rbp, 168(%rsp)                 # 8-byte Spill
	.p2align	4, 0x90
.LBB1_13:                               # %.preheader7.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_14 Depth 2
                                        #       Child Loop BB1_15 Depth 3
                                        #         Child Loop BB1_16 Depth 4
                                        #           Child Loop BB1_17 Depth 5
                                        #             Child Loop BB1_18 Depth 6
                                        #               Child Loop BB1_19 Depth 7
                                        #                 Child Loop BB1_20 Depth 8
                                        #                   Child Loop BB1_21 Depth 9
	movq	8(%rsp), %rcx                   # 8-byte Reload
	xorl	%eax, %eax
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	.p2align	4, 0x90
.LBB1_14:                               # %.preheader6.i
                                        #   Parent Loop BB1_13 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_15 Depth 3
                                        #         Child Loop BB1_16 Depth 4
                                        #           Child Loop BB1_17 Depth 5
                                        #             Child Loop BB1_18 Depth 6
                                        #               Child Loop BB1_19 Depth 7
                                        #                 Child Loop BB1_20 Depth 8
                                        #                   Child Loop BB1_21 Depth 9
	movq	40(%rsp), %rdx                  # 8-byte Reload
	movq	%rcx, 88(%rsp)                  # 8-byte Spill
	movq	%rcx, 48(%rsp)                  # 8-byte Spill
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB1_15:                               # %.preheader5.i
                                        #   Parent Loop BB1_13 Depth=1
                                        #     Parent Loop BB1_14 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB1_16 Depth 4
                                        #           Child Loop BB1_17 Depth 5
                                        #             Child Loop BB1_18 Depth 6
                                        #               Child Loop BB1_19 Depth 7
                                        #                 Child Loop BB1_20 Depth 8
                                        #                   Child Loop BB1_21 Depth 9
	movq	%rax, 96(%rsp)                  # 8-byte Spill
	movq	%rdx, 104(%rsp)                 # 8-byte Spill
	movq	%rdx, 56(%rsp)                  # 8-byte Spill
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB1_16:                               # %.preheader4.i
                                        #   Parent Loop BB1_13 Depth=1
                                        #     Parent Loop BB1_14 Depth=2
                                        #       Parent Loop BB1_15 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB1_17 Depth 5
                                        #             Child Loop BB1_18 Depth 6
                                        #               Child Loop BB1_19 Depth 7
                                        #                 Child Loop BB1_20 Depth 8
                                        #                   Child Loop BB1_21 Depth 9
	movq	16(%rsp), %rax                  # 8-byte Reload
	movq	%rcx, 112(%rsp)                 # 8-byte Spill
	addq	%rcx, %rax
	movq	%rax, 152(%rsp)                 # 8-byte Spill
	movq	48(%rsp), %rcx                  # 8-byte Reload
	xorl	%edx, %edx
	.p2align	4, 0x90
.LBB1_17:                               # %.preheader3.i
                                        #   Parent Loop BB1_13 Depth=1
                                        #     Parent Loop BB1_14 Depth=2
                                        #       Parent Loop BB1_15 Depth=3
                                        #         Parent Loop BB1_16 Depth=4
                                        # =>        This Loop Header: Depth=5
                                        #             Child Loop BB1_18 Depth 6
                                        #               Child Loop BB1_19 Depth 7
                                        #                 Child Loop BB1_20 Depth 8
                                        #                   Child Loop BB1_21 Depth 9
	movq	24(%rsp), %rax                  # 8-byte Reload
	movq	%rdx, 120(%rsp)                 # 8-byte Spill
	addq	%rdx, %rax
	movq	%rax, 176(%rsp)                 # 8-byte Spill
	movq	56(%rsp), %r13                  # 8-byte Reload
	movq	%rcx, 128(%rsp)                 # 8-byte Spill
	movq	%rcx, 64(%rsp)                  # 8-byte Spill
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB1_18:                               # %.preheader2.i
                                        #   Parent Loop BB1_13 Depth=1
                                        #     Parent Loop BB1_14 Depth=2
                                        #       Parent Loop BB1_15 Depth=3
                                        #         Parent Loop BB1_16 Depth=4
                                        #           Parent Loop BB1_17 Depth=5
                                        # =>          This Loop Header: Depth=6
                                        #               Child Loop BB1_19 Depth 7
                                        #                 Child Loop BB1_20 Depth 8
                                        #                   Child Loop BB1_21 Depth 9
	movq	%rax, 136(%rsp)                 # 8-byte Spill
	movq	%r13, 144(%rsp)                 # 8-byte Spill
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB1_19:                               # %.preheader1.i
                                        #   Parent Loop BB1_13 Depth=1
                                        #     Parent Loop BB1_14 Depth=2
                                        #       Parent Loop BB1_15 Depth=3
                                        #         Parent Loop BB1_16 Depth=4
                                        #           Parent Loop BB1_17 Depth=5
                                        #             Parent Loop BB1_18 Depth=6
                                        # =>            This Loop Header: Depth=7
                                        #                 Child Loop BB1_20 Depth 8
                                        #                   Child Loop BB1_21 Depth 9
	movq	152(%rsp), %rax                 # 8-byte Reload
	movq	%rcx, 160(%rsp)                 # 8-byte Spill
	addq	%rcx, %rax
	shlq	$13, %rax
	movq	%rax, 184(%rsp)                 # 8-byte Spill
	movq	64(%rsp), %r12                  # 8-byte Reload
	xorl	%r14d, %r14d
	.p2align	4, 0x90
.LBB1_20:                               # %.preheader.i
                                        #   Parent Loop BB1_13 Depth=1
                                        #     Parent Loop BB1_14 Depth=2
                                        #       Parent Loop BB1_15 Depth=3
                                        #         Parent Loop BB1_16 Depth=4
                                        #           Parent Loop BB1_17 Depth=5
                                        #             Parent Loop BB1_18 Depth=6
                                        #               Parent Loop BB1_19 Depth=7
                                        # =>              This Loop Header: Depth=8
                                        #                   Child Loop BB1_21 Depth 9
	movq	176(%rsp), %rax                 # 8-byte Reload
	leaq	(%rax,%r14), %r15
	addq	184(%rsp), %r15                 # 8-byte Folded Reload
	movd	(%rbp,%r15,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	movq	$-1, %rbx
	movq	%r12, %rbp
	.p2align	4, 0x90
.LBB1_21:                               #   Parent Loop BB1_13 Depth=1
                                        #     Parent Loop BB1_14 Depth=2
                                        #       Parent Loop BB1_15 Depth=3
                                        #         Parent Loop BB1_16 Depth=4
                                        #           Parent Loop BB1_17 Depth=5
                                        #             Parent Loop BB1_18 Depth=6
                                        #               Parent Loop BB1_19 Depth=7
                                        #                 Parent Loop BB1_20 Depth=8
                                        # =>                This Inner Loop Header: Depth=9
	movd	%xmm0, (%rsp)                   # 4-byte Folded Spill
	pinsrw	$0, 2(%r13,%rbx,2), %xmm0
	pinsrw	$0, (%rbp), %xmm1
	movdqa	%xmm1, 192(%rsp)                # 16-byte Spill
	callq	__extendhfsf2@PLT
	movd	%xmm0, 36(%rsp)                 # 4-byte Folded Spill
	movaps	192(%rsp), %xmm0                # 16-byte Reload
	callq	__extendhfsf2@PLT
	mulss	36(%rsp), %xmm0                 # 4-byte Folded Reload
	callq	__truncsfhf2@PLT
	callq	__extendhfsf2@PLT
	movss	(%rsp), %xmm1                   # 4-byte Reload
                                        # xmm1 = mem[0],zero,zero,zero
	addss	%xmm0, %xmm1
	movss	%xmm1, (%rsp)                   # 4-byte Spill
	movss	(%rsp), %xmm0                   # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	incq	%rbx
	addq	$16384, %rbp                    # imm = 0x4000
	cmpq	$31, %rbx
	jb	.LBB1_21
# %bb.22:                               #   in Loop: Header=BB1_20 Depth=8
	movq	168(%rsp), %rbp                 # 8-byte Reload
	movss	%xmm0, (%rbp,%r15,4)
	addq	$2, %r12
	cmpq	$63, %r14
	leaq	1(%r14), %r14
	jb	.LBB1_20
# %bb.23:                               #   in Loop: Header=BB1_19 Depth=7
	addq	$16384, %r13                    # imm = 0x4000
	movq	160(%rsp), %rax                 # 8-byte Reload
	cmpq	$63, %rax
	leaq	1(%rax), %rcx
	jb	.LBB1_19
# %bb.24:                               #   in Loop: Header=BB1_18 Depth=6
	addq	$524288, 64(%rsp)               # 8-byte Folded Spill
                                        # imm = 0x80000
	movq	144(%rsp), %r13                 # 8-byte Reload
	addq	$64, %r13
	movq	136(%rsp), %rax                 # 8-byte Reload
	cmpq	$8160, %rax                     # imm = 0x1FE0
	leaq	32(%rax), %rax
	jb	.LBB1_18
# %bb.25:                               #   in Loop: Header=BB1_17 Depth=5
	movq	128(%rsp), %rcx                 # 8-byte Reload
	subq	$-128, %rcx
	movq	120(%rsp), %rax                 # 8-byte Reload
	cmpq	$8128, %rax                     # imm = 0x1FC0
	leaq	64(%rax), %rdx
	jb	.LBB1_17
# %bb.26:                               #   in Loop: Header=BB1_16 Depth=4
	addq	$1048576, 56(%rsp)              # 8-byte Folded Spill
                                        # imm = 0x100000
	movq	112(%rsp), %rax                 # 8-byte Reload
	cmpq	$8128, %rax                     # imm = 0x1FC0
	leaq	64(%rax), %rcx
	jb	.LBB1_16
# %bb.27:                               #   in Loop: Header=BB1_15 Depth=3
	addq	$1048576, 48(%rsp)              # 8-byte Folded Spill
                                        # imm = 0x100000
	movq	104(%rsp), %rdx                 # 8-byte Reload
	subq	$-128, %rdx
	movq	96(%rsp), %rax                  # 8-byte Reload
	cmpq	$8128, %rax                     # imm = 0x1FC0
	leaq	64(%rax), %rax
	jb	.LBB1_15
# %bb.28:                               #   in Loop: Header=BB1_14 Depth=2
	movq	88(%rsp), %rcx                  # 8-byte Reload
	addq	$256, %rcx                      # imm = 0x100
	movq	24(%rsp), %rax                  # 8-byte Reload
	cmpq	$8064, %rax                     # imm = 0x1F80
	leaq	128(%rax), %rax
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	jb	.LBB1_14
# %bb.29:                               #   in Loop: Header=BB1_13 Depth=1
	addq	$2097152, 40(%rsp)              # 8-byte Folded Spill
                                        # imm = 0x200000
	movq	16(%rsp), %rax                  # 8-byte Reload
	cmpq	$8064, %rax                     # imm = 0x1F80
	leaq	128(%rax), %rax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	jb	.LBB1_13
# %bb.30:                               # %matmul.exit
	callq	rtclock@PLT
	subsd	72(%rsp), %xmm0                 # 8-byte Folded Reload
	movsd	%xmm0, (%rsp)                   # 8-byte Spill
	callq	printF64@PLT
	callq	printNewline@PLT
	movabsq	$1099511627776, %rdi            # imm = 0x10000000000
	callq	printU64@PLT
	callq	printNewline@PLT
	movsd	.LCPI1_0(%rip), %xmm0           # xmm0 = mem[0],zero
	divsd	(%rsp), %xmm0                   # 8-byte Folded Reload
	movsd	%xmm0, (%rsp)                   # 8-byte Spill
	callq	printF64@PLT
	callq	printNewline@PLT
	movsd	(%rsp), %xmm0                   # 8-byte Reload
                                        # xmm0 = mem[0],zero
	callq	printFlops@PLT
	movq	80(%rsp), %rdi                  # 8-byte Reload
	callq	free@PLT
	movq	8(%rsp), %rdi                   # 8-byte Reload
	callq	free@PLT
	movq	%rbp, %rdi
	addq	$216, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	free@PLT                        # TAILCALL
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
