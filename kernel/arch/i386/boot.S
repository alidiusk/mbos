/* Declare constants for multiboot header */
.set ALIGN, 	1<<0 		 /* align loaded modules on page boundaries */
.set MEMINFO, 	1<<1 		 /* provide memory map */
.set FLAGS, 	ALIGN | MEMINFO  /* multiboot flag field */
.set MAGIC, 	0x1BADB002 	 /* 'magic number' lets bootloader find the header */
.set CHECKSUM, 	-(MAGIC + FLAGS) /* checksum of above, to prove we are multiboot */

/*
Declare multiboot header that markes program as a kernel.
See multiboot standard.
*/
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

/* Create a small stack with 16KiB. It must be 16-byte aligned. */
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

/* Linker script specifies `_start` as the entry point to the kernel. */
.section .text
.global _start
.type _start, @function
_start:
	/*
	Bootloader has loaded into 32-bit protected mode on a x86 machine.
	- Interrupts are disabled.
	- Paging is disabled.
	- The processor state is as defined in the multiboot standard.
	*/

	/* Set up a stack by setting `esp` register. */
	movl $stack_top, %esp

	/*
	Initialize crucial processor state here before entering high-level
	kernel.

	Note that there are no floating point instructions or instruction
	set extensions yet (they must be initialized).

	- The GDT should be loaded here.
	- Paging should be enabled here.
	- C++ features such as global constructors and exceptions will
	  require runtime support as well.
	*/

	/* Call the kernel main function to enter the high-level kernel. */
	call kernel_main

	/*
	If the system has nothing more to do, put computer into infinite loop.
	1. Disable interrupts with `cli`
	2. Wait for the next interrupt to arrive with `hlt`; this will lock
	   the computer.
	3. Jump to `hlt` instruction if it ever wakes up due to a non-maskable
	   interrupt occurring or due to system management mode.
	*/
	cli
1:	hlt
	jmp 1b

/*
Set the size of the `_start` symbol to the current location `.` minus its start.
This is useful when debugging or when we implement call tracing
*/
.size _start, . - _start
