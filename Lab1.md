## 实验吐槽：

- yysy  OSLab1的实验工作量着实有被整懵到。
- 倒也不是任务量很重的原因，主要是感觉实验一的前提知识很多，实验上手的过程中必须花大量的时间用于学习看手册、以及看代码。
- 而且我感觉大家都把指导书上面的问题当作了报告内容，所以报告写了好久（以下内容为鉴）。
- 可能是第一次接触这样的实验，所以我觉得大家可能是都有些没适应。
- 实验难度很大，但是由于指导书的帮助以及一些网上的参考答案，实际完成弄懂大致的工作流程还是可以做到的。

## 实验过程中错误问题：

- 首先最明显的错误就是环境的配置，由于本人没有拿网站上提供的虚拟环境，而是自建Ubuntu，自动安装qemu等环境。故实验初期花费定量时间用于环境搭建上。
- gdb修改tools/gitinit文件，设定调试配置时出现一定的问题。
- 自己找一个bootloader或内核中的代码位置，设置断点并进行测试。这里由于本人设置的代码位置一直迟迟无法执行到，错以为电脑崩了（最后实验做差不多，懂得越来越多就知道是那个代码应该是很难被执行到或者在很后的阶段才会被触发到
- challenge部分对于用户内核态切换的一些个问题，具体细节（记不得了已经）。

# Lab1

## 练习1：理解通过make生成执行文件的过程

### **操作系统镜像文件ucore.img是如何一步一步生成的？(需要比较详细地解释Makefile中每一条相关命令和命令参数的含义，以及说明命令导致的结果)**

操作系统镜像文件ucore.img是通过make "V="编译生成的。
通过分析追踪make的过程，解释Makefile的命令以及参数含义加以分析镜像文件的生成过程。

运行 make "V="产生的结果

<img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221010195540278.png" alt="image-20221010195540278" style="zoom: 25%;" />

查看Makefile文件中与ucore.img相关的部分

![image-20221010200530700](C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221010200530700.png)

从中可以看出，ucore.img的生成需要如下步骤：

1. 生成kernel

   - <img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221010201312832.png" alt="image-20221010201312832" style="zoom:50%;" />

   从kernel的相关代码可以看出：

   生成kernel首先要编译KSRCDIR下的.c文件，生成对应所需的.o文件

   ```cmake
   $(call add_files_cc,$(call listf_cc,$(KSRCDIR)),kernel,$(KCFLAGS))
   ```
   实际执行的命令可在make "V="中观察到：
   
   ```cmake
   + cc kern/init/init.c
   gcc -Ikern/init/ -march=i686 -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/init/init.c -o obj/kern/init/init.o
   + cc kern/libs/stdio.c
   gcc -Ikern/libs/ -march=i686 -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/stdio.c -o obj/kern/libs/stdio.o
   + cc kern/libs/readline.c
   gcc -Ikern/libs/ -march=i686 -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/readline.c -o obj/kern/libs/readline.o
   ```
   对于编译生成的.o文件，需要链接起来生成kernel
   
   ``` cmake
   $(kernel): $(KOBJS)
           @echo + ld $@
           $(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
           @$(OBJDUMP) -S $@ > $(call asmfile,kernel)
           @$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)
   ```
   
   对应的执行命令为：
   
   ``` cmake
   + ld bin/kernel
   ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/stdio.o obj/kern/libs/readline.o obj/kern/debug/panic.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/picirq.o obj/kern/driver/intr.o obj/kern/trap/trap.o obj/kern/trap/vectors.o obj/kern/trap/trapentry.o obj/kern/mm/pmm.o  obj/libs/string.o obj/libs/printfmt.o
   ```
   
2. 生成bootblock

   - <img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221010204223734.png" alt="image-20221010204223734" style="zoom: 50%;" />

   从bootblock的Makefile中创建可以分析出：其的生成过程由：编译boot/目录下的bootmain.o和bootasm.s文件生成对应的.o文件、再编译生成sign.o文件、将这些.o文件全部链接生成bootblock。

   <img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221010205459674.png" alt="image-20221010205459674" style="zoom: 50%;" />

