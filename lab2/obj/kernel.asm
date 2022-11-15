
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 a0 11 00       	mov    $0x11a000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 a0 11 c0       	mov    %eax,0xc011a000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 90 11 c0       	mov    $0xc0119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	f3 0f 1e fb          	endbr32 
c010003a:	55                   	push   %ebp
c010003b:	89 e5                	mov    %esp,%ebp
c010003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100040:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0100045:	2d 00 c0 11 c0       	sub    $0xc011c000,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 c0 11 c0 	movl   $0xc011c000,(%esp)
c010005d:	e8 88 59 00 00       	call   c01059ea <memset>

    cons_init();                // init the console
c0100062:	e8 75 16 00 00       	call   c01016dc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 20 62 10 c0 	movl   $0xc0106220,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 3c 62 10 c0 	movl   $0xc010623c,(%esp)
c010007c:	e8 58 02 00 00       	call   c01002d9 <cprintf>

    print_kerninfo();
c0100081:	e8 16 09 00 00       	call   c010099c <print_kerninfo>

    grade_backtrace();
c0100086:	e8 9a 00 00 00       	call   c0100125 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 df 32 00 00       	call   c010336f <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 c2 17 00 00       	call   c0101857 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 67 19 00 00       	call   c0101a01 <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 84 0d 00 00       	call   c0100e23 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 ff 18 00 00       	call   c01019a3 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
c01000a4:	e8 96 01 00 00       	call   c010023f <lab1_switch_test>

    /* do nothing */
    while (1);
c01000a9:	eb fe                	jmp    c01000a9 <kern_init+0x73>

c01000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000ab:	f3 0f 1e fb          	endbr32 
c01000af:	55                   	push   %ebp
c01000b0:	89 e5                	mov    %esp,%ebp
c01000b2:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000bc:	00 
c01000bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c4:	00 
c01000c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000cc:	e8 3c 0d 00 00       	call   c0100e0d <mon_backtrace>
}
c01000d1:	90                   	nop
c01000d2:	c9                   	leave  
c01000d3:	c3                   	ret    

c01000d4 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d4:	f3 0f 1e fb          	endbr32 
c01000d8:	55                   	push   %ebp
c01000d9:	89 e5                	mov    %esp,%ebp
c01000db:	53                   	push   %ebx
c01000dc:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000df:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000e2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e5:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000ef:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f7:	89 04 24             	mov    %eax,(%esp)
c01000fa:	e8 ac ff ff ff       	call   c01000ab <grade_backtrace2>
}
c01000ff:	90                   	nop
c0100100:	83 c4 14             	add    $0x14,%esp
c0100103:	5b                   	pop    %ebx
c0100104:	5d                   	pop    %ebp
c0100105:	c3                   	ret    

c0100106 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100106:	f3 0f 1e fb          	endbr32 
c010010a:	55                   	push   %ebp
c010010b:	89 e5                	mov    %esp,%ebp
c010010d:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100110:	8b 45 10             	mov    0x10(%ebp),%eax
c0100113:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100117:	8b 45 08             	mov    0x8(%ebp),%eax
c010011a:	89 04 24             	mov    %eax,(%esp)
c010011d:	e8 b2 ff ff ff       	call   c01000d4 <grade_backtrace1>
}
c0100122:	90                   	nop
c0100123:	c9                   	leave  
c0100124:	c3                   	ret    

c0100125 <grade_backtrace>:

void
grade_backtrace(void) {
c0100125:	f3 0f 1e fb          	endbr32 
c0100129:	55                   	push   %ebp
c010012a:	89 e5                	mov    %esp,%ebp
c010012c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010012f:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100134:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010013b:	ff 
c010013c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100147:	e8 ba ff ff ff       	call   c0100106 <grade_backtrace0>
}
c010014c:	90                   	nop
c010014d:	c9                   	leave  
c010014e:	c3                   	ret    

c010014f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010014f:	f3 0f 1e fb          	endbr32 
c0100153:	55                   	push   %ebp
c0100154:	89 e5                	mov    %esp,%ebp
c0100156:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100159:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010015c:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015f:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100162:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100169:	83 e0 03             	and    $0x3,%eax
c010016c:	89 c2                	mov    %eax,%edx
c010016e:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100173:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100177:	89 44 24 04          	mov    %eax,0x4(%esp)
c010017b:	c7 04 24 41 62 10 c0 	movl   $0xc0106241,(%esp)
c0100182:	e8 52 01 00 00       	call   c01002d9 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100187:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010018b:	89 c2                	mov    %eax,%edx
c010018d:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100192:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100196:	89 44 24 04          	mov    %eax,0x4(%esp)
c010019a:	c7 04 24 4f 62 10 c0 	movl   $0xc010624f,(%esp)
c01001a1:	e8 33 01 00 00       	call   c01002d9 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a6:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001aa:	89 c2                	mov    %eax,%edx
c01001ac:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b9:	c7 04 24 5d 62 10 c0 	movl   $0xc010625d,(%esp)
c01001c0:	e8 14 01 00 00       	call   c01002d9 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c9:	89 c2                	mov    %eax,%edx
c01001cb:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001d0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d8:	c7 04 24 6b 62 10 c0 	movl   $0xc010626b,(%esp)
c01001df:	e8 f5 00 00 00       	call   c01002d9 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001e4:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e8:	89 c2                	mov    %eax,%edx
c01001ea:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001ef:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f7:	c7 04 24 79 62 10 c0 	movl   $0xc0106279,(%esp)
c01001fe:	e8 d6 00 00 00       	call   c01002d9 <cprintf>
    round ++;
c0100203:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100208:	40                   	inc    %eax
c0100209:	a3 00 c0 11 c0       	mov    %eax,0xc011c000
}
c010020e:	90                   	nop
c010020f:	c9                   	leave  
c0100210:	c3                   	ret    

c0100211 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100211:	f3 0f 1e fb          	endbr32 
c0100215:	55                   	push   %ebp
c0100216:	89 e5                	mov    %esp,%ebp
c0100218:	83 ec 18             	sub    $0x18,%esp
    //LAB1 CHALLENGE 1 : TODO
    cprintf("1");
c010021b:	c7 04 24 87 62 10 c0 	movl   $0xc0106287,(%esp)
c0100222:	e8 b2 00 00 00       	call   c01002d9 <cprintf>
    asm volatile(
c0100227:	83 ec 08             	sub    $0x8,%esp
c010022a:	cd 78                	int    $0x78
c010022c:	89 ec                	mov    %ebp,%esp
        "sub $0x8, %%esp \n"
        "int %0 \n"
        "movl %%ebp, %%esp" ::"i"(T_SWITCH_TOU));
}
c010022e:	90                   	nop
c010022f:	c9                   	leave  
c0100230:	c3                   	ret    

c0100231 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100231:	f3 0f 1e fb          	endbr32 
c0100235:	55                   	push   %ebp
c0100236:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile(
c0100238:	cd 79                	int    $0x79
c010023a:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp" ::"i"(T_SWITCH_TOK));
}
c010023c:	90                   	nop
c010023d:	5d                   	pop    %ebp
c010023e:	c3                   	ret    

c010023f <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010023f:	f3 0f 1e fb          	endbr32 
c0100243:	55                   	push   %ebp
c0100244:	89 e5                	mov    %esp,%ebp
c0100246:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100249:	e8 01 ff ff ff       	call   c010014f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010024e:	c7 04 24 8c 62 10 c0 	movl   $0xc010628c,(%esp)
c0100255:	e8 7f 00 00 00       	call   c01002d9 <cprintf>
    lab1_switch_to_user();
c010025a:	e8 b2 ff ff ff       	call   c0100211 <lab1_switch_to_user>
    lab1_print_cur_status();
c010025f:	e8 eb fe ff ff       	call   c010014f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100264:	c7 04 24 ac 62 10 c0 	movl   $0xc01062ac,(%esp)
c010026b:	e8 69 00 00 00       	call   c01002d9 <cprintf>
    lab1_switch_to_kernel();
c0100270:	e8 bc ff ff ff       	call   c0100231 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100275:	e8 d5 fe ff ff       	call   c010014f <lab1_print_cur_status>
}
c010027a:	90                   	nop
c010027b:	c9                   	leave  
c010027c:	c3                   	ret    

c010027d <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010027d:	f3 0f 1e fb          	endbr32 
c0100281:	55                   	push   %ebp
c0100282:	89 e5                	mov    %esp,%ebp
c0100284:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100287:	8b 45 08             	mov    0x8(%ebp),%eax
c010028a:	89 04 24             	mov    %eax,(%esp)
c010028d:	e8 7b 14 00 00       	call   c010170d <cons_putc>
    (*cnt) ++;
c0100292:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100295:	8b 00                	mov    (%eax),%eax
c0100297:	8d 50 01             	lea    0x1(%eax),%edx
c010029a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010029d:	89 10                	mov    %edx,(%eax)
}
c010029f:	90                   	nop
c01002a0:	c9                   	leave  
c01002a1:	c3                   	ret    

c01002a2 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c01002a2:	f3 0f 1e fb          	endbr32 
c01002a6:	55                   	push   %ebp
c01002a7:	89 e5                	mov    %esp,%ebp
c01002a9:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c01002b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01002ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01002bd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01002c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01002c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002c8:	c7 04 24 7d 02 10 c0 	movl   $0xc010027d,(%esp)
c01002cf:	e8 82 5a 00 00       	call   c0105d56 <vprintfmt>
    return cnt;
c01002d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002d7:	c9                   	leave  
c01002d8:	c3                   	ret    

c01002d9 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002d9:	f3 0f 1e fb          	endbr32 
c01002dd:	55                   	push   %ebp
c01002de:	89 e5                	mov    %esp,%ebp
c01002e0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002e3:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f3:	89 04 24             	mov    %eax,(%esp)
c01002f6:	e8 a7 ff ff ff       	call   c01002a2 <vcprintf>
c01002fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100301:	c9                   	leave  
c0100302:	c3                   	ret    

c0100303 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100303:	f3 0f 1e fb          	endbr32 
c0100307:	55                   	push   %ebp
c0100308:	89 e5                	mov    %esp,%ebp
c010030a:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010030d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100310:	89 04 24             	mov    %eax,(%esp)
c0100313:	e8 f5 13 00 00       	call   c010170d <cons_putc>
}
c0100318:	90                   	nop
c0100319:	c9                   	leave  
c010031a:	c3                   	ret    

c010031b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010031b:	f3 0f 1e fb          	endbr32 
c010031f:	55                   	push   %ebp
c0100320:	89 e5                	mov    %esp,%ebp
c0100322:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100325:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010032c:	eb 13                	jmp    c0100341 <cputs+0x26>
        cputch(c, &cnt);
c010032e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100332:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100335:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100339:	89 04 24             	mov    %eax,(%esp)
c010033c:	e8 3c ff ff ff       	call   c010027d <cputch>
    while ((c = *str ++) != '\0') {
c0100341:	8b 45 08             	mov    0x8(%ebp),%eax
c0100344:	8d 50 01             	lea    0x1(%eax),%edx
c0100347:	89 55 08             	mov    %edx,0x8(%ebp)
c010034a:	0f b6 00             	movzbl (%eax),%eax
c010034d:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100350:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100354:	75 d8                	jne    c010032e <cputs+0x13>
    }
    cputch('\n', &cnt);
c0100356:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100359:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100364:	e8 14 ff ff ff       	call   c010027d <cputch>
    return cnt;
c0100369:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010036c:	c9                   	leave  
c010036d:	c3                   	ret    

c010036e <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010036e:	f3 0f 1e fb          	endbr32 
c0100372:	55                   	push   %ebp
c0100373:	89 e5                	mov    %esp,%ebp
c0100375:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100378:	90                   	nop
c0100379:	e8 d0 13 00 00       	call   c010174e <cons_getc>
c010037e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100381:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100385:	74 f2                	je     c0100379 <getchar+0xb>
        /* do nothing */;
    return c;
c0100387:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010038a:	c9                   	leave  
c010038b:	c3                   	ret    

c010038c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010038c:	f3 0f 1e fb          	endbr32 
c0100390:	55                   	push   %ebp
c0100391:	89 e5                	mov    %esp,%ebp
c0100393:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100396:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010039a:	74 13                	je     c01003af <readline+0x23>
        cprintf("%s", prompt);
c010039c:	8b 45 08             	mov    0x8(%ebp),%eax
c010039f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003a3:	c7 04 24 cb 62 10 c0 	movl   $0xc01062cb,(%esp)
c01003aa:	e8 2a ff ff ff       	call   c01002d9 <cprintf>
    }
    int i = 0, c;
c01003af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c01003b6:	e8 b3 ff ff ff       	call   c010036e <getchar>
c01003bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c01003be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01003c2:	79 07                	jns    c01003cb <readline+0x3f>
            return NULL;
c01003c4:	b8 00 00 00 00       	mov    $0x0,%eax
c01003c9:	eb 78                	jmp    c0100443 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c01003cb:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c01003cf:	7e 28                	jle    c01003f9 <readline+0x6d>
c01003d1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c01003d8:	7f 1f                	jg     c01003f9 <readline+0x6d>
            cputchar(c);
c01003da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003dd:	89 04 24             	mov    %eax,(%esp)
c01003e0:	e8 1e ff ff ff       	call   c0100303 <cputchar>
            buf[i ++] = c;
c01003e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003e8:	8d 50 01             	lea    0x1(%eax),%edx
c01003eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003f1:	88 90 20 c0 11 c0    	mov    %dl,-0x3fee3fe0(%eax)
c01003f7:	eb 45                	jmp    c010043e <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01003f9:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003fd:	75 16                	jne    c0100415 <readline+0x89>
c01003ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100403:	7e 10                	jle    c0100415 <readline+0x89>
            cputchar(c);
c0100405:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100408:	89 04 24             	mov    %eax,(%esp)
c010040b:	e8 f3 fe ff ff       	call   c0100303 <cputchar>
            i --;
c0100410:	ff 4d f4             	decl   -0xc(%ebp)
c0100413:	eb 29                	jmp    c010043e <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c0100415:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c0100419:	74 06                	je     c0100421 <readline+0x95>
c010041b:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c010041f:	75 95                	jne    c01003b6 <readline+0x2a>
            cputchar(c);
c0100421:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100424:	89 04 24             	mov    %eax,(%esp)
c0100427:	e8 d7 fe ff ff       	call   c0100303 <cputchar>
            buf[i] = '\0';
c010042c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010042f:	05 20 c0 11 c0       	add    $0xc011c020,%eax
c0100434:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c0100437:	b8 20 c0 11 c0       	mov    $0xc011c020,%eax
c010043c:	eb 05                	jmp    c0100443 <readline+0xb7>
        c = getchar();
c010043e:	e9 73 ff ff ff       	jmp    c01003b6 <readline+0x2a>
        }
    }
}
c0100443:	c9                   	leave  
c0100444:	c3                   	ret    

c0100445 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100445:	f3 0f 1e fb          	endbr32 
c0100449:	55                   	push   %ebp
c010044a:	89 e5                	mov    %esp,%ebp
c010044c:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c010044f:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
c0100454:	85 c0                	test   %eax,%eax
c0100456:	75 5b                	jne    c01004b3 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100458:	c7 05 20 c4 11 c0 01 	movl   $0x1,0xc011c420
c010045f:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100462:	8d 45 14             	lea    0x14(%ebp),%eax
c0100465:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100468:	8b 45 0c             	mov    0xc(%ebp),%eax
c010046b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010046f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100472:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100476:	c7 04 24 ce 62 10 c0 	movl   $0xc01062ce,(%esp)
c010047d:	e8 57 fe ff ff       	call   c01002d9 <cprintf>
    vcprintf(fmt, ap);
c0100482:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100485:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100489:	8b 45 10             	mov    0x10(%ebp),%eax
c010048c:	89 04 24             	mov    %eax,(%esp)
c010048f:	e8 0e fe ff ff       	call   c01002a2 <vcprintf>
    cprintf("\n");
c0100494:	c7 04 24 ea 62 10 c0 	movl   $0xc01062ea,(%esp)
c010049b:	e8 39 fe ff ff       	call   c01002d9 <cprintf>
    
    cprintf("stack trackback:\n");
c01004a0:	c7 04 24 ec 62 10 c0 	movl   $0xc01062ec,(%esp)
c01004a7:	e8 2d fe ff ff       	call   c01002d9 <cprintf>
    print_stackframe();
c01004ac:	e8 3d 06 00 00       	call   c0100aee <print_stackframe>
c01004b1:	eb 01                	jmp    c01004b4 <__panic+0x6f>
        goto panic_dead;
c01004b3:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c01004b4:	e8 f6 14 00 00       	call   c01019af <intr_disable>
    while (1) {
        kmonitor(NULL);
c01004b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01004c0:	e8 6f 08 00 00       	call   c0100d34 <kmonitor>
c01004c5:	eb f2                	jmp    c01004b9 <__panic+0x74>

c01004c7 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c01004c7:	f3 0f 1e fb          	endbr32 
c01004cb:	55                   	push   %ebp
c01004cc:	89 e5                	mov    %esp,%ebp
c01004ce:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c01004d1:	8d 45 14             	lea    0x14(%ebp),%eax
c01004d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c01004d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004da:	89 44 24 08          	mov    %eax,0x8(%esp)
c01004de:	8b 45 08             	mov    0x8(%ebp),%eax
c01004e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004e5:	c7 04 24 fe 62 10 c0 	movl   $0xc01062fe,(%esp)
c01004ec:	e8 e8 fd ff ff       	call   c01002d9 <cprintf>
    vcprintf(fmt, ap);
c01004f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004f8:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fb:	89 04 24             	mov    %eax,(%esp)
c01004fe:	e8 9f fd ff ff       	call   c01002a2 <vcprintf>
    cprintf("\n");
c0100503:	c7 04 24 ea 62 10 c0 	movl   $0xc01062ea,(%esp)
c010050a:	e8 ca fd ff ff       	call   c01002d9 <cprintf>
    va_end(ap);
}
c010050f:	90                   	nop
c0100510:	c9                   	leave  
c0100511:	c3                   	ret    

c0100512 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100512:	f3 0f 1e fb          	endbr32 
c0100516:	55                   	push   %ebp
c0100517:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100519:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
}
c010051e:	5d                   	pop    %ebp
c010051f:	c3                   	ret    

c0100520 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100520:	f3 0f 1e fb          	endbr32 
c0100524:	55                   	push   %ebp
c0100525:	89 e5                	mov    %esp,%ebp
c0100527:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c010052a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052d:	8b 00                	mov    (%eax),%eax
c010052f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100532:	8b 45 10             	mov    0x10(%ebp),%eax
c0100535:	8b 00                	mov    (%eax),%eax
c0100537:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010053a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100541:	e9 ca 00 00 00       	jmp    c0100610 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
c0100546:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100549:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010054c:	01 d0                	add    %edx,%eax
c010054e:	89 c2                	mov    %eax,%edx
c0100550:	c1 ea 1f             	shr    $0x1f,%edx
c0100553:	01 d0                	add    %edx,%eax
c0100555:	d1 f8                	sar    %eax
c0100557:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010055a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010055d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100560:	eb 03                	jmp    c0100565 <stab_binsearch+0x45>
            m --;
c0100562:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100565:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100568:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010056b:	7c 1f                	jl     c010058c <stab_binsearch+0x6c>
c010056d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100570:	89 d0                	mov    %edx,%eax
c0100572:	01 c0                	add    %eax,%eax
c0100574:	01 d0                	add    %edx,%eax
c0100576:	c1 e0 02             	shl    $0x2,%eax
c0100579:	89 c2                	mov    %eax,%edx
c010057b:	8b 45 08             	mov    0x8(%ebp),%eax
c010057e:	01 d0                	add    %edx,%eax
c0100580:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100584:	0f b6 c0             	movzbl %al,%eax
c0100587:	39 45 14             	cmp    %eax,0x14(%ebp)
c010058a:	75 d6                	jne    c0100562 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
c010058c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010058f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100592:	7d 09                	jge    c010059d <stab_binsearch+0x7d>
            l = true_m + 1;
c0100594:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100597:	40                   	inc    %eax
c0100598:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010059b:	eb 73                	jmp    c0100610 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
c010059d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c01005a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005a7:	89 d0                	mov    %edx,%eax
c01005a9:	01 c0                	add    %eax,%eax
c01005ab:	01 d0                	add    %edx,%eax
c01005ad:	c1 e0 02             	shl    $0x2,%eax
c01005b0:	89 c2                	mov    %eax,%edx
c01005b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01005b5:	01 d0                	add    %edx,%eax
c01005b7:	8b 40 08             	mov    0x8(%eax),%eax
c01005ba:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005bd:	76 11                	jbe    c01005d0 <stab_binsearch+0xb0>
            *region_left = m;
c01005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c5:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01005c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005ca:	40                   	inc    %eax
c01005cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005ce:	eb 40                	jmp    c0100610 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
c01005d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005d3:	89 d0                	mov    %edx,%eax
c01005d5:	01 c0                	add    %eax,%eax
c01005d7:	01 d0                	add    %edx,%eax
c01005d9:	c1 e0 02             	shl    $0x2,%eax
c01005dc:	89 c2                	mov    %eax,%edx
c01005de:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e1:	01 d0                	add    %edx,%eax
c01005e3:	8b 40 08             	mov    0x8(%eax),%eax
c01005e6:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005e9:	73 14                	jae    c01005ff <stab_binsearch+0xdf>
            *region_right = m - 1;
c01005eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005ee:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01005f4:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005f9:	48                   	dec    %eax
c01005fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005fd:	eb 11                	jmp    c0100610 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100602:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100605:	89 10                	mov    %edx,(%eax)
            l = m;
c0100607:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010060a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010060d:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c0100610:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100613:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100616:	0f 8e 2a ff ff ff    	jle    c0100546 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
c010061c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100620:	75 0f                	jne    c0100631 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
c0100622:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100625:	8b 00                	mov    (%eax),%eax
c0100627:	8d 50 ff             	lea    -0x1(%eax),%edx
c010062a:	8b 45 10             	mov    0x10(%ebp),%eax
c010062d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010062f:	eb 3e                	jmp    c010066f <stab_binsearch+0x14f>
        l = *region_right;
c0100631:	8b 45 10             	mov    0x10(%ebp),%eax
c0100634:	8b 00                	mov    (%eax),%eax
c0100636:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100639:	eb 03                	jmp    c010063e <stab_binsearch+0x11e>
c010063b:	ff 4d fc             	decl   -0x4(%ebp)
c010063e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100641:	8b 00                	mov    (%eax),%eax
c0100643:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100646:	7e 1f                	jle    c0100667 <stab_binsearch+0x147>
c0100648:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010064b:	89 d0                	mov    %edx,%eax
c010064d:	01 c0                	add    %eax,%eax
c010064f:	01 d0                	add    %edx,%eax
c0100651:	c1 e0 02             	shl    $0x2,%eax
c0100654:	89 c2                	mov    %eax,%edx
c0100656:	8b 45 08             	mov    0x8(%ebp),%eax
c0100659:	01 d0                	add    %edx,%eax
c010065b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010065f:	0f b6 c0             	movzbl %al,%eax
c0100662:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100665:	75 d4                	jne    c010063b <stab_binsearch+0x11b>
        *region_left = l;
c0100667:	8b 45 0c             	mov    0xc(%ebp),%eax
c010066a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010066d:	89 10                	mov    %edx,(%eax)
}
c010066f:	90                   	nop
c0100670:	c9                   	leave  
c0100671:	c3                   	ret    

c0100672 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100672:	f3 0f 1e fb          	endbr32 
c0100676:	55                   	push   %ebp
c0100677:	89 e5                	mov    %esp,%ebp
c0100679:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010067c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010067f:	c7 00 1c 63 10 c0    	movl   $0xc010631c,(%eax)
    info->eip_line = 0;
c0100685:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100688:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010068f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100692:	c7 40 08 1c 63 10 c0 	movl   $0xc010631c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100699:	8b 45 0c             	mov    0xc(%ebp),%eax
c010069c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c01006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a6:	8b 55 08             	mov    0x8(%ebp),%edx
c01006a9:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c01006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006af:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c01006b6:	c7 45 f4 98 75 10 c0 	movl   $0xc0107598,-0xc(%ebp)
    stab_end = __STAB_END__;
c01006bd:	c7 45 f0 88 3f 11 c0 	movl   $0xc0113f88,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01006c4:	c7 45 ec 89 3f 11 c0 	movl   $0xc0113f89,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01006cb:	c7 45 e8 b9 6a 11 c0 	movl   $0xc0116ab9,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006d8:	76 0b                	jbe    c01006e5 <debuginfo_eip+0x73>
c01006da:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006dd:	48                   	dec    %eax
c01006de:	0f b6 00             	movzbl (%eax),%eax
c01006e1:	84 c0                	test   %al,%al
c01006e3:	74 0a                	je     c01006ef <debuginfo_eip+0x7d>
        return -1;
c01006e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006ea:	e9 ab 02 00 00       	jmp    c010099a <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006f9:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01006fc:	c1 f8 02             	sar    $0x2,%eax
c01006ff:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100705:	48                   	dec    %eax
c0100706:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c0100709:	8b 45 08             	mov    0x8(%ebp),%eax
c010070c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100710:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c0100717:	00 
c0100718:	8d 45 e0             	lea    -0x20(%ebp),%eax
c010071b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010071f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0100722:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100726:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100729:	89 04 24             	mov    %eax,(%esp)
c010072c:	e8 ef fd ff ff       	call   c0100520 <stab_binsearch>
    if (lfile == 0)
c0100731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100734:	85 c0                	test   %eax,%eax
c0100736:	75 0a                	jne    c0100742 <debuginfo_eip+0xd0>
        return -1;
c0100738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010073d:	e9 58 02 00 00       	jmp    c010099a <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100745:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100748:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010074e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100751:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100755:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010075c:	00 
c010075d:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100760:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100764:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100767:	89 44 24 04          	mov    %eax,0x4(%esp)
c010076b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010076e:	89 04 24             	mov    %eax,(%esp)
c0100771:	e8 aa fd ff ff       	call   c0100520 <stab_binsearch>

    if (lfun <= rfun) {
c0100776:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100779:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010077c:	39 c2                	cmp    %eax,%edx
c010077e:	7f 78                	jg     c01007f8 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100780:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100783:	89 c2                	mov    %eax,%edx
c0100785:	89 d0                	mov    %edx,%eax
c0100787:	01 c0                	add    %eax,%eax
c0100789:	01 d0                	add    %edx,%eax
c010078b:	c1 e0 02             	shl    $0x2,%eax
c010078e:	89 c2                	mov    %eax,%edx
c0100790:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100793:	01 d0                	add    %edx,%eax
c0100795:	8b 10                	mov    (%eax),%edx
c0100797:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010079a:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010079d:	39 c2                	cmp    %eax,%edx
c010079f:	73 22                	jae    c01007c3 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c01007a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007a4:	89 c2                	mov    %eax,%edx
c01007a6:	89 d0                	mov    %edx,%eax
c01007a8:	01 c0                	add    %eax,%eax
c01007aa:	01 d0                	add    %edx,%eax
c01007ac:	c1 e0 02             	shl    $0x2,%eax
c01007af:	89 c2                	mov    %eax,%edx
c01007b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b4:	01 d0                	add    %edx,%eax
c01007b6:	8b 10                	mov    (%eax),%edx
c01007b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007bb:	01 c2                	add    %eax,%edx
c01007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c0:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01007c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	89 d0                	mov    %edx,%eax
c01007ca:	01 c0                	add    %eax,%eax
c01007cc:	01 d0                	add    %edx,%eax
c01007ce:	c1 e0 02             	shl    $0x2,%eax
c01007d1:	89 c2                	mov    %eax,%edx
c01007d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d6:	01 d0                	add    %edx,%eax
c01007d8:	8b 50 08             	mov    0x8(%eax),%edx
c01007db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007de:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e4:	8b 40 10             	mov    0x10(%eax),%eax
c01007e7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007f6:	eb 15                	jmp    c010080d <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007fb:	8b 55 08             	mov    0x8(%ebp),%edx
c01007fe:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c0100801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100804:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100807:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010080a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c010080d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100810:	8b 40 08             	mov    0x8(%eax),%eax
c0100813:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c010081a:	00 
c010081b:	89 04 24             	mov    %eax,(%esp)
c010081e:	e8 3b 50 00 00       	call   c010585e <strfind>
c0100823:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100826:	8b 52 08             	mov    0x8(%edx),%edx
c0100829:	29 d0                	sub    %edx,%eax
c010082b:	89 c2                	mov    %eax,%edx
c010082d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100830:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100833:	8b 45 08             	mov    0x8(%ebp),%eax
c0100836:	89 44 24 10          	mov    %eax,0x10(%esp)
c010083a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100841:	00 
c0100842:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100845:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100849:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010084c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100850:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100853:	89 04 24             	mov    %eax,(%esp)
c0100856:	e8 c5 fc ff ff       	call   c0100520 <stab_binsearch>
    if (lline <= rline) {
c010085b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010085e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100861:	39 c2                	cmp    %eax,%edx
c0100863:	7f 23                	jg     c0100888 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
c0100865:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100868:	89 c2                	mov    %eax,%edx
c010086a:	89 d0                	mov    %edx,%eax
c010086c:	01 c0                	add    %eax,%eax
c010086e:	01 d0                	add    %edx,%eax
c0100870:	c1 e0 02             	shl    $0x2,%eax
c0100873:	89 c2                	mov    %eax,%edx
c0100875:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100878:	01 d0                	add    %edx,%eax
c010087a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010087e:	89 c2                	mov    %eax,%edx
c0100880:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100883:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100886:	eb 11                	jmp    c0100899 <debuginfo_eip+0x227>
        return -1;
c0100888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010088d:	e9 08 01 00 00       	jmp    c010099a <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100892:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100895:	48                   	dec    %eax
c0100896:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100899:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010089c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010089f:	39 c2                	cmp    %eax,%edx
c01008a1:	7c 56                	jl     c01008f9 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
c01008a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008a6:	89 c2                	mov    %eax,%edx
c01008a8:	89 d0                	mov    %edx,%eax
c01008aa:	01 c0                	add    %eax,%eax
c01008ac:	01 d0                	add    %edx,%eax
c01008ae:	c1 e0 02             	shl    $0x2,%eax
c01008b1:	89 c2                	mov    %eax,%edx
c01008b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008b6:	01 d0                	add    %edx,%eax
c01008b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008bc:	3c 84                	cmp    $0x84,%al
c01008be:	74 39                	je     c01008f9 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01008c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008c3:	89 c2                	mov    %eax,%edx
c01008c5:	89 d0                	mov    %edx,%eax
c01008c7:	01 c0                	add    %eax,%eax
c01008c9:	01 d0                	add    %edx,%eax
c01008cb:	c1 e0 02             	shl    $0x2,%eax
c01008ce:	89 c2                	mov    %eax,%edx
c01008d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008d3:	01 d0                	add    %edx,%eax
c01008d5:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008d9:	3c 64                	cmp    $0x64,%al
c01008db:	75 b5                	jne    c0100892 <debuginfo_eip+0x220>
c01008dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008e0:	89 c2                	mov    %eax,%edx
c01008e2:	89 d0                	mov    %edx,%eax
c01008e4:	01 c0                	add    %eax,%eax
c01008e6:	01 d0                	add    %edx,%eax
c01008e8:	c1 e0 02             	shl    $0x2,%eax
c01008eb:	89 c2                	mov    %eax,%edx
c01008ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f0:	01 d0                	add    %edx,%eax
c01008f2:	8b 40 08             	mov    0x8(%eax),%eax
c01008f5:	85 c0                	test   %eax,%eax
c01008f7:	74 99                	je     c0100892 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008ff:	39 c2                	cmp    %eax,%edx
c0100901:	7c 42                	jl     c0100945 <debuginfo_eip+0x2d3>
c0100903:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100906:	89 c2                	mov    %eax,%edx
c0100908:	89 d0                	mov    %edx,%eax
c010090a:	01 c0                	add    %eax,%eax
c010090c:	01 d0                	add    %edx,%eax
c010090e:	c1 e0 02             	shl    $0x2,%eax
c0100911:	89 c2                	mov    %eax,%edx
c0100913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100916:	01 d0                	add    %edx,%eax
c0100918:	8b 10                	mov    (%eax),%edx
c010091a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010091d:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100920:	39 c2                	cmp    %eax,%edx
c0100922:	73 21                	jae    c0100945 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100924:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100927:	89 c2                	mov    %eax,%edx
c0100929:	89 d0                	mov    %edx,%eax
c010092b:	01 c0                	add    %eax,%eax
c010092d:	01 d0                	add    %edx,%eax
c010092f:	c1 e0 02             	shl    $0x2,%eax
c0100932:	89 c2                	mov    %eax,%edx
c0100934:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100937:	01 d0                	add    %edx,%eax
c0100939:	8b 10                	mov    (%eax),%edx
c010093b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010093e:	01 c2                	add    %eax,%edx
c0100940:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100943:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100945:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100948:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010094b:	39 c2                	cmp    %eax,%edx
c010094d:	7d 46                	jge    c0100995 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
c010094f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100952:	40                   	inc    %eax
c0100953:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100956:	eb 16                	jmp    c010096e <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100958:	8b 45 0c             	mov    0xc(%ebp),%eax
c010095b:	8b 40 14             	mov    0x14(%eax),%eax
c010095e:	8d 50 01             	lea    0x1(%eax),%edx
c0100961:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100964:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100967:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010096a:	40                   	inc    %eax
c010096b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010096e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100971:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100974:	39 c2                	cmp    %eax,%edx
c0100976:	7d 1d                	jge    c0100995 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100978:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010097b:	89 c2                	mov    %eax,%edx
c010097d:	89 d0                	mov    %edx,%eax
c010097f:	01 c0                	add    %eax,%eax
c0100981:	01 d0                	add    %edx,%eax
c0100983:	c1 e0 02             	shl    $0x2,%eax
c0100986:	89 c2                	mov    %eax,%edx
c0100988:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010098b:	01 d0                	add    %edx,%eax
c010098d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100991:	3c a0                	cmp    $0xa0,%al
c0100993:	74 c3                	je     c0100958 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
c0100995:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010099a:	c9                   	leave  
c010099b:	c3                   	ret    

c010099c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010099c:	f3 0f 1e fb          	endbr32 
c01009a0:	55                   	push   %ebp
c01009a1:	89 e5                	mov    %esp,%ebp
c01009a3:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c01009a6:	c7 04 24 26 63 10 c0 	movl   $0xc0106326,(%esp)
c01009ad:	e8 27 f9 ff ff       	call   c01002d9 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c01009b2:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01009b9:	c0 
c01009ba:	c7 04 24 3f 63 10 c0 	movl   $0xc010633f,(%esp)
c01009c1:	e8 13 f9 ff ff       	call   c01002d9 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009c6:	c7 44 24 04 0e 62 10 	movl   $0xc010620e,0x4(%esp)
c01009cd:	c0 
c01009ce:	c7 04 24 57 63 10 c0 	movl   $0xc0106357,(%esp)
c01009d5:	e8 ff f8 ff ff       	call   c01002d9 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009da:	c7 44 24 04 00 c0 11 	movl   $0xc011c000,0x4(%esp)
c01009e1:	c0 
c01009e2:	c7 04 24 6f 63 10 c0 	movl   $0xc010636f,(%esp)
c01009e9:	e8 eb f8 ff ff       	call   c01002d9 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009ee:	c7 44 24 04 28 cf 11 	movl   $0xc011cf28,0x4(%esp)
c01009f5:	c0 
c01009f6:	c7 04 24 87 63 10 c0 	movl   $0xc0106387,(%esp)
c01009fd:	e8 d7 f8 ff ff       	call   c01002d9 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100a02:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0100a07:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c0100a0c:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100a11:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100a17:	85 c0                	test   %eax,%eax
c0100a19:	0f 48 c2             	cmovs  %edx,%eax
c0100a1c:	c1 f8 0a             	sar    $0xa,%eax
c0100a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a23:	c7 04 24 a0 63 10 c0 	movl   $0xc01063a0,(%esp)
c0100a2a:	e8 aa f8 ff ff       	call   c01002d9 <cprintf>
}
c0100a2f:	90                   	nop
c0100a30:	c9                   	leave  
c0100a31:	c3                   	ret    

c0100a32 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a32:	f3 0f 1e fb          	endbr32 
c0100a36:	55                   	push   %ebp
c0100a37:	89 e5                	mov    %esp,%ebp
c0100a39:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a3f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a46:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a49:	89 04 24             	mov    %eax,(%esp)
c0100a4c:	e8 21 fc ff ff       	call   c0100672 <debuginfo_eip>
c0100a51:	85 c0                	test   %eax,%eax
c0100a53:	74 15                	je     c0100a6a <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a5c:	c7 04 24 ca 63 10 c0 	movl   $0xc01063ca,(%esp)
c0100a63:	e8 71 f8 ff ff       	call   c01002d9 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a68:	eb 6c                	jmp    c0100ad6 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a71:	eb 1b                	jmp    c0100a8e <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
c0100a73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a79:	01 d0                	add    %edx,%eax
c0100a7b:	0f b6 10             	movzbl (%eax),%edx
c0100a7e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a87:	01 c8                	add    %ecx,%eax
c0100a89:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a8b:	ff 45 f4             	incl   -0xc(%ebp)
c0100a8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a91:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a94:	7c dd                	jl     c0100a73 <print_debuginfo+0x41>
        fnname[j] = '\0';
c0100a96:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a9f:	01 d0                	add    %edx,%eax
c0100aa1:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100aa7:	8b 55 08             	mov    0x8(%ebp),%edx
c0100aaa:	89 d1                	mov    %edx,%ecx
c0100aac:	29 c1                	sub    %eax,%ecx
c0100aae:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100ab1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100ab4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100ab8:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100abe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100ac2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aca:	c7 04 24 e6 63 10 c0 	movl   $0xc01063e6,(%esp)
c0100ad1:	e8 03 f8 ff ff       	call   c01002d9 <cprintf>
}
c0100ad6:	90                   	nop
c0100ad7:	c9                   	leave  
c0100ad8:	c3                   	ret    

c0100ad9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100ad9:	f3 0f 1e fb          	endbr32 
c0100add:	55                   	push   %ebp
c0100ade:	89 e5                	mov    %esp,%ebp
c0100ae0:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100ae3:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ae6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100aec:	c9                   	leave  
c0100aed:	c3                   	ret    

c0100aee <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100aee:	f3 0f 1e fb          	endbr32 
c0100af2:	55                   	push   %ebp
c0100af3:	89 e5                	mov    %esp,%ebp
c0100af5:	53                   	push   %ebx
c0100af6:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100af9:	89 e8                	mov    %ebp,%eax
c0100afb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c0100afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp();
c0100b01:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip = read_eip();
c0100b04:	e8 d0 ff ff ff       	call   c0100ad9 <read_eip>
c0100b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
     for(int i =0;i<=STACKFRAME_DEPTH;i++)
c0100b0c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100b13:	e9 94 00 00 00       	jmp    c0100bac <print_stackframe+0xbe>
     {
        if(ebp==0)
c0100b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b1c:	0f 84 96 00 00 00    	je     c0100bb8 <print_stackframe+0xca>
        {
            break;
        }    
        cprintf("ebp:0x%08x eip:0x%08x",ebp,eip);
c0100b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b25:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b30:	c7 04 24 f8 63 10 c0 	movl   $0xc01063f8,(%esp)
c0100b37:	e8 9d f7 ff ff       	call   c01002d9 <cprintf>
        uint32_t *argu;
        argu = (uint32_t)ebp +2;
c0100b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b3f:	83 c0 02             	add    $0x2,%eax
c0100b42:	89 45 e8             	mov    %eax,-0x18(%ebp)
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x",argu[0],argu[1],argu[2],argu[3]);
c0100b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b48:	83 c0 0c             	add    $0xc,%eax
c0100b4b:	8b 18                	mov    (%eax),%ebx
c0100b4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b50:	83 c0 08             	add    $0x8,%eax
c0100b53:	8b 08                	mov    (%eax),%ecx
c0100b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b58:	83 c0 04             	add    $0x4,%eax
c0100b5b:	8b 10                	mov    (%eax),%edx
c0100b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b60:	8b 00                	mov    (%eax),%eax
c0100b62:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100b66:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100b6a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b72:	c7 04 24 10 64 10 c0 	movl   $0xc0106410,(%esp)
c0100b79:	e8 5b f7 ff ff       	call   c01002d9 <cprintf>
        cprintf("\n");
c0100b7e:	c7 04 24 31 64 10 c0 	movl   $0xc0106431,(%esp)
c0100b85:	e8 4f f7 ff ff       	call   c01002d9 <cprintf>
        print_debuginfo(eip-1);
c0100b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b8d:	48                   	dec    %eax
c0100b8e:	89 04 24             	mov    %eax,(%esp)
c0100b91:	e8 9c fe ff ff       	call   c0100a32 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b99:	83 c0 04             	add    $0x4,%eax
c0100b9c:	8b 00                	mov    (%eax),%eax
c0100b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];      
c0100ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ba4:	8b 00                	mov    (%eax),%eax
c0100ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     for(int i =0;i<=STACKFRAME_DEPTH;i++)
c0100ba9:	ff 45 ec             	incl   -0x14(%ebp)
c0100bac:	83 7d ec 14          	cmpl   $0x14,-0x14(%ebp)
c0100bb0:	0f 8e 62 ff ff ff    	jle    c0100b18 <print_stackframe+0x2a>
     }
}
c0100bb6:	eb 01                	jmp    c0100bb9 <print_stackframe+0xcb>
            break;
c0100bb8:	90                   	nop
}
c0100bb9:	90                   	nop
c0100bba:	83 c4 44             	add    $0x44,%esp
c0100bbd:	5b                   	pop    %ebx
c0100bbe:	5d                   	pop    %ebp
c0100bbf:	c3                   	ret    

c0100bc0 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100bc0:	f3 0f 1e fb          	endbr32 
c0100bc4:	55                   	push   %ebp
c0100bc5:	89 e5                	mov    %esp,%ebp
c0100bc7:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bd1:	eb 0c                	jmp    c0100bdf <parse+0x1f>
            *buf ++ = '\0';
c0100bd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd6:	8d 50 01             	lea    0x1(%eax),%edx
c0100bd9:	89 55 08             	mov    %edx,0x8(%ebp)
c0100bdc:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100be2:	0f b6 00             	movzbl (%eax),%eax
c0100be5:	84 c0                	test   %al,%al
c0100be7:	74 1d                	je     c0100c06 <parse+0x46>
c0100be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bec:	0f b6 00             	movzbl (%eax),%eax
c0100bef:	0f be c0             	movsbl %al,%eax
c0100bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bf6:	c7 04 24 b4 64 10 c0 	movl   $0xc01064b4,(%esp)
c0100bfd:	e8 26 4c 00 00       	call   c0105828 <strchr>
c0100c02:	85 c0                	test   %eax,%eax
c0100c04:	75 cd                	jne    c0100bd3 <parse+0x13>
        }
        if (*buf == '\0') {
c0100c06:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c09:	0f b6 00             	movzbl (%eax),%eax
c0100c0c:	84 c0                	test   %al,%al
c0100c0e:	74 65                	je     c0100c75 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100c10:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100c14:	75 14                	jne    c0100c2a <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100c16:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100c1d:	00 
c0100c1e:	c7 04 24 b9 64 10 c0 	movl   $0xc01064b9,(%esp)
c0100c25:	e8 af f6 ff ff       	call   c01002d9 <cprintf>
        }
        argv[argc ++] = buf;
c0100c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c2d:	8d 50 01             	lea    0x1(%eax),%edx
c0100c30:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100c33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c3d:	01 c2                	add    %eax,%edx
c0100c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c42:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c44:	eb 03                	jmp    c0100c49 <parse+0x89>
            buf ++;
c0100c46:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c4c:	0f b6 00             	movzbl (%eax),%eax
c0100c4f:	84 c0                	test   %al,%al
c0100c51:	74 8c                	je     c0100bdf <parse+0x1f>
c0100c53:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c56:	0f b6 00             	movzbl (%eax),%eax
c0100c59:	0f be c0             	movsbl %al,%eax
c0100c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c60:	c7 04 24 b4 64 10 c0 	movl   $0xc01064b4,(%esp)
c0100c67:	e8 bc 4b 00 00       	call   c0105828 <strchr>
c0100c6c:	85 c0                	test   %eax,%eax
c0100c6e:	74 d6                	je     c0100c46 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c70:	e9 6a ff ff ff       	jmp    c0100bdf <parse+0x1f>
            break;
c0100c75:	90                   	nop
        }
    }
    return argc;
c0100c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c79:	c9                   	leave  
c0100c7a:	c3                   	ret    

c0100c7b <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c7b:	f3 0f 1e fb          	endbr32 
c0100c7f:	55                   	push   %ebp
c0100c80:	89 e5                	mov    %esp,%ebp
c0100c82:	53                   	push   %ebx
c0100c83:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c86:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c90:	89 04 24             	mov    %eax,(%esp)
c0100c93:	e8 28 ff ff ff       	call   c0100bc0 <parse>
c0100c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c9f:	75 0a                	jne    c0100cab <runcmd+0x30>
        return 0;
c0100ca1:	b8 00 00 00 00       	mov    $0x0,%eax
c0100ca6:	e9 83 00 00 00       	jmp    c0100d2e <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100cb2:	eb 5a                	jmp    c0100d0e <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100cb4:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cba:	89 d0                	mov    %edx,%eax
c0100cbc:	01 c0                	add    %eax,%eax
c0100cbe:	01 d0                	add    %edx,%eax
c0100cc0:	c1 e0 02             	shl    $0x2,%eax
c0100cc3:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100cc8:	8b 00                	mov    (%eax),%eax
c0100cca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100cce:	89 04 24             	mov    %eax,(%esp)
c0100cd1:	e8 ae 4a 00 00       	call   c0105784 <strcmp>
c0100cd6:	85 c0                	test   %eax,%eax
c0100cd8:	75 31                	jne    c0100d0b <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100cda:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cdd:	89 d0                	mov    %edx,%eax
c0100cdf:	01 c0                	add    %eax,%eax
c0100ce1:	01 d0                	add    %edx,%eax
c0100ce3:	c1 e0 02             	shl    $0x2,%eax
c0100ce6:	05 08 90 11 c0       	add    $0xc0119008,%eax
c0100ceb:	8b 10                	mov    (%eax),%edx
c0100ced:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100cf0:	83 c0 04             	add    $0x4,%eax
c0100cf3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100cf6:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100cfc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d04:	89 1c 24             	mov    %ebx,(%esp)
c0100d07:	ff d2                	call   *%edx
c0100d09:	eb 23                	jmp    c0100d2e <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d0b:	ff 45 f4             	incl   -0xc(%ebp)
c0100d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d11:	83 f8 02             	cmp    $0x2,%eax
c0100d14:	76 9e                	jbe    c0100cb4 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100d16:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100d19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1d:	c7 04 24 d7 64 10 c0 	movl   $0xc01064d7,(%esp)
c0100d24:	e8 b0 f5 ff ff       	call   c01002d9 <cprintf>
    return 0;
c0100d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d2e:	83 c4 64             	add    $0x64,%esp
c0100d31:	5b                   	pop    %ebx
c0100d32:	5d                   	pop    %ebp
c0100d33:	c3                   	ret    

c0100d34 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100d34:	f3 0f 1e fb          	endbr32 
c0100d38:	55                   	push   %ebp
c0100d39:	89 e5                	mov    %esp,%ebp
c0100d3b:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100d3e:	c7 04 24 f0 64 10 c0 	movl   $0xc01064f0,(%esp)
c0100d45:	e8 8f f5 ff ff       	call   c01002d9 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d4a:	c7 04 24 18 65 10 c0 	movl   $0xc0106518,(%esp)
c0100d51:	e8 83 f5 ff ff       	call   c01002d9 <cprintf>

    if (tf != NULL) {
c0100d56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d5a:	74 0b                	je     c0100d67 <kmonitor+0x33>
        print_trapframe(tf);
c0100d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d5f:	89 04 24             	mov    %eax,(%esp)
c0100d62:	e8 5e 0e 00 00       	call   c0101bc5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d67:	c7 04 24 3d 65 10 c0 	movl   $0xc010653d,(%esp)
c0100d6e:	e8 19 f6 ff ff       	call   c010038c <readline>
c0100d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d7a:	74 eb                	je     c0100d67 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
c0100d7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d86:	89 04 24             	mov    %eax,(%esp)
c0100d89:	e8 ed fe ff ff       	call   c0100c7b <runcmd>
c0100d8e:	85 c0                	test   %eax,%eax
c0100d90:	78 02                	js     c0100d94 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
c0100d92:	eb d3                	jmp    c0100d67 <kmonitor+0x33>
                break;
c0100d94:	90                   	nop
            }
        }
    }
}
c0100d95:	90                   	nop
c0100d96:	c9                   	leave  
c0100d97:	c3                   	ret    

c0100d98 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d98:	f3 0f 1e fb          	endbr32 
c0100d9c:	55                   	push   %ebp
c0100d9d:	89 e5                	mov    %esp,%ebp
c0100d9f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100da2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100da9:	eb 3d                	jmp    c0100de8 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100dab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100dae:	89 d0                	mov    %edx,%eax
c0100db0:	01 c0                	add    %eax,%eax
c0100db2:	01 d0                	add    %edx,%eax
c0100db4:	c1 e0 02             	shl    $0x2,%eax
c0100db7:	05 04 90 11 c0       	add    $0xc0119004,%eax
c0100dbc:	8b 08                	mov    (%eax),%ecx
c0100dbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100dc1:	89 d0                	mov    %edx,%eax
c0100dc3:	01 c0                	add    %eax,%eax
c0100dc5:	01 d0                	add    %edx,%eax
c0100dc7:	c1 e0 02             	shl    $0x2,%eax
c0100dca:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100dcf:	8b 00                	mov    (%eax),%eax
c0100dd1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100dd9:	c7 04 24 41 65 10 c0 	movl   $0xc0106541,(%esp)
c0100de0:	e8 f4 f4 ff ff       	call   c01002d9 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100de5:	ff 45 f4             	incl   -0xc(%ebp)
c0100de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100deb:	83 f8 02             	cmp    $0x2,%eax
c0100dee:	76 bb                	jbe    c0100dab <mon_help+0x13>
    }
    return 0;
c0100df0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df5:	c9                   	leave  
c0100df6:	c3                   	ret    

c0100df7 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100df7:	f3 0f 1e fb          	endbr32 
c0100dfb:	55                   	push   %ebp
c0100dfc:	89 e5                	mov    %esp,%ebp
c0100dfe:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100e01:	e8 96 fb ff ff       	call   c010099c <print_kerninfo>
    return 0;
c0100e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e0b:	c9                   	leave  
c0100e0c:	c3                   	ret    

c0100e0d <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100e0d:	f3 0f 1e fb          	endbr32 
c0100e11:	55                   	push   %ebp
c0100e12:	89 e5                	mov    %esp,%ebp
c0100e14:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100e17:	e8 d2 fc ff ff       	call   c0100aee <print_stackframe>
    return 0;
c0100e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e21:	c9                   	leave  
c0100e22:	c3                   	ret    

c0100e23 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100e23:	f3 0f 1e fb          	endbr32 
c0100e27:	55                   	push   %ebp
c0100e28:	89 e5                	mov    %esp,%ebp
c0100e2a:	83 ec 28             	sub    $0x28,%esp
c0100e2d:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100e33:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e37:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e3b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e3f:	ee                   	out    %al,(%dx)
}
c0100e40:	90                   	nop
c0100e41:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100e47:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e4b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e4f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e53:	ee                   	out    %al,(%dx)
}
c0100e54:	90                   	nop
c0100e55:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100e5b:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e5f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e63:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e67:	ee                   	out    %al,(%dx)
}
c0100e68:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e69:	c7 05 0c cf 11 c0 00 	movl   $0x0,0xc011cf0c
c0100e70:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e73:	c7 04 24 4a 65 10 c0 	movl   $0xc010654a,(%esp)
c0100e7a:	e8 5a f4 ff ff       	call   c01002d9 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e86:	e8 95 09 00 00       	call   c0101820 <pic_enable>
}
c0100e8b:	90                   	nop
c0100e8c:	c9                   	leave  
c0100e8d:	c3                   	ret    

c0100e8e <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e8e:	55                   	push   %ebp
c0100e8f:	89 e5                	mov    %esp,%ebp
c0100e91:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e94:	9c                   	pushf  
c0100e95:	58                   	pop    %eax
c0100e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e9c:	25 00 02 00 00       	and    $0x200,%eax
c0100ea1:	85 c0                	test   %eax,%eax
c0100ea3:	74 0c                	je     c0100eb1 <__intr_save+0x23>
        intr_disable();
c0100ea5:	e8 05 0b 00 00       	call   c01019af <intr_disable>
        return 1;
c0100eaa:	b8 01 00 00 00       	mov    $0x1,%eax
c0100eaf:	eb 05                	jmp    c0100eb6 <__intr_save+0x28>
    }
    return 0;
c0100eb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100eb6:	c9                   	leave  
c0100eb7:	c3                   	ret    

c0100eb8 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100eb8:	55                   	push   %ebp
c0100eb9:	89 e5                	mov    %esp,%ebp
c0100ebb:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100ebe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ec2:	74 05                	je     c0100ec9 <__intr_restore+0x11>
        intr_enable();
c0100ec4:	e8 da 0a 00 00       	call   c01019a3 <intr_enable>
    }
}
c0100ec9:	90                   	nop
c0100eca:	c9                   	leave  
c0100ecb:	c3                   	ret    

c0100ecc <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100ecc:	f3 0f 1e fb          	endbr32 
c0100ed0:	55                   	push   %ebp
c0100ed1:	89 e5                	mov    %esp,%ebp
c0100ed3:	83 ec 10             	sub    $0x10,%esp
c0100ed6:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100edc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ee0:	89 c2                	mov    %eax,%edx
c0100ee2:	ec                   	in     (%dx),%al
c0100ee3:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100ee6:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100eec:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100ef0:	89 c2                	mov    %eax,%edx
c0100ef2:	ec                   	in     (%dx),%al
c0100ef3:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100ef6:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100efc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100f00:	89 c2                	mov    %eax,%edx
c0100f02:	ec                   	in     (%dx),%al
c0100f03:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100f06:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100f0c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100f10:	89 c2                	mov    %eax,%edx
c0100f12:	ec                   	in     (%dx),%al
c0100f13:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100f16:	90                   	nop
c0100f17:	c9                   	leave  
c0100f18:	c3                   	ret    

c0100f19 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100f19:	f3 0f 1e fb          	endbr32 
c0100f1d:	55                   	push   %ebp
c0100f1e:	89 e5                	mov    %esp,%ebp
c0100f20:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100f23:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f2d:	0f b7 00             	movzwl (%eax),%eax
c0100f30:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f37:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f3f:	0f b7 00             	movzwl (%eax),%eax
c0100f42:	0f b7 c0             	movzwl %ax,%eax
c0100f45:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100f4a:	74 12                	je     c0100f5e <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100f4c:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100f53:	66 c7 05 46 c4 11 c0 	movw   $0x3b4,0xc011c446
c0100f5a:	b4 03 
c0100f5c:	eb 13                	jmp    c0100f71 <cga_init+0x58>
    } else {
        *cp = was;
c0100f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f61:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f65:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f68:	66 c7 05 46 c4 11 c0 	movw   $0x3d4,0xc011c446
c0100f6f:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f71:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f78:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f7c:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f80:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f84:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f88:	ee                   	out    %al,(%dx)
}
c0100f89:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f8a:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f91:	40                   	inc    %eax
c0100f92:	0f b7 c0             	movzwl %ax,%eax
c0100f95:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f99:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f9d:	89 c2                	mov    %eax,%edx
c0100f9f:	ec                   	in     (%dx),%al
c0100fa0:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100fa3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa7:	0f b6 c0             	movzbl %al,%eax
c0100faa:	c1 e0 08             	shl    $0x8,%eax
c0100fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100fb0:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100fb7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100fbb:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fbf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fc3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fc7:	ee                   	out    %al,(%dx)
}
c0100fc8:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100fc9:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100fd0:	40                   	inc    %eax
c0100fd1:	0f b7 c0             	movzwl %ax,%eax
c0100fd4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fd8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100fdc:	89 c2                	mov    %eax,%edx
c0100fde:	ec                   	in     (%dx),%al
c0100fdf:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100fe2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fe6:	0f b6 c0             	movzbl %al,%eax
c0100fe9:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100fec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fef:	a3 40 c4 11 c0       	mov    %eax,0xc011c440
    crt_pos = pos;
c0100ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ff7:	0f b7 c0             	movzwl %ax,%eax
c0100ffa:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
}
c0101000:	90                   	nop
c0101001:	c9                   	leave  
c0101002:	c3                   	ret    

c0101003 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0101003:	f3 0f 1e fb          	endbr32 
c0101007:	55                   	push   %ebp
c0101008:	89 e5                	mov    %esp,%ebp
c010100a:	83 ec 48             	sub    $0x48,%esp
c010100d:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0101013:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101017:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010101b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010101f:	ee                   	out    %al,(%dx)
}
c0101020:	90                   	nop
c0101021:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0101027:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010102b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010102f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101033:	ee                   	out    %al,(%dx)
}
c0101034:	90                   	nop
c0101035:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c010103b:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010103f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101043:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101047:	ee                   	out    %al,(%dx)
}
c0101048:	90                   	nop
c0101049:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c010104f:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101053:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101057:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010105b:	ee                   	out    %al,(%dx)
}
c010105c:	90                   	nop
c010105d:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0101063:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101067:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010106b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010106f:	ee                   	out    %al,(%dx)
}
c0101070:	90                   	nop
c0101071:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101077:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010107b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010107f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101083:	ee                   	out    %al,(%dx)
}
c0101084:	90                   	nop
c0101085:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010108b:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010108f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101093:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101097:	ee                   	out    %al,(%dx)
}
c0101098:	90                   	nop
c0101099:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010109f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c01010a3:	89 c2                	mov    %eax,%edx
c01010a5:	ec                   	in     (%dx),%al
c01010a6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c01010a9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c01010ad:	3c ff                	cmp    $0xff,%al
c01010af:	0f 95 c0             	setne  %al
c01010b2:	0f b6 c0             	movzbl %al,%eax
c01010b5:	a3 48 c4 11 c0       	mov    %eax,0xc011c448
c01010ba:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01010c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01010c4:	89 c2                	mov    %eax,%edx
c01010c6:	ec                   	in     (%dx),%al
c01010c7:	88 45 f1             	mov    %al,-0xf(%ebp)
c01010ca:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01010d0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010d4:	89 c2                	mov    %eax,%edx
c01010d6:	ec                   	in     (%dx),%al
c01010d7:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01010da:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01010df:	85 c0                	test   %eax,%eax
c01010e1:	74 0c                	je     c01010ef <serial_init+0xec>
        pic_enable(IRQ_COM1);
c01010e3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01010ea:	e8 31 07 00 00       	call   c0101820 <pic_enable>
    }
}
c01010ef:	90                   	nop
c01010f0:	c9                   	leave  
c01010f1:	c3                   	ret    

c01010f2 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01010f2:	f3 0f 1e fb          	endbr32 
c01010f6:	55                   	push   %ebp
c01010f7:	89 e5                	mov    %esp,%ebp
c01010f9:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101103:	eb 08                	jmp    c010110d <lpt_putc_sub+0x1b>
        delay();
c0101105:	e8 c2 fd ff ff       	call   c0100ecc <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010110a:	ff 45 fc             	incl   -0x4(%ebp)
c010110d:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101113:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101117:	89 c2                	mov    %eax,%edx
c0101119:	ec                   	in     (%dx),%al
c010111a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010111d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101121:	84 c0                	test   %al,%al
c0101123:	78 09                	js     c010112e <lpt_putc_sub+0x3c>
c0101125:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010112c:	7e d7                	jle    c0101105 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
c010112e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101131:	0f b6 c0             	movzbl %al,%eax
c0101134:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c010113a:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010113d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101141:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101145:	ee                   	out    %al,(%dx)
}
c0101146:	90                   	nop
c0101147:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010114d:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101151:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101155:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101159:	ee                   	out    %al,(%dx)
}
c010115a:	90                   	nop
c010115b:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101161:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101165:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101169:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010116d:	ee                   	out    %al,(%dx)
}
c010116e:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010116f:	90                   	nop
c0101170:	c9                   	leave  
c0101171:	c3                   	ret    

c0101172 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101172:	f3 0f 1e fb          	endbr32 
c0101176:	55                   	push   %ebp
c0101177:	89 e5                	mov    %esp,%ebp
c0101179:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010117c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101180:	74 0d                	je     c010118f <lpt_putc+0x1d>
        lpt_putc_sub(c);
c0101182:	8b 45 08             	mov    0x8(%ebp),%eax
c0101185:	89 04 24             	mov    %eax,(%esp)
c0101188:	e8 65 ff ff ff       	call   c01010f2 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010118d:	eb 24                	jmp    c01011b3 <lpt_putc+0x41>
        lpt_putc_sub('\b');
c010118f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101196:	e8 57 ff ff ff       	call   c01010f2 <lpt_putc_sub>
        lpt_putc_sub(' ');
c010119b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01011a2:	e8 4b ff ff ff       	call   c01010f2 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01011a7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011ae:	e8 3f ff ff ff       	call   c01010f2 <lpt_putc_sub>
}
c01011b3:	90                   	nop
c01011b4:	c9                   	leave  
c01011b5:	c3                   	ret    

c01011b6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01011b6:	f3 0f 1e fb          	endbr32 
c01011ba:	55                   	push   %ebp
c01011bb:	89 e5                	mov    %esp,%ebp
c01011bd:	53                   	push   %ebx
c01011be:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01011c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c4:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011c9:	85 c0                	test   %eax,%eax
c01011cb:	75 07                	jne    c01011d4 <cga_putc+0x1e>
        c |= 0x0700;
c01011cd:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01011d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d7:	0f b6 c0             	movzbl %al,%eax
c01011da:	83 f8 0d             	cmp    $0xd,%eax
c01011dd:	74 72                	je     c0101251 <cga_putc+0x9b>
c01011df:	83 f8 0d             	cmp    $0xd,%eax
c01011e2:	0f 8f a3 00 00 00    	jg     c010128b <cga_putc+0xd5>
c01011e8:	83 f8 08             	cmp    $0x8,%eax
c01011eb:	74 0a                	je     c01011f7 <cga_putc+0x41>
c01011ed:	83 f8 0a             	cmp    $0xa,%eax
c01011f0:	74 4c                	je     c010123e <cga_putc+0x88>
c01011f2:	e9 94 00 00 00       	jmp    c010128b <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
c01011f7:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011fe:	85 c0                	test   %eax,%eax
c0101200:	0f 84 af 00 00 00    	je     c01012b5 <cga_putc+0xff>
            crt_pos --;
c0101206:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010120d:	48                   	dec    %eax
c010120e:	0f b7 c0             	movzwl %ax,%eax
c0101211:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101217:	8b 45 08             	mov    0x8(%ebp),%eax
c010121a:	98                   	cwtl   
c010121b:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101220:	98                   	cwtl   
c0101221:	83 c8 20             	or     $0x20,%eax
c0101224:	98                   	cwtl   
c0101225:	8b 15 40 c4 11 c0    	mov    0xc011c440,%edx
c010122b:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c0101232:	01 c9                	add    %ecx,%ecx
c0101234:	01 ca                	add    %ecx,%edx
c0101236:	0f b7 c0             	movzwl %ax,%eax
c0101239:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010123c:	eb 77                	jmp    c01012b5 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
c010123e:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101245:	83 c0 50             	add    $0x50,%eax
c0101248:	0f b7 c0             	movzwl %ax,%eax
c010124b:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101251:	0f b7 1d 44 c4 11 c0 	movzwl 0xc011c444,%ebx
c0101258:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c010125f:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c0101264:	89 c8                	mov    %ecx,%eax
c0101266:	f7 e2                	mul    %edx
c0101268:	c1 ea 06             	shr    $0x6,%edx
c010126b:	89 d0                	mov    %edx,%eax
c010126d:	c1 e0 02             	shl    $0x2,%eax
c0101270:	01 d0                	add    %edx,%eax
c0101272:	c1 e0 04             	shl    $0x4,%eax
c0101275:	29 c1                	sub    %eax,%ecx
c0101277:	89 c8                	mov    %ecx,%eax
c0101279:	0f b7 c0             	movzwl %ax,%eax
c010127c:	29 c3                	sub    %eax,%ebx
c010127e:	89 d8                	mov    %ebx,%eax
c0101280:	0f b7 c0             	movzwl %ax,%eax
c0101283:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
        break;
c0101289:	eb 2b                	jmp    c01012b6 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010128b:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c0101291:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101298:	8d 50 01             	lea    0x1(%eax),%edx
c010129b:	0f b7 d2             	movzwl %dx,%edx
c010129e:	66 89 15 44 c4 11 c0 	mov    %dx,0xc011c444
c01012a5:	01 c0                	add    %eax,%eax
c01012a7:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01012aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01012ad:	0f b7 c0             	movzwl %ax,%eax
c01012b0:	66 89 02             	mov    %ax,(%edx)
        break;
c01012b3:	eb 01                	jmp    c01012b6 <cga_putc+0x100>
        break;
c01012b5:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01012b6:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012bd:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c01012c2:	76 5d                	jbe    c0101321 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01012c4:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01012c9:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01012cf:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01012d4:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012db:	00 
c01012dc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01012e0:	89 04 24             	mov    %eax,(%esp)
c01012e3:	e8 45 47 00 00       	call   c0105a2d <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012e8:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01012ef:	eb 14                	jmp    c0101305 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
c01012f1:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012f9:	01 d2                	add    %edx,%edx
c01012fb:	01 d0                	add    %edx,%eax
c01012fd:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101302:	ff 45 f4             	incl   -0xc(%ebp)
c0101305:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010130c:	7e e3                	jle    c01012f1 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
c010130e:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101315:	83 e8 50             	sub    $0x50,%eax
c0101318:	0f b7 c0             	movzwl %ax,%eax
c010131b:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101321:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0101328:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c010132c:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101330:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101334:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101338:	ee                   	out    %al,(%dx)
}
c0101339:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c010133a:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101341:	c1 e8 08             	shr    $0x8,%eax
c0101344:	0f b7 c0             	movzwl %ax,%eax
c0101347:	0f b6 c0             	movzbl %al,%eax
c010134a:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c0101351:	42                   	inc    %edx
c0101352:	0f b7 d2             	movzwl %dx,%edx
c0101355:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101359:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010135c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101360:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101364:	ee                   	out    %al,(%dx)
}
c0101365:	90                   	nop
    outb(addr_6845, 15);
c0101366:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c010136d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101371:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101375:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101379:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010137d:	ee                   	out    %al,(%dx)
}
c010137e:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c010137f:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101386:	0f b6 c0             	movzbl %al,%eax
c0101389:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c0101390:	42                   	inc    %edx
c0101391:	0f b7 d2             	movzwl %dx,%edx
c0101394:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101398:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010139b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010139f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01013a3:	ee                   	out    %al,(%dx)
}
c01013a4:	90                   	nop
}
c01013a5:	90                   	nop
c01013a6:	83 c4 34             	add    $0x34,%esp
c01013a9:	5b                   	pop    %ebx
c01013aa:	5d                   	pop    %ebp
c01013ab:	c3                   	ret    

c01013ac <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01013ac:	f3 0f 1e fb          	endbr32 
c01013b0:	55                   	push   %ebp
c01013b1:	89 e5                	mov    %esp,%ebp
c01013b3:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01013bd:	eb 08                	jmp    c01013c7 <serial_putc_sub+0x1b>
        delay();
c01013bf:	e8 08 fb ff ff       	call   c0100ecc <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013c4:	ff 45 fc             	incl   -0x4(%ebp)
c01013c7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013cd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013d1:	89 c2                	mov    %eax,%edx
c01013d3:	ec                   	in     (%dx),%al
c01013d4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013d7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013db:	0f b6 c0             	movzbl %al,%eax
c01013de:	83 e0 20             	and    $0x20,%eax
c01013e1:	85 c0                	test   %eax,%eax
c01013e3:	75 09                	jne    c01013ee <serial_putc_sub+0x42>
c01013e5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01013ec:	7e d1                	jle    c01013bf <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
c01013ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01013f1:	0f b6 c0             	movzbl %al,%eax
c01013f4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01013fa:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013fd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101401:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101405:	ee                   	out    %al,(%dx)
}
c0101406:	90                   	nop
}
c0101407:	90                   	nop
c0101408:	c9                   	leave  
c0101409:	c3                   	ret    

c010140a <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010140a:	f3 0f 1e fb          	endbr32 
c010140e:	55                   	push   %ebp
c010140f:	89 e5                	mov    %esp,%ebp
c0101411:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101414:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101418:	74 0d                	je     c0101427 <serial_putc+0x1d>
        serial_putc_sub(c);
c010141a:	8b 45 08             	mov    0x8(%ebp),%eax
c010141d:	89 04 24             	mov    %eax,(%esp)
c0101420:	e8 87 ff ff ff       	call   c01013ac <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101425:	eb 24                	jmp    c010144b <serial_putc+0x41>
        serial_putc_sub('\b');
c0101427:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010142e:	e8 79 ff ff ff       	call   c01013ac <serial_putc_sub>
        serial_putc_sub(' ');
c0101433:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010143a:	e8 6d ff ff ff       	call   c01013ac <serial_putc_sub>
        serial_putc_sub('\b');
c010143f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101446:	e8 61 ff ff ff       	call   c01013ac <serial_putc_sub>
}
c010144b:	90                   	nop
c010144c:	c9                   	leave  
c010144d:	c3                   	ret    

c010144e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010144e:	f3 0f 1e fb          	endbr32 
c0101452:	55                   	push   %ebp
c0101453:	89 e5                	mov    %esp,%ebp
c0101455:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101458:	eb 33                	jmp    c010148d <cons_intr+0x3f>
        if (c != 0) {
c010145a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010145e:	74 2d                	je     c010148d <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
c0101460:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101465:	8d 50 01             	lea    0x1(%eax),%edx
c0101468:	89 15 64 c6 11 c0    	mov    %edx,0xc011c664
c010146e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101471:	88 90 60 c4 11 c0    	mov    %dl,-0x3fee3ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101477:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c010147c:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101481:	75 0a                	jne    c010148d <cons_intr+0x3f>
                cons.wpos = 0;
c0101483:	c7 05 64 c6 11 c0 00 	movl   $0x0,0xc011c664
c010148a:	00 00 00 
    while ((c = (*proc)()) != -1) {
c010148d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101490:	ff d0                	call   *%eax
c0101492:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101495:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101499:	75 bf                	jne    c010145a <cons_intr+0xc>
            }
        }
    }
}
c010149b:	90                   	nop
c010149c:	90                   	nop
c010149d:	c9                   	leave  
c010149e:	c3                   	ret    

c010149f <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010149f:	f3 0f 1e fb          	endbr32 
c01014a3:	55                   	push   %ebp
c01014a4:	89 e5                	mov    %esp,%ebp
c01014a6:	83 ec 10             	sub    $0x10,%esp
c01014a9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014af:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01014b3:	89 c2                	mov    %eax,%edx
c01014b5:	ec                   	in     (%dx),%al
c01014b6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01014b9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01014bd:	0f b6 c0             	movzbl %al,%eax
c01014c0:	83 e0 01             	and    $0x1,%eax
c01014c3:	85 c0                	test   %eax,%eax
c01014c5:	75 07                	jne    c01014ce <serial_proc_data+0x2f>
        return -1;
c01014c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014cc:	eb 2a                	jmp    c01014f8 <serial_proc_data+0x59>
c01014ce:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014d4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014d8:	89 c2                	mov    %eax,%edx
c01014da:	ec                   	in     (%dx),%al
c01014db:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014de:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014e2:	0f b6 c0             	movzbl %al,%eax
c01014e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014e8:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014ec:	75 07                	jne    c01014f5 <serial_proc_data+0x56>
        c = '\b';
c01014ee:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01014f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01014f8:	c9                   	leave  
c01014f9:	c3                   	ret    

c01014fa <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01014fa:	f3 0f 1e fb          	endbr32 
c01014fe:	55                   	push   %ebp
c01014ff:	89 e5                	mov    %esp,%ebp
c0101501:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101504:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c0101509:	85 c0                	test   %eax,%eax
c010150b:	74 0c                	je     c0101519 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c010150d:	c7 04 24 9f 14 10 c0 	movl   $0xc010149f,(%esp)
c0101514:	e8 35 ff ff ff       	call   c010144e <cons_intr>
    }
}
c0101519:	90                   	nop
c010151a:	c9                   	leave  
c010151b:	c3                   	ret    

c010151c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010151c:	f3 0f 1e fb          	endbr32 
c0101520:	55                   	push   %ebp
c0101521:	89 e5                	mov    %esp,%ebp
c0101523:	83 ec 38             	sub    $0x38,%esp
c0101526:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010152f:	89 c2                	mov    %eax,%edx
c0101531:	ec                   	in     (%dx),%al
c0101532:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101535:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101539:	0f b6 c0             	movzbl %al,%eax
c010153c:	83 e0 01             	and    $0x1,%eax
c010153f:	85 c0                	test   %eax,%eax
c0101541:	75 0a                	jne    c010154d <kbd_proc_data+0x31>
        return -1;
c0101543:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101548:	e9 56 01 00 00       	jmp    c01016a3 <kbd_proc_data+0x187>
c010154d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101553:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101556:	89 c2                	mov    %eax,%edx
c0101558:	ec                   	in     (%dx),%al
c0101559:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010155c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101560:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101563:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101567:	75 17                	jne    c0101580 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
c0101569:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010156e:	83 c8 40             	or     $0x40,%eax
c0101571:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101576:	b8 00 00 00 00       	mov    $0x0,%eax
c010157b:	e9 23 01 00 00       	jmp    c01016a3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101580:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101584:	84 c0                	test   %al,%al
c0101586:	79 45                	jns    c01015cd <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101588:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010158d:	83 e0 40             	and    $0x40,%eax
c0101590:	85 c0                	test   %eax,%eax
c0101592:	75 08                	jne    c010159c <kbd_proc_data+0x80>
c0101594:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101598:	24 7f                	and    $0x7f,%al
c010159a:	eb 04                	jmp    c01015a0 <kbd_proc_data+0x84>
c010159c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01015a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a7:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c01015ae:	0c 40                	or     $0x40,%al
c01015b0:	0f b6 c0             	movzbl %al,%eax
c01015b3:	f7 d0                	not    %eax
c01015b5:	89 c2                	mov    %eax,%edx
c01015b7:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015bc:	21 d0                	and    %edx,%eax
c01015be:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c01015c3:	b8 00 00 00 00       	mov    $0x0,%eax
c01015c8:	e9 d6 00 00 00       	jmp    c01016a3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01015cd:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015d2:	83 e0 40             	and    $0x40,%eax
c01015d5:	85 c0                	test   %eax,%eax
c01015d7:	74 11                	je     c01015ea <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015d9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015dd:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015e2:	83 e0 bf             	and    $0xffffffbf,%eax
c01015e5:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    }

    shift |= shiftcode[data];
c01015ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015ee:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c01015f5:	0f b6 d0             	movzbl %al,%edx
c01015f8:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015fd:	09 d0                	or     %edx,%eax
c01015ff:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    shift ^= togglecode[data];
c0101604:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101608:	0f b6 80 40 91 11 c0 	movzbl -0x3fee6ec0(%eax),%eax
c010160f:	0f b6 d0             	movzbl %al,%edx
c0101612:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101617:	31 d0                	xor    %edx,%eax
c0101619:	a3 68 c6 11 c0       	mov    %eax,0xc011c668

    c = charcode[shift & (CTL | SHIFT)][data];
c010161e:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101623:	83 e0 03             	and    $0x3,%eax
c0101626:	8b 14 85 40 95 11 c0 	mov    -0x3fee6ac0(,%eax,4),%edx
c010162d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101631:	01 d0                	add    %edx,%eax
c0101633:	0f b6 00             	movzbl (%eax),%eax
c0101636:	0f b6 c0             	movzbl %al,%eax
c0101639:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010163c:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101641:	83 e0 08             	and    $0x8,%eax
c0101644:	85 c0                	test   %eax,%eax
c0101646:	74 22                	je     c010166a <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101648:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010164c:	7e 0c                	jle    c010165a <kbd_proc_data+0x13e>
c010164e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101652:	7f 06                	jg     c010165a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101654:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101658:	eb 10                	jmp    c010166a <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010165a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010165e:	7e 0a                	jle    c010166a <kbd_proc_data+0x14e>
c0101660:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101664:	7f 04                	jg     c010166a <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101666:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010166a:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010166f:	f7 d0                	not    %eax
c0101671:	83 e0 06             	and    $0x6,%eax
c0101674:	85 c0                	test   %eax,%eax
c0101676:	75 28                	jne    c01016a0 <kbd_proc_data+0x184>
c0101678:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010167f:	75 1f                	jne    c01016a0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101681:	c7 04 24 65 65 10 c0 	movl   $0xc0106565,(%esp)
c0101688:	e8 4c ec ff ff       	call   c01002d9 <cprintf>
c010168d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101693:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101697:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010169b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010169e:	ee                   	out    %al,(%dx)
}
c010169f:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a3:	c9                   	leave  
c01016a4:	c3                   	ret    

c01016a5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01016a5:	f3 0f 1e fb          	endbr32 
c01016a9:	55                   	push   %ebp
c01016aa:	89 e5                	mov    %esp,%ebp
c01016ac:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01016af:	c7 04 24 1c 15 10 c0 	movl   $0xc010151c,(%esp)
c01016b6:	e8 93 fd ff ff       	call   c010144e <cons_intr>
}
c01016bb:	90                   	nop
c01016bc:	c9                   	leave  
c01016bd:	c3                   	ret    

c01016be <kbd_init>:

static void
kbd_init(void) {
c01016be:	f3 0f 1e fb          	endbr32 
c01016c2:	55                   	push   %ebp
c01016c3:	89 e5                	mov    %esp,%ebp
c01016c5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01016c8:	e8 d8 ff ff ff       	call   c01016a5 <kbd_intr>
    pic_enable(IRQ_KBD);
c01016cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016d4:	e8 47 01 00 00       	call   c0101820 <pic_enable>
}
c01016d9:	90                   	nop
c01016da:	c9                   	leave  
c01016db:	c3                   	ret    

c01016dc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016dc:	f3 0f 1e fb          	endbr32 
c01016e0:	55                   	push   %ebp
c01016e1:	89 e5                	mov    %esp,%ebp
c01016e3:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016e6:	e8 2e f8 ff ff       	call   c0100f19 <cga_init>
    serial_init();
c01016eb:	e8 13 f9 ff ff       	call   c0101003 <serial_init>
    kbd_init();
c01016f0:	e8 c9 ff ff ff       	call   c01016be <kbd_init>
    if (!serial_exists) {
c01016f5:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01016fa:	85 c0                	test   %eax,%eax
c01016fc:	75 0c                	jne    c010170a <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01016fe:	c7 04 24 71 65 10 c0 	movl   $0xc0106571,(%esp)
c0101705:	e8 cf eb ff ff       	call   c01002d9 <cprintf>
    }
}
c010170a:	90                   	nop
c010170b:	c9                   	leave  
c010170c:	c3                   	ret    

c010170d <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010170d:	f3 0f 1e fb          	endbr32 
c0101711:	55                   	push   %ebp
c0101712:	89 e5                	mov    %esp,%ebp
c0101714:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101717:	e8 72 f7 ff ff       	call   c0100e8e <__intr_save>
c010171c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010171f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101722:	89 04 24             	mov    %eax,(%esp)
c0101725:	e8 48 fa ff ff       	call   c0101172 <lpt_putc>
        cga_putc(c);
c010172a:	8b 45 08             	mov    0x8(%ebp),%eax
c010172d:	89 04 24             	mov    %eax,(%esp)
c0101730:	e8 81 fa ff ff       	call   c01011b6 <cga_putc>
        serial_putc(c);
c0101735:	8b 45 08             	mov    0x8(%ebp),%eax
c0101738:	89 04 24             	mov    %eax,(%esp)
c010173b:	e8 ca fc ff ff       	call   c010140a <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101740:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101743:	89 04 24             	mov    %eax,(%esp)
c0101746:	e8 6d f7 ff ff       	call   c0100eb8 <__intr_restore>
}
c010174b:	90                   	nop
c010174c:	c9                   	leave  
c010174d:	c3                   	ret    

c010174e <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010174e:	f3 0f 1e fb          	endbr32 
c0101752:	55                   	push   %ebp
c0101753:	89 e5                	mov    %esp,%ebp
c0101755:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101758:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010175f:	e8 2a f7 ff ff       	call   c0100e8e <__intr_save>
c0101764:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101767:	e8 8e fd ff ff       	call   c01014fa <serial_intr>
        kbd_intr();
c010176c:	e8 34 ff ff ff       	call   c01016a5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101771:	8b 15 60 c6 11 c0    	mov    0xc011c660,%edx
c0101777:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c010177c:	39 c2                	cmp    %eax,%edx
c010177e:	74 31                	je     c01017b1 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
c0101780:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c0101785:	8d 50 01             	lea    0x1(%eax),%edx
c0101788:	89 15 60 c6 11 c0    	mov    %edx,0xc011c660
c010178e:	0f b6 80 60 c4 11 c0 	movzbl -0x3fee3ba0(%eax),%eax
c0101795:	0f b6 c0             	movzbl %al,%eax
c0101798:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010179b:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c01017a0:	3d 00 02 00 00       	cmp    $0x200,%eax
c01017a5:	75 0a                	jne    c01017b1 <cons_getc+0x63>
                cons.rpos = 0;
c01017a7:	c7 05 60 c6 11 c0 00 	movl   $0x0,0xc011c660
c01017ae:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01017b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01017b4:	89 04 24             	mov    %eax,(%esp)
c01017b7:	e8 fc f6 ff ff       	call   c0100eb8 <__intr_restore>
    return c;
c01017bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01017bf:	c9                   	leave  
c01017c0:	c3                   	ret    

c01017c1 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01017c1:	f3 0f 1e fb          	endbr32 
c01017c5:	55                   	push   %ebp
c01017c6:	89 e5                	mov    %esp,%ebp
c01017c8:	83 ec 14             	sub    $0x14,%esp
c01017cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01017ce:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01017d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017d5:	66 a3 50 95 11 c0    	mov    %ax,0xc0119550
    if (did_init) {
c01017db:	a1 6c c6 11 c0       	mov    0xc011c66c,%eax
c01017e0:	85 c0                	test   %eax,%eax
c01017e2:	74 39                	je     c010181d <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
c01017e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017e7:	0f b6 c0             	movzbl %al,%eax
c01017ea:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01017f0:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017f3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017f7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017fb:	ee                   	out    %al,(%dx)
}
c01017fc:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c01017fd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101801:	c1 e8 08             	shr    $0x8,%eax
c0101804:	0f b7 c0             	movzwl %ax,%eax
c0101807:	0f b6 c0             	movzbl %al,%eax
c010180a:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101810:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101813:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101817:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010181b:	ee                   	out    %al,(%dx)
}
c010181c:	90                   	nop
    }
}
c010181d:	90                   	nop
c010181e:	c9                   	leave  
c010181f:	c3                   	ret    

c0101820 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101820:	f3 0f 1e fb          	endbr32 
c0101824:	55                   	push   %ebp
c0101825:	89 e5                	mov    %esp,%ebp
c0101827:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010182a:	8b 45 08             	mov    0x8(%ebp),%eax
c010182d:	ba 01 00 00 00       	mov    $0x1,%edx
c0101832:	88 c1                	mov    %al,%cl
c0101834:	d3 e2                	shl    %cl,%edx
c0101836:	89 d0                	mov    %edx,%eax
c0101838:	98                   	cwtl   
c0101839:	f7 d0                	not    %eax
c010183b:	0f bf d0             	movswl %ax,%edx
c010183e:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101845:	98                   	cwtl   
c0101846:	21 d0                	and    %edx,%eax
c0101848:	98                   	cwtl   
c0101849:	0f b7 c0             	movzwl %ax,%eax
c010184c:	89 04 24             	mov    %eax,(%esp)
c010184f:	e8 6d ff ff ff       	call   c01017c1 <pic_setmask>
}
c0101854:	90                   	nop
c0101855:	c9                   	leave  
c0101856:	c3                   	ret    

c0101857 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101857:	f3 0f 1e fb          	endbr32 
c010185b:	55                   	push   %ebp
c010185c:	89 e5                	mov    %esp,%ebp
c010185e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101861:	c7 05 6c c6 11 c0 01 	movl   $0x1,0xc011c66c
c0101868:	00 00 00 
c010186b:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101871:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101875:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101879:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010187d:	ee                   	out    %al,(%dx)
}
c010187e:	90                   	nop
c010187f:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101885:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101889:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010188d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101891:	ee                   	out    %al,(%dx)
}
c0101892:	90                   	nop
c0101893:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101899:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010189d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01018a1:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01018a5:	ee                   	out    %al,(%dx)
}
c01018a6:	90                   	nop
c01018a7:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c01018ad:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018b1:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01018b5:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01018b9:	ee                   	out    %al,(%dx)
}
c01018ba:	90                   	nop
c01018bb:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c01018c1:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018c5:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01018c9:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01018cd:	ee                   	out    %al,(%dx)
}
c01018ce:	90                   	nop
c01018cf:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01018d5:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01018dd:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01018e1:	ee                   	out    %al,(%dx)
}
c01018e2:	90                   	nop
c01018e3:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01018e9:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ed:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01018f1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01018f5:	ee                   	out    %al,(%dx)
}
c01018f6:	90                   	nop
c01018f7:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01018fd:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101901:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101905:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101909:	ee                   	out    %al,(%dx)
}
c010190a:	90                   	nop
c010190b:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101911:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101915:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101919:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010191d:	ee                   	out    %al,(%dx)
}
c010191e:	90                   	nop
c010191f:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0101925:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101929:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010192d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101931:	ee                   	out    %al,(%dx)
}
c0101932:	90                   	nop
c0101933:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101939:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010193d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101941:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101945:	ee                   	out    %al,(%dx)
}
c0101946:	90                   	nop
c0101947:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010194d:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101951:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101955:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101959:	ee                   	out    %al,(%dx)
}
c010195a:	90                   	nop
c010195b:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101961:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101965:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101969:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010196d:	ee                   	out    %al,(%dx)
}
c010196e:	90                   	nop
c010196f:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101975:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101979:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010197d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101981:	ee                   	out    %al,(%dx)
}
c0101982:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101983:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c010198a:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010198f:	74 0f                	je     c01019a0 <pic_init+0x149>
        pic_setmask(irq_mask);
c0101991:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101998:	89 04 24             	mov    %eax,(%esp)
c010199b:	e8 21 fe ff ff       	call   c01017c1 <pic_setmask>
    }
}
c01019a0:	90                   	nop
c01019a1:	c9                   	leave  
c01019a2:	c3                   	ret    

c01019a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01019a3:	f3 0f 1e fb          	endbr32 
c01019a7:	55                   	push   %ebp
c01019a8:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c01019aa:	fb                   	sti    
}
c01019ab:	90                   	nop
    sti();
}
c01019ac:	90                   	nop
c01019ad:	5d                   	pop    %ebp
c01019ae:	c3                   	ret    

c01019af <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01019af:	f3 0f 1e fb          	endbr32 
c01019b3:	55                   	push   %ebp
c01019b4:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c01019b6:	fa                   	cli    
}
c01019b7:	90                   	nop
    cli();
}
c01019b8:	90                   	nop
c01019b9:	5d                   	pop    %ebp
c01019ba:	c3                   	ret    

c01019bb <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01019bb:	f3 0f 1e fb          	endbr32 
c01019bf:	55                   	push   %ebp
c01019c0:	89 e5                	mov    %esp,%ebp
c01019c2:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01019c5:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01019cc:	00 
c01019cd:	c7 04 24 a0 65 10 c0 	movl   $0xc01065a0,(%esp)
c01019d4:	e8 00 e9 ff ff       	call   c01002d9 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01019d9:	c7 04 24 aa 65 10 c0 	movl   $0xc01065aa,(%esp)
c01019e0:	e8 f4 e8 ff ff       	call   c01002d9 <cprintf>
    panic("EOT: kernel seems ok.");
c01019e5:	c7 44 24 08 b8 65 10 	movl   $0xc01065b8,0x8(%esp)
c01019ec:	c0 
c01019ed:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01019f4:	00 
c01019f5:	c7 04 24 ce 65 10 c0 	movl   $0xc01065ce,(%esp)
c01019fc:	e8 44 ea ff ff       	call   c0100445 <__panic>

c0101a01 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101a01:	f3 0f 1e fb          	endbr32 
c0101a05:	55                   	push   %ebp
c0101a06:	89 e5                	mov    %esp,%ebp
c0101a08:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    for (int i = 0; i < 256; ++i)
c0101a0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101a12:	e9 c4 00 00 00       	jmp    c0101adb <idt_init+0xda>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a1a:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101a21:	0f b7 d0             	movzwl %ax,%edx
c0101a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a27:	66 89 14 c5 80 c6 11 	mov    %dx,-0x3fee3980(,%eax,8)
c0101a2e:	c0 
c0101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a32:	66 c7 04 c5 82 c6 11 	movw   $0x8,-0x3fee397e(,%eax,8)
c0101a39:	c0 08 00 
c0101a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a3f:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c0101a46:	c0 
c0101a47:	80 e2 e0             	and    $0xe0,%dl
c0101a4a:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a54:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c0101a5b:	c0 
c0101a5c:	80 e2 1f             	and    $0x1f,%dl
c0101a5f:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101a66:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a69:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a70:	c0 
c0101a71:	80 e2 f0             	and    $0xf0,%dl
c0101a74:	80 ca 0e             	or     $0xe,%dl
c0101a77:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a81:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a88:	c0 
c0101a89:	80 e2 ef             	and    $0xef,%dl
c0101a8c:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a93:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a96:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a9d:	c0 
c0101a9e:	80 e2 9f             	and    $0x9f,%dl
c0101aa1:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aab:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101ab2:	c0 
c0101ab3:	80 ca 80             	or     $0x80,%dl
c0101ab6:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ac0:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101ac7:	c1 e8 10             	shr    $0x10,%eax
c0101aca:	0f b7 d0             	movzwl %ax,%edx
c0101acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ad0:	66 89 14 c5 86 c6 11 	mov    %dx,-0x3fee397a(,%eax,8)
c0101ad7:	c0 
    for (int i = 0; i < 256; ++i)
c0101ad8:	ff 45 fc             	incl   -0x4(%ebp)
c0101adb:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101ae2:	0f 8e 2f ff ff ff    	jle    c0101a17 <idt_init+0x16>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101ae8:	a1 c4 97 11 c0       	mov    0xc01197c4,%eax
c0101aed:	0f b7 c0             	movzwl %ax,%eax
c0101af0:	66 a3 48 ca 11 c0    	mov    %ax,0xc011ca48
c0101af6:	66 c7 05 4a ca 11 c0 	movw   $0x8,0xc011ca4a
c0101afd:	08 00 
c0101aff:	0f b6 05 4c ca 11 c0 	movzbl 0xc011ca4c,%eax
c0101b06:	24 e0                	and    $0xe0,%al
c0101b08:	a2 4c ca 11 c0       	mov    %al,0xc011ca4c
c0101b0d:	0f b6 05 4c ca 11 c0 	movzbl 0xc011ca4c,%eax
c0101b14:	24 1f                	and    $0x1f,%al
c0101b16:	a2 4c ca 11 c0       	mov    %al,0xc011ca4c
c0101b1b:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101b22:	24 f0                	and    $0xf0,%al
c0101b24:	0c 0e                	or     $0xe,%al
c0101b26:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101b2b:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101b32:	24 ef                	and    $0xef,%al
c0101b34:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101b39:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101b40:	0c 60                	or     $0x60,%al
c0101b42:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101b47:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101b4e:	0c 80                	or     $0x80,%al
c0101b50:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101b55:	a1 c4 97 11 c0       	mov    0xc01197c4,%eax
c0101b5a:	c1 e8 10             	shr    $0x10,%eax
c0101b5d:	0f b7 c0             	movzwl %ax,%eax
c0101b60:	66 a3 4e ca 11 c0    	mov    %ax,0xc011ca4e
c0101b66:	c7 45 f8 60 95 11 c0 	movl   $0xc0119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101b6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b70:	0f 01 18             	lidtl  (%eax)
}
c0101b73:	90                   	nop
    lidt(&idt_pd);
}
c0101b74:	90                   	nop
c0101b75:	c9                   	leave  
c0101b76:	c3                   	ret    

c0101b77 <trapname>:

static const char *
trapname(int trapno) {
c0101b77:	f3 0f 1e fb          	endbr32 
c0101b7b:	55                   	push   %ebp
c0101b7c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b81:	83 f8 13             	cmp    $0x13,%eax
c0101b84:	77 0c                	ja     c0101b92 <trapname+0x1b>
        return excnames[trapno];
c0101b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b89:	8b 04 85 20 69 10 c0 	mov    -0x3fef96e0(,%eax,4),%eax
c0101b90:	eb 18                	jmp    c0101baa <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101b92:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101b96:	7e 0d                	jle    c0101ba5 <trapname+0x2e>
c0101b98:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101b9c:	7f 07                	jg     c0101ba5 <trapname+0x2e>
        return "Hardware Interrupt";
c0101b9e:	b8 df 65 10 c0       	mov    $0xc01065df,%eax
c0101ba3:	eb 05                	jmp    c0101baa <trapname+0x33>
    }
    return "(unknown trap)";
c0101ba5:	b8 f2 65 10 c0       	mov    $0xc01065f2,%eax
}
c0101baa:	5d                   	pop    %ebp
c0101bab:	c3                   	ret    

c0101bac <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101bac:	f3 0f 1e fb          	endbr32 
c0101bb0:	55                   	push   %ebp
c0101bb1:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101bb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bba:	83 f8 08             	cmp    $0x8,%eax
c0101bbd:	0f 94 c0             	sete   %al
c0101bc0:	0f b6 c0             	movzbl %al,%eax
}
c0101bc3:	5d                   	pop    %ebp
c0101bc4:	c3                   	ret    

c0101bc5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101bc5:	f3 0f 1e fb          	endbr32 
c0101bc9:	55                   	push   %ebp
c0101bca:	89 e5                	mov    %esp,%ebp
c0101bcc:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101bcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd6:	c7 04 24 33 66 10 c0 	movl   $0xc0106633,(%esp)
c0101bdd:	e8 f7 e6 ff ff       	call   c01002d9 <cprintf>
    print_regs(&tf->tf_regs);
c0101be2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be5:	89 04 24             	mov    %eax,(%esp)
c0101be8:	e8 8d 01 00 00       	call   c0101d7a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101bed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf0:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf8:	c7 04 24 44 66 10 c0 	movl   $0xc0106644,(%esp)
c0101bff:	e8 d5 e6 ff ff       	call   c01002d9 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c07:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0f:	c7 04 24 57 66 10 c0 	movl   $0xc0106657,(%esp)
c0101c16:	e8 be e6 ff ff       	call   c01002d9 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c26:	c7 04 24 6a 66 10 c0 	movl   $0xc010666a,(%esp)
c0101c2d:	e8 a7 e6 ff ff       	call   c01002d9 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c35:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101c39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3d:	c7 04 24 7d 66 10 c0 	movl   $0xc010667d,(%esp)
c0101c44:	e8 90 e6 ff ff       	call   c01002d9 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4c:	8b 40 30             	mov    0x30(%eax),%eax
c0101c4f:	89 04 24             	mov    %eax,(%esp)
c0101c52:	e8 20 ff ff ff       	call   c0101b77 <trapname>
c0101c57:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c5a:	8b 52 30             	mov    0x30(%edx),%edx
c0101c5d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101c61:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101c65:	c7 04 24 90 66 10 c0 	movl   $0xc0106690,(%esp)
c0101c6c:	e8 68 e6 ff ff       	call   c01002d9 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101c71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c74:	8b 40 34             	mov    0x34(%eax),%eax
c0101c77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c7b:	c7 04 24 a2 66 10 c0 	movl   $0xc01066a2,(%esp)
c0101c82:	e8 52 e6 ff ff       	call   c01002d9 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101c87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8a:	8b 40 38             	mov    0x38(%eax),%eax
c0101c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c91:	c7 04 24 b1 66 10 c0 	movl   $0xc01066b1,(%esp)
c0101c98:	e8 3c e6 ff ff       	call   c01002d9 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca8:	c7 04 24 c0 66 10 c0 	movl   $0xc01066c0,(%esp)
c0101caf:	e8 25 e6 ff ff       	call   c01002d9 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101cb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb7:	8b 40 40             	mov    0x40(%eax),%eax
c0101cba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbe:	c7 04 24 d3 66 10 c0 	movl   $0xc01066d3,(%esp)
c0101cc5:	e8 0f e6 ff ff       	call   c01002d9 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101cd1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101cd8:	eb 3d                	jmp    c0101d17 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdd:	8b 50 40             	mov    0x40(%eax),%edx
c0101ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ce3:	21 d0                	and    %edx,%eax
c0101ce5:	85 c0                	test   %eax,%eax
c0101ce7:	74 28                	je     c0101d11 <print_trapframe+0x14c>
c0101ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cec:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101cf3:	85 c0                	test   %eax,%eax
c0101cf5:	74 1a                	je     c0101d11 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
c0101cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cfa:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101d01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d05:	c7 04 24 e2 66 10 c0 	movl   $0xc01066e2,(%esp)
c0101d0c:	e8 c8 e5 ff ff       	call   c01002d9 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101d11:	ff 45 f4             	incl   -0xc(%ebp)
c0101d14:	d1 65 f0             	shll   -0x10(%ebp)
c0101d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d1a:	83 f8 17             	cmp    $0x17,%eax
c0101d1d:	76 bb                	jbe    c0101cda <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101d1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d22:	8b 40 40             	mov    0x40(%eax),%eax
c0101d25:	c1 e8 0c             	shr    $0xc,%eax
c0101d28:	83 e0 03             	and    $0x3,%eax
c0101d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d2f:	c7 04 24 e6 66 10 c0 	movl   $0xc01066e6,(%esp)
c0101d36:	e8 9e e5 ff ff       	call   c01002d9 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d3e:	89 04 24             	mov    %eax,(%esp)
c0101d41:	e8 66 fe ff ff       	call   c0101bac <trap_in_kernel>
c0101d46:	85 c0                	test   %eax,%eax
c0101d48:	75 2d                	jne    c0101d77 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d4d:	8b 40 44             	mov    0x44(%eax),%eax
c0101d50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d54:	c7 04 24 ef 66 10 c0 	movl   $0xc01066ef,(%esp)
c0101d5b:	e8 79 e5 ff ff       	call   c01002d9 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101d60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d63:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101d67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d6b:	c7 04 24 fe 66 10 c0 	movl   $0xc01066fe,(%esp)
c0101d72:	e8 62 e5 ff ff       	call   c01002d9 <cprintf>
    }
}
c0101d77:	90                   	nop
c0101d78:	c9                   	leave  
c0101d79:	c3                   	ret    

c0101d7a <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101d7a:	f3 0f 1e fb          	endbr32 
c0101d7e:	55                   	push   %ebp
c0101d7f:	89 e5                	mov    %esp,%ebp
c0101d81:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101d84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d87:	8b 00                	mov    (%eax),%eax
c0101d89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d8d:	c7 04 24 11 67 10 c0 	movl   $0xc0106711,(%esp)
c0101d94:	e8 40 e5 ff ff       	call   c01002d9 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101d99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d9c:	8b 40 04             	mov    0x4(%eax),%eax
c0101d9f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101da3:	c7 04 24 20 67 10 c0 	movl   $0xc0106720,(%esp)
c0101daa:	e8 2a e5 ff ff       	call   c01002d9 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101daf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101db2:	8b 40 08             	mov    0x8(%eax),%eax
c0101db5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101db9:	c7 04 24 2f 67 10 c0 	movl   $0xc010672f,(%esp)
c0101dc0:	e8 14 e5 ff ff       	call   c01002d9 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101dc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dc8:	8b 40 0c             	mov    0xc(%eax),%eax
c0101dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dcf:	c7 04 24 3e 67 10 c0 	movl   $0xc010673e,(%esp)
c0101dd6:	e8 fe e4 ff ff       	call   c01002d9 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dde:	8b 40 10             	mov    0x10(%eax),%eax
c0101de1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101de5:	c7 04 24 4d 67 10 c0 	movl   $0xc010674d,(%esp)
c0101dec:	e8 e8 e4 ff ff       	call   c01002d9 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101df1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df4:	8b 40 14             	mov    0x14(%eax),%eax
c0101df7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dfb:	c7 04 24 5c 67 10 c0 	movl   $0xc010675c,(%esp)
c0101e02:	e8 d2 e4 ff ff       	call   c01002d9 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101e07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e0a:	8b 40 18             	mov    0x18(%eax),%eax
c0101e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e11:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0101e18:	e8 bc e4 ff ff       	call   c01002d9 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e20:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101e23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e27:	c7 04 24 7a 67 10 c0 	movl   $0xc010677a,(%esp)
c0101e2e:	e8 a6 e4 ff ff       	call   c01002d9 <cprintf>
}
c0101e33:	90                   	nop
c0101e34:	c9                   	leave  
c0101e35:	c3                   	ret    

c0101e36 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101e36:	f3 0f 1e fb          	endbr32 
c0101e3a:	55                   	push   %ebp
c0101e3b:	89 e5                	mov    %esp,%ebp
c0101e3d:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e43:	8b 40 30             	mov    0x30(%eax),%eax
c0101e46:	83 f8 79             	cmp    $0x79,%eax
c0101e49:	0f 84 02 01 00 00    	je     c0101f51 <trap_dispatch+0x11b>
c0101e4f:	83 f8 79             	cmp    $0x79,%eax
c0101e52:	0f 87 32 01 00 00    	ja     c0101f8a <trap_dispatch+0x154>
c0101e58:	83 f8 78             	cmp    $0x78,%eax
c0101e5b:	0f 84 b7 00 00 00    	je     c0101f18 <trap_dispatch+0xe2>
c0101e61:	83 f8 78             	cmp    $0x78,%eax
c0101e64:	0f 87 20 01 00 00    	ja     c0101f8a <trap_dispatch+0x154>
c0101e6a:	83 f8 2f             	cmp    $0x2f,%eax
c0101e6d:	0f 87 17 01 00 00    	ja     c0101f8a <trap_dispatch+0x154>
c0101e73:	83 f8 2e             	cmp    $0x2e,%eax
c0101e76:	0f 83 43 01 00 00    	jae    c0101fbf <trap_dispatch+0x189>
c0101e7c:	83 f8 24             	cmp    $0x24,%eax
c0101e7f:	74 45                	je     c0101ec6 <trap_dispatch+0x90>
c0101e81:	83 f8 24             	cmp    $0x24,%eax
c0101e84:	0f 87 00 01 00 00    	ja     c0101f8a <trap_dispatch+0x154>
c0101e8a:	83 f8 20             	cmp    $0x20,%eax
c0101e8d:	74 0a                	je     c0101e99 <trap_dispatch+0x63>
c0101e8f:	83 f8 21             	cmp    $0x21,%eax
c0101e92:	74 5b                	je     c0101eef <trap_dispatch+0xb9>
c0101e94:	e9 f1 00 00 00       	jmp    c0101f8a <trap_dispatch+0x154>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
 	ticks++;
c0101e99:	a1 0c cf 11 c0       	mov    0xc011cf0c,%eax
c0101e9e:	40                   	inc    %eax
c0101e9f:	a3 0c cf 11 c0       	mov    %eax,0xc011cf0c
        if (ticks == TICK_NUM)
c0101ea4:	a1 0c cf 11 c0       	mov    0xc011cf0c,%eax
c0101ea9:	83 f8 64             	cmp    $0x64,%eax
c0101eac:	0f 85 10 01 00 00    	jne    c0101fc2 <trap_dispatch+0x18c>
        {
            ticks = 0;
c0101eb2:	c7 05 0c cf 11 c0 00 	movl   $0x0,0xc011cf0c
c0101eb9:	00 00 00 
            print_ticks();
c0101ebc:	e8 fa fa ff ff       	call   c01019bb <print_ticks>
        }
        break;
c0101ec1:	e9 fc 00 00 00       	jmp    c0101fc2 <trap_dispatch+0x18c>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101ec6:	e8 83 f8 ff ff       	call   c010174e <cons_getc>
c0101ecb:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ece:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ed2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ed6:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101eda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ede:	c7 04 24 89 67 10 c0 	movl   $0xc0106789,(%esp)
c0101ee5:	e8 ef e3 ff ff       	call   c01002d9 <cprintf>
        break;
c0101eea:	e9 d4 00 00 00       	jmp    c0101fc3 <trap_dispatch+0x18d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101eef:	e8 5a f8 ff ff       	call   c010174e <cons_getc>
c0101ef4:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101ef7:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101efb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101eff:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101f03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101f07:	c7 04 24 9b 67 10 c0 	movl   $0xc010679b,(%esp)
c0101f0e:	e8 c6 e3 ff ff       	call   c01002d9 <cprintf>
        break;
c0101f13:	e9 ab 00 00 00       	jmp    c0101fc3 <trap_dispatch+0x18d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        tf->tf_cs = USER_CS;
c0101f18:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f1b:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
        tf->tf_ds = USER_DS;
c0101f21:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f24:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
        tf->tf_es = USER_DS;
c0101f2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f2d:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
        tf->tf_ss = USER_DS;
c0101f33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f36:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
        tf->tf_eflags |= FL_IOPL_MASK;
c0101f3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3f:	8b 40 40             	mov    0x40(%eax),%eax
c0101f42:	0d 00 30 00 00       	or     $0x3000,%eax
c0101f47:	89 c2                	mov    %eax,%edx
c0101f49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f4c:	89 50 40             	mov    %edx,0x40(%eax)
        break;
c0101f4f:	eb 72                	jmp    c0101fc3 <trap_dispatch+0x18d>
    case T_SWITCH_TOK:
        tf->tf_cs = KERNEL_CS;
c0101f51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f54:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
c0101f5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f5d:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
c0101f63:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f66:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_ss = KERNEL_DS;
c0101f6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f6f:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
c0101f75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f78:	8b 40 40             	mov    0x40(%eax),%eax
c0101f7b:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101f80:	89 c2                	mov    %eax,%edx
c0101f82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f85:	89 50 40             	mov    %edx,0x40(%eax)
        // panic("T_SWITCH_** ??\n");
        break;
c0101f88:	eb 39                	jmp    c0101fc3 <trap_dispatch+0x18d>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101f8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f8d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f91:	83 e0 03             	and    $0x3,%eax
c0101f94:	85 c0                	test   %eax,%eax
c0101f96:	75 2b                	jne    c0101fc3 <trap_dispatch+0x18d>
            print_trapframe(tf);
c0101f98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9b:	89 04 24             	mov    %eax,(%esp)
c0101f9e:	e8 22 fc ff ff       	call   c0101bc5 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101fa3:	c7 44 24 08 aa 67 10 	movl   $0xc01067aa,0x8(%esp)
c0101faa:	c0 
c0101fab:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0101fb2:	00 
c0101fb3:	c7 04 24 ce 65 10 c0 	movl   $0xc01065ce,(%esp)
c0101fba:	e8 86 e4 ff ff       	call   c0100445 <__panic>
        break;
c0101fbf:	90                   	nop
c0101fc0:	eb 01                	jmp    c0101fc3 <trap_dispatch+0x18d>
        break;
c0101fc2:	90                   	nop
        }
    }
}
c0101fc3:	90                   	nop
c0101fc4:	c9                   	leave  
c0101fc5:	c3                   	ret    

c0101fc6 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101fc6:	f3 0f 1e fb          	endbr32 
c0101fca:	55                   	push   %ebp
c0101fcb:	89 e5                	mov    %esp,%ebp
c0101fcd:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101fd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fd3:	89 04 24             	mov    %eax,(%esp)
c0101fd6:	e8 5b fe ff ff       	call   c0101e36 <trap_dispatch>
}
c0101fdb:	90                   	nop
c0101fdc:	c9                   	leave  
c0101fdd:	c3                   	ret    

c0101fde <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101fde:	6a 00                	push   $0x0
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  jmp __alltraps
c0101fe2:	e9 69 0a 00 00       	jmp    c0102a50 <__alltraps>

c0101fe7 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101fe7:	6a 00                	push   $0x0
  pushl $1
c0101fe9:	6a 01                	push   $0x1
  jmp __alltraps
c0101feb:	e9 60 0a 00 00       	jmp    c0102a50 <__alltraps>

c0101ff0 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101ff0:	6a 00                	push   $0x0
  pushl $2
c0101ff2:	6a 02                	push   $0x2
  jmp __alltraps
c0101ff4:	e9 57 0a 00 00       	jmp    c0102a50 <__alltraps>

c0101ff9 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101ff9:	6a 00                	push   $0x0
  pushl $3
c0101ffb:	6a 03                	push   $0x3
  jmp __alltraps
c0101ffd:	e9 4e 0a 00 00       	jmp    c0102a50 <__alltraps>

c0102002 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102002:	6a 00                	push   $0x0
  pushl $4
c0102004:	6a 04                	push   $0x4
  jmp __alltraps
c0102006:	e9 45 0a 00 00       	jmp    c0102a50 <__alltraps>

c010200b <vector5>:
.globl vector5
vector5:
  pushl $0
c010200b:	6a 00                	push   $0x0
  pushl $5
c010200d:	6a 05                	push   $0x5
  jmp __alltraps
c010200f:	e9 3c 0a 00 00       	jmp    c0102a50 <__alltraps>

c0102014 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102014:	6a 00                	push   $0x0
  pushl $6
c0102016:	6a 06                	push   $0x6
  jmp __alltraps
c0102018:	e9 33 0a 00 00       	jmp    c0102a50 <__alltraps>

c010201d <vector7>:
.globl vector7
vector7:
  pushl $0
c010201d:	6a 00                	push   $0x0
  pushl $7
c010201f:	6a 07                	push   $0x7
  jmp __alltraps
c0102021:	e9 2a 0a 00 00       	jmp    c0102a50 <__alltraps>

c0102026 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102026:	6a 08                	push   $0x8
  jmp __alltraps
c0102028:	e9 23 0a 00 00       	jmp    c0102a50 <__alltraps>

c010202d <vector9>:
.globl vector9
vector9:
  pushl $0
c010202d:	6a 00                	push   $0x0
  pushl $9
c010202f:	6a 09                	push   $0x9
  jmp __alltraps
c0102031:	e9 1a 0a 00 00       	jmp    c0102a50 <__alltraps>

c0102036 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102036:	6a 0a                	push   $0xa
  jmp __alltraps
c0102038:	e9 13 0a 00 00       	jmp    c0102a50 <__alltraps>

c010203d <vector11>:
.globl vector11
vector11:
  pushl $11
c010203d:	6a 0b                	push   $0xb
  jmp __alltraps
c010203f:	e9 0c 0a 00 00       	jmp    c0102a50 <__alltraps>

c0102044 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102044:	6a 0c                	push   $0xc
  jmp __alltraps
c0102046:	e9 05 0a 00 00       	jmp    c0102a50 <__alltraps>

c010204b <vector13>:
.globl vector13
vector13:
  pushl $13
c010204b:	6a 0d                	push   $0xd
  jmp __alltraps
c010204d:	e9 fe 09 00 00       	jmp    c0102a50 <__alltraps>

c0102052 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102052:	6a 0e                	push   $0xe
  jmp __alltraps
c0102054:	e9 f7 09 00 00       	jmp    c0102a50 <__alltraps>

c0102059 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102059:	6a 00                	push   $0x0
  pushl $15
c010205b:	6a 0f                	push   $0xf
  jmp __alltraps
c010205d:	e9 ee 09 00 00       	jmp    c0102a50 <__alltraps>

c0102062 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102062:	6a 00                	push   $0x0
  pushl $16
c0102064:	6a 10                	push   $0x10
  jmp __alltraps
c0102066:	e9 e5 09 00 00       	jmp    c0102a50 <__alltraps>

c010206b <vector17>:
.globl vector17
vector17:
  pushl $17
c010206b:	6a 11                	push   $0x11
  jmp __alltraps
c010206d:	e9 de 09 00 00       	jmp    c0102a50 <__alltraps>

c0102072 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $18
c0102074:	6a 12                	push   $0x12
  jmp __alltraps
c0102076:	e9 d5 09 00 00       	jmp    c0102a50 <__alltraps>

c010207b <vector19>:
.globl vector19
vector19:
  pushl $0
c010207b:	6a 00                	push   $0x0
  pushl $19
c010207d:	6a 13                	push   $0x13
  jmp __alltraps
c010207f:	e9 cc 09 00 00       	jmp    c0102a50 <__alltraps>

c0102084 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102084:	6a 00                	push   $0x0
  pushl $20
c0102086:	6a 14                	push   $0x14
  jmp __alltraps
c0102088:	e9 c3 09 00 00       	jmp    c0102a50 <__alltraps>

c010208d <vector21>:
.globl vector21
vector21:
  pushl $0
c010208d:	6a 00                	push   $0x0
  pushl $21
c010208f:	6a 15                	push   $0x15
  jmp __alltraps
c0102091:	e9 ba 09 00 00       	jmp    c0102a50 <__alltraps>

c0102096 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102096:	6a 00                	push   $0x0
  pushl $22
c0102098:	6a 16                	push   $0x16
  jmp __alltraps
c010209a:	e9 b1 09 00 00       	jmp    c0102a50 <__alltraps>

c010209f <vector23>:
.globl vector23
vector23:
  pushl $0
c010209f:	6a 00                	push   $0x0
  pushl $23
c01020a1:	6a 17                	push   $0x17
  jmp __alltraps
c01020a3:	e9 a8 09 00 00       	jmp    c0102a50 <__alltraps>

c01020a8 <vector24>:
.globl vector24
vector24:
  pushl $0
c01020a8:	6a 00                	push   $0x0
  pushl $24
c01020aa:	6a 18                	push   $0x18
  jmp __alltraps
c01020ac:	e9 9f 09 00 00       	jmp    c0102a50 <__alltraps>

c01020b1 <vector25>:
.globl vector25
vector25:
  pushl $0
c01020b1:	6a 00                	push   $0x0
  pushl $25
c01020b3:	6a 19                	push   $0x19
  jmp __alltraps
c01020b5:	e9 96 09 00 00       	jmp    c0102a50 <__alltraps>

c01020ba <vector26>:
.globl vector26
vector26:
  pushl $0
c01020ba:	6a 00                	push   $0x0
  pushl $26
c01020bc:	6a 1a                	push   $0x1a
  jmp __alltraps
c01020be:	e9 8d 09 00 00       	jmp    c0102a50 <__alltraps>

c01020c3 <vector27>:
.globl vector27
vector27:
  pushl $0
c01020c3:	6a 00                	push   $0x0
  pushl $27
c01020c5:	6a 1b                	push   $0x1b
  jmp __alltraps
c01020c7:	e9 84 09 00 00       	jmp    c0102a50 <__alltraps>

c01020cc <vector28>:
.globl vector28
vector28:
  pushl $0
c01020cc:	6a 00                	push   $0x0
  pushl $28
c01020ce:	6a 1c                	push   $0x1c
  jmp __alltraps
c01020d0:	e9 7b 09 00 00       	jmp    c0102a50 <__alltraps>

c01020d5 <vector29>:
.globl vector29
vector29:
  pushl $0
c01020d5:	6a 00                	push   $0x0
  pushl $29
c01020d7:	6a 1d                	push   $0x1d
  jmp __alltraps
c01020d9:	e9 72 09 00 00       	jmp    c0102a50 <__alltraps>

c01020de <vector30>:
.globl vector30
vector30:
  pushl $0
c01020de:	6a 00                	push   $0x0
  pushl $30
c01020e0:	6a 1e                	push   $0x1e
  jmp __alltraps
c01020e2:	e9 69 09 00 00       	jmp    c0102a50 <__alltraps>

c01020e7 <vector31>:
.globl vector31
vector31:
  pushl $0
c01020e7:	6a 00                	push   $0x0
  pushl $31
c01020e9:	6a 1f                	push   $0x1f
  jmp __alltraps
c01020eb:	e9 60 09 00 00       	jmp    c0102a50 <__alltraps>

c01020f0 <vector32>:
.globl vector32
vector32:
  pushl $0
c01020f0:	6a 00                	push   $0x0
  pushl $32
c01020f2:	6a 20                	push   $0x20
  jmp __alltraps
c01020f4:	e9 57 09 00 00       	jmp    c0102a50 <__alltraps>

c01020f9 <vector33>:
.globl vector33
vector33:
  pushl $0
c01020f9:	6a 00                	push   $0x0
  pushl $33
c01020fb:	6a 21                	push   $0x21
  jmp __alltraps
c01020fd:	e9 4e 09 00 00       	jmp    c0102a50 <__alltraps>

c0102102 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102102:	6a 00                	push   $0x0
  pushl $34
c0102104:	6a 22                	push   $0x22
  jmp __alltraps
c0102106:	e9 45 09 00 00       	jmp    c0102a50 <__alltraps>

c010210b <vector35>:
.globl vector35
vector35:
  pushl $0
c010210b:	6a 00                	push   $0x0
  pushl $35
c010210d:	6a 23                	push   $0x23
  jmp __alltraps
c010210f:	e9 3c 09 00 00       	jmp    c0102a50 <__alltraps>

c0102114 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102114:	6a 00                	push   $0x0
  pushl $36
c0102116:	6a 24                	push   $0x24
  jmp __alltraps
c0102118:	e9 33 09 00 00       	jmp    c0102a50 <__alltraps>

c010211d <vector37>:
.globl vector37
vector37:
  pushl $0
c010211d:	6a 00                	push   $0x0
  pushl $37
c010211f:	6a 25                	push   $0x25
  jmp __alltraps
c0102121:	e9 2a 09 00 00       	jmp    c0102a50 <__alltraps>

c0102126 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102126:	6a 00                	push   $0x0
  pushl $38
c0102128:	6a 26                	push   $0x26
  jmp __alltraps
c010212a:	e9 21 09 00 00       	jmp    c0102a50 <__alltraps>

c010212f <vector39>:
.globl vector39
vector39:
  pushl $0
c010212f:	6a 00                	push   $0x0
  pushl $39
c0102131:	6a 27                	push   $0x27
  jmp __alltraps
c0102133:	e9 18 09 00 00       	jmp    c0102a50 <__alltraps>

c0102138 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102138:	6a 00                	push   $0x0
  pushl $40
c010213a:	6a 28                	push   $0x28
  jmp __alltraps
c010213c:	e9 0f 09 00 00       	jmp    c0102a50 <__alltraps>

c0102141 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102141:	6a 00                	push   $0x0
  pushl $41
c0102143:	6a 29                	push   $0x29
  jmp __alltraps
c0102145:	e9 06 09 00 00       	jmp    c0102a50 <__alltraps>

c010214a <vector42>:
.globl vector42
vector42:
  pushl $0
c010214a:	6a 00                	push   $0x0
  pushl $42
c010214c:	6a 2a                	push   $0x2a
  jmp __alltraps
c010214e:	e9 fd 08 00 00       	jmp    c0102a50 <__alltraps>

c0102153 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102153:	6a 00                	push   $0x0
  pushl $43
c0102155:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102157:	e9 f4 08 00 00       	jmp    c0102a50 <__alltraps>

c010215c <vector44>:
.globl vector44
vector44:
  pushl $0
c010215c:	6a 00                	push   $0x0
  pushl $44
c010215e:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102160:	e9 eb 08 00 00       	jmp    c0102a50 <__alltraps>

c0102165 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102165:	6a 00                	push   $0x0
  pushl $45
c0102167:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102169:	e9 e2 08 00 00       	jmp    c0102a50 <__alltraps>

c010216e <vector46>:
.globl vector46
vector46:
  pushl $0
c010216e:	6a 00                	push   $0x0
  pushl $46
c0102170:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102172:	e9 d9 08 00 00       	jmp    c0102a50 <__alltraps>

c0102177 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102177:	6a 00                	push   $0x0
  pushl $47
c0102179:	6a 2f                	push   $0x2f
  jmp __alltraps
c010217b:	e9 d0 08 00 00       	jmp    c0102a50 <__alltraps>

c0102180 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102180:	6a 00                	push   $0x0
  pushl $48
c0102182:	6a 30                	push   $0x30
  jmp __alltraps
c0102184:	e9 c7 08 00 00       	jmp    c0102a50 <__alltraps>

c0102189 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102189:	6a 00                	push   $0x0
  pushl $49
c010218b:	6a 31                	push   $0x31
  jmp __alltraps
c010218d:	e9 be 08 00 00       	jmp    c0102a50 <__alltraps>

c0102192 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102192:	6a 00                	push   $0x0
  pushl $50
c0102194:	6a 32                	push   $0x32
  jmp __alltraps
c0102196:	e9 b5 08 00 00       	jmp    c0102a50 <__alltraps>

c010219b <vector51>:
.globl vector51
vector51:
  pushl $0
c010219b:	6a 00                	push   $0x0
  pushl $51
c010219d:	6a 33                	push   $0x33
  jmp __alltraps
c010219f:	e9 ac 08 00 00       	jmp    c0102a50 <__alltraps>

c01021a4 <vector52>:
.globl vector52
vector52:
  pushl $0
c01021a4:	6a 00                	push   $0x0
  pushl $52
c01021a6:	6a 34                	push   $0x34
  jmp __alltraps
c01021a8:	e9 a3 08 00 00       	jmp    c0102a50 <__alltraps>

c01021ad <vector53>:
.globl vector53
vector53:
  pushl $0
c01021ad:	6a 00                	push   $0x0
  pushl $53
c01021af:	6a 35                	push   $0x35
  jmp __alltraps
c01021b1:	e9 9a 08 00 00       	jmp    c0102a50 <__alltraps>

c01021b6 <vector54>:
.globl vector54
vector54:
  pushl $0
c01021b6:	6a 00                	push   $0x0
  pushl $54
c01021b8:	6a 36                	push   $0x36
  jmp __alltraps
c01021ba:	e9 91 08 00 00       	jmp    c0102a50 <__alltraps>

c01021bf <vector55>:
.globl vector55
vector55:
  pushl $0
c01021bf:	6a 00                	push   $0x0
  pushl $55
c01021c1:	6a 37                	push   $0x37
  jmp __alltraps
c01021c3:	e9 88 08 00 00       	jmp    c0102a50 <__alltraps>

c01021c8 <vector56>:
.globl vector56
vector56:
  pushl $0
c01021c8:	6a 00                	push   $0x0
  pushl $56
c01021ca:	6a 38                	push   $0x38
  jmp __alltraps
c01021cc:	e9 7f 08 00 00       	jmp    c0102a50 <__alltraps>

c01021d1 <vector57>:
.globl vector57
vector57:
  pushl $0
c01021d1:	6a 00                	push   $0x0
  pushl $57
c01021d3:	6a 39                	push   $0x39
  jmp __alltraps
c01021d5:	e9 76 08 00 00       	jmp    c0102a50 <__alltraps>

c01021da <vector58>:
.globl vector58
vector58:
  pushl $0
c01021da:	6a 00                	push   $0x0
  pushl $58
c01021dc:	6a 3a                	push   $0x3a
  jmp __alltraps
c01021de:	e9 6d 08 00 00       	jmp    c0102a50 <__alltraps>

c01021e3 <vector59>:
.globl vector59
vector59:
  pushl $0
c01021e3:	6a 00                	push   $0x0
  pushl $59
c01021e5:	6a 3b                	push   $0x3b
  jmp __alltraps
c01021e7:	e9 64 08 00 00       	jmp    c0102a50 <__alltraps>

c01021ec <vector60>:
.globl vector60
vector60:
  pushl $0
c01021ec:	6a 00                	push   $0x0
  pushl $60
c01021ee:	6a 3c                	push   $0x3c
  jmp __alltraps
c01021f0:	e9 5b 08 00 00       	jmp    c0102a50 <__alltraps>

c01021f5 <vector61>:
.globl vector61
vector61:
  pushl $0
c01021f5:	6a 00                	push   $0x0
  pushl $61
c01021f7:	6a 3d                	push   $0x3d
  jmp __alltraps
c01021f9:	e9 52 08 00 00       	jmp    c0102a50 <__alltraps>

c01021fe <vector62>:
.globl vector62
vector62:
  pushl $0
c01021fe:	6a 00                	push   $0x0
  pushl $62
c0102200:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102202:	e9 49 08 00 00       	jmp    c0102a50 <__alltraps>

c0102207 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102207:	6a 00                	push   $0x0
  pushl $63
c0102209:	6a 3f                	push   $0x3f
  jmp __alltraps
c010220b:	e9 40 08 00 00       	jmp    c0102a50 <__alltraps>

c0102210 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102210:	6a 00                	push   $0x0
  pushl $64
c0102212:	6a 40                	push   $0x40
  jmp __alltraps
c0102214:	e9 37 08 00 00       	jmp    c0102a50 <__alltraps>

c0102219 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102219:	6a 00                	push   $0x0
  pushl $65
c010221b:	6a 41                	push   $0x41
  jmp __alltraps
c010221d:	e9 2e 08 00 00       	jmp    c0102a50 <__alltraps>

c0102222 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102222:	6a 00                	push   $0x0
  pushl $66
c0102224:	6a 42                	push   $0x42
  jmp __alltraps
c0102226:	e9 25 08 00 00       	jmp    c0102a50 <__alltraps>

c010222b <vector67>:
.globl vector67
vector67:
  pushl $0
c010222b:	6a 00                	push   $0x0
  pushl $67
c010222d:	6a 43                	push   $0x43
  jmp __alltraps
c010222f:	e9 1c 08 00 00       	jmp    c0102a50 <__alltraps>

c0102234 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102234:	6a 00                	push   $0x0
  pushl $68
c0102236:	6a 44                	push   $0x44
  jmp __alltraps
c0102238:	e9 13 08 00 00       	jmp    c0102a50 <__alltraps>

c010223d <vector69>:
.globl vector69
vector69:
  pushl $0
c010223d:	6a 00                	push   $0x0
  pushl $69
c010223f:	6a 45                	push   $0x45
  jmp __alltraps
c0102241:	e9 0a 08 00 00       	jmp    c0102a50 <__alltraps>

c0102246 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102246:	6a 00                	push   $0x0
  pushl $70
c0102248:	6a 46                	push   $0x46
  jmp __alltraps
c010224a:	e9 01 08 00 00       	jmp    c0102a50 <__alltraps>

c010224f <vector71>:
.globl vector71
vector71:
  pushl $0
c010224f:	6a 00                	push   $0x0
  pushl $71
c0102251:	6a 47                	push   $0x47
  jmp __alltraps
c0102253:	e9 f8 07 00 00       	jmp    c0102a50 <__alltraps>

c0102258 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102258:	6a 00                	push   $0x0
  pushl $72
c010225a:	6a 48                	push   $0x48
  jmp __alltraps
c010225c:	e9 ef 07 00 00       	jmp    c0102a50 <__alltraps>

c0102261 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102261:	6a 00                	push   $0x0
  pushl $73
c0102263:	6a 49                	push   $0x49
  jmp __alltraps
c0102265:	e9 e6 07 00 00       	jmp    c0102a50 <__alltraps>

c010226a <vector74>:
.globl vector74
vector74:
  pushl $0
c010226a:	6a 00                	push   $0x0
  pushl $74
c010226c:	6a 4a                	push   $0x4a
  jmp __alltraps
c010226e:	e9 dd 07 00 00       	jmp    c0102a50 <__alltraps>

c0102273 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102273:	6a 00                	push   $0x0
  pushl $75
c0102275:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102277:	e9 d4 07 00 00       	jmp    c0102a50 <__alltraps>

c010227c <vector76>:
.globl vector76
vector76:
  pushl $0
c010227c:	6a 00                	push   $0x0
  pushl $76
c010227e:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102280:	e9 cb 07 00 00       	jmp    c0102a50 <__alltraps>

c0102285 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102285:	6a 00                	push   $0x0
  pushl $77
c0102287:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102289:	e9 c2 07 00 00       	jmp    c0102a50 <__alltraps>

c010228e <vector78>:
.globl vector78
vector78:
  pushl $0
c010228e:	6a 00                	push   $0x0
  pushl $78
c0102290:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102292:	e9 b9 07 00 00       	jmp    c0102a50 <__alltraps>

c0102297 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102297:	6a 00                	push   $0x0
  pushl $79
c0102299:	6a 4f                	push   $0x4f
  jmp __alltraps
c010229b:	e9 b0 07 00 00       	jmp    c0102a50 <__alltraps>

c01022a0 <vector80>:
.globl vector80
vector80:
  pushl $0
c01022a0:	6a 00                	push   $0x0
  pushl $80
c01022a2:	6a 50                	push   $0x50
  jmp __alltraps
c01022a4:	e9 a7 07 00 00       	jmp    c0102a50 <__alltraps>

c01022a9 <vector81>:
.globl vector81
vector81:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $81
c01022ab:	6a 51                	push   $0x51
  jmp __alltraps
c01022ad:	e9 9e 07 00 00       	jmp    c0102a50 <__alltraps>

c01022b2 <vector82>:
.globl vector82
vector82:
  pushl $0
c01022b2:	6a 00                	push   $0x0
  pushl $82
c01022b4:	6a 52                	push   $0x52
  jmp __alltraps
c01022b6:	e9 95 07 00 00       	jmp    c0102a50 <__alltraps>

c01022bb <vector83>:
.globl vector83
vector83:
  pushl $0
c01022bb:	6a 00                	push   $0x0
  pushl $83
c01022bd:	6a 53                	push   $0x53
  jmp __alltraps
c01022bf:	e9 8c 07 00 00       	jmp    c0102a50 <__alltraps>

c01022c4 <vector84>:
.globl vector84
vector84:
  pushl $0
c01022c4:	6a 00                	push   $0x0
  pushl $84
c01022c6:	6a 54                	push   $0x54
  jmp __alltraps
c01022c8:	e9 83 07 00 00       	jmp    c0102a50 <__alltraps>

c01022cd <vector85>:
.globl vector85
vector85:
  pushl $0
c01022cd:	6a 00                	push   $0x0
  pushl $85
c01022cf:	6a 55                	push   $0x55
  jmp __alltraps
c01022d1:	e9 7a 07 00 00       	jmp    c0102a50 <__alltraps>

c01022d6 <vector86>:
.globl vector86
vector86:
  pushl $0
c01022d6:	6a 00                	push   $0x0
  pushl $86
c01022d8:	6a 56                	push   $0x56
  jmp __alltraps
c01022da:	e9 71 07 00 00       	jmp    c0102a50 <__alltraps>

c01022df <vector87>:
.globl vector87
vector87:
  pushl $0
c01022df:	6a 00                	push   $0x0
  pushl $87
c01022e1:	6a 57                	push   $0x57
  jmp __alltraps
c01022e3:	e9 68 07 00 00       	jmp    c0102a50 <__alltraps>

c01022e8 <vector88>:
.globl vector88
vector88:
  pushl $0
c01022e8:	6a 00                	push   $0x0
  pushl $88
c01022ea:	6a 58                	push   $0x58
  jmp __alltraps
c01022ec:	e9 5f 07 00 00       	jmp    c0102a50 <__alltraps>

c01022f1 <vector89>:
.globl vector89
vector89:
  pushl $0
c01022f1:	6a 00                	push   $0x0
  pushl $89
c01022f3:	6a 59                	push   $0x59
  jmp __alltraps
c01022f5:	e9 56 07 00 00       	jmp    c0102a50 <__alltraps>

c01022fa <vector90>:
.globl vector90
vector90:
  pushl $0
c01022fa:	6a 00                	push   $0x0
  pushl $90
c01022fc:	6a 5a                	push   $0x5a
  jmp __alltraps
c01022fe:	e9 4d 07 00 00       	jmp    c0102a50 <__alltraps>

c0102303 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102303:	6a 00                	push   $0x0
  pushl $91
c0102305:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102307:	e9 44 07 00 00       	jmp    c0102a50 <__alltraps>

c010230c <vector92>:
.globl vector92
vector92:
  pushl $0
c010230c:	6a 00                	push   $0x0
  pushl $92
c010230e:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102310:	e9 3b 07 00 00       	jmp    c0102a50 <__alltraps>

c0102315 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102315:	6a 00                	push   $0x0
  pushl $93
c0102317:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102319:	e9 32 07 00 00       	jmp    c0102a50 <__alltraps>

c010231e <vector94>:
.globl vector94
vector94:
  pushl $0
c010231e:	6a 00                	push   $0x0
  pushl $94
c0102320:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102322:	e9 29 07 00 00       	jmp    c0102a50 <__alltraps>

c0102327 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102327:	6a 00                	push   $0x0
  pushl $95
c0102329:	6a 5f                	push   $0x5f
  jmp __alltraps
c010232b:	e9 20 07 00 00       	jmp    c0102a50 <__alltraps>

c0102330 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102330:	6a 00                	push   $0x0
  pushl $96
c0102332:	6a 60                	push   $0x60
  jmp __alltraps
c0102334:	e9 17 07 00 00       	jmp    c0102a50 <__alltraps>

c0102339 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102339:	6a 00                	push   $0x0
  pushl $97
c010233b:	6a 61                	push   $0x61
  jmp __alltraps
c010233d:	e9 0e 07 00 00       	jmp    c0102a50 <__alltraps>

c0102342 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102342:	6a 00                	push   $0x0
  pushl $98
c0102344:	6a 62                	push   $0x62
  jmp __alltraps
c0102346:	e9 05 07 00 00       	jmp    c0102a50 <__alltraps>

c010234b <vector99>:
.globl vector99
vector99:
  pushl $0
c010234b:	6a 00                	push   $0x0
  pushl $99
c010234d:	6a 63                	push   $0x63
  jmp __alltraps
c010234f:	e9 fc 06 00 00       	jmp    c0102a50 <__alltraps>

c0102354 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102354:	6a 00                	push   $0x0
  pushl $100
c0102356:	6a 64                	push   $0x64
  jmp __alltraps
c0102358:	e9 f3 06 00 00       	jmp    c0102a50 <__alltraps>

c010235d <vector101>:
.globl vector101
vector101:
  pushl $0
c010235d:	6a 00                	push   $0x0
  pushl $101
c010235f:	6a 65                	push   $0x65
  jmp __alltraps
c0102361:	e9 ea 06 00 00       	jmp    c0102a50 <__alltraps>

c0102366 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102366:	6a 00                	push   $0x0
  pushl $102
c0102368:	6a 66                	push   $0x66
  jmp __alltraps
c010236a:	e9 e1 06 00 00       	jmp    c0102a50 <__alltraps>

c010236f <vector103>:
.globl vector103
vector103:
  pushl $0
c010236f:	6a 00                	push   $0x0
  pushl $103
c0102371:	6a 67                	push   $0x67
  jmp __alltraps
c0102373:	e9 d8 06 00 00       	jmp    c0102a50 <__alltraps>

c0102378 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102378:	6a 00                	push   $0x0
  pushl $104
c010237a:	6a 68                	push   $0x68
  jmp __alltraps
c010237c:	e9 cf 06 00 00       	jmp    c0102a50 <__alltraps>

c0102381 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102381:	6a 00                	push   $0x0
  pushl $105
c0102383:	6a 69                	push   $0x69
  jmp __alltraps
c0102385:	e9 c6 06 00 00       	jmp    c0102a50 <__alltraps>

c010238a <vector106>:
.globl vector106
vector106:
  pushl $0
c010238a:	6a 00                	push   $0x0
  pushl $106
c010238c:	6a 6a                	push   $0x6a
  jmp __alltraps
c010238e:	e9 bd 06 00 00       	jmp    c0102a50 <__alltraps>

c0102393 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102393:	6a 00                	push   $0x0
  pushl $107
c0102395:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102397:	e9 b4 06 00 00       	jmp    c0102a50 <__alltraps>

c010239c <vector108>:
.globl vector108
vector108:
  pushl $0
c010239c:	6a 00                	push   $0x0
  pushl $108
c010239e:	6a 6c                	push   $0x6c
  jmp __alltraps
c01023a0:	e9 ab 06 00 00       	jmp    c0102a50 <__alltraps>

c01023a5 <vector109>:
.globl vector109
vector109:
  pushl $0
c01023a5:	6a 00                	push   $0x0
  pushl $109
c01023a7:	6a 6d                	push   $0x6d
  jmp __alltraps
c01023a9:	e9 a2 06 00 00       	jmp    c0102a50 <__alltraps>

c01023ae <vector110>:
.globl vector110
vector110:
  pushl $0
c01023ae:	6a 00                	push   $0x0
  pushl $110
c01023b0:	6a 6e                	push   $0x6e
  jmp __alltraps
c01023b2:	e9 99 06 00 00       	jmp    c0102a50 <__alltraps>

c01023b7 <vector111>:
.globl vector111
vector111:
  pushl $0
c01023b7:	6a 00                	push   $0x0
  pushl $111
c01023b9:	6a 6f                	push   $0x6f
  jmp __alltraps
c01023bb:	e9 90 06 00 00       	jmp    c0102a50 <__alltraps>

c01023c0 <vector112>:
.globl vector112
vector112:
  pushl $0
c01023c0:	6a 00                	push   $0x0
  pushl $112
c01023c2:	6a 70                	push   $0x70
  jmp __alltraps
c01023c4:	e9 87 06 00 00       	jmp    c0102a50 <__alltraps>

c01023c9 <vector113>:
.globl vector113
vector113:
  pushl $0
c01023c9:	6a 00                	push   $0x0
  pushl $113
c01023cb:	6a 71                	push   $0x71
  jmp __alltraps
c01023cd:	e9 7e 06 00 00       	jmp    c0102a50 <__alltraps>

c01023d2 <vector114>:
.globl vector114
vector114:
  pushl $0
c01023d2:	6a 00                	push   $0x0
  pushl $114
c01023d4:	6a 72                	push   $0x72
  jmp __alltraps
c01023d6:	e9 75 06 00 00       	jmp    c0102a50 <__alltraps>

c01023db <vector115>:
.globl vector115
vector115:
  pushl $0
c01023db:	6a 00                	push   $0x0
  pushl $115
c01023dd:	6a 73                	push   $0x73
  jmp __alltraps
c01023df:	e9 6c 06 00 00       	jmp    c0102a50 <__alltraps>

c01023e4 <vector116>:
.globl vector116
vector116:
  pushl $0
c01023e4:	6a 00                	push   $0x0
  pushl $116
c01023e6:	6a 74                	push   $0x74
  jmp __alltraps
c01023e8:	e9 63 06 00 00       	jmp    c0102a50 <__alltraps>

c01023ed <vector117>:
.globl vector117
vector117:
  pushl $0
c01023ed:	6a 00                	push   $0x0
  pushl $117
c01023ef:	6a 75                	push   $0x75
  jmp __alltraps
c01023f1:	e9 5a 06 00 00       	jmp    c0102a50 <__alltraps>

c01023f6 <vector118>:
.globl vector118
vector118:
  pushl $0
c01023f6:	6a 00                	push   $0x0
  pushl $118
c01023f8:	6a 76                	push   $0x76
  jmp __alltraps
c01023fa:	e9 51 06 00 00       	jmp    c0102a50 <__alltraps>

c01023ff <vector119>:
.globl vector119
vector119:
  pushl $0
c01023ff:	6a 00                	push   $0x0
  pushl $119
c0102401:	6a 77                	push   $0x77
  jmp __alltraps
c0102403:	e9 48 06 00 00       	jmp    c0102a50 <__alltraps>

c0102408 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102408:	6a 00                	push   $0x0
  pushl $120
c010240a:	6a 78                	push   $0x78
  jmp __alltraps
c010240c:	e9 3f 06 00 00       	jmp    c0102a50 <__alltraps>

c0102411 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102411:	6a 00                	push   $0x0
  pushl $121
c0102413:	6a 79                	push   $0x79
  jmp __alltraps
c0102415:	e9 36 06 00 00       	jmp    c0102a50 <__alltraps>

c010241a <vector122>:
.globl vector122
vector122:
  pushl $0
c010241a:	6a 00                	push   $0x0
  pushl $122
c010241c:	6a 7a                	push   $0x7a
  jmp __alltraps
c010241e:	e9 2d 06 00 00       	jmp    c0102a50 <__alltraps>

c0102423 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102423:	6a 00                	push   $0x0
  pushl $123
c0102425:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102427:	e9 24 06 00 00       	jmp    c0102a50 <__alltraps>

c010242c <vector124>:
.globl vector124
vector124:
  pushl $0
c010242c:	6a 00                	push   $0x0
  pushl $124
c010242e:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102430:	e9 1b 06 00 00       	jmp    c0102a50 <__alltraps>

c0102435 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102435:	6a 00                	push   $0x0
  pushl $125
c0102437:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102439:	e9 12 06 00 00       	jmp    c0102a50 <__alltraps>

c010243e <vector126>:
.globl vector126
vector126:
  pushl $0
c010243e:	6a 00                	push   $0x0
  pushl $126
c0102440:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102442:	e9 09 06 00 00       	jmp    c0102a50 <__alltraps>

c0102447 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102447:	6a 00                	push   $0x0
  pushl $127
c0102449:	6a 7f                	push   $0x7f
  jmp __alltraps
c010244b:	e9 00 06 00 00       	jmp    c0102a50 <__alltraps>

c0102450 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102450:	6a 00                	push   $0x0
  pushl $128
c0102452:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102457:	e9 f4 05 00 00       	jmp    c0102a50 <__alltraps>

c010245c <vector129>:
.globl vector129
vector129:
  pushl $0
c010245c:	6a 00                	push   $0x0
  pushl $129
c010245e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102463:	e9 e8 05 00 00       	jmp    c0102a50 <__alltraps>

c0102468 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $130
c010246a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010246f:	e9 dc 05 00 00       	jmp    c0102a50 <__alltraps>

c0102474 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102474:	6a 00                	push   $0x0
  pushl $131
c0102476:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010247b:	e9 d0 05 00 00       	jmp    c0102a50 <__alltraps>

c0102480 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102480:	6a 00                	push   $0x0
  pushl $132
c0102482:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102487:	e9 c4 05 00 00       	jmp    c0102a50 <__alltraps>

c010248c <vector133>:
.globl vector133
vector133:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $133
c010248e:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102493:	e9 b8 05 00 00       	jmp    c0102a50 <__alltraps>

c0102498 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102498:	6a 00                	push   $0x0
  pushl $134
c010249a:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010249f:	e9 ac 05 00 00       	jmp    c0102a50 <__alltraps>

c01024a4 <vector135>:
.globl vector135
vector135:
  pushl $0
c01024a4:	6a 00                	push   $0x0
  pushl $135
c01024a6:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01024ab:	e9 a0 05 00 00       	jmp    c0102a50 <__alltraps>

c01024b0 <vector136>:
.globl vector136
vector136:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $136
c01024b2:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01024b7:	e9 94 05 00 00       	jmp    c0102a50 <__alltraps>

c01024bc <vector137>:
.globl vector137
vector137:
  pushl $0
c01024bc:	6a 00                	push   $0x0
  pushl $137
c01024be:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01024c3:	e9 88 05 00 00       	jmp    c0102a50 <__alltraps>

c01024c8 <vector138>:
.globl vector138
vector138:
  pushl $0
c01024c8:	6a 00                	push   $0x0
  pushl $138
c01024ca:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01024cf:	e9 7c 05 00 00       	jmp    c0102a50 <__alltraps>

c01024d4 <vector139>:
.globl vector139
vector139:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $139
c01024d6:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01024db:	e9 70 05 00 00       	jmp    c0102a50 <__alltraps>

c01024e0 <vector140>:
.globl vector140
vector140:
  pushl $0
c01024e0:	6a 00                	push   $0x0
  pushl $140
c01024e2:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01024e7:	e9 64 05 00 00       	jmp    c0102a50 <__alltraps>

c01024ec <vector141>:
.globl vector141
vector141:
  pushl $0
c01024ec:	6a 00                	push   $0x0
  pushl $141
c01024ee:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01024f3:	e9 58 05 00 00       	jmp    c0102a50 <__alltraps>

c01024f8 <vector142>:
.globl vector142
vector142:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $142
c01024fa:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01024ff:	e9 4c 05 00 00       	jmp    c0102a50 <__alltraps>

c0102504 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102504:	6a 00                	push   $0x0
  pushl $143
c0102506:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010250b:	e9 40 05 00 00       	jmp    c0102a50 <__alltraps>

c0102510 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102510:	6a 00                	push   $0x0
  pushl $144
c0102512:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102517:	e9 34 05 00 00       	jmp    c0102a50 <__alltraps>

c010251c <vector145>:
.globl vector145
vector145:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $145
c010251e:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102523:	e9 28 05 00 00       	jmp    c0102a50 <__alltraps>

c0102528 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102528:	6a 00                	push   $0x0
  pushl $146
c010252a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010252f:	e9 1c 05 00 00       	jmp    c0102a50 <__alltraps>

c0102534 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102534:	6a 00                	push   $0x0
  pushl $147
c0102536:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010253b:	e9 10 05 00 00       	jmp    c0102a50 <__alltraps>

c0102540 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $148
c0102542:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102547:	e9 04 05 00 00       	jmp    c0102a50 <__alltraps>

c010254c <vector149>:
.globl vector149
vector149:
  pushl $0
c010254c:	6a 00                	push   $0x0
  pushl $149
c010254e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102553:	e9 f8 04 00 00       	jmp    c0102a50 <__alltraps>

c0102558 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102558:	6a 00                	push   $0x0
  pushl $150
c010255a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010255f:	e9 ec 04 00 00       	jmp    c0102a50 <__alltraps>

c0102564 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $151
c0102566:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010256b:	e9 e0 04 00 00       	jmp    c0102a50 <__alltraps>

c0102570 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102570:	6a 00                	push   $0x0
  pushl $152
c0102572:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102577:	e9 d4 04 00 00       	jmp    c0102a50 <__alltraps>

c010257c <vector153>:
.globl vector153
vector153:
  pushl $0
c010257c:	6a 00                	push   $0x0
  pushl $153
c010257e:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102583:	e9 c8 04 00 00       	jmp    c0102a50 <__alltraps>

c0102588 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $154
c010258a:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010258f:	e9 bc 04 00 00       	jmp    c0102a50 <__alltraps>

c0102594 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102594:	6a 00                	push   $0x0
  pushl $155
c0102596:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010259b:	e9 b0 04 00 00       	jmp    c0102a50 <__alltraps>

c01025a0 <vector156>:
.globl vector156
vector156:
  pushl $0
c01025a0:	6a 00                	push   $0x0
  pushl $156
c01025a2:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01025a7:	e9 a4 04 00 00       	jmp    c0102a50 <__alltraps>

c01025ac <vector157>:
.globl vector157
vector157:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $157
c01025ae:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01025b3:	e9 98 04 00 00       	jmp    c0102a50 <__alltraps>

c01025b8 <vector158>:
.globl vector158
vector158:
  pushl $0
c01025b8:	6a 00                	push   $0x0
  pushl $158
c01025ba:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01025bf:	e9 8c 04 00 00       	jmp    c0102a50 <__alltraps>

c01025c4 <vector159>:
.globl vector159
vector159:
  pushl $0
c01025c4:	6a 00                	push   $0x0
  pushl $159
c01025c6:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01025cb:	e9 80 04 00 00       	jmp    c0102a50 <__alltraps>

c01025d0 <vector160>:
.globl vector160
vector160:
  pushl $0
c01025d0:	6a 00                	push   $0x0
  pushl $160
c01025d2:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01025d7:	e9 74 04 00 00       	jmp    c0102a50 <__alltraps>

c01025dc <vector161>:
.globl vector161
vector161:
  pushl $0
c01025dc:	6a 00                	push   $0x0
  pushl $161
c01025de:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01025e3:	e9 68 04 00 00       	jmp    c0102a50 <__alltraps>

c01025e8 <vector162>:
.globl vector162
vector162:
  pushl $0
c01025e8:	6a 00                	push   $0x0
  pushl $162
c01025ea:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01025ef:	e9 5c 04 00 00       	jmp    c0102a50 <__alltraps>

c01025f4 <vector163>:
.globl vector163
vector163:
  pushl $0
c01025f4:	6a 00                	push   $0x0
  pushl $163
c01025f6:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01025fb:	e9 50 04 00 00       	jmp    c0102a50 <__alltraps>

c0102600 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102600:	6a 00                	push   $0x0
  pushl $164
c0102602:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102607:	e9 44 04 00 00       	jmp    c0102a50 <__alltraps>

c010260c <vector165>:
.globl vector165
vector165:
  pushl $0
c010260c:	6a 00                	push   $0x0
  pushl $165
c010260e:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102613:	e9 38 04 00 00       	jmp    c0102a50 <__alltraps>

c0102618 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102618:	6a 00                	push   $0x0
  pushl $166
c010261a:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010261f:	e9 2c 04 00 00       	jmp    c0102a50 <__alltraps>

c0102624 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102624:	6a 00                	push   $0x0
  pushl $167
c0102626:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010262b:	e9 20 04 00 00       	jmp    c0102a50 <__alltraps>

c0102630 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102630:	6a 00                	push   $0x0
  pushl $168
c0102632:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102637:	e9 14 04 00 00       	jmp    c0102a50 <__alltraps>

c010263c <vector169>:
.globl vector169
vector169:
  pushl $0
c010263c:	6a 00                	push   $0x0
  pushl $169
c010263e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102643:	e9 08 04 00 00       	jmp    c0102a50 <__alltraps>

c0102648 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102648:	6a 00                	push   $0x0
  pushl $170
c010264a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010264f:	e9 fc 03 00 00       	jmp    c0102a50 <__alltraps>

c0102654 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102654:	6a 00                	push   $0x0
  pushl $171
c0102656:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010265b:	e9 f0 03 00 00       	jmp    c0102a50 <__alltraps>

c0102660 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102660:	6a 00                	push   $0x0
  pushl $172
c0102662:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102667:	e9 e4 03 00 00       	jmp    c0102a50 <__alltraps>

c010266c <vector173>:
.globl vector173
vector173:
  pushl $0
c010266c:	6a 00                	push   $0x0
  pushl $173
c010266e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102673:	e9 d8 03 00 00       	jmp    c0102a50 <__alltraps>

c0102678 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102678:	6a 00                	push   $0x0
  pushl $174
c010267a:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010267f:	e9 cc 03 00 00       	jmp    c0102a50 <__alltraps>

c0102684 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102684:	6a 00                	push   $0x0
  pushl $175
c0102686:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010268b:	e9 c0 03 00 00       	jmp    c0102a50 <__alltraps>

c0102690 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102690:	6a 00                	push   $0x0
  pushl $176
c0102692:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102697:	e9 b4 03 00 00       	jmp    c0102a50 <__alltraps>

c010269c <vector177>:
.globl vector177
vector177:
  pushl $0
c010269c:	6a 00                	push   $0x0
  pushl $177
c010269e:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01026a3:	e9 a8 03 00 00       	jmp    c0102a50 <__alltraps>

c01026a8 <vector178>:
.globl vector178
vector178:
  pushl $0
c01026a8:	6a 00                	push   $0x0
  pushl $178
c01026aa:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01026af:	e9 9c 03 00 00       	jmp    c0102a50 <__alltraps>

c01026b4 <vector179>:
.globl vector179
vector179:
  pushl $0
c01026b4:	6a 00                	push   $0x0
  pushl $179
c01026b6:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01026bb:	e9 90 03 00 00       	jmp    c0102a50 <__alltraps>

c01026c0 <vector180>:
.globl vector180
vector180:
  pushl $0
c01026c0:	6a 00                	push   $0x0
  pushl $180
c01026c2:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01026c7:	e9 84 03 00 00       	jmp    c0102a50 <__alltraps>

c01026cc <vector181>:
.globl vector181
vector181:
  pushl $0
c01026cc:	6a 00                	push   $0x0
  pushl $181
c01026ce:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01026d3:	e9 78 03 00 00       	jmp    c0102a50 <__alltraps>

c01026d8 <vector182>:
.globl vector182
vector182:
  pushl $0
c01026d8:	6a 00                	push   $0x0
  pushl $182
c01026da:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01026df:	e9 6c 03 00 00       	jmp    c0102a50 <__alltraps>

c01026e4 <vector183>:
.globl vector183
vector183:
  pushl $0
c01026e4:	6a 00                	push   $0x0
  pushl $183
c01026e6:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01026eb:	e9 60 03 00 00       	jmp    c0102a50 <__alltraps>

c01026f0 <vector184>:
.globl vector184
vector184:
  pushl $0
c01026f0:	6a 00                	push   $0x0
  pushl $184
c01026f2:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01026f7:	e9 54 03 00 00       	jmp    c0102a50 <__alltraps>

c01026fc <vector185>:
.globl vector185
vector185:
  pushl $0
c01026fc:	6a 00                	push   $0x0
  pushl $185
c01026fe:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102703:	e9 48 03 00 00       	jmp    c0102a50 <__alltraps>

c0102708 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102708:	6a 00                	push   $0x0
  pushl $186
c010270a:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010270f:	e9 3c 03 00 00       	jmp    c0102a50 <__alltraps>

c0102714 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102714:	6a 00                	push   $0x0
  pushl $187
c0102716:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010271b:	e9 30 03 00 00       	jmp    c0102a50 <__alltraps>

c0102720 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102720:	6a 00                	push   $0x0
  pushl $188
c0102722:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102727:	e9 24 03 00 00       	jmp    c0102a50 <__alltraps>

c010272c <vector189>:
.globl vector189
vector189:
  pushl $0
c010272c:	6a 00                	push   $0x0
  pushl $189
c010272e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102733:	e9 18 03 00 00       	jmp    c0102a50 <__alltraps>

c0102738 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102738:	6a 00                	push   $0x0
  pushl $190
c010273a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010273f:	e9 0c 03 00 00       	jmp    c0102a50 <__alltraps>

c0102744 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102744:	6a 00                	push   $0x0
  pushl $191
c0102746:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010274b:	e9 00 03 00 00       	jmp    c0102a50 <__alltraps>

c0102750 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102750:	6a 00                	push   $0x0
  pushl $192
c0102752:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102757:	e9 f4 02 00 00       	jmp    c0102a50 <__alltraps>

c010275c <vector193>:
.globl vector193
vector193:
  pushl $0
c010275c:	6a 00                	push   $0x0
  pushl $193
c010275e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102763:	e9 e8 02 00 00       	jmp    c0102a50 <__alltraps>

c0102768 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102768:	6a 00                	push   $0x0
  pushl $194
c010276a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010276f:	e9 dc 02 00 00       	jmp    c0102a50 <__alltraps>

c0102774 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $195
c0102776:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010277b:	e9 d0 02 00 00       	jmp    c0102a50 <__alltraps>

c0102780 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $196
c0102782:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102787:	e9 c4 02 00 00       	jmp    c0102a50 <__alltraps>

c010278c <vector197>:
.globl vector197
vector197:
  pushl $0
c010278c:	6a 00                	push   $0x0
  pushl $197
c010278e:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102793:	e9 b8 02 00 00       	jmp    c0102a50 <__alltraps>

c0102798 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $198
c010279a:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010279f:	e9 ac 02 00 00       	jmp    c0102a50 <__alltraps>

c01027a4 <vector199>:
.globl vector199
vector199:
  pushl $0
c01027a4:	6a 00                	push   $0x0
  pushl $199
c01027a6:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01027ab:	e9 a0 02 00 00       	jmp    c0102a50 <__alltraps>

c01027b0 <vector200>:
.globl vector200
vector200:
  pushl $0
c01027b0:	6a 00                	push   $0x0
  pushl $200
c01027b2:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01027b7:	e9 94 02 00 00       	jmp    c0102a50 <__alltraps>

c01027bc <vector201>:
.globl vector201
vector201:
  pushl $0
c01027bc:	6a 00                	push   $0x0
  pushl $201
c01027be:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01027c3:	e9 88 02 00 00       	jmp    c0102a50 <__alltraps>

c01027c8 <vector202>:
.globl vector202
vector202:
  pushl $0
c01027c8:	6a 00                	push   $0x0
  pushl $202
c01027ca:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01027cf:	e9 7c 02 00 00       	jmp    c0102a50 <__alltraps>

c01027d4 <vector203>:
.globl vector203
vector203:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $203
c01027d6:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01027db:	e9 70 02 00 00       	jmp    c0102a50 <__alltraps>

c01027e0 <vector204>:
.globl vector204
vector204:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $204
c01027e2:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01027e7:	e9 64 02 00 00       	jmp    c0102a50 <__alltraps>

c01027ec <vector205>:
.globl vector205
vector205:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $205
c01027ee:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01027f3:	e9 58 02 00 00       	jmp    c0102a50 <__alltraps>

c01027f8 <vector206>:
.globl vector206
vector206:
  pushl $0
c01027f8:	6a 00                	push   $0x0
  pushl $206
c01027fa:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01027ff:	e9 4c 02 00 00       	jmp    c0102a50 <__alltraps>

c0102804 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $207
c0102806:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010280b:	e9 40 02 00 00       	jmp    c0102a50 <__alltraps>

c0102810 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $208
c0102812:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102817:	e9 34 02 00 00       	jmp    c0102a50 <__alltraps>

c010281c <vector209>:
.globl vector209
vector209:
  pushl $0
c010281c:	6a 00                	push   $0x0
  pushl $209
c010281e:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102823:	e9 28 02 00 00       	jmp    c0102a50 <__alltraps>

c0102828 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $210
c010282a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010282f:	e9 1c 02 00 00       	jmp    c0102a50 <__alltraps>

c0102834 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $211
c0102836:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010283b:	e9 10 02 00 00       	jmp    c0102a50 <__alltraps>

c0102840 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102840:	6a 00                	push   $0x0
  pushl $212
c0102842:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102847:	e9 04 02 00 00       	jmp    c0102a50 <__alltraps>

c010284c <vector213>:
.globl vector213
vector213:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $213
c010284e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102853:	e9 f8 01 00 00       	jmp    c0102a50 <__alltraps>

c0102858 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $214
c010285a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010285f:	e9 ec 01 00 00       	jmp    c0102a50 <__alltraps>

c0102864 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102864:	6a 00                	push   $0x0
  pushl $215
c0102866:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010286b:	e9 e0 01 00 00       	jmp    c0102a50 <__alltraps>

c0102870 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $216
c0102872:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102877:	e9 d4 01 00 00       	jmp    c0102a50 <__alltraps>

c010287c <vector217>:
.globl vector217
vector217:
  pushl $0
c010287c:	6a 00                	push   $0x0
  pushl $217
c010287e:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102883:	e9 c8 01 00 00       	jmp    c0102a50 <__alltraps>

c0102888 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102888:	6a 00                	push   $0x0
  pushl $218
c010288a:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010288f:	e9 bc 01 00 00       	jmp    c0102a50 <__alltraps>

c0102894 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102894:	6a 00                	push   $0x0
  pushl $219
c0102896:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010289b:	e9 b0 01 00 00       	jmp    c0102a50 <__alltraps>

c01028a0 <vector220>:
.globl vector220
vector220:
  pushl $0
c01028a0:	6a 00                	push   $0x0
  pushl $220
c01028a2:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01028a7:	e9 a4 01 00 00       	jmp    c0102a50 <__alltraps>

c01028ac <vector221>:
.globl vector221
vector221:
  pushl $0
c01028ac:	6a 00                	push   $0x0
  pushl $221
c01028ae:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01028b3:	e9 98 01 00 00       	jmp    c0102a50 <__alltraps>

c01028b8 <vector222>:
.globl vector222
vector222:
  pushl $0
c01028b8:	6a 00                	push   $0x0
  pushl $222
c01028ba:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01028bf:	e9 8c 01 00 00       	jmp    c0102a50 <__alltraps>

c01028c4 <vector223>:
.globl vector223
vector223:
  pushl $0
c01028c4:	6a 00                	push   $0x0
  pushl $223
c01028c6:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01028cb:	e9 80 01 00 00       	jmp    c0102a50 <__alltraps>

c01028d0 <vector224>:
.globl vector224
vector224:
  pushl $0
c01028d0:	6a 00                	push   $0x0
  pushl $224
c01028d2:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01028d7:	e9 74 01 00 00       	jmp    c0102a50 <__alltraps>

c01028dc <vector225>:
.globl vector225
vector225:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $225
c01028de:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01028e3:	e9 68 01 00 00       	jmp    c0102a50 <__alltraps>

c01028e8 <vector226>:
.globl vector226
vector226:
  pushl $0
c01028e8:	6a 00                	push   $0x0
  pushl $226
c01028ea:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01028ef:	e9 5c 01 00 00       	jmp    c0102a50 <__alltraps>

c01028f4 <vector227>:
.globl vector227
vector227:
  pushl $0
c01028f4:	6a 00                	push   $0x0
  pushl $227
c01028f6:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01028fb:	e9 50 01 00 00       	jmp    c0102a50 <__alltraps>

c0102900 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $228
c0102902:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102907:	e9 44 01 00 00       	jmp    c0102a50 <__alltraps>

c010290c <vector229>:
.globl vector229
vector229:
  pushl $0
c010290c:	6a 00                	push   $0x0
  pushl $229
c010290e:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102913:	e9 38 01 00 00       	jmp    c0102a50 <__alltraps>

c0102918 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102918:	6a 00                	push   $0x0
  pushl $230
c010291a:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010291f:	e9 2c 01 00 00       	jmp    c0102a50 <__alltraps>

c0102924 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102924:	6a 00                	push   $0x0
  pushl $231
c0102926:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010292b:	e9 20 01 00 00       	jmp    c0102a50 <__alltraps>

c0102930 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102930:	6a 00                	push   $0x0
  pushl $232
c0102932:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102937:	e9 14 01 00 00       	jmp    c0102a50 <__alltraps>

c010293c <vector233>:
.globl vector233
vector233:
  pushl $0
c010293c:	6a 00                	push   $0x0
  pushl $233
c010293e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102943:	e9 08 01 00 00       	jmp    c0102a50 <__alltraps>

c0102948 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102948:	6a 00                	push   $0x0
  pushl $234
c010294a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010294f:	e9 fc 00 00 00       	jmp    c0102a50 <__alltraps>

c0102954 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102954:	6a 00                	push   $0x0
  pushl $235
c0102956:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010295b:	e9 f0 00 00 00       	jmp    c0102a50 <__alltraps>

c0102960 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102960:	6a 00                	push   $0x0
  pushl $236
c0102962:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102967:	e9 e4 00 00 00       	jmp    c0102a50 <__alltraps>

c010296c <vector237>:
.globl vector237
vector237:
  pushl $0
c010296c:	6a 00                	push   $0x0
  pushl $237
c010296e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102973:	e9 d8 00 00 00       	jmp    c0102a50 <__alltraps>

c0102978 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102978:	6a 00                	push   $0x0
  pushl $238
c010297a:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010297f:	e9 cc 00 00 00       	jmp    c0102a50 <__alltraps>

c0102984 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102984:	6a 00                	push   $0x0
  pushl $239
c0102986:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010298b:	e9 c0 00 00 00       	jmp    c0102a50 <__alltraps>

c0102990 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102990:	6a 00                	push   $0x0
  pushl $240
c0102992:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102997:	e9 b4 00 00 00       	jmp    c0102a50 <__alltraps>

c010299c <vector241>:
.globl vector241
vector241:
  pushl $0
c010299c:	6a 00                	push   $0x0
  pushl $241
c010299e:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01029a3:	e9 a8 00 00 00       	jmp    c0102a50 <__alltraps>

c01029a8 <vector242>:
.globl vector242
vector242:
  pushl $0
c01029a8:	6a 00                	push   $0x0
  pushl $242
c01029aa:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01029af:	e9 9c 00 00 00       	jmp    c0102a50 <__alltraps>

c01029b4 <vector243>:
.globl vector243
vector243:
  pushl $0
c01029b4:	6a 00                	push   $0x0
  pushl $243
c01029b6:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01029bb:	e9 90 00 00 00       	jmp    c0102a50 <__alltraps>

c01029c0 <vector244>:
.globl vector244
vector244:
  pushl $0
c01029c0:	6a 00                	push   $0x0
  pushl $244
c01029c2:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01029c7:	e9 84 00 00 00       	jmp    c0102a50 <__alltraps>

c01029cc <vector245>:
.globl vector245
vector245:
  pushl $0
c01029cc:	6a 00                	push   $0x0
  pushl $245
c01029ce:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01029d3:	e9 78 00 00 00       	jmp    c0102a50 <__alltraps>

c01029d8 <vector246>:
.globl vector246
vector246:
  pushl $0
c01029d8:	6a 00                	push   $0x0
  pushl $246
c01029da:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01029df:	e9 6c 00 00 00       	jmp    c0102a50 <__alltraps>

c01029e4 <vector247>:
.globl vector247
vector247:
  pushl $0
c01029e4:	6a 00                	push   $0x0
  pushl $247
c01029e6:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01029eb:	e9 60 00 00 00       	jmp    c0102a50 <__alltraps>

c01029f0 <vector248>:
.globl vector248
vector248:
  pushl $0
c01029f0:	6a 00                	push   $0x0
  pushl $248
c01029f2:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01029f7:	e9 54 00 00 00       	jmp    c0102a50 <__alltraps>

c01029fc <vector249>:
.globl vector249
vector249:
  pushl $0
c01029fc:	6a 00                	push   $0x0
  pushl $249
c01029fe:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102a03:	e9 48 00 00 00       	jmp    c0102a50 <__alltraps>

c0102a08 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102a08:	6a 00                	push   $0x0
  pushl $250
c0102a0a:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102a0f:	e9 3c 00 00 00       	jmp    c0102a50 <__alltraps>

c0102a14 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102a14:	6a 00                	push   $0x0
  pushl $251
c0102a16:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102a1b:	e9 30 00 00 00       	jmp    c0102a50 <__alltraps>

c0102a20 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102a20:	6a 00                	push   $0x0
  pushl $252
c0102a22:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102a27:	e9 24 00 00 00       	jmp    c0102a50 <__alltraps>

c0102a2c <vector253>:
.globl vector253
vector253:
  pushl $0
c0102a2c:	6a 00                	push   $0x0
  pushl $253
c0102a2e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102a33:	e9 18 00 00 00       	jmp    c0102a50 <__alltraps>

c0102a38 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102a38:	6a 00                	push   $0x0
  pushl $254
c0102a3a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102a3f:	e9 0c 00 00 00       	jmp    c0102a50 <__alltraps>

c0102a44 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102a44:	6a 00                	push   $0x0
  pushl $255
c0102a46:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102a4b:	e9 00 00 00 00       	jmp    c0102a50 <__alltraps>

c0102a50 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102a50:	1e                   	push   %ds
    pushl %es
c0102a51:	06                   	push   %es
    pushl %fs
c0102a52:	0f a0                	push   %fs
    pushl %gs
c0102a54:	0f a8                	push   %gs
    pushal
c0102a56:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102a57:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102a5c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102a5e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102a60:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102a61:	e8 60 f5 ff ff       	call   c0101fc6 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102a66:	5c                   	pop    %esp

c0102a67 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102a67:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102a68:	0f a9                	pop    %gs
    popl %fs
c0102a6a:	0f a1                	pop    %fs
    popl %es
c0102a6c:	07                   	pop    %es
    popl %ds
c0102a6d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102a6e:	83 c4 08             	add    $0x8,%esp
    iret
c0102a71:	cf                   	iret   

c0102a72 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102a72:	55                   	push   %ebp
c0102a73:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102a75:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0102a7a:	8b 55 08             	mov    0x8(%ebp),%edx
c0102a7d:	29 c2                	sub    %eax,%edx
c0102a7f:	89 d0                	mov    %edx,%eax
c0102a81:	c1 f8 02             	sar    $0x2,%eax
c0102a84:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102a8a:	5d                   	pop    %ebp
c0102a8b:	c3                   	ret    

c0102a8c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102a8c:	55                   	push   %ebp
c0102a8d:	89 e5                	mov    %esp,%ebp
c0102a8f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a95:	89 04 24             	mov    %eax,(%esp)
c0102a98:	e8 d5 ff ff ff       	call   c0102a72 <page2ppn>
c0102a9d:	c1 e0 0c             	shl    $0xc,%eax
}
c0102aa0:	c9                   	leave  
c0102aa1:	c3                   	ret    

c0102aa2 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102aa2:	55                   	push   %ebp
c0102aa3:	89 e5                	mov    %esp,%ebp
c0102aa5:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aab:	c1 e8 0c             	shr    $0xc,%eax
c0102aae:	89 c2                	mov    %eax,%edx
c0102ab0:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102ab5:	39 c2                	cmp    %eax,%edx
c0102ab7:	72 1c                	jb     c0102ad5 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102ab9:	c7 44 24 08 70 69 10 	movl   $0xc0106970,0x8(%esp)
c0102ac0:	c0 
c0102ac1:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102ac8:	00 
c0102ac9:	c7 04 24 8f 69 10 c0 	movl   $0xc010698f,(%esp)
c0102ad0:	e8 70 d9 ff ff       	call   c0100445 <__panic>
    }
    return &pages[PPN(pa)];
c0102ad5:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c0102adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ade:	c1 e8 0c             	shr    $0xc,%eax
c0102ae1:	89 c2                	mov    %eax,%edx
c0102ae3:	89 d0                	mov    %edx,%eax
c0102ae5:	c1 e0 02             	shl    $0x2,%eax
c0102ae8:	01 d0                	add    %edx,%eax
c0102aea:	c1 e0 02             	shl    $0x2,%eax
c0102aed:	01 c8                	add    %ecx,%eax
}
c0102aef:	c9                   	leave  
c0102af0:	c3                   	ret    

c0102af1 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102af1:	55                   	push   %ebp
c0102af2:	89 e5                	mov    %esp,%ebp
c0102af4:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102af7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102afa:	89 04 24             	mov    %eax,(%esp)
c0102afd:	e8 8a ff ff ff       	call   c0102a8c <page2pa>
c0102b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b08:	c1 e8 0c             	shr    $0xc,%eax
c0102b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b0e:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102b13:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102b16:	72 23                	jb     c0102b3b <page2kva+0x4a>
c0102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102b1f:	c7 44 24 08 a0 69 10 	movl   $0xc01069a0,0x8(%esp)
c0102b26:	c0 
c0102b27:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102b2e:	00 
c0102b2f:	c7 04 24 8f 69 10 c0 	movl   $0xc010698f,(%esp)
c0102b36:	e8 0a d9 ff ff       	call   c0100445 <__panic>
c0102b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b3e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102b43:	c9                   	leave  
c0102b44:	c3                   	ret    

c0102b45 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102b45:	55                   	push   %ebp
c0102b46:	89 e5                	mov    %esp,%ebp
c0102b48:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b4e:	83 e0 01             	and    $0x1,%eax
c0102b51:	85 c0                	test   %eax,%eax
c0102b53:	75 1c                	jne    c0102b71 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102b55:	c7 44 24 08 c4 69 10 	movl   $0xc01069c4,0x8(%esp)
c0102b5c:	c0 
c0102b5d:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102b64:	00 
c0102b65:	c7 04 24 8f 69 10 c0 	movl   $0xc010698f,(%esp)
c0102b6c:	e8 d4 d8 ff ff       	call   c0100445 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102b79:	89 04 24             	mov    %eax,(%esp)
c0102b7c:	e8 21 ff ff ff       	call   c0102aa2 <pa2page>
}
c0102b81:	c9                   	leave  
c0102b82:	c3                   	ret    

c0102b83 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102b83:	55                   	push   %ebp
c0102b84:	89 e5                	mov    %esp,%ebp
c0102b86:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102b89:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102b91:	89 04 24             	mov    %eax,(%esp)
c0102b94:	e8 09 ff ff ff       	call   c0102aa2 <pa2page>
}
c0102b99:	c9                   	leave  
c0102b9a:	c3                   	ret    

c0102b9b <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102b9b:	55                   	push   %ebp
c0102b9c:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102b9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ba1:	8b 00                	mov    (%eax),%eax
}
c0102ba3:	5d                   	pop    %ebp
c0102ba4:	c3                   	ret    

c0102ba5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102ba5:	55                   	push   %ebp
c0102ba6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bab:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102bae:	89 10                	mov    %edx,(%eax)
}
c0102bb0:	90                   	nop
c0102bb1:	5d                   	pop    %ebp
c0102bb2:	c3                   	ret    

c0102bb3 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102bb3:	55                   	push   %ebp
c0102bb4:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102bb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bb9:	8b 00                	mov    (%eax),%eax
c0102bbb:	8d 50 01             	lea    0x1(%eax),%edx
c0102bbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bc1:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102bc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bc6:	8b 00                	mov    (%eax),%eax
}
c0102bc8:	5d                   	pop    %ebp
c0102bc9:	c3                   	ret    

c0102bca <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102bca:	55                   	push   %ebp
c0102bcb:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102bcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bd0:	8b 00                	mov    (%eax),%eax
c0102bd2:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bd8:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bdd:	8b 00                	mov    (%eax),%eax
}
c0102bdf:	5d                   	pop    %ebp
c0102be0:	c3                   	ret    

c0102be1 <__intr_save>:
__intr_save(void) {
c0102be1:	55                   	push   %ebp
c0102be2:	89 e5                	mov    %esp,%ebp
c0102be4:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102be7:	9c                   	pushf  
c0102be8:	58                   	pop    %eax
c0102be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102bef:	25 00 02 00 00       	and    $0x200,%eax
c0102bf4:	85 c0                	test   %eax,%eax
c0102bf6:	74 0c                	je     c0102c04 <__intr_save+0x23>
        intr_disable();
c0102bf8:	e8 b2 ed ff ff       	call   c01019af <intr_disable>
        return 1;
c0102bfd:	b8 01 00 00 00       	mov    $0x1,%eax
c0102c02:	eb 05                	jmp    c0102c09 <__intr_save+0x28>
    return 0;
c0102c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102c09:	c9                   	leave  
c0102c0a:	c3                   	ret    

c0102c0b <__intr_restore>:
__intr_restore(bool flag) {
c0102c0b:	55                   	push   %ebp
c0102c0c:	89 e5                	mov    %esp,%ebp
c0102c0e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102c11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102c15:	74 05                	je     c0102c1c <__intr_restore+0x11>
        intr_enable();
c0102c17:	e8 87 ed ff ff       	call   c01019a3 <intr_enable>
}
c0102c1c:	90                   	nop
c0102c1d:	c9                   	leave  
c0102c1e:	c3                   	ret    

c0102c1f <lgdt>:
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd)
{
c0102c1f:	55                   	push   %ebp
c0102c20:	89 e5                	mov    %esp,%ebp
    asm volatile("lgdt (%0)" ::"r"(pd));
c0102c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c25:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax, %%gs" ::"a"(USER_DS));
c0102c28:	b8 23 00 00 00       	mov    $0x23,%eax
c0102c2d:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax, %%fs" ::"a"(USER_DS));
c0102c2f:	b8 23 00 00 00       	mov    $0x23,%eax
c0102c34:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax, %%es" ::"a"(KERNEL_DS));
c0102c36:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c3b:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax, %%ds" ::"a"(KERNEL_DS));
c0102c3d:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c42:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax, %%ss" ::"a"(KERNEL_DS));
c0102c44:	b8 10 00 00 00       	mov    $0x10,%eax
c0102c49:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile("ljmp %0, $1f\n 1:\n" ::"i"(KERNEL_CS));
c0102c4b:	ea 52 2c 10 c0 08 00 	ljmp   $0x8,$0xc0102c52
}
c0102c52:	90                   	nop
c0102c53:	5d                   	pop    %ebp
c0102c54:	c3                   	ret    

c0102c55 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void load_esp0(uintptr_t esp0)
{
c0102c55:	f3 0f 1e fb          	endbr32 
c0102c59:	55                   	push   %ebp
c0102c5a:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102c5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c5f:	a3 a4 ce 11 c0       	mov    %eax,0xc011cea4
}
c0102c64:	90                   	nop
c0102c65:	5d                   	pop    %ebp
c0102c66:	c3                   	ret    

c0102c67 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void)
{
c0102c67:	f3 0f 1e fb          	endbr32 
c0102c6b:	55                   	push   %ebp
c0102c6c:	89 e5                	mov    %esp,%ebp
c0102c6e:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102c71:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0102c76:	89 04 24             	mov    %eax,(%esp)
c0102c79:	e8 d7 ff ff ff       	call   c0102c55 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102c7e:	66 c7 05 a8 ce 11 c0 	movw   $0x10,0xc011cea8
c0102c85:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102c87:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0102c8e:	68 00 
c0102c90:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102c95:	0f b7 c0             	movzwl %ax,%eax
c0102c98:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0102c9e:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102ca3:	c1 e8 10             	shr    $0x10,%eax
c0102ca6:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0102cab:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102cb2:	24 f0                	and    $0xf0,%al
c0102cb4:	0c 09                	or     $0x9,%al
c0102cb6:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102cbb:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102cc2:	24 ef                	and    $0xef,%al
c0102cc4:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102cc9:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102cd0:	24 9f                	and    $0x9f,%al
c0102cd2:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102cd7:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102cde:	0c 80                	or     $0x80,%al
c0102ce0:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102ce5:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102cec:	24 f0                	and    $0xf0,%al
c0102cee:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102cf3:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102cfa:	24 ef                	and    $0xef,%al
c0102cfc:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102d01:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102d08:	24 df                	and    $0xdf,%al
c0102d0a:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102d0f:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102d16:	0c 40                	or     $0x40,%al
c0102d18:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102d1d:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102d24:	24 7f                	and    $0x7f,%al
c0102d26:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102d2b:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102d30:	c1 e8 18             	shr    $0x18,%eax
c0102d33:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102d38:	c7 04 24 30 9a 11 c0 	movl   $0xc0119a30,(%esp)
c0102d3f:	e8 db fe ff ff       	call   c0102c1f <lgdt>
c0102d44:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102d4a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102d4e:	0f 00 d8             	ltr    %ax
}
c0102d51:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0102d52:	90                   	nop
c0102d53:	c9                   	leave  
c0102d54:	c3                   	ret    

c0102d55 <init_pmm_manager>:

// init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void)
{
c0102d55:	f3 0f 1e fb          	endbr32 
c0102d59:	55                   	push   %ebp
c0102d5a:	89 e5                	mov    %esp,%ebp
c0102d5c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102d5f:	c7 05 10 cf 11 c0 80 	movl   $0xc0107380,0xc011cf10
c0102d66:	73 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102d69:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d6e:	8b 00                	mov    (%eax),%eax
c0102d70:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102d74:	c7 04 24 f0 69 10 c0 	movl   $0xc01069f0,(%esp)
c0102d7b:	e8 59 d5 ff ff       	call   c01002d9 <cprintf>
    pmm_manager->init();
c0102d80:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d85:	8b 40 04             	mov    0x4(%eax),%eax
c0102d88:	ff d0                	call   *%eax
}
c0102d8a:	90                   	nop
c0102d8b:	c9                   	leave  
c0102d8c:	c3                   	ret    

c0102d8d <init_memmap>:

// init_memmap - call pmm->init_memmap to build Page struct for free memory
static void
init_memmap(struct Page *base, size_t n)
{
c0102d8d:	f3 0f 1e fb          	endbr32 
c0102d91:	55                   	push   %ebp
c0102d92:	89 e5                	mov    %esp,%ebp
c0102d94:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102d97:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d9c:	8b 40 08             	mov    0x8(%eax),%eax
c0102d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102da2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102da6:	8b 55 08             	mov    0x8(%ebp),%edx
c0102da9:	89 14 24             	mov    %edx,(%esp)
c0102dac:	ff d0                	call   *%eax
}
c0102dae:	90                   	nop
c0102daf:	c9                   	leave  
c0102db0:	c3                   	ret    

c0102db1 <alloc_pages>:

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory
struct Page *
alloc_pages(size_t n)
{
c0102db1:	f3 0f 1e fb          	endbr32 
c0102db5:	55                   	push   %ebp
c0102db6:	89 e5                	mov    %esp,%ebp
c0102db8:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = NULL;
c0102dbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102dc2:	e8 1a fe ff ff       	call   c0102be1 <__intr_save>
c0102dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102dca:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102dcf:	8b 40 0c             	mov    0xc(%eax),%eax
c0102dd2:	8b 55 08             	mov    0x8(%ebp),%edx
c0102dd5:	89 14 24             	mov    %edx,(%esp)
c0102dd8:	ff d0                	call   *%eax
c0102dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102de0:	89 04 24             	mov    %eax,(%esp)
c0102de3:	e8 23 fe ff ff       	call   c0102c0b <__intr_restore>
    return page;
c0102de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102deb:	c9                   	leave  
c0102dec:	c3                   	ret    

c0102ded <free_pages>:

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n)
{
c0102ded:	f3 0f 1e fb          	endbr32 
c0102df1:	55                   	push   %ebp
c0102df2:	89 e5                	mov    %esp,%ebp
c0102df4:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102df7:	e8 e5 fd ff ff       	call   c0102be1 <__intr_save>
c0102dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102dff:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102e04:	8b 40 10             	mov    0x10(%eax),%eax
c0102e07:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e0a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102e0e:	8b 55 08             	mov    0x8(%ebp),%edx
c0102e11:	89 14 24             	mov    %edx,(%esp)
c0102e14:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e19:	89 04 24             	mov    %eax,(%esp)
c0102e1c:	e8 ea fd ff ff       	call   c0102c0b <__intr_restore>
}
c0102e21:	90                   	nop
c0102e22:	c9                   	leave  
c0102e23:	c3                   	ret    

c0102e24 <nr_free_pages>:

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t
nr_free_pages(void)
{
c0102e24:	f3 0f 1e fb          	endbr32 
c0102e28:	55                   	push   %ebp
c0102e29:	89 e5                	mov    %esp,%ebp
c0102e2b:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102e2e:	e8 ae fd ff ff       	call   c0102be1 <__intr_save>
c0102e33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102e36:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102e3b:	8b 40 14             	mov    0x14(%eax),%eax
c0102e3e:	ff d0                	call   *%eax
c0102e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e46:	89 04 24             	mov    %eax,(%esp)
c0102e49:	e8 bd fd ff ff       	call   c0102c0b <__intr_restore>
    return ret;
c0102e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102e51:	c9                   	leave  
c0102e52:	c3                   	ret    

c0102e53 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void)
{
c0102e53:	f3 0f 1e fb          	endbr32 
c0102e57:	55                   	push   %ebp
c0102e58:	89 e5                	mov    %esp,%ebp
c0102e5a:	57                   	push   %edi
c0102e5b:	56                   	push   %esi
c0102e5c:	53                   	push   %ebx
c0102e5d:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102e63:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102e6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102e71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102e78:	c7 04 24 07 6a 10 c0 	movl   $0xc0106a07,(%esp)
c0102e7f:	e8 55 d4 ff ff       	call   c01002d9 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i++)
c0102e84:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e8b:	e9 1a 01 00 00       	jmp    c0102faa <page_init+0x157>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e90:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e93:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e96:	89 d0                	mov    %edx,%eax
c0102e98:	c1 e0 02             	shl    $0x2,%eax
c0102e9b:	01 d0                	add    %edx,%eax
c0102e9d:	c1 e0 02             	shl    $0x2,%eax
c0102ea0:	01 c8                	add    %ecx,%eax
c0102ea2:	8b 50 08             	mov    0x8(%eax),%edx
c0102ea5:	8b 40 04             	mov    0x4(%eax),%eax
c0102ea8:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102eab:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102eae:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102eb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102eb4:	89 d0                	mov    %edx,%eax
c0102eb6:	c1 e0 02             	shl    $0x2,%eax
c0102eb9:	01 d0                	add    %edx,%eax
c0102ebb:	c1 e0 02             	shl    $0x2,%eax
c0102ebe:	01 c8                	add    %ecx,%eax
c0102ec0:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102ec3:	8b 58 10             	mov    0x10(%eax),%ebx
c0102ec6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ec9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102ecc:	01 c8                	add    %ecx,%eax
c0102ece:	11 da                	adc    %ebx,%edx
c0102ed0:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102ed3:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102ed6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ed9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102edc:	89 d0                	mov    %edx,%eax
c0102ede:	c1 e0 02             	shl    $0x2,%eax
c0102ee1:	01 d0                	add    %edx,%eax
c0102ee3:	c1 e0 02             	shl    $0x2,%eax
c0102ee6:	01 c8                	add    %ecx,%eax
c0102ee8:	83 c0 14             	add    $0x14,%eax
c0102eeb:	8b 00                	mov    (%eax),%eax
c0102eed:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102ef0:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102ef3:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102ef6:	83 c0 ff             	add    $0xffffffff,%eax
c0102ef9:	83 d2 ff             	adc    $0xffffffff,%edx
c0102efc:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0102f02:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102f08:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f0e:	89 d0                	mov    %edx,%eax
c0102f10:	c1 e0 02             	shl    $0x2,%eax
c0102f13:	01 d0                	add    %edx,%eax
c0102f15:	c1 e0 02             	shl    $0x2,%eax
c0102f18:	01 c8                	add    %ecx,%eax
c0102f1a:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102f1d:	8b 58 10             	mov    0x10(%eax),%ebx
c0102f20:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102f23:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0102f27:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102f2d:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102f33:	89 44 24 14          	mov    %eax,0x14(%esp)
c0102f37:	89 54 24 18          	mov    %edx,0x18(%esp)
c0102f3b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f3e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102f41:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102f45:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102f49:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102f4d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102f51:	c7 04 24 14 6a 10 c0 	movl   $0xc0106a14,(%esp)
c0102f58:	e8 7c d3 ff ff       	call   c01002d9 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM)
c0102f5d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f60:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f63:	89 d0                	mov    %edx,%eax
c0102f65:	c1 e0 02             	shl    $0x2,%eax
c0102f68:	01 d0                	add    %edx,%eax
c0102f6a:	c1 e0 02             	shl    $0x2,%eax
c0102f6d:	01 c8                	add    %ecx,%eax
c0102f6f:	83 c0 14             	add    $0x14,%eax
c0102f72:	8b 00                	mov    (%eax),%eax
c0102f74:	83 f8 01             	cmp    $0x1,%eax
c0102f77:	75 2e                	jne    c0102fa7 <page_init+0x154>
        {
            if (maxpa < end && begin < KMEMSIZE)
c0102f79:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102f7f:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102f82:	89 d0                	mov    %edx,%eax
c0102f84:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0102f87:	73 1e                	jae    c0102fa7 <page_init+0x154>
c0102f89:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0102f8e:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f93:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0102f96:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0102f99:	72 0c                	jb     c0102fa7 <page_init+0x154>
            {
                maxpa = end;
c0102f9b:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f9e:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102fa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102fa4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++)
c0102fa7:	ff 45 dc             	incl   -0x24(%ebp)
c0102faa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102fad:	8b 00                	mov    (%eax),%eax
c0102faf:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102fb2:	0f 8c d8 fe ff ff    	jl     c0102e90 <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE)
c0102fb8:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0102fbd:	b8 00 00 00 00       	mov    $0x0,%eax
c0102fc2:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0102fc5:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0102fc8:	73 0e                	jae    c0102fd8 <page_init+0x185>
    {
        maxpa = KMEMSIZE;
c0102fca:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102fd1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102fdb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102fde:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102fe2:	c1 ea 0c             	shr    $0xc,%edx
c0102fe5:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102fea:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0102ff1:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0102ff6:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102ff9:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ffc:	01 d0                	add    %edx,%eax
c0102ffe:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103001:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103004:	ba 00 00 00 00       	mov    $0x0,%edx
c0103009:	f7 75 c0             	divl   -0x40(%ebp)
c010300c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010300f:	29 d0                	sub    %edx,%eax
c0103011:	a3 18 cf 11 c0       	mov    %eax,0xc011cf18

    for (i = 0; i < npage; i++)
c0103016:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010301d:	eb 2f                	jmp    c010304e <page_init+0x1fb>
    {
        SetPageReserved(pages + i);
c010301f:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c0103025:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103028:	89 d0                	mov    %edx,%eax
c010302a:	c1 e0 02             	shl    $0x2,%eax
c010302d:	01 d0                	add    %edx,%eax
c010302f:	c1 e0 02             	shl    $0x2,%eax
c0103032:	01 c8                	add    %ecx,%eax
c0103034:	83 c0 04             	add    $0x4,%eax
c0103037:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c010303e:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103041:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103044:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103047:	0f ab 10             	bts    %edx,(%eax)
}
c010304a:	90                   	nop
    for (i = 0; i < npage; i++)
c010304b:	ff 45 dc             	incl   -0x24(%ebp)
c010304e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103051:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103056:	39 c2                	cmp    %eax,%edx
c0103058:	72 c5                	jb     c010301f <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010305a:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0103060:	89 d0                	mov    %edx,%eax
c0103062:	c1 e0 02             	shl    $0x2,%eax
c0103065:	01 d0                	add    %edx,%eax
c0103067:	c1 e0 02             	shl    $0x2,%eax
c010306a:	89 c2                	mov    %eax,%edx
c010306c:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0103071:	01 d0                	add    %edx,%eax
c0103073:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103076:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c010307d:	77 23                	ja     c01030a2 <page_init+0x24f>
c010307f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103082:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103086:	c7 44 24 08 44 6a 10 	movl   $0xc0106a44,0x8(%esp)
c010308d:	c0 
c010308e:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103095:	00 
c0103096:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c010309d:	e8 a3 d3 ff ff       	call   c0100445 <__panic>
c01030a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01030a5:	05 00 00 00 40       	add    $0x40000000,%eax
c01030aa:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i++)
c01030ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01030b4:	e9 4b 01 00 00       	jmp    c0103204 <page_init+0x3b1>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01030b9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030bf:	89 d0                	mov    %edx,%eax
c01030c1:	c1 e0 02             	shl    $0x2,%eax
c01030c4:	01 d0                	add    %edx,%eax
c01030c6:	c1 e0 02             	shl    $0x2,%eax
c01030c9:	01 c8                	add    %ecx,%eax
c01030cb:	8b 50 08             	mov    0x8(%eax),%edx
c01030ce:	8b 40 04             	mov    0x4(%eax),%eax
c01030d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01030d7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030da:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030dd:	89 d0                	mov    %edx,%eax
c01030df:	c1 e0 02             	shl    $0x2,%eax
c01030e2:	01 d0                	add    %edx,%eax
c01030e4:	c1 e0 02             	shl    $0x2,%eax
c01030e7:	01 c8                	add    %ecx,%eax
c01030e9:	8b 48 0c             	mov    0xc(%eax),%ecx
c01030ec:	8b 58 10             	mov    0x10(%eax),%ebx
c01030ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01030f5:	01 c8                	add    %ecx,%eax
c01030f7:	11 da                	adc    %ebx,%edx
c01030f9:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01030fc:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM)
c01030ff:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103102:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103105:	89 d0                	mov    %edx,%eax
c0103107:	c1 e0 02             	shl    $0x2,%eax
c010310a:	01 d0                	add    %edx,%eax
c010310c:	c1 e0 02             	shl    $0x2,%eax
c010310f:	01 c8                	add    %ecx,%eax
c0103111:	83 c0 14             	add    $0x14,%eax
c0103114:	8b 00                	mov    (%eax),%eax
c0103116:	83 f8 01             	cmp    $0x1,%eax
c0103119:	0f 85 e2 00 00 00    	jne    c0103201 <page_init+0x3ae>
        {
            if (begin < freemem)
c010311f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103122:	ba 00 00 00 00       	mov    $0x0,%edx
c0103127:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010312a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010312d:	19 d1                	sbb    %edx,%ecx
c010312f:	73 0d                	jae    c010313e <page_init+0x2eb>
            {
                begin = freemem;
c0103131:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103134:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103137:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE)
c010313e:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103143:	b8 00 00 00 00       	mov    $0x0,%eax
c0103148:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c010314b:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010314e:	73 0e                	jae    c010315e <page_init+0x30b>
            {
                end = KMEMSIZE;
c0103150:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103157:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end)
c010315e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103161:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103164:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103167:	89 d0                	mov    %edx,%eax
c0103169:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010316c:	0f 83 8f 00 00 00    	jae    c0103201 <page_init+0x3ae>
            {
                begin = ROUNDUP(begin, PGSIZE);
c0103172:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103179:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010317c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010317f:	01 d0                	add    %edx,%eax
c0103181:	48                   	dec    %eax
c0103182:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103185:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103188:	ba 00 00 00 00       	mov    $0x0,%edx
c010318d:	f7 75 b0             	divl   -0x50(%ebp)
c0103190:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103193:	29 d0                	sub    %edx,%eax
c0103195:	ba 00 00 00 00       	mov    $0x0,%edx
c010319a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010319d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01031a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01031a3:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01031a6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01031a9:	ba 00 00 00 00       	mov    $0x0,%edx
c01031ae:	89 c3                	mov    %eax,%ebx
c01031b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c01031b6:	89 de                	mov    %ebx,%esi
c01031b8:	89 d0                	mov    %edx,%eax
c01031ba:	83 e0 00             	and    $0x0,%eax
c01031bd:	89 c7                	mov    %eax,%edi
c01031bf:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01031c2:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end)
c01031c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01031c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01031cb:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01031ce:	89 d0                	mov    %edx,%eax
c01031d0:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01031d3:	73 2c                	jae    c0103201 <page_init+0x3ae>
                {
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01031d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01031d8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01031db:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01031de:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c01031e1:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01031e5:	c1 ea 0c             	shr    $0xc,%edx
c01031e8:	89 c3                	mov    %eax,%ebx
c01031ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01031ed:	89 04 24             	mov    %eax,(%esp)
c01031f0:	e8 ad f8 ff ff       	call   c0102aa2 <pa2page>
c01031f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01031f9:	89 04 24             	mov    %eax,(%esp)
c01031fc:	e8 8c fb ff ff       	call   c0102d8d <init_memmap>
    for (i = 0; i < memmap->nr_map; i++)
c0103201:	ff 45 dc             	incl   -0x24(%ebp)
c0103204:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103207:	8b 00                	mov    (%eax),%eax
c0103209:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010320c:	0f 8c a7 fe ff ff    	jl     c01030b9 <page_init+0x266>
                }
            }
        }
    }
}
c0103212:	90                   	nop
c0103213:	90                   	nop
c0103214:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010321a:	5b                   	pop    %ebx
c010321b:	5e                   	pop    %esi
c010321c:	5f                   	pop    %edi
c010321d:	5d                   	pop    %ebp
c010321e:	c3                   	ret    

c010321f <boot_map_segment>:
//   size: memory size
//   pa:   physical address of this memory
//   perm: permission of this memory
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm)
{
c010321f:	f3 0f 1e fb          	endbr32 
c0103223:	55                   	push   %ebp
c0103224:	89 e5                	mov    %esp,%ebp
c0103226:	83 ec 38             	sub    $0x38,%esp
    // 将boot_pgdir[1]的Present位给设置为0，让get_pte函数重新分配
    // boot_pgdir[1] &= ~PTE_P;
    assert(PGOFF(la) == PGOFF(pa));
c0103229:	8b 45 0c             	mov    0xc(%ebp),%eax
c010322c:	33 45 14             	xor    0x14(%ebp),%eax
c010322f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103234:	85 c0                	test   %eax,%eax
c0103236:	74 24                	je     c010325c <boot_map_segment+0x3d>
c0103238:	c7 44 24 0c 76 6a 10 	movl   $0xc0106a76,0xc(%esp)
c010323f:	c0 
c0103240:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103247:	c0 
c0103248:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c010324f:	00 
c0103250:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103257:	e8 e9 d1 ff ff       	call   c0100445 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010325c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103263:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103266:	25 ff 0f 00 00       	and    $0xfff,%eax
c010326b:	89 c2                	mov    %eax,%edx
c010326d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103270:	01 c2                	add    %eax,%edx
c0103272:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103275:	01 d0                	add    %edx,%eax
c0103277:	48                   	dec    %eax
c0103278:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010327b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010327e:	ba 00 00 00 00       	mov    $0x0,%edx
c0103283:	f7 75 f0             	divl   -0x10(%ebp)
c0103286:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103289:	29 d0                	sub    %edx,%eax
c010328b:	c1 e8 0c             	shr    $0xc,%eax
c010328e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103291:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103294:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103297:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010329a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010329f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01032a2:	8b 45 14             	mov    0x14(%ebp),%eax
c01032a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01032b0:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
c01032b3:	eb 68                	jmp    c010331d <boot_map_segment+0xfe>
    {
        pte_t *ptep = get_pte(pgdir, la, 1);
c01032b5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01032bc:	00 
c01032bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01032c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01032c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01032c7:	89 04 24             	mov    %eax,(%esp)
c01032ca:	e8 8a 01 00 00       	call   c0103459 <get_pte>
c01032cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01032d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01032d6:	75 24                	jne    c01032fc <boot_map_segment+0xdd>
c01032d8:	c7 44 24 0c a2 6a 10 	movl   $0xc0106aa2,0xc(%esp)
c01032df:	c0 
c01032e0:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c01032e7:	c0 
c01032e8:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01032ef:	00 
c01032f0:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c01032f7:	e8 49 d1 ff ff       	call   c0100445 <__panic>
        *ptep = pa | PTE_P | perm;
c01032fc:	8b 45 14             	mov    0x14(%ebp),%eax
c01032ff:	0b 45 18             	or     0x18(%ebp),%eax
c0103302:	83 c8 01             	or     $0x1,%eax
c0103305:	89 c2                	mov    %eax,%edx
c0103307:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010330a:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
c010330c:	ff 4d f4             	decl   -0xc(%ebp)
c010330f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0103316:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010331d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103321:	75 92                	jne    c01032b5 <boot_map_segment+0x96>
    }
}
c0103323:	90                   	nop
c0103324:	90                   	nop
c0103325:	c9                   	leave  
c0103326:	c3                   	ret    

c0103327 <boot_alloc_page>:
// boot_alloc_page - allocate one page using pmm->alloc_pages(1)
//  return value: the kernel virtual address of this allocated page
// note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void)
{
c0103327:	f3 0f 1e fb          	endbr32 
c010332b:	55                   	push   %ebp
c010332c:	89 e5                	mov    %esp,%ebp
c010332e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0103331:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103338:	e8 74 fa ff ff       	call   c0102db1 <alloc_pages>
c010333d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL)
c0103340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103344:	75 1c                	jne    c0103362 <boot_alloc_page+0x3b>
    {
        panic("boot_alloc_page failed.\n");
c0103346:	c7 44 24 08 af 6a 10 	movl   $0xc0106aaf,0x8(%esp)
c010334d:	c0 
c010334e:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0103355:	00 
c0103356:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c010335d:	e8 e3 d0 ff ff       	call   c0100445 <__panic>
    }
    return page2kva(p);
c0103362:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103365:	89 04 24             	mov    %eax,(%esp)
c0103368:	e8 84 f7 ff ff       	call   c0102af1 <page2kva>
}
c010336d:	c9                   	leave  
c010336e:	c3                   	ret    

c010336f <pmm_init>:

// pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism
//          - check the correctness of pmm & paging mechanism, print PDT&PT
void pmm_init(void)
{
c010336f:	f3 0f 1e fb          	endbr32 
c0103373:	55                   	push   %ebp
c0103374:	89 e5                	mov    %esp,%ebp
c0103376:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0103379:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010337e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103381:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103388:	77 23                	ja     c01033ad <pmm_init+0x3e>
c010338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010338d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103391:	c7 44 24 08 44 6a 10 	movl   $0xc0106a44,0x8(%esp)
c0103398:	c0 
c0103399:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c01033a0:	00 
c01033a1:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c01033a8:	e8 98 d0 ff ff       	call   c0100445 <__panic>
c01033ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033b0:	05 00 00 00 40       	add    $0x40000000,%eax
c01033b5:	a3 14 cf 11 c0       	mov    %eax,0xc011cf14
    // We need to alloc/free the physical memory (granularity is 4KB or other size).
    // So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    // First we should init a physical memory manager(pmm) based on the framework.
    // Then pmm can alloc/free the physical memory.
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01033ba:	e8 96 f9 ff ff       	call   c0102d55 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01033bf:	e8 8f fa ff ff       	call   c0102e53 <page_init>

    // use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01033c4:	e8 fd 03 00 00       	call   c01037c6 <check_alloc_page>

    check_pgdir();
c01033c9:	e8 1b 04 00 00       	call   c01037e9 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01033ce:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01033d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033d6:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01033dd:	77 23                	ja     c0103402 <pmm_init+0x93>
c01033df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01033e6:	c7 44 24 08 44 6a 10 	movl   $0xc0106a44,0x8(%esp)
c01033ed:	c0 
c01033ee:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c01033f5:	00 
c01033f6:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c01033fd:	e8 43 d0 ff ff       	call   c0100445 <__panic>
c0103402:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103405:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010340b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103410:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103415:	83 ca 03             	or     $0x3,%edx
c0103418:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010341a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010341f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0103426:	00 
c0103427:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010342e:	00 
c010342f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0103436:	38 
c0103437:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010343e:	c0 
c010343f:	89 04 24             	mov    %eax,(%esp)
c0103442:	e8 d8 fd ff ff       	call   c010321f <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103447:	e8 1b f8 ff ff       	call   c0102c67 <gdt_init>

    // now the basic virtual memory map(see memalyout.h) is established.
    // check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010344c:	e8 38 0a 00 00       	call   c0103e89 <check_boot_pgdir>

    print_pgdir();
c0103451:	e8 bd 0e 00 00       	call   c0104313 <print_pgdir>
}
c0103456:	90                   	nop
c0103457:	c9                   	leave  
c0103458:	c3                   	ret    

c0103459 <get_pte>:
//   la:     the linear address need to map
//   create: a logical value to decide if alloc a page for PT
//  return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
c0103459:	f3 0f 1e fb          	endbr32 
c010345d:	55                   	push   %ebp
c010345e:	89 e5                	mov    %esp,%ebp
c0103460:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

    pde_t *pdep = &pgdir[PDX(la)]; // (1) 首先找到页目录项，尝试获得页表
c0103463:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103466:	c1 e8 16             	shr    $0x16,%eax
c0103469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103470:	8b 45 08             	mov    0x8(%ebp),%eax
c0103473:	01 d0                	add    %edx,%eax
c0103475:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P))
c0103478:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010347b:	8b 00                	mov    (%eax),%eax
c010347d:	83 e0 01             	and    $0x1,%eax
c0103480:	85 c0                	test   %eax,%eax
c0103482:	0f 85 b9 00 00 00    	jne    c0103541 <get_pte+0xe8>
    { // (2) 检查这个页目录项是否存在，存在则直接返回找到的页表项，如果不存在
        if (!create)
c0103488:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010348c:	75 0a                	jne    c0103498 <get_pte+0x3f>
        { // (3) 页目录项不存在且参数不要求创建新的页表，那么返回NULL
            return NULL;
c010348e:	b8 00 00 00 00       	mov    $0x0,%eax
c0103493:	e9 06 01 00 00       	jmp    c010359e <get_pte+0x145>
        }
        struct Page *page = alloc_page(); // (3) 否则分配一个物理页存储创建的页表
c0103498:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010349f:	e8 0d f9 ff ff       	call   c0102db1 <alloc_pages>
c01034a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (page == NULL)
c01034a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01034ab:	75 0a                	jne    c01034b7 <get_pte+0x5e>
        { // (3) 如果分配失败，那么返回NULL
            return NULL;
c01034ad:	b8 00 00 00 00       	mov    $0x0,%eax
c01034b2:	e9 e7 00 00 00       	jmp    c010359e <get_pte+0x145>
        }
        set_page_ref(page, 1);              // (4) 设置物理页被引用一次
c01034b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01034be:	00 
c01034bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034c2:	89 04 24             	mov    %eax,(%esp)
c01034c5:	e8 db f6 ff ff       	call   c0102ba5 <set_page_ref>
        uintptr_t pa = page2pa(page);       // (5) 获得物理页的线性物理地址
c01034ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034cd:	89 04 24             	mov    %eax,(%esp)
c01034d0:	e8 b7 f5 ff ff       	call   c0102a8c <page2pa>
c01034d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);       // (6) 将物理地址转换成虚拟地址后，用memset函数清除页目录进行初始化
c01034d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034db:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01034de:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034e1:	c1 e8 0c             	shr    $0xc,%eax
c01034e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01034e7:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01034ec:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01034ef:	72 23                	jb     c0103514 <get_pte+0xbb>
c01034f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01034f8:	c7 44 24 08 a0 69 10 	movl   $0xc01069a0,0x8(%esp)
c01034ff:	c0 
c0103500:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
c0103507:	00 
c0103508:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c010350f:	e8 31 cf ff ff       	call   c0100445 <__panic>
c0103514:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103517:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010351c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103523:	00 
c0103524:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010352b:	00 
c010352c:	89 04 24             	mov    %eax,(%esp)
c010352f:	e8 b6 24 00 00       	call   c01059ea <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P; // (7) 设置页目录项的权限
c0103534:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103537:	83 c8 07             	or     $0x7,%eax
c010353a:	89 c2                	mov    %eax,%edx
c010353c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010353f:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; // (8) 返回虚拟地址la对应的页表项入口地址
c0103541:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103544:	8b 00                	mov    (%eax),%eax
c0103546:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010354b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010354e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103551:	c1 e8 0c             	shr    $0xc,%eax
c0103554:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103557:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c010355c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010355f:	72 23                	jb     c0103584 <get_pte+0x12b>
c0103561:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103564:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103568:	c7 44 24 08 a0 69 10 	movl   $0xc01069a0,0x8(%esp)
c010356f:	c0 
c0103570:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
c0103577:	00 
c0103578:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c010357f:	e8 c1 ce ff ff       	call   c0100445 <__panic>
c0103584:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103587:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010358c:	89 c2                	mov    %eax,%edx
c010358e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103591:	c1 e8 0c             	shr    $0xc,%eax
c0103594:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103599:	c1 e0 02             	shl    $0x2,%eax
c010359c:	01 d0                	add    %edx,%eax
    //                           // (6) clear page content using memset
    //                           // (7) set page directory entry's permission
    //     }
    //     return NULL;          // (8) return page table entry
    // #endif
}
c010359e:	c9                   	leave  
c010359f:	c3                   	ret    

c01035a0 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
c01035a0:	f3 0f 1e fb          	endbr32 
c01035a4:	55                   	push   %ebp
c01035a5:	89 e5                	mov    %esp,%ebp
c01035a7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01035aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01035b1:	00 
c01035b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01035b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01035bc:	89 04 24             	mov    %eax,(%esp)
c01035bf:	e8 95 fe ff ff       	call   c0103459 <get_pte>
c01035c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL)
c01035c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01035cb:	74 08                	je     c01035d5 <get_page+0x35>
    {
        *ptep_store = ptep;
c01035cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01035d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01035d3:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P)
c01035d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01035d9:	74 1b                	je     c01035f6 <get_page+0x56>
c01035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035de:	8b 00                	mov    (%eax),%eax
c01035e0:	83 e0 01             	and    $0x1,%eax
c01035e3:	85 c0                	test   %eax,%eax
c01035e5:	74 0f                	je     c01035f6 <get_page+0x56>
    {
        return pte2page(*ptep);
c01035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035ea:	8b 00                	mov    (%eax),%eax
c01035ec:	89 04 24             	mov    %eax,(%esp)
c01035ef:	e8 51 f5 ff ff       	call   c0102b45 <pte2page>
c01035f4:	eb 05                	jmp    c01035fb <get_page+0x5b>
    }
    return NULL;
c01035f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01035fb:	c9                   	leave  
c01035fc:	c3                   	ret    

c01035fd <page_remove_pte>:
// page_remove_pte - free an Page sturct which is related linear address la
//                 - and clean(invalidate) pte which is related linear address la
// note: PT is changed, so the TLB need to be invalidate
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep)
{
c01035fd:	55                   	push   %ebp
c01035fe:	89 e5                	mov    %esp,%ebp
c0103600:	83 ec 28             	sub    $0x28,%esp
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    // check if this page table entry is present
    // 如果传入的页表条目是可用的
    if (*ptep & PTE_P)
c0103603:	8b 45 10             	mov    0x10(%ebp),%eax
c0103606:	8b 00                	mov    (%eax),%eax
c0103608:	83 e0 01             	and    $0x1,%eax
c010360b:	85 c0                	test   %eax,%eax
c010360d:	74 4d                	je     c010365c <page_remove_pte+0x5f>
    {
        // find corresponding page to pte，获取该页表项所对应的地址
        struct Page *page = pte2page(*ptep);
c010360f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103612:	8b 00                	mov    (%eax),%eax
c0103614:	89 04 24             	mov    %eax,(%esp)
c0103617:	e8 29 f5 ff ff       	call   c0102b45 <pte2page>
c010361c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // decrease page reference，如果该页的引用次数在减1后为0
        if (page_ref_dec(page) == 0)
c010361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103622:	89 04 24             	mov    %eax,(%esp)
c0103625:	e8 a0 f5 ff ff       	call   c0102bca <page_ref_dec>
c010362a:	85 c0                	test   %eax,%eax
c010362c:	75 13                	jne    c0103641 <page_remove_pte+0x44>
            // and free this page when page reference reachs 0，释放当前页
            free_page(page);
c010362e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103635:	00 
c0103636:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103639:	89 04 24             	mov    %eax,(%esp)
c010363c:	e8 ac f7 ff ff       	call   c0102ded <free_pages>
        // clear second page table entry，清空PTE
        *ptep = 0;
c0103641:	8b 45 10             	mov    0x10(%ebp),%eax
c0103644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        // flush tlb，刷新TLB内的数据
        tlb_invalidate(pgdir, la);
c010364a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010364d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103651:	8b 45 08             	mov    0x8(%ebp),%eax
c0103654:	89 04 24             	mov    %eax,(%esp)
c0103657:	e8 09 01 00 00       	call   c0103765 <tlb_invalidate>
    //                                   //(4) and free this page when page reference reachs 0
    //                                   //(5) clear second page table entry
    //                                   //(6) flush tlb
    //     }
    // #endif
}
c010365c:	90                   	nop
c010365d:	c9                   	leave  
c010365e:	c3                   	ret    

c010365f <page_remove>:

// page_remove - free an Page which is related linear address la and has an validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
c010365f:	f3 0f 1e fb          	endbr32 
c0103663:	55                   	push   %ebp
c0103664:	89 e5                	mov    %esp,%ebp
c0103666:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103669:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103670:	00 
c0103671:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103674:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103678:	8b 45 08             	mov    0x8(%ebp),%eax
c010367b:	89 04 24             	mov    %eax,(%esp)
c010367e:	e8 d6 fd ff ff       	call   c0103459 <get_pte>
c0103683:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL)
c0103686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010368a:	74 19                	je     c01036a5 <page_remove+0x46>
    {
        page_remove_pte(pgdir, la, ptep);
c010368c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010368f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103693:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103696:	89 44 24 04          	mov    %eax,0x4(%esp)
c010369a:	8b 45 08             	mov    0x8(%ebp),%eax
c010369d:	89 04 24             	mov    %eax,(%esp)
c01036a0:	e8 58 ff ff ff       	call   c01035fd <page_remove_pte>
    }
}
c01036a5:	90                   	nop
c01036a6:	c9                   	leave  
c01036a7:	c3                   	ret    

c01036a8 <page_insert>:
//   la:    the linear address need to map
//   perm:  the permission of this Page which is setted in related pte
//  return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm)
{
c01036a8:	f3 0f 1e fb          	endbr32 
c01036ac:	55                   	push   %ebp
c01036ad:	89 e5                	mov    %esp,%ebp
c01036af:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01036b2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01036b9:	00 
c01036ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01036bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01036c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01036c4:	89 04 24             	mov    %eax,(%esp)
c01036c7:	e8 8d fd ff ff       	call   c0103459 <get_pte>
c01036cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL)
c01036cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01036d3:	75 0a                	jne    c01036df <page_insert+0x37>
    {
        return -E_NO_MEM;
c01036d5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01036da:	e9 84 00 00 00       	jmp    c0103763 <page_insert+0xbb>
    }
    page_ref_inc(page);
c01036df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036e2:	89 04 24             	mov    %eax,(%esp)
c01036e5:	e8 c9 f4 ff ff       	call   c0102bb3 <page_ref_inc>
    if (*ptep & PTE_P)
c01036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ed:	8b 00                	mov    (%eax),%eax
c01036ef:	83 e0 01             	and    $0x1,%eax
c01036f2:	85 c0                	test   %eax,%eax
c01036f4:	74 3e                	je     c0103734 <page_insert+0x8c>
    {
        struct Page *p = pte2page(*ptep);
c01036f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f9:	8b 00                	mov    (%eax),%eax
c01036fb:	89 04 24             	mov    %eax,(%esp)
c01036fe:	e8 42 f4 ff ff       	call   c0102b45 <pte2page>
c0103703:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page)
c0103706:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103709:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010370c:	75 0d                	jne    c010371b <page_insert+0x73>
        {
            page_ref_dec(page);
c010370e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103711:	89 04 24             	mov    %eax,(%esp)
c0103714:	e8 b1 f4 ff ff       	call   c0102bca <page_ref_dec>
c0103719:	eb 19                	jmp    c0103734 <page_insert+0x8c>
        }
        else
        {
            page_remove_pte(pgdir, la, ptep);
c010371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010371e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103722:	8b 45 10             	mov    0x10(%ebp),%eax
c0103725:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103729:	8b 45 08             	mov    0x8(%ebp),%eax
c010372c:	89 04 24             	mov    %eax,(%esp)
c010372f:	e8 c9 fe ff ff       	call   c01035fd <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103734:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103737:	89 04 24             	mov    %eax,(%esp)
c010373a:	e8 4d f3 ff ff       	call   c0102a8c <page2pa>
c010373f:	0b 45 14             	or     0x14(%ebp),%eax
c0103742:	83 c8 01             	or     $0x1,%eax
c0103745:	89 c2                	mov    %eax,%edx
c0103747:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010374a:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010374c:	8b 45 10             	mov    0x10(%ebp),%eax
c010374f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103753:	8b 45 08             	mov    0x8(%ebp),%eax
c0103756:	89 04 24             	mov    %eax,(%esp)
c0103759:	e8 07 00 00 00       	call   c0103765 <tlb_invalidate>
    return 0;
c010375e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103763:	c9                   	leave  
c0103764:	c3                   	ret    

c0103765 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
c0103765:	f3 0f 1e fb          	endbr32 
c0103769:	55                   	push   %ebp
c010376a:	89 e5                	mov    %esp,%ebp
c010376c:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010376f:	0f 20 d8             	mov    %cr3,%eax
c0103772:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0103775:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir))
c0103778:	8b 45 08             	mov    0x8(%ebp),%eax
c010377b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010377e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103785:	77 23                	ja     c01037aa <tlb_invalidate+0x45>
c0103787:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010378a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010378e:	c7 44 24 08 44 6a 10 	movl   $0xc0106a44,0x8(%esp)
c0103795:	c0 
c0103796:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c010379d:	00 
c010379e:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c01037a5:	e8 9b cc ff ff       	call   c0100445 <__panic>
c01037aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037ad:	05 00 00 00 40       	add    $0x40000000,%eax
c01037b2:	39 d0                	cmp    %edx,%eax
c01037b4:	75 0d                	jne    c01037c3 <tlb_invalidate+0x5e>
    {
        invlpg((void *)la);
c01037b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01037bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037bf:	0f 01 38             	invlpg (%eax)
}
c01037c2:	90                   	nop
    }
}
c01037c3:	90                   	nop
c01037c4:	c9                   	leave  
c01037c5:	c3                   	ret    

c01037c6 <check_alloc_page>:

static void
check_alloc_page(void)
{
c01037c6:	f3 0f 1e fb          	endbr32 
c01037ca:	55                   	push   %ebp
c01037cb:	89 e5                	mov    %esp,%ebp
c01037cd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01037d0:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c01037d5:	8b 40 18             	mov    0x18(%eax),%eax
c01037d8:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01037da:	c7 04 24 c8 6a 10 c0 	movl   $0xc0106ac8,(%esp)
c01037e1:	e8 f3 ca ff ff       	call   c01002d9 <cprintf>
}
c01037e6:	90                   	nop
c01037e7:	c9                   	leave  
c01037e8:	c3                   	ret    

c01037e9 <check_pgdir>:

static void
check_pgdir(void)
{
c01037e9:	f3 0f 1e fb          	endbr32 
c01037ed:	55                   	push   %ebp
c01037ee:	89 e5                	mov    %esp,%ebp
c01037f0:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01037f3:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01037f8:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01037fd:	76 24                	jbe    c0103823 <check_pgdir+0x3a>
c01037ff:	c7 44 24 0c e7 6a 10 	movl   $0xc0106ae7,0xc(%esp)
c0103806:	c0 
c0103807:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c010380e:	c0 
c010380f:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0103816:	00 
c0103817:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c010381e:	e8 22 cc ff ff       	call   c0100445 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103823:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103828:	85 c0                	test   %eax,%eax
c010382a:	74 0e                	je     c010383a <check_pgdir+0x51>
c010382c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103831:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103836:	85 c0                	test   %eax,%eax
c0103838:	74 24                	je     c010385e <check_pgdir+0x75>
c010383a:	c7 44 24 0c 04 6b 10 	movl   $0xc0106b04,0xc(%esp)
c0103841:	c0 
c0103842:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103849:	c0 
c010384a:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0103851:	00 
c0103852:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103859:	e8 e7 cb ff ff       	call   c0100445 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010385e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103863:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010386a:	00 
c010386b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103872:	00 
c0103873:	89 04 24             	mov    %eax,(%esp)
c0103876:	e8 25 fd ff ff       	call   c01035a0 <get_page>
c010387b:	85 c0                	test   %eax,%eax
c010387d:	74 24                	je     c01038a3 <check_pgdir+0xba>
c010387f:	c7 44 24 0c 3c 6b 10 	movl   $0xc0106b3c,0xc(%esp)
c0103886:	c0 
c0103887:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c010388e:	c0 
c010388f:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0103896:	00 
c0103897:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c010389e:	e8 a2 cb ff ff       	call   c0100445 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01038a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038aa:	e8 02 f5 ff ff       	call   c0102db1 <alloc_pages>
c01038af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01038b2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01038b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01038be:	00 
c01038bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01038c6:	00 
c01038c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01038ca:	89 54 24 04          	mov    %edx,0x4(%esp)
c01038ce:	89 04 24             	mov    %eax,(%esp)
c01038d1:	e8 d2 fd ff ff       	call   c01036a8 <page_insert>
c01038d6:	85 c0                	test   %eax,%eax
c01038d8:	74 24                	je     c01038fe <check_pgdir+0x115>
c01038da:	c7 44 24 0c 64 6b 10 	movl   $0xc0106b64,0xc(%esp)
c01038e1:	c0 
c01038e2:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c01038e9:	c0 
c01038ea:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c01038f1:	00 
c01038f2:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c01038f9:	e8 47 cb ff ff       	call   c0100445 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01038fe:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103903:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010390a:	00 
c010390b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103912:	00 
c0103913:	89 04 24             	mov    %eax,(%esp)
c0103916:	e8 3e fb ff ff       	call   c0103459 <get_pte>
c010391b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010391e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103922:	75 24                	jne    c0103948 <check_pgdir+0x15f>
c0103924:	c7 44 24 0c 90 6b 10 	movl   $0xc0106b90,0xc(%esp)
c010392b:	c0 
c010392c:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103933:	c0 
c0103934:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c010393b:	00 
c010393c:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103943:	e8 fd ca ff ff       	call   c0100445 <__panic>
    assert(pte2page(*ptep) == p1);
c0103948:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010394b:	8b 00                	mov    (%eax),%eax
c010394d:	89 04 24             	mov    %eax,(%esp)
c0103950:	e8 f0 f1 ff ff       	call   c0102b45 <pte2page>
c0103955:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103958:	74 24                	je     c010397e <check_pgdir+0x195>
c010395a:	c7 44 24 0c bd 6b 10 	movl   $0xc0106bbd,0xc(%esp)
c0103961:	c0 
c0103962:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103969:	c0 
c010396a:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0103971:	00 
c0103972:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103979:	e8 c7 ca ff ff       	call   c0100445 <__panic>
    assert(page_ref(p1) == 1);
c010397e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103981:	89 04 24             	mov    %eax,(%esp)
c0103984:	e8 12 f2 ff ff       	call   c0102b9b <page_ref>
c0103989:	83 f8 01             	cmp    $0x1,%eax
c010398c:	74 24                	je     c01039b2 <check_pgdir+0x1c9>
c010398e:	c7 44 24 0c d3 6b 10 	movl   $0xc0106bd3,0xc(%esp)
c0103995:	c0 
c0103996:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c010399d:	c0 
c010399e:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c01039a5:	00 
c01039a6:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c01039ad:	e8 93 ca ff ff       	call   c0100445 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01039b2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01039b7:	8b 00                	mov    (%eax),%eax
c01039b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039be:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039c4:	c1 e8 0c             	shr    $0xc,%eax
c01039c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039ca:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01039cf:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01039d2:	72 23                	jb     c01039f7 <check_pgdir+0x20e>
c01039d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01039db:	c7 44 24 08 a0 69 10 	movl   $0xc01069a0,0x8(%esp)
c01039e2:	c0 
c01039e3:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c01039ea:	00 
c01039eb:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c01039f2:	e8 4e ca ff ff       	call   c0100445 <__panic>
c01039f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039fa:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01039ff:	83 c0 04             	add    $0x4,%eax
c0103a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103a05:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103a0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a11:	00 
c0103a12:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103a19:	00 
c0103a1a:	89 04 24             	mov    %eax,(%esp)
c0103a1d:	e8 37 fa ff ff       	call   c0103459 <get_pte>
c0103a22:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a25:	74 24                	je     c0103a4b <check_pgdir+0x262>
c0103a27:	c7 44 24 0c e8 6b 10 	movl   $0xc0106be8,0xc(%esp)
c0103a2e:	c0 
c0103a2f:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103a36:	c0 
c0103a37:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0103a3e:	00 
c0103a3f:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103a46:	e8 fa c9 ff ff       	call   c0100445 <__panic>

    p2 = alloc_page();
c0103a4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a52:	e8 5a f3 ff ff       	call   c0102db1 <alloc_pages>
c0103a57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103a5a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103a5f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103a66:	00 
c0103a67:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103a6e:	00 
c0103a6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103a72:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103a76:	89 04 24             	mov    %eax,(%esp)
c0103a79:	e8 2a fc ff ff       	call   c01036a8 <page_insert>
c0103a7e:	85 c0                	test   %eax,%eax
c0103a80:	74 24                	je     c0103aa6 <check_pgdir+0x2bd>
c0103a82:	c7 44 24 0c 10 6c 10 	movl   $0xc0106c10,0xc(%esp)
c0103a89:	c0 
c0103a8a:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103a91:	c0 
c0103a92:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0103a99:	00 
c0103a9a:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103aa1:	e8 9f c9 ff ff       	call   c0100445 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103aa6:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103aab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103ab2:	00 
c0103ab3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103aba:	00 
c0103abb:	89 04 24             	mov    %eax,(%esp)
c0103abe:	e8 96 f9 ff ff       	call   c0103459 <get_pte>
c0103ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ac6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103aca:	75 24                	jne    c0103af0 <check_pgdir+0x307>
c0103acc:	c7 44 24 0c 48 6c 10 	movl   $0xc0106c48,0xc(%esp)
c0103ad3:	c0 
c0103ad4:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103adb:	c0 
c0103adc:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0103ae3:	00 
c0103ae4:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103aeb:	e8 55 c9 ff ff       	call   c0100445 <__panic>
    assert(*ptep & PTE_U);
c0103af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103af3:	8b 00                	mov    (%eax),%eax
c0103af5:	83 e0 04             	and    $0x4,%eax
c0103af8:	85 c0                	test   %eax,%eax
c0103afa:	75 24                	jne    c0103b20 <check_pgdir+0x337>
c0103afc:	c7 44 24 0c 78 6c 10 	movl   $0xc0106c78,0xc(%esp)
c0103b03:	c0 
c0103b04:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103b0b:	c0 
c0103b0c:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0103b13:	00 
c0103b14:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103b1b:	e8 25 c9 ff ff       	call   c0100445 <__panic>
    assert(*ptep & PTE_W);
c0103b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b23:	8b 00                	mov    (%eax),%eax
c0103b25:	83 e0 02             	and    $0x2,%eax
c0103b28:	85 c0                	test   %eax,%eax
c0103b2a:	75 24                	jne    c0103b50 <check_pgdir+0x367>
c0103b2c:	c7 44 24 0c 86 6c 10 	movl   $0xc0106c86,0xc(%esp)
c0103b33:	c0 
c0103b34:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103b3b:	c0 
c0103b3c:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0103b43:	00 
c0103b44:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103b4b:	e8 f5 c8 ff ff       	call   c0100445 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103b50:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b55:	8b 00                	mov    (%eax),%eax
c0103b57:	83 e0 04             	and    $0x4,%eax
c0103b5a:	85 c0                	test   %eax,%eax
c0103b5c:	75 24                	jne    c0103b82 <check_pgdir+0x399>
c0103b5e:	c7 44 24 0c 94 6c 10 	movl   $0xc0106c94,0xc(%esp)
c0103b65:	c0 
c0103b66:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103b6d:	c0 
c0103b6e:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c0103b75:	00 
c0103b76:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103b7d:	e8 c3 c8 ff ff       	call   c0100445 <__panic>
    assert(page_ref(p2) == 1);
c0103b82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b85:	89 04 24             	mov    %eax,(%esp)
c0103b88:	e8 0e f0 ff ff       	call   c0102b9b <page_ref>
c0103b8d:	83 f8 01             	cmp    $0x1,%eax
c0103b90:	74 24                	je     c0103bb6 <check_pgdir+0x3cd>
c0103b92:	c7 44 24 0c aa 6c 10 	movl   $0xc0106caa,0xc(%esp)
c0103b99:	c0 
c0103b9a:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103ba1:	c0 
c0103ba2:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c0103ba9:	00 
c0103baa:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103bb1:	e8 8f c8 ff ff       	call   c0100445 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103bb6:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103bbb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103bc2:	00 
c0103bc3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103bca:	00 
c0103bcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103bce:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103bd2:	89 04 24             	mov    %eax,(%esp)
c0103bd5:	e8 ce fa ff ff       	call   c01036a8 <page_insert>
c0103bda:	85 c0                	test   %eax,%eax
c0103bdc:	74 24                	je     c0103c02 <check_pgdir+0x419>
c0103bde:	c7 44 24 0c bc 6c 10 	movl   $0xc0106cbc,0xc(%esp)
c0103be5:	c0 
c0103be6:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103bed:	c0 
c0103bee:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0103bf5:	00 
c0103bf6:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103bfd:	e8 43 c8 ff ff       	call   c0100445 <__panic>
    assert(page_ref(p1) == 2);
c0103c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c05:	89 04 24             	mov    %eax,(%esp)
c0103c08:	e8 8e ef ff ff       	call   c0102b9b <page_ref>
c0103c0d:	83 f8 02             	cmp    $0x2,%eax
c0103c10:	74 24                	je     c0103c36 <check_pgdir+0x44d>
c0103c12:	c7 44 24 0c e8 6c 10 	movl   $0xc0106ce8,0xc(%esp)
c0103c19:	c0 
c0103c1a:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103c21:	c0 
c0103c22:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c0103c29:	00 
c0103c2a:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103c31:	e8 0f c8 ff ff       	call   c0100445 <__panic>
    assert(page_ref(p2) == 0);
c0103c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c39:	89 04 24             	mov    %eax,(%esp)
c0103c3c:	e8 5a ef ff ff       	call   c0102b9b <page_ref>
c0103c41:	85 c0                	test   %eax,%eax
c0103c43:	74 24                	je     c0103c69 <check_pgdir+0x480>
c0103c45:	c7 44 24 0c fa 6c 10 	movl   $0xc0106cfa,0xc(%esp)
c0103c4c:	c0 
c0103c4d:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103c54:	c0 
c0103c55:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c0103c5c:	00 
c0103c5d:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103c64:	e8 dc c7 ff ff       	call   c0100445 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103c69:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c6e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103c75:	00 
c0103c76:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103c7d:	00 
c0103c7e:	89 04 24             	mov    %eax,(%esp)
c0103c81:	e8 d3 f7 ff ff       	call   c0103459 <get_pte>
c0103c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c8d:	75 24                	jne    c0103cb3 <check_pgdir+0x4ca>
c0103c8f:	c7 44 24 0c 48 6c 10 	movl   $0xc0106c48,0xc(%esp)
c0103c96:	c0 
c0103c97:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103c9e:	c0 
c0103c9f:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c0103ca6:	00 
c0103ca7:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103cae:	e8 92 c7 ff ff       	call   c0100445 <__panic>
    assert(pte2page(*ptep) == p1);
c0103cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cb6:	8b 00                	mov    (%eax),%eax
c0103cb8:	89 04 24             	mov    %eax,(%esp)
c0103cbb:	e8 85 ee ff ff       	call   c0102b45 <pte2page>
c0103cc0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103cc3:	74 24                	je     c0103ce9 <check_pgdir+0x500>
c0103cc5:	c7 44 24 0c bd 6b 10 	movl   $0xc0106bbd,0xc(%esp)
c0103ccc:	c0 
c0103ccd:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103cd4:	c0 
c0103cd5:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0103cdc:	00 
c0103cdd:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103ce4:	e8 5c c7 ff ff       	call   c0100445 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cec:	8b 00                	mov    (%eax),%eax
c0103cee:	83 e0 04             	and    $0x4,%eax
c0103cf1:	85 c0                	test   %eax,%eax
c0103cf3:	74 24                	je     c0103d19 <check_pgdir+0x530>
c0103cf5:	c7 44 24 0c 0c 6d 10 	movl   $0xc0106d0c,0xc(%esp)
c0103cfc:	c0 
c0103cfd:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103d04:	c0 
c0103d05:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
c0103d0c:	00 
c0103d0d:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103d14:	e8 2c c7 ff ff       	call   c0100445 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103d19:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d1e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103d25:	00 
c0103d26:	89 04 24             	mov    %eax,(%esp)
c0103d29:	e8 31 f9 ff ff       	call   c010365f <page_remove>
    assert(page_ref(p1) == 1);
c0103d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d31:	89 04 24             	mov    %eax,(%esp)
c0103d34:	e8 62 ee ff ff       	call   c0102b9b <page_ref>
c0103d39:	83 f8 01             	cmp    $0x1,%eax
c0103d3c:	74 24                	je     c0103d62 <check_pgdir+0x579>
c0103d3e:	c7 44 24 0c d3 6b 10 	movl   $0xc0106bd3,0xc(%esp)
c0103d45:	c0 
c0103d46:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103d4d:	c0 
c0103d4e:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
c0103d55:	00 
c0103d56:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103d5d:	e8 e3 c6 ff ff       	call   c0100445 <__panic>
    assert(page_ref(p2) == 0);
c0103d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d65:	89 04 24             	mov    %eax,(%esp)
c0103d68:	e8 2e ee ff ff       	call   c0102b9b <page_ref>
c0103d6d:	85 c0                	test   %eax,%eax
c0103d6f:	74 24                	je     c0103d95 <check_pgdir+0x5ac>
c0103d71:	c7 44 24 0c fa 6c 10 	movl   $0xc0106cfa,0xc(%esp)
c0103d78:	c0 
c0103d79:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103d80:	c0 
c0103d81:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c0103d88:	00 
c0103d89:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103d90:	e8 b0 c6 ff ff       	call   c0100445 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103d95:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d9a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103da1:	00 
c0103da2:	89 04 24             	mov    %eax,(%esp)
c0103da5:	e8 b5 f8 ff ff       	call   c010365f <page_remove>
    assert(page_ref(p1) == 0);
c0103daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dad:	89 04 24             	mov    %eax,(%esp)
c0103db0:	e8 e6 ed ff ff       	call   c0102b9b <page_ref>
c0103db5:	85 c0                	test   %eax,%eax
c0103db7:	74 24                	je     c0103ddd <check_pgdir+0x5f4>
c0103db9:	c7 44 24 0c 21 6d 10 	movl   $0xc0106d21,0xc(%esp)
c0103dc0:	c0 
c0103dc1:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103dc8:	c0 
c0103dc9:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0103dd0:	00 
c0103dd1:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103dd8:	e8 68 c6 ff ff       	call   c0100445 <__panic>
    assert(page_ref(p2) == 0);
c0103ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103de0:	89 04 24             	mov    %eax,(%esp)
c0103de3:	e8 b3 ed ff ff       	call   c0102b9b <page_ref>
c0103de8:	85 c0                	test   %eax,%eax
c0103dea:	74 24                	je     c0103e10 <check_pgdir+0x627>
c0103dec:	c7 44 24 0c fa 6c 10 	movl   $0xc0106cfa,0xc(%esp)
c0103df3:	c0 
c0103df4:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103dfb:	c0 
c0103dfc:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c0103e03:	00 
c0103e04:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103e0b:	e8 35 c6 ff ff       	call   c0100445 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103e10:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e15:	8b 00                	mov    (%eax),%eax
c0103e17:	89 04 24             	mov    %eax,(%esp)
c0103e1a:	e8 64 ed ff ff       	call   c0102b83 <pde2page>
c0103e1f:	89 04 24             	mov    %eax,(%esp)
c0103e22:	e8 74 ed ff ff       	call   c0102b9b <page_ref>
c0103e27:	83 f8 01             	cmp    $0x1,%eax
c0103e2a:	74 24                	je     c0103e50 <check_pgdir+0x667>
c0103e2c:	c7 44 24 0c 34 6d 10 	movl   $0xc0106d34,0xc(%esp)
c0103e33:	c0 
c0103e34:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103e3b:	c0 
c0103e3c:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c0103e43:	00 
c0103e44:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103e4b:	e8 f5 c5 ff ff       	call   c0100445 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103e50:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e55:	8b 00                	mov    (%eax),%eax
c0103e57:	89 04 24             	mov    %eax,(%esp)
c0103e5a:	e8 24 ed ff ff       	call   c0102b83 <pde2page>
c0103e5f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103e66:	00 
c0103e67:	89 04 24             	mov    %eax,(%esp)
c0103e6a:	e8 7e ef ff ff       	call   c0102ded <free_pages>
    boot_pgdir[0] = 0;
c0103e6f:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103e7a:	c7 04 24 5b 6d 10 c0 	movl   $0xc0106d5b,(%esp)
c0103e81:	e8 53 c4 ff ff       	call   c01002d9 <cprintf>
}
c0103e86:	90                   	nop
c0103e87:	c9                   	leave  
c0103e88:	c3                   	ret    

c0103e89 <check_boot_pgdir>:

static void
check_boot_pgdir(void)
{
c0103e89:	f3 0f 1e fb          	endbr32 
c0103e8d:	55                   	push   %ebp
c0103e8e:	89 e5                	mov    %esp,%ebp
c0103e90:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE)
c0103e93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103e9a:	e9 ca 00 00 00       	jmp    c0103f69 <check_boot_pgdir+0xe0>
    {
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ea2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ea5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ea8:	c1 e8 0c             	shr    $0xc,%eax
c0103eab:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103eae:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103eb3:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103eb6:	72 23                	jb     c0103edb <check_boot_pgdir+0x52>
c0103eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ebb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ebf:	c7 44 24 08 a0 69 10 	movl   $0xc01069a0,0x8(%esp)
c0103ec6:	c0 
c0103ec7:	c7 44 24 04 64 02 00 	movl   $0x264,0x4(%esp)
c0103ece:	00 
c0103ecf:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103ed6:	e8 6a c5 ff ff       	call   c0100445 <__panic>
c0103edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ede:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103ee3:	89 c2                	mov    %eax,%edx
c0103ee5:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103eea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103ef1:	00 
c0103ef2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ef6:	89 04 24             	mov    %eax,(%esp)
c0103ef9:	e8 5b f5 ff ff       	call   c0103459 <get_pte>
c0103efe:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103f01:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103f05:	75 24                	jne    c0103f2b <check_boot_pgdir+0xa2>
c0103f07:	c7 44 24 0c 78 6d 10 	movl   $0xc0106d78,0xc(%esp)
c0103f0e:	c0 
c0103f0f:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103f16:	c0 
c0103f17:	c7 44 24 04 64 02 00 	movl   $0x264,0x4(%esp)
c0103f1e:	00 
c0103f1f:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103f26:	e8 1a c5 ff ff       	call   c0100445 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103f2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103f2e:	8b 00                	mov    (%eax),%eax
c0103f30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103f35:	89 c2                	mov    %eax,%edx
c0103f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f3a:	39 c2                	cmp    %eax,%edx
c0103f3c:	74 24                	je     c0103f62 <check_boot_pgdir+0xd9>
c0103f3e:	c7 44 24 0c b5 6d 10 	movl   $0xc0106db5,0xc(%esp)
c0103f45:	c0 
c0103f46:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103f4d:	c0 
c0103f4e:	c7 44 24 04 65 02 00 	movl   $0x265,0x4(%esp)
c0103f55:	00 
c0103f56:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103f5d:	e8 e3 c4 ff ff       	call   c0100445 <__panic>
    for (i = 0; i < npage; i += PGSIZE)
c0103f62:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f6c:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103f71:	39 c2                	cmp    %eax,%edx
c0103f73:	0f 82 26 ff ff ff    	jb     c0103e9f <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103f79:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103f7e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103f83:	8b 00                	mov    (%eax),%eax
c0103f85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103f8a:	89 c2                	mov    %eax,%edx
c0103f8c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f94:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103f9b:	77 23                	ja     c0103fc0 <check_boot_pgdir+0x137>
c0103f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fa0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103fa4:	c7 44 24 08 44 6a 10 	movl   $0xc0106a44,0x8(%esp)
c0103fab:	c0 
c0103fac:	c7 44 24 04 68 02 00 	movl   $0x268,0x4(%esp)
c0103fb3:	00 
c0103fb4:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103fbb:	e8 85 c4 ff ff       	call   c0100445 <__panic>
c0103fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fc3:	05 00 00 00 40       	add    $0x40000000,%eax
c0103fc8:	39 d0                	cmp    %edx,%eax
c0103fca:	74 24                	je     c0103ff0 <check_boot_pgdir+0x167>
c0103fcc:	c7 44 24 0c cc 6d 10 	movl   $0xc0106dcc,0xc(%esp)
c0103fd3:	c0 
c0103fd4:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0103fdb:	c0 
c0103fdc:	c7 44 24 04 68 02 00 	movl   $0x268,0x4(%esp)
c0103fe3:	00 
c0103fe4:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0103feb:	e8 55 c4 ff ff       	call   c0100445 <__panic>

    assert(boot_pgdir[0] == 0);
c0103ff0:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103ff5:	8b 00                	mov    (%eax),%eax
c0103ff7:	85 c0                	test   %eax,%eax
c0103ff9:	74 24                	je     c010401f <check_boot_pgdir+0x196>
c0103ffb:	c7 44 24 0c 00 6e 10 	movl   $0xc0106e00,0xc(%esp)
c0104002:	c0 
c0104003:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c010400a:	c0 
c010400b:	c7 44 24 04 6a 02 00 	movl   $0x26a,0x4(%esp)
c0104012:	00 
c0104013:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c010401a:	e8 26 c4 ff ff       	call   c0100445 <__panic>

    struct Page *p;
    p = alloc_page();
c010401f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104026:	e8 86 ed ff ff       	call   c0102db1 <alloc_pages>
c010402b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010402e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104033:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010403a:	00 
c010403b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104042:	00 
c0104043:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104046:	89 54 24 04          	mov    %edx,0x4(%esp)
c010404a:	89 04 24             	mov    %eax,(%esp)
c010404d:	e8 56 f6 ff ff       	call   c01036a8 <page_insert>
c0104052:	85 c0                	test   %eax,%eax
c0104054:	74 24                	je     c010407a <check_boot_pgdir+0x1f1>
c0104056:	c7 44 24 0c 14 6e 10 	movl   $0xc0106e14,0xc(%esp)
c010405d:	c0 
c010405e:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0104065:	c0 
c0104066:	c7 44 24 04 6e 02 00 	movl   $0x26e,0x4(%esp)
c010406d:	00 
c010406e:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0104075:	e8 cb c3 ff ff       	call   c0100445 <__panic>
    assert(page_ref(p) == 1);
c010407a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010407d:	89 04 24             	mov    %eax,(%esp)
c0104080:	e8 16 eb ff ff       	call   c0102b9b <page_ref>
c0104085:	83 f8 01             	cmp    $0x1,%eax
c0104088:	74 24                	je     c01040ae <check_boot_pgdir+0x225>
c010408a:	c7 44 24 0c 42 6e 10 	movl   $0xc0106e42,0xc(%esp)
c0104091:	c0 
c0104092:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0104099:	c0 
c010409a:	c7 44 24 04 6f 02 00 	movl   $0x26f,0x4(%esp)
c01040a1:	00 
c01040a2:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c01040a9:	e8 97 c3 ff ff       	call   c0100445 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01040ae:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01040b3:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01040ba:	00 
c01040bb:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01040c2:	00 
c01040c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01040c6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01040ca:	89 04 24             	mov    %eax,(%esp)
c01040cd:	e8 d6 f5 ff ff       	call   c01036a8 <page_insert>
c01040d2:	85 c0                	test   %eax,%eax
c01040d4:	74 24                	je     c01040fa <check_boot_pgdir+0x271>
c01040d6:	c7 44 24 0c 54 6e 10 	movl   $0xc0106e54,0xc(%esp)
c01040dd:	c0 
c01040de:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c01040e5:	c0 
c01040e6:	c7 44 24 04 70 02 00 	movl   $0x270,0x4(%esp)
c01040ed:	00 
c01040ee:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c01040f5:	e8 4b c3 ff ff       	call   c0100445 <__panic>
    assert(page_ref(p) == 2);
c01040fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040fd:	89 04 24             	mov    %eax,(%esp)
c0104100:	e8 96 ea ff ff       	call   c0102b9b <page_ref>
c0104105:	83 f8 02             	cmp    $0x2,%eax
c0104108:	74 24                	je     c010412e <check_boot_pgdir+0x2a5>
c010410a:	c7 44 24 0c 8b 6e 10 	movl   $0xc0106e8b,0xc(%esp)
c0104111:	c0 
c0104112:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c0104119:	c0 
c010411a:	c7 44 24 04 71 02 00 	movl   $0x271,0x4(%esp)
c0104121:	00 
c0104122:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c0104129:	e8 17 c3 ff ff       	call   c0100445 <__panic>

    const char *str = "ucore: Hello world!!";
c010412e:	c7 45 e8 9c 6e 10 c0 	movl   $0xc0106e9c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0104135:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104138:	89 44 24 04          	mov    %eax,0x4(%esp)
c010413c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104143:	e8 be 15 00 00       	call   c0105706 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104148:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010414f:	00 
c0104150:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104157:	e8 28 16 00 00       	call   c0105784 <strcmp>
c010415c:	85 c0                	test   %eax,%eax
c010415e:	74 24                	je     c0104184 <check_boot_pgdir+0x2fb>
c0104160:	c7 44 24 0c b4 6e 10 	movl   $0xc0106eb4,0xc(%esp)
c0104167:	c0 
c0104168:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c010416f:	c0 
c0104170:	c7 44 24 04 75 02 00 	movl   $0x275,0x4(%esp)
c0104177:	00 
c0104178:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c010417f:	e8 c1 c2 ff ff       	call   c0100445 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104184:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104187:	89 04 24             	mov    %eax,(%esp)
c010418a:	e8 62 e9 ff ff       	call   c0102af1 <page2kva>
c010418f:	05 00 01 00 00       	add    $0x100,%eax
c0104194:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104197:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010419e:	e8 05 15 00 00       	call   c01056a8 <strlen>
c01041a3:	85 c0                	test   %eax,%eax
c01041a5:	74 24                	je     c01041cb <check_boot_pgdir+0x342>
c01041a7:	c7 44 24 0c ec 6e 10 	movl   $0xc0106eec,0xc(%esp)
c01041ae:	c0 
c01041af:	c7 44 24 08 8d 6a 10 	movl   $0xc0106a8d,0x8(%esp)
c01041b6:	c0 
c01041b7:	c7 44 24 04 78 02 00 	movl   $0x278,0x4(%esp)
c01041be:	00 
c01041bf:	c7 04 24 68 6a 10 c0 	movl   $0xc0106a68,(%esp)
c01041c6:	e8 7a c2 ff ff       	call   c0100445 <__panic>

    free_page(p);
c01041cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041d2:	00 
c01041d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041d6:	89 04 24             	mov    %eax,(%esp)
c01041d9:	e8 0f ec ff ff       	call   c0102ded <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c01041de:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01041e3:	8b 00                	mov    (%eax),%eax
c01041e5:	89 04 24             	mov    %eax,(%esp)
c01041e8:	e8 96 e9 ff ff       	call   c0102b83 <pde2page>
c01041ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041f4:	00 
c01041f5:	89 04 24             	mov    %eax,(%esp)
c01041f8:	e8 f0 eb ff ff       	call   c0102ded <free_pages>
    boot_pgdir[0] = 0;
c01041fd:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104202:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104208:	c7 04 24 10 6f 10 c0 	movl   $0xc0106f10,(%esp)
c010420f:	e8 c5 c0 ff ff       	call   c01002d9 <cprintf>
}
c0104214:	90                   	nop
c0104215:	c9                   	leave  
c0104216:	c3                   	ret    

c0104217 <perm2str>:

// perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm)
{
c0104217:	f3 0f 1e fb          	endbr32 
c010421b:	55                   	push   %ebp
c010421c:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010421e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104221:	83 e0 04             	and    $0x4,%eax
c0104224:	85 c0                	test   %eax,%eax
c0104226:	74 04                	je     c010422c <perm2str+0x15>
c0104228:	b0 75                	mov    $0x75,%al
c010422a:	eb 02                	jmp    c010422e <perm2str+0x17>
c010422c:	b0 2d                	mov    $0x2d,%al
c010422e:	a2 08 cf 11 c0       	mov    %al,0xc011cf08
    str[1] = 'r';
c0104233:	c6 05 09 cf 11 c0 72 	movb   $0x72,0xc011cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010423a:	8b 45 08             	mov    0x8(%ebp),%eax
c010423d:	83 e0 02             	and    $0x2,%eax
c0104240:	85 c0                	test   %eax,%eax
c0104242:	74 04                	je     c0104248 <perm2str+0x31>
c0104244:	b0 77                	mov    $0x77,%al
c0104246:	eb 02                	jmp    c010424a <perm2str+0x33>
c0104248:	b0 2d                	mov    $0x2d,%al
c010424a:	a2 0a cf 11 c0       	mov    %al,0xc011cf0a
    str[3] = '\0';
c010424f:	c6 05 0b cf 11 c0 00 	movb   $0x0,0xc011cf0b
    return str;
c0104256:	b8 08 cf 11 c0       	mov    $0xc011cf08,%eax
}
c010425b:	5d                   	pop    %ebp
c010425c:	c3                   	ret    

c010425d <get_pgtable_items>:
//   left_store:  the pointer of the high side of table's next range
//   right_store: the pointer of the low side of table's next range
//  return value: 0 - not a invalid item range, perm - a valid item range with perm permission
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store)
{
c010425d:	f3 0f 1e fb          	endbr32 
c0104261:	55                   	push   %ebp
c0104262:	89 e5                	mov    %esp,%ebp
c0104264:	83 ec 10             	sub    $0x10,%esp
    if (start >= right)
c0104267:	8b 45 10             	mov    0x10(%ebp),%eax
c010426a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010426d:	72 0d                	jb     c010427c <get_pgtable_items+0x1f>
    {
        return 0;
c010426f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104274:	e9 98 00 00 00       	jmp    c0104311 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P))
    {
        start++;
c0104279:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P))
c010427c:	8b 45 10             	mov    0x10(%ebp),%eax
c010427f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104282:	73 18                	jae    c010429c <get_pgtable_items+0x3f>
c0104284:	8b 45 10             	mov    0x10(%ebp),%eax
c0104287:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010428e:	8b 45 14             	mov    0x14(%ebp),%eax
c0104291:	01 d0                	add    %edx,%eax
c0104293:	8b 00                	mov    (%eax),%eax
c0104295:	83 e0 01             	and    $0x1,%eax
c0104298:	85 c0                	test   %eax,%eax
c010429a:	74 dd                	je     c0104279 <get_pgtable_items+0x1c>
    }
    if (start < right)
c010429c:	8b 45 10             	mov    0x10(%ebp),%eax
c010429f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01042a2:	73 68                	jae    c010430c <get_pgtable_items+0xaf>
    {
        if (left_store != NULL)
c01042a4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01042a8:	74 08                	je     c01042b2 <get_pgtable_items+0x55>
        {
            *left_store = start;
c01042aa:	8b 45 18             	mov    0x18(%ebp),%eax
c01042ad:	8b 55 10             	mov    0x10(%ebp),%edx
c01042b0:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
c01042b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01042b5:	8d 50 01             	lea    0x1(%eax),%edx
c01042b8:	89 55 10             	mov    %edx,0x10(%ebp)
c01042bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01042c2:	8b 45 14             	mov    0x14(%ebp),%eax
c01042c5:	01 d0                	add    %edx,%eax
c01042c7:	8b 00                	mov    (%eax),%eax
c01042c9:	83 e0 07             	and    $0x7,%eax
c01042cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
c01042cf:	eb 03                	jmp    c01042d4 <get_pgtable_items+0x77>
        {
            start++;
c01042d1:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
c01042d4:	8b 45 10             	mov    0x10(%ebp),%eax
c01042d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01042da:	73 1d                	jae    c01042f9 <get_pgtable_items+0x9c>
c01042dc:	8b 45 10             	mov    0x10(%ebp),%eax
c01042df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01042e6:	8b 45 14             	mov    0x14(%ebp),%eax
c01042e9:	01 d0                	add    %edx,%eax
c01042eb:	8b 00                	mov    (%eax),%eax
c01042ed:	83 e0 07             	and    $0x7,%eax
c01042f0:	89 c2                	mov    %eax,%edx
c01042f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01042f5:	39 c2                	cmp    %eax,%edx
c01042f7:	74 d8                	je     c01042d1 <get_pgtable_items+0x74>
        }
        if (right_store != NULL)
c01042f9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01042fd:	74 08                	je     c0104307 <get_pgtable_items+0xaa>
        {
            *right_store = start;
c01042ff:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104302:	8b 55 10             	mov    0x10(%ebp),%edx
c0104305:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104307:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010430a:	eb 05                	jmp    c0104311 <get_pgtable_items+0xb4>
    }
    return 0;
c010430c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104311:	c9                   	leave  
c0104312:	c3                   	ret    

c0104313 <print_pgdir>:

// print_pgdir - print the PDT&PT
void print_pgdir(void)
{
c0104313:	f3 0f 1e fb          	endbr32 
c0104317:	55                   	push   %ebp
c0104318:	89 e5                	mov    %esp,%ebp
c010431a:	57                   	push   %edi
c010431b:	56                   	push   %esi
c010431c:	53                   	push   %ebx
c010431d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104320:	c7 04 24 30 6f 10 c0 	movl   $0xc0106f30,(%esp)
c0104327:	e8 ad bf ff ff       	call   c01002d9 <cprintf>
    size_t left, right = 0, perm;
c010432c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
c0104333:	e9 fa 00 00 00       	jmp    c0104432 <print_pgdir+0x11f>
    {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010433b:	89 04 24             	mov    %eax,(%esp)
c010433e:	e8 d4 fe ff ff       	call   c0104217 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104343:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104346:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104349:	29 d1                	sub    %edx,%ecx
c010434b:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010434d:	89 d6                	mov    %edx,%esi
c010434f:	c1 e6 16             	shl    $0x16,%esi
c0104352:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104355:	89 d3                	mov    %edx,%ebx
c0104357:	c1 e3 16             	shl    $0x16,%ebx
c010435a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010435d:	89 d1                	mov    %edx,%ecx
c010435f:	c1 e1 16             	shl    $0x16,%ecx
c0104362:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104365:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104368:	29 d7                	sub    %edx,%edi
c010436a:	89 fa                	mov    %edi,%edx
c010436c:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104370:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104374:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104378:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010437c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104380:	c7 04 24 61 6f 10 c0 	movl   $0xc0106f61,(%esp)
c0104387:	e8 4d bf ff ff       	call   c01002d9 <cprintf>
        size_t l, r = left * NPTEENTRY;
c010438c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010438f:	c1 e0 0a             	shl    $0xa,%eax
c0104392:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
c0104395:	eb 54                	jmp    c01043eb <print_pgdir+0xd8>
        {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104397:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010439a:	89 04 24             	mov    %eax,(%esp)
c010439d:	e8 75 fe ff ff       	call   c0104217 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01043a2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01043a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01043a8:	29 d1                	sub    %edx,%ecx
c01043aa:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01043ac:	89 d6                	mov    %edx,%esi
c01043ae:	c1 e6 0c             	shl    $0xc,%esi
c01043b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01043b4:	89 d3                	mov    %edx,%ebx
c01043b6:	c1 e3 0c             	shl    $0xc,%ebx
c01043b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01043bc:	89 d1                	mov    %edx,%ecx
c01043be:	c1 e1 0c             	shl    $0xc,%ecx
c01043c1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01043c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01043c7:	29 d7                	sub    %edx,%edi
c01043c9:	89 fa                	mov    %edi,%edx
c01043cb:	89 44 24 14          	mov    %eax,0x14(%esp)
c01043cf:	89 74 24 10          	mov    %esi,0x10(%esp)
c01043d3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01043d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01043db:	89 54 24 04          	mov    %edx,0x4(%esp)
c01043df:	c7 04 24 80 6f 10 c0 	movl   $0xc0106f80,(%esp)
c01043e6:	e8 ee be ff ff       	call   c01002d9 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
c01043eb:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01043f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01043f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01043f6:	89 d3                	mov    %edx,%ebx
c01043f8:	c1 e3 0a             	shl    $0xa,%ebx
c01043fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01043fe:	89 d1                	mov    %edx,%ecx
c0104400:	c1 e1 0a             	shl    $0xa,%ecx
c0104403:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104406:	89 54 24 14          	mov    %edx,0x14(%esp)
c010440a:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010440d:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104411:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0104415:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104419:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010441d:	89 0c 24             	mov    %ecx,(%esp)
c0104420:	e8 38 fe ff ff       	call   c010425d <get_pgtable_items>
c0104425:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104428:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010442c:	0f 85 65 ff ff ff    	jne    c0104397 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
c0104432:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104437:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010443a:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010443d:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104441:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104444:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104448:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010444c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104450:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0104457:	00 
c0104458:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010445f:	e8 f9 fd ff ff       	call   c010425d <get_pgtable_items>
c0104464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104467:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010446b:	0f 85 c7 fe ff ff    	jne    c0104338 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104471:	c7 04 24 a4 6f 10 c0 	movl   $0xc0106fa4,(%esp)
c0104478:	e8 5c be ff ff       	call   c01002d9 <cprintf>
}
c010447d:	90                   	nop
c010447e:	83 c4 4c             	add    $0x4c,%esp
c0104481:	5b                   	pop    %ebx
c0104482:	5e                   	pop    %esi
c0104483:	5f                   	pop    %edi
c0104484:	5d                   	pop    %ebp
c0104485:	c3                   	ret    

c0104486 <page2ppn>:
page2ppn(struct Page *page) {
c0104486:	55                   	push   %ebp
c0104487:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104489:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c010448e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104491:	29 c2                	sub    %eax,%edx
c0104493:	89 d0                	mov    %edx,%eax
c0104495:	c1 f8 02             	sar    $0x2,%eax
c0104498:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010449e:	5d                   	pop    %ebp
c010449f:	c3                   	ret    

c01044a0 <page2pa>:
page2pa(struct Page *page) {
c01044a0:	55                   	push   %ebp
c01044a1:	89 e5                	mov    %esp,%ebp
c01044a3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01044a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a9:	89 04 24             	mov    %eax,(%esp)
c01044ac:	e8 d5 ff ff ff       	call   c0104486 <page2ppn>
c01044b1:	c1 e0 0c             	shl    $0xc,%eax
}
c01044b4:	c9                   	leave  
c01044b5:	c3                   	ret    

c01044b6 <page_ref>:
page_ref(struct Page *page) {
c01044b6:	55                   	push   %ebp
c01044b7:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01044b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01044bc:	8b 00                	mov    (%eax),%eax
}
c01044be:	5d                   	pop    %ebp
c01044bf:	c3                   	ret    

c01044c0 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01044c0:	55                   	push   %ebp
c01044c1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01044c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01044c6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044c9:	89 10                	mov    %edx,(%eax)
}
c01044cb:	90                   	nop
c01044cc:	5d                   	pop    %ebp
c01044cd:	c3                   	ret    

c01044ce <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void)
{
c01044ce:	f3 0f 1e fb          	endbr32 
c01044d2:	55                   	push   %ebp
c01044d3:	89 e5                	mov    %esp,%ebp
c01044d5:	83 ec 10             	sub    $0x10,%esp
c01044d8:	c7 45 fc 1c cf 11 c0 	movl   $0xc011cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01044df:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01044e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01044e5:	89 50 04             	mov    %edx,0x4(%eax)
c01044e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01044eb:	8b 50 04             	mov    0x4(%eax),%edx
c01044ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01044f1:	89 10                	mov    %edx,(%eax)
}
c01044f3:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c01044f4:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c01044fb:	00 00 00 
}
c01044fe:	90                   	nop
c01044ff:	c9                   	leave  
c0104500:	c3                   	ret    

c0104501 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n)
{
c0104501:	f3 0f 1e fb          	endbr32 
c0104505:	55                   	push   %ebp
c0104506:	89 e5                	mov    %esp,%ebp
c0104508:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010450b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010450f:	75 24                	jne    c0104535 <default_init_memmap+0x34>
c0104511:	c7 44 24 0c d8 6f 10 	movl   $0xc0106fd8,0xc(%esp)
c0104518:	c0 
c0104519:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104520:	c0 
c0104521:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0104528:	00 
c0104529:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104530:	e8 10 bf ff ff       	call   c0100445 <__panic>
    struct Page *p = base;
c0104535:	8b 45 08             	mov    0x8(%ebp),%eax
c0104538:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c010453b:	eb 7d                	jmp    c01045ba <default_init_memmap+0xb9>
    {
        assert(PageReserved(p));
c010453d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104540:	83 c0 04             	add    $0x4,%eax
c0104543:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010454a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010454d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104550:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104553:	0f a3 10             	bt     %edx,(%eax)
c0104556:	19 c0                	sbb    %eax,%eax
c0104558:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010455b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010455f:	0f 95 c0             	setne  %al
c0104562:	0f b6 c0             	movzbl %al,%eax
c0104565:	85 c0                	test   %eax,%eax
c0104567:	75 24                	jne    c010458d <default_init_memmap+0x8c>
c0104569:	c7 44 24 0c 09 70 10 	movl   $0xc0107009,0xc(%esp)
c0104570:	c0 
c0104571:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104578:	c0 
c0104579:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
c0104580:	00 
c0104581:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104588:	e8 b8 be ff ff       	call   c0100445 <__panic>
        p->flags = p->property = 0;
c010458d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104590:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104597:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010459a:	8b 50 08             	mov    0x8(%eax),%edx
c010459d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a0:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01045a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01045aa:	00 
c01045ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ae:	89 04 24             	mov    %eax,(%esp)
c01045b1:	e8 0a ff ff ff       	call   c01044c0 <set_page_ref>
    for (; p != base + n; p++)
c01045b6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01045ba:	8b 55 0c             	mov    0xc(%ebp),%edx
c01045bd:	89 d0                	mov    %edx,%eax
c01045bf:	c1 e0 02             	shl    $0x2,%eax
c01045c2:	01 d0                	add    %edx,%eax
c01045c4:	c1 e0 02             	shl    $0x2,%eax
c01045c7:	89 c2                	mov    %eax,%edx
c01045c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01045cc:	01 d0                	add    %edx,%eax
c01045ce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01045d1:	0f 85 66 ff ff ff    	jne    c010453d <default_init_memmap+0x3c>
    }
    base->property = n;
c01045d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01045da:	8b 55 0c             	mov    0xc(%ebp),%edx
c01045dd:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01045e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e3:	83 c0 04             	add    $0x4,%eax
c01045e6:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c01045ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01045f0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01045f3:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01045f6:	0f ab 10             	bts    %edx,(%eax)
}
c01045f9:	90                   	nop
    nr_free += n;
c01045fa:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c0104600:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104603:	01 d0                	add    %edx,%eax
c0104605:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
    //注意这里新页面插入时应该插入进末尾
    // list_add(&free_list, &(base->page_link));  原版错误，插在了Free之后的第一个位置
    // 修改方法：
    list_add(free_list.prev, &(base->page_link));
c010460a:	8b 45 08             	mov    0x8(%ebp),%eax
c010460d:	8d 50 0c             	lea    0xc(%eax),%edx
c0104610:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104615:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104618:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010461b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010461e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104621:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104624:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104627:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010462a:	8b 40 04             	mov    0x4(%eax),%eax
c010462d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104630:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104633:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104636:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104639:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010463c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010463f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104642:	89 10                	mov    %edx,(%eax)
c0104644:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104647:	8b 10                	mov    (%eax),%edx
c0104649:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010464c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010464f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104652:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104655:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104658:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010465b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010465e:	89 10                	mov    %edx,(%eax)
}
c0104660:	90                   	nop
}
c0104661:	90                   	nop
}
c0104662:	90                   	nop
    // list_add_before(&free_list, &(base->page_link));
}
c0104663:	90                   	nop
c0104664:	c9                   	leave  
c0104665:	c3                   	ret    

c0104666 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
c0104666:	f3 0f 1e fb          	endbr32 
c010466a:	55                   	push   %ebp
c010466b:	89 e5                	mov    %esp,%ebp
c010466d:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0104670:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104674:	75 24                	jne    c010469a <default_alloc_pages+0x34>
c0104676:	c7 44 24 0c d8 6f 10 	movl   $0xc0106fd8,0xc(%esp)
c010467d:	c0 
c010467e:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104685:	c0 
c0104686:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
c010468d:	00 
c010468e:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104695:	e8 ab bd ff ff       	call   c0100445 <__panic>
    if (n > nr_free)
c010469a:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c010469f:	39 45 08             	cmp    %eax,0x8(%ebp)
c01046a2:	76 0a                	jbe    c01046ae <default_alloc_pages+0x48>
    {
        return NULL;
c01046a4:	b8 00 00 00 00       	mov    $0x0,%eax
c01046a9:	e9 43 01 00 00       	jmp    c01047f1 <default_alloc_pages+0x18b>
    }
    struct Page *page = NULL;
c01046ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01046b5:	c7 45 f0 1c cf 11 c0 	movl   $0xc011cf1c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
c01046bc:	eb 1c                	jmp    c01046da <default_alloc_pages+0x74>
    {
        struct Page *p = le2page(le, page_link);
c01046be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046c1:	83 e8 0c             	sub    $0xc,%eax
c01046c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
c01046c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046ca:	8b 40 08             	mov    0x8(%eax),%eax
c01046cd:	39 45 08             	cmp    %eax,0x8(%ebp)
c01046d0:	77 08                	ja     c01046da <default_alloc_pages+0x74>
        {
            page = p;
c01046d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01046d8:	eb 18                	jmp    c01046f2 <default_alloc_pages+0x8c>
c01046da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c01046e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046e3:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c01046e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01046e9:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c01046f0:	75 cc                	jne    c01046be <default_alloc_pages+0x58>
        }
    }
    if (page != NULL)
c01046f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046f6:	0f 84 f2 00 00 00    	je     c01047ee <default_alloc_pages+0x188>
    {
        // list_del(&(page->page_link));
        if (page->property > n)
c01046fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ff:	8b 40 08             	mov    0x8(%eax),%eax
c0104702:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104705:	0f 83 8f 00 00 00    	jae    c010479a <default_alloc_pages+0x134>
        {
            struct Page *p = page + n;
c010470b:	8b 55 08             	mov    0x8(%ebp),%edx
c010470e:	89 d0                	mov    %edx,%eax
c0104710:	c1 e0 02             	shl    $0x2,%eax
c0104713:	01 d0                	add    %edx,%eax
c0104715:	c1 e0 02             	shl    $0x2,%eax
c0104718:	89 c2                	mov    %eax,%edx
c010471a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010471d:	01 d0                	add    %edx,%eax
c010471f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0104722:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104725:	8b 40 08             	mov    0x8(%eax),%eax
c0104728:	2b 45 08             	sub    0x8(%ebp),%eax
c010472b:	89 c2                	mov    %eax,%edx
c010472d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104730:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0104733:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104736:	83 c0 04             	add    $0x4,%eax
c0104739:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0104740:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104743:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104746:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104749:	0f ab 10             	bts    %edx,(%eax)
}
c010474c:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
c010474d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104750:	83 c0 0c             	add    $0xc,%eax
c0104753:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104756:	83 c2 0c             	add    $0xc,%edx
c0104759:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010475c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c010475f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104762:	8b 40 04             	mov    0x4(%eax),%eax
c0104765:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104768:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010476b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010476e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104771:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c0104774:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104777:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010477a:	89 10                	mov    %edx,(%eax)
c010477c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010477f:	8b 10                	mov    (%eax),%edx
c0104781:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104784:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104787:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010478a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010478d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104790:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104793:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104796:	89 10                	mov    %edx,(%eax)
}
c0104798:	90                   	nop
}
c0104799:	90                   	nop
        }
        list_del(&(page->page_link));
c010479a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010479d:	83 c0 0c             	add    $0xc,%eax
c01047a0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c01047a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01047a6:	8b 40 04             	mov    0x4(%eax),%eax
c01047a9:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01047ac:	8b 12                	mov    (%edx),%edx
c01047ae:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01047b1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01047b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01047b7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01047ba:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01047bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01047c0:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01047c3:	89 10                	mov    %edx,(%eax)
}
c01047c5:	90                   	nop
}
c01047c6:	90                   	nop
        nr_free -= n;
c01047c7:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c01047cc:	2b 45 08             	sub    0x8(%ebp),%eax
c01047cf:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
        ClearPageProperty(page);
c01047d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047d7:	83 c0 04             	add    $0x4,%eax
c01047da:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01047e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01047e4:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01047e7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01047ea:	0f b3 10             	btr    %edx,(%eax)
}
c01047ed:	90                   	nop
    }
    return page;
c01047ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01047f1:	c9                   	leave  
c01047f2:	c3                   	ret    

c01047f3 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
c01047f3:	f3 0f 1e fb          	endbr32 
c01047f7:	55                   	push   %ebp
c01047f8:	89 e5                	mov    %esp,%ebp
c01047fa:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0104800:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104804:	75 24                	jne    c010482a <default_free_pages+0x37>
c0104806:	c7 44 24 0c d8 6f 10 	movl   $0xc0106fd8,0xc(%esp)
c010480d:	c0 
c010480e:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104815:	c0 
c0104816:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c010481d:	00 
c010481e:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104825:	e8 1b bc ff ff       	call   c0100445 <__panic>
    struct Page *p = base;
c010482a:	8b 45 08             	mov    0x8(%ebp),%eax
c010482d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
c0104830:	e9 9d 00 00 00       	jmp    c01048d2 <default_free_pages+0xdf>
    {
        assert(!PageReserved(p) && !PageProperty(p));
c0104835:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104838:	83 c0 04             	add    $0x4,%eax
c010483b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104848:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010484b:	0f a3 10             	bt     %edx,(%eax)
c010484e:	19 c0                	sbb    %eax,%eax
c0104850:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0104853:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104857:	0f 95 c0             	setne  %al
c010485a:	0f b6 c0             	movzbl %al,%eax
c010485d:	85 c0                	test   %eax,%eax
c010485f:	75 2c                	jne    c010488d <default_free_pages+0x9a>
c0104861:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104864:	83 c0 04             	add    $0x4,%eax
c0104867:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c010486e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104871:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104874:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104877:	0f a3 10             	bt     %edx,(%eax)
c010487a:	19 c0                	sbb    %eax,%eax
c010487c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c010487f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104883:	0f 95 c0             	setne  %al
c0104886:	0f b6 c0             	movzbl %al,%eax
c0104889:	85 c0                	test   %eax,%eax
c010488b:	74 24                	je     c01048b1 <default_free_pages+0xbe>
c010488d:	c7 44 24 0c 1c 70 10 	movl   $0xc010701c,0xc(%esp)
c0104894:	c0 
c0104895:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c010489c:	c0 
c010489d:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c01048a4:	00 
c01048a5:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c01048ac:	e8 94 bb ff ff       	call   c0100445 <__panic>
        p->flags = 0;
c01048b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01048bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048c2:	00 
c01048c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048c6:	89 04 24             	mov    %eax,(%esp)
c01048c9:	e8 f2 fb ff ff       	call   c01044c0 <set_page_ref>
    for (; p != base + n; p++)
c01048ce:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01048d2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01048d5:	89 d0                	mov    %edx,%eax
c01048d7:	c1 e0 02             	shl    $0x2,%eax
c01048da:	01 d0                	add    %edx,%eax
c01048dc:	c1 e0 02             	shl    $0x2,%eax
c01048df:	89 c2                	mov    %eax,%edx
c01048e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01048e4:	01 d0                	add    %edx,%eax
c01048e6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01048e9:	0f 85 46 ff ff ff    	jne    c0104835 <default_free_pages+0x42>
    }
    base->property = n;
c01048ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01048f2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01048f5:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01048f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01048fb:	83 c0 04             	add    $0x4,%eax
c01048fe:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0104905:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104908:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010490b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010490e:	0f ab 10             	bts    %edx,(%eax)
}
c0104911:	90                   	nop
c0104912:	c7 45 d0 1c cf 11 c0 	movl   $0xc011cf1c,-0x30(%ebp)
    return listelm->next;
c0104919:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010491c:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c010491f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *pos = free_list.prev;
c0104922:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104927:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while (le != &free_list)
c010492a:	e9 20 01 00 00       	jmp    c0104a4f <default_free_pages+0x25c>
    {
        p = le2page(le, page_link);
c010492f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104932:	83 e8 0c             	sub    $0xc,%eax
c0104935:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // le = list_next(le);
        if (base + base->property == p)
c0104938:	8b 45 08             	mov    0x8(%ebp),%eax
c010493b:	8b 50 08             	mov    0x8(%eax),%edx
c010493e:	89 d0                	mov    %edx,%eax
c0104940:	c1 e0 02             	shl    $0x2,%eax
c0104943:	01 d0                	add    %edx,%eax
c0104945:	c1 e0 02             	shl    $0x2,%eax
c0104948:	89 c2                	mov    %eax,%edx
c010494a:	8b 45 08             	mov    0x8(%ebp),%eax
c010494d:	01 d0                	add    %edx,%eax
c010494f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104952:	75 67                	jne    c01049bb <default_free_pages+0x1c8>
        {
            base->property += p->property;
c0104954:	8b 45 08             	mov    0x8(%ebp),%eax
c0104957:	8b 50 08             	mov    0x8(%eax),%edx
c010495a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010495d:	8b 40 08             	mov    0x8(%eax),%eax
c0104960:	01 c2                	add    %eax,%edx
c0104962:	8b 45 08             	mov    0x8(%ebp),%eax
c0104965:	89 50 08             	mov    %edx,0x8(%eax)
            pos = le->prev;
c0104968:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010496b:	8b 00                	mov    (%eax),%eax
c010496d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            ClearPageProperty(p);
c0104970:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104973:	83 c0 04             	add    $0x4,%eax
c0104976:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c010497d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104980:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104983:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104986:	0f b3 10             	btr    %edx,(%eax)
}
c0104989:	90                   	nop
            list_del(&(p->page_link));
c010498a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010498d:	83 c0 0c             	add    $0xc,%eax
c0104990:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104993:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104996:	8b 40 04             	mov    0x4(%eax),%eax
c0104999:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010499c:	8b 12                	mov    (%edx),%edx
c010499e:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01049a1:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c01049a4:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01049a7:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01049aa:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01049ad:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01049b0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01049b3:	89 10                	mov    %edx,(%eax)
}
c01049b5:	90                   	nop
}
c01049b6:	e9 85 00 00 00       	jmp    c0104a40 <default_free_pages+0x24d>
        }
        else if (p + p->property == base)
c01049bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049be:	8b 50 08             	mov    0x8(%eax),%edx
c01049c1:	89 d0                	mov    %edx,%eax
c01049c3:	c1 e0 02             	shl    $0x2,%eax
c01049c6:	01 d0                	add    %edx,%eax
c01049c8:	c1 e0 02             	shl    $0x2,%eax
c01049cb:	89 c2                	mov    %eax,%edx
c01049cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d0:	01 d0                	add    %edx,%eax
c01049d2:	39 45 08             	cmp    %eax,0x8(%ebp)
c01049d5:	75 69                	jne    c0104a40 <default_free_pages+0x24d>
        {
            p->property += base->property;
c01049d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049da:	8b 50 08             	mov    0x8(%eax),%edx
c01049dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01049e0:	8b 40 08             	mov    0x8(%eax),%eax
c01049e3:	01 c2                	add    %eax,%edx
c01049e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049e8:	89 50 08             	mov    %edx,0x8(%eax)
            pos = le->prev;
c01049eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049ee:	8b 00                	mov    (%eax),%eax
c01049f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
            ClearPageProperty(base);
c01049f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01049f6:	83 c0 04             	add    $0x4,%eax
c01049f9:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0104a00:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104a03:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104a06:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104a09:	0f b3 10             	btr    %edx,(%eax)
}
c0104a0c:	90                   	nop
            base = p;
c0104a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a10:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0104a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a16:	83 c0 0c             	add    $0xc,%eax
c0104a19:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104a1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104a1f:	8b 40 04             	mov    0x4(%eax),%eax
c0104a22:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104a25:	8b 12                	mov    (%edx),%edx
c0104a27:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104a2a:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104a2d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104a30:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104a33:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104a36:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104a39:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104a3c:	89 10                	mov    %edx,(%eax)
}
c0104a3e:	90                   	nop
}
c0104a3f:	90                   	nop
c0104a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a43:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
c0104a46:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104a49:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c0104a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list)
c0104a4f:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c0104a56:	0f 85 d3 fe ff ff    	jne    c010492f <default_free_pages+0x13c>
    }
    nr_free += n;
c0104a5c:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c0104a62:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a65:	01 d0                	add    %edx,%eax
c0104a67:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
    // list_add_before(le, &(base->page_link));
    // list_add(le->prev, &(base->page_link));
    list_add(pos, &(base->page_link));
c0104a6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a6f:	8d 50 0c             	lea    0xc(%eax),%edx
c0104a72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a75:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104a78:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0104a7b:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104a7e:	89 45 90             	mov    %eax,-0x70(%ebp)
c0104a81:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104a84:	89 45 8c             	mov    %eax,-0x74(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104a87:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104a8a:	8b 40 04             	mov    0x4(%eax),%eax
c0104a8d:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104a90:	89 55 88             	mov    %edx,-0x78(%ebp)
c0104a93:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104a96:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104a99:	89 45 80             	mov    %eax,-0x80(%ebp)
    prev->next = next->prev = elm;
c0104a9c:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104a9f:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104aa2:	89 10                	mov    %edx,(%eax)
c0104aa4:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104aa7:	8b 10                	mov    (%eax),%edx
c0104aa9:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104aac:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104aaf:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104ab2:	8b 55 80             	mov    -0x80(%ebp),%edx
c0104ab5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104ab8:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104abb:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104abe:	89 10                	mov    %edx,(%eax)
}
c0104ac0:	90                   	nop
}
c0104ac1:	90                   	nop
}
c0104ac2:	90                   	nop
}
c0104ac3:	90                   	nop
c0104ac4:	c9                   	leave  
c0104ac5:	c3                   	ret    

c0104ac6 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
c0104ac6:	f3 0f 1e fb          	endbr32 
c0104aca:	55                   	push   %ebp
c0104acb:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104acd:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
}
c0104ad2:	5d                   	pop    %ebp
c0104ad3:	c3                   	ret    

c0104ad4 <basic_check>:

static void
basic_check(void)
{
c0104ad4:	f3 0f 1e fb          	endbr32 
c0104ad8:	55                   	push   %ebp
c0104ad9:	89 e5                	mov    %esp,%ebp
c0104adb:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104ade:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104af1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104af8:	e8 b4 e2 ff ff       	call   c0102db1 <alloc_pages>
c0104afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104b04:	75 24                	jne    c0104b2a <basic_check+0x56>
c0104b06:	c7 44 24 0c 41 70 10 	movl   $0xc0107041,0xc(%esp)
c0104b0d:	c0 
c0104b0e:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104b15:	c0 
c0104b16:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0104b1d:	00 
c0104b1e:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104b25:	e8 1b b9 ff ff       	call   c0100445 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104b2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b31:	e8 7b e2 ff ff       	call   c0102db1 <alloc_pages>
c0104b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b3d:	75 24                	jne    c0104b63 <basic_check+0x8f>
c0104b3f:	c7 44 24 0c 5d 70 10 	movl   $0xc010705d,0xc(%esp)
c0104b46:	c0 
c0104b47:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104b4e:	c0 
c0104b4f:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104b56:	00 
c0104b57:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104b5e:	e8 e2 b8 ff ff       	call   c0100445 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104b63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b6a:	e8 42 e2 ff ff       	call   c0102db1 <alloc_pages>
c0104b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104b76:	75 24                	jne    c0104b9c <basic_check+0xc8>
c0104b78:	c7 44 24 0c 79 70 10 	movl   $0xc0107079,0xc(%esp)
c0104b7f:	c0 
c0104b80:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104b87:	c0 
c0104b88:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104b8f:	00 
c0104b90:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104b97:	e8 a9 b8 ff ff       	call   c0100445 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b9f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104ba2:	74 10                	je     c0104bb4 <basic_check+0xe0>
c0104ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ba7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104baa:	74 08                	je     c0104bb4 <basic_check+0xe0>
c0104bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104baf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104bb2:	75 24                	jne    c0104bd8 <basic_check+0x104>
c0104bb4:	c7 44 24 0c 98 70 10 	movl   $0xc0107098,0xc(%esp)
c0104bbb:	c0 
c0104bbc:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104bc3:	c0 
c0104bc4:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0104bcb:	00 
c0104bcc:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104bd3:	e8 6d b8 ff ff       	call   c0100445 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bdb:	89 04 24             	mov    %eax,(%esp)
c0104bde:	e8 d3 f8 ff ff       	call   c01044b6 <page_ref>
c0104be3:	85 c0                	test   %eax,%eax
c0104be5:	75 1e                	jne    c0104c05 <basic_check+0x131>
c0104be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bea:	89 04 24             	mov    %eax,(%esp)
c0104bed:	e8 c4 f8 ff ff       	call   c01044b6 <page_ref>
c0104bf2:	85 c0                	test   %eax,%eax
c0104bf4:	75 0f                	jne    c0104c05 <basic_check+0x131>
c0104bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bf9:	89 04 24             	mov    %eax,(%esp)
c0104bfc:	e8 b5 f8 ff ff       	call   c01044b6 <page_ref>
c0104c01:	85 c0                	test   %eax,%eax
c0104c03:	74 24                	je     c0104c29 <basic_check+0x155>
c0104c05:	c7 44 24 0c bc 70 10 	movl   $0xc01070bc,0xc(%esp)
c0104c0c:	c0 
c0104c0d:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104c14:	c0 
c0104c15:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0104c1c:	00 
c0104c1d:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104c24:	e8 1c b8 ff ff       	call   c0100445 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c2c:	89 04 24             	mov    %eax,(%esp)
c0104c2f:	e8 6c f8 ff ff       	call   c01044a0 <page2pa>
c0104c34:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0104c3a:	c1 e2 0c             	shl    $0xc,%edx
c0104c3d:	39 d0                	cmp    %edx,%eax
c0104c3f:	72 24                	jb     c0104c65 <basic_check+0x191>
c0104c41:	c7 44 24 0c f8 70 10 	movl   $0xc01070f8,0xc(%esp)
c0104c48:	c0 
c0104c49:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104c50:	c0 
c0104c51:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0104c58:	00 
c0104c59:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104c60:	e8 e0 b7 ff ff       	call   c0100445 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c68:	89 04 24             	mov    %eax,(%esp)
c0104c6b:	e8 30 f8 ff ff       	call   c01044a0 <page2pa>
c0104c70:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0104c76:	c1 e2 0c             	shl    $0xc,%edx
c0104c79:	39 d0                	cmp    %edx,%eax
c0104c7b:	72 24                	jb     c0104ca1 <basic_check+0x1cd>
c0104c7d:	c7 44 24 0c 15 71 10 	movl   $0xc0107115,0xc(%esp)
c0104c84:	c0 
c0104c85:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104c8c:	c0 
c0104c8d:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104c94:	00 
c0104c95:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104c9c:	e8 a4 b7 ff ff       	call   c0100445 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ca4:	89 04 24             	mov    %eax,(%esp)
c0104ca7:	e8 f4 f7 ff ff       	call   c01044a0 <page2pa>
c0104cac:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0104cb2:	c1 e2 0c             	shl    $0xc,%edx
c0104cb5:	39 d0                	cmp    %edx,%eax
c0104cb7:	72 24                	jb     c0104cdd <basic_check+0x209>
c0104cb9:	c7 44 24 0c 32 71 10 	movl   $0xc0107132,0xc(%esp)
c0104cc0:	c0 
c0104cc1:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104cc8:	c0 
c0104cc9:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0104cd0:	00 
c0104cd1:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104cd8:	e8 68 b7 ff ff       	call   c0100445 <__panic>

    list_entry_t free_list_store = free_list;
c0104cdd:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104ce2:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c0104ce8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104ceb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104cee:	c7 45 dc 1c cf 11 c0 	movl   $0xc011cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104cf5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104cf8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104cfb:	89 50 04             	mov    %edx,0x4(%eax)
c0104cfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d01:	8b 50 04             	mov    0x4(%eax),%edx
c0104d04:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d07:	89 10                	mov    %edx,(%eax)
}
c0104d09:	90                   	nop
c0104d0a:	c7 45 e0 1c cf 11 c0 	movl   $0xc011cf1c,-0x20(%ebp)
    return list->next == list;
c0104d11:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d14:	8b 40 04             	mov    0x4(%eax),%eax
c0104d17:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104d1a:	0f 94 c0             	sete   %al
c0104d1d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104d20:	85 c0                	test   %eax,%eax
c0104d22:	75 24                	jne    c0104d48 <basic_check+0x274>
c0104d24:	c7 44 24 0c 4f 71 10 	movl   $0xc010714f,0xc(%esp)
c0104d2b:	c0 
c0104d2c:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104d33:	c0 
c0104d34:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0104d3b:	00 
c0104d3c:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104d43:	e8 fd b6 ff ff       	call   c0100445 <__panic>

    unsigned int nr_free_store = nr_free;
c0104d48:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104d4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104d50:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c0104d57:	00 00 00 

    assert(alloc_page() == NULL);
c0104d5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d61:	e8 4b e0 ff ff       	call   c0102db1 <alloc_pages>
c0104d66:	85 c0                	test   %eax,%eax
c0104d68:	74 24                	je     c0104d8e <basic_check+0x2ba>
c0104d6a:	c7 44 24 0c 66 71 10 	movl   $0xc0107166,0xc(%esp)
c0104d71:	c0 
c0104d72:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104d79:	c0 
c0104d7a:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0104d81:	00 
c0104d82:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104d89:	e8 b7 b6 ff ff       	call   c0100445 <__panic>

    free_page(p0);
c0104d8e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d95:	00 
c0104d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d99:	89 04 24             	mov    %eax,(%esp)
c0104d9c:	e8 4c e0 ff ff       	call   c0102ded <free_pages>
    free_page(p1);
c0104da1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104da8:	00 
c0104da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dac:	89 04 24             	mov    %eax,(%esp)
c0104daf:	e8 39 e0 ff ff       	call   c0102ded <free_pages>
    free_page(p2);
c0104db4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104dbb:	00 
c0104dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dbf:	89 04 24             	mov    %eax,(%esp)
c0104dc2:	e8 26 e0 ff ff       	call   c0102ded <free_pages>
    assert(nr_free == 3);
c0104dc7:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104dcc:	83 f8 03             	cmp    $0x3,%eax
c0104dcf:	74 24                	je     c0104df5 <basic_check+0x321>
c0104dd1:	c7 44 24 0c 7b 71 10 	movl   $0xc010717b,0xc(%esp)
c0104dd8:	c0 
c0104dd9:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104de0:	c0 
c0104de1:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0104de8:	00 
c0104de9:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104df0:	e8 50 b6 ff ff       	call   c0100445 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104df5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104dfc:	e8 b0 df ff ff       	call   c0102db1 <alloc_pages>
c0104e01:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104e08:	75 24                	jne    c0104e2e <basic_check+0x35a>
c0104e0a:	c7 44 24 0c 41 70 10 	movl   $0xc0107041,0xc(%esp)
c0104e11:	c0 
c0104e12:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104e19:	c0 
c0104e1a:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0104e21:	00 
c0104e22:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104e29:	e8 17 b6 ff ff       	call   c0100445 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104e2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e35:	e8 77 df ff ff       	call   c0102db1 <alloc_pages>
c0104e3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e41:	75 24                	jne    c0104e67 <basic_check+0x393>
c0104e43:	c7 44 24 0c 5d 70 10 	movl   $0xc010705d,0xc(%esp)
c0104e4a:	c0 
c0104e4b:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104e52:	c0 
c0104e53:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0104e5a:	00 
c0104e5b:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104e62:	e8 de b5 ff ff       	call   c0100445 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e6e:	e8 3e df ff ff       	call   c0102db1 <alloc_pages>
c0104e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e7a:	75 24                	jne    c0104ea0 <basic_check+0x3cc>
c0104e7c:	c7 44 24 0c 79 70 10 	movl   $0xc0107079,0xc(%esp)
c0104e83:	c0 
c0104e84:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104e8b:	c0 
c0104e8c:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0104e93:	00 
c0104e94:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104e9b:	e8 a5 b5 ff ff       	call   c0100445 <__panic>

    assert(alloc_page() == NULL);
c0104ea0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ea7:	e8 05 df ff ff       	call   c0102db1 <alloc_pages>
c0104eac:	85 c0                	test   %eax,%eax
c0104eae:	74 24                	je     c0104ed4 <basic_check+0x400>
c0104eb0:	c7 44 24 0c 66 71 10 	movl   $0xc0107166,0xc(%esp)
c0104eb7:	c0 
c0104eb8:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104ebf:	c0 
c0104ec0:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c0104ec7:	00 
c0104ec8:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104ecf:	e8 71 b5 ff ff       	call   c0100445 <__panic>

    free_page(p0);
c0104ed4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104edb:	00 
c0104edc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104edf:	89 04 24             	mov    %eax,(%esp)
c0104ee2:	e8 06 df ff ff       	call   c0102ded <free_pages>
c0104ee7:	c7 45 d8 1c cf 11 c0 	movl   $0xc011cf1c,-0x28(%ebp)
c0104eee:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104ef1:	8b 40 04             	mov    0x4(%eax),%eax
c0104ef4:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104ef7:	0f 94 c0             	sete   %al
c0104efa:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104efd:	85 c0                	test   %eax,%eax
c0104eff:	74 24                	je     c0104f25 <basic_check+0x451>
c0104f01:	c7 44 24 0c 88 71 10 	movl   $0xc0107188,0xc(%esp)
c0104f08:	c0 
c0104f09:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104f10:	c0 
c0104f11:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104f18:	00 
c0104f19:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104f20:	e8 20 b5 ff ff       	call   c0100445 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104f25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f2c:	e8 80 de ff ff       	call   c0102db1 <alloc_pages>
c0104f31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f37:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104f3a:	74 24                	je     c0104f60 <basic_check+0x48c>
c0104f3c:	c7 44 24 0c a0 71 10 	movl   $0xc01071a0,0xc(%esp)
c0104f43:	c0 
c0104f44:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104f4b:	c0 
c0104f4c:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0104f53:	00 
c0104f54:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104f5b:	e8 e5 b4 ff ff       	call   c0100445 <__panic>
    assert(alloc_page() == NULL);
c0104f60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f67:	e8 45 de ff ff       	call   c0102db1 <alloc_pages>
c0104f6c:	85 c0                	test   %eax,%eax
c0104f6e:	74 24                	je     c0104f94 <basic_check+0x4c0>
c0104f70:	c7 44 24 0c 66 71 10 	movl   $0xc0107166,0xc(%esp)
c0104f77:	c0 
c0104f78:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104f7f:	c0 
c0104f80:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0104f87:	00 
c0104f88:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104f8f:	e8 b1 b4 ff ff       	call   c0100445 <__panic>

    assert(nr_free == 0);
c0104f94:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104f99:	85 c0                	test   %eax,%eax
c0104f9b:	74 24                	je     c0104fc1 <basic_check+0x4ed>
c0104f9d:	c7 44 24 0c b9 71 10 	movl   $0xc01071b9,0xc(%esp)
c0104fa4:	c0 
c0104fa5:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0104fac:	c0 
c0104fad:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104fb4:	00 
c0104fb5:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104fbc:	e8 84 b4 ff ff       	call   c0100445 <__panic>
    free_list = free_list_store;
c0104fc1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104fc4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104fc7:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c0104fcc:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    nr_free = nr_free_store;
c0104fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fd5:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_page(p);
c0104fda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fe1:	00 
c0104fe2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fe5:	89 04 24             	mov    %eax,(%esp)
c0104fe8:	e8 00 de ff ff       	call   c0102ded <free_pages>
    free_page(p1);
c0104fed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ff4:	00 
c0104ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ff8:	89 04 24             	mov    %eax,(%esp)
c0104ffb:	e8 ed dd ff ff       	call   c0102ded <free_pages>
    free_page(p2);
c0105000:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105007:	00 
c0105008:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010500b:	89 04 24             	mov    %eax,(%esp)
c010500e:	e8 da dd ff ff       	call   c0102ded <free_pages>
}
c0105013:	90                   	nop
c0105014:	c9                   	leave  
c0105015:	c3                   	ret    

c0105016 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
c0105016:	f3 0f 1e fb          	endbr32 
c010501a:	55                   	push   %ebp
c010501b:	89 e5                	mov    %esp,%ebp
c010501d:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0105023:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010502a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0105031:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c0105038:	eb 6a                	jmp    c01050a4 <default_check+0x8e>
    {
        struct Page *p = le2page(le, page_link);
c010503a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010503d:	83 e8 0c             	sub    $0xc,%eax
c0105040:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0105043:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105046:	83 c0 04             	add    $0x4,%eax
c0105049:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105050:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105053:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105056:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105059:	0f a3 10             	bt     %edx,(%eax)
c010505c:	19 c0                	sbb    %eax,%eax
c010505e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0105061:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0105065:	0f 95 c0             	setne  %al
c0105068:	0f b6 c0             	movzbl %al,%eax
c010506b:	85 c0                	test   %eax,%eax
c010506d:	75 24                	jne    c0105093 <default_check+0x7d>
c010506f:	c7 44 24 0c c6 71 10 	movl   $0xc01071c6,0xc(%esp)
c0105076:	c0 
c0105077:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c010507e:	c0 
c010507f:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0105086:	00 
c0105087:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c010508e:	e8 b2 b3 ff ff       	call   c0100445 <__panic>
        count++, total += p->property;
c0105093:	ff 45 f4             	incl   -0xc(%ebp)
c0105096:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105099:	8b 50 08             	mov    0x8(%eax),%edx
c010509c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010509f:	01 d0                	add    %edx,%eax
c01050a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01050aa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01050ad:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c01050b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01050b3:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c01050ba:	0f 85 7a ff ff ff    	jne    c010503a <default_check+0x24>
    }
    assert(total == nr_free_pages());
c01050c0:	e8 5f dd ff ff       	call   c0102e24 <nr_free_pages>
c01050c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01050c8:	39 d0                	cmp    %edx,%eax
c01050ca:	74 24                	je     c01050f0 <default_check+0xda>
c01050cc:	c7 44 24 0c d6 71 10 	movl   $0xc01071d6,0xc(%esp)
c01050d3:	c0 
c01050d4:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c01050db:	c0 
c01050dc:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01050e3:	00 
c01050e4:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c01050eb:	e8 55 b3 ff ff       	call   c0100445 <__panic>

    basic_check();
c01050f0:	e8 df f9 ff ff       	call   c0104ad4 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01050f5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01050fc:	e8 b0 dc ff ff       	call   c0102db1 <alloc_pages>
c0105101:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0105104:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105108:	75 24                	jne    c010512e <default_check+0x118>
c010510a:	c7 44 24 0c ef 71 10 	movl   $0xc01071ef,0xc(%esp)
c0105111:	c0 
c0105112:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105119:	c0 
c010511a:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0105121:	00 
c0105122:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105129:	e8 17 b3 ff ff       	call   c0100445 <__panic>
    assert(!PageProperty(p0));
c010512e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105131:	83 c0 04             	add    $0x4,%eax
c0105134:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010513b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010513e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105141:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105144:	0f a3 10             	bt     %edx,(%eax)
c0105147:	19 c0                	sbb    %eax,%eax
c0105149:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010514c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0105150:	0f 95 c0             	setne  %al
c0105153:	0f b6 c0             	movzbl %al,%eax
c0105156:	85 c0                	test   %eax,%eax
c0105158:	74 24                	je     c010517e <default_check+0x168>
c010515a:	c7 44 24 0c fa 71 10 	movl   $0xc01071fa,0xc(%esp)
c0105161:	c0 
c0105162:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105169:	c0 
c010516a:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0105171:	00 
c0105172:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105179:	e8 c7 b2 ff ff       	call   c0100445 <__panic>

    list_entry_t free_list_store = free_list;
c010517e:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0105183:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c0105189:	89 45 80             	mov    %eax,-0x80(%ebp)
c010518c:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010518f:	c7 45 b0 1c cf 11 c0 	movl   $0xc011cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0105196:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105199:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010519c:	89 50 04             	mov    %edx,0x4(%eax)
c010519f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01051a2:	8b 50 04             	mov    0x4(%eax),%edx
c01051a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01051a8:	89 10                	mov    %edx,(%eax)
}
c01051aa:	90                   	nop
c01051ab:	c7 45 b4 1c cf 11 c0 	movl   $0xc011cf1c,-0x4c(%ebp)
    return list->next == list;
c01051b2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01051b5:	8b 40 04             	mov    0x4(%eax),%eax
c01051b8:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c01051bb:	0f 94 c0             	sete   %al
c01051be:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01051c1:	85 c0                	test   %eax,%eax
c01051c3:	75 24                	jne    c01051e9 <default_check+0x1d3>
c01051c5:	c7 44 24 0c 4f 71 10 	movl   $0xc010714f,0xc(%esp)
c01051cc:	c0 
c01051cd:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c01051d4:	c0 
c01051d5:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c01051dc:	00 
c01051dd:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c01051e4:	e8 5c b2 ff ff       	call   c0100445 <__panic>
    assert(alloc_page() == NULL);
c01051e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051f0:	e8 bc db ff ff       	call   c0102db1 <alloc_pages>
c01051f5:	85 c0                	test   %eax,%eax
c01051f7:	74 24                	je     c010521d <default_check+0x207>
c01051f9:	c7 44 24 0c 66 71 10 	movl   $0xc0107166,0xc(%esp)
c0105200:	c0 
c0105201:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105208:	c0 
c0105209:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0105210:	00 
c0105211:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105218:	e8 28 b2 ff ff       	call   c0100445 <__panic>

    unsigned int nr_free_store = nr_free;
c010521d:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0105222:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0105225:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c010522c:	00 00 00 

    free_pages(p0 + 2, 3);
c010522f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105232:	83 c0 28             	add    $0x28,%eax
c0105235:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010523c:	00 
c010523d:	89 04 24             	mov    %eax,(%esp)
c0105240:	e8 a8 db ff ff       	call   c0102ded <free_pages>
    assert(alloc_pages(4) == NULL);
c0105245:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010524c:	e8 60 db ff ff       	call   c0102db1 <alloc_pages>
c0105251:	85 c0                	test   %eax,%eax
c0105253:	74 24                	je     c0105279 <default_check+0x263>
c0105255:	c7 44 24 0c 0c 72 10 	movl   $0xc010720c,0xc(%esp)
c010525c:	c0 
c010525d:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105264:	c0 
c0105265:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c010526c:	00 
c010526d:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105274:	e8 cc b1 ff ff       	call   c0100445 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0105279:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010527c:	83 c0 28             	add    $0x28,%eax
c010527f:	83 c0 04             	add    $0x4,%eax
c0105282:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0105289:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010528c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010528f:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0105292:	0f a3 10             	bt     %edx,(%eax)
c0105295:	19 c0                	sbb    %eax,%eax
c0105297:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010529a:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010529e:	0f 95 c0             	setne  %al
c01052a1:	0f b6 c0             	movzbl %al,%eax
c01052a4:	85 c0                	test   %eax,%eax
c01052a6:	74 0e                	je     c01052b6 <default_check+0x2a0>
c01052a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052ab:	83 c0 28             	add    $0x28,%eax
c01052ae:	8b 40 08             	mov    0x8(%eax),%eax
c01052b1:	83 f8 03             	cmp    $0x3,%eax
c01052b4:	74 24                	je     c01052da <default_check+0x2c4>
c01052b6:	c7 44 24 0c 24 72 10 	movl   $0xc0107224,0xc(%esp)
c01052bd:	c0 
c01052be:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c01052c5:	c0 
c01052c6:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c01052cd:	00 
c01052ce:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c01052d5:	e8 6b b1 ff ff       	call   c0100445 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01052da:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01052e1:	e8 cb da ff ff       	call   c0102db1 <alloc_pages>
c01052e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01052ed:	75 24                	jne    c0105313 <default_check+0x2fd>
c01052ef:	c7 44 24 0c 50 72 10 	movl   $0xc0107250,0xc(%esp)
c01052f6:	c0 
c01052f7:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c01052fe:	c0 
c01052ff:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c0105306:	00 
c0105307:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c010530e:	e8 32 b1 ff ff       	call   c0100445 <__panic>
    assert(alloc_page() == NULL);
c0105313:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010531a:	e8 92 da ff ff       	call   c0102db1 <alloc_pages>
c010531f:	85 c0                	test   %eax,%eax
c0105321:	74 24                	je     c0105347 <default_check+0x331>
c0105323:	c7 44 24 0c 66 71 10 	movl   $0xc0107166,0xc(%esp)
c010532a:	c0 
c010532b:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105332:	c0 
c0105333:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c010533a:	00 
c010533b:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105342:	e8 fe b0 ff ff       	call   c0100445 <__panic>
    assert(p0 + 2 == p1);
c0105347:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010534a:	83 c0 28             	add    $0x28,%eax
c010534d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105350:	74 24                	je     c0105376 <default_check+0x360>
c0105352:	c7 44 24 0c 6e 72 10 	movl   $0xc010726e,0xc(%esp)
c0105359:	c0 
c010535a:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105361:	c0 
c0105362:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c0105369:	00 
c010536a:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105371:	e8 cf b0 ff ff       	call   c0100445 <__panic>

    p2 = p0 + 1;
c0105376:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105379:	83 c0 14             	add    $0x14,%eax
c010537c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c010537f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105386:	00 
c0105387:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010538a:	89 04 24             	mov    %eax,(%esp)
c010538d:	e8 5b da ff ff       	call   c0102ded <free_pages>
    free_pages(p1, 3);
c0105392:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105399:	00 
c010539a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010539d:	89 04 24             	mov    %eax,(%esp)
c01053a0:	e8 48 da ff ff       	call   c0102ded <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01053a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053a8:	83 c0 04             	add    $0x4,%eax
c01053ab:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01053b2:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01053b5:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01053b8:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01053bb:	0f a3 10             	bt     %edx,(%eax)
c01053be:	19 c0                	sbb    %eax,%eax
c01053c0:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01053c3:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01053c7:	0f 95 c0             	setne  %al
c01053ca:	0f b6 c0             	movzbl %al,%eax
c01053cd:	85 c0                	test   %eax,%eax
c01053cf:	74 0b                	je     c01053dc <default_check+0x3c6>
c01053d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053d4:	8b 40 08             	mov    0x8(%eax),%eax
c01053d7:	83 f8 01             	cmp    $0x1,%eax
c01053da:	74 24                	je     c0105400 <default_check+0x3ea>
c01053dc:	c7 44 24 0c 7c 72 10 	movl   $0xc010727c,0xc(%esp)
c01053e3:	c0 
c01053e4:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c01053eb:	c0 
c01053ec:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01053f3:	00 
c01053f4:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c01053fb:	e8 45 b0 ff ff       	call   c0100445 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0105400:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105403:	83 c0 04             	add    $0x4,%eax
c0105406:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010540d:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105410:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105413:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105416:	0f a3 10             	bt     %edx,(%eax)
c0105419:	19 c0                	sbb    %eax,%eax
c010541b:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010541e:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0105422:	0f 95 c0             	setne  %al
c0105425:	0f b6 c0             	movzbl %al,%eax
c0105428:	85 c0                	test   %eax,%eax
c010542a:	74 0b                	je     c0105437 <default_check+0x421>
c010542c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010542f:	8b 40 08             	mov    0x8(%eax),%eax
c0105432:	83 f8 03             	cmp    $0x3,%eax
c0105435:	74 24                	je     c010545b <default_check+0x445>
c0105437:	c7 44 24 0c a4 72 10 	movl   $0xc01072a4,0xc(%esp)
c010543e:	c0 
c010543f:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105446:	c0 
c0105447:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c010544e:	00 
c010544f:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105456:	e8 ea af ff ff       	call   c0100445 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010545b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105462:	e8 4a d9 ff ff       	call   c0102db1 <alloc_pages>
c0105467:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010546a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010546d:	83 e8 14             	sub    $0x14,%eax
c0105470:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105473:	74 24                	je     c0105499 <default_check+0x483>
c0105475:	c7 44 24 0c ca 72 10 	movl   $0xc01072ca,0xc(%esp)
c010547c:	c0 
c010547d:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105484:	c0 
c0105485:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c010548c:	00 
c010548d:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105494:	e8 ac af ff ff       	call   c0100445 <__panic>
    free_page(p0);
c0105499:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01054a0:	00 
c01054a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054a4:	89 04 24             	mov    %eax,(%esp)
c01054a7:	e8 41 d9 ff ff       	call   c0102ded <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01054ac:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01054b3:	e8 f9 d8 ff ff       	call   c0102db1 <alloc_pages>
c01054b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054be:	83 c0 14             	add    $0x14,%eax
c01054c1:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01054c4:	74 24                	je     c01054ea <default_check+0x4d4>
c01054c6:	c7 44 24 0c e8 72 10 	movl   $0xc01072e8,0xc(%esp)
c01054cd:	c0 
c01054ce:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c01054d5:	c0 
c01054d6:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c01054dd:	00 
c01054de:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c01054e5:	e8 5b af ff ff       	call   c0100445 <__panic>

    free_pages(p0, 2);
c01054ea:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01054f1:	00 
c01054f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054f5:	89 04 24             	mov    %eax,(%esp)
c01054f8:	e8 f0 d8 ff ff       	call   c0102ded <free_pages>
    free_page(p2);
c01054fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105504:	00 
c0105505:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105508:	89 04 24             	mov    %eax,(%esp)
c010550b:	e8 dd d8 ff ff       	call   c0102ded <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0105510:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105517:	e8 95 d8 ff ff       	call   c0102db1 <alloc_pages>
c010551c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010551f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105523:	75 24                	jne    c0105549 <default_check+0x533>
c0105525:	c7 44 24 0c 08 73 10 	movl   $0xc0107308,0xc(%esp)
c010552c:	c0 
c010552d:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105534:	c0 
c0105535:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
c010553c:	00 
c010553d:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105544:	e8 fc ae ff ff       	call   c0100445 <__panic>
    assert(alloc_page() == NULL);
c0105549:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105550:	e8 5c d8 ff ff       	call   c0102db1 <alloc_pages>
c0105555:	85 c0                	test   %eax,%eax
c0105557:	74 24                	je     c010557d <default_check+0x567>
c0105559:	c7 44 24 0c 66 71 10 	movl   $0xc0107166,0xc(%esp)
c0105560:	c0 
c0105561:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105568:	c0 
c0105569:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c0105570:	00 
c0105571:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105578:	e8 c8 ae ff ff       	call   c0100445 <__panic>

    assert(nr_free == 0);
c010557d:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0105582:	85 c0                	test   %eax,%eax
c0105584:	74 24                	je     c01055aa <default_check+0x594>
c0105586:	c7 44 24 0c b9 71 10 	movl   $0xc01071b9,0xc(%esp)
c010558d:	c0 
c010558e:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105595:	c0 
c0105596:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c010559d:	00 
c010559e:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c01055a5:	e8 9b ae ff ff       	call   c0100445 <__panic>
    nr_free = nr_free_store;
c01055aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055ad:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_list = free_list_store;
c01055b2:	8b 45 80             	mov    -0x80(%ebp),%eax
c01055b5:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01055b8:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c01055bd:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    free_pages(p0, 5);
c01055c3:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01055ca:	00 
c01055cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055ce:	89 04 24             	mov    %eax,(%esp)
c01055d1:	e8 17 d8 ff ff       	call   c0102ded <free_pages>

    le = &free_list;
c01055d6:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
c01055dd:	eb 5a                	jmp    c0105639 <default_check+0x623>
    {
        assert(le->next->prev == le && le->prev->next == le);
c01055df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055e2:	8b 40 04             	mov    0x4(%eax),%eax
c01055e5:	8b 00                	mov    (%eax),%eax
c01055e7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01055ea:	75 0d                	jne    c01055f9 <default_check+0x5e3>
c01055ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055ef:	8b 00                	mov    (%eax),%eax
c01055f1:	8b 40 04             	mov    0x4(%eax),%eax
c01055f4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01055f7:	74 24                	je     c010561d <default_check+0x607>
c01055f9:	c7 44 24 0c 28 73 10 	movl   $0xc0107328,0xc(%esp)
c0105600:	c0 
c0105601:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105608:	c0 
c0105609:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c0105610:	00 
c0105611:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105618:	e8 28 ae ff ff       	call   c0100445 <__panic>
        struct Page *p = le2page(le, page_link);
c010561d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105620:	83 e8 0c             	sub    $0xc,%eax
c0105623:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
c0105626:	ff 4d f4             	decl   -0xc(%ebp)
c0105629:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010562c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010562f:	8b 40 08             	mov    0x8(%eax),%eax
c0105632:	29 c2                	sub    %eax,%edx
c0105634:	89 d0                	mov    %edx,%eax
c0105636:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105639:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010563c:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c010563f:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105642:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
c0105645:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105648:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c010564f:	75 8e                	jne    c01055df <default_check+0x5c9>
    }
    assert(count == 0);
c0105651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105655:	74 24                	je     c010567b <default_check+0x665>
c0105657:	c7 44 24 0c 55 73 10 	movl   $0xc0107355,0xc(%esp)
c010565e:	c0 
c010565f:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105666:	c0 
c0105667:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
c010566e:	00 
c010566f:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0105676:	e8 ca ad ff ff       	call   c0100445 <__panic>
    assert(total == 0);
c010567b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010567f:	74 24                	je     c01056a5 <default_check+0x68f>
c0105681:	c7 44 24 0c 60 73 10 	movl   $0xc0107360,0xc(%esp)
c0105688:	c0 
c0105689:	c7 44 24 08 de 6f 10 	movl   $0xc0106fde,0x8(%esp)
c0105690:	c0 
c0105691:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c0105698:	00 
c0105699:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c01056a0:	e8 a0 ad ff ff       	call   c0100445 <__panic>
}
c01056a5:	90                   	nop
c01056a6:	c9                   	leave  
c01056a7:	c3                   	ret    

c01056a8 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01056a8:	f3 0f 1e fb          	endbr32 
c01056ac:	55                   	push   %ebp
c01056ad:	89 e5                	mov    %esp,%ebp
c01056af:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01056b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01056b9:	eb 03                	jmp    c01056be <strlen+0x16>
        cnt ++;
c01056bb:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c01056be:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c1:	8d 50 01             	lea    0x1(%eax),%edx
c01056c4:	89 55 08             	mov    %edx,0x8(%ebp)
c01056c7:	0f b6 00             	movzbl (%eax),%eax
c01056ca:	84 c0                	test   %al,%al
c01056cc:	75 ed                	jne    c01056bb <strlen+0x13>
    }
    return cnt;
c01056ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01056d1:	c9                   	leave  
c01056d2:	c3                   	ret    

c01056d3 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01056d3:	f3 0f 1e fb          	endbr32 
c01056d7:	55                   	push   %ebp
c01056d8:	89 e5                	mov    %esp,%ebp
c01056da:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01056dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01056e4:	eb 03                	jmp    c01056e9 <strnlen+0x16>
        cnt ++;
c01056e6:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01056e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01056ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01056ef:	73 10                	jae    c0105701 <strnlen+0x2e>
c01056f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f4:	8d 50 01             	lea    0x1(%eax),%edx
c01056f7:	89 55 08             	mov    %edx,0x8(%ebp)
c01056fa:	0f b6 00             	movzbl (%eax),%eax
c01056fd:	84 c0                	test   %al,%al
c01056ff:	75 e5                	jne    c01056e6 <strnlen+0x13>
    }
    return cnt;
c0105701:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105704:	c9                   	leave  
c0105705:	c3                   	ret    

c0105706 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105706:	f3 0f 1e fb          	endbr32 
c010570a:	55                   	push   %ebp
c010570b:	89 e5                	mov    %esp,%ebp
c010570d:	57                   	push   %edi
c010570e:	56                   	push   %esi
c010570f:	83 ec 20             	sub    $0x20,%esp
c0105712:	8b 45 08             	mov    0x8(%ebp),%eax
c0105715:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105718:	8b 45 0c             	mov    0xc(%ebp),%eax
c010571b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010571e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105721:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105724:	89 d1                	mov    %edx,%ecx
c0105726:	89 c2                	mov    %eax,%edx
c0105728:	89 ce                	mov    %ecx,%esi
c010572a:	89 d7                	mov    %edx,%edi
c010572c:	ac                   	lods   %ds:(%esi),%al
c010572d:	aa                   	stos   %al,%es:(%edi)
c010572e:	84 c0                	test   %al,%al
c0105730:	75 fa                	jne    c010572c <strcpy+0x26>
c0105732:	89 fa                	mov    %edi,%edx
c0105734:	89 f1                	mov    %esi,%ecx
c0105736:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105739:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010573c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010573f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105742:	83 c4 20             	add    $0x20,%esp
c0105745:	5e                   	pop    %esi
c0105746:	5f                   	pop    %edi
c0105747:	5d                   	pop    %ebp
c0105748:	c3                   	ret    

c0105749 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105749:	f3 0f 1e fb          	endbr32 
c010574d:	55                   	push   %ebp
c010574e:	89 e5                	mov    %esp,%ebp
c0105750:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105753:	8b 45 08             	mov    0x8(%ebp),%eax
c0105756:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105759:	eb 1e                	jmp    c0105779 <strncpy+0x30>
        if ((*p = *src) != '\0') {
c010575b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010575e:	0f b6 10             	movzbl (%eax),%edx
c0105761:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105764:	88 10                	mov    %dl,(%eax)
c0105766:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105769:	0f b6 00             	movzbl (%eax),%eax
c010576c:	84 c0                	test   %al,%al
c010576e:	74 03                	je     c0105773 <strncpy+0x2a>
            src ++;
c0105770:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105773:	ff 45 fc             	incl   -0x4(%ebp)
c0105776:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105779:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010577d:	75 dc                	jne    c010575b <strncpy+0x12>
    }
    return dst;
c010577f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105782:	c9                   	leave  
c0105783:	c3                   	ret    

c0105784 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105784:	f3 0f 1e fb          	endbr32 
c0105788:	55                   	push   %ebp
c0105789:	89 e5                	mov    %esp,%ebp
c010578b:	57                   	push   %edi
c010578c:	56                   	push   %esi
c010578d:	83 ec 20             	sub    $0x20,%esp
c0105790:	8b 45 08             	mov    0x8(%ebp),%eax
c0105793:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105796:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105799:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c010579c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010579f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057a2:	89 d1                	mov    %edx,%ecx
c01057a4:	89 c2                	mov    %eax,%edx
c01057a6:	89 ce                	mov    %ecx,%esi
c01057a8:	89 d7                	mov    %edx,%edi
c01057aa:	ac                   	lods   %ds:(%esi),%al
c01057ab:	ae                   	scas   %es:(%edi),%al
c01057ac:	75 08                	jne    c01057b6 <strcmp+0x32>
c01057ae:	84 c0                	test   %al,%al
c01057b0:	75 f8                	jne    c01057aa <strcmp+0x26>
c01057b2:	31 c0                	xor    %eax,%eax
c01057b4:	eb 04                	jmp    c01057ba <strcmp+0x36>
c01057b6:	19 c0                	sbb    %eax,%eax
c01057b8:	0c 01                	or     $0x1,%al
c01057ba:	89 fa                	mov    %edi,%edx
c01057bc:	89 f1                	mov    %esi,%ecx
c01057be:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01057c1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01057c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01057c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01057ca:	83 c4 20             	add    $0x20,%esp
c01057cd:	5e                   	pop    %esi
c01057ce:	5f                   	pop    %edi
c01057cf:	5d                   	pop    %ebp
c01057d0:	c3                   	ret    

c01057d1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01057d1:	f3 0f 1e fb          	endbr32 
c01057d5:	55                   	push   %ebp
c01057d6:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01057d8:	eb 09                	jmp    c01057e3 <strncmp+0x12>
        n --, s1 ++, s2 ++;
c01057da:	ff 4d 10             	decl   0x10(%ebp)
c01057dd:	ff 45 08             	incl   0x8(%ebp)
c01057e0:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01057e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01057e7:	74 1a                	je     c0105803 <strncmp+0x32>
c01057e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ec:	0f b6 00             	movzbl (%eax),%eax
c01057ef:	84 c0                	test   %al,%al
c01057f1:	74 10                	je     c0105803 <strncmp+0x32>
c01057f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f6:	0f b6 10             	movzbl (%eax),%edx
c01057f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057fc:	0f b6 00             	movzbl (%eax),%eax
c01057ff:	38 c2                	cmp    %al,%dl
c0105801:	74 d7                	je     c01057da <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105803:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105807:	74 18                	je     c0105821 <strncmp+0x50>
c0105809:	8b 45 08             	mov    0x8(%ebp),%eax
c010580c:	0f b6 00             	movzbl (%eax),%eax
c010580f:	0f b6 d0             	movzbl %al,%edx
c0105812:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105815:	0f b6 00             	movzbl (%eax),%eax
c0105818:	0f b6 c0             	movzbl %al,%eax
c010581b:	29 c2                	sub    %eax,%edx
c010581d:	89 d0                	mov    %edx,%eax
c010581f:	eb 05                	jmp    c0105826 <strncmp+0x55>
c0105821:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105826:	5d                   	pop    %ebp
c0105827:	c3                   	ret    

c0105828 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105828:	f3 0f 1e fb          	endbr32 
c010582c:	55                   	push   %ebp
c010582d:	89 e5                	mov    %esp,%ebp
c010582f:	83 ec 04             	sub    $0x4,%esp
c0105832:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105835:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105838:	eb 13                	jmp    c010584d <strchr+0x25>
        if (*s == c) {
c010583a:	8b 45 08             	mov    0x8(%ebp),%eax
c010583d:	0f b6 00             	movzbl (%eax),%eax
c0105840:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105843:	75 05                	jne    c010584a <strchr+0x22>
            return (char *)s;
c0105845:	8b 45 08             	mov    0x8(%ebp),%eax
c0105848:	eb 12                	jmp    c010585c <strchr+0x34>
        }
        s ++;
c010584a:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c010584d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105850:	0f b6 00             	movzbl (%eax),%eax
c0105853:	84 c0                	test   %al,%al
c0105855:	75 e3                	jne    c010583a <strchr+0x12>
    }
    return NULL;
c0105857:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010585c:	c9                   	leave  
c010585d:	c3                   	ret    

c010585e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010585e:	f3 0f 1e fb          	endbr32 
c0105862:	55                   	push   %ebp
c0105863:	89 e5                	mov    %esp,%ebp
c0105865:	83 ec 04             	sub    $0x4,%esp
c0105868:	8b 45 0c             	mov    0xc(%ebp),%eax
c010586b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010586e:	eb 0e                	jmp    c010587e <strfind+0x20>
        if (*s == c) {
c0105870:	8b 45 08             	mov    0x8(%ebp),%eax
c0105873:	0f b6 00             	movzbl (%eax),%eax
c0105876:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105879:	74 0f                	je     c010588a <strfind+0x2c>
            break;
        }
        s ++;
c010587b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c010587e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105881:	0f b6 00             	movzbl (%eax),%eax
c0105884:	84 c0                	test   %al,%al
c0105886:	75 e8                	jne    c0105870 <strfind+0x12>
c0105888:	eb 01                	jmp    c010588b <strfind+0x2d>
            break;
c010588a:	90                   	nop
    }
    return (char *)s;
c010588b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010588e:	c9                   	leave  
c010588f:	c3                   	ret    

c0105890 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105890:	f3 0f 1e fb          	endbr32 
c0105894:	55                   	push   %ebp
c0105895:	89 e5                	mov    %esp,%ebp
c0105897:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010589a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01058a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01058a8:	eb 03                	jmp    c01058ad <strtol+0x1d>
        s ++;
c01058aa:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01058ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b0:	0f b6 00             	movzbl (%eax),%eax
c01058b3:	3c 20                	cmp    $0x20,%al
c01058b5:	74 f3                	je     c01058aa <strtol+0x1a>
c01058b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ba:	0f b6 00             	movzbl (%eax),%eax
c01058bd:	3c 09                	cmp    $0x9,%al
c01058bf:	74 e9                	je     c01058aa <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
c01058c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c4:	0f b6 00             	movzbl (%eax),%eax
c01058c7:	3c 2b                	cmp    $0x2b,%al
c01058c9:	75 05                	jne    c01058d0 <strtol+0x40>
        s ++;
c01058cb:	ff 45 08             	incl   0x8(%ebp)
c01058ce:	eb 14                	jmp    c01058e4 <strtol+0x54>
    }
    else if (*s == '-') {
c01058d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d3:	0f b6 00             	movzbl (%eax),%eax
c01058d6:	3c 2d                	cmp    $0x2d,%al
c01058d8:	75 0a                	jne    c01058e4 <strtol+0x54>
        s ++, neg = 1;
c01058da:	ff 45 08             	incl   0x8(%ebp)
c01058dd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01058e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01058e8:	74 06                	je     c01058f0 <strtol+0x60>
c01058ea:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01058ee:	75 22                	jne    c0105912 <strtol+0x82>
c01058f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f3:	0f b6 00             	movzbl (%eax),%eax
c01058f6:	3c 30                	cmp    $0x30,%al
c01058f8:	75 18                	jne    c0105912 <strtol+0x82>
c01058fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fd:	40                   	inc    %eax
c01058fe:	0f b6 00             	movzbl (%eax),%eax
c0105901:	3c 78                	cmp    $0x78,%al
c0105903:	75 0d                	jne    c0105912 <strtol+0x82>
        s += 2, base = 16;
c0105905:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105909:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105910:	eb 29                	jmp    c010593b <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
c0105912:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105916:	75 16                	jne    c010592e <strtol+0x9e>
c0105918:	8b 45 08             	mov    0x8(%ebp),%eax
c010591b:	0f b6 00             	movzbl (%eax),%eax
c010591e:	3c 30                	cmp    $0x30,%al
c0105920:	75 0c                	jne    c010592e <strtol+0x9e>
        s ++, base = 8;
c0105922:	ff 45 08             	incl   0x8(%ebp)
c0105925:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010592c:	eb 0d                	jmp    c010593b <strtol+0xab>
    }
    else if (base == 0) {
c010592e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105932:	75 07                	jne    c010593b <strtol+0xab>
        base = 10;
c0105934:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010593b:	8b 45 08             	mov    0x8(%ebp),%eax
c010593e:	0f b6 00             	movzbl (%eax),%eax
c0105941:	3c 2f                	cmp    $0x2f,%al
c0105943:	7e 1b                	jle    c0105960 <strtol+0xd0>
c0105945:	8b 45 08             	mov    0x8(%ebp),%eax
c0105948:	0f b6 00             	movzbl (%eax),%eax
c010594b:	3c 39                	cmp    $0x39,%al
c010594d:	7f 11                	jg     c0105960 <strtol+0xd0>
            dig = *s - '0';
c010594f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105952:	0f b6 00             	movzbl (%eax),%eax
c0105955:	0f be c0             	movsbl %al,%eax
c0105958:	83 e8 30             	sub    $0x30,%eax
c010595b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010595e:	eb 48                	jmp    c01059a8 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105960:	8b 45 08             	mov    0x8(%ebp),%eax
c0105963:	0f b6 00             	movzbl (%eax),%eax
c0105966:	3c 60                	cmp    $0x60,%al
c0105968:	7e 1b                	jle    c0105985 <strtol+0xf5>
c010596a:	8b 45 08             	mov    0x8(%ebp),%eax
c010596d:	0f b6 00             	movzbl (%eax),%eax
c0105970:	3c 7a                	cmp    $0x7a,%al
c0105972:	7f 11                	jg     c0105985 <strtol+0xf5>
            dig = *s - 'a' + 10;
c0105974:	8b 45 08             	mov    0x8(%ebp),%eax
c0105977:	0f b6 00             	movzbl (%eax),%eax
c010597a:	0f be c0             	movsbl %al,%eax
c010597d:	83 e8 57             	sub    $0x57,%eax
c0105980:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105983:	eb 23                	jmp    c01059a8 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105985:	8b 45 08             	mov    0x8(%ebp),%eax
c0105988:	0f b6 00             	movzbl (%eax),%eax
c010598b:	3c 40                	cmp    $0x40,%al
c010598d:	7e 3b                	jle    c01059ca <strtol+0x13a>
c010598f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105992:	0f b6 00             	movzbl (%eax),%eax
c0105995:	3c 5a                	cmp    $0x5a,%al
c0105997:	7f 31                	jg     c01059ca <strtol+0x13a>
            dig = *s - 'A' + 10;
c0105999:	8b 45 08             	mov    0x8(%ebp),%eax
c010599c:	0f b6 00             	movzbl (%eax),%eax
c010599f:	0f be c0             	movsbl %al,%eax
c01059a2:	83 e8 37             	sub    $0x37,%eax
c01059a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01059a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059ab:	3b 45 10             	cmp    0x10(%ebp),%eax
c01059ae:	7d 19                	jge    c01059c9 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
c01059b0:	ff 45 08             	incl   0x8(%ebp)
c01059b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01059b6:	0f af 45 10          	imul   0x10(%ebp),%eax
c01059ba:	89 c2                	mov    %eax,%edx
c01059bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059bf:	01 d0                	add    %edx,%eax
c01059c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01059c4:	e9 72 ff ff ff       	jmp    c010593b <strtol+0xab>
            break;
c01059c9:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01059ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01059ce:	74 08                	je     c01059d8 <strtol+0x148>
        *endptr = (char *) s;
c01059d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01059d6:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01059d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01059dc:	74 07                	je     c01059e5 <strtol+0x155>
c01059de:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01059e1:	f7 d8                	neg    %eax
c01059e3:	eb 03                	jmp    c01059e8 <strtol+0x158>
c01059e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01059e8:	c9                   	leave  
c01059e9:	c3                   	ret    

c01059ea <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01059ea:	f3 0f 1e fb          	endbr32 
c01059ee:	55                   	push   %ebp
c01059ef:	89 e5                	mov    %esp,%ebp
c01059f1:	57                   	push   %edi
c01059f2:	83 ec 24             	sub    $0x24,%esp
c01059f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f8:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01059fb:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c01059ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a02:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105a05:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105a08:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105a0e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105a11:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105a15:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105a18:	89 d7                	mov    %edx,%edi
c0105a1a:	f3 aa                	rep stos %al,%es:(%edi)
c0105a1c:	89 fa                	mov    %edi,%edx
c0105a1e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105a21:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105a24:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105a27:	83 c4 24             	add    $0x24,%esp
c0105a2a:	5f                   	pop    %edi
c0105a2b:	5d                   	pop    %ebp
c0105a2c:	c3                   	ret    

c0105a2d <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105a2d:	f3 0f 1e fb          	endbr32 
c0105a31:	55                   	push   %ebp
c0105a32:	89 e5                	mov    %esp,%ebp
c0105a34:	57                   	push   %edi
c0105a35:	56                   	push   %esi
c0105a36:	53                   	push   %ebx
c0105a37:	83 ec 30             	sub    $0x30,%esp
c0105a3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a43:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a46:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a49:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a4f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105a52:	73 42                	jae    c0105a96 <memmove+0x69>
c0105a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a63:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105a66:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a69:	c1 e8 02             	shr    $0x2,%eax
c0105a6c:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105a6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105a71:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a74:	89 d7                	mov    %edx,%edi
c0105a76:	89 c6                	mov    %eax,%esi
c0105a78:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105a7a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105a7d:	83 e1 03             	and    $0x3,%ecx
c0105a80:	74 02                	je     c0105a84 <memmove+0x57>
c0105a82:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105a84:	89 f0                	mov    %esi,%eax
c0105a86:	89 fa                	mov    %edi,%edx
c0105a88:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105a8b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105a8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105a91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105a94:	eb 36                	jmp    c0105acc <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105a96:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a99:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a9f:	01 c2                	add    %eax,%edx
c0105aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105aa4:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aaa:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105aad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ab0:	89 c1                	mov    %eax,%ecx
c0105ab2:	89 d8                	mov    %ebx,%eax
c0105ab4:	89 d6                	mov    %edx,%esi
c0105ab6:	89 c7                	mov    %eax,%edi
c0105ab8:	fd                   	std    
c0105ab9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105abb:	fc                   	cld    
c0105abc:	89 f8                	mov    %edi,%eax
c0105abe:	89 f2                	mov    %esi,%edx
c0105ac0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105ac3:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105ac6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105acc:	83 c4 30             	add    $0x30,%esp
c0105acf:	5b                   	pop    %ebx
c0105ad0:	5e                   	pop    %esi
c0105ad1:	5f                   	pop    %edi
c0105ad2:	5d                   	pop    %ebp
c0105ad3:	c3                   	ret    

c0105ad4 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105ad4:	f3 0f 1e fb          	endbr32 
c0105ad8:	55                   	push   %ebp
c0105ad9:	89 e5                	mov    %esp,%ebp
c0105adb:	57                   	push   %edi
c0105adc:	56                   	push   %esi
c0105add:	83 ec 20             	sub    $0x20,%esp
c0105ae0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aec:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105af5:	c1 e8 02             	shr    $0x2,%eax
c0105af8:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b00:	89 d7                	mov    %edx,%edi
c0105b02:	89 c6                	mov    %eax,%esi
c0105b04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105b06:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105b09:	83 e1 03             	and    $0x3,%ecx
c0105b0c:	74 02                	je     c0105b10 <memcpy+0x3c>
c0105b0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105b10:	89 f0                	mov    %esi,%eax
c0105b12:	89 fa                	mov    %edi,%edx
c0105b14:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105b17:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105b1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105b20:	83 c4 20             	add    $0x20,%esp
c0105b23:	5e                   	pop    %esi
c0105b24:	5f                   	pop    %edi
c0105b25:	5d                   	pop    %ebp
c0105b26:	c3                   	ret    

c0105b27 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105b27:	f3 0f 1e fb          	endbr32 
c0105b2b:	55                   	push   %ebp
c0105b2c:	89 e5                	mov    %esp,%ebp
c0105b2e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105b31:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105b37:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105b3d:	eb 2e                	jmp    c0105b6d <memcmp+0x46>
        if (*s1 != *s2) {
c0105b3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b42:	0f b6 10             	movzbl (%eax),%edx
c0105b45:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105b48:	0f b6 00             	movzbl (%eax),%eax
c0105b4b:	38 c2                	cmp    %al,%dl
c0105b4d:	74 18                	je     c0105b67 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105b4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b52:	0f b6 00             	movzbl (%eax),%eax
c0105b55:	0f b6 d0             	movzbl %al,%edx
c0105b58:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105b5b:	0f b6 00             	movzbl (%eax),%eax
c0105b5e:	0f b6 c0             	movzbl %al,%eax
c0105b61:	29 c2                	sub    %eax,%edx
c0105b63:	89 d0                	mov    %edx,%eax
c0105b65:	eb 18                	jmp    c0105b7f <memcmp+0x58>
        }
        s1 ++, s2 ++;
c0105b67:	ff 45 fc             	incl   -0x4(%ebp)
c0105b6a:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105b6d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b70:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105b73:	89 55 10             	mov    %edx,0x10(%ebp)
c0105b76:	85 c0                	test   %eax,%eax
c0105b78:	75 c5                	jne    c0105b3f <memcmp+0x18>
    }
    return 0;
c0105b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b7f:	c9                   	leave  
c0105b80:	c3                   	ret    

c0105b81 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105b81:	f3 0f 1e fb          	endbr32 
c0105b85:	55                   	push   %ebp
c0105b86:	89 e5                	mov    %esp,%ebp
c0105b88:	83 ec 58             	sub    $0x58,%esp
c0105b8b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105b91:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b94:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105b97:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105b9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105b9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105ba0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105ba3:	8b 45 18             	mov    0x18(%ebp),%eax
c0105ba6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105bac:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105baf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105bb2:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105bbf:	74 1c                	je     c0105bdd <printnum+0x5c>
c0105bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bc4:	ba 00 00 00 00       	mov    $0x0,%edx
c0105bc9:	f7 75 e4             	divl   -0x1c(%ebp)
c0105bcc:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bd2:	ba 00 00 00 00       	mov    $0x0,%edx
c0105bd7:	f7 75 e4             	divl   -0x1c(%ebp)
c0105bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105be3:	f7 75 e4             	divl   -0x1c(%ebp)
c0105be6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105be9:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105bec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105bef:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105bf2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105bf5:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105bf8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105bfb:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105bfe:	8b 45 18             	mov    0x18(%ebp),%eax
c0105c01:	ba 00 00 00 00       	mov    $0x0,%edx
c0105c06:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105c09:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105c0c:	19 d1                	sbb    %edx,%ecx
c0105c0e:	72 4c                	jb     c0105c5c <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105c10:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105c13:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105c16:	8b 45 20             	mov    0x20(%ebp),%eax
c0105c19:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105c1d:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105c21:	8b 45 18             	mov    0x18(%ebp),%eax
c0105c24:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c2e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c32:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105c36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c40:	89 04 24             	mov    %eax,(%esp)
c0105c43:	e8 39 ff ff ff       	call   c0105b81 <printnum>
c0105c48:	eb 1b                	jmp    c0105c65 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c51:	8b 45 20             	mov    0x20(%ebp),%eax
c0105c54:	89 04 24             	mov    %eax,(%esp)
c0105c57:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5a:	ff d0                	call   *%eax
        while (-- width > 0)
c0105c5c:	ff 4d 1c             	decl   0x1c(%ebp)
c0105c5f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105c63:	7f e5                	jg     c0105c4a <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105c65:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105c68:	05 1c 74 10 c0       	add    $0xc010741c,%eax
c0105c6d:	0f b6 00             	movzbl (%eax),%eax
c0105c70:	0f be c0             	movsbl %al,%eax
c0105c73:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105c76:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c7a:	89 04 24             	mov    %eax,(%esp)
c0105c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c80:	ff d0                	call   *%eax
}
c0105c82:	90                   	nop
c0105c83:	c9                   	leave  
c0105c84:	c3                   	ret    

c0105c85 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105c85:	f3 0f 1e fb          	endbr32 
c0105c89:	55                   	push   %ebp
c0105c8a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105c8c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105c90:	7e 14                	jle    c0105ca6 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
c0105c92:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c95:	8b 00                	mov    (%eax),%eax
c0105c97:	8d 48 08             	lea    0x8(%eax),%ecx
c0105c9a:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c9d:	89 0a                	mov    %ecx,(%edx)
c0105c9f:	8b 50 04             	mov    0x4(%eax),%edx
c0105ca2:	8b 00                	mov    (%eax),%eax
c0105ca4:	eb 30                	jmp    c0105cd6 <getuint+0x51>
    }
    else if (lflag) {
c0105ca6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105caa:	74 16                	je     c0105cc2 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
c0105cac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105caf:	8b 00                	mov    (%eax),%eax
c0105cb1:	8d 48 04             	lea    0x4(%eax),%ecx
c0105cb4:	8b 55 08             	mov    0x8(%ebp),%edx
c0105cb7:	89 0a                	mov    %ecx,(%edx)
c0105cb9:	8b 00                	mov    (%eax),%eax
c0105cbb:	ba 00 00 00 00       	mov    $0x0,%edx
c0105cc0:	eb 14                	jmp    c0105cd6 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105cc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc5:	8b 00                	mov    (%eax),%eax
c0105cc7:	8d 48 04             	lea    0x4(%eax),%ecx
c0105cca:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ccd:	89 0a                	mov    %ecx,(%edx)
c0105ccf:	8b 00                	mov    (%eax),%eax
c0105cd1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105cd6:	5d                   	pop    %ebp
c0105cd7:	c3                   	ret    

c0105cd8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105cd8:	f3 0f 1e fb          	endbr32 
c0105cdc:	55                   	push   %ebp
c0105cdd:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105cdf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105ce3:	7e 14                	jle    c0105cf9 <getint+0x21>
        return va_arg(*ap, long long);
c0105ce5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce8:	8b 00                	mov    (%eax),%eax
c0105cea:	8d 48 08             	lea    0x8(%eax),%ecx
c0105ced:	8b 55 08             	mov    0x8(%ebp),%edx
c0105cf0:	89 0a                	mov    %ecx,(%edx)
c0105cf2:	8b 50 04             	mov    0x4(%eax),%edx
c0105cf5:	8b 00                	mov    (%eax),%eax
c0105cf7:	eb 28                	jmp    c0105d21 <getint+0x49>
    }
    else if (lflag) {
c0105cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105cfd:	74 12                	je     c0105d11 <getint+0x39>
        return va_arg(*ap, long);
c0105cff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d02:	8b 00                	mov    (%eax),%eax
c0105d04:	8d 48 04             	lea    0x4(%eax),%ecx
c0105d07:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d0a:	89 0a                	mov    %ecx,(%edx)
c0105d0c:	8b 00                	mov    (%eax),%eax
c0105d0e:	99                   	cltd   
c0105d0f:	eb 10                	jmp    c0105d21 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
c0105d11:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d14:	8b 00                	mov    (%eax),%eax
c0105d16:	8d 48 04             	lea    0x4(%eax),%ecx
c0105d19:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d1c:	89 0a                	mov    %ecx,(%edx)
c0105d1e:	8b 00                	mov    (%eax),%eax
c0105d20:	99                   	cltd   
    }
}
c0105d21:	5d                   	pop    %ebp
c0105d22:	c3                   	ret    

c0105d23 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105d23:	f3 0f 1e fb          	endbr32 
c0105d27:	55                   	push   %ebp
c0105d28:	89 e5                	mov    %esp,%ebp
c0105d2a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105d2d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d36:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d3d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d48:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4b:	89 04 24             	mov    %eax,(%esp)
c0105d4e:	e8 03 00 00 00       	call   c0105d56 <vprintfmt>
    va_end(ap);
}
c0105d53:	90                   	nop
c0105d54:	c9                   	leave  
c0105d55:	c3                   	ret    

c0105d56 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105d56:	f3 0f 1e fb          	endbr32 
c0105d5a:	55                   	push   %ebp
c0105d5b:	89 e5                	mov    %esp,%ebp
c0105d5d:	56                   	push   %esi
c0105d5e:	53                   	push   %ebx
c0105d5f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105d62:	eb 17                	jmp    c0105d7b <vprintfmt+0x25>
            if (ch == '\0') {
c0105d64:	85 db                	test   %ebx,%ebx
c0105d66:	0f 84 c0 03 00 00    	je     c010612c <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
c0105d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d73:	89 1c 24             	mov    %ebx,(%esp)
c0105d76:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d79:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105d7b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d7e:	8d 50 01             	lea    0x1(%eax),%edx
c0105d81:	89 55 10             	mov    %edx,0x10(%ebp)
c0105d84:	0f b6 00             	movzbl (%eax),%eax
c0105d87:	0f b6 d8             	movzbl %al,%ebx
c0105d8a:	83 fb 25             	cmp    $0x25,%ebx
c0105d8d:	75 d5                	jne    c0105d64 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105d8f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105d93:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105da0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105da7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105daa:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105dad:	8b 45 10             	mov    0x10(%ebp),%eax
c0105db0:	8d 50 01             	lea    0x1(%eax),%edx
c0105db3:	89 55 10             	mov    %edx,0x10(%ebp)
c0105db6:	0f b6 00             	movzbl (%eax),%eax
c0105db9:	0f b6 d8             	movzbl %al,%ebx
c0105dbc:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105dbf:	83 f8 55             	cmp    $0x55,%eax
c0105dc2:	0f 87 38 03 00 00    	ja     c0106100 <vprintfmt+0x3aa>
c0105dc8:	8b 04 85 40 74 10 c0 	mov    -0x3fef8bc0(,%eax,4),%eax
c0105dcf:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105dd2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105dd6:	eb d5                	jmp    c0105dad <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105dd8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105ddc:	eb cf                	jmp    c0105dad <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105dde:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105de5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105de8:	89 d0                	mov    %edx,%eax
c0105dea:	c1 e0 02             	shl    $0x2,%eax
c0105ded:	01 d0                	add    %edx,%eax
c0105def:	01 c0                	add    %eax,%eax
c0105df1:	01 d8                	add    %ebx,%eax
c0105df3:	83 e8 30             	sub    $0x30,%eax
c0105df6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105df9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dfc:	0f b6 00             	movzbl (%eax),%eax
c0105dff:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105e02:	83 fb 2f             	cmp    $0x2f,%ebx
c0105e05:	7e 38                	jle    c0105e3f <vprintfmt+0xe9>
c0105e07:	83 fb 39             	cmp    $0x39,%ebx
c0105e0a:	7f 33                	jg     c0105e3f <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
c0105e0c:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105e0f:	eb d4                	jmp    c0105de5 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105e11:	8b 45 14             	mov    0x14(%ebp),%eax
c0105e14:	8d 50 04             	lea    0x4(%eax),%edx
c0105e17:	89 55 14             	mov    %edx,0x14(%ebp)
c0105e1a:	8b 00                	mov    (%eax),%eax
c0105e1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105e1f:	eb 1f                	jmp    c0105e40 <vprintfmt+0xea>

        case '.':
            if (width < 0)
c0105e21:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105e25:	79 86                	jns    c0105dad <vprintfmt+0x57>
                width = 0;
c0105e27:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105e2e:	e9 7a ff ff ff       	jmp    c0105dad <vprintfmt+0x57>

        case '#':
            altflag = 1;
c0105e33:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105e3a:	e9 6e ff ff ff       	jmp    c0105dad <vprintfmt+0x57>
            goto process_precision;
c0105e3f:	90                   	nop

        process_precision:
            if (width < 0)
c0105e40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105e44:	0f 89 63 ff ff ff    	jns    c0105dad <vprintfmt+0x57>
                width = precision, precision = -1;
c0105e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105e50:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105e57:	e9 51 ff ff ff       	jmp    c0105dad <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105e5c:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105e5f:	e9 49 ff ff ff       	jmp    c0105dad <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105e64:	8b 45 14             	mov    0x14(%ebp),%eax
c0105e67:	8d 50 04             	lea    0x4(%eax),%edx
c0105e6a:	89 55 14             	mov    %edx,0x14(%ebp)
c0105e6d:	8b 00                	mov    (%eax),%eax
c0105e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105e72:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e76:	89 04 24             	mov    %eax,(%esp)
c0105e79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e7c:	ff d0                	call   *%eax
            break;
c0105e7e:	e9 a4 02 00 00       	jmp    c0106127 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105e83:	8b 45 14             	mov    0x14(%ebp),%eax
c0105e86:	8d 50 04             	lea    0x4(%eax),%edx
c0105e89:	89 55 14             	mov    %edx,0x14(%ebp)
c0105e8c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105e8e:	85 db                	test   %ebx,%ebx
c0105e90:	79 02                	jns    c0105e94 <vprintfmt+0x13e>
                err = -err;
c0105e92:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105e94:	83 fb 06             	cmp    $0x6,%ebx
c0105e97:	7f 0b                	jg     c0105ea4 <vprintfmt+0x14e>
c0105e99:	8b 34 9d 00 74 10 c0 	mov    -0x3fef8c00(,%ebx,4),%esi
c0105ea0:	85 f6                	test   %esi,%esi
c0105ea2:	75 23                	jne    c0105ec7 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
c0105ea4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105ea8:	c7 44 24 08 2d 74 10 	movl   $0xc010742d,0x8(%esp)
c0105eaf:	c0 
c0105eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105eb3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105eb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eba:	89 04 24             	mov    %eax,(%esp)
c0105ebd:	e8 61 fe ff ff       	call   c0105d23 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105ec2:	e9 60 02 00 00       	jmp    c0106127 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
c0105ec7:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105ecb:	c7 44 24 08 36 74 10 	movl   $0xc0107436,0x8(%esp)
c0105ed2:	c0 
c0105ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ed6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105eda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105edd:	89 04 24             	mov    %eax,(%esp)
c0105ee0:	e8 3e fe ff ff       	call   c0105d23 <printfmt>
            break;
c0105ee5:	e9 3d 02 00 00       	jmp    c0106127 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105eea:	8b 45 14             	mov    0x14(%ebp),%eax
c0105eed:	8d 50 04             	lea    0x4(%eax),%edx
c0105ef0:	89 55 14             	mov    %edx,0x14(%ebp)
c0105ef3:	8b 30                	mov    (%eax),%esi
c0105ef5:	85 f6                	test   %esi,%esi
c0105ef7:	75 05                	jne    c0105efe <vprintfmt+0x1a8>
                p = "(null)";
c0105ef9:	be 39 74 10 c0       	mov    $0xc0107439,%esi
            }
            if (width > 0 && padc != '-') {
c0105efe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105f02:	7e 76                	jle    c0105f7a <vprintfmt+0x224>
c0105f04:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105f08:	74 70                	je     c0105f7a <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105f0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f11:	89 34 24             	mov    %esi,(%esp)
c0105f14:	e8 ba f7 ff ff       	call   c01056d3 <strnlen>
c0105f19:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105f1c:	29 c2                	sub    %eax,%edx
c0105f1e:	89 d0                	mov    %edx,%eax
c0105f20:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105f23:	eb 16                	jmp    c0105f3b <vprintfmt+0x1e5>
                    putch(padc, putdat);
c0105f25:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105f29:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105f2c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f30:	89 04 24             	mov    %eax,(%esp)
c0105f33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f36:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105f38:	ff 4d e8             	decl   -0x18(%ebp)
c0105f3b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105f3f:	7f e4                	jg     c0105f25 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105f41:	eb 37                	jmp    c0105f7a <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105f43:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105f47:	74 1f                	je     c0105f68 <vprintfmt+0x212>
c0105f49:	83 fb 1f             	cmp    $0x1f,%ebx
c0105f4c:	7e 05                	jle    c0105f53 <vprintfmt+0x1fd>
c0105f4e:	83 fb 7e             	cmp    $0x7e,%ebx
c0105f51:	7e 15                	jle    c0105f68 <vprintfmt+0x212>
                    putch('?', putdat);
c0105f53:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f5a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105f61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f64:	ff d0                	call   *%eax
c0105f66:	eb 0f                	jmp    c0105f77 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
c0105f68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f6f:	89 1c 24             	mov    %ebx,(%esp)
c0105f72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f75:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105f77:	ff 4d e8             	decl   -0x18(%ebp)
c0105f7a:	89 f0                	mov    %esi,%eax
c0105f7c:	8d 70 01             	lea    0x1(%eax),%esi
c0105f7f:	0f b6 00             	movzbl (%eax),%eax
c0105f82:	0f be d8             	movsbl %al,%ebx
c0105f85:	85 db                	test   %ebx,%ebx
c0105f87:	74 27                	je     c0105fb0 <vprintfmt+0x25a>
c0105f89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105f8d:	78 b4                	js     c0105f43 <vprintfmt+0x1ed>
c0105f8f:	ff 4d e4             	decl   -0x1c(%ebp)
c0105f92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105f96:	79 ab                	jns    c0105f43 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
c0105f98:	eb 16                	jmp    c0105fb0 <vprintfmt+0x25a>
                putch(' ', putdat);
c0105f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fa1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105fa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fab:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105fad:	ff 4d e8             	decl   -0x18(%ebp)
c0105fb0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105fb4:	7f e4                	jg     c0105f9a <vprintfmt+0x244>
            }
            break;
c0105fb6:	e9 6c 01 00 00       	jmp    c0106127 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fc2:	8d 45 14             	lea    0x14(%ebp),%eax
c0105fc5:	89 04 24             	mov    %eax,(%esp)
c0105fc8:	e8 0b fd ff ff       	call   c0105cd8 <getint>
c0105fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105fd9:	85 d2                	test   %edx,%edx
c0105fdb:	79 26                	jns    c0106003 <vprintfmt+0x2ad>
                putch('-', putdat);
c0105fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fe4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105feb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fee:	ff d0                	call   *%eax
                num = -(long long)num;
c0105ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ff3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ff6:	f7 d8                	neg    %eax
c0105ff8:	83 d2 00             	adc    $0x0,%edx
c0105ffb:	f7 da                	neg    %edx
c0105ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106000:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0106003:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010600a:	e9 a8 00 00 00       	jmp    c01060b7 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010600f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106012:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106016:	8d 45 14             	lea    0x14(%ebp),%eax
c0106019:	89 04 24             	mov    %eax,(%esp)
c010601c:	e8 64 fc ff ff       	call   c0105c85 <getuint>
c0106021:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106024:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0106027:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010602e:	e9 84 00 00 00       	jmp    c01060b7 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0106033:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106036:	89 44 24 04          	mov    %eax,0x4(%esp)
c010603a:	8d 45 14             	lea    0x14(%ebp),%eax
c010603d:	89 04 24             	mov    %eax,(%esp)
c0106040:	e8 40 fc ff ff       	call   c0105c85 <getuint>
c0106045:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106048:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010604b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0106052:	eb 63                	jmp    c01060b7 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
c0106054:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106057:	89 44 24 04          	mov    %eax,0x4(%esp)
c010605b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0106062:	8b 45 08             	mov    0x8(%ebp),%eax
c0106065:	ff d0                	call   *%eax
            putch('x', putdat);
c0106067:	8b 45 0c             	mov    0xc(%ebp),%eax
c010606a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010606e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0106075:	8b 45 08             	mov    0x8(%ebp),%eax
c0106078:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010607a:	8b 45 14             	mov    0x14(%ebp),%eax
c010607d:	8d 50 04             	lea    0x4(%eax),%edx
c0106080:	89 55 14             	mov    %edx,0x14(%ebp)
c0106083:	8b 00                	mov    (%eax),%eax
c0106085:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106088:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010608f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0106096:	eb 1f                	jmp    c01060b7 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0106098:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010609b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010609f:	8d 45 14             	lea    0x14(%ebp),%eax
c01060a2:	89 04 24             	mov    %eax,(%esp)
c01060a5:	e8 db fb ff ff       	call   c0105c85 <getuint>
c01060aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01060b0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01060b7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01060bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060be:	89 54 24 18          	mov    %edx,0x18(%esp)
c01060c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01060c5:	89 54 24 14          	mov    %edx,0x14(%esp)
c01060c9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01060cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01060d3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01060d7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01060db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01060e5:	89 04 24             	mov    %eax,(%esp)
c01060e8:	e8 94 fa ff ff       	call   c0105b81 <printnum>
            break;
c01060ed:	eb 38                	jmp    c0106127 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01060ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060f6:	89 1c 24             	mov    %ebx,(%esp)
c01060f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01060fc:	ff d0                	call   *%eax
            break;
c01060fe:	eb 27                	jmp    c0106127 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0106100:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106107:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010610e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106111:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0106113:	ff 4d 10             	decl   0x10(%ebp)
c0106116:	eb 03                	jmp    c010611b <vprintfmt+0x3c5>
c0106118:	ff 4d 10             	decl   0x10(%ebp)
c010611b:	8b 45 10             	mov    0x10(%ebp),%eax
c010611e:	48                   	dec    %eax
c010611f:	0f b6 00             	movzbl (%eax),%eax
c0106122:	3c 25                	cmp    $0x25,%al
c0106124:	75 f2                	jne    c0106118 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
c0106126:	90                   	nop
    while (1) {
c0106127:	e9 36 fc ff ff       	jmp    c0105d62 <vprintfmt+0xc>
                return;
c010612c:	90                   	nop
        }
    }
}
c010612d:	83 c4 40             	add    $0x40,%esp
c0106130:	5b                   	pop    %ebx
c0106131:	5e                   	pop    %esi
c0106132:	5d                   	pop    %ebp
c0106133:	c3                   	ret    

c0106134 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0106134:	f3 0f 1e fb          	endbr32 
c0106138:	55                   	push   %ebp
c0106139:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010613b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010613e:	8b 40 08             	mov    0x8(%eax),%eax
c0106141:	8d 50 01             	lea    0x1(%eax),%edx
c0106144:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106147:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010614a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010614d:	8b 10                	mov    (%eax),%edx
c010614f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106152:	8b 40 04             	mov    0x4(%eax),%eax
c0106155:	39 c2                	cmp    %eax,%edx
c0106157:	73 12                	jae    c010616b <sprintputch+0x37>
        *b->buf ++ = ch;
c0106159:	8b 45 0c             	mov    0xc(%ebp),%eax
c010615c:	8b 00                	mov    (%eax),%eax
c010615e:	8d 48 01             	lea    0x1(%eax),%ecx
c0106161:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106164:	89 0a                	mov    %ecx,(%edx)
c0106166:	8b 55 08             	mov    0x8(%ebp),%edx
c0106169:	88 10                	mov    %dl,(%eax)
    }
}
c010616b:	90                   	nop
c010616c:	5d                   	pop    %ebp
c010616d:	c3                   	ret    

c010616e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010616e:	f3 0f 1e fb          	endbr32 
c0106172:	55                   	push   %ebp
c0106173:	89 e5                	mov    %esp,%ebp
c0106175:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106178:	8d 45 14             	lea    0x14(%ebp),%eax
c010617b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010617e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106181:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106185:	8b 45 10             	mov    0x10(%ebp),%eax
c0106188:	89 44 24 08          	mov    %eax,0x8(%esp)
c010618c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010618f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106193:	8b 45 08             	mov    0x8(%ebp),%eax
c0106196:	89 04 24             	mov    %eax,(%esp)
c0106199:	e8 08 00 00 00       	call   c01061a6 <vsnprintf>
c010619e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01061a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01061a4:	c9                   	leave  
c01061a5:	c3                   	ret    

c01061a6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01061a6:	f3 0f 1e fb          	endbr32 
c01061aa:	55                   	push   %ebp
c01061ab:	89 e5                	mov    %esp,%ebp
c01061ad:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01061b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01061b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01061b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061b9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01061bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01061bf:	01 d0                	add    %edx,%eax
c01061c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01061cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01061cf:	74 0a                	je     c01061db <vsnprintf+0x35>
c01061d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01061d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061d7:	39 c2                	cmp    %eax,%edx
c01061d9:	76 07                	jbe    c01061e2 <vsnprintf+0x3c>
        return -E_INVAL;
c01061db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01061e0:	eb 2a                	jmp    c010620c <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01061e2:	8b 45 14             	mov    0x14(%ebp),%eax
c01061e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01061e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01061ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01061f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01061f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061f7:	c7 04 24 34 61 10 c0 	movl   $0xc0106134,(%esp)
c01061fe:	e8 53 fb ff ff       	call   c0105d56 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0106203:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106206:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106209:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010620c:	c9                   	leave  
c010620d:	c3                   	ret    