1. `$(V)dd if=/dev/zero of=$@ count=10000`：生成一个有10000个块的文件，每个块默认512字节，用0填充。
   `$(V)dd if=$(bootblock) of=$@ conv=notrunc`：把bootblock中的内容写到第一个块。
   `$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc`：从第二个块开始写kernel中的内容。

   <img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221010210022431.png" alt="image-20221010210022431" style="zoom:67%;" />
   
   > 有一些知识点值得学习的是：生成.o文件的命令中在 gcc 后添加了许多选项，这些选项对于 .o文件的生成是很重要的！
   >
   > - `-fno-builtin`：表示防止 `gcc` 使用自带的内置函数，比如用到的 `strcpy`，如果没有这个选项，`gcc` 会跳过我们的代码，使用它自带的 `strcpy` 函数。
   >
   > - `-nostdinc`：表示不要在系统自带的标准库的目录下搜索包含文件，只在 `-I` 指定的目录下搜索，这也是为了防止自定义的 `strcpy` 之类的标准库函数和系统自带的产生冲突。
   >
   > - `-fno-PIC`：表示不要生成 PIC (Position Independent Code)。由于新版本 `gcc` 默认启用 PIC，所以会导致生成的 `bootloader` 大于 512 字节，无法放进一个扇区中。并且，PIC 需要 `bootloader` 正确处理重定位，而 ucore 的 `bootloader` 不支持处理重定位，在后续实验中也会产生问题。
   >
   > - `-fno-stack-protector`：为了减小代码体积。启用栈保护的话在函数调用时会增加额外的代码。
   >
   > - `-Wall`：表示打印出所有警告，可以帮我们尽早地发现可能出现的问题。
   >
   > - `-gstabs` ：使用stabs格式，不包含gdb扩展。
   >
   > - `-ggdb` ：表示生成gdb调试信息。
   >
   > - `-m32`：生成 32 位代码。
   >
   > - `-c`：只编译不链接
   
   >   值得注意的是，在编译 `bootloader` 的时候还增加了一个额外的选项：
   >
   >   - `-Os`：意思是指示编译器尽可能地优化代码体积，因为 `bootloader` 在去掉启动标识符和分区表之后只有 466 字节可用，因此需要尽可能小。
   
   > 在 ld 链接的命令中同样有一些值得留意的 -选项 ：
   >
   > - -m elf_i386 模拟为 i386 上的连接器  
   >
   > - -nostdlib 不使用标准库  
   >
   > - -N 设置代码段和数据段均可读写  
   >
   > - -e 指定入口  
   >
   > - -Ttext 指定代码段开始位置  
   >
   > - -T 让连接器使用指定的脚本
   
   

### **一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？**

​		从问题1的分析过程中可知通过sign.c文件的操作使得bootblock.o成为一个符合规范的引导扇区，故一个被系统认为是符合规范的硬盘主引导扇区的特征可以通过分析sign.c中的代码解答。

<img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221010210446010.png" alt="image-20221010210446010" style="zoom: 50%;" />

- 大小为 512 字节，空余部分用0填充。
- 最后两个字节为`0x55` 和 `0xAA`，故文件大小st.st_size不能大于510字节。因为最后俩个字节用作结束符。

## 练习2：使用qemu执行并调试lab1中的软件

### **从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行。**

1. 修改tools/gitinit文件
> file bin/kernel
set architecture i8086
target remote :1234
2. 在lab1文件下执行 make debug，在gdb窗口下通过使用`si`命令进行单步跟踪BIOS的执行
    <img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221011165154297.png" alt="image-20221011165154297" style="zoom: 50%;" />
### **在初始化位置0x7c00设置实地址断点,测试断点正常。**

1. gdb设置实地址断点，先修改tools/gitinit文件
> set architecture i8086
target remote :1234
b *0x7c00
c
x/10i $pc   //显示10条pc指令
2. 执行make debug命令
    <img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221011170757879.png" alt="image-20221011170757879" style="zoom: 50%;" />

  断点正常。

### **从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较。**

1. 修改tools/gitinit文件，添加配置要求
> 有可能gdb无法正确获取当前qemu执行的汇编指令，通过如下配置可以在每次gdb命令行前强制反汇编当前的指令，在gdb命令行或配置文件中添加:
> define hook-stop
x/i $pc
end
2. make debug后 si 单步跟踪代码运行，观察反汇编代码
    <img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221011174003600.png" alt="image-20221011174003600" style="zoom: 50%;" />

3. gdb这个窗口使用起来有一说一较为麻烦，显示的行数受限，在比较的时候感觉很麻烦。。。

4. 搜索发现可以修改Makefile，使得跟踪代码的反汇编得到的代码保存输出到文件中：

 ```cmake
   debug: $(UCOREIMG)
       $(V)$(QEMU) -S -s -d in_asm -D $(BINDIR)/q.log -parallel stdio -hda $< -serial null &
       $(V)sleep 2
       $(V)$(TERMINAL) -e "gdb -q -tui -x tools/gdbinit"
 ```
5. 重新上述跟踪过程，得到保存文件。

   <img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221011180207145.png" alt="image-20221011180207145" style="zoom:80%;" />

6. 利用vscode比较保存的q.log与bootasm.S，发现汇编代码是相同的
 <img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221011180253875.png" alt="image-20221011180253875" style="zoom: 33%;" />

### **自己找一个bootloader或内核中的代码位置，设置断点并进行测试。**

随意设定断点位置：设定一个本人的生日日期：0x7c24

- 修改tools/gitinit文件：

> ...
>
> b *ox7c24
>
> ...

**不知道为啥 qemu跑了许久？**

最后CTRL C直接终止了。。。。。（看来数字不是很幸运。。。。

## 练习3：分析bootloader进入保护模式的过程

- 为何开启A20，以及如何开启A20
- 如何初始化GDT表
- 如何使能和进入保护模式

在vscode中打开bootasm.S，分析进入保护模式的过程：

```c++
.globl start
start:      # 实地址模式下开始
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    cld                                             # String operations increment

    # 第一步 清零  设定段寄存器的初值
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment

    # Enable A20:
    # 开启A20：通过将键盘控制器上的A20线置于高电位，让32条地址线都可以使用
seta20.1:
    inb $0x64, %al                             # 等待键盘控制器 not busy
    testb $0x2, %al
    jnz seta20.1
    # 发送写8042输出端口的指令
    movb $0xd1, %al                            # 0xd1 -> port 0x64
    outb %al, $0x64                            # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                             # 等待键盘控制器 not busy
    testb $0x2, %al
    jnz seta20.2
    # 开启A20
    movb $0xdf, %al                            # 0xdf -> port 0x60
    outb %al, $0x60                            # 0xdf = 11011111, 将A20bit设为1

    # 切换 从实模式变为保护模式  开启bootstrap GDT  
    lgdt gdtdesc   # GDT表和其描述符已经静态储存在引导区中 
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0

    # 处理器转至32位模式且跳转至下条指令
    ljmp $PROT_MODE_CSEG, $protcseg

.code32                                             # Assemble for 32-bit mode
protcseg:
    # 设置段寄存器 建立堆栈
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    movl $start, %esp
    # 进入 bootmain
    call bootmain
```

1. 关闭中断，清空主要寄存器。
2. 打开 A20 模式，通过控制 8042 键盘控制器实现。
3. 设置全局描述符，将全局描述符表的地址和大小加载到寄存器中。
4. 设置 `CR0` 寄存器 `$CR0_PE_ON` 位，启动保护模式。
5. 然后在 32 位模式下，设置好段寄存器和栈寄存器，跳转到 `bootmain` 也就是加载内核 ELF 的程序。

对于问题下的三个小知识点，后俩个在分析过程中已经有所描述，在此不作赘述。
关于第一个**为何开启A20，以及如何开启A20**，列出个人的学习理解：

> 在 i8086 时代，由于**（CPU的数据总线是16bit，地址总线是20bit，寄存器是16bit）**，故CPU只能访问1MB以内的空间。**因为数据总线和寄存器只有16bit。**如果需要获取 20bit 的数据, 则需要进行移位操作。
> 实际上，CPU是通过对segment(每个segment大小恒定为64K) 进行移位后和offset一起组成了一个20bit的地址，这个地址就是实模式下访问内存的地址：

> **address = segment << 4 | offset**

> 理论上，20bit的地址可以访问1MB的内存空间(0x00000 - (2^20 - 1 = 0xFFFFF))。但在实模式下, 这20bit的地址理论上能访问从0x00000 - (0xFFFF0 + 0xFFFF = 0x10FFEF)的内存空间。这意味着：可以访问超过1MB的内存空间，但越过0xFFFFF后，地址又会回到0x00000。
> 上面这个特征在i8086中是没有任何问题的(因为它最多只能访问1MB的内存空间)，但到了i80386后，CPU有了更宽的地址总线，数据总线和寄存器后，这就会出现一个问题： 在实模式下, 我们可以访问超过1MB的空间，但我们只希望访问 1MB 以内的内存空间。为了解决这个问题， CPU中添加了一个可控制A20地址线的模块，通过这个模块，我们在实模式下将第20bit的地址线限制为0，这样CPU就不能访问超过1MB的空间了。进入保护模式后，我们再通过这个模块解除对A20地址线的限制（**默认情况下，A20地址线是关闭的，20bit以上的地址线限制为0**），这样我们就能访问超过1MB的内存空间了。



## 练习4：分析bootloader加载ELF格式的OS的过程

- bootloader如何读取硬盘扇区的？

​	`bootloader`通过`readsect()`与`readseg()`来读取硬盘扇区：


```C++
static void readsect(void *dst, uint32_t secno) {
    // readsect()读取单个扇区
    
    // 调用waitdisk()函数 目的是等待磁盘准备好
    waitdisk();

    //控制信息
    outb(0x1F2, 1);   //0x1F2是要读取的扇区数   count = 1 ：读取一个扇区
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    outb(0x1F7, 0x20);           //0x1F7 状态和命令寄存器 0x20表示 读 命令

    // 等待磁盘准备好
    waitdisk();

    // 把磁盘扇区数据读到指定内存
    insl(0x1F0, dst, SECTSIZE / 4);
}
```
​	`readseg()`包装了`readsect()`实现了读取多个扇区

​	`readseg()`是从磁盘的**offest**字节处开始读取**count**个字节到**va**指向的虚拟地址中

```C++
static void readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    }
}
```
- bootloader是如何加载ELF格式的OS？
  - 读磁盘的第一页，即ELF header
  - 判断读取到的是否是正确合法的ELF   uint magic;  // must equal ELF_MAGIC
  - 合法ELF 开始读取ELF中的每一段到内存中的相应位置
  - 读完之后 跳转到ELF头部中的e_entry的入口地址
  - 加载完成 控制器给到OS


``` c++
void bootmain(void) {
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}
```

## 练习5：实现函数调用堆栈跟踪函数

通过了解函数堆栈的上下结构以及`ebp`的重要地位，编写代码实现函数：

```c++
uint32_t ebp = read_ebp();
uint32_t eip = read_eip();
for(int i =0;i<=STACKFRAME_DEPTH;i++)
{
    if(ebp==0)
    {
        break;
    }    
    cprintf("ebp:0x%08x eip:0x%08x",ebp,eip);
    uint32_t *argu;
    argu = (uint32_t)ebp +2;
    cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x",argu[0],argu[1],argu[2],argu[3]);
    cprintf("\n");
    print_debuginfo(eip-1);
    eip = ((uint32_t *)ebp)[1];
    ebp = ((uint32_t *)ebp)[0];      
}
```

<img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221011225235228.png" alt="image-20221011225235228" style="zoom:50%;" />

最后一行是函数调用的最深层，也就是0x7c00处开始调用。由于函数调用时`call`指令的关系，ebp栈底为0x7bf8



## 练习6：完善中断初始化和处理

1. 中断描述符表（也可简称为保护模式下的中断向量表）中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

   在kern/mm/mmu.h中找到关于中断描述附表的定义：

   <img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221011230810426.png" alt="image-20221011230810426" style="zoom: 80%;" />

   **一个表项占据 8 个字节，2-3字节是段选择子，0-1字节和6-7字节拼成位移，两者联合便是中断处理程序的入口地址。**

   

2. 请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init。在idt_init函数中，依次对所有中断入口进行初始化。使用mmu.h中的SETGATE宏，填充idt数组内容。每个中断的入口由tools/vectors.c生成，使用trap.c中声明的vectors数组即可。

3. 请编程完善trap.c中的中断处理函数trap，在对时钟中断进行处理的部分填写trap函数中处理时钟中断的部分，使操作系统每遇到100次时钟中断后，调用print_ticks子程序，向屏幕上打印一行文字”100 ticks”。

<img src="C:\Users\Kyrie\AppData\Roaming\Typora\typora-user-images\image-20221011232242096.png" alt="image-20221011232242096" style="zoom:50%;" />

## GitHub地址：https://github.com/kyrielw24/NKU_OS.git
