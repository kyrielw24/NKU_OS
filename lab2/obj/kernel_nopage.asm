
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 a0 11 40       	mov    $0x4011a000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 a0 11 00       	mov    %eax,0x11a000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 90 11 00       	mov    $0x119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	f3 0f 1e fb          	endbr32 
  10003a:	55                   	push   %ebp
  10003b:	89 e5                	mov    %esp,%ebp
  10003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100040:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  100045:	2d 36 9a 11 00       	sub    $0x119a36,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 9a 11 00 	movl   $0x119a36,(%esp)
  10005d:	e8 88 59 00 00       	call   1059ea <memset>

    cons_init();                // init the console
  100062:	e8 75 16 00 00       	call   1016dc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 20 62 10 00 	movl   $0x106220,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 3c 62 10 00 	movl   $0x10623c,(%esp)
  10007c:	e8 58 02 00 00       	call   1002d9 <cprintf>

    print_kerninfo();
  100081:	e8 16 09 00 00       	call   10099c <print_kerninfo>

    grade_backtrace();
  100086:	e8 9a 00 00 00       	call   100125 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 df 32 00 00       	call   10336f <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 c2 17 00 00       	call   101857 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 67 19 00 00       	call   101a01 <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 84 0d 00 00       	call   100e23 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 ff 18 00 00       	call   1019a3 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  1000a4:	e8 96 01 00 00       	call   10023f <lab1_switch_test>

    /* do nothing */
    while (1);
  1000a9:	eb fe                	jmp    1000a9 <kern_init+0x73>

001000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000ab:	f3 0f 1e fb          	endbr32 
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000bc:	00 
  1000bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000c4:	00 
  1000c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000cc:	e8 3c 0d 00 00       	call   100e0d <mon_backtrace>
}
  1000d1:	90                   	nop
  1000d2:	c9                   	leave  
  1000d3:	c3                   	ret    

001000d4 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000d4:	f3 0f 1e fb          	endbr32 
  1000d8:	55                   	push   %ebp
  1000d9:	89 e5                	mov    %esp,%ebp
  1000db:	53                   	push   %ebx
  1000dc:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000df:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000e5:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000f7:	89 04 24             	mov    %eax,(%esp)
  1000fa:	e8 ac ff ff ff       	call   1000ab <grade_backtrace2>
}
  1000ff:	90                   	nop
  100100:	83 c4 14             	add    $0x14,%esp
  100103:	5b                   	pop    %ebx
  100104:	5d                   	pop    %ebp
  100105:	c3                   	ret    

00100106 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100106:	f3 0f 1e fb          	endbr32 
  10010a:	55                   	push   %ebp
  10010b:	89 e5                	mov    %esp,%ebp
  10010d:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100110:	8b 45 10             	mov    0x10(%ebp),%eax
  100113:	89 44 24 04          	mov    %eax,0x4(%esp)
  100117:	8b 45 08             	mov    0x8(%ebp),%eax
  10011a:	89 04 24             	mov    %eax,(%esp)
  10011d:	e8 b2 ff ff ff       	call   1000d4 <grade_backtrace1>
}
  100122:	90                   	nop
  100123:	c9                   	leave  
  100124:	c3                   	ret    

00100125 <grade_backtrace>:

void
grade_backtrace(void) {
  100125:	f3 0f 1e fb          	endbr32 
  100129:	55                   	push   %ebp
  10012a:	89 e5                	mov    %esp,%ebp
  10012c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10012f:	b8 36 00 10 00       	mov    $0x100036,%eax
  100134:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10013b:	ff 
  10013c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100147:	e8 ba ff ff ff       	call   100106 <grade_backtrace0>
}
  10014c:	90                   	nop
  10014d:	c9                   	leave  
  10014e:	c3                   	ret    

0010014f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10014f:	f3 0f 1e fb          	endbr32 
  100153:	55                   	push   %ebp
  100154:	89 e5                	mov    %esp,%ebp
  100156:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100159:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10015c:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10015f:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100162:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100169:	83 e0 03             	and    $0x3,%eax
  10016c:	89 c2                	mov    %eax,%edx
  10016e:	a1 00 c0 11 00       	mov    0x11c000,%eax
  100173:	89 54 24 08          	mov    %edx,0x8(%esp)
  100177:	89 44 24 04          	mov    %eax,0x4(%esp)
  10017b:	c7 04 24 41 62 10 00 	movl   $0x106241,(%esp)
  100182:	e8 52 01 00 00       	call   1002d9 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100187:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10018b:	89 c2                	mov    %eax,%edx
  10018d:	a1 00 c0 11 00       	mov    0x11c000,%eax
  100192:	89 54 24 08          	mov    %edx,0x8(%esp)
  100196:	89 44 24 04          	mov    %eax,0x4(%esp)
  10019a:	c7 04 24 4f 62 10 00 	movl   $0x10624f,(%esp)
  1001a1:	e8 33 01 00 00       	call   1002d9 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a6:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001aa:	89 c2                	mov    %eax,%edx
  1001ac:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b9:	c7 04 24 5d 62 10 00 	movl   $0x10625d,(%esp)
  1001c0:	e8 14 01 00 00       	call   1002d9 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c9:	89 c2                	mov    %eax,%edx
  1001cb:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001d0:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d8:	c7 04 24 6b 62 10 00 	movl   $0x10626b,(%esp)
  1001df:	e8 f5 00 00 00       	call   1002d9 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001e4:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e8:	89 c2                	mov    %eax,%edx
  1001ea:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f7:	c7 04 24 79 62 10 00 	movl   $0x106279,(%esp)
  1001fe:	e8 d6 00 00 00       	call   1002d9 <cprintf>
    round ++;
  100203:	a1 00 c0 11 00       	mov    0x11c000,%eax
  100208:	40                   	inc    %eax
  100209:	a3 00 c0 11 00       	mov    %eax,0x11c000
}
  10020e:	90                   	nop
  10020f:	c9                   	leave  
  100210:	c3                   	ret    

00100211 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  100211:	f3 0f 1e fb          	endbr32 
  100215:	55                   	push   %ebp
  100216:	89 e5                	mov    %esp,%ebp
  100218:	83 ec 18             	sub    $0x18,%esp
    //LAB1 CHALLENGE 1 : TODO
    cprintf("1");
  10021b:	c7 04 24 87 62 10 00 	movl   $0x106287,(%esp)
  100222:	e8 b2 00 00 00       	call   1002d9 <cprintf>
    asm volatile(
  100227:	83 ec 08             	sub    $0x8,%esp
  10022a:	cd 78                	int    $0x78
  10022c:	89 ec                	mov    %ebp,%esp
        "sub $0x8, %%esp \n"
        "int %0 \n"
        "movl %%ebp, %%esp" ::"i"(T_SWITCH_TOU));
}
  10022e:	90                   	nop
  10022f:	c9                   	leave  
  100230:	c3                   	ret    

00100231 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100231:	f3 0f 1e fb          	endbr32 
  100235:	55                   	push   %ebp
  100236:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile(
  100238:	cd 79                	int    $0x79
  10023a:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp" ::"i"(T_SWITCH_TOK));
}
  10023c:	90                   	nop
  10023d:	5d                   	pop    %ebp
  10023e:	c3                   	ret    

0010023f <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10023f:	f3 0f 1e fb          	endbr32 
  100243:	55                   	push   %ebp
  100244:	89 e5                	mov    %esp,%ebp
  100246:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100249:	e8 01 ff ff ff       	call   10014f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10024e:	c7 04 24 8c 62 10 00 	movl   $0x10628c,(%esp)
  100255:	e8 7f 00 00 00       	call   1002d9 <cprintf>
    lab1_switch_to_user();
  10025a:	e8 b2 ff ff ff       	call   100211 <lab1_switch_to_user>
    lab1_print_cur_status();
  10025f:	e8 eb fe ff ff       	call   10014f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100264:	c7 04 24 ac 62 10 00 	movl   $0x1062ac,(%esp)
  10026b:	e8 69 00 00 00       	call   1002d9 <cprintf>
    lab1_switch_to_kernel();
  100270:	e8 bc ff ff ff       	call   100231 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100275:	e8 d5 fe ff ff       	call   10014f <lab1_print_cur_status>
}
  10027a:	90                   	nop
  10027b:	c9                   	leave  
  10027c:	c3                   	ret    

0010027d <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10027d:	f3 0f 1e fb          	endbr32 
  100281:	55                   	push   %ebp
  100282:	89 e5                	mov    %esp,%ebp
  100284:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100287:	8b 45 08             	mov    0x8(%ebp),%eax
  10028a:	89 04 24             	mov    %eax,(%esp)
  10028d:	e8 7b 14 00 00       	call   10170d <cons_putc>
    (*cnt) ++;
  100292:	8b 45 0c             	mov    0xc(%ebp),%eax
  100295:	8b 00                	mov    (%eax),%eax
  100297:	8d 50 01             	lea    0x1(%eax),%edx
  10029a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10029d:	89 10                	mov    %edx,(%eax)
}
  10029f:	90                   	nop
  1002a0:	c9                   	leave  
  1002a1:	c3                   	ret    

001002a2 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002a2:	f3 0f 1e fb          	endbr32 
  1002a6:	55                   	push   %ebp
  1002a7:	89 e5                	mov    %esp,%ebp
  1002a9:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1002bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002c8:	c7 04 24 7d 02 10 00 	movl   $0x10027d,(%esp)
  1002cf:	e8 82 5a 00 00       	call   105d56 <vprintfmt>
    return cnt;
  1002d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002d7:	c9                   	leave  
  1002d8:	c3                   	ret    

001002d9 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002d9:	f3 0f 1e fb          	endbr32 
  1002dd:	55                   	push   %ebp
  1002de:	89 e5                	mov    %esp,%ebp
  1002e0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002e3:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f3:	89 04 24             	mov    %eax,(%esp)
  1002f6:	e8 a7 ff ff ff       	call   1002a2 <vcprintf>
  1002fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100301:	c9                   	leave  
  100302:	c3                   	ret    

00100303 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100303:	f3 0f 1e fb          	endbr32 
  100307:	55                   	push   %ebp
  100308:	89 e5                	mov    %esp,%ebp
  10030a:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10030d:	8b 45 08             	mov    0x8(%ebp),%eax
  100310:	89 04 24             	mov    %eax,(%esp)
  100313:	e8 f5 13 00 00       	call   10170d <cons_putc>
}
  100318:	90                   	nop
  100319:	c9                   	leave  
  10031a:	c3                   	ret    

0010031b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10031b:	f3 0f 1e fb          	endbr32 
  10031f:	55                   	push   %ebp
  100320:	89 e5                	mov    %esp,%ebp
  100322:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100325:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10032c:	eb 13                	jmp    100341 <cputs+0x26>
        cputch(c, &cnt);
  10032e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100332:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100335:	89 54 24 04          	mov    %edx,0x4(%esp)
  100339:	89 04 24             	mov    %eax,(%esp)
  10033c:	e8 3c ff ff ff       	call   10027d <cputch>
    while ((c = *str ++) != '\0') {
  100341:	8b 45 08             	mov    0x8(%ebp),%eax
  100344:	8d 50 01             	lea    0x1(%eax),%edx
  100347:	89 55 08             	mov    %edx,0x8(%ebp)
  10034a:	0f b6 00             	movzbl (%eax),%eax
  10034d:	88 45 f7             	mov    %al,-0x9(%ebp)
  100350:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100354:	75 d8                	jne    10032e <cputs+0x13>
    }
    cputch('\n', &cnt);
  100356:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100359:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100364:	e8 14 ff ff ff       	call   10027d <cputch>
    return cnt;
  100369:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10036c:	c9                   	leave  
  10036d:	c3                   	ret    

0010036e <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10036e:	f3 0f 1e fb          	endbr32 
  100372:	55                   	push   %ebp
  100373:	89 e5                	mov    %esp,%ebp
  100375:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100378:	90                   	nop
  100379:	e8 d0 13 00 00       	call   10174e <cons_getc>
  10037e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100381:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100385:	74 f2                	je     100379 <getchar+0xb>
        /* do nothing */;
    return c;
  100387:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10038a:	c9                   	leave  
  10038b:	c3                   	ret    

0010038c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10038c:	f3 0f 1e fb          	endbr32 
  100390:	55                   	push   %ebp
  100391:	89 e5                	mov    %esp,%ebp
  100393:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100396:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10039a:	74 13                	je     1003af <readline+0x23>
        cprintf("%s", prompt);
  10039c:	8b 45 08             	mov    0x8(%ebp),%eax
  10039f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003a3:	c7 04 24 cb 62 10 00 	movl   $0x1062cb,(%esp)
  1003aa:	e8 2a ff ff ff       	call   1002d9 <cprintf>
    }
    int i = 0, c;
  1003af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  1003b6:	e8 b3 ff ff ff       	call   10036e <getchar>
  1003bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  1003be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1003c2:	79 07                	jns    1003cb <readline+0x3f>
            return NULL;
  1003c4:	b8 00 00 00 00       	mov    $0x0,%eax
  1003c9:	eb 78                	jmp    100443 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  1003cb:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  1003cf:	7e 28                	jle    1003f9 <readline+0x6d>
  1003d1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  1003d8:	7f 1f                	jg     1003f9 <readline+0x6d>
            cputchar(c);
  1003da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003dd:	89 04 24             	mov    %eax,(%esp)
  1003e0:	e8 1e ff ff ff       	call   100303 <cputchar>
            buf[i ++] = c;
  1003e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003e8:	8d 50 01             	lea    0x1(%eax),%edx
  1003eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003f1:	88 90 20 c0 11 00    	mov    %dl,0x11c020(%eax)
  1003f7:	eb 45                	jmp    10043e <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003f9:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003fd:	75 16                	jne    100415 <readline+0x89>
  1003ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100403:	7e 10                	jle    100415 <readline+0x89>
            cputchar(c);
  100405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100408:	89 04 24             	mov    %eax,(%esp)
  10040b:	e8 f3 fe ff ff       	call   100303 <cputchar>
            i --;
  100410:	ff 4d f4             	decl   -0xc(%ebp)
  100413:	eb 29                	jmp    10043e <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  100415:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100419:	74 06                	je     100421 <readline+0x95>
  10041b:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10041f:	75 95                	jne    1003b6 <readline+0x2a>
            cputchar(c);
  100421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100424:	89 04 24             	mov    %eax,(%esp)
  100427:	e8 d7 fe ff ff       	call   100303 <cputchar>
            buf[i] = '\0';
  10042c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10042f:	05 20 c0 11 00       	add    $0x11c020,%eax
  100434:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100437:	b8 20 c0 11 00       	mov    $0x11c020,%eax
  10043c:	eb 05                	jmp    100443 <readline+0xb7>
        c = getchar();
  10043e:	e9 73 ff ff ff       	jmp    1003b6 <readline+0x2a>
        }
    }
}
  100443:	c9                   	leave  
  100444:	c3                   	ret    

00100445 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100445:	f3 0f 1e fb          	endbr32 
  100449:	55                   	push   %ebp
  10044a:	89 e5                	mov    %esp,%ebp
  10044c:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10044f:	a1 20 c4 11 00       	mov    0x11c420,%eax
  100454:	85 c0                	test   %eax,%eax
  100456:	75 5b                	jne    1004b3 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100458:	c7 05 20 c4 11 00 01 	movl   $0x1,0x11c420
  10045f:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100462:	8d 45 14             	lea    0x14(%ebp),%eax
  100465:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100468:	8b 45 0c             	mov    0xc(%ebp),%eax
  10046b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10046f:	8b 45 08             	mov    0x8(%ebp),%eax
  100472:	89 44 24 04          	mov    %eax,0x4(%esp)
  100476:	c7 04 24 ce 62 10 00 	movl   $0x1062ce,(%esp)
  10047d:	e8 57 fe ff ff       	call   1002d9 <cprintf>
    vcprintf(fmt, ap);
  100482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100485:	89 44 24 04          	mov    %eax,0x4(%esp)
  100489:	8b 45 10             	mov    0x10(%ebp),%eax
  10048c:	89 04 24             	mov    %eax,(%esp)
  10048f:	e8 0e fe ff ff       	call   1002a2 <vcprintf>
    cprintf("\n");
  100494:	c7 04 24 ea 62 10 00 	movl   $0x1062ea,(%esp)
  10049b:	e8 39 fe ff ff       	call   1002d9 <cprintf>
    
    cprintf("stack trackback:\n");
  1004a0:	c7 04 24 ec 62 10 00 	movl   $0x1062ec,(%esp)
  1004a7:	e8 2d fe ff ff       	call   1002d9 <cprintf>
    print_stackframe();
  1004ac:	e8 3d 06 00 00       	call   100aee <print_stackframe>
  1004b1:	eb 01                	jmp    1004b4 <__panic+0x6f>
        goto panic_dead;
  1004b3:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  1004b4:	e8 f6 14 00 00       	call   1019af <intr_disable>
    while (1) {
        kmonitor(NULL);
  1004b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1004c0:	e8 6f 08 00 00       	call   100d34 <kmonitor>
  1004c5:	eb f2                	jmp    1004b9 <__panic+0x74>

001004c7 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  1004c7:	f3 0f 1e fb          	endbr32 
  1004cb:	55                   	push   %ebp
  1004cc:	89 e5                	mov    %esp,%ebp
  1004ce:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  1004d1:	8d 45 14             	lea    0x14(%ebp),%eax
  1004d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  1004d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004da:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004de:	8b 45 08             	mov    0x8(%ebp),%eax
  1004e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004e5:	c7 04 24 fe 62 10 00 	movl   $0x1062fe,(%esp)
  1004ec:	e8 e8 fd ff ff       	call   1002d9 <cprintf>
    vcprintf(fmt, ap);
  1004f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004f8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004fb:	89 04 24             	mov    %eax,(%esp)
  1004fe:	e8 9f fd ff ff       	call   1002a2 <vcprintf>
    cprintf("\n");
  100503:	c7 04 24 ea 62 10 00 	movl   $0x1062ea,(%esp)
  10050a:	e8 ca fd ff ff       	call   1002d9 <cprintf>
    va_end(ap);
}
  10050f:	90                   	nop
  100510:	c9                   	leave  
  100511:	c3                   	ret    

00100512 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100512:	f3 0f 1e fb          	endbr32 
  100516:	55                   	push   %ebp
  100517:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100519:	a1 20 c4 11 00       	mov    0x11c420,%eax
}
  10051e:	5d                   	pop    %ebp
  10051f:	c3                   	ret    

00100520 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100520:	f3 0f 1e fb          	endbr32 
  100524:	55                   	push   %ebp
  100525:	89 e5                	mov    %esp,%ebp
  100527:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	8b 00                	mov    (%eax),%eax
  10052f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100532:	8b 45 10             	mov    0x10(%ebp),%eax
  100535:	8b 00                	mov    (%eax),%eax
  100537:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10053a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100541:	e9 ca 00 00 00       	jmp    100610 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100546:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100549:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10054c:	01 d0                	add    %edx,%eax
  10054e:	89 c2                	mov    %eax,%edx
  100550:	c1 ea 1f             	shr    $0x1f,%edx
  100553:	01 d0                	add    %edx,%eax
  100555:	d1 f8                	sar    %eax
  100557:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10055a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10055d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100560:	eb 03                	jmp    100565 <stab_binsearch+0x45>
            m --;
  100562:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100568:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10056b:	7c 1f                	jl     10058c <stab_binsearch+0x6c>
  10056d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100570:	89 d0                	mov    %edx,%eax
  100572:	01 c0                	add    %eax,%eax
  100574:	01 d0                	add    %edx,%eax
  100576:	c1 e0 02             	shl    $0x2,%eax
  100579:	89 c2                	mov    %eax,%edx
  10057b:	8b 45 08             	mov    0x8(%ebp),%eax
  10057e:	01 d0                	add    %edx,%eax
  100580:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100584:	0f b6 c0             	movzbl %al,%eax
  100587:	39 45 14             	cmp    %eax,0x14(%ebp)
  10058a:	75 d6                	jne    100562 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  10058c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10058f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100592:	7d 09                	jge    10059d <stab_binsearch+0x7d>
            l = true_m + 1;
  100594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100597:	40                   	inc    %eax
  100598:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10059b:	eb 73                	jmp    100610 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  10059d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1005a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005a7:	89 d0                	mov    %edx,%eax
  1005a9:	01 c0                	add    %eax,%eax
  1005ab:	01 d0                	add    %edx,%eax
  1005ad:	c1 e0 02             	shl    $0x2,%eax
  1005b0:	89 c2                	mov    %eax,%edx
  1005b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b5:	01 d0                	add    %edx,%eax
  1005b7:	8b 40 08             	mov    0x8(%eax),%eax
  1005ba:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005bd:	76 11                	jbe    1005d0 <stab_binsearch+0xb0>
            *region_left = m;
  1005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c5:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1005c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005ca:	40                   	inc    %eax
  1005cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005ce:	eb 40                	jmp    100610 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  1005d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005d3:	89 d0                	mov    %edx,%eax
  1005d5:	01 c0                	add    %eax,%eax
  1005d7:	01 d0                	add    %edx,%eax
  1005d9:	c1 e0 02             	shl    $0x2,%eax
  1005dc:	89 c2                	mov    %eax,%edx
  1005de:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e1:	01 d0                	add    %edx,%eax
  1005e3:	8b 40 08             	mov    0x8(%eax),%eax
  1005e6:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005e9:	73 14                	jae    1005ff <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1005f4:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005f9:	48                   	dec    %eax
  1005fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005fd:	eb 11                	jmp    100610 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100602:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100605:	89 10                	mov    %edx,(%eax)
            l = m;
  100607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10060a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10060d:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  100610:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100613:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100616:	0f 8e 2a ff ff ff    	jle    100546 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  10061c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100620:	75 0f                	jne    100631 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  100622:	8b 45 0c             	mov    0xc(%ebp),%eax
  100625:	8b 00                	mov    (%eax),%eax
  100627:	8d 50 ff             	lea    -0x1(%eax),%edx
  10062a:	8b 45 10             	mov    0x10(%ebp),%eax
  10062d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10062f:	eb 3e                	jmp    10066f <stab_binsearch+0x14f>
        l = *region_right;
  100631:	8b 45 10             	mov    0x10(%ebp),%eax
  100634:	8b 00                	mov    (%eax),%eax
  100636:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100639:	eb 03                	jmp    10063e <stab_binsearch+0x11e>
  10063b:	ff 4d fc             	decl   -0x4(%ebp)
  10063e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100641:	8b 00                	mov    (%eax),%eax
  100643:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100646:	7e 1f                	jle    100667 <stab_binsearch+0x147>
  100648:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10064b:	89 d0                	mov    %edx,%eax
  10064d:	01 c0                	add    %eax,%eax
  10064f:	01 d0                	add    %edx,%eax
  100651:	c1 e0 02             	shl    $0x2,%eax
  100654:	89 c2                	mov    %eax,%edx
  100656:	8b 45 08             	mov    0x8(%ebp),%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10065f:	0f b6 c0             	movzbl %al,%eax
  100662:	39 45 14             	cmp    %eax,0x14(%ebp)
  100665:	75 d4                	jne    10063b <stab_binsearch+0x11b>
        *region_left = l;
  100667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10066d:	89 10                	mov    %edx,(%eax)
}
  10066f:	90                   	nop
  100670:	c9                   	leave  
  100671:	c3                   	ret    

00100672 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100672:	f3 0f 1e fb          	endbr32 
  100676:	55                   	push   %ebp
  100677:	89 e5                	mov    %esp,%ebp
  100679:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10067c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067f:	c7 00 1c 63 10 00    	movl   $0x10631c,(%eax)
    info->eip_line = 0;
  100685:	8b 45 0c             	mov    0xc(%ebp),%eax
  100688:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10068f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100692:	c7 40 08 1c 63 10 00 	movl   $0x10631c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100699:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a6:	8b 55 08             	mov    0x8(%ebp),%edx
  1006a9:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1006b6:	c7 45 f4 98 75 10 00 	movl   $0x107598,-0xc(%ebp)
    stab_end = __STAB_END__;
  1006bd:	c7 45 f0 88 3f 11 00 	movl   $0x113f88,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006c4:	c7 45 ec 89 3f 11 00 	movl   $0x113f89,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006cb:	c7 45 e8 b9 6a 11 00 	movl   $0x116ab9,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1006d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1006d8:	76 0b                	jbe    1006e5 <debuginfo_eip+0x73>
  1006da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006dd:	48                   	dec    %eax
  1006de:	0f b6 00             	movzbl (%eax),%eax
  1006e1:	84 c0                	test   %al,%al
  1006e3:	74 0a                	je     1006ef <debuginfo_eip+0x7d>
        return -1;
  1006e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006ea:	e9 ab 02 00 00       	jmp    10099a <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006f9:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006fc:	c1 f8 02             	sar    $0x2,%eax
  1006ff:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100705:	48                   	dec    %eax
  100706:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100709:	8b 45 08             	mov    0x8(%ebp),%eax
  10070c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100710:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100717:	00 
  100718:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10071b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100722:	89 44 24 04          	mov    %eax,0x4(%esp)
  100726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100729:	89 04 24             	mov    %eax,(%esp)
  10072c:	e8 ef fd ff ff       	call   100520 <stab_binsearch>
    if (lfile == 0)
  100731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100734:	85 c0                	test   %eax,%eax
  100736:	75 0a                	jne    100742 <debuginfo_eip+0xd0>
        return -1;
  100738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10073d:	e9 58 02 00 00       	jmp    10099a <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100745:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100748:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10074e:	8b 45 08             	mov    0x8(%ebp),%eax
  100751:	89 44 24 10          	mov    %eax,0x10(%esp)
  100755:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10075c:	00 
  10075d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100760:	89 44 24 08          	mov    %eax,0x8(%esp)
  100764:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100767:	89 44 24 04          	mov    %eax,0x4(%esp)
  10076b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076e:	89 04 24             	mov    %eax,(%esp)
  100771:	e8 aa fd ff ff       	call   100520 <stab_binsearch>

    if (lfun <= rfun) {
  100776:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100779:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10077c:	39 c2                	cmp    %eax,%edx
  10077e:	7f 78                	jg     1007f8 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100780:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100783:	89 c2                	mov    %eax,%edx
  100785:	89 d0                	mov    %edx,%eax
  100787:	01 c0                	add    %eax,%eax
  100789:	01 d0                	add    %edx,%eax
  10078b:	c1 e0 02             	shl    $0x2,%eax
  10078e:	89 c2                	mov    %eax,%edx
  100790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100793:	01 d0                	add    %edx,%eax
  100795:	8b 10                	mov    (%eax),%edx
  100797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10079a:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10079d:	39 c2                	cmp    %eax,%edx
  10079f:	73 22                	jae    1007c3 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1007a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a4:	89 c2                	mov    %eax,%edx
  1007a6:	89 d0                	mov    %edx,%eax
  1007a8:	01 c0                	add    %eax,%eax
  1007aa:	01 d0                	add    %edx,%eax
  1007ac:	c1 e0 02             	shl    $0x2,%eax
  1007af:	89 c2                	mov    %eax,%edx
  1007b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b4:	01 d0                	add    %edx,%eax
  1007b6:	8b 10                	mov    (%eax),%edx
  1007b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007bb:	01 c2                	add    %eax,%edx
  1007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c0:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1007c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007c6:	89 c2                	mov    %eax,%edx
  1007c8:	89 d0                	mov    %edx,%eax
  1007ca:	01 c0                	add    %eax,%eax
  1007cc:	01 d0                	add    %edx,%eax
  1007ce:	c1 e0 02             	shl    $0x2,%eax
  1007d1:	89 c2                	mov    %eax,%edx
  1007d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d6:	01 d0                	add    %edx,%eax
  1007d8:	8b 50 08             	mov    0x8(%eax),%edx
  1007db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007de:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1007e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e4:	8b 40 10             	mov    0x10(%eax),%eax
  1007e7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007f6:	eb 15                	jmp    10080d <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007fb:	8b 55 08             	mov    0x8(%ebp),%edx
  1007fe:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100804:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100807:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10080a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100810:	8b 40 08             	mov    0x8(%eax),%eax
  100813:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  10081a:	00 
  10081b:	89 04 24             	mov    %eax,(%esp)
  10081e:	e8 3b 50 00 00       	call   10585e <strfind>
  100823:	8b 55 0c             	mov    0xc(%ebp),%edx
  100826:	8b 52 08             	mov    0x8(%edx),%edx
  100829:	29 d0                	sub    %edx,%eax
  10082b:	89 c2                	mov    %eax,%edx
  10082d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100830:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100833:	8b 45 08             	mov    0x8(%ebp),%eax
  100836:	89 44 24 10          	mov    %eax,0x10(%esp)
  10083a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100841:	00 
  100842:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100845:	89 44 24 08          	mov    %eax,0x8(%esp)
  100849:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10084c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100853:	89 04 24             	mov    %eax,(%esp)
  100856:	e8 c5 fc ff ff       	call   100520 <stab_binsearch>
    if (lline <= rline) {
  10085b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10085e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100861:	39 c2                	cmp    %eax,%edx
  100863:	7f 23                	jg     100888 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100865:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100868:	89 c2                	mov    %eax,%edx
  10086a:	89 d0                	mov    %edx,%eax
  10086c:	01 c0                	add    %eax,%eax
  10086e:	01 d0                	add    %edx,%eax
  100870:	c1 e0 02             	shl    $0x2,%eax
  100873:	89 c2                	mov    %eax,%edx
  100875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100878:	01 d0                	add    %edx,%eax
  10087a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	8b 45 0c             	mov    0xc(%ebp),%eax
  100883:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100886:	eb 11                	jmp    100899 <debuginfo_eip+0x227>
        return -1;
  100888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10088d:	e9 08 01 00 00       	jmp    10099a <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100892:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100895:	48                   	dec    %eax
  100896:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100899:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10089c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10089f:	39 c2                	cmp    %eax,%edx
  1008a1:	7c 56                	jl     1008f9 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  1008a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	89 d0                	mov    %edx,%eax
  1008aa:	01 c0                	add    %eax,%eax
  1008ac:	01 d0                	add    %edx,%eax
  1008ae:	c1 e0 02             	shl    $0x2,%eax
  1008b1:	89 c2                	mov    %eax,%edx
  1008b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008b6:	01 d0                	add    %edx,%eax
  1008b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008bc:	3c 84                	cmp    $0x84,%al
  1008be:	74 39                	je     1008f9 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1008c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c3:	89 c2                	mov    %eax,%edx
  1008c5:	89 d0                	mov    %edx,%eax
  1008c7:	01 c0                	add    %eax,%eax
  1008c9:	01 d0                	add    %edx,%eax
  1008cb:	c1 e0 02             	shl    $0x2,%eax
  1008ce:	89 c2                	mov    %eax,%edx
  1008d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d3:	01 d0                	add    %edx,%eax
  1008d5:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008d9:	3c 64                	cmp    $0x64,%al
  1008db:	75 b5                	jne    100892 <debuginfo_eip+0x220>
  1008dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e0:	89 c2                	mov    %eax,%edx
  1008e2:	89 d0                	mov    %edx,%eax
  1008e4:	01 c0                	add    %eax,%eax
  1008e6:	01 d0                	add    %edx,%eax
  1008e8:	c1 e0 02             	shl    $0x2,%eax
  1008eb:	89 c2                	mov    %eax,%edx
  1008ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f0:	01 d0                	add    %edx,%eax
  1008f2:	8b 40 08             	mov    0x8(%eax),%eax
  1008f5:	85 c0                	test   %eax,%eax
  1008f7:	74 99                	je     100892 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008ff:	39 c2                	cmp    %eax,%edx
  100901:	7c 42                	jl     100945 <debuginfo_eip+0x2d3>
  100903:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100906:	89 c2                	mov    %eax,%edx
  100908:	89 d0                	mov    %edx,%eax
  10090a:	01 c0                	add    %eax,%eax
  10090c:	01 d0                	add    %edx,%eax
  10090e:	c1 e0 02             	shl    $0x2,%eax
  100911:	89 c2                	mov    %eax,%edx
  100913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100916:	01 d0                	add    %edx,%eax
  100918:	8b 10                	mov    (%eax),%edx
  10091a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10091d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100920:	39 c2                	cmp    %eax,%edx
  100922:	73 21                	jae    100945 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100924:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100927:	89 c2                	mov    %eax,%edx
  100929:	89 d0                	mov    %edx,%eax
  10092b:	01 c0                	add    %eax,%eax
  10092d:	01 d0                	add    %edx,%eax
  10092f:	c1 e0 02             	shl    $0x2,%eax
  100932:	89 c2                	mov    %eax,%edx
  100934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100937:	01 d0                	add    %edx,%eax
  100939:	8b 10                	mov    (%eax),%edx
  10093b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10093e:	01 c2                	add    %eax,%edx
  100940:	8b 45 0c             	mov    0xc(%ebp),%eax
  100943:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100945:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100948:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10094b:	39 c2                	cmp    %eax,%edx
  10094d:	7d 46                	jge    100995 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10094f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100952:	40                   	inc    %eax
  100953:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100956:	eb 16                	jmp    10096e <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100958:	8b 45 0c             	mov    0xc(%ebp),%eax
  10095b:	8b 40 14             	mov    0x14(%eax),%eax
  10095e:	8d 50 01             	lea    0x1(%eax),%edx
  100961:	8b 45 0c             	mov    0xc(%ebp),%eax
  100964:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100967:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10096a:	40                   	inc    %eax
  10096b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10096e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100971:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100974:	39 c2                	cmp    %eax,%edx
  100976:	7d 1d                	jge    100995 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100978:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10097b:	89 c2                	mov    %eax,%edx
  10097d:	89 d0                	mov    %edx,%eax
  10097f:	01 c0                	add    %eax,%eax
  100981:	01 d0                	add    %edx,%eax
  100983:	c1 e0 02             	shl    $0x2,%eax
  100986:	89 c2                	mov    %eax,%edx
  100988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10098b:	01 d0                	add    %edx,%eax
  10098d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100991:	3c a0                	cmp    $0xa0,%al
  100993:	74 c3                	je     100958 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100995:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10099a:	c9                   	leave  
  10099b:	c3                   	ret    

0010099c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10099c:	f3 0f 1e fb          	endbr32 
  1009a0:	55                   	push   %ebp
  1009a1:	89 e5                	mov    %esp,%ebp
  1009a3:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1009a6:	c7 04 24 26 63 10 00 	movl   $0x106326,(%esp)
  1009ad:	e8 27 f9 ff ff       	call   1002d9 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1009b2:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1009b9:	00 
  1009ba:	c7 04 24 3f 63 10 00 	movl   $0x10633f,(%esp)
  1009c1:	e8 13 f9 ff ff       	call   1002d9 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009c6:	c7 44 24 04 0e 62 10 	movl   $0x10620e,0x4(%esp)
  1009cd:	00 
  1009ce:	c7 04 24 57 63 10 00 	movl   $0x106357,(%esp)
  1009d5:	e8 ff f8 ff ff       	call   1002d9 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009da:	c7 44 24 04 36 9a 11 	movl   $0x119a36,0x4(%esp)
  1009e1:	00 
  1009e2:	c7 04 24 6f 63 10 00 	movl   $0x10636f,(%esp)
  1009e9:	e8 eb f8 ff ff       	call   1002d9 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009ee:	c7 44 24 04 28 cf 11 	movl   $0x11cf28,0x4(%esp)
  1009f5:	00 
  1009f6:	c7 04 24 87 63 10 00 	movl   $0x106387,(%esp)
  1009fd:	e8 d7 f8 ff ff       	call   1002d9 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100a02:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  100a07:	2d 36 00 10 00       	sub    $0x100036,%eax
  100a0c:	05 ff 03 00 00       	add    $0x3ff,%eax
  100a11:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100a17:	85 c0                	test   %eax,%eax
  100a19:	0f 48 c2             	cmovs  %edx,%eax
  100a1c:	c1 f8 0a             	sar    $0xa,%eax
  100a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a23:	c7 04 24 a0 63 10 00 	movl   $0x1063a0,(%esp)
  100a2a:	e8 aa f8 ff ff       	call   1002d9 <cprintf>
}
  100a2f:	90                   	nop
  100a30:	c9                   	leave  
  100a31:	c3                   	ret    

00100a32 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100a32:	f3 0f 1e fb          	endbr32 
  100a36:	55                   	push   %ebp
  100a37:	89 e5                	mov    %esp,%ebp
  100a39:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100a3f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a46:	8b 45 08             	mov    0x8(%ebp),%eax
  100a49:	89 04 24             	mov    %eax,(%esp)
  100a4c:	e8 21 fc ff ff       	call   100672 <debuginfo_eip>
  100a51:	85 c0                	test   %eax,%eax
  100a53:	74 15                	je     100a6a <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a55:	8b 45 08             	mov    0x8(%ebp),%eax
  100a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a5c:	c7 04 24 ca 63 10 00 	movl   $0x1063ca,(%esp)
  100a63:	e8 71 f8 ff ff       	call   1002d9 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a68:	eb 6c                	jmp    100ad6 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a71:	eb 1b                	jmp    100a8e <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a79:	01 d0                	add    %edx,%eax
  100a7b:	0f b6 10             	movzbl (%eax),%edx
  100a7e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a87:	01 c8                	add    %ecx,%eax
  100a89:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a8b:	ff 45 f4             	incl   -0xc(%ebp)
  100a8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a91:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a94:	7c dd                	jl     100a73 <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a96:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a9f:	01 d0                	add    %edx,%eax
  100aa1:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100aa7:	8b 55 08             	mov    0x8(%ebp),%edx
  100aaa:	89 d1                	mov    %edx,%ecx
  100aac:	29 c1                	sub    %eax,%ecx
  100aae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100ab1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100ab4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100ab8:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100abe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100ac2:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aca:	c7 04 24 e6 63 10 00 	movl   $0x1063e6,(%esp)
  100ad1:	e8 03 f8 ff ff       	call   1002d9 <cprintf>
}
  100ad6:	90                   	nop
  100ad7:	c9                   	leave  
  100ad8:	c3                   	ret    

00100ad9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100ad9:	f3 0f 1e fb          	endbr32 
  100add:	55                   	push   %ebp
  100ade:	89 e5                	mov    %esp,%ebp
  100ae0:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100ae3:	8b 45 04             	mov    0x4(%ebp),%eax
  100ae6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100aec:	c9                   	leave  
  100aed:	c3                   	ret    

00100aee <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100aee:	f3 0f 1e fb          	endbr32 
  100af2:	55                   	push   %ebp
  100af3:	89 e5                	mov    %esp,%ebp
  100af5:	53                   	push   %ebx
  100af6:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100af9:	89 e8                	mov    %ebp,%eax
  100afb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp();
  100b01:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip = read_eip();
  100b04:	e8 d0 ff ff ff       	call   100ad9 <read_eip>
  100b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
     for(int i =0;i<=STACKFRAME_DEPTH;i++)
  100b0c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100b13:	e9 94 00 00 00       	jmp    100bac <print_stackframe+0xbe>
     {
        if(ebp==0)
  100b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b1c:	0f 84 96 00 00 00    	je     100bb8 <print_stackframe+0xca>
        {
            break;
        }    
        cprintf("ebp:0x%08x eip:0x%08x",ebp,eip);
  100b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b25:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b30:	c7 04 24 f8 63 10 00 	movl   $0x1063f8,(%esp)
  100b37:	e8 9d f7 ff ff       	call   1002d9 <cprintf>
        uint32_t *argu;
        argu = (uint32_t)ebp +2;
  100b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b3f:	83 c0 02             	add    $0x2,%eax
  100b42:	89 45 e8             	mov    %eax,-0x18(%ebp)
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x",argu[0],argu[1],argu[2],argu[3]);
  100b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b48:	83 c0 0c             	add    $0xc,%eax
  100b4b:	8b 18                	mov    (%eax),%ebx
  100b4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b50:	83 c0 08             	add    $0x8,%eax
  100b53:	8b 08                	mov    (%eax),%ecx
  100b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b58:	83 c0 04             	add    $0x4,%eax
  100b5b:	8b 10                	mov    (%eax),%edx
  100b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b60:	8b 00                	mov    (%eax),%eax
  100b62:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100b66:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100b6a:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b72:	c7 04 24 10 64 10 00 	movl   $0x106410,(%esp)
  100b79:	e8 5b f7 ff ff       	call   1002d9 <cprintf>
        cprintf("\n");
  100b7e:	c7 04 24 31 64 10 00 	movl   $0x106431,(%esp)
  100b85:	e8 4f f7 ff ff       	call   1002d9 <cprintf>
        print_debuginfo(eip-1);
  100b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b8d:	48                   	dec    %eax
  100b8e:	89 04 24             	mov    %eax,(%esp)
  100b91:	e8 9c fe ff ff       	call   100a32 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b99:	83 c0 04             	add    $0x4,%eax
  100b9c:	8b 00                	mov    (%eax),%eax
  100b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];      
  100ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba4:	8b 00                	mov    (%eax),%eax
  100ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     for(int i =0;i<=STACKFRAME_DEPTH;i++)
  100ba9:	ff 45 ec             	incl   -0x14(%ebp)
  100bac:	83 7d ec 14          	cmpl   $0x14,-0x14(%ebp)
  100bb0:	0f 8e 62 ff ff ff    	jle    100b18 <print_stackframe+0x2a>
     }
}
  100bb6:	eb 01                	jmp    100bb9 <print_stackframe+0xcb>
            break;
  100bb8:	90                   	nop
}
  100bb9:	90                   	nop
  100bba:	83 c4 44             	add    $0x44,%esp
  100bbd:	5b                   	pop    %ebx
  100bbe:	5d                   	pop    %ebp
  100bbf:	c3                   	ret    

00100bc0 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100bc0:	f3 0f 1e fb          	endbr32 
  100bc4:	55                   	push   %ebp
  100bc5:	89 e5                	mov    %esp,%ebp
  100bc7:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bd1:	eb 0c                	jmp    100bdf <parse+0x1f>
            *buf ++ = '\0';
  100bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd6:	8d 50 01             	lea    0x1(%eax),%edx
  100bd9:	89 55 08             	mov    %edx,0x8(%ebp)
  100bdc:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  100be2:	0f b6 00             	movzbl (%eax),%eax
  100be5:	84 c0                	test   %al,%al
  100be7:	74 1d                	je     100c06 <parse+0x46>
  100be9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bec:	0f b6 00             	movzbl (%eax),%eax
  100bef:	0f be c0             	movsbl %al,%eax
  100bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bf6:	c7 04 24 b4 64 10 00 	movl   $0x1064b4,(%esp)
  100bfd:	e8 26 4c 00 00       	call   105828 <strchr>
  100c02:	85 c0                	test   %eax,%eax
  100c04:	75 cd                	jne    100bd3 <parse+0x13>
        }
        if (*buf == '\0') {
  100c06:	8b 45 08             	mov    0x8(%ebp),%eax
  100c09:	0f b6 00             	movzbl (%eax),%eax
  100c0c:	84 c0                	test   %al,%al
  100c0e:	74 65                	je     100c75 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100c10:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100c14:	75 14                	jne    100c2a <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100c16:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100c1d:	00 
  100c1e:	c7 04 24 b9 64 10 00 	movl   $0x1064b9,(%esp)
  100c25:	e8 af f6 ff ff       	call   1002d9 <cprintf>
        }
        argv[argc ++] = buf;
  100c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c2d:	8d 50 01             	lea    0x1(%eax),%edx
  100c30:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100c33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c3d:	01 c2                	add    %eax,%edx
  100c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c42:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c44:	eb 03                	jmp    100c49 <parse+0x89>
            buf ++;
  100c46:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c49:	8b 45 08             	mov    0x8(%ebp),%eax
  100c4c:	0f b6 00             	movzbl (%eax),%eax
  100c4f:	84 c0                	test   %al,%al
  100c51:	74 8c                	je     100bdf <parse+0x1f>
  100c53:	8b 45 08             	mov    0x8(%ebp),%eax
  100c56:	0f b6 00             	movzbl (%eax),%eax
  100c59:	0f be c0             	movsbl %al,%eax
  100c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c60:	c7 04 24 b4 64 10 00 	movl   $0x1064b4,(%esp)
  100c67:	e8 bc 4b 00 00       	call   105828 <strchr>
  100c6c:	85 c0                	test   %eax,%eax
  100c6e:	74 d6                	je     100c46 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c70:	e9 6a ff ff ff       	jmp    100bdf <parse+0x1f>
            break;
  100c75:	90                   	nop
        }
    }
    return argc;
  100c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c79:	c9                   	leave  
  100c7a:	c3                   	ret    

00100c7b <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c7b:	f3 0f 1e fb          	endbr32 
  100c7f:	55                   	push   %ebp
  100c80:	89 e5                	mov    %esp,%ebp
  100c82:	53                   	push   %ebx
  100c83:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c86:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  100c90:	89 04 24             	mov    %eax,(%esp)
  100c93:	e8 28 ff ff ff       	call   100bc0 <parse>
  100c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c9f:	75 0a                	jne    100cab <runcmd+0x30>
        return 0;
  100ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  100ca6:	e9 83 00 00 00       	jmp    100d2e <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cb2:	eb 5a                	jmp    100d0e <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100cb4:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cba:	89 d0                	mov    %edx,%eax
  100cbc:	01 c0                	add    %eax,%eax
  100cbe:	01 d0                	add    %edx,%eax
  100cc0:	c1 e0 02             	shl    $0x2,%eax
  100cc3:	05 00 90 11 00       	add    $0x119000,%eax
  100cc8:	8b 00                	mov    (%eax),%eax
  100cca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100cce:	89 04 24             	mov    %eax,(%esp)
  100cd1:	e8 ae 4a 00 00       	call   105784 <strcmp>
  100cd6:	85 c0                	test   %eax,%eax
  100cd8:	75 31                	jne    100d0b <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100cda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cdd:	89 d0                	mov    %edx,%eax
  100cdf:	01 c0                	add    %eax,%eax
  100ce1:	01 d0                	add    %edx,%eax
  100ce3:	c1 e0 02             	shl    $0x2,%eax
  100ce6:	05 08 90 11 00       	add    $0x119008,%eax
  100ceb:	8b 10                	mov    (%eax),%edx
  100ced:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cf0:	83 c0 04             	add    $0x4,%eax
  100cf3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100cf6:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cfc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d00:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d04:	89 1c 24             	mov    %ebx,(%esp)
  100d07:	ff d2                	call   *%edx
  100d09:	eb 23                	jmp    100d2e <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d0b:	ff 45 f4             	incl   -0xc(%ebp)
  100d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d11:	83 f8 02             	cmp    $0x2,%eax
  100d14:	76 9e                	jbe    100cb4 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100d16:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d1d:	c7 04 24 d7 64 10 00 	movl   $0x1064d7,(%esp)
  100d24:	e8 b0 f5 ff ff       	call   1002d9 <cprintf>
    return 0;
  100d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2e:	83 c4 64             	add    $0x64,%esp
  100d31:	5b                   	pop    %ebx
  100d32:	5d                   	pop    %ebp
  100d33:	c3                   	ret    

00100d34 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100d34:	f3 0f 1e fb          	endbr32 
  100d38:	55                   	push   %ebp
  100d39:	89 e5                	mov    %esp,%ebp
  100d3b:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d3e:	c7 04 24 f0 64 10 00 	movl   $0x1064f0,(%esp)
  100d45:	e8 8f f5 ff ff       	call   1002d9 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d4a:	c7 04 24 18 65 10 00 	movl   $0x106518,(%esp)
  100d51:	e8 83 f5 ff ff       	call   1002d9 <cprintf>

    if (tf != NULL) {
  100d56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d5a:	74 0b                	je     100d67 <kmonitor+0x33>
        print_trapframe(tf);
  100d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d5f:	89 04 24             	mov    %eax,(%esp)
  100d62:	e8 5e 0e 00 00       	call   101bc5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d67:	c7 04 24 3d 65 10 00 	movl   $0x10653d,(%esp)
  100d6e:	e8 19 f6 ff ff       	call   10038c <readline>
  100d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d7a:	74 eb                	je     100d67 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d86:	89 04 24             	mov    %eax,(%esp)
  100d89:	e8 ed fe ff ff       	call   100c7b <runcmd>
  100d8e:	85 c0                	test   %eax,%eax
  100d90:	78 02                	js     100d94 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d92:	eb d3                	jmp    100d67 <kmonitor+0x33>
                break;
  100d94:	90                   	nop
            }
        }
    }
}
  100d95:	90                   	nop
  100d96:	c9                   	leave  
  100d97:	c3                   	ret    

00100d98 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d98:	f3 0f 1e fb          	endbr32 
  100d9c:	55                   	push   %ebp
  100d9d:	89 e5                	mov    %esp,%ebp
  100d9f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100da2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100da9:	eb 3d                	jmp    100de8 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100dab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100dae:	89 d0                	mov    %edx,%eax
  100db0:	01 c0                	add    %eax,%eax
  100db2:	01 d0                	add    %edx,%eax
  100db4:	c1 e0 02             	shl    $0x2,%eax
  100db7:	05 04 90 11 00       	add    $0x119004,%eax
  100dbc:	8b 08                	mov    (%eax),%ecx
  100dbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100dc1:	89 d0                	mov    %edx,%eax
  100dc3:	01 c0                	add    %eax,%eax
  100dc5:	01 d0                	add    %edx,%eax
  100dc7:	c1 e0 02             	shl    $0x2,%eax
  100dca:	05 00 90 11 00       	add    $0x119000,%eax
  100dcf:	8b 00                	mov    (%eax),%eax
  100dd1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100dd9:	c7 04 24 41 65 10 00 	movl   $0x106541,(%esp)
  100de0:	e8 f4 f4 ff ff       	call   1002d9 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100de5:	ff 45 f4             	incl   -0xc(%ebp)
  100de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100deb:	83 f8 02             	cmp    $0x2,%eax
  100dee:	76 bb                	jbe    100dab <mon_help+0x13>
    }
    return 0;
  100df0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df5:	c9                   	leave  
  100df6:	c3                   	ret    

00100df7 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100df7:	f3 0f 1e fb          	endbr32 
  100dfb:	55                   	push   %ebp
  100dfc:	89 e5                	mov    %esp,%ebp
  100dfe:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100e01:	e8 96 fb ff ff       	call   10099c <print_kerninfo>
    return 0;
  100e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e0b:	c9                   	leave  
  100e0c:	c3                   	ret    

00100e0d <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100e0d:	f3 0f 1e fb          	endbr32 
  100e11:	55                   	push   %ebp
  100e12:	89 e5                	mov    %esp,%ebp
  100e14:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100e17:	e8 d2 fc ff ff       	call   100aee <print_stackframe>
    return 0;
  100e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e21:	c9                   	leave  
  100e22:	c3                   	ret    

00100e23 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100e23:	f3 0f 1e fb          	endbr32 
  100e27:	55                   	push   %ebp
  100e28:	89 e5                	mov    %esp,%ebp
  100e2a:	83 ec 28             	sub    $0x28,%esp
  100e2d:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100e33:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e37:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e3b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e3f:	ee                   	out    %al,(%dx)
}
  100e40:	90                   	nop
  100e41:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e47:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e4b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e4f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e53:	ee                   	out    %al,(%dx)
}
  100e54:	90                   	nop
  100e55:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e5b:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e5f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e63:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e67:	ee                   	out    %al,(%dx)
}
  100e68:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e69:	c7 05 0c cf 11 00 00 	movl   $0x0,0x11cf0c
  100e70:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e73:	c7 04 24 4a 65 10 00 	movl   $0x10654a,(%esp)
  100e7a:	e8 5a f4 ff ff       	call   1002d9 <cprintf>
    pic_enable(IRQ_TIMER);
  100e7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e86:	e8 95 09 00 00       	call   101820 <pic_enable>
}
  100e8b:	90                   	nop
  100e8c:	c9                   	leave  
  100e8d:	c3                   	ret    

00100e8e <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e8e:	55                   	push   %ebp
  100e8f:	89 e5                	mov    %esp,%ebp
  100e91:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e94:	9c                   	pushf  
  100e95:	58                   	pop    %eax
  100e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e9c:	25 00 02 00 00       	and    $0x200,%eax
  100ea1:	85 c0                	test   %eax,%eax
  100ea3:	74 0c                	je     100eb1 <__intr_save+0x23>
        intr_disable();
  100ea5:	e8 05 0b 00 00       	call   1019af <intr_disable>
        return 1;
  100eaa:	b8 01 00 00 00       	mov    $0x1,%eax
  100eaf:	eb 05                	jmp    100eb6 <__intr_save+0x28>
    }
    return 0;
  100eb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100eb6:	c9                   	leave  
  100eb7:	c3                   	ret    

00100eb8 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100eb8:	55                   	push   %ebp
  100eb9:	89 e5                	mov    %esp,%ebp
  100ebb:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100ebe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ec2:	74 05                	je     100ec9 <__intr_restore+0x11>
        intr_enable();
  100ec4:	e8 da 0a 00 00       	call   1019a3 <intr_enable>
    }
}
  100ec9:	90                   	nop
  100eca:	c9                   	leave  
  100ecb:	c3                   	ret    

00100ecc <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ecc:	f3 0f 1e fb          	endbr32 
  100ed0:	55                   	push   %ebp
  100ed1:	89 e5                	mov    %esp,%ebp
  100ed3:	83 ec 10             	sub    $0x10,%esp
  100ed6:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100edc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ee0:	89 c2                	mov    %eax,%edx
  100ee2:	ec                   	in     (%dx),%al
  100ee3:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ee6:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100eec:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ef0:	89 c2                	mov    %eax,%edx
  100ef2:	ec                   	in     (%dx),%al
  100ef3:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ef6:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100efc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100f00:	89 c2                	mov    %eax,%edx
  100f02:	ec                   	in     (%dx),%al
  100f03:	88 45 f9             	mov    %al,-0x7(%ebp)
  100f06:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100f0c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100f10:	89 c2                	mov    %eax,%edx
  100f12:	ec                   	in     (%dx),%al
  100f13:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100f16:	90                   	nop
  100f17:	c9                   	leave  
  100f18:	c3                   	ret    

00100f19 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100f19:	f3 0f 1e fb          	endbr32 
  100f1d:	55                   	push   %ebp
  100f1e:	89 e5                	mov    %esp,%ebp
  100f20:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100f23:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f2d:	0f b7 00             	movzwl (%eax),%eax
  100f30:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f37:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f3f:	0f b7 00             	movzwl (%eax),%eax
  100f42:	0f b7 c0             	movzwl %ax,%eax
  100f45:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100f4a:	74 12                	je     100f5e <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100f4c:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100f53:	66 c7 05 46 c4 11 00 	movw   $0x3b4,0x11c446
  100f5a:	b4 03 
  100f5c:	eb 13                	jmp    100f71 <cga_init+0x58>
    } else {
        *cp = was;
  100f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f61:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f65:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f68:	66 c7 05 46 c4 11 00 	movw   $0x3d4,0x11c446
  100f6f:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f71:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f78:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f7c:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f80:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f84:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f88:	ee                   	out    %al,(%dx)
}
  100f89:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f8a:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f91:	40                   	inc    %eax
  100f92:	0f b7 c0             	movzwl %ax,%eax
  100f95:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f99:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f9d:	89 c2                	mov    %eax,%edx
  100f9f:	ec                   	in     (%dx),%al
  100fa0:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100fa3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa7:	0f b6 c0             	movzbl %al,%eax
  100faa:	c1 e0 08             	shl    $0x8,%eax
  100fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100fb0:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100fb7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100fbb:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fbf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fc3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fc7:	ee                   	out    %al,(%dx)
}
  100fc8:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100fc9:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100fd0:	40                   	inc    %eax
  100fd1:	0f b7 c0             	movzwl %ax,%eax
  100fd4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fd8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fdc:	89 c2                	mov    %eax,%edx
  100fde:	ec                   	in     (%dx),%al
  100fdf:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100fe2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fe6:	0f b6 c0             	movzbl %al,%eax
  100fe9:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100fec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fef:	a3 40 c4 11 00       	mov    %eax,0x11c440
    crt_pos = pos;
  100ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ff7:	0f b7 c0             	movzwl %ax,%eax
  100ffa:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
}
  101000:	90                   	nop
  101001:	c9                   	leave  
  101002:	c3                   	ret    

00101003 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  101003:	f3 0f 1e fb          	endbr32 
  101007:	55                   	push   %ebp
  101008:	89 e5                	mov    %esp,%ebp
  10100a:	83 ec 48             	sub    $0x48,%esp
  10100d:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  101013:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101017:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10101b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10101f:	ee                   	out    %al,(%dx)
}
  101020:	90                   	nop
  101021:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  101027:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10102b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10102f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101033:	ee                   	out    %al,(%dx)
}
  101034:	90                   	nop
  101035:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  10103b:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10103f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101043:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101047:	ee                   	out    %al,(%dx)
}
  101048:	90                   	nop
  101049:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  10104f:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101053:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101057:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10105b:	ee                   	out    %al,(%dx)
}
  10105c:	90                   	nop
  10105d:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  101063:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101067:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10106b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10106f:	ee                   	out    %al,(%dx)
}
  101070:	90                   	nop
  101071:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101077:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10107b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10107f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101083:	ee                   	out    %al,(%dx)
}
  101084:	90                   	nop
  101085:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  10108b:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10108f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101093:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101097:	ee                   	out    %al,(%dx)
}
  101098:	90                   	nop
  101099:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10109f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  1010a3:	89 c2                	mov    %eax,%edx
  1010a5:	ec                   	in     (%dx),%al
  1010a6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  1010a9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  1010ad:	3c ff                	cmp    $0xff,%al
  1010af:	0f 95 c0             	setne  %al
  1010b2:	0f b6 c0             	movzbl %al,%eax
  1010b5:	a3 48 c4 11 00       	mov    %eax,0x11c448
  1010ba:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1010c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1010c4:	89 c2                	mov    %eax,%edx
  1010c6:	ec                   	in     (%dx),%al
  1010c7:	88 45 f1             	mov    %al,-0xf(%ebp)
  1010ca:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1010d0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1010d4:	89 c2                	mov    %eax,%edx
  1010d6:	ec                   	in     (%dx),%al
  1010d7:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1010da:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1010df:	85 c0                	test   %eax,%eax
  1010e1:	74 0c                	je     1010ef <serial_init+0xec>
        pic_enable(IRQ_COM1);
  1010e3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1010ea:	e8 31 07 00 00       	call   101820 <pic_enable>
    }
}
  1010ef:	90                   	nop
  1010f0:	c9                   	leave  
  1010f1:	c3                   	ret    

001010f2 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1010f2:	f3 0f 1e fb          	endbr32 
  1010f6:	55                   	push   %ebp
  1010f7:	89 e5                	mov    %esp,%ebp
  1010f9:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101103:	eb 08                	jmp    10110d <lpt_putc_sub+0x1b>
        delay();
  101105:	e8 c2 fd ff ff       	call   100ecc <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10110a:	ff 45 fc             	incl   -0x4(%ebp)
  10110d:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101113:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101117:	89 c2                	mov    %eax,%edx
  101119:	ec                   	in     (%dx),%al
  10111a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10111d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101121:	84 c0                	test   %al,%al
  101123:	78 09                	js     10112e <lpt_putc_sub+0x3c>
  101125:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10112c:	7e d7                	jle    101105 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  10112e:	8b 45 08             	mov    0x8(%ebp),%eax
  101131:	0f b6 c0             	movzbl %al,%eax
  101134:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10113a:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10113d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101141:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101145:	ee                   	out    %al,(%dx)
}
  101146:	90                   	nop
  101147:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10114d:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101151:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101155:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101159:	ee                   	out    %al,(%dx)
}
  10115a:	90                   	nop
  10115b:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101161:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101165:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101169:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10116d:	ee                   	out    %al,(%dx)
}
  10116e:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10116f:	90                   	nop
  101170:	c9                   	leave  
  101171:	c3                   	ret    

00101172 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101172:	f3 0f 1e fb          	endbr32 
  101176:	55                   	push   %ebp
  101177:	89 e5                	mov    %esp,%ebp
  101179:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10117c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101180:	74 0d                	je     10118f <lpt_putc+0x1d>
        lpt_putc_sub(c);
  101182:	8b 45 08             	mov    0x8(%ebp),%eax
  101185:	89 04 24             	mov    %eax,(%esp)
  101188:	e8 65 ff ff ff       	call   1010f2 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10118d:	eb 24                	jmp    1011b3 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  10118f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101196:	e8 57 ff ff ff       	call   1010f2 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10119b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1011a2:	e8 4b ff ff ff       	call   1010f2 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1011a7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1011ae:	e8 3f ff ff ff       	call   1010f2 <lpt_putc_sub>
}
  1011b3:	90                   	nop
  1011b4:	c9                   	leave  
  1011b5:	c3                   	ret    

001011b6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1011b6:	f3 0f 1e fb          	endbr32 
  1011ba:	55                   	push   %ebp
  1011bb:	89 e5                	mov    %esp,%ebp
  1011bd:	53                   	push   %ebx
  1011be:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c4:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011c9:	85 c0                	test   %eax,%eax
  1011cb:	75 07                	jne    1011d4 <cga_putc+0x1e>
        c |= 0x0700;
  1011cd:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1011d7:	0f b6 c0             	movzbl %al,%eax
  1011da:	83 f8 0d             	cmp    $0xd,%eax
  1011dd:	74 72                	je     101251 <cga_putc+0x9b>
  1011df:	83 f8 0d             	cmp    $0xd,%eax
  1011e2:	0f 8f a3 00 00 00    	jg     10128b <cga_putc+0xd5>
  1011e8:	83 f8 08             	cmp    $0x8,%eax
  1011eb:	74 0a                	je     1011f7 <cga_putc+0x41>
  1011ed:	83 f8 0a             	cmp    $0xa,%eax
  1011f0:	74 4c                	je     10123e <cga_putc+0x88>
  1011f2:	e9 94 00 00 00       	jmp    10128b <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  1011f7:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011fe:	85 c0                	test   %eax,%eax
  101200:	0f 84 af 00 00 00    	je     1012b5 <cga_putc+0xff>
            crt_pos --;
  101206:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10120d:	48                   	dec    %eax
  10120e:	0f b7 c0             	movzwl %ax,%eax
  101211:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101217:	8b 45 08             	mov    0x8(%ebp),%eax
  10121a:	98                   	cwtl   
  10121b:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101220:	98                   	cwtl   
  101221:	83 c8 20             	or     $0x20,%eax
  101224:	98                   	cwtl   
  101225:	8b 15 40 c4 11 00    	mov    0x11c440,%edx
  10122b:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  101232:	01 c9                	add    %ecx,%ecx
  101234:	01 ca                	add    %ecx,%edx
  101236:	0f b7 c0             	movzwl %ax,%eax
  101239:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10123c:	eb 77                	jmp    1012b5 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  10123e:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101245:	83 c0 50             	add    $0x50,%eax
  101248:	0f b7 c0             	movzwl %ax,%eax
  10124b:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101251:	0f b7 1d 44 c4 11 00 	movzwl 0x11c444,%ebx
  101258:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  10125f:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101264:	89 c8                	mov    %ecx,%eax
  101266:	f7 e2                	mul    %edx
  101268:	c1 ea 06             	shr    $0x6,%edx
  10126b:	89 d0                	mov    %edx,%eax
  10126d:	c1 e0 02             	shl    $0x2,%eax
  101270:	01 d0                	add    %edx,%eax
  101272:	c1 e0 04             	shl    $0x4,%eax
  101275:	29 c1                	sub    %eax,%ecx
  101277:	89 c8                	mov    %ecx,%eax
  101279:	0f b7 c0             	movzwl %ax,%eax
  10127c:	29 c3                	sub    %eax,%ebx
  10127e:	89 d8                	mov    %ebx,%eax
  101280:	0f b7 c0             	movzwl %ax,%eax
  101283:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
        break;
  101289:	eb 2b                	jmp    1012b6 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10128b:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  101291:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101298:	8d 50 01             	lea    0x1(%eax),%edx
  10129b:	0f b7 d2             	movzwl %dx,%edx
  10129e:	66 89 15 44 c4 11 00 	mov    %dx,0x11c444
  1012a5:	01 c0                	add    %eax,%eax
  1012a7:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ad:	0f b7 c0             	movzwl %ax,%eax
  1012b0:	66 89 02             	mov    %ax,(%edx)
        break;
  1012b3:	eb 01                	jmp    1012b6 <cga_putc+0x100>
        break;
  1012b5:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1012b6:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1012bd:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1012c2:	76 5d                	jbe    101321 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1012c4:	a1 40 c4 11 00       	mov    0x11c440,%eax
  1012c9:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1012cf:	a1 40 c4 11 00       	mov    0x11c440,%eax
  1012d4:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1012db:	00 
  1012dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1012e0:	89 04 24             	mov    %eax,(%esp)
  1012e3:	e8 45 47 00 00       	call   105a2d <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012e8:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1012ef:	eb 14                	jmp    101305 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  1012f1:	a1 40 c4 11 00       	mov    0x11c440,%eax
  1012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012f9:	01 d2                	add    %edx,%edx
  1012fb:	01 d0                	add    %edx,%eax
  1012fd:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101302:	ff 45 f4             	incl   -0xc(%ebp)
  101305:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10130c:	7e e3                	jle    1012f1 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  10130e:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101315:	83 e8 50             	sub    $0x50,%eax
  101318:	0f b7 c0             	movzwl %ax,%eax
  10131b:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101321:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  101328:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10132c:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101330:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101334:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101338:	ee                   	out    %al,(%dx)
}
  101339:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  10133a:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101341:	c1 e8 08             	shr    $0x8,%eax
  101344:	0f b7 c0             	movzwl %ax,%eax
  101347:	0f b6 c0             	movzbl %al,%eax
  10134a:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  101351:	42                   	inc    %edx
  101352:	0f b7 d2             	movzwl %dx,%edx
  101355:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101359:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10135c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101360:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101364:	ee                   	out    %al,(%dx)
}
  101365:	90                   	nop
    outb(addr_6845, 15);
  101366:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  10136d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101371:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101375:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101379:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10137d:	ee                   	out    %al,(%dx)
}
  10137e:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  10137f:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101386:	0f b6 c0             	movzbl %al,%eax
  101389:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  101390:	42                   	inc    %edx
  101391:	0f b7 d2             	movzwl %dx,%edx
  101394:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101398:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10139b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10139f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1013a3:	ee                   	out    %al,(%dx)
}
  1013a4:	90                   	nop
}
  1013a5:	90                   	nop
  1013a6:	83 c4 34             	add    $0x34,%esp
  1013a9:	5b                   	pop    %ebx
  1013aa:	5d                   	pop    %ebp
  1013ab:	c3                   	ret    

001013ac <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1013ac:	f3 0f 1e fb          	endbr32 
  1013b0:	55                   	push   %ebp
  1013b1:	89 e5                	mov    %esp,%ebp
  1013b3:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1013b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1013bd:	eb 08                	jmp    1013c7 <serial_putc_sub+0x1b>
        delay();
  1013bf:	e8 08 fb ff ff       	call   100ecc <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1013c4:	ff 45 fc             	incl   -0x4(%ebp)
  1013c7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013cd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013d1:	89 c2                	mov    %eax,%edx
  1013d3:	ec                   	in     (%dx),%al
  1013d4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013d7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1013db:	0f b6 c0             	movzbl %al,%eax
  1013de:	83 e0 20             	and    $0x20,%eax
  1013e1:	85 c0                	test   %eax,%eax
  1013e3:	75 09                	jne    1013ee <serial_putc_sub+0x42>
  1013e5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1013ec:	7e d1                	jle    1013bf <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  1013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1013f1:	0f b6 c0             	movzbl %al,%eax
  1013f4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1013fa:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1013fd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101401:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101405:	ee                   	out    %al,(%dx)
}
  101406:	90                   	nop
}
  101407:	90                   	nop
  101408:	c9                   	leave  
  101409:	c3                   	ret    

0010140a <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10140a:	f3 0f 1e fb          	endbr32 
  10140e:	55                   	push   %ebp
  10140f:	89 e5                	mov    %esp,%ebp
  101411:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101414:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101418:	74 0d                	je     101427 <serial_putc+0x1d>
        serial_putc_sub(c);
  10141a:	8b 45 08             	mov    0x8(%ebp),%eax
  10141d:	89 04 24             	mov    %eax,(%esp)
  101420:	e8 87 ff ff ff       	call   1013ac <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101425:	eb 24                	jmp    10144b <serial_putc+0x41>
        serial_putc_sub('\b');
  101427:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10142e:	e8 79 ff ff ff       	call   1013ac <serial_putc_sub>
        serial_putc_sub(' ');
  101433:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10143a:	e8 6d ff ff ff       	call   1013ac <serial_putc_sub>
        serial_putc_sub('\b');
  10143f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101446:	e8 61 ff ff ff       	call   1013ac <serial_putc_sub>
}
  10144b:	90                   	nop
  10144c:	c9                   	leave  
  10144d:	c3                   	ret    

0010144e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10144e:	f3 0f 1e fb          	endbr32 
  101452:	55                   	push   %ebp
  101453:	89 e5                	mov    %esp,%ebp
  101455:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101458:	eb 33                	jmp    10148d <cons_intr+0x3f>
        if (c != 0) {
  10145a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10145e:	74 2d                	je     10148d <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  101460:	a1 64 c6 11 00       	mov    0x11c664,%eax
  101465:	8d 50 01             	lea    0x1(%eax),%edx
  101468:	89 15 64 c6 11 00    	mov    %edx,0x11c664
  10146e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101471:	88 90 60 c4 11 00    	mov    %dl,0x11c460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101477:	a1 64 c6 11 00       	mov    0x11c664,%eax
  10147c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101481:	75 0a                	jne    10148d <cons_intr+0x3f>
                cons.wpos = 0;
  101483:	c7 05 64 c6 11 00 00 	movl   $0x0,0x11c664
  10148a:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10148d:	8b 45 08             	mov    0x8(%ebp),%eax
  101490:	ff d0                	call   *%eax
  101492:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101495:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101499:	75 bf                	jne    10145a <cons_intr+0xc>
            }
        }
    }
}
  10149b:	90                   	nop
  10149c:	90                   	nop
  10149d:	c9                   	leave  
  10149e:	c3                   	ret    

0010149f <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10149f:	f3 0f 1e fb          	endbr32 
  1014a3:	55                   	push   %ebp
  1014a4:	89 e5                	mov    %esp,%ebp
  1014a6:	83 ec 10             	sub    $0x10,%esp
  1014a9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014af:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1014b3:	89 c2                	mov    %eax,%edx
  1014b5:	ec                   	in     (%dx),%al
  1014b6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1014b9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1014bd:	0f b6 c0             	movzbl %al,%eax
  1014c0:	83 e0 01             	and    $0x1,%eax
  1014c3:	85 c0                	test   %eax,%eax
  1014c5:	75 07                	jne    1014ce <serial_proc_data+0x2f>
        return -1;
  1014c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014cc:	eb 2a                	jmp    1014f8 <serial_proc_data+0x59>
  1014ce:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014d4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1014d8:	89 c2                	mov    %eax,%edx
  1014da:	ec                   	in     (%dx),%al
  1014db:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1014de:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1014e2:	0f b6 c0             	movzbl %al,%eax
  1014e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1014e8:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1014ec:	75 07                	jne    1014f5 <serial_proc_data+0x56>
        c = '\b';
  1014ee:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1014f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1014f8:	c9                   	leave  
  1014f9:	c3                   	ret    

001014fa <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1014fa:	f3 0f 1e fb          	endbr32 
  1014fe:	55                   	push   %ebp
  1014ff:	89 e5                	mov    %esp,%ebp
  101501:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101504:	a1 48 c4 11 00       	mov    0x11c448,%eax
  101509:	85 c0                	test   %eax,%eax
  10150b:	74 0c                	je     101519 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  10150d:	c7 04 24 9f 14 10 00 	movl   $0x10149f,(%esp)
  101514:	e8 35 ff ff ff       	call   10144e <cons_intr>
    }
}
  101519:	90                   	nop
  10151a:	c9                   	leave  
  10151b:	c3                   	ret    

0010151c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10151c:	f3 0f 1e fb          	endbr32 
  101520:	55                   	push   %ebp
  101521:	89 e5                	mov    %esp,%ebp
  101523:	83 ec 38             	sub    $0x38,%esp
  101526:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10152f:	89 c2                	mov    %eax,%edx
  101531:	ec                   	in     (%dx),%al
  101532:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101535:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101539:	0f b6 c0             	movzbl %al,%eax
  10153c:	83 e0 01             	and    $0x1,%eax
  10153f:	85 c0                	test   %eax,%eax
  101541:	75 0a                	jne    10154d <kbd_proc_data+0x31>
        return -1;
  101543:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101548:	e9 56 01 00 00       	jmp    1016a3 <kbd_proc_data+0x187>
  10154d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101556:	89 c2                	mov    %eax,%edx
  101558:	ec                   	in     (%dx),%al
  101559:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10155c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101560:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101563:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101567:	75 17                	jne    101580 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  101569:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10156e:	83 c8 40             	or     $0x40,%eax
  101571:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  101576:	b8 00 00 00 00       	mov    $0x0,%eax
  10157b:	e9 23 01 00 00       	jmp    1016a3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101580:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101584:	84 c0                	test   %al,%al
  101586:	79 45                	jns    1015cd <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101588:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10158d:	83 e0 40             	and    $0x40,%eax
  101590:	85 c0                	test   %eax,%eax
  101592:	75 08                	jne    10159c <kbd_proc_data+0x80>
  101594:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101598:	24 7f                	and    $0x7f,%al
  10159a:	eb 04                	jmp    1015a0 <kbd_proc_data+0x84>
  10159c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015a0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1015a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015a7:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  1015ae:	0c 40                	or     $0x40,%al
  1015b0:	0f b6 c0             	movzbl %al,%eax
  1015b3:	f7 d0                	not    %eax
  1015b5:	89 c2                	mov    %eax,%edx
  1015b7:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015bc:	21 d0                	and    %edx,%eax
  1015be:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  1015c3:	b8 00 00 00 00       	mov    $0x0,%eax
  1015c8:	e9 d6 00 00 00       	jmp    1016a3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1015cd:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015d2:	83 e0 40             	and    $0x40,%eax
  1015d5:	85 c0                	test   %eax,%eax
  1015d7:	74 11                	je     1015ea <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1015d9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1015dd:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015e2:	83 e0 bf             	and    $0xffffffbf,%eax
  1015e5:	a3 68 c6 11 00       	mov    %eax,0x11c668
    }

    shift |= shiftcode[data];
  1015ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015ee:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  1015f5:	0f b6 d0             	movzbl %al,%edx
  1015f8:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015fd:	09 d0                	or     %edx,%eax
  1015ff:	a3 68 c6 11 00       	mov    %eax,0x11c668
    shift ^= togglecode[data];
  101604:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101608:	0f b6 80 40 91 11 00 	movzbl 0x119140(%eax),%eax
  10160f:	0f b6 d0             	movzbl %al,%edx
  101612:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101617:	31 d0                	xor    %edx,%eax
  101619:	a3 68 c6 11 00       	mov    %eax,0x11c668

    c = charcode[shift & (CTL | SHIFT)][data];
  10161e:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101623:	83 e0 03             	and    $0x3,%eax
  101626:	8b 14 85 40 95 11 00 	mov    0x119540(,%eax,4),%edx
  10162d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101631:	01 d0                	add    %edx,%eax
  101633:	0f b6 00             	movzbl (%eax),%eax
  101636:	0f b6 c0             	movzbl %al,%eax
  101639:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10163c:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101641:	83 e0 08             	and    $0x8,%eax
  101644:	85 c0                	test   %eax,%eax
  101646:	74 22                	je     10166a <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101648:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10164c:	7e 0c                	jle    10165a <kbd_proc_data+0x13e>
  10164e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101652:	7f 06                	jg     10165a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101654:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101658:	eb 10                	jmp    10166a <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10165a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10165e:	7e 0a                	jle    10166a <kbd_proc_data+0x14e>
  101660:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101664:	7f 04                	jg     10166a <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101666:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10166a:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10166f:	f7 d0                	not    %eax
  101671:	83 e0 06             	and    $0x6,%eax
  101674:	85 c0                	test   %eax,%eax
  101676:	75 28                	jne    1016a0 <kbd_proc_data+0x184>
  101678:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10167f:	75 1f                	jne    1016a0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101681:	c7 04 24 65 65 10 00 	movl   $0x106565,(%esp)
  101688:	e8 4c ec ff ff       	call   1002d9 <cprintf>
  10168d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101693:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101697:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10169b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10169e:	ee                   	out    %al,(%dx)
}
  10169f:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a3:	c9                   	leave  
  1016a4:	c3                   	ret    

001016a5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1016a5:	f3 0f 1e fb          	endbr32 
  1016a9:	55                   	push   %ebp
  1016aa:	89 e5                	mov    %esp,%ebp
  1016ac:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1016af:	c7 04 24 1c 15 10 00 	movl   $0x10151c,(%esp)
  1016b6:	e8 93 fd ff ff       	call   10144e <cons_intr>
}
  1016bb:	90                   	nop
  1016bc:	c9                   	leave  
  1016bd:	c3                   	ret    

001016be <kbd_init>:

static void
kbd_init(void) {
  1016be:	f3 0f 1e fb          	endbr32 
  1016c2:	55                   	push   %ebp
  1016c3:	89 e5                	mov    %esp,%ebp
  1016c5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1016c8:	e8 d8 ff ff ff       	call   1016a5 <kbd_intr>
    pic_enable(IRQ_KBD);
  1016cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1016d4:	e8 47 01 00 00       	call   101820 <pic_enable>
}
  1016d9:	90                   	nop
  1016da:	c9                   	leave  
  1016db:	c3                   	ret    

001016dc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1016dc:	f3 0f 1e fb          	endbr32 
  1016e0:	55                   	push   %ebp
  1016e1:	89 e5                	mov    %esp,%ebp
  1016e3:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1016e6:	e8 2e f8 ff ff       	call   100f19 <cga_init>
    serial_init();
  1016eb:	e8 13 f9 ff ff       	call   101003 <serial_init>
    kbd_init();
  1016f0:	e8 c9 ff ff ff       	call   1016be <kbd_init>
    if (!serial_exists) {
  1016f5:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1016fa:	85 c0                	test   %eax,%eax
  1016fc:	75 0c                	jne    10170a <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1016fe:	c7 04 24 71 65 10 00 	movl   $0x106571,(%esp)
  101705:	e8 cf eb ff ff       	call   1002d9 <cprintf>
    }
}
  10170a:	90                   	nop
  10170b:	c9                   	leave  
  10170c:	c3                   	ret    

0010170d <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10170d:	f3 0f 1e fb          	endbr32 
  101711:	55                   	push   %ebp
  101712:	89 e5                	mov    %esp,%ebp
  101714:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101717:	e8 72 f7 ff ff       	call   100e8e <__intr_save>
  10171c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10171f:	8b 45 08             	mov    0x8(%ebp),%eax
  101722:	89 04 24             	mov    %eax,(%esp)
  101725:	e8 48 fa ff ff       	call   101172 <lpt_putc>
        cga_putc(c);
  10172a:	8b 45 08             	mov    0x8(%ebp),%eax
  10172d:	89 04 24             	mov    %eax,(%esp)
  101730:	e8 81 fa ff ff       	call   1011b6 <cga_putc>
        serial_putc(c);
  101735:	8b 45 08             	mov    0x8(%ebp),%eax
  101738:	89 04 24             	mov    %eax,(%esp)
  10173b:	e8 ca fc ff ff       	call   10140a <serial_putc>
    }
    local_intr_restore(intr_flag);
  101740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101743:	89 04 24             	mov    %eax,(%esp)
  101746:	e8 6d f7 ff ff       	call   100eb8 <__intr_restore>
}
  10174b:	90                   	nop
  10174c:	c9                   	leave  
  10174d:	c3                   	ret    

0010174e <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10174e:	f3 0f 1e fb          	endbr32 
  101752:	55                   	push   %ebp
  101753:	89 e5                	mov    %esp,%ebp
  101755:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101758:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10175f:	e8 2a f7 ff ff       	call   100e8e <__intr_save>
  101764:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101767:	e8 8e fd ff ff       	call   1014fa <serial_intr>
        kbd_intr();
  10176c:	e8 34 ff ff ff       	call   1016a5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101771:	8b 15 60 c6 11 00    	mov    0x11c660,%edx
  101777:	a1 64 c6 11 00       	mov    0x11c664,%eax
  10177c:	39 c2                	cmp    %eax,%edx
  10177e:	74 31                	je     1017b1 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
  101780:	a1 60 c6 11 00       	mov    0x11c660,%eax
  101785:	8d 50 01             	lea    0x1(%eax),%edx
  101788:	89 15 60 c6 11 00    	mov    %edx,0x11c660
  10178e:	0f b6 80 60 c4 11 00 	movzbl 0x11c460(%eax),%eax
  101795:	0f b6 c0             	movzbl %al,%eax
  101798:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10179b:	a1 60 c6 11 00       	mov    0x11c660,%eax
  1017a0:	3d 00 02 00 00       	cmp    $0x200,%eax
  1017a5:	75 0a                	jne    1017b1 <cons_getc+0x63>
                cons.rpos = 0;
  1017a7:	c7 05 60 c6 11 00 00 	movl   $0x0,0x11c660
  1017ae:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1017b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1017b4:	89 04 24             	mov    %eax,(%esp)
  1017b7:	e8 fc f6 ff ff       	call   100eb8 <__intr_restore>
    return c;
  1017bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1017bf:	c9                   	leave  
  1017c0:	c3                   	ret    

001017c1 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1017c1:	f3 0f 1e fb          	endbr32 
  1017c5:	55                   	push   %ebp
  1017c6:	89 e5                	mov    %esp,%ebp
  1017c8:	83 ec 14             	sub    $0x14,%esp
  1017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1017ce:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1017d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017d5:	66 a3 50 95 11 00    	mov    %ax,0x119550
    if (did_init) {
  1017db:	a1 6c c6 11 00       	mov    0x11c66c,%eax
  1017e0:	85 c0                	test   %eax,%eax
  1017e2:	74 39                	je     10181d <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  1017e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017e7:	0f b6 c0             	movzbl %al,%eax
  1017ea:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1017f0:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017f3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017f7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017fb:	ee                   	out    %al,(%dx)
}
  1017fc:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1017fd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101801:	c1 e8 08             	shr    $0x8,%eax
  101804:	0f b7 c0             	movzwl %ax,%eax
  101807:	0f b6 c0             	movzbl %al,%eax
  10180a:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101810:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101813:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101817:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10181b:	ee                   	out    %al,(%dx)
}
  10181c:	90                   	nop
    }
}
  10181d:	90                   	nop
  10181e:	c9                   	leave  
  10181f:	c3                   	ret    

00101820 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101820:	f3 0f 1e fb          	endbr32 
  101824:	55                   	push   %ebp
  101825:	89 e5                	mov    %esp,%ebp
  101827:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10182a:	8b 45 08             	mov    0x8(%ebp),%eax
  10182d:	ba 01 00 00 00       	mov    $0x1,%edx
  101832:	88 c1                	mov    %al,%cl
  101834:	d3 e2                	shl    %cl,%edx
  101836:	89 d0                	mov    %edx,%eax
  101838:	98                   	cwtl   
  101839:	f7 d0                	not    %eax
  10183b:	0f bf d0             	movswl %ax,%edx
  10183e:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101845:	98                   	cwtl   
  101846:	21 d0                	and    %edx,%eax
  101848:	98                   	cwtl   
  101849:	0f b7 c0             	movzwl %ax,%eax
  10184c:	89 04 24             	mov    %eax,(%esp)
  10184f:	e8 6d ff ff ff       	call   1017c1 <pic_setmask>
}
  101854:	90                   	nop
  101855:	c9                   	leave  
  101856:	c3                   	ret    

00101857 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101857:	f3 0f 1e fb          	endbr32 
  10185b:	55                   	push   %ebp
  10185c:	89 e5                	mov    %esp,%ebp
  10185e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101861:	c7 05 6c c6 11 00 01 	movl   $0x1,0x11c66c
  101868:	00 00 00 
  10186b:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101871:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101875:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101879:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10187d:	ee                   	out    %al,(%dx)
}
  10187e:	90                   	nop
  10187f:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101885:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101889:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10188d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101891:	ee                   	out    %al,(%dx)
}
  101892:	90                   	nop
  101893:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101899:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10189d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1018a1:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1018a5:	ee                   	out    %al,(%dx)
}
  1018a6:	90                   	nop
  1018a7:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1018ad:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018b1:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1018b5:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1018b9:	ee                   	out    %al,(%dx)
}
  1018ba:	90                   	nop
  1018bb:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1018c1:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018c5:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1018c9:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1018cd:	ee                   	out    %al,(%dx)
}
  1018ce:	90                   	nop
  1018cf:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1018d5:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1018dd:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1018e1:	ee                   	out    %al,(%dx)
}
  1018e2:	90                   	nop
  1018e3:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1018e9:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ed:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1018f1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1018f5:	ee                   	out    %al,(%dx)
}
  1018f6:	90                   	nop
  1018f7:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1018fd:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101901:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101905:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101909:	ee                   	out    %al,(%dx)
}
  10190a:	90                   	nop
  10190b:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101911:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101915:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101919:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10191d:	ee                   	out    %al,(%dx)
}
  10191e:	90                   	nop
  10191f:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101925:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101929:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10192d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101931:	ee                   	out    %al,(%dx)
}
  101932:	90                   	nop
  101933:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101939:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10193d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101941:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101945:	ee                   	out    %al,(%dx)
}
  101946:	90                   	nop
  101947:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10194d:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101951:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101955:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101959:	ee                   	out    %al,(%dx)
}
  10195a:	90                   	nop
  10195b:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101961:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101965:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101969:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10196d:	ee                   	out    %al,(%dx)
}
  10196e:	90                   	nop
  10196f:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101975:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101979:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10197d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101981:	ee                   	out    %al,(%dx)
}
  101982:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101983:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  10198a:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10198f:	74 0f                	je     1019a0 <pic_init+0x149>
        pic_setmask(irq_mask);
  101991:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101998:	89 04 24             	mov    %eax,(%esp)
  10199b:	e8 21 fe ff ff       	call   1017c1 <pic_setmask>
    }
}
  1019a0:	90                   	nop
  1019a1:	c9                   	leave  
  1019a2:	c3                   	ret    

001019a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1019a3:	f3 0f 1e fb          	endbr32 
  1019a7:	55                   	push   %ebp
  1019a8:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  1019aa:	fb                   	sti    
}
  1019ab:	90                   	nop
    sti();
}
  1019ac:	90                   	nop
  1019ad:	5d                   	pop    %ebp
  1019ae:	c3                   	ret    

001019af <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1019af:	f3 0f 1e fb          	endbr32 
  1019b3:	55                   	push   %ebp
  1019b4:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  1019b6:	fa                   	cli    
}
  1019b7:	90                   	nop
    cli();
}
  1019b8:	90                   	nop
  1019b9:	5d                   	pop    %ebp
  1019ba:	c3                   	ret    

001019bb <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1019bb:	f3 0f 1e fb          	endbr32 
  1019bf:	55                   	push   %ebp
  1019c0:	89 e5                	mov    %esp,%ebp
  1019c2:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1019c5:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1019cc:	00 
  1019cd:	c7 04 24 a0 65 10 00 	movl   $0x1065a0,(%esp)
  1019d4:	e8 00 e9 ff ff       	call   1002d9 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1019d9:	c7 04 24 aa 65 10 00 	movl   $0x1065aa,(%esp)
  1019e0:	e8 f4 e8 ff ff       	call   1002d9 <cprintf>
    panic("EOT: kernel seems ok.");
  1019e5:	c7 44 24 08 b8 65 10 	movl   $0x1065b8,0x8(%esp)
  1019ec:	00 
  1019ed:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1019f4:	00 
  1019f5:	c7 04 24 ce 65 10 00 	movl   $0x1065ce,(%esp)
  1019fc:	e8 44 ea ff ff       	call   100445 <__panic>

00101a01 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101a01:	f3 0f 1e fb          	endbr32 
  101a05:	55                   	push   %ebp
  101a06:	89 e5                	mov    %esp,%ebp
  101a08:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    for (int i = 0; i < 256; ++i)
  101a0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101a12:	e9 c4 00 00 00       	jmp    101adb <idt_init+0xda>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a1a:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101a21:	0f b7 d0             	movzwl %ax,%edx
  101a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a27:	66 89 14 c5 80 c6 11 	mov    %dx,0x11c680(,%eax,8)
  101a2e:	00 
  101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a32:	66 c7 04 c5 82 c6 11 	movw   $0x8,0x11c682(,%eax,8)
  101a39:	00 08 00 
  101a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a3f:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  101a46:	00 
  101a47:	80 e2 e0             	and    $0xe0,%dl
  101a4a:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a54:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  101a5b:	00 
  101a5c:	80 e2 1f             	and    $0x1f,%dl
  101a5f:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101a66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a69:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a70:	00 
  101a71:	80 e2 f0             	and    $0xf0,%dl
  101a74:	80 ca 0e             	or     $0xe,%dl
  101a77:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a81:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a88:	00 
  101a89:	80 e2 ef             	and    $0xef,%dl
  101a8c:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a96:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a9d:	00 
  101a9e:	80 e2 9f             	and    $0x9f,%dl
  101aa1:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101aab:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101ab2:	00 
  101ab3:	80 ca 80             	or     $0x80,%dl
  101ab6:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ac0:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101ac7:	c1 e8 10             	shr    $0x10,%eax
  101aca:	0f b7 d0             	movzwl %ax,%edx
  101acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ad0:	66 89 14 c5 86 c6 11 	mov    %dx,0x11c686(,%eax,8)
  101ad7:	00 
    for (int i = 0; i < 256; ++i)
  101ad8:	ff 45 fc             	incl   -0x4(%ebp)
  101adb:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101ae2:	0f 8e 2f ff ff ff    	jle    101a17 <idt_init+0x16>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101ae8:	a1 c4 97 11 00       	mov    0x1197c4,%eax
  101aed:	0f b7 c0             	movzwl %ax,%eax
  101af0:	66 a3 48 ca 11 00    	mov    %ax,0x11ca48
  101af6:	66 c7 05 4a ca 11 00 	movw   $0x8,0x11ca4a
  101afd:	08 00 
  101aff:	0f b6 05 4c ca 11 00 	movzbl 0x11ca4c,%eax
  101b06:	24 e0                	and    $0xe0,%al
  101b08:	a2 4c ca 11 00       	mov    %al,0x11ca4c
  101b0d:	0f b6 05 4c ca 11 00 	movzbl 0x11ca4c,%eax
  101b14:	24 1f                	and    $0x1f,%al
  101b16:	a2 4c ca 11 00       	mov    %al,0x11ca4c
  101b1b:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101b22:	24 f0                	and    $0xf0,%al
  101b24:	0c 0e                	or     $0xe,%al
  101b26:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101b2b:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101b32:	24 ef                	and    $0xef,%al
  101b34:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101b39:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101b40:	0c 60                	or     $0x60,%al
  101b42:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101b47:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101b4e:	0c 80                	or     $0x80,%al
  101b50:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101b55:	a1 c4 97 11 00       	mov    0x1197c4,%eax
  101b5a:	c1 e8 10             	shr    $0x10,%eax
  101b5d:	0f b7 c0             	movzwl %ax,%eax
  101b60:	66 a3 4e ca 11 00    	mov    %ax,0x11ca4e
  101b66:	c7 45 f8 60 95 11 00 	movl   $0x119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101b6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b70:	0f 01 18             	lidtl  (%eax)
}
  101b73:	90                   	nop
    lidt(&idt_pd);
}
  101b74:	90                   	nop
  101b75:	c9                   	leave  
  101b76:	c3                   	ret    

00101b77 <trapname>:

static const char *
trapname(int trapno) {
  101b77:	f3 0f 1e fb          	endbr32 
  101b7b:	55                   	push   %ebp
  101b7c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b81:	83 f8 13             	cmp    $0x13,%eax
  101b84:	77 0c                	ja     101b92 <trapname+0x1b>
        return excnames[trapno];
  101b86:	8b 45 08             	mov    0x8(%ebp),%eax
  101b89:	8b 04 85 20 69 10 00 	mov    0x106920(,%eax,4),%eax
  101b90:	eb 18                	jmp    101baa <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b92:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b96:	7e 0d                	jle    101ba5 <trapname+0x2e>
  101b98:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b9c:	7f 07                	jg     101ba5 <trapname+0x2e>
        return "Hardware Interrupt";
  101b9e:	b8 df 65 10 00       	mov    $0x1065df,%eax
  101ba3:	eb 05                	jmp    101baa <trapname+0x33>
    }
    return "(unknown trap)";
  101ba5:	b8 f2 65 10 00       	mov    $0x1065f2,%eax
}
  101baa:	5d                   	pop    %ebp
  101bab:	c3                   	ret    

00101bac <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101bac:	f3 0f 1e fb          	endbr32 
  101bb0:	55                   	push   %ebp
  101bb1:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bba:	83 f8 08             	cmp    $0x8,%eax
  101bbd:	0f 94 c0             	sete   %al
  101bc0:	0f b6 c0             	movzbl %al,%eax
}
  101bc3:	5d                   	pop    %ebp
  101bc4:	c3                   	ret    

00101bc5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101bc5:	f3 0f 1e fb          	endbr32 
  101bc9:	55                   	push   %ebp
  101bca:	89 e5                	mov    %esp,%ebp
  101bcc:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd6:	c7 04 24 33 66 10 00 	movl   $0x106633,(%esp)
  101bdd:	e8 f7 e6 ff ff       	call   1002d9 <cprintf>
    print_regs(&tf->tf_regs);
  101be2:	8b 45 08             	mov    0x8(%ebp),%eax
  101be5:	89 04 24             	mov    %eax,(%esp)
  101be8:	e8 8d 01 00 00       	call   101d7a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf8:	c7 04 24 44 66 10 00 	movl   $0x106644,(%esp)
  101bff:	e8 d5 e6 ff ff       	call   1002d9 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101c04:	8b 45 08             	mov    0x8(%ebp),%eax
  101c07:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0f:	c7 04 24 57 66 10 00 	movl   $0x106657,(%esp)
  101c16:	e8 be e6 ff ff       	call   1002d9 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c26:	c7 04 24 6a 66 10 00 	movl   $0x10666a,(%esp)
  101c2d:	e8 a7 e6 ff ff       	call   1002d9 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c32:	8b 45 08             	mov    0x8(%ebp),%eax
  101c35:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3d:	c7 04 24 7d 66 10 00 	movl   $0x10667d,(%esp)
  101c44:	e8 90 e6 ff ff       	call   1002d9 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c49:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4c:	8b 40 30             	mov    0x30(%eax),%eax
  101c4f:	89 04 24             	mov    %eax,(%esp)
  101c52:	e8 20 ff ff ff       	call   101b77 <trapname>
  101c57:	8b 55 08             	mov    0x8(%ebp),%edx
  101c5a:	8b 52 30             	mov    0x30(%edx),%edx
  101c5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c61:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c65:	c7 04 24 90 66 10 00 	movl   $0x106690,(%esp)
  101c6c:	e8 68 e6 ff ff       	call   1002d9 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c71:	8b 45 08             	mov    0x8(%ebp),%eax
  101c74:	8b 40 34             	mov    0x34(%eax),%eax
  101c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7b:	c7 04 24 a2 66 10 00 	movl   $0x1066a2,(%esp)
  101c82:	e8 52 e6 ff ff       	call   1002d9 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c87:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8a:	8b 40 38             	mov    0x38(%eax),%eax
  101c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c91:	c7 04 24 b1 66 10 00 	movl   $0x1066b1,(%esp)
  101c98:	e8 3c e6 ff ff       	call   1002d9 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca8:	c7 04 24 c0 66 10 00 	movl   $0x1066c0,(%esp)
  101caf:	e8 25 e6 ff ff       	call   1002d9 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb7:	8b 40 40             	mov    0x40(%eax),%eax
  101cba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbe:	c7 04 24 d3 66 10 00 	movl   $0x1066d3,(%esp)
  101cc5:	e8 0f e6 ff ff       	call   1002d9 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101cd1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101cd8:	eb 3d                	jmp    101d17 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101cda:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdd:	8b 50 40             	mov    0x40(%eax),%edx
  101ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ce3:	21 d0                	and    %edx,%eax
  101ce5:	85 c0                	test   %eax,%eax
  101ce7:	74 28                	je     101d11 <print_trapframe+0x14c>
  101ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cec:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101cf3:	85 c0                	test   %eax,%eax
  101cf5:	74 1a                	je     101d11 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cfa:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101d01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d05:	c7 04 24 e2 66 10 00 	movl   $0x1066e2,(%esp)
  101d0c:	e8 c8 e5 ff ff       	call   1002d9 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d11:	ff 45 f4             	incl   -0xc(%ebp)
  101d14:	d1 65 f0             	shll   -0x10(%ebp)
  101d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d1a:	83 f8 17             	cmp    $0x17,%eax
  101d1d:	76 bb                	jbe    101cda <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d22:	8b 40 40             	mov    0x40(%eax),%eax
  101d25:	c1 e8 0c             	shr    $0xc,%eax
  101d28:	83 e0 03             	and    $0x3,%eax
  101d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2f:	c7 04 24 e6 66 10 00 	movl   $0x1066e6,(%esp)
  101d36:	e8 9e e5 ff ff       	call   1002d9 <cprintf>

    if (!trap_in_kernel(tf)) {
  101d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3e:	89 04 24             	mov    %eax,(%esp)
  101d41:	e8 66 fe ff ff       	call   101bac <trap_in_kernel>
  101d46:	85 c0                	test   %eax,%eax
  101d48:	75 2d                	jne    101d77 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4d:	8b 40 44             	mov    0x44(%eax),%eax
  101d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d54:	c7 04 24 ef 66 10 00 	movl   $0x1066ef,(%esp)
  101d5b:	e8 79 e5 ff ff       	call   1002d9 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d60:	8b 45 08             	mov    0x8(%ebp),%eax
  101d63:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6b:	c7 04 24 fe 66 10 00 	movl   $0x1066fe,(%esp)
  101d72:	e8 62 e5 ff ff       	call   1002d9 <cprintf>
    }
}
  101d77:	90                   	nop
  101d78:	c9                   	leave  
  101d79:	c3                   	ret    

00101d7a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d7a:	f3 0f 1e fb          	endbr32 
  101d7e:	55                   	push   %ebp
  101d7f:	89 e5                	mov    %esp,%ebp
  101d81:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d84:	8b 45 08             	mov    0x8(%ebp),%eax
  101d87:	8b 00                	mov    (%eax),%eax
  101d89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8d:	c7 04 24 11 67 10 00 	movl   $0x106711,(%esp)
  101d94:	e8 40 e5 ff ff       	call   1002d9 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d99:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9c:	8b 40 04             	mov    0x4(%eax),%eax
  101d9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da3:	c7 04 24 20 67 10 00 	movl   $0x106720,(%esp)
  101daa:	e8 2a e5 ff ff       	call   1002d9 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101daf:	8b 45 08             	mov    0x8(%ebp),%eax
  101db2:	8b 40 08             	mov    0x8(%eax),%eax
  101db5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db9:	c7 04 24 2f 67 10 00 	movl   $0x10672f,(%esp)
  101dc0:	e8 14 e5 ff ff       	call   1002d9 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc8:	8b 40 0c             	mov    0xc(%eax),%eax
  101dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dcf:	c7 04 24 3e 67 10 00 	movl   $0x10673e,(%esp)
  101dd6:	e8 fe e4 ff ff       	call   1002d9 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dde:	8b 40 10             	mov    0x10(%eax),%eax
  101de1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101de5:	c7 04 24 4d 67 10 00 	movl   $0x10674d,(%esp)
  101dec:	e8 e8 e4 ff ff       	call   1002d9 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101df1:	8b 45 08             	mov    0x8(%ebp),%eax
  101df4:	8b 40 14             	mov    0x14(%eax),%eax
  101df7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dfb:	c7 04 24 5c 67 10 00 	movl   $0x10675c,(%esp)
  101e02:	e8 d2 e4 ff ff       	call   1002d9 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101e07:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0a:	8b 40 18             	mov    0x18(%eax),%eax
  101e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e11:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  101e18:	e8 bc e4 ff ff       	call   1002d9 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e20:	8b 40 1c             	mov    0x1c(%eax),%eax
  101e23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e27:	c7 04 24 7a 67 10 00 	movl   $0x10677a,(%esp)
  101e2e:	e8 a6 e4 ff ff       	call   1002d9 <cprintf>
}
  101e33:	90                   	nop
  101e34:	c9                   	leave  
  101e35:	c3                   	ret    

00101e36 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e36:	f3 0f 1e fb          	endbr32 
  101e3a:	55                   	push   %ebp
  101e3b:	89 e5                	mov    %esp,%ebp
  101e3d:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101e40:	8b 45 08             	mov    0x8(%ebp),%eax
  101e43:	8b 40 30             	mov    0x30(%eax),%eax
  101e46:	83 f8 79             	cmp    $0x79,%eax
  101e49:	0f 84 02 01 00 00    	je     101f51 <trap_dispatch+0x11b>
  101e4f:	83 f8 79             	cmp    $0x79,%eax
  101e52:	0f 87 32 01 00 00    	ja     101f8a <trap_dispatch+0x154>
  101e58:	83 f8 78             	cmp    $0x78,%eax
  101e5b:	0f 84 b7 00 00 00    	je     101f18 <trap_dispatch+0xe2>
  101e61:	83 f8 78             	cmp    $0x78,%eax
  101e64:	0f 87 20 01 00 00    	ja     101f8a <trap_dispatch+0x154>
  101e6a:	83 f8 2f             	cmp    $0x2f,%eax
  101e6d:	0f 87 17 01 00 00    	ja     101f8a <trap_dispatch+0x154>
  101e73:	83 f8 2e             	cmp    $0x2e,%eax
  101e76:	0f 83 43 01 00 00    	jae    101fbf <trap_dispatch+0x189>
  101e7c:	83 f8 24             	cmp    $0x24,%eax
  101e7f:	74 45                	je     101ec6 <trap_dispatch+0x90>
  101e81:	83 f8 24             	cmp    $0x24,%eax
  101e84:	0f 87 00 01 00 00    	ja     101f8a <trap_dispatch+0x154>
  101e8a:	83 f8 20             	cmp    $0x20,%eax
  101e8d:	74 0a                	je     101e99 <trap_dispatch+0x63>
  101e8f:	83 f8 21             	cmp    $0x21,%eax
  101e92:	74 5b                	je     101eef <trap_dispatch+0xb9>
  101e94:	e9 f1 00 00 00       	jmp    101f8a <trap_dispatch+0x154>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
 	ticks++;
  101e99:	a1 0c cf 11 00       	mov    0x11cf0c,%eax
  101e9e:	40                   	inc    %eax
  101e9f:	a3 0c cf 11 00       	mov    %eax,0x11cf0c
        if (ticks == TICK_NUM)
  101ea4:	a1 0c cf 11 00       	mov    0x11cf0c,%eax
  101ea9:	83 f8 64             	cmp    $0x64,%eax
  101eac:	0f 85 10 01 00 00    	jne    101fc2 <trap_dispatch+0x18c>
        {
            ticks = 0;
  101eb2:	c7 05 0c cf 11 00 00 	movl   $0x0,0x11cf0c
  101eb9:	00 00 00 
            print_ticks();
  101ebc:	e8 fa fa ff ff       	call   1019bb <print_ticks>
        }
        break;
  101ec1:	e9 fc 00 00 00       	jmp    101fc2 <trap_dispatch+0x18c>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ec6:	e8 83 f8 ff ff       	call   10174e <cons_getc>
  101ecb:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ece:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ed2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ed6:	89 54 24 08          	mov    %edx,0x8(%esp)
  101eda:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ede:	c7 04 24 89 67 10 00 	movl   $0x106789,(%esp)
  101ee5:	e8 ef e3 ff ff       	call   1002d9 <cprintf>
        break;
  101eea:	e9 d4 00 00 00       	jmp    101fc3 <trap_dispatch+0x18d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101eef:	e8 5a f8 ff ff       	call   10174e <cons_getc>
  101ef4:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ef7:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101efb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101eff:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f03:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f07:	c7 04 24 9b 67 10 00 	movl   $0x10679b,(%esp)
  101f0e:	e8 c6 e3 ff ff       	call   1002d9 <cprintf>
        break;
  101f13:	e9 ab 00 00 00       	jmp    101fc3 <trap_dispatch+0x18d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        tf->tf_cs = USER_CS;
  101f18:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1b:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
        tf->tf_ds = USER_DS;
  101f21:	8b 45 08             	mov    0x8(%ebp),%eax
  101f24:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
        tf->tf_es = USER_DS;
  101f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2d:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
        tf->tf_ss = USER_DS;
  101f33:	8b 45 08             	mov    0x8(%ebp),%eax
  101f36:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
        tf->tf_eflags |= FL_IOPL_MASK;
  101f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3f:	8b 40 40             	mov    0x40(%eax),%eax
  101f42:	0d 00 30 00 00       	or     $0x3000,%eax
  101f47:	89 c2                	mov    %eax,%edx
  101f49:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4c:	89 50 40             	mov    %edx,0x40(%eax)
        break;
  101f4f:	eb 72                	jmp    101fc3 <trap_dispatch+0x18d>
    case T_SWITCH_TOK:
        tf->tf_cs = KERNEL_CS;
  101f51:	8b 45 08             	mov    0x8(%ebp),%eax
  101f54:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
  101f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5d:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
  101f63:	8b 45 08             	mov    0x8(%ebp),%eax
  101f66:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_ss = KERNEL_DS;
  101f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f6f:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101f75:	8b 45 08             	mov    0x8(%ebp),%eax
  101f78:	8b 40 40             	mov    0x40(%eax),%eax
  101f7b:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f80:	89 c2                	mov    %eax,%edx
  101f82:	8b 45 08             	mov    0x8(%ebp),%eax
  101f85:	89 50 40             	mov    %edx,0x40(%eax)
        // panic("T_SWITCH_** ??\n");
        break;
  101f88:	eb 39                	jmp    101fc3 <trap_dispatch+0x18d>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f91:	83 e0 03             	and    $0x3,%eax
  101f94:	85 c0                	test   %eax,%eax
  101f96:	75 2b                	jne    101fc3 <trap_dispatch+0x18d>
            print_trapframe(tf);
  101f98:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9b:	89 04 24             	mov    %eax,(%esp)
  101f9e:	e8 22 fc ff ff       	call   101bc5 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101fa3:	c7 44 24 08 aa 67 10 	movl   $0x1067aa,0x8(%esp)
  101faa:	00 
  101fab:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  101fb2:	00 
  101fb3:	c7 04 24 ce 65 10 00 	movl   $0x1065ce,(%esp)
  101fba:	e8 86 e4 ff ff       	call   100445 <__panic>
        break;
  101fbf:	90                   	nop
  101fc0:	eb 01                	jmp    101fc3 <trap_dispatch+0x18d>
        break;
  101fc2:	90                   	nop
        }
    }
}
  101fc3:	90                   	nop
  101fc4:	c9                   	leave  
  101fc5:	c3                   	ret    

00101fc6 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101fc6:	f3 0f 1e fb          	endbr32 
  101fca:	55                   	push   %ebp
  101fcb:	89 e5                	mov    %esp,%ebp
  101fcd:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd3:	89 04 24             	mov    %eax,(%esp)
  101fd6:	e8 5b fe ff ff       	call   101e36 <trap_dispatch>
}
  101fdb:	90                   	nop
  101fdc:	c9                   	leave  
  101fdd:	c3                   	ret    

00101fde <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101fde:	6a 00                	push   $0x0
  pushl $0
  101fe0:	6a 00                	push   $0x0
  jmp __alltraps
  101fe2:	e9 69 0a 00 00       	jmp    102a50 <__alltraps>

00101fe7 <vector1>:
.globl vector1
vector1:
  pushl $0
  101fe7:	6a 00                	push   $0x0
  pushl $1
  101fe9:	6a 01                	push   $0x1
  jmp __alltraps
  101feb:	e9 60 0a 00 00       	jmp    102a50 <__alltraps>

00101ff0 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ff0:	6a 00                	push   $0x0
  pushl $2
  101ff2:	6a 02                	push   $0x2
  jmp __alltraps
  101ff4:	e9 57 0a 00 00       	jmp    102a50 <__alltraps>

00101ff9 <vector3>:
.globl vector3
vector3:
  pushl $0
  101ff9:	6a 00                	push   $0x0
  pushl $3
  101ffb:	6a 03                	push   $0x3
  jmp __alltraps
  101ffd:	e9 4e 0a 00 00       	jmp    102a50 <__alltraps>

00102002 <vector4>:
.globl vector4
vector4:
  pushl $0
  102002:	6a 00                	push   $0x0
  pushl $4
  102004:	6a 04                	push   $0x4
  jmp __alltraps
  102006:	e9 45 0a 00 00       	jmp    102a50 <__alltraps>

0010200b <vector5>:
.globl vector5
vector5:
  pushl $0
  10200b:	6a 00                	push   $0x0
  pushl $5
  10200d:	6a 05                	push   $0x5
  jmp __alltraps
  10200f:	e9 3c 0a 00 00       	jmp    102a50 <__alltraps>

00102014 <vector6>:
.globl vector6
vector6:
  pushl $0
  102014:	6a 00                	push   $0x0
  pushl $6
  102016:	6a 06                	push   $0x6
  jmp __alltraps
  102018:	e9 33 0a 00 00       	jmp    102a50 <__alltraps>

0010201d <vector7>:
.globl vector7
vector7:
  pushl $0
  10201d:	6a 00                	push   $0x0
  pushl $7
  10201f:	6a 07                	push   $0x7
  jmp __alltraps
  102021:	e9 2a 0a 00 00       	jmp    102a50 <__alltraps>

00102026 <vector8>:
.globl vector8
vector8:
  pushl $8
  102026:	6a 08                	push   $0x8
  jmp __alltraps
  102028:	e9 23 0a 00 00       	jmp    102a50 <__alltraps>

0010202d <vector9>:
.globl vector9
vector9:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $9
  10202f:	6a 09                	push   $0x9
  jmp __alltraps
  102031:	e9 1a 0a 00 00       	jmp    102a50 <__alltraps>

00102036 <vector10>:
.globl vector10
vector10:
  pushl $10
  102036:	6a 0a                	push   $0xa
  jmp __alltraps
  102038:	e9 13 0a 00 00       	jmp    102a50 <__alltraps>

0010203d <vector11>:
.globl vector11
vector11:
  pushl $11
  10203d:	6a 0b                	push   $0xb
  jmp __alltraps
  10203f:	e9 0c 0a 00 00       	jmp    102a50 <__alltraps>

00102044 <vector12>:
.globl vector12
vector12:
  pushl $12
  102044:	6a 0c                	push   $0xc
  jmp __alltraps
  102046:	e9 05 0a 00 00       	jmp    102a50 <__alltraps>

0010204b <vector13>:
.globl vector13
vector13:
  pushl $13
  10204b:	6a 0d                	push   $0xd
  jmp __alltraps
  10204d:	e9 fe 09 00 00       	jmp    102a50 <__alltraps>

00102052 <vector14>:
.globl vector14
vector14:
  pushl $14
  102052:	6a 0e                	push   $0xe
  jmp __alltraps
  102054:	e9 f7 09 00 00       	jmp    102a50 <__alltraps>

00102059 <vector15>:
.globl vector15
vector15:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $15
  10205b:	6a 0f                	push   $0xf
  jmp __alltraps
  10205d:	e9 ee 09 00 00       	jmp    102a50 <__alltraps>

00102062 <vector16>:
.globl vector16
vector16:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $16
  102064:	6a 10                	push   $0x10
  jmp __alltraps
  102066:	e9 e5 09 00 00       	jmp    102a50 <__alltraps>

0010206b <vector17>:
.globl vector17
vector17:
  pushl $17
  10206b:	6a 11                	push   $0x11
  jmp __alltraps
  10206d:	e9 de 09 00 00       	jmp    102a50 <__alltraps>

00102072 <vector18>:
.globl vector18
vector18:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $18
  102074:	6a 12                	push   $0x12
  jmp __alltraps
  102076:	e9 d5 09 00 00       	jmp    102a50 <__alltraps>

0010207b <vector19>:
.globl vector19
vector19:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $19
  10207d:	6a 13                	push   $0x13
  jmp __alltraps
  10207f:	e9 cc 09 00 00       	jmp    102a50 <__alltraps>

00102084 <vector20>:
.globl vector20
vector20:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $20
  102086:	6a 14                	push   $0x14
  jmp __alltraps
  102088:	e9 c3 09 00 00       	jmp    102a50 <__alltraps>

0010208d <vector21>:
.globl vector21
vector21:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $21
  10208f:	6a 15                	push   $0x15
  jmp __alltraps
  102091:	e9 ba 09 00 00       	jmp    102a50 <__alltraps>

00102096 <vector22>:
.globl vector22
vector22:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $22
  102098:	6a 16                	push   $0x16
  jmp __alltraps
  10209a:	e9 b1 09 00 00       	jmp    102a50 <__alltraps>

0010209f <vector23>:
.globl vector23
vector23:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $23
  1020a1:	6a 17                	push   $0x17
  jmp __alltraps
  1020a3:	e9 a8 09 00 00       	jmp    102a50 <__alltraps>

001020a8 <vector24>:
.globl vector24
vector24:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $24
  1020aa:	6a 18                	push   $0x18
  jmp __alltraps
  1020ac:	e9 9f 09 00 00       	jmp    102a50 <__alltraps>

001020b1 <vector25>:
.globl vector25
vector25:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $25
  1020b3:	6a 19                	push   $0x19
  jmp __alltraps
  1020b5:	e9 96 09 00 00       	jmp    102a50 <__alltraps>

001020ba <vector26>:
.globl vector26
vector26:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $26
  1020bc:	6a 1a                	push   $0x1a
  jmp __alltraps
  1020be:	e9 8d 09 00 00       	jmp    102a50 <__alltraps>

001020c3 <vector27>:
.globl vector27
vector27:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $27
  1020c5:	6a 1b                	push   $0x1b
  jmp __alltraps
  1020c7:	e9 84 09 00 00       	jmp    102a50 <__alltraps>

001020cc <vector28>:
.globl vector28
vector28:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $28
  1020ce:	6a 1c                	push   $0x1c
  jmp __alltraps
  1020d0:	e9 7b 09 00 00       	jmp    102a50 <__alltraps>

001020d5 <vector29>:
.globl vector29
vector29:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $29
  1020d7:	6a 1d                	push   $0x1d
  jmp __alltraps
  1020d9:	e9 72 09 00 00       	jmp    102a50 <__alltraps>

001020de <vector30>:
.globl vector30
vector30:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $30
  1020e0:	6a 1e                	push   $0x1e
  jmp __alltraps
  1020e2:	e9 69 09 00 00       	jmp    102a50 <__alltraps>

001020e7 <vector31>:
.globl vector31
vector31:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $31
  1020e9:	6a 1f                	push   $0x1f
  jmp __alltraps
  1020eb:	e9 60 09 00 00       	jmp    102a50 <__alltraps>

001020f0 <vector32>:
.globl vector32
vector32:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $32
  1020f2:	6a 20                	push   $0x20
  jmp __alltraps
  1020f4:	e9 57 09 00 00       	jmp    102a50 <__alltraps>

001020f9 <vector33>:
.globl vector33
vector33:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $33
  1020fb:	6a 21                	push   $0x21
  jmp __alltraps
  1020fd:	e9 4e 09 00 00       	jmp    102a50 <__alltraps>

00102102 <vector34>:
.globl vector34
vector34:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $34
  102104:	6a 22                	push   $0x22
  jmp __alltraps
  102106:	e9 45 09 00 00       	jmp    102a50 <__alltraps>

0010210b <vector35>:
.globl vector35
vector35:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $35
  10210d:	6a 23                	push   $0x23
  jmp __alltraps
  10210f:	e9 3c 09 00 00       	jmp    102a50 <__alltraps>

00102114 <vector36>:
.globl vector36
vector36:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $36
  102116:	6a 24                	push   $0x24
  jmp __alltraps
  102118:	e9 33 09 00 00       	jmp    102a50 <__alltraps>

0010211d <vector37>:
.globl vector37
vector37:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $37
  10211f:	6a 25                	push   $0x25
  jmp __alltraps
  102121:	e9 2a 09 00 00       	jmp    102a50 <__alltraps>

00102126 <vector38>:
.globl vector38
vector38:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $38
  102128:	6a 26                	push   $0x26
  jmp __alltraps
  10212a:	e9 21 09 00 00       	jmp    102a50 <__alltraps>

0010212f <vector39>:
.globl vector39
vector39:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $39
  102131:	6a 27                	push   $0x27
  jmp __alltraps
  102133:	e9 18 09 00 00       	jmp    102a50 <__alltraps>

00102138 <vector40>:
.globl vector40
vector40:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $40
  10213a:	6a 28                	push   $0x28
  jmp __alltraps
  10213c:	e9 0f 09 00 00       	jmp    102a50 <__alltraps>

00102141 <vector41>:
.globl vector41
vector41:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $41
  102143:	6a 29                	push   $0x29
  jmp __alltraps
  102145:	e9 06 09 00 00       	jmp    102a50 <__alltraps>

0010214a <vector42>:
.globl vector42
vector42:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $42
  10214c:	6a 2a                	push   $0x2a
  jmp __alltraps
  10214e:	e9 fd 08 00 00       	jmp    102a50 <__alltraps>

00102153 <vector43>:
.globl vector43
vector43:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $43
  102155:	6a 2b                	push   $0x2b
  jmp __alltraps
  102157:	e9 f4 08 00 00       	jmp    102a50 <__alltraps>

0010215c <vector44>:
.globl vector44
vector44:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $44
  10215e:	6a 2c                	push   $0x2c
  jmp __alltraps
  102160:	e9 eb 08 00 00       	jmp    102a50 <__alltraps>

00102165 <vector45>:
.globl vector45
vector45:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $45
  102167:	6a 2d                	push   $0x2d
  jmp __alltraps
  102169:	e9 e2 08 00 00       	jmp    102a50 <__alltraps>

0010216e <vector46>:
.globl vector46
vector46:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $46
  102170:	6a 2e                	push   $0x2e
  jmp __alltraps
  102172:	e9 d9 08 00 00       	jmp    102a50 <__alltraps>

00102177 <vector47>:
.globl vector47
vector47:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $47
  102179:	6a 2f                	push   $0x2f
  jmp __alltraps
  10217b:	e9 d0 08 00 00       	jmp    102a50 <__alltraps>

00102180 <vector48>:
.globl vector48
vector48:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $48
  102182:	6a 30                	push   $0x30
  jmp __alltraps
  102184:	e9 c7 08 00 00       	jmp    102a50 <__alltraps>

00102189 <vector49>:
.globl vector49
vector49:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $49
  10218b:	6a 31                	push   $0x31
  jmp __alltraps
  10218d:	e9 be 08 00 00       	jmp    102a50 <__alltraps>

00102192 <vector50>:
.globl vector50
vector50:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $50
  102194:	6a 32                	push   $0x32
  jmp __alltraps
  102196:	e9 b5 08 00 00       	jmp    102a50 <__alltraps>

0010219b <vector51>:
.globl vector51
vector51:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $51
  10219d:	6a 33                	push   $0x33
  jmp __alltraps
  10219f:	e9 ac 08 00 00       	jmp    102a50 <__alltraps>

001021a4 <vector52>:
.globl vector52
vector52:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $52
  1021a6:	6a 34                	push   $0x34
  jmp __alltraps
  1021a8:	e9 a3 08 00 00       	jmp    102a50 <__alltraps>

001021ad <vector53>:
.globl vector53
vector53:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $53
  1021af:	6a 35                	push   $0x35
  jmp __alltraps
  1021b1:	e9 9a 08 00 00       	jmp    102a50 <__alltraps>

001021b6 <vector54>:
.globl vector54
vector54:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $54
  1021b8:	6a 36                	push   $0x36
  jmp __alltraps
  1021ba:	e9 91 08 00 00       	jmp    102a50 <__alltraps>

001021bf <vector55>:
.globl vector55
vector55:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $55
  1021c1:	6a 37                	push   $0x37
  jmp __alltraps
  1021c3:	e9 88 08 00 00       	jmp    102a50 <__alltraps>

001021c8 <vector56>:
.globl vector56
vector56:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $56
  1021ca:	6a 38                	push   $0x38
  jmp __alltraps
  1021cc:	e9 7f 08 00 00       	jmp    102a50 <__alltraps>

001021d1 <vector57>:
.globl vector57
vector57:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $57
  1021d3:	6a 39                	push   $0x39
  jmp __alltraps
  1021d5:	e9 76 08 00 00       	jmp    102a50 <__alltraps>

001021da <vector58>:
.globl vector58
vector58:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $58
  1021dc:	6a 3a                	push   $0x3a
  jmp __alltraps
  1021de:	e9 6d 08 00 00       	jmp    102a50 <__alltraps>

001021e3 <vector59>:
.globl vector59
vector59:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $59
  1021e5:	6a 3b                	push   $0x3b
  jmp __alltraps
  1021e7:	e9 64 08 00 00       	jmp    102a50 <__alltraps>

001021ec <vector60>:
.globl vector60
vector60:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $60
  1021ee:	6a 3c                	push   $0x3c
  jmp __alltraps
  1021f0:	e9 5b 08 00 00       	jmp    102a50 <__alltraps>

001021f5 <vector61>:
.globl vector61
vector61:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $61
  1021f7:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021f9:	e9 52 08 00 00       	jmp    102a50 <__alltraps>

001021fe <vector62>:
.globl vector62
vector62:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $62
  102200:	6a 3e                	push   $0x3e
  jmp __alltraps
  102202:	e9 49 08 00 00       	jmp    102a50 <__alltraps>

00102207 <vector63>:
.globl vector63
vector63:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $63
  102209:	6a 3f                	push   $0x3f
  jmp __alltraps
  10220b:	e9 40 08 00 00       	jmp    102a50 <__alltraps>

00102210 <vector64>:
.globl vector64
vector64:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $64
  102212:	6a 40                	push   $0x40
  jmp __alltraps
  102214:	e9 37 08 00 00       	jmp    102a50 <__alltraps>

00102219 <vector65>:
.globl vector65
vector65:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $65
  10221b:	6a 41                	push   $0x41
  jmp __alltraps
  10221d:	e9 2e 08 00 00       	jmp    102a50 <__alltraps>

00102222 <vector66>:
.globl vector66
vector66:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $66
  102224:	6a 42                	push   $0x42
  jmp __alltraps
  102226:	e9 25 08 00 00       	jmp    102a50 <__alltraps>

0010222b <vector67>:
.globl vector67
vector67:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $67
  10222d:	6a 43                	push   $0x43
  jmp __alltraps
  10222f:	e9 1c 08 00 00       	jmp    102a50 <__alltraps>

00102234 <vector68>:
.globl vector68
vector68:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $68
  102236:	6a 44                	push   $0x44
  jmp __alltraps
  102238:	e9 13 08 00 00       	jmp    102a50 <__alltraps>

0010223d <vector69>:
.globl vector69
vector69:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $69
  10223f:	6a 45                	push   $0x45
  jmp __alltraps
  102241:	e9 0a 08 00 00       	jmp    102a50 <__alltraps>

00102246 <vector70>:
.globl vector70
vector70:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $70
  102248:	6a 46                	push   $0x46
  jmp __alltraps
  10224a:	e9 01 08 00 00       	jmp    102a50 <__alltraps>

0010224f <vector71>:
.globl vector71
vector71:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $71
  102251:	6a 47                	push   $0x47
  jmp __alltraps
  102253:	e9 f8 07 00 00       	jmp    102a50 <__alltraps>

00102258 <vector72>:
.globl vector72
vector72:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $72
  10225a:	6a 48                	push   $0x48
  jmp __alltraps
  10225c:	e9 ef 07 00 00       	jmp    102a50 <__alltraps>

00102261 <vector73>:
.globl vector73
vector73:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $73
  102263:	6a 49                	push   $0x49
  jmp __alltraps
  102265:	e9 e6 07 00 00       	jmp    102a50 <__alltraps>

0010226a <vector74>:
.globl vector74
vector74:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $74
  10226c:	6a 4a                	push   $0x4a
  jmp __alltraps
  10226e:	e9 dd 07 00 00       	jmp    102a50 <__alltraps>

00102273 <vector75>:
.globl vector75
vector75:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $75
  102275:	6a 4b                	push   $0x4b
  jmp __alltraps
  102277:	e9 d4 07 00 00       	jmp    102a50 <__alltraps>

0010227c <vector76>:
.globl vector76
vector76:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $76
  10227e:	6a 4c                	push   $0x4c
  jmp __alltraps
  102280:	e9 cb 07 00 00       	jmp    102a50 <__alltraps>

00102285 <vector77>:
.globl vector77
vector77:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $77
  102287:	6a 4d                	push   $0x4d
  jmp __alltraps
  102289:	e9 c2 07 00 00       	jmp    102a50 <__alltraps>

0010228e <vector78>:
.globl vector78
vector78:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $78
  102290:	6a 4e                	push   $0x4e
  jmp __alltraps
  102292:	e9 b9 07 00 00       	jmp    102a50 <__alltraps>

00102297 <vector79>:
.globl vector79
vector79:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $79
  102299:	6a 4f                	push   $0x4f
  jmp __alltraps
  10229b:	e9 b0 07 00 00       	jmp    102a50 <__alltraps>

001022a0 <vector80>:
.globl vector80
vector80:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $80
  1022a2:	6a 50                	push   $0x50
  jmp __alltraps
  1022a4:	e9 a7 07 00 00       	jmp    102a50 <__alltraps>

001022a9 <vector81>:
.globl vector81
vector81:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $81
  1022ab:	6a 51                	push   $0x51
  jmp __alltraps
  1022ad:	e9 9e 07 00 00       	jmp    102a50 <__alltraps>

001022b2 <vector82>:
.globl vector82
vector82:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $82
  1022b4:	6a 52                	push   $0x52
  jmp __alltraps
  1022b6:	e9 95 07 00 00       	jmp    102a50 <__alltraps>

001022bb <vector83>:
.globl vector83
vector83:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $83
  1022bd:	6a 53                	push   $0x53
  jmp __alltraps
  1022bf:	e9 8c 07 00 00       	jmp    102a50 <__alltraps>

001022c4 <vector84>:
.globl vector84
vector84:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $84
  1022c6:	6a 54                	push   $0x54
  jmp __alltraps
  1022c8:	e9 83 07 00 00       	jmp    102a50 <__alltraps>

001022cd <vector85>:
.globl vector85
vector85:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $85
  1022cf:	6a 55                	push   $0x55
  jmp __alltraps
  1022d1:	e9 7a 07 00 00       	jmp    102a50 <__alltraps>

001022d6 <vector86>:
.globl vector86
vector86:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $86
  1022d8:	6a 56                	push   $0x56
  jmp __alltraps
  1022da:	e9 71 07 00 00       	jmp    102a50 <__alltraps>

001022df <vector87>:
.globl vector87
vector87:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $87
  1022e1:	6a 57                	push   $0x57
  jmp __alltraps
  1022e3:	e9 68 07 00 00       	jmp    102a50 <__alltraps>

001022e8 <vector88>:
.globl vector88
vector88:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $88
  1022ea:	6a 58                	push   $0x58
  jmp __alltraps
  1022ec:	e9 5f 07 00 00       	jmp    102a50 <__alltraps>

001022f1 <vector89>:
.globl vector89
vector89:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $89
  1022f3:	6a 59                	push   $0x59
  jmp __alltraps
  1022f5:	e9 56 07 00 00       	jmp    102a50 <__alltraps>

001022fa <vector90>:
.globl vector90
vector90:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $90
  1022fc:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022fe:	e9 4d 07 00 00       	jmp    102a50 <__alltraps>

00102303 <vector91>:
.globl vector91
vector91:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $91
  102305:	6a 5b                	push   $0x5b
  jmp __alltraps
  102307:	e9 44 07 00 00       	jmp    102a50 <__alltraps>

0010230c <vector92>:
.globl vector92
vector92:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $92
  10230e:	6a 5c                	push   $0x5c
  jmp __alltraps
  102310:	e9 3b 07 00 00       	jmp    102a50 <__alltraps>

00102315 <vector93>:
.globl vector93
vector93:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $93
  102317:	6a 5d                	push   $0x5d
  jmp __alltraps
  102319:	e9 32 07 00 00       	jmp    102a50 <__alltraps>

0010231e <vector94>:
.globl vector94
vector94:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $94
  102320:	6a 5e                	push   $0x5e
  jmp __alltraps
  102322:	e9 29 07 00 00       	jmp    102a50 <__alltraps>

00102327 <vector95>:
.globl vector95
vector95:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $95
  102329:	6a 5f                	push   $0x5f
  jmp __alltraps
  10232b:	e9 20 07 00 00       	jmp    102a50 <__alltraps>

00102330 <vector96>:
.globl vector96
vector96:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $96
  102332:	6a 60                	push   $0x60
  jmp __alltraps
  102334:	e9 17 07 00 00       	jmp    102a50 <__alltraps>

00102339 <vector97>:
.globl vector97
vector97:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $97
  10233b:	6a 61                	push   $0x61
  jmp __alltraps
  10233d:	e9 0e 07 00 00       	jmp    102a50 <__alltraps>

00102342 <vector98>:
.globl vector98
vector98:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $98
  102344:	6a 62                	push   $0x62
  jmp __alltraps
  102346:	e9 05 07 00 00       	jmp    102a50 <__alltraps>

0010234b <vector99>:
.globl vector99
vector99:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $99
  10234d:	6a 63                	push   $0x63
  jmp __alltraps
  10234f:	e9 fc 06 00 00       	jmp    102a50 <__alltraps>

00102354 <vector100>:
.globl vector100
vector100:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $100
  102356:	6a 64                	push   $0x64
  jmp __alltraps
  102358:	e9 f3 06 00 00       	jmp    102a50 <__alltraps>

0010235d <vector101>:
.globl vector101
vector101:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $101
  10235f:	6a 65                	push   $0x65
  jmp __alltraps
  102361:	e9 ea 06 00 00       	jmp    102a50 <__alltraps>

00102366 <vector102>:
.globl vector102
vector102:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $102
  102368:	6a 66                	push   $0x66
  jmp __alltraps
  10236a:	e9 e1 06 00 00       	jmp    102a50 <__alltraps>

0010236f <vector103>:
.globl vector103
vector103:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $103
  102371:	6a 67                	push   $0x67
  jmp __alltraps
  102373:	e9 d8 06 00 00       	jmp    102a50 <__alltraps>

00102378 <vector104>:
.globl vector104
vector104:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $104
  10237a:	6a 68                	push   $0x68
  jmp __alltraps
  10237c:	e9 cf 06 00 00       	jmp    102a50 <__alltraps>

00102381 <vector105>:
.globl vector105
vector105:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $105
  102383:	6a 69                	push   $0x69
  jmp __alltraps
  102385:	e9 c6 06 00 00       	jmp    102a50 <__alltraps>

0010238a <vector106>:
.globl vector106
vector106:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $106
  10238c:	6a 6a                	push   $0x6a
  jmp __alltraps
  10238e:	e9 bd 06 00 00       	jmp    102a50 <__alltraps>

00102393 <vector107>:
.globl vector107
vector107:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $107
  102395:	6a 6b                	push   $0x6b
  jmp __alltraps
  102397:	e9 b4 06 00 00       	jmp    102a50 <__alltraps>

0010239c <vector108>:
.globl vector108
vector108:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $108
  10239e:	6a 6c                	push   $0x6c
  jmp __alltraps
  1023a0:	e9 ab 06 00 00       	jmp    102a50 <__alltraps>

001023a5 <vector109>:
.globl vector109
vector109:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $109
  1023a7:	6a 6d                	push   $0x6d
  jmp __alltraps
  1023a9:	e9 a2 06 00 00       	jmp    102a50 <__alltraps>

001023ae <vector110>:
.globl vector110
vector110:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $110
  1023b0:	6a 6e                	push   $0x6e
  jmp __alltraps
  1023b2:	e9 99 06 00 00       	jmp    102a50 <__alltraps>

001023b7 <vector111>:
.globl vector111
vector111:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $111
  1023b9:	6a 6f                	push   $0x6f
  jmp __alltraps
  1023bb:	e9 90 06 00 00       	jmp    102a50 <__alltraps>

001023c0 <vector112>:
.globl vector112
vector112:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $112
  1023c2:	6a 70                	push   $0x70
  jmp __alltraps
  1023c4:	e9 87 06 00 00       	jmp    102a50 <__alltraps>

001023c9 <vector113>:
.globl vector113
vector113:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $113
  1023cb:	6a 71                	push   $0x71
  jmp __alltraps
  1023cd:	e9 7e 06 00 00       	jmp    102a50 <__alltraps>

001023d2 <vector114>:
.globl vector114
vector114:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $114
  1023d4:	6a 72                	push   $0x72
  jmp __alltraps
  1023d6:	e9 75 06 00 00       	jmp    102a50 <__alltraps>

001023db <vector115>:
.globl vector115
vector115:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $115
  1023dd:	6a 73                	push   $0x73
  jmp __alltraps
  1023df:	e9 6c 06 00 00       	jmp    102a50 <__alltraps>

001023e4 <vector116>:
.globl vector116
vector116:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $116
  1023e6:	6a 74                	push   $0x74
  jmp __alltraps
  1023e8:	e9 63 06 00 00       	jmp    102a50 <__alltraps>

001023ed <vector117>:
.globl vector117
vector117:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $117
  1023ef:	6a 75                	push   $0x75
  jmp __alltraps
  1023f1:	e9 5a 06 00 00       	jmp    102a50 <__alltraps>

001023f6 <vector118>:
.globl vector118
vector118:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $118
  1023f8:	6a 76                	push   $0x76
  jmp __alltraps
  1023fa:	e9 51 06 00 00       	jmp    102a50 <__alltraps>

001023ff <vector119>:
.globl vector119
vector119:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $119
  102401:	6a 77                	push   $0x77
  jmp __alltraps
  102403:	e9 48 06 00 00       	jmp    102a50 <__alltraps>

00102408 <vector120>:
.globl vector120
vector120:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $120
  10240a:	6a 78                	push   $0x78
  jmp __alltraps
  10240c:	e9 3f 06 00 00       	jmp    102a50 <__alltraps>

00102411 <vector121>:
.globl vector121
vector121:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $121
  102413:	6a 79                	push   $0x79
  jmp __alltraps
  102415:	e9 36 06 00 00       	jmp    102a50 <__alltraps>

0010241a <vector122>:
.globl vector122
vector122:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $122
  10241c:	6a 7a                	push   $0x7a
  jmp __alltraps
  10241e:	e9 2d 06 00 00       	jmp    102a50 <__alltraps>

00102423 <vector123>:
.globl vector123
vector123:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $123
  102425:	6a 7b                	push   $0x7b
  jmp __alltraps
  102427:	e9 24 06 00 00       	jmp    102a50 <__alltraps>

0010242c <vector124>:
.globl vector124
vector124:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $124
  10242e:	6a 7c                	push   $0x7c
  jmp __alltraps
  102430:	e9 1b 06 00 00       	jmp    102a50 <__alltraps>

00102435 <vector125>:
.globl vector125
vector125:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $125
  102437:	6a 7d                	push   $0x7d
  jmp __alltraps
  102439:	e9 12 06 00 00       	jmp    102a50 <__alltraps>

0010243e <vector126>:
.globl vector126
vector126:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $126
  102440:	6a 7e                	push   $0x7e
  jmp __alltraps
  102442:	e9 09 06 00 00       	jmp    102a50 <__alltraps>

00102447 <vector127>:
.globl vector127
vector127:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $127
  102449:	6a 7f                	push   $0x7f
  jmp __alltraps
  10244b:	e9 00 06 00 00       	jmp    102a50 <__alltraps>

00102450 <vector128>:
.globl vector128
vector128:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $128
  102452:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102457:	e9 f4 05 00 00       	jmp    102a50 <__alltraps>

0010245c <vector129>:
.globl vector129
vector129:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $129
  10245e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102463:	e9 e8 05 00 00       	jmp    102a50 <__alltraps>

00102468 <vector130>:
.globl vector130
vector130:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $130
  10246a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10246f:	e9 dc 05 00 00       	jmp    102a50 <__alltraps>

00102474 <vector131>:
.globl vector131
vector131:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $131
  102476:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10247b:	e9 d0 05 00 00       	jmp    102a50 <__alltraps>

00102480 <vector132>:
.globl vector132
vector132:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $132
  102482:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102487:	e9 c4 05 00 00       	jmp    102a50 <__alltraps>

0010248c <vector133>:
.globl vector133
vector133:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $133
  10248e:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102493:	e9 b8 05 00 00       	jmp    102a50 <__alltraps>

00102498 <vector134>:
.globl vector134
vector134:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $134
  10249a:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10249f:	e9 ac 05 00 00       	jmp    102a50 <__alltraps>

001024a4 <vector135>:
.globl vector135
vector135:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $135
  1024a6:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1024ab:	e9 a0 05 00 00       	jmp    102a50 <__alltraps>

001024b0 <vector136>:
.globl vector136
vector136:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $136
  1024b2:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1024b7:	e9 94 05 00 00       	jmp    102a50 <__alltraps>

001024bc <vector137>:
.globl vector137
vector137:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $137
  1024be:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1024c3:	e9 88 05 00 00       	jmp    102a50 <__alltraps>

001024c8 <vector138>:
.globl vector138
vector138:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $138
  1024ca:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1024cf:	e9 7c 05 00 00       	jmp    102a50 <__alltraps>

001024d4 <vector139>:
.globl vector139
vector139:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $139
  1024d6:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1024db:	e9 70 05 00 00       	jmp    102a50 <__alltraps>

001024e0 <vector140>:
.globl vector140
vector140:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $140
  1024e2:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1024e7:	e9 64 05 00 00       	jmp    102a50 <__alltraps>

001024ec <vector141>:
.globl vector141
vector141:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $141
  1024ee:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1024f3:	e9 58 05 00 00       	jmp    102a50 <__alltraps>

001024f8 <vector142>:
.globl vector142
vector142:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $142
  1024fa:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024ff:	e9 4c 05 00 00       	jmp    102a50 <__alltraps>

00102504 <vector143>:
.globl vector143
vector143:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $143
  102506:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10250b:	e9 40 05 00 00       	jmp    102a50 <__alltraps>

00102510 <vector144>:
.globl vector144
vector144:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $144
  102512:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102517:	e9 34 05 00 00       	jmp    102a50 <__alltraps>

0010251c <vector145>:
.globl vector145
vector145:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $145
  10251e:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102523:	e9 28 05 00 00       	jmp    102a50 <__alltraps>

00102528 <vector146>:
.globl vector146
vector146:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $146
  10252a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10252f:	e9 1c 05 00 00       	jmp    102a50 <__alltraps>

00102534 <vector147>:
.globl vector147
vector147:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $147
  102536:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10253b:	e9 10 05 00 00       	jmp    102a50 <__alltraps>

00102540 <vector148>:
.globl vector148
vector148:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $148
  102542:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102547:	e9 04 05 00 00       	jmp    102a50 <__alltraps>

0010254c <vector149>:
.globl vector149
vector149:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $149
  10254e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102553:	e9 f8 04 00 00       	jmp    102a50 <__alltraps>

00102558 <vector150>:
.globl vector150
vector150:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $150
  10255a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10255f:	e9 ec 04 00 00       	jmp    102a50 <__alltraps>

00102564 <vector151>:
.globl vector151
vector151:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $151
  102566:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10256b:	e9 e0 04 00 00       	jmp    102a50 <__alltraps>

00102570 <vector152>:
.globl vector152
vector152:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $152
  102572:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102577:	e9 d4 04 00 00       	jmp    102a50 <__alltraps>

0010257c <vector153>:
.globl vector153
vector153:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $153
  10257e:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102583:	e9 c8 04 00 00       	jmp    102a50 <__alltraps>

00102588 <vector154>:
.globl vector154
vector154:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $154
  10258a:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10258f:	e9 bc 04 00 00       	jmp    102a50 <__alltraps>

00102594 <vector155>:
.globl vector155
vector155:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $155
  102596:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10259b:	e9 b0 04 00 00       	jmp    102a50 <__alltraps>

001025a0 <vector156>:
.globl vector156
vector156:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $156
  1025a2:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1025a7:	e9 a4 04 00 00       	jmp    102a50 <__alltraps>

001025ac <vector157>:
.globl vector157
vector157:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $157
  1025ae:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1025b3:	e9 98 04 00 00       	jmp    102a50 <__alltraps>

001025b8 <vector158>:
.globl vector158
vector158:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $158
  1025ba:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1025bf:	e9 8c 04 00 00       	jmp    102a50 <__alltraps>

001025c4 <vector159>:
.globl vector159
vector159:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $159
  1025c6:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1025cb:	e9 80 04 00 00       	jmp    102a50 <__alltraps>

001025d0 <vector160>:
.globl vector160
vector160:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $160
  1025d2:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1025d7:	e9 74 04 00 00       	jmp    102a50 <__alltraps>

001025dc <vector161>:
.globl vector161
vector161:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $161
  1025de:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1025e3:	e9 68 04 00 00       	jmp    102a50 <__alltraps>

001025e8 <vector162>:
.globl vector162
vector162:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $162
  1025ea:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1025ef:	e9 5c 04 00 00       	jmp    102a50 <__alltraps>

001025f4 <vector163>:
.globl vector163
vector163:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $163
  1025f6:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025fb:	e9 50 04 00 00       	jmp    102a50 <__alltraps>

00102600 <vector164>:
.globl vector164
vector164:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $164
  102602:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102607:	e9 44 04 00 00       	jmp    102a50 <__alltraps>

0010260c <vector165>:
.globl vector165
vector165:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $165
  10260e:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102613:	e9 38 04 00 00       	jmp    102a50 <__alltraps>

00102618 <vector166>:
.globl vector166
vector166:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $166
  10261a:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10261f:	e9 2c 04 00 00       	jmp    102a50 <__alltraps>

00102624 <vector167>:
.globl vector167
vector167:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $167
  102626:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10262b:	e9 20 04 00 00       	jmp    102a50 <__alltraps>

00102630 <vector168>:
.globl vector168
vector168:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $168
  102632:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102637:	e9 14 04 00 00       	jmp    102a50 <__alltraps>

0010263c <vector169>:
.globl vector169
vector169:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $169
  10263e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102643:	e9 08 04 00 00       	jmp    102a50 <__alltraps>

00102648 <vector170>:
.globl vector170
vector170:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $170
  10264a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10264f:	e9 fc 03 00 00       	jmp    102a50 <__alltraps>

00102654 <vector171>:
.globl vector171
vector171:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $171
  102656:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10265b:	e9 f0 03 00 00       	jmp    102a50 <__alltraps>

00102660 <vector172>:
.globl vector172
vector172:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $172
  102662:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102667:	e9 e4 03 00 00       	jmp    102a50 <__alltraps>

0010266c <vector173>:
.globl vector173
vector173:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $173
  10266e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102673:	e9 d8 03 00 00       	jmp    102a50 <__alltraps>

00102678 <vector174>:
.globl vector174
vector174:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $174
  10267a:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10267f:	e9 cc 03 00 00       	jmp    102a50 <__alltraps>

00102684 <vector175>:
.globl vector175
vector175:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $175
  102686:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10268b:	e9 c0 03 00 00       	jmp    102a50 <__alltraps>

00102690 <vector176>:
.globl vector176
vector176:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $176
  102692:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102697:	e9 b4 03 00 00       	jmp    102a50 <__alltraps>

0010269c <vector177>:
.globl vector177
vector177:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $177
  10269e:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1026a3:	e9 a8 03 00 00       	jmp    102a50 <__alltraps>

001026a8 <vector178>:
.globl vector178
vector178:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $178
  1026aa:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1026af:	e9 9c 03 00 00       	jmp    102a50 <__alltraps>

001026b4 <vector179>:
.globl vector179
vector179:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $179
  1026b6:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1026bb:	e9 90 03 00 00       	jmp    102a50 <__alltraps>

001026c0 <vector180>:
.globl vector180
vector180:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $180
  1026c2:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1026c7:	e9 84 03 00 00       	jmp    102a50 <__alltraps>

001026cc <vector181>:
.globl vector181
vector181:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $181
  1026ce:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1026d3:	e9 78 03 00 00       	jmp    102a50 <__alltraps>

001026d8 <vector182>:
.globl vector182
vector182:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $182
  1026da:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1026df:	e9 6c 03 00 00       	jmp    102a50 <__alltraps>

001026e4 <vector183>:
.globl vector183
vector183:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $183
  1026e6:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1026eb:	e9 60 03 00 00       	jmp    102a50 <__alltraps>

001026f0 <vector184>:
.globl vector184
vector184:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $184
  1026f2:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1026f7:	e9 54 03 00 00       	jmp    102a50 <__alltraps>

001026fc <vector185>:
.globl vector185
vector185:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $185
  1026fe:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102703:	e9 48 03 00 00       	jmp    102a50 <__alltraps>

00102708 <vector186>:
.globl vector186
vector186:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $186
  10270a:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10270f:	e9 3c 03 00 00       	jmp    102a50 <__alltraps>

00102714 <vector187>:
.globl vector187
vector187:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $187
  102716:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10271b:	e9 30 03 00 00       	jmp    102a50 <__alltraps>

00102720 <vector188>:
.globl vector188
vector188:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $188
  102722:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102727:	e9 24 03 00 00       	jmp    102a50 <__alltraps>

0010272c <vector189>:
.globl vector189
vector189:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $189
  10272e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102733:	e9 18 03 00 00       	jmp    102a50 <__alltraps>

00102738 <vector190>:
.globl vector190
vector190:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $190
  10273a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10273f:	e9 0c 03 00 00       	jmp    102a50 <__alltraps>

00102744 <vector191>:
.globl vector191
vector191:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $191
  102746:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10274b:	e9 00 03 00 00       	jmp    102a50 <__alltraps>

00102750 <vector192>:
.globl vector192
vector192:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $192
  102752:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102757:	e9 f4 02 00 00       	jmp    102a50 <__alltraps>

0010275c <vector193>:
.globl vector193
vector193:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $193
  10275e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102763:	e9 e8 02 00 00       	jmp    102a50 <__alltraps>

00102768 <vector194>:
.globl vector194
vector194:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $194
  10276a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10276f:	e9 dc 02 00 00       	jmp    102a50 <__alltraps>

00102774 <vector195>:
.globl vector195
vector195:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $195
  102776:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10277b:	e9 d0 02 00 00       	jmp    102a50 <__alltraps>

00102780 <vector196>:
.globl vector196
vector196:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $196
  102782:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102787:	e9 c4 02 00 00       	jmp    102a50 <__alltraps>

0010278c <vector197>:
.globl vector197
vector197:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $197
  10278e:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102793:	e9 b8 02 00 00       	jmp    102a50 <__alltraps>

00102798 <vector198>:
.globl vector198
vector198:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $198
  10279a:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10279f:	e9 ac 02 00 00       	jmp    102a50 <__alltraps>

001027a4 <vector199>:
.globl vector199
vector199:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $199
  1027a6:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1027ab:	e9 a0 02 00 00       	jmp    102a50 <__alltraps>

001027b0 <vector200>:
.globl vector200
vector200:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $200
  1027b2:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1027b7:	e9 94 02 00 00       	jmp    102a50 <__alltraps>

001027bc <vector201>:
.globl vector201
vector201:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $201
  1027be:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1027c3:	e9 88 02 00 00       	jmp    102a50 <__alltraps>

001027c8 <vector202>:
.globl vector202
vector202:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $202
  1027ca:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1027cf:	e9 7c 02 00 00       	jmp    102a50 <__alltraps>

001027d4 <vector203>:
.globl vector203
vector203:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $203
  1027d6:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1027db:	e9 70 02 00 00       	jmp    102a50 <__alltraps>

001027e0 <vector204>:
.globl vector204
vector204:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $204
  1027e2:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1027e7:	e9 64 02 00 00       	jmp    102a50 <__alltraps>

001027ec <vector205>:
.globl vector205
vector205:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $205
  1027ee:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1027f3:	e9 58 02 00 00       	jmp    102a50 <__alltraps>

001027f8 <vector206>:
.globl vector206
vector206:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $206
  1027fa:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027ff:	e9 4c 02 00 00       	jmp    102a50 <__alltraps>

00102804 <vector207>:
.globl vector207
vector207:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $207
  102806:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10280b:	e9 40 02 00 00       	jmp    102a50 <__alltraps>

00102810 <vector208>:
.globl vector208
vector208:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $208
  102812:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102817:	e9 34 02 00 00       	jmp    102a50 <__alltraps>

0010281c <vector209>:
.globl vector209
vector209:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $209
  10281e:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102823:	e9 28 02 00 00       	jmp    102a50 <__alltraps>

00102828 <vector210>:
.globl vector210
vector210:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $210
  10282a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10282f:	e9 1c 02 00 00       	jmp    102a50 <__alltraps>

00102834 <vector211>:
.globl vector211
vector211:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $211
  102836:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10283b:	e9 10 02 00 00       	jmp    102a50 <__alltraps>

00102840 <vector212>:
.globl vector212
vector212:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $212
  102842:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102847:	e9 04 02 00 00       	jmp    102a50 <__alltraps>

0010284c <vector213>:
.globl vector213
vector213:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $213
  10284e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102853:	e9 f8 01 00 00       	jmp    102a50 <__alltraps>

00102858 <vector214>:
.globl vector214
vector214:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $214
  10285a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10285f:	e9 ec 01 00 00       	jmp    102a50 <__alltraps>

00102864 <vector215>:
.globl vector215
vector215:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $215
  102866:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10286b:	e9 e0 01 00 00       	jmp    102a50 <__alltraps>

00102870 <vector216>:
.globl vector216
vector216:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $216
  102872:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102877:	e9 d4 01 00 00       	jmp    102a50 <__alltraps>

0010287c <vector217>:
.globl vector217
vector217:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $217
  10287e:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102883:	e9 c8 01 00 00       	jmp    102a50 <__alltraps>

00102888 <vector218>:
.globl vector218
vector218:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $218
  10288a:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10288f:	e9 bc 01 00 00       	jmp    102a50 <__alltraps>

00102894 <vector219>:
.globl vector219
vector219:
  pushl $0
  102894:	6a 00                	push   $0x0
  pushl $219
  102896:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10289b:	e9 b0 01 00 00       	jmp    102a50 <__alltraps>

001028a0 <vector220>:
.globl vector220
vector220:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $220
  1028a2:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1028a7:	e9 a4 01 00 00       	jmp    102a50 <__alltraps>

001028ac <vector221>:
.globl vector221
vector221:
  pushl $0
  1028ac:	6a 00                	push   $0x0
  pushl $221
  1028ae:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1028b3:	e9 98 01 00 00       	jmp    102a50 <__alltraps>

001028b8 <vector222>:
.globl vector222
vector222:
  pushl $0
  1028b8:	6a 00                	push   $0x0
  pushl $222
  1028ba:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1028bf:	e9 8c 01 00 00       	jmp    102a50 <__alltraps>

001028c4 <vector223>:
.globl vector223
vector223:
  pushl $0
  1028c4:	6a 00                	push   $0x0
  pushl $223
  1028c6:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1028cb:	e9 80 01 00 00       	jmp    102a50 <__alltraps>

001028d0 <vector224>:
.globl vector224
vector224:
  pushl $0
  1028d0:	6a 00                	push   $0x0
  pushl $224
  1028d2:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1028d7:	e9 74 01 00 00       	jmp    102a50 <__alltraps>

001028dc <vector225>:
.globl vector225
vector225:
  pushl $0
  1028dc:	6a 00                	push   $0x0
  pushl $225
  1028de:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1028e3:	e9 68 01 00 00       	jmp    102a50 <__alltraps>

001028e8 <vector226>:
.globl vector226
vector226:
  pushl $0
  1028e8:	6a 00                	push   $0x0
  pushl $226
  1028ea:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1028ef:	e9 5c 01 00 00       	jmp    102a50 <__alltraps>

001028f4 <vector227>:
.globl vector227
vector227:
  pushl $0
  1028f4:	6a 00                	push   $0x0
  pushl $227
  1028f6:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028fb:	e9 50 01 00 00       	jmp    102a50 <__alltraps>

00102900 <vector228>:
.globl vector228
vector228:
  pushl $0
  102900:	6a 00                	push   $0x0
  pushl $228
  102902:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102907:	e9 44 01 00 00       	jmp    102a50 <__alltraps>

0010290c <vector229>:
.globl vector229
vector229:
  pushl $0
  10290c:	6a 00                	push   $0x0
  pushl $229
  10290e:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102913:	e9 38 01 00 00       	jmp    102a50 <__alltraps>

00102918 <vector230>:
.globl vector230
vector230:
  pushl $0
  102918:	6a 00                	push   $0x0
  pushl $230
  10291a:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10291f:	e9 2c 01 00 00       	jmp    102a50 <__alltraps>

00102924 <vector231>:
.globl vector231
vector231:
  pushl $0
  102924:	6a 00                	push   $0x0
  pushl $231
  102926:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10292b:	e9 20 01 00 00       	jmp    102a50 <__alltraps>

00102930 <vector232>:
.globl vector232
vector232:
  pushl $0
  102930:	6a 00                	push   $0x0
  pushl $232
  102932:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102937:	e9 14 01 00 00       	jmp    102a50 <__alltraps>

0010293c <vector233>:
.globl vector233
vector233:
  pushl $0
  10293c:	6a 00                	push   $0x0
  pushl $233
  10293e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102943:	e9 08 01 00 00       	jmp    102a50 <__alltraps>

00102948 <vector234>:
.globl vector234
vector234:
  pushl $0
  102948:	6a 00                	push   $0x0
  pushl $234
  10294a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10294f:	e9 fc 00 00 00       	jmp    102a50 <__alltraps>

00102954 <vector235>:
.globl vector235
vector235:
  pushl $0
  102954:	6a 00                	push   $0x0
  pushl $235
  102956:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10295b:	e9 f0 00 00 00       	jmp    102a50 <__alltraps>

00102960 <vector236>:
.globl vector236
vector236:
  pushl $0
  102960:	6a 00                	push   $0x0
  pushl $236
  102962:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102967:	e9 e4 00 00 00       	jmp    102a50 <__alltraps>

0010296c <vector237>:
.globl vector237
vector237:
  pushl $0
  10296c:	6a 00                	push   $0x0
  pushl $237
  10296e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102973:	e9 d8 00 00 00       	jmp    102a50 <__alltraps>

00102978 <vector238>:
.globl vector238
vector238:
  pushl $0
  102978:	6a 00                	push   $0x0
  pushl $238
  10297a:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10297f:	e9 cc 00 00 00       	jmp    102a50 <__alltraps>

00102984 <vector239>:
.globl vector239
vector239:
  pushl $0
  102984:	6a 00                	push   $0x0
  pushl $239
  102986:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10298b:	e9 c0 00 00 00       	jmp    102a50 <__alltraps>

00102990 <vector240>:
.globl vector240
vector240:
  pushl $0
  102990:	6a 00                	push   $0x0
  pushl $240
  102992:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102997:	e9 b4 00 00 00       	jmp    102a50 <__alltraps>

0010299c <vector241>:
.globl vector241
vector241:
  pushl $0
  10299c:	6a 00                	push   $0x0
  pushl $241
  10299e:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1029a3:	e9 a8 00 00 00       	jmp    102a50 <__alltraps>

001029a8 <vector242>:
.globl vector242
vector242:
  pushl $0
  1029a8:	6a 00                	push   $0x0
  pushl $242
  1029aa:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1029af:	e9 9c 00 00 00       	jmp    102a50 <__alltraps>

001029b4 <vector243>:
.globl vector243
vector243:
  pushl $0
  1029b4:	6a 00                	push   $0x0
  pushl $243
  1029b6:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1029bb:	e9 90 00 00 00       	jmp    102a50 <__alltraps>

001029c0 <vector244>:
.globl vector244
vector244:
  pushl $0
  1029c0:	6a 00                	push   $0x0
  pushl $244
  1029c2:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1029c7:	e9 84 00 00 00       	jmp    102a50 <__alltraps>

001029cc <vector245>:
.globl vector245
vector245:
  pushl $0
  1029cc:	6a 00                	push   $0x0
  pushl $245
  1029ce:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1029d3:	e9 78 00 00 00       	jmp    102a50 <__alltraps>

001029d8 <vector246>:
.globl vector246
vector246:
  pushl $0
  1029d8:	6a 00                	push   $0x0
  pushl $246
  1029da:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1029df:	e9 6c 00 00 00       	jmp    102a50 <__alltraps>

001029e4 <vector247>:
.globl vector247
vector247:
  pushl $0
  1029e4:	6a 00                	push   $0x0
  pushl $247
  1029e6:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1029eb:	e9 60 00 00 00       	jmp    102a50 <__alltraps>

001029f0 <vector248>:
.globl vector248
vector248:
  pushl $0
  1029f0:	6a 00                	push   $0x0
  pushl $248
  1029f2:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1029f7:	e9 54 00 00 00       	jmp    102a50 <__alltraps>

001029fc <vector249>:
.globl vector249
vector249:
  pushl $0
  1029fc:	6a 00                	push   $0x0
  pushl $249
  1029fe:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a03:	e9 48 00 00 00       	jmp    102a50 <__alltraps>

00102a08 <vector250>:
.globl vector250
vector250:
  pushl $0
  102a08:	6a 00                	push   $0x0
  pushl $250
  102a0a:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a0f:	e9 3c 00 00 00       	jmp    102a50 <__alltraps>

00102a14 <vector251>:
.globl vector251
vector251:
  pushl $0
  102a14:	6a 00                	push   $0x0
  pushl $251
  102a16:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a1b:	e9 30 00 00 00       	jmp    102a50 <__alltraps>

00102a20 <vector252>:
.globl vector252
vector252:
  pushl $0
  102a20:	6a 00                	push   $0x0
  pushl $252
  102a22:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a27:	e9 24 00 00 00       	jmp    102a50 <__alltraps>

00102a2c <vector253>:
.globl vector253
vector253:
  pushl $0
  102a2c:	6a 00                	push   $0x0
  pushl $253
  102a2e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a33:	e9 18 00 00 00       	jmp    102a50 <__alltraps>

00102a38 <vector254>:
.globl vector254
vector254:
  pushl $0
  102a38:	6a 00                	push   $0x0
  pushl $254
  102a3a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a3f:	e9 0c 00 00 00       	jmp    102a50 <__alltraps>

00102a44 <vector255>:
.globl vector255
vector255:
  pushl $0
  102a44:	6a 00                	push   $0x0
  pushl $255
  102a46:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a4b:	e9 00 00 00 00       	jmp    102a50 <__alltraps>

00102a50 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102a50:	1e                   	push   %ds
    pushl %es
  102a51:	06                   	push   %es
    pushl %fs
  102a52:	0f a0                	push   %fs
    pushl %gs
  102a54:	0f a8                	push   %gs
    pushal
  102a56:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102a57:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102a5c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102a5e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102a60:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102a61:	e8 60 f5 ff ff       	call   101fc6 <trap>

    # pop the pushed stack pointer
    popl %esp
  102a66:	5c                   	pop    %esp

00102a67 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102a67:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102a68:	0f a9                	pop    %gs
    popl %fs
  102a6a:	0f a1                	pop    %fs
    popl %es
  102a6c:	07                   	pop    %es
    popl %ds
  102a6d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102a6e:	83 c4 08             	add    $0x8,%esp
    iret
  102a71:	cf                   	iret   

00102a72 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102a72:	55                   	push   %ebp
  102a73:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102a75:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  102a7a:	8b 55 08             	mov    0x8(%ebp),%edx
  102a7d:	29 c2                	sub    %eax,%edx
  102a7f:	89 d0                	mov    %edx,%eax
  102a81:	c1 f8 02             	sar    $0x2,%eax
  102a84:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102a8a:	5d                   	pop    %ebp
  102a8b:	c3                   	ret    

00102a8c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102a8c:	55                   	push   %ebp
  102a8d:	89 e5                	mov    %esp,%ebp
  102a8f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102a92:	8b 45 08             	mov    0x8(%ebp),%eax
  102a95:	89 04 24             	mov    %eax,(%esp)
  102a98:	e8 d5 ff ff ff       	call   102a72 <page2ppn>
  102a9d:	c1 e0 0c             	shl    $0xc,%eax
}
  102aa0:	c9                   	leave  
  102aa1:	c3                   	ret    

00102aa2 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102aa2:	55                   	push   %ebp
  102aa3:	89 e5                	mov    %esp,%ebp
  102aa5:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  102aab:	c1 e8 0c             	shr    $0xc,%eax
  102aae:	89 c2                	mov    %eax,%edx
  102ab0:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102ab5:	39 c2                	cmp    %eax,%edx
  102ab7:	72 1c                	jb     102ad5 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102ab9:	c7 44 24 08 70 69 10 	movl   $0x106970,0x8(%esp)
  102ac0:	00 
  102ac1:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102ac8:	00 
  102ac9:	c7 04 24 8f 69 10 00 	movl   $0x10698f,(%esp)
  102ad0:	e8 70 d9 ff ff       	call   100445 <__panic>
    }
    return &pages[PPN(pa)];
  102ad5:	8b 0d 18 cf 11 00    	mov    0x11cf18,%ecx
  102adb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ade:	c1 e8 0c             	shr    $0xc,%eax
  102ae1:	89 c2                	mov    %eax,%edx
  102ae3:	89 d0                	mov    %edx,%eax
  102ae5:	c1 e0 02             	shl    $0x2,%eax
  102ae8:	01 d0                	add    %edx,%eax
  102aea:	c1 e0 02             	shl    $0x2,%eax
  102aed:	01 c8                	add    %ecx,%eax
}
  102aef:	c9                   	leave  
  102af0:	c3                   	ret    

00102af1 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102af1:	55                   	push   %ebp
  102af2:	89 e5                	mov    %esp,%ebp
  102af4:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102af7:	8b 45 08             	mov    0x8(%ebp),%eax
  102afa:	89 04 24             	mov    %eax,(%esp)
  102afd:	e8 8a ff ff ff       	call   102a8c <page2pa>
  102b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b08:	c1 e8 0c             	shr    $0xc,%eax
  102b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b0e:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102b13:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102b16:	72 23                	jb     102b3b <page2kva+0x4a>
  102b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102b1f:	c7 44 24 08 a0 69 10 	movl   $0x1069a0,0x8(%esp)
  102b26:	00 
  102b27:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102b2e:	00 
  102b2f:	c7 04 24 8f 69 10 00 	movl   $0x10698f,(%esp)
  102b36:	e8 0a d9 ff ff       	call   100445 <__panic>
  102b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b3e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102b43:	c9                   	leave  
  102b44:	c3                   	ret    

00102b45 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102b45:	55                   	push   %ebp
  102b46:	89 e5                	mov    %esp,%ebp
  102b48:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4e:	83 e0 01             	and    $0x1,%eax
  102b51:	85 c0                	test   %eax,%eax
  102b53:	75 1c                	jne    102b71 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102b55:	c7 44 24 08 c4 69 10 	movl   $0x1069c4,0x8(%esp)
  102b5c:	00 
  102b5d:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102b64:	00 
  102b65:	c7 04 24 8f 69 10 00 	movl   $0x10698f,(%esp)
  102b6c:	e8 d4 d8 ff ff       	call   100445 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102b71:	8b 45 08             	mov    0x8(%ebp),%eax
  102b74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b79:	89 04 24             	mov    %eax,(%esp)
  102b7c:	e8 21 ff ff ff       	call   102aa2 <pa2page>
}
  102b81:	c9                   	leave  
  102b82:	c3                   	ret    

00102b83 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102b83:	55                   	push   %ebp
  102b84:	89 e5                	mov    %esp,%ebp
  102b86:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102b89:	8b 45 08             	mov    0x8(%ebp),%eax
  102b8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b91:	89 04 24             	mov    %eax,(%esp)
  102b94:	e8 09 ff ff ff       	call   102aa2 <pa2page>
}
  102b99:	c9                   	leave  
  102b9a:	c3                   	ret    

00102b9b <page_ref>:

static inline int
page_ref(struct Page *page) {
  102b9b:	55                   	push   %ebp
  102b9c:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba1:	8b 00                	mov    (%eax),%eax
}
  102ba3:	5d                   	pop    %ebp
  102ba4:	c3                   	ret    

00102ba5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102ba5:	55                   	push   %ebp
  102ba6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  102bae:	89 10                	mov    %edx,(%eax)
}
  102bb0:	90                   	nop
  102bb1:	5d                   	pop    %ebp
  102bb2:	c3                   	ret    

00102bb3 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102bb3:	55                   	push   %ebp
  102bb4:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb9:	8b 00                	mov    (%eax),%eax
  102bbb:	8d 50 01             	lea    0x1(%eax),%edx
  102bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc1:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc6:	8b 00                	mov    (%eax),%eax
}
  102bc8:	5d                   	pop    %ebp
  102bc9:	c3                   	ret    

00102bca <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102bca:	55                   	push   %ebp
  102bcb:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd0:	8b 00                	mov    (%eax),%eax
  102bd2:	8d 50 ff             	lea    -0x1(%eax),%edx
  102bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd8:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102bda:	8b 45 08             	mov    0x8(%ebp),%eax
  102bdd:	8b 00                	mov    (%eax),%eax
}
  102bdf:	5d                   	pop    %ebp
  102be0:	c3                   	ret    

00102be1 <__intr_save>:
__intr_save(void) {
  102be1:	55                   	push   %ebp
  102be2:	89 e5                	mov    %esp,%ebp
  102be4:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102be7:	9c                   	pushf  
  102be8:	58                   	pop    %eax
  102be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102bef:	25 00 02 00 00       	and    $0x200,%eax
  102bf4:	85 c0                	test   %eax,%eax
  102bf6:	74 0c                	je     102c04 <__intr_save+0x23>
        intr_disable();
  102bf8:	e8 b2 ed ff ff       	call   1019af <intr_disable>
        return 1;
  102bfd:	b8 01 00 00 00       	mov    $0x1,%eax
  102c02:	eb 05                	jmp    102c09 <__intr_save+0x28>
    return 0;
  102c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c09:	c9                   	leave  
  102c0a:	c3                   	ret    

00102c0b <__intr_restore>:
__intr_restore(bool flag) {
  102c0b:	55                   	push   %ebp
  102c0c:	89 e5                	mov    %esp,%ebp
  102c0e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102c11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102c15:	74 05                	je     102c1c <__intr_restore+0x11>
        intr_enable();
  102c17:	e8 87 ed ff ff       	call   1019a3 <intr_enable>
}
  102c1c:	90                   	nop
  102c1d:	c9                   	leave  
  102c1e:	c3                   	ret    

00102c1f <lgdt>:
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd)
{
  102c1f:	55                   	push   %ebp
  102c20:	89 e5                	mov    %esp,%ebp
    asm volatile("lgdt (%0)" ::"r"(pd));
  102c22:	8b 45 08             	mov    0x8(%ebp),%eax
  102c25:	0f 01 10             	lgdtl  (%eax)
    asm volatile("movw %%ax, %%gs" ::"a"(USER_DS));
  102c28:	b8 23 00 00 00       	mov    $0x23,%eax
  102c2d:	8e e8                	mov    %eax,%gs
    asm volatile("movw %%ax, %%fs" ::"a"(USER_DS));
  102c2f:	b8 23 00 00 00       	mov    $0x23,%eax
  102c34:	8e e0                	mov    %eax,%fs
    asm volatile("movw %%ax, %%es" ::"a"(KERNEL_DS));
  102c36:	b8 10 00 00 00       	mov    $0x10,%eax
  102c3b:	8e c0                	mov    %eax,%es
    asm volatile("movw %%ax, %%ds" ::"a"(KERNEL_DS));
  102c3d:	b8 10 00 00 00       	mov    $0x10,%eax
  102c42:	8e d8                	mov    %eax,%ds
    asm volatile("movw %%ax, %%ss" ::"a"(KERNEL_DS));
  102c44:	b8 10 00 00 00       	mov    $0x10,%eax
  102c49:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile("ljmp %0, $1f\n 1:\n" ::"i"(KERNEL_CS));
  102c4b:	ea 52 2c 10 00 08 00 	ljmp   $0x8,$0x102c52
}
  102c52:	90                   	nop
  102c53:	5d                   	pop    %ebp
  102c54:	c3                   	ret    

00102c55 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void load_esp0(uintptr_t esp0)
{
  102c55:	f3 0f 1e fb          	endbr32 
  102c59:	55                   	push   %ebp
  102c5a:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5f:	a3 a4 ce 11 00       	mov    %eax,0x11cea4
}
  102c64:	90                   	nop
  102c65:	5d                   	pop    %ebp
  102c66:	c3                   	ret    

00102c67 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void)
{
  102c67:	f3 0f 1e fb          	endbr32 
  102c6b:	55                   	push   %ebp
  102c6c:	89 e5                	mov    %esp,%ebp
  102c6e:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102c71:	b8 00 90 11 00       	mov    $0x119000,%eax
  102c76:	89 04 24             	mov    %eax,(%esp)
  102c79:	e8 d7 ff ff ff       	call   102c55 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102c7e:	66 c7 05 a8 ce 11 00 	movw   $0x10,0x11cea8
  102c85:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102c87:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  102c8e:	68 00 
  102c90:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102c95:	0f b7 c0             	movzwl %ax,%eax
  102c98:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  102c9e:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102ca3:	c1 e8 10             	shr    $0x10,%eax
  102ca6:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  102cab:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102cb2:	24 f0                	and    $0xf0,%al
  102cb4:	0c 09                	or     $0x9,%al
  102cb6:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102cbb:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102cc2:	24 ef                	and    $0xef,%al
  102cc4:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102cc9:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102cd0:	24 9f                	and    $0x9f,%al
  102cd2:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102cd7:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102cde:	0c 80                	or     $0x80,%al
  102ce0:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102ce5:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102cec:	24 f0                	and    $0xf0,%al
  102cee:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102cf3:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102cfa:	24 ef                	and    $0xef,%al
  102cfc:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102d01:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102d08:	24 df                	and    $0xdf,%al
  102d0a:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102d0f:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102d16:	0c 40                	or     $0x40,%al
  102d18:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102d1d:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102d24:	24 7f                	and    $0x7f,%al
  102d26:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102d2b:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102d30:	c1 e8 18             	shr    $0x18,%eax
  102d33:	a2 2f 9a 11 00       	mov    %al,0x119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102d38:	c7 04 24 30 9a 11 00 	movl   $0x119a30,(%esp)
  102d3f:	e8 db fe ff ff       	call   102c1f <lgdt>
  102d44:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102d4a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102d4e:	0f 00 d8             	ltr    %ax
}
  102d51:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102d52:	90                   	nop
  102d53:	c9                   	leave  
  102d54:	c3                   	ret    

00102d55 <init_pmm_manager>:

// init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void)
{
  102d55:	f3 0f 1e fb          	endbr32 
  102d59:	55                   	push   %ebp
  102d5a:	89 e5                	mov    %esp,%ebp
  102d5c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102d5f:	c7 05 10 cf 11 00 80 	movl   $0x107380,0x11cf10
  102d66:	73 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102d69:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d6e:	8b 00                	mov    (%eax),%eax
  102d70:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d74:	c7 04 24 f0 69 10 00 	movl   $0x1069f0,(%esp)
  102d7b:	e8 59 d5 ff ff       	call   1002d9 <cprintf>
    pmm_manager->init();
  102d80:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d85:	8b 40 04             	mov    0x4(%eax),%eax
  102d88:	ff d0                	call   *%eax
}
  102d8a:	90                   	nop
  102d8b:	c9                   	leave  
  102d8c:	c3                   	ret    

00102d8d <init_memmap>:

// init_memmap - call pmm->init_memmap to build Page struct for free memory
static void
init_memmap(struct Page *base, size_t n)
{
  102d8d:	f3 0f 1e fb          	endbr32 
  102d91:	55                   	push   %ebp
  102d92:	89 e5                	mov    %esp,%ebp
  102d94:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102d97:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d9c:	8b 40 08             	mov    0x8(%eax),%eax
  102d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102da2:	89 54 24 04          	mov    %edx,0x4(%esp)
  102da6:	8b 55 08             	mov    0x8(%ebp),%edx
  102da9:	89 14 24             	mov    %edx,(%esp)
  102dac:	ff d0                	call   *%eax
}
  102dae:	90                   	nop
  102daf:	c9                   	leave  
  102db0:	c3                   	ret    

00102db1 <alloc_pages>:

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory
struct Page *
alloc_pages(size_t n)
{
  102db1:	f3 0f 1e fb          	endbr32 
  102db5:	55                   	push   %ebp
  102db6:	89 e5                	mov    %esp,%ebp
  102db8:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = NULL;
  102dbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102dc2:	e8 1a fe ff ff       	call   102be1 <__intr_save>
  102dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102dca:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102dcf:	8b 40 0c             	mov    0xc(%eax),%eax
  102dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  102dd5:	89 14 24             	mov    %edx,(%esp)
  102dd8:	ff d0                	call   *%eax
  102dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de0:	89 04 24             	mov    %eax,(%esp)
  102de3:	e8 23 fe ff ff       	call   102c0b <__intr_restore>
    return page;
  102de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102deb:	c9                   	leave  
  102dec:	c3                   	ret    

00102ded <free_pages>:

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n)
{
  102ded:	f3 0f 1e fb          	endbr32 
  102df1:	55                   	push   %ebp
  102df2:	89 e5                	mov    %esp,%ebp
  102df4:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102df7:	e8 e5 fd ff ff       	call   102be1 <__intr_save>
  102dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102dff:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102e04:	8b 40 10             	mov    0x10(%eax),%eax
  102e07:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e0a:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  102e11:	89 14 24             	mov    %edx,(%esp)
  102e14:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e19:	89 04 24             	mov    %eax,(%esp)
  102e1c:	e8 ea fd ff ff       	call   102c0b <__intr_restore>
}
  102e21:	90                   	nop
  102e22:	c9                   	leave  
  102e23:	c3                   	ret    

00102e24 <nr_free_pages>:

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t
nr_free_pages(void)
{
  102e24:	f3 0f 1e fb          	endbr32 
  102e28:	55                   	push   %ebp
  102e29:	89 e5                	mov    %esp,%ebp
  102e2b:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102e2e:	e8 ae fd ff ff       	call   102be1 <__intr_save>
  102e33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102e36:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102e3b:	8b 40 14             	mov    0x14(%eax),%eax
  102e3e:	ff d0                	call   *%eax
  102e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e46:	89 04 24             	mov    %eax,(%esp)
  102e49:	e8 bd fd ff ff       	call   102c0b <__intr_restore>
    return ret;
  102e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102e51:	c9                   	leave  
  102e52:	c3                   	ret    

00102e53 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void)
{
  102e53:	f3 0f 1e fb          	endbr32 
  102e57:	55                   	push   %ebp
  102e58:	89 e5                	mov    %esp,%ebp
  102e5a:	57                   	push   %edi
  102e5b:	56                   	push   %esi
  102e5c:	53                   	push   %ebx
  102e5d:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102e63:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102e6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102e71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102e78:	c7 04 24 07 6a 10 00 	movl   $0x106a07,(%esp)
  102e7f:	e8 55 d4 ff ff       	call   1002d9 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i++)
  102e84:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e8b:	e9 1a 01 00 00       	jmp    102faa <page_init+0x157>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102e90:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e93:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e96:	89 d0                	mov    %edx,%eax
  102e98:	c1 e0 02             	shl    $0x2,%eax
  102e9b:	01 d0                	add    %edx,%eax
  102e9d:	c1 e0 02             	shl    $0x2,%eax
  102ea0:	01 c8                	add    %ecx,%eax
  102ea2:	8b 50 08             	mov    0x8(%eax),%edx
  102ea5:	8b 40 04             	mov    0x4(%eax),%eax
  102ea8:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102eab:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102eae:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102eb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102eb4:	89 d0                	mov    %edx,%eax
  102eb6:	c1 e0 02             	shl    $0x2,%eax
  102eb9:	01 d0                	add    %edx,%eax
  102ebb:	c1 e0 02             	shl    $0x2,%eax
  102ebe:	01 c8                	add    %ecx,%eax
  102ec0:	8b 48 0c             	mov    0xc(%eax),%ecx
  102ec3:	8b 58 10             	mov    0x10(%eax),%ebx
  102ec6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102ec9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102ecc:	01 c8                	add    %ecx,%eax
  102ece:	11 da                	adc    %ebx,%edx
  102ed0:	89 45 98             	mov    %eax,-0x68(%ebp)
  102ed3:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102ed6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ed9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102edc:	89 d0                	mov    %edx,%eax
  102ede:	c1 e0 02             	shl    $0x2,%eax
  102ee1:	01 d0                	add    %edx,%eax
  102ee3:	c1 e0 02             	shl    $0x2,%eax
  102ee6:	01 c8                	add    %ecx,%eax
  102ee8:	83 c0 14             	add    $0x14,%eax
  102eeb:	8b 00                	mov    (%eax),%eax
  102eed:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102ef0:	8b 45 98             	mov    -0x68(%ebp),%eax
  102ef3:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102ef6:	83 c0 ff             	add    $0xffffffff,%eax
  102ef9:	83 d2 ff             	adc    $0xffffffff,%edx
  102efc:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102f02:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102f08:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f0e:	89 d0                	mov    %edx,%eax
  102f10:	c1 e0 02             	shl    $0x2,%eax
  102f13:	01 d0                	add    %edx,%eax
  102f15:	c1 e0 02             	shl    $0x2,%eax
  102f18:	01 c8                	add    %ecx,%eax
  102f1a:	8b 48 0c             	mov    0xc(%eax),%ecx
  102f1d:	8b 58 10             	mov    0x10(%eax),%ebx
  102f20:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102f23:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102f27:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102f2d:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102f33:	89 44 24 14          	mov    %eax,0x14(%esp)
  102f37:	89 54 24 18          	mov    %edx,0x18(%esp)
  102f3b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f3e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102f41:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f45:	89 54 24 10          	mov    %edx,0x10(%esp)
  102f49:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102f4d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102f51:	c7 04 24 14 6a 10 00 	movl   $0x106a14,(%esp)
  102f58:	e8 7c d3 ff ff       	call   1002d9 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM)
  102f5d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f60:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f63:	89 d0                	mov    %edx,%eax
  102f65:	c1 e0 02             	shl    $0x2,%eax
  102f68:	01 d0                	add    %edx,%eax
  102f6a:	c1 e0 02             	shl    $0x2,%eax
  102f6d:	01 c8                	add    %ecx,%eax
  102f6f:	83 c0 14             	add    $0x14,%eax
  102f72:	8b 00                	mov    (%eax),%eax
  102f74:	83 f8 01             	cmp    $0x1,%eax
  102f77:	75 2e                	jne    102fa7 <page_init+0x154>
        {
            if (maxpa < end && begin < KMEMSIZE)
  102f79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f7f:	3b 45 98             	cmp    -0x68(%ebp),%eax
  102f82:	89 d0                	mov    %edx,%eax
  102f84:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  102f87:	73 1e                	jae    102fa7 <page_init+0x154>
  102f89:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  102f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  102f93:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  102f96:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  102f99:	72 0c                	jb     102fa7 <page_init+0x154>
            {
                maxpa = end;
  102f9b:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f9e:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102fa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fa4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i++)
  102fa7:	ff 45 dc             	incl   -0x24(%ebp)
  102faa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102fad:	8b 00                	mov    (%eax),%eax
  102faf:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102fb2:	0f 8c d8 fe ff ff    	jl     102e90 <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE)
  102fb8:	ba 00 00 00 38       	mov    $0x38000000,%edx
  102fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  102fc2:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  102fc5:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  102fc8:	73 0e                	jae    102fd8 <page_init+0x185>
    {
        maxpa = KMEMSIZE;
  102fca:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102fd1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fdb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102fde:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102fe2:	c1 ea 0c             	shr    $0xc,%edx
  102fe5:	a3 80 ce 11 00       	mov    %eax,0x11ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102fea:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  102ff1:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  102ff6:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ff9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102ffc:	01 d0                	add    %edx,%eax
  102ffe:	89 45 bc             	mov    %eax,-0x44(%ebp)
  103001:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103004:	ba 00 00 00 00       	mov    $0x0,%edx
  103009:	f7 75 c0             	divl   -0x40(%ebp)
  10300c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10300f:	29 d0                	sub    %edx,%eax
  103011:	a3 18 cf 11 00       	mov    %eax,0x11cf18

    for (i = 0; i < npage; i++)
  103016:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10301d:	eb 2f                	jmp    10304e <page_init+0x1fb>
    {
        SetPageReserved(pages + i);
  10301f:	8b 0d 18 cf 11 00    	mov    0x11cf18,%ecx
  103025:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103028:	89 d0                	mov    %edx,%eax
  10302a:	c1 e0 02             	shl    $0x2,%eax
  10302d:	01 d0                	add    %edx,%eax
  10302f:	c1 e0 02             	shl    $0x2,%eax
  103032:	01 c8                	add    %ecx,%eax
  103034:	83 c0 04             	add    $0x4,%eax
  103037:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  10303e:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103041:	8b 45 90             	mov    -0x70(%ebp),%eax
  103044:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103047:	0f ab 10             	bts    %edx,(%eax)
}
  10304a:	90                   	nop
    for (i = 0; i < npage; i++)
  10304b:	ff 45 dc             	incl   -0x24(%ebp)
  10304e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103051:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103056:	39 c2                	cmp    %eax,%edx
  103058:	72 c5                	jb     10301f <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  10305a:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  103060:	89 d0                	mov    %edx,%eax
  103062:	c1 e0 02             	shl    $0x2,%eax
  103065:	01 d0                	add    %edx,%eax
  103067:	c1 e0 02             	shl    $0x2,%eax
  10306a:	89 c2                	mov    %eax,%edx
  10306c:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  103071:	01 d0                	add    %edx,%eax
  103073:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103076:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  10307d:	77 23                	ja     1030a2 <page_init+0x24f>
  10307f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103086:	c7 44 24 08 44 6a 10 	movl   $0x106a44,0x8(%esp)
  10308d:	00 
  10308e:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  103095:	00 
  103096:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  10309d:	e8 a3 d3 ff ff       	call   100445 <__panic>
  1030a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1030a5:	05 00 00 00 40       	add    $0x40000000,%eax
  1030aa:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i++)
  1030ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1030b4:	e9 4b 01 00 00       	jmp    103204 <page_init+0x3b1>
    {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1030b9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030bf:	89 d0                	mov    %edx,%eax
  1030c1:	c1 e0 02             	shl    $0x2,%eax
  1030c4:	01 d0                	add    %edx,%eax
  1030c6:	c1 e0 02             	shl    $0x2,%eax
  1030c9:	01 c8                	add    %ecx,%eax
  1030cb:	8b 50 08             	mov    0x8(%eax),%edx
  1030ce:	8b 40 04             	mov    0x4(%eax),%eax
  1030d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1030d7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030dd:	89 d0                	mov    %edx,%eax
  1030df:	c1 e0 02             	shl    $0x2,%eax
  1030e2:	01 d0                	add    %edx,%eax
  1030e4:	c1 e0 02             	shl    $0x2,%eax
  1030e7:	01 c8                	add    %ecx,%eax
  1030e9:	8b 48 0c             	mov    0xc(%eax),%ecx
  1030ec:	8b 58 10             	mov    0x10(%eax),%ebx
  1030ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030f5:	01 c8                	add    %ecx,%eax
  1030f7:	11 da                	adc    %ebx,%edx
  1030f9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1030fc:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM)
  1030ff:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103102:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103105:	89 d0                	mov    %edx,%eax
  103107:	c1 e0 02             	shl    $0x2,%eax
  10310a:	01 d0                	add    %edx,%eax
  10310c:	c1 e0 02             	shl    $0x2,%eax
  10310f:	01 c8                	add    %ecx,%eax
  103111:	83 c0 14             	add    $0x14,%eax
  103114:	8b 00                	mov    (%eax),%eax
  103116:	83 f8 01             	cmp    $0x1,%eax
  103119:	0f 85 e2 00 00 00    	jne    103201 <page_init+0x3ae>
        {
            if (begin < freemem)
  10311f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103122:	ba 00 00 00 00       	mov    $0x0,%edx
  103127:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10312a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10312d:	19 d1                	sbb    %edx,%ecx
  10312f:	73 0d                	jae    10313e <page_init+0x2eb>
            {
                begin = freemem;
  103131:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103134:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103137:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE)
  10313e:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103143:	b8 00 00 00 00       	mov    $0x0,%eax
  103148:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  10314b:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10314e:	73 0e                	jae    10315e <page_init+0x30b>
            {
                end = KMEMSIZE;
  103150:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103157:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end)
  10315e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103161:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103164:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103167:	89 d0                	mov    %edx,%eax
  103169:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10316c:	0f 83 8f 00 00 00    	jae    103201 <page_init+0x3ae>
            {
                begin = ROUNDUP(begin, PGSIZE);
  103172:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  103179:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10317c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10317f:	01 d0                	add    %edx,%eax
  103181:	48                   	dec    %eax
  103182:	89 45 ac             	mov    %eax,-0x54(%ebp)
  103185:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103188:	ba 00 00 00 00       	mov    $0x0,%edx
  10318d:	f7 75 b0             	divl   -0x50(%ebp)
  103190:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103193:	29 d0                	sub    %edx,%eax
  103195:	ba 00 00 00 00       	mov    $0x0,%edx
  10319a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10319d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1031a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1031a3:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1031a6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1031a9:	ba 00 00 00 00       	mov    $0x0,%edx
  1031ae:	89 c3                	mov    %eax,%ebx
  1031b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  1031b6:	89 de                	mov    %ebx,%esi
  1031b8:	89 d0                	mov    %edx,%eax
  1031ba:	83 e0 00             	and    $0x0,%eax
  1031bd:	89 c7                	mov    %eax,%edi
  1031bf:	89 75 c8             	mov    %esi,-0x38(%ebp)
  1031c2:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end)
  1031c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1031c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1031cb:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1031ce:	89 d0                	mov    %edx,%eax
  1031d0:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1031d3:	73 2c                	jae    103201 <page_init+0x3ae>
                {
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1031d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1031d8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1031db:	2b 45 d0             	sub    -0x30(%ebp),%eax
  1031de:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  1031e1:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1031e5:	c1 ea 0c             	shr    $0xc,%edx
  1031e8:	89 c3                	mov    %eax,%ebx
  1031ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1031ed:	89 04 24             	mov    %eax,(%esp)
  1031f0:	e8 ad f8 ff ff       	call   102aa2 <pa2page>
  1031f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1031f9:	89 04 24             	mov    %eax,(%esp)
  1031fc:	e8 8c fb ff ff       	call   102d8d <init_memmap>
    for (i = 0; i < memmap->nr_map; i++)
  103201:	ff 45 dc             	incl   -0x24(%ebp)
  103204:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103207:	8b 00                	mov    (%eax),%eax
  103209:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10320c:	0f 8c a7 fe ff ff    	jl     1030b9 <page_init+0x266>
                }
            }
        }
    }
}
  103212:	90                   	nop
  103213:	90                   	nop
  103214:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  10321a:	5b                   	pop    %ebx
  10321b:	5e                   	pop    %esi
  10321c:	5f                   	pop    %edi
  10321d:	5d                   	pop    %ebp
  10321e:	c3                   	ret    

0010321f <boot_map_segment>:
//   size: memory size
//   pa:   physical address of this memory
//   perm: permission of this memory
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm)
{
  10321f:	f3 0f 1e fb          	endbr32 
  103223:	55                   	push   %ebp
  103224:	89 e5                	mov    %esp,%ebp
  103226:	83 ec 38             	sub    $0x38,%esp
    // 将boot_pgdir[1]的Present位给设置为0，让get_pte函数重新分配
    // boot_pgdir[1] &= ~PTE_P;
    assert(PGOFF(la) == PGOFF(pa));
  103229:	8b 45 0c             	mov    0xc(%ebp),%eax
  10322c:	33 45 14             	xor    0x14(%ebp),%eax
  10322f:	25 ff 0f 00 00       	and    $0xfff,%eax
  103234:	85 c0                	test   %eax,%eax
  103236:	74 24                	je     10325c <boot_map_segment+0x3d>
  103238:	c7 44 24 0c 76 6a 10 	movl   $0x106a76,0xc(%esp)
  10323f:	00 
  103240:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103247:	00 
  103248:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  10324f:	00 
  103250:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103257:	e8 e9 d1 ff ff       	call   100445 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10325c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103263:	8b 45 0c             	mov    0xc(%ebp),%eax
  103266:	25 ff 0f 00 00       	and    $0xfff,%eax
  10326b:	89 c2                	mov    %eax,%edx
  10326d:	8b 45 10             	mov    0x10(%ebp),%eax
  103270:	01 c2                	add    %eax,%edx
  103272:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103275:	01 d0                	add    %edx,%eax
  103277:	48                   	dec    %eax
  103278:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10327b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10327e:	ba 00 00 00 00       	mov    $0x0,%edx
  103283:	f7 75 f0             	divl   -0x10(%ebp)
  103286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103289:	29 d0                	sub    %edx,%eax
  10328b:	c1 e8 0c             	shr    $0xc,%eax
  10328e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  103291:	8b 45 0c             	mov    0xc(%ebp),%eax
  103294:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103297:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10329a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10329f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1032a2:	8b 45 14             	mov    0x14(%ebp),%eax
  1032a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1032b0:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
  1032b3:	eb 68                	jmp    10331d <boot_map_segment+0xfe>
    {
        pte_t *ptep = get_pte(pgdir, la, 1);
  1032b5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1032bc:	00 
  1032bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c7:	89 04 24             	mov    %eax,(%esp)
  1032ca:	e8 8a 01 00 00       	call   103459 <get_pte>
  1032cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1032d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1032d6:	75 24                	jne    1032fc <boot_map_segment+0xdd>
  1032d8:	c7 44 24 0c a2 6a 10 	movl   $0x106aa2,0xc(%esp)
  1032df:	00 
  1032e0:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  1032e7:	00 
  1032e8:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1032ef:	00 
  1032f0:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  1032f7:	e8 49 d1 ff ff       	call   100445 <__panic>
        *ptep = pa | PTE_P | perm;
  1032fc:	8b 45 14             	mov    0x14(%ebp),%eax
  1032ff:	0b 45 18             	or     0x18(%ebp),%eax
  103302:	83 c8 01             	or     $0x1,%eax
  103305:	89 c2                	mov    %eax,%edx
  103307:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10330a:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE)
  10330c:	ff 4d f4             	decl   -0xc(%ebp)
  10330f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103316:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10331d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103321:	75 92                	jne    1032b5 <boot_map_segment+0x96>
    }
}
  103323:	90                   	nop
  103324:	90                   	nop
  103325:	c9                   	leave  
  103326:	c3                   	ret    

00103327 <boot_alloc_page>:
// boot_alloc_page - allocate one page using pmm->alloc_pages(1)
//  return value: the kernel virtual address of this allocated page
// note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void)
{
  103327:	f3 0f 1e fb          	endbr32 
  10332b:	55                   	push   %ebp
  10332c:	89 e5                	mov    %esp,%ebp
  10332e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  103331:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103338:	e8 74 fa ff ff       	call   102db1 <alloc_pages>
  10333d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL)
  103340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103344:	75 1c                	jne    103362 <boot_alloc_page+0x3b>
    {
        panic("boot_alloc_page failed.\n");
  103346:	c7 44 24 08 af 6a 10 	movl   $0x106aaf,0x8(%esp)
  10334d:	00 
  10334e:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  103355:	00 
  103356:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  10335d:	e8 e3 d0 ff ff       	call   100445 <__panic>
    }
    return page2kva(p);
  103362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103365:	89 04 24             	mov    %eax,(%esp)
  103368:	e8 84 f7 ff ff       	call   102af1 <page2kva>
}
  10336d:	c9                   	leave  
  10336e:	c3                   	ret    

0010336f <pmm_init>:

// pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism
//          - check the correctness of pmm & paging mechanism, print PDT&PT
void pmm_init(void)
{
  10336f:	f3 0f 1e fb          	endbr32 
  103373:	55                   	push   %ebp
  103374:	89 e5                	mov    %esp,%ebp
  103376:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  103379:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10337e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103381:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103388:	77 23                	ja     1033ad <pmm_init+0x3e>
  10338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10338d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103391:	c7 44 24 08 44 6a 10 	movl   $0x106a44,0x8(%esp)
  103398:	00 
  103399:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  1033a0:	00 
  1033a1:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  1033a8:	e8 98 d0 ff ff       	call   100445 <__panic>
  1033ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033b0:	05 00 00 00 40       	add    $0x40000000,%eax
  1033b5:	a3 14 cf 11 00       	mov    %eax,0x11cf14
    // We need to alloc/free the physical memory (granularity is 4KB or other size).
    // So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    // First we should init a physical memory manager(pmm) based on the framework.
    // Then pmm can alloc/free the physical memory.
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1033ba:	e8 96 f9 ff ff       	call   102d55 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1033bf:	e8 8f fa ff ff       	call   102e53 <page_init>

    // use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1033c4:	e8 fd 03 00 00       	call   1037c6 <check_alloc_page>

    check_pgdir();
  1033c9:	e8 1b 04 00 00       	call   1037e9 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1033ce:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1033d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033d6:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1033dd:	77 23                	ja     103402 <pmm_init+0x93>
  1033df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1033e6:	c7 44 24 08 44 6a 10 	movl   $0x106a44,0x8(%esp)
  1033ed:	00 
  1033ee:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
  1033f5:	00 
  1033f6:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  1033fd:	e8 43 d0 ff ff       	call   100445 <__panic>
  103402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103405:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  10340b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103410:	05 ac 0f 00 00       	add    $0xfac,%eax
  103415:	83 ca 03             	or     $0x3,%edx
  103418:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10341a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10341f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  103426:	00 
  103427:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10342e:	00 
  10342f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  103436:	38 
  103437:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10343e:	c0 
  10343f:	89 04 24             	mov    %eax,(%esp)
  103442:	e8 d8 fd ff ff       	call   10321f <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103447:	e8 1b f8 ff ff       	call   102c67 <gdt_init>

    // now the basic virtual memory map(see memalyout.h) is established.
    // check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10344c:	e8 38 0a 00 00       	call   103e89 <check_boot_pgdir>

    print_pgdir();
  103451:	e8 bd 0e 00 00       	call   104313 <print_pgdir>
}
  103456:	90                   	nop
  103457:	c9                   	leave  
  103458:	c3                   	ret    

00103459 <get_pte>:
//   la:     the linear address need to map
//   create: a logical value to decide if alloc a page for PT
//  return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
  103459:	f3 0f 1e fb          	endbr32 
  10345d:	55                   	push   %ebp
  10345e:	89 e5                	mov    %esp,%ebp
  103460:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

    pde_t *pdep = &pgdir[PDX(la)]; // (1) 首先找到页目录项，尝试获得页表
  103463:	8b 45 0c             	mov    0xc(%ebp),%eax
  103466:	c1 e8 16             	shr    $0x16,%eax
  103469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103470:	8b 45 08             	mov    0x8(%ebp),%eax
  103473:	01 d0                	add    %edx,%eax
  103475:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P))
  103478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10347b:	8b 00                	mov    (%eax),%eax
  10347d:	83 e0 01             	and    $0x1,%eax
  103480:	85 c0                	test   %eax,%eax
  103482:	0f 85 b9 00 00 00    	jne    103541 <get_pte+0xe8>
    { // (2) 检查这个页目录项是否存在，存在则直接返回找到的页表项，如果不存在
        if (!create)
  103488:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10348c:	75 0a                	jne    103498 <get_pte+0x3f>
        { // (3) 页目录项不存在且参数不要求创建新的页表，那么返回NULL
            return NULL;
  10348e:	b8 00 00 00 00       	mov    $0x0,%eax
  103493:	e9 06 01 00 00       	jmp    10359e <get_pte+0x145>
        }
        struct Page *page = alloc_page(); // (3) 否则分配一个物理页存储创建的页表
  103498:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10349f:	e8 0d f9 ff ff       	call   102db1 <alloc_pages>
  1034a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (page == NULL)
  1034a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1034ab:	75 0a                	jne    1034b7 <get_pte+0x5e>
        { // (3) 如果分配失败，那么返回NULL
            return NULL;
  1034ad:	b8 00 00 00 00       	mov    $0x0,%eax
  1034b2:	e9 e7 00 00 00       	jmp    10359e <get_pte+0x145>
        }
        set_page_ref(page, 1);              // (4) 设置物理页被引用一次
  1034b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1034be:	00 
  1034bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034c2:	89 04 24             	mov    %eax,(%esp)
  1034c5:	e8 db f6 ff ff       	call   102ba5 <set_page_ref>
        uintptr_t pa = page2pa(page);       // (5) 获得物理页的线性物理地址
  1034ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034cd:	89 04 24             	mov    %eax,(%esp)
  1034d0:	e8 b7 f5 ff ff       	call   102a8c <page2pa>
  1034d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);       // (6) 将物理地址转换成虚拟地址后，用memset函数清除页目录进行初始化
  1034d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1034de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034e1:	c1 e8 0c             	shr    $0xc,%eax
  1034e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034e7:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1034ec:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1034ef:	72 23                	jb     103514 <get_pte+0xbb>
  1034f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034f8:	c7 44 24 08 a0 69 10 	movl   $0x1069a0,0x8(%esp)
  1034ff:	00 
  103500:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
  103507:	00 
  103508:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  10350f:	e8 31 cf ff ff       	call   100445 <__panic>
  103514:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103517:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10351c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103523:	00 
  103524:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10352b:	00 
  10352c:	89 04 24             	mov    %eax,(%esp)
  10352f:	e8 b6 24 00 00       	call   1059ea <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P; // (7) 设置页目录项的权限
  103534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103537:	83 c8 07             	or     $0x7,%eax
  10353a:	89 c2                	mov    %eax,%edx
  10353c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10353f:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; // (8) 返回虚拟地址la对应的页表项入口地址
  103541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103544:	8b 00                	mov    (%eax),%eax
  103546:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10354b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10354e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103551:	c1 e8 0c             	shr    $0xc,%eax
  103554:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103557:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  10355c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10355f:	72 23                	jb     103584 <get_pte+0x12b>
  103561:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103564:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103568:	c7 44 24 08 a0 69 10 	movl   $0x1069a0,0x8(%esp)
  10356f:	00 
  103570:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
  103577:	00 
  103578:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  10357f:	e8 c1 ce ff ff       	call   100445 <__panic>
  103584:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103587:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10358c:	89 c2                	mov    %eax,%edx
  10358e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103591:	c1 e8 0c             	shr    $0xc,%eax
  103594:	25 ff 03 00 00       	and    $0x3ff,%eax
  103599:	c1 e0 02             	shl    $0x2,%eax
  10359c:	01 d0                	add    %edx,%eax
    //                           // (6) clear page content using memset
    //                           // (7) set page directory entry's permission
    //     }
    //     return NULL;          // (8) return page table entry
    // #endif
}
  10359e:	c9                   	leave  
  10359f:	c3                   	ret    

001035a0 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
  1035a0:	f3 0f 1e fb          	endbr32 
  1035a4:	55                   	push   %ebp
  1035a5:	89 e5                	mov    %esp,%ebp
  1035a7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1035aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1035b1:	00 
  1035b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1035bc:	89 04 24             	mov    %eax,(%esp)
  1035bf:	e8 95 fe ff ff       	call   103459 <get_pte>
  1035c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL)
  1035c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1035cb:	74 08                	je     1035d5 <get_page+0x35>
    {
        *ptep_store = ptep;
  1035cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1035d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035d3:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P)
  1035d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1035d9:	74 1b                	je     1035f6 <get_page+0x56>
  1035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035de:	8b 00                	mov    (%eax),%eax
  1035e0:	83 e0 01             	and    $0x1,%eax
  1035e3:	85 c0                	test   %eax,%eax
  1035e5:	74 0f                	je     1035f6 <get_page+0x56>
    {
        return pte2page(*ptep);
  1035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035ea:	8b 00                	mov    (%eax),%eax
  1035ec:	89 04 24             	mov    %eax,(%esp)
  1035ef:	e8 51 f5 ff ff       	call   102b45 <pte2page>
  1035f4:	eb 05                	jmp    1035fb <get_page+0x5b>
    }
    return NULL;
  1035f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035fb:	c9                   	leave  
  1035fc:	c3                   	ret    

001035fd <page_remove_pte>:
// page_remove_pte - free an Page sturct which is related linear address la
//                 - and clean(invalidate) pte which is related linear address la
// note: PT is changed, so the TLB need to be invalidate
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep)
{
  1035fd:	55                   	push   %ebp
  1035fe:	89 e5                	mov    %esp,%ebp
  103600:	83 ec 28             	sub    $0x28,%esp
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    // check if this page table entry is present
    // 如果传入的页表条目是可用的
    if (*ptep & PTE_P)
  103603:	8b 45 10             	mov    0x10(%ebp),%eax
  103606:	8b 00                	mov    (%eax),%eax
  103608:	83 e0 01             	and    $0x1,%eax
  10360b:	85 c0                	test   %eax,%eax
  10360d:	74 4d                	je     10365c <page_remove_pte+0x5f>
    {
        // find corresponding page to pte，获取该页表项所对应的地址
        struct Page *page = pte2page(*ptep);
  10360f:	8b 45 10             	mov    0x10(%ebp),%eax
  103612:	8b 00                	mov    (%eax),%eax
  103614:	89 04 24             	mov    %eax,(%esp)
  103617:	e8 29 f5 ff ff       	call   102b45 <pte2page>
  10361c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // decrease page reference，如果该页的引用次数在减1后为0
        if (page_ref_dec(page) == 0)
  10361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103622:	89 04 24             	mov    %eax,(%esp)
  103625:	e8 a0 f5 ff ff       	call   102bca <page_ref_dec>
  10362a:	85 c0                	test   %eax,%eax
  10362c:	75 13                	jne    103641 <page_remove_pte+0x44>
            // and free this page when page reference reachs 0，释放当前页
            free_page(page);
  10362e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103635:	00 
  103636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103639:	89 04 24             	mov    %eax,(%esp)
  10363c:	e8 ac f7 ff ff       	call   102ded <free_pages>
        // clear second page table entry，清空PTE
        *ptep = 0;
  103641:	8b 45 10             	mov    0x10(%ebp),%eax
  103644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        // flush tlb，刷新TLB内的数据
        tlb_invalidate(pgdir, la);
  10364a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10364d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103651:	8b 45 08             	mov    0x8(%ebp),%eax
  103654:	89 04 24             	mov    %eax,(%esp)
  103657:	e8 09 01 00 00       	call   103765 <tlb_invalidate>
    //                                   //(4) and free this page when page reference reachs 0
    //                                   //(5) clear second page table entry
    //                                   //(6) flush tlb
    //     }
    // #endif
}
  10365c:	90                   	nop
  10365d:	c9                   	leave  
  10365e:	c3                   	ret    

0010365f <page_remove>:

// page_remove - free an Page which is related linear address la and has an validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
  10365f:	f3 0f 1e fb          	endbr32 
  103663:	55                   	push   %ebp
  103664:	89 e5                	mov    %esp,%ebp
  103666:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103669:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103670:	00 
  103671:	8b 45 0c             	mov    0xc(%ebp),%eax
  103674:	89 44 24 04          	mov    %eax,0x4(%esp)
  103678:	8b 45 08             	mov    0x8(%ebp),%eax
  10367b:	89 04 24             	mov    %eax,(%esp)
  10367e:	e8 d6 fd ff ff       	call   103459 <get_pte>
  103683:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL)
  103686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10368a:	74 19                	je     1036a5 <page_remove+0x46>
    {
        page_remove_pte(pgdir, la, ptep);
  10368c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10368f:	89 44 24 08          	mov    %eax,0x8(%esp)
  103693:	8b 45 0c             	mov    0xc(%ebp),%eax
  103696:	89 44 24 04          	mov    %eax,0x4(%esp)
  10369a:	8b 45 08             	mov    0x8(%ebp),%eax
  10369d:	89 04 24             	mov    %eax,(%esp)
  1036a0:	e8 58 ff ff ff       	call   1035fd <page_remove_pte>
    }
}
  1036a5:	90                   	nop
  1036a6:	c9                   	leave  
  1036a7:	c3                   	ret    

001036a8 <page_insert>:
//   la:    the linear address need to map
//   perm:  the permission of this Page which is setted in related pte
//  return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm)
{
  1036a8:	f3 0f 1e fb          	endbr32 
  1036ac:	55                   	push   %ebp
  1036ad:	89 e5                	mov    %esp,%ebp
  1036af:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1036b2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1036b9:	00 
  1036ba:	8b 45 10             	mov    0x10(%ebp),%eax
  1036bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1036c4:	89 04 24             	mov    %eax,(%esp)
  1036c7:	e8 8d fd ff ff       	call   103459 <get_pte>
  1036cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL)
  1036cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1036d3:	75 0a                	jne    1036df <page_insert+0x37>
    {
        return -E_NO_MEM;
  1036d5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1036da:	e9 84 00 00 00       	jmp    103763 <page_insert+0xbb>
    }
    page_ref_inc(page);
  1036df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036e2:	89 04 24             	mov    %eax,(%esp)
  1036e5:	e8 c9 f4 ff ff       	call   102bb3 <page_ref_inc>
    if (*ptep & PTE_P)
  1036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036ed:	8b 00                	mov    (%eax),%eax
  1036ef:	83 e0 01             	and    $0x1,%eax
  1036f2:	85 c0                	test   %eax,%eax
  1036f4:	74 3e                	je     103734 <page_insert+0x8c>
    {
        struct Page *p = pte2page(*ptep);
  1036f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036f9:	8b 00                	mov    (%eax),%eax
  1036fb:	89 04 24             	mov    %eax,(%esp)
  1036fe:	e8 42 f4 ff ff       	call   102b45 <pte2page>
  103703:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page)
  103706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103709:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10370c:	75 0d                	jne    10371b <page_insert+0x73>
        {
            page_ref_dec(page);
  10370e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103711:	89 04 24             	mov    %eax,(%esp)
  103714:	e8 b1 f4 ff ff       	call   102bca <page_ref_dec>
  103719:	eb 19                	jmp    103734 <page_insert+0x8c>
        }
        else
        {
            page_remove_pte(pgdir, la, ptep);
  10371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10371e:	89 44 24 08          	mov    %eax,0x8(%esp)
  103722:	8b 45 10             	mov    0x10(%ebp),%eax
  103725:	89 44 24 04          	mov    %eax,0x4(%esp)
  103729:	8b 45 08             	mov    0x8(%ebp),%eax
  10372c:	89 04 24             	mov    %eax,(%esp)
  10372f:	e8 c9 fe ff ff       	call   1035fd <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103734:	8b 45 0c             	mov    0xc(%ebp),%eax
  103737:	89 04 24             	mov    %eax,(%esp)
  10373a:	e8 4d f3 ff ff       	call   102a8c <page2pa>
  10373f:	0b 45 14             	or     0x14(%ebp),%eax
  103742:	83 c8 01             	or     $0x1,%eax
  103745:	89 c2                	mov    %eax,%edx
  103747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10374a:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10374c:	8b 45 10             	mov    0x10(%ebp),%eax
  10374f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103753:	8b 45 08             	mov    0x8(%ebp),%eax
  103756:	89 04 24             	mov    %eax,(%esp)
  103759:	e8 07 00 00 00       	call   103765 <tlb_invalidate>
    return 0;
  10375e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103763:	c9                   	leave  
  103764:	c3                   	ret    

00103765 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
  103765:	f3 0f 1e fb          	endbr32 
  103769:	55                   	push   %ebp
  10376a:	89 e5                	mov    %esp,%ebp
  10376c:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10376f:	0f 20 d8             	mov    %cr3,%eax
  103772:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  103775:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir))
  103778:	8b 45 08             	mov    0x8(%ebp),%eax
  10377b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10377e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103785:	77 23                	ja     1037aa <tlb_invalidate+0x45>
  103787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10378a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10378e:	c7 44 24 08 44 6a 10 	movl   $0x106a44,0x8(%esp)
  103795:	00 
  103796:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  10379d:	00 
  10379e:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  1037a5:	e8 9b cc ff ff       	call   100445 <__panic>
  1037aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037ad:	05 00 00 00 40       	add    $0x40000000,%eax
  1037b2:	39 d0                	cmp    %edx,%eax
  1037b4:	75 0d                	jne    1037c3 <tlb_invalidate+0x5e>
    {
        invlpg((void *)la);
  1037b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1037bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037bf:	0f 01 38             	invlpg (%eax)
}
  1037c2:	90                   	nop
    }
}
  1037c3:	90                   	nop
  1037c4:	c9                   	leave  
  1037c5:	c3                   	ret    

001037c6 <check_alloc_page>:

static void
check_alloc_page(void)
{
  1037c6:	f3 0f 1e fb          	endbr32 
  1037ca:	55                   	push   %ebp
  1037cb:	89 e5                	mov    %esp,%ebp
  1037cd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1037d0:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  1037d5:	8b 40 18             	mov    0x18(%eax),%eax
  1037d8:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1037da:	c7 04 24 c8 6a 10 00 	movl   $0x106ac8,(%esp)
  1037e1:	e8 f3 ca ff ff       	call   1002d9 <cprintf>
}
  1037e6:	90                   	nop
  1037e7:	c9                   	leave  
  1037e8:	c3                   	ret    

001037e9 <check_pgdir>:

static void
check_pgdir(void)
{
  1037e9:	f3 0f 1e fb          	endbr32 
  1037ed:	55                   	push   %ebp
  1037ee:	89 e5                	mov    %esp,%ebp
  1037f0:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1037f3:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1037f8:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1037fd:	76 24                	jbe    103823 <check_pgdir+0x3a>
  1037ff:	c7 44 24 0c e7 6a 10 	movl   $0x106ae7,0xc(%esp)
  103806:	00 
  103807:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  10380e:	00 
  10380f:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  103816:	00 
  103817:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  10381e:	e8 22 cc ff ff       	call   100445 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103823:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103828:	85 c0                	test   %eax,%eax
  10382a:	74 0e                	je     10383a <check_pgdir+0x51>
  10382c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103831:	25 ff 0f 00 00       	and    $0xfff,%eax
  103836:	85 c0                	test   %eax,%eax
  103838:	74 24                	je     10385e <check_pgdir+0x75>
  10383a:	c7 44 24 0c 04 6b 10 	movl   $0x106b04,0xc(%esp)
  103841:	00 
  103842:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103849:	00 
  10384a:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  103851:	00 
  103852:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103859:	e8 e7 cb ff ff       	call   100445 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10385e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103863:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10386a:	00 
  10386b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103872:	00 
  103873:	89 04 24             	mov    %eax,(%esp)
  103876:	e8 25 fd ff ff       	call   1035a0 <get_page>
  10387b:	85 c0                	test   %eax,%eax
  10387d:	74 24                	je     1038a3 <check_pgdir+0xba>
  10387f:	c7 44 24 0c 3c 6b 10 	movl   $0x106b3c,0xc(%esp)
  103886:	00 
  103887:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  10388e:	00 
  10388f:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  103896:	00 
  103897:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  10389e:	e8 a2 cb ff ff       	call   100445 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1038a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038aa:	e8 02 f5 ff ff       	call   102db1 <alloc_pages>
  1038af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1038b2:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1038b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1038be:	00 
  1038bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1038c6:	00 
  1038c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1038ca:	89 54 24 04          	mov    %edx,0x4(%esp)
  1038ce:	89 04 24             	mov    %eax,(%esp)
  1038d1:	e8 d2 fd ff ff       	call   1036a8 <page_insert>
  1038d6:	85 c0                	test   %eax,%eax
  1038d8:	74 24                	je     1038fe <check_pgdir+0x115>
  1038da:	c7 44 24 0c 64 6b 10 	movl   $0x106b64,0xc(%esp)
  1038e1:	00 
  1038e2:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  1038e9:	00 
  1038ea:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  1038f1:	00 
  1038f2:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  1038f9:	e8 47 cb ff ff       	call   100445 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1038fe:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103903:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10390a:	00 
  10390b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103912:	00 
  103913:	89 04 24             	mov    %eax,(%esp)
  103916:	e8 3e fb ff ff       	call   103459 <get_pte>
  10391b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10391e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103922:	75 24                	jne    103948 <check_pgdir+0x15f>
  103924:	c7 44 24 0c 90 6b 10 	movl   $0x106b90,0xc(%esp)
  10392b:	00 
  10392c:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103933:	00 
  103934:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  10393b:	00 
  10393c:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103943:	e8 fd ca ff ff       	call   100445 <__panic>
    assert(pte2page(*ptep) == p1);
  103948:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10394b:	8b 00                	mov    (%eax),%eax
  10394d:	89 04 24             	mov    %eax,(%esp)
  103950:	e8 f0 f1 ff ff       	call   102b45 <pte2page>
  103955:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103958:	74 24                	je     10397e <check_pgdir+0x195>
  10395a:	c7 44 24 0c bd 6b 10 	movl   $0x106bbd,0xc(%esp)
  103961:	00 
  103962:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103969:	00 
  10396a:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  103971:	00 
  103972:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103979:	e8 c7 ca ff ff       	call   100445 <__panic>
    assert(page_ref(p1) == 1);
  10397e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103981:	89 04 24             	mov    %eax,(%esp)
  103984:	e8 12 f2 ff ff       	call   102b9b <page_ref>
  103989:	83 f8 01             	cmp    $0x1,%eax
  10398c:	74 24                	je     1039b2 <check_pgdir+0x1c9>
  10398e:	c7 44 24 0c d3 6b 10 	movl   $0x106bd3,0xc(%esp)
  103995:	00 
  103996:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  10399d:	00 
  10399e:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  1039a5:	00 
  1039a6:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  1039ad:	e8 93 ca ff ff       	call   100445 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1039b2:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1039b7:	8b 00                	mov    (%eax),%eax
  1039b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1039be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1039c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039c4:	c1 e8 0c             	shr    $0xc,%eax
  1039c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1039ca:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1039cf:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1039d2:	72 23                	jb     1039f7 <check_pgdir+0x20e>
  1039d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1039db:	c7 44 24 08 a0 69 10 	movl   $0x1069a0,0x8(%esp)
  1039e2:	00 
  1039e3:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  1039ea:	00 
  1039eb:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  1039f2:	e8 4e ca ff ff       	call   100445 <__panic>
  1039f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039fa:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1039ff:	83 c0 04             	add    $0x4,%eax
  103a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103a05:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103a0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a11:	00 
  103a12:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103a19:	00 
  103a1a:	89 04 24             	mov    %eax,(%esp)
  103a1d:	e8 37 fa ff ff       	call   103459 <get_pte>
  103a22:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a25:	74 24                	je     103a4b <check_pgdir+0x262>
  103a27:	c7 44 24 0c e8 6b 10 	movl   $0x106be8,0xc(%esp)
  103a2e:	00 
  103a2f:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103a36:	00 
  103a37:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  103a3e:	00 
  103a3f:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103a46:	e8 fa c9 ff ff       	call   100445 <__panic>

    p2 = alloc_page();
  103a4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103a52:	e8 5a f3 ff ff       	call   102db1 <alloc_pages>
  103a57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103a5a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103a5f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103a66:	00 
  103a67:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103a6e:	00 
  103a6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103a72:	89 54 24 04          	mov    %edx,0x4(%esp)
  103a76:	89 04 24             	mov    %eax,(%esp)
  103a79:	e8 2a fc ff ff       	call   1036a8 <page_insert>
  103a7e:	85 c0                	test   %eax,%eax
  103a80:	74 24                	je     103aa6 <check_pgdir+0x2bd>
  103a82:	c7 44 24 0c 10 6c 10 	movl   $0x106c10,0xc(%esp)
  103a89:	00 
  103a8a:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103a91:	00 
  103a92:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  103a99:	00 
  103a9a:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103aa1:	e8 9f c9 ff ff       	call   100445 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103aa6:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103aab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103ab2:	00 
  103ab3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103aba:	00 
  103abb:	89 04 24             	mov    %eax,(%esp)
  103abe:	e8 96 f9 ff ff       	call   103459 <get_pte>
  103ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ac6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103aca:	75 24                	jne    103af0 <check_pgdir+0x307>
  103acc:	c7 44 24 0c 48 6c 10 	movl   $0x106c48,0xc(%esp)
  103ad3:	00 
  103ad4:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103adb:	00 
  103adc:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
  103ae3:	00 
  103ae4:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103aeb:	e8 55 c9 ff ff       	call   100445 <__panic>
    assert(*ptep & PTE_U);
  103af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103af3:	8b 00                	mov    (%eax),%eax
  103af5:	83 e0 04             	and    $0x4,%eax
  103af8:	85 c0                	test   %eax,%eax
  103afa:	75 24                	jne    103b20 <check_pgdir+0x337>
  103afc:	c7 44 24 0c 78 6c 10 	movl   $0x106c78,0xc(%esp)
  103b03:	00 
  103b04:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103b0b:	00 
  103b0c:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
  103b13:	00 
  103b14:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103b1b:	e8 25 c9 ff ff       	call   100445 <__panic>
    assert(*ptep & PTE_W);
  103b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b23:	8b 00                	mov    (%eax),%eax
  103b25:	83 e0 02             	and    $0x2,%eax
  103b28:	85 c0                	test   %eax,%eax
  103b2a:	75 24                	jne    103b50 <check_pgdir+0x367>
  103b2c:	c7 44 24 0c 86 6c 10 	movl   $0x106c86,0xc(%esp)
  103b33:	00 
  103b34:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103b3b:	00 
  103b3c:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
  103b43:	00 
  103b44:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103b4b:	e8 f5 c8 ff ff       	call   100445 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103b50:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103b55:	8b 00                	mov    (%eax),%eax
  103b57:	83 e0 04             	and    $0x4,%eax
  103b5a:	85 c0                	test   %eax,%eax
  103b5c:	75 24                	jne    103b82 <check_pgdir+0x399>
  103b5e:	c7 44 24 0c 94 6c 10 	movl   $0x106c94,0xc(%esp)
  103b65:	00 
  103b66:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103b6d:	00 
  103b6e:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
  103b75:	00 
  103b76:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103b7d:	e8 c3 c8 ff ff       	call   100445 <__panic>
    assert(page_ref(p2) == 1);
  103b82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b85:	89 04 24             	mov    %eax,(%esp)
  103b88:	e8 0e f0 ff ff       	call   102b9b <page_ref>
  103b8d:	83 f8 01             	cmp    $0x1,%eax
  103b90:	74 24                	je     103bb6 <check_pgdir+0x3cd>
  103b92:	c7 44 24 0c aa 6c 10 	movl   $0x106caa,0xc(%esp)
  103b99:	00 
  103b9a:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103ba1:	00 
  103ba2:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
  103ba9:	00 
  103baa:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103bb1:	e8 8f c8 ff ff       	call   100445 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103bb6:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103bbb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103bc2:	00 
  103bc3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103bca:	00 
  103bcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103bce:	89 54 24 04          	mov    %edx,0x4(%esp)
  103bd2:	89 04 24             	mov    %eax,(%esp)
  103bd5:	e8 ce fa ff ff       	call   1036a8 <page_insert>
  103bda:	85 c0                	test   %eax,%eax
  103bdc:	74 24                	je     103c02 <check_pgdir+0x419>
  103bde:	c7 44 24 0c bc 6c 10 	movl   $0x106cbc,0xc(%esp)
  103be5:	00 
  103be6:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103bed:	00 
  103bee:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
  103bf5:	00 
  103bf6:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103bfd:	e8 43 c8 ff ff       	call   100445 <__panic>
    assert(page_ref(p1) == 2);
  103c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c05:	89 04 24             	mov    %eax,(%esp)
  103c08:	e8 8e ef ff ff       	call   102b9b <page_ref>
  103c0d:	83 f8 02             	cmp    $0x2,%eax
  103c10:	74 24                	je     103c36 <check_pgdir+0x44d>
  103c12:	c7 44 24 0c e8 6c 10 	movl   $0x106ce8,0xc(%esp)
  103c19:	00 
  103c1a:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103c21:	00 
  103c22:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
  103c29:	00 
  103c2a:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103c31:	e8 0f c8 ff ff       	call   100445 <__panic>
    assert(page_ref(p2) == 0);
  103c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c39:	89 04 24             	mov    %eax,(%esp)
  103c3c:	e8 5a ef ff ff       	call   102b9b <page_ref>
  103c41:	85 c0                	test   %eax,%eax
  103c43:	74 24                	je     103c69 <check_pgdir+0x480>
  103c45:	c7 44 24 0c fa 6c 10 	movl   $0x106cfa,0xc(%esp)
  103c4c:	00 
  103c4d:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103c54:	00 
  103c55:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
  103c5c:	00 
  103c5d:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103c64:	e8 dc c7 ff ff       	call   100445 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103c69:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103c6e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103c75:	00 
  103c76:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103c7d:	00 
  103c7e:	89 04 24             	mov    %eax,(%esp)
  103c81:	e8 d3 f7 ff ff       	call   103459 <get_pte>
  103c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c8d:	75 24                	jne    103cb3 <check_pgdir+0x4ca>
  103c8f:	c7 44 24 0c 48 6c 10 	movl   $0x106c48,0xc(%esp)
  103c96:	00 
  103c97:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103c9e:	00 
  103c9f:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
  103ca6:	00 
  103ca7:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103cae:	e8 92 c7 ff ff       	call   100445 <__panic>
    assert(pte2page(*ptep) == p1);
  103cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103cb6:	8b 00                	mov    (%eax),%eax
  103cb8:	89 04 24             	mov    %eax,(%esp)
  103cbb:	e8 85 ee ff ff       	call   102b45 <pte2page>
  103cc0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103cc3:	74 24                	je     103ce9 <check_pgdir+0x500>
  103cc5:	c7 44 24 0c bd 6b 10 	movl   $0x106bbd,0xc(%esp)
  103ccc:	00 
  103ccd:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103cd4:	00 
  103cd5:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
  103cdc:	00 
  103cdd:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103ce4:	e8 5c c7 ff ff       	call   100445 <__panic>
    assert((*ptep & PTE_U) == 0);
  103ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103cec:	8b 00                	mov    (%eax),%eax
  103cee:	83 e0 04             	and    $0x4,%eax
  103cf1:	85 c0                	test   %eax,%eax
  103cf3:	74 24                	je     103d19 <check_pgdir+0x530>
  103cf5:	c7 44 24 0c 0c 6d 10 	movl   $0x106d0c,0xc(%esp)
  103cfc:	00 
  103cfd:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103d04:	00 
  103d05:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
  103d0c:	00 
  103d0d:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103d14:	e8 2c c7 ff ff       	call   100445 <__panic>

    page_remove(boot_pgdir, 0x0);
  103d19:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d1e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103d25:	00 
  103d26:	89 04 24             	mov    %eax,(%esp)
  103d29:	e8 31 f9 ff ff       	call   10365f <page_remove>
    assert(page_ref(p1) == 1);
  103d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d31:	89 04 24             	mov    %eax,(%esp)
  103d34:	e8 62 ee ff ff       	call   102b9b <page_ref>
  103d39:	83 f8 01             	cmp    $0x1,%eax
  103d3c:	74 24                	je     103d62 <check_pgdir+0x579>
  103d3e:	c7 44 24 0c d3 6b 10 	movl   $0x106bd3,0xc(%esp)
  103d45:	00 
  103d46:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103d4d:	00 
  103d4e:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
  103d55:	00 
  103d56:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103d5d:	e8 e3 c6 ff ff       	call   100445 <__panic>
    assert(page_ref(p2) == 0);
  103d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d65:	89 04 24             	mov    %eax,(%esp)
  103d68:	e8 2e ee ff ff       	call   102b9b <page_ref>
  103d6d:	85 c0                	test   %eax,%eax
  103d6f:	74 24                	je     103d95 <check_pgdir+0x5ac>
  103d71:	c7 44 24 0c fa 6c 10 	movl   $0x106cfa,0xc(%esp)
  103d78:	00 
  103d79:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103d80:	00 
  103d81:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
  103d88:	00 
  103d89:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103d90:	e8 b0 c6 ff ff       	call   100445 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103d95:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d9a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103da1:	00 
  103da2:	89 04 24             	mov    %eax,(%esp)
  103da5:	e8 b5 f8 ff ff       	call   10365f <page_remove>
    assert(page_ref(p1) == 0);
  103daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dad:	89 04 24             	mov    %eax,(%esp)
  103db0:	e8 e6 ed ff ff       	call   102b9b <page_ref>
  103db5:	85 c0                	test   %eax,%eax
  103db7:	74 24                	je     103ddd <check_pgdir+0x5f4>
  103db9:	c7 44 24 0c 21 6d 10 	movl   $0x106d21,0xc(%esp)
  103dc0:	00 
  103dc1:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103dc8:	00 
  103dc9:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
  103dd0:	00 
  103dd1:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103dd8:	e8 68 c6 ff ff       	call   100445 <__panic>
    assert(page_ref(p2) == 0);
  103ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103de0:	89 04 24             	mov    %eax,(%esp)
  103de3:	e8 b3 ed ff ff       	call   102b9b <page_ref>
  103de8:	85 c0                	test   %eax,%eax
  103dea:	74 24                	je     103e10 <check_pgdir+0x627>
  103dec:	c7 44 24 0c fa 6c 10 	movl   $0x106cfa,0xc(%esp)
  103df3:	00 
  103df4:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103dfb:	00 
  103dfc:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
  103e03:	00 
  103e04:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103e0b:	e8 35 c6 ff ff       	call   100445 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103e10:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e15:	8b 00                	mov    (%eax),%eax
  103e17:	89 04 24             	mov    %eax,(%esp)
  103e1a:	e8 64 ed ff ff       	call   102b83 <pde2page>
  103e1f:	89 04 24             	mov    %eax,(%esp)
  103e22:	e8 74 ed ff ff       	call   102b9b <page_ref>
  103e27:	83 f8 01             	cmp    $0x1,%eax
  103e2a:	74 24                	je     103e50 <check_pgdir+0x667>
  103e2c:	c7 44 24 0c 34 6d 10 	movl   $0x106d34,0xc(%esp)
  103e33:	00 
  103e34:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103e3b:	00 
  103e3c:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
  103e43:	00 
  103e44:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103e4b:	e8 f5 c5 ff ff       	call   100445 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103e50:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e55:	8b 00                	mov    (%eax),%eax
  103e57:	89 04 24             	mov    %eax,(%esp)
  103e5a:	e8 24 ed ff ff       	call   102b83 <pde2page>
  103e5f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103e66:	00 
  103e67:	89 04 24             	mov    %eax,(%esp)
  103e6a:	e8 7e ef ff ff       	call   102ded <free_pages>
    boot_pgdir[0] = 0;
  103e6f:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103e7a:	c7 04 24 5b 6d 10 00 	movl   $0x106d5b,(%esp)
  103e81:	e8 53 c4 ff ff       	call   1002d9 <cprintf>
}
  103e86:	90                   	nop
  103e87:	c9                   	leave  
  103e88:	c3                   	ret    

00103e89 <check_boot_pgdir>:

static void
check_boot_pgdir(void)
{
  103e89:	f3 0f 1e fb          	endbr32 
  103e8d:	55                   	push   %ebp
  103e8e:	89 e5                	mov    %esp,%ebp
  103e90:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE)
  103e93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103e9a:	e9 ca 00 00 00       	jmp    103f69 <check_boot_pgdir+0xe0>
    {
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ea2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ea5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ea8:	c1 e8 0c             	shr    $0xc,%eax
  103eab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103eae:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103eb3:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103eb6:	72 23                	jb     103edb <check_boot_pgdir+0x52>
  103eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ebb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ebf:	c7 44 24 08 a0 69 10 	movl   $0x1069a0,0x8(%esp)
  103ec6:	00 
  103ec7:	c7 44 24 04 64 02 00 	movl   $0x264,0x4(%esp)
  103ece:	00 
  103ecf:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103ed6:	e8 6a c5 ff ff       	call   100445 <__panic>
  103edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ede:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103ee3:	89 c2                	mov    %eax,%edx
  103ee5:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103eea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103ef1:	00 
  103ef2:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ef6:	89 04 24             	mov    %eax,(%esp)
  103ef9:	e8 5b f5 ff ff       	call   103459 <get_pte>
  103efe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103f01:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103f05:	75 24                	jne    103f2b <check_boot_pgdir+0xa2>
  103f07:	c7 44 24 0c 78 6d 10 	movl   $0x106d78,0xc(%esp)
  103f0e:	00 
  103f0f:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103f16:	00 
  103f17:	c7 44 24 04 64 02 00 	movl   $0x264,0x4(%esp)
  103f1e:	00 
  103f1f:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103f26:	e8 1a c5 ff ff       	call   100445 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103f2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103f2e:	8b 00                	mov    (%eax),%eax
  103f30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103f35:	89 c2                	mov    %eax,%edx
  103f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f3a:	39 c2                	cmp    %eax,%edx
  103f3c:	74 24                	je     103f62 <check_boot_pgdir+0xd9>
  103f3e:	c7 44 24 0c b5 6d 10 	movl   $0x106db5,0xc(%esp)
  103f45:	00 
  103f46:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103f4d:	00 
  103f4e:	c7 44 24 04 65 02 00 	movl   $0x265,0x4(%esp)
  103f55:	00 
  103f56:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103f5d:	e8 e3 c4 ff ff       	call   100445 <__panic>
    for (i = 0; i < npage; i += PGSIZE)
  103f62:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103f6c:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103f71:	39 c2                	cmp    %eax,%edx
  103f73:	0f 82 26 ff ff ff    	jb     103e9f <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103f79:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103f7e:	05 ac 0f 00 00       	add    $0xfac,%eax
  103f83:	8b 00                	mov    (%eax),%eax
  103f85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103f8a:	89 c2                	mov    %eax,%edx
  103f8c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103f94:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103f9b:	77 23                	ja     103fc0 <check_boot_pgdir+0x137>
  103f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103fa0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103fa4:	c7 44 24 08 44 6a 10 	movl   $0x106a44,0x8(%esp)
  103fab:	00 
  103fac:	c7 44 24 04 68 02 00 	movl   $0x268,0x4(%esp)
  103fb3:	00 
  103fb4:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103fbb:	e8 85 c4 ff ff       	call   100445 <__panic>
  103fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103fc3:	05 00 00 00 40       	add    $0x40000000,%eax
  103fc8:	39 d0                	cmp    %edx,%eax
  103fca:	74 24                	je     103ff0 <check_boot_pgdir+0x167>
  103fcc:	c7 44 24 0c cc 6d 10 	movl   $0x106dcc,0xc(%esp)
  103fd3:	00 
  103fd4:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  103fdb:	00 
  103fdc:	c7 44 24 04 68 02 00 	movl   $0x268,0x4(%esp)
  103fe3:	00 
  103fe4:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  103feb:	e8 55 c4 ff ff       	call   100445 <__panic>

    assert(boot_pgdir[0] == 0);
  103ff0:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103ff5:	8b 00                	mov    (%eax),%eax
  103ff7:	85 c0                	test   %eax,%eax
  103ff9:	74 24                	je     10401f <check_boot_pgdir+0x196>
  103ffb:	c7 44 24 0c 00 6e 10 	movl   $0x106e00,0xc(%esp)
  104002:	00 
  104003:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  10400a:	00 
  10400b:	c7 44 24 04 6a 02 00 	movl   $0x26a,0x4(%esp)
  104012:	00 
  104013:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  10401a:	e8 26 c4 ff ff       	call   100445 <__panic>

    struct Page *p;
    p = alloc_page();
  10401f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104026:	e8 86 ed ff ff       	call   102db1 <alloc_pages>
  10402b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  10402e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104033:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10403a:	00 
  10403b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104042:	00 
  104043:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104046:	89 54 24 04          	mov    %edx,0x4(%esp)
  10404a:	89 04 24             	mov    %eax,(%esp)
  10404d:	e8 56 f6 ff ff       	call   1036a8 <page_insert>
  104052:	85 c0                	test   %eax,%eax
  104054:	74 24                	je     10407a <check_boot_pgdir+0x1f1>
  104056:	c7 44 24 0c 14 6e 10 	movl   $0x106e14,0xc(%esp)
  10405d:	00 
  10405e:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  104065:	00 
  104066:	c7 44 24 04 6e 02 00 	movl   $0x26e,0x4(%esp)
  10406d:	00 
  10406e:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  104075:	e8 cb c3 ff ff       	call   100445 <__panic>
    assert(page_ref(p) == 1);
  10407a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10407d:	89 04 24             	mov    %eax,(%esp)
  104080:	e8 16 eb ff ff       	call   102b9b <page_ref>
  104085:	83 f8 01             	cmp    $0x1,%eax
  104088:	74 24                	je     1040ae <check_boot_pgdir+0x225>
  10408a:	c7 44 24 0c 42 6e 10 	movl   $0x106e42,0xc(%esp)
  104091:	00 
  104092:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  104099:	00 
  10409a:	c7 44 24 04 6f 02 00 	movl   $0x26f,0x4(%esp)
  1040a1:	00 
  1040a2:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  1040a9:	e8 97 c3 ff ff       	call   100445 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1040ae:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1040b3:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1040ba:	00 
  1040bb:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1040c2:	00 
  1040c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1040c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1040ca:	89 04 24             	mov    %eax,(%esp)
  1040cd:	e8 d6 f5 ff ff       	call   1036a8 <page_insert>
  1040d2:	85 c0                	test   %eax,%eax
  1040d4:	74 24                	je     1040fa <check_boot_pgdir+0x271>
  1040d6:	c7 44 24 0c 54 6e 10 	movl   $0x106e54,0xc(%esp)
  1040dd:	00 
  1040de:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  1040e5:	00 
  1040e6:	c7 44 24 04 70 02 00 	movl   $0x270,0x4(%esp)
  1040ed:	00 
  1040ee:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  1040f5:	e8 4b c3 ff ff       	call   100445 <__panic>
    assert(page_ref(p) == 2);
  1040fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1040fd:	89 04 24             	mov    %eax,(%esp)
  104100:	e8 96 ea ff ff       	call   102b9b <page_ref>
  104105:	83 f8 02             	cmp    $0x2,%eax
  104108:	74 24                	je     10412e <check_boot_pgdir+0x2a5>
  10410a:	c7 44 24 0c 8b 6e 10 	movl   $0x106e8b,0xc(%esp)
  104111:	00 
  104112:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  104119:	00 
  10411a:	c7 44 24 04 71 02 00 	movl   $0x271,0x4(%esp)
  104121:	00 
  104122:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  104129:	e8 17 c3 ff ff       	call   100445 <__panic>

    const char *str = "ucore: Hello world!!";
  10412e:	c7 45 e8 9c 6e 10 00 	movl   $0x106e9c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  104135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104138:	89 44 24 04          	mov    %eax,0x4(%esp)
  10413c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104143:	e8 be 15 00 00       	call   105706 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104148:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10414f:	00 
  104150:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104157:	e8 28 16 00 00       	call   105784 <strcmp>
  10415c:	85 c0                	test   %eax,%eax
  10415e:	74 24                	je     104184 <check_boot_pgdir+0x2fb>
  104160:	c7 44 24 0c b4 6e 10 	movl   $0x106eb4,0xc(%esp)
  104167:	00 
  104168:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  10416f:	00 
  104170:	c7 44 24 04 75 02 00 	movl   $0x275,0x4(%esp)
  104177:	00 
  104178:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  10417f:	e8 c1 c2 ff ff       	call   100445 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104187:	89 04 24             	mov    %eax,(%esp)
  10418a:	e8 62 e9 ff ff       	call   102af1 <page2kva>
  10418f:	05 00 01 00 00       	add    $0x100,%eax
  104194:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104197:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10419e:	e8 05 15 00 00       	call   1056a8 <strlen>
  1041a3:	85 c0                	test   %eax,%eax
  1041a5:	74 24                	je     1041cb <check_boot_pgdir+0x342>
  1041a7:	c7 44 24 0c ec 6e 10 	movl   $0x106eec,0xc(%esp)
  1041ae:	00 
  1041af:	c7 44 24 08 8d 6a 10 	movl   $0x106a8d,0x8(%esp)
  1041b6:	00 
  1041b7:	c7 44 24 04 78 02 00 	movl   $0x278,0x4(%esp)
  1041be:	00 
  1041bf:	c7 04 24 68 6a 10 00 	movl   $0x106a68,(%esp)
  1041c6:	e8 7a c2 ff ff       	call   100445 <__panic>

    free_page(p);
  1041cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1041d2:	00 
  1041d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041d6:	89 04 24             	mov    %eax,(%esp)
  1041d9:	e8 0f ec ff ff       	call   102ded <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  1041de:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1041e3:	8b 00                	mov    (%eax),%eax
  1041e5:	89 04 24             	mov    %eax,(%esp)
  1041e8:	e8 96 e9 ff ff       	call   102b83 <pde2page>
  1041ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1041f4:	00 
  1041f5:	89 04 24             	mov    %eax,(%esp)
  1041f8:	e8 f0 eb ff ff       	call   102ded <free_pages>
    boot_pgdir[0] = 0;
  1041fd:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104202:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104208:	c7 04 24 10 6f 10 00 	movl   $0x106f10,(%esp)
  10420f:	e8 c5 c0 ff ff       	call   1002d9 <cprintf>
}
  104214:	90                   	nop
  104215:	c9                   	leave  
  104216:	c3                   	ret    

00104217 <perm2str>:

// perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm)
{
  104217:	f3 0f 1e fb          	endbr32 
  10421b:	55                   	push   %ebp
  10421c:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10421e:	8b 45 08             	mov    0x8(%ebp),%eax
  104221:	83 e0 04             	and    $0x4,%eax
  104224:	85 c0                	test   %eax,%eax
  104226:	74 04                	je     10422c <perm2str+0x15>
  104228:	b0 75                	mov    $0x75,%al
  10422a:	eb 02                	jmp    10422e <perm2str+0x17>
  10422c:	b0 2d                	mov    $0x2d,%al
  10422e:	a2 08 cf 11 00       	mov    %al,0x11cf08
    str[1] = 'r';
  104233:	c6 05 09 cf 11 00 72 	movb   $0x72,0x11cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10423a:	8b 45 08             	mov    0x8(%ebp),%eax
  10423d:	83 e0 02             	and    $0x2,%eax
  104240:	85 c0                	test   %eax,%eax
  104242:	74 04                	je     104248 <perm2str+0x31>
  104244:	b0 77                	mov    $0x77,%al
  104246:	eb 02                	jmp    10424a <perm2str+0x33>
  104248:	b0 2d                	mov    $0x2d,%al
  10424a:	a2 0a cf 11 00       	mov    %al,0x11cf0a
    str[3] = '\0';
  10424f:	c6 05 0b cf 11 00 00 	movb   $0x0,0x11cf0b
    return str;
  104256:	b8 08 cf 11 00       	mov    $0x11cf08,%eax
}
  10425b:	5d                   	pop    %ebp
  10425c:	c3                   	ret    

0010425d <get_pgtable_items>:
//   left_store:  the pointer of the high side of table's next range
//   right_store: the pointer of the low side of table's next range
//  return value: 0 - not a invalid item range, perm - a valid item range with perm permission
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store)
{
  10425d:	f3 0f 1e fb          	endbr32 
  104261:	55                   	push   %ebp
  104262:	89 e5                	mov    %esp,%ebp
  104264:	83 ec 10             	sub    $0x10,%esp
    if (start >= right)
  104267:	8b 45 10             	mov    0x10(%ebp),%eax
  10426a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10426d:	72 0d                	jb     10427c <get_pgtable_items+0x1f>
    {
        return 0;
  10426f:	b8 00 00 00 00       	mov    $0x0,%eax
  104274:	e9 98 00 00 00       	jmp    104311 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P))
    {
        start++;
  104279:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P))
  10427c:	8b 45 10             	mov    0x10(%ebp),%eax
  10427f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104282:	73 18                	jae    10429c <get_pgtable_items+0x3f>
  104284:	8b 45 10             	mov    0x10(%ebp),%eax
  104287:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10428e:	8b 45 14             	mov    0x14(%ebp),%eax
  104291:	01 d0                	add    %edx,%eax
  104293:	8b 00                	mov    (%eax),%eax
  104295:	83 e0 01             	and    $0x1,%eax
  104298:	85 c0                	test   %eax,%eax
  10429a:	74 dd                	je     104279 <get_pgtable_items+0x1c>
    }
    if (start < right)
  10429c:	8b 45 10             	mov    0x10(%ebp),%eax
  10429f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1042a2:	73 68                	jae    10430c <get_pgtable_items+0xaf>
    {
        if (left_store != NULL)
  1042a4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1042a8:	74 08                	je     1042b2 <get_pgtable_items+0x55>
        {
            *left_store = start;
  1042aa:	8b 45 18             	mov    0x18(%ebp),%eax
  1042ad:	8b 55 10             	mov    0x10(%ebp),%edx
  1042b0:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start++] & PTE_USER);
  1042b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1042b5:	8d 50 01             	lea    0x1(%eax),%edx
  1042b8:	89 55 10             	mov    %edx,0x10(%ebp)
  1042bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1042c2:	8b 45 14             	mov    0x14(%ebp),%eax
  1042c5:	01 d0                	add    %edx,%eax
  1042c7:	8b 00                	mov    (%eax),%eax
  1042c9:	83 e0 07             	and    $0x7,%eax
  1042cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
  1042cf:	eb 03                	jmp    1042d4 <get_pgtable_items+0x77>
        {
            start++;
  1042d1:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm)
  1042d4:	8b 45 10             	mov    0x10(%ebp),%eax
  1042d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1042da:	73 1d                	jae    1042f9 <get_pgtable_items+0x9c>
  1042dc:	8b 45 10             	mov    0x10(%ebp),%eax
  1042df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1042e6:	8b 45 14             	mov    0x14(%ebp),%eax
  1042e9:	01 d0                	add    %edx,%eax
  1042eb:	8b 00                	mov    (%eax),%eax
  1042ed:	83 e0 07             	and    $0x7,%eax
  1042f0:	89 c2                	mov    %eax,%edx
  1042f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1042f5:	39 c2                	cmp    %eax,%edx
  1042f7:	74 d8                	je     1042d1 <get_pgtable_items+0x74>
        }
        if (right_store != NULL)
  1042f9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1042fd:	74 08                	je     104307 <get_pgtable_items+0xaa>
        {
            *right_store = start;
  1042ff:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104302:	8b 55 10             	mov    0x10(%ebp),%edx
  104305:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104307:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10430a:	eb 05                	jmp    104311 <get_pgtable_items+0xb4>
    }
    return 0;
  10430c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104311:	c9                   	leave  
  104312:	c3                   	ret    

00104313 <print_pgdir>:

// print_pgdir - print the PDT&PT
void print_pgdir(void)
{
  104313:	f3 0f 1e fb          	endbr32 
  104317:	55                   	push   %ebp
  104318:	89 e5                	mov    %esp,%ebp
  10431a:	57                   	push   %edi
  10431b:	56                   	push   %esi
  10431c:	53                   	push   %ebx
  10431d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104320:	c7 04 24 30 6f 10 00 	movl   $0x106f30,(%esp)
  104327:	e8 ad bf ff ff       	call   1002d9 <cprintf>
    size_t left, right = 0, perm;
  10432c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
  104333:	e9 fa 00 00 00       	jmp    104432 <print_pgdir+0x11f>
    {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10433b:	89 04 24             	mov    %eax,(%esp)
  10433e:	e8 d4 fe ff ff       	call   104217 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104343:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104346:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104349:	29 d1                	sub    %edx,%ecx
  10434b:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10434d:	89 d6                	mov    %edx,%esi
  10434f:	c1 e6 16             	shl    $0x16,%esi
  104352:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104355:	89 d3                	mov    %edx,%ebx
  104357:	c1 e3 16             	shl    $0x16,%ebx
  10435a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10435d:	89 d1                	mov    %edx,%ecx
  10435f:	c1 e1 16             	shl    $0x16,%ecx
  104362:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104365:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104368:	29 d7                	sub    %edx,%edi
  10436a:	89 fa                	mov    %edi,%edx
  10436c:	89 44 24 14          	mov    %eax,0x14(%esp)
  104370:	89 74 24 10          	mov    %esi,0x10(%esp)
  104374:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104378:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10437c:	89 54 24 04          	mov    %edx,0x4(%esp)
  104380:	c7 04 24 61 6f 10 00 	movl   $0x106f61,(%esp)
  104387:	e8 4d bf ff ff       	call   1002d9 <cprintf>
        size_t l, r = left * NPTEENTRY;
  10438c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10438f:	c1 e0 0a             	shl    $0xa,%eax
  104392:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
  104395:	eb 54                	jmp    1043eb <print_pgdir+0xd8>
        {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104397:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10439a:	89 04 24             	mov    %eax,(%esp)
  10439d:	e8 75 fe ff ff       	call   104217 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1043a2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1043a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1043a8:	29 d1                	sub    %edx,%ecx
  1043aa:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1043ac:	89 d6                	mov    %edx,%esi
  1043ae:	c1 e6 0c             	shl    $0xc,%esi
  1043b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1043b4:	89 d3                	mov    %edx,%ebx
  1043b6:	c1 e3 0c             	shl    $0xc,%ebx
  1043b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1043bc:	89 d1                	mov    %edx,%ecx
  1043be:	c1 e1 0c             	shl    $0xc,%ecx
  1043c1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1043c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1043c7:	29 d7                	sub    %edx,%edi
  1043c9:	89 fa                	mov    %edi,%edx
  1043cb:	89 44 24 14          	mov    %eax,0x14(%esp)
  1043cf:	89 74 24 10          	mov    %esi,0x10(%esp)
  1043d3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1043d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1043db:	89 54 24 04          	mov    %edx,0x4(%esp)
  1043df:	c7 04 24 80 6f 10 00 	movl   $0x106f80,(%esp)
  1043e6:	e8 ee be ff ff       	call   1002d9 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0)
  1043eb:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1043f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1043f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1043f6:	89 d3                	mov    %edx,%ebx
  1043f8:	c1 e3 0a             	shl    $0xa,%ebx
  1043fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1043fe:	89 d1                	mov    %edx,%ecx
  104400:	c1 e1 0a             	shl    $0xa,%ecx
  104403:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  104406:	89 54 24 14          	mov    %edx,0x14(%esp)
  10440a:	8d 55 d8             	lea    -0x28(%ebp),%edx
  10440d:	89 54 24 10          	mov    %edx,0x10(%esp)
  104411:	89 74 24 0c          	mov    %esi,0xc(%esp)
  104415:	89 44 24 08          	mov    %eax,0x8(%esp)
  104419:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10441d:	89 0c 24             	mov    %ecx,(%esp)
  104420:	e8 38 fe ff ff       	call   10425d <get_pgtable_items>
  104425:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104428:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10442c:	0f 85 65 ff ff ff    	jne    104397 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0)
  104432:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104437:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10443a:	8d 55 dc             	lea    -0x24(%ebp),%edx
  10443d:	89 54 24 14          	mov    %edx,0x14(%esp)
  104441:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104444:	89 54 24 10          	mov    %edx,0x10(%esp)
  104448:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10444c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104450:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  104457:	00 
  104458:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10445f:	e8 f9 fd ff ff       	call   10425d <get_pgtable_items>
  104464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104467:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10446b:	0f 85 c7 fe ff ff    	jne    104338 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  104471:	c7 04 24 a4 6f 10 00 	movl   $0x106fa4,(%esp)
  104478:	e8 5c be ff ff       	call   1002d9 <cprintf>
}
  10447d:	90                   	nop
  10447e:	83 c4 4c             	add    $0x4c,%esp
  104481:	5b                   	pop    %ebx
  104482:	5e                   	pop    %esi
  104483:	5f                   	pop    %edi
  104484:	5d                   	pop    %ebp
  104485:	c3                   	ret    

00104486 <page2ppn>:
page2ppn(struct Page *page) {
  104486:	55                   	push   %ebp
  104487:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104489:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  10448e:	8b 55 08             	mov    0x8(%ebp),%edx
  104491:	29 c2                	sub    %eax,%edx
  104493:	89 d0                	mov    %edx,%eax
  104495:	c1 f8 02             	sar    $0x2,%eax
  104498:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10449e:	5d                   	pop    %ebp
  10449f:	c3                   	ret    

001044a0 <page2pa>:
page2pa(struct Page *page) {
  1044a0:	55                   	push   %ebp
  1044a1:	89 e5                	mov    %esp,%ebp
  1044a3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1044a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1044a9:	89 04 24             	mov    %eax,(%esp)
  1044ac:	e8 d5 ff ff ff       	call   104486 <page2ppn>
  1044b1:	c1 e0 0c             	shl    $0xc,%eax
}
  1044b4:	c9                   	leave  
  1044b5:	c3                   	ret    

001044b6 <page_ref>:
page_ref(struct Page *page) {
  1044b6:	55                   	push   %ebp
  1044b7:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1044b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1044bc:	8b 00                	mov    (%eax),%eax
}
  1044be:	5d                   	pop    %ebp
  1044bf:	c3                   	ret    

001044c0 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1044c0:	55                   	push   %ebp
  1044c1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1044c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1044c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044c9:	89 10                	mov    %edx,(%eax)
}
  1044cb:	90                   	nop
  1044cc:	5d                   	pop    %ebp
  1044cd:	c3                   	ret    

001044ce <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void)
{
  1044ce:	f3 0f 1e fb          	endbr32 
  1044d2:	55                   	push   %ebp
  1044d3:	89 e5                	mov    %esp,%ebp
  1044d5:	83 ec 10             	sub    $0x10,%esp
  1044d8:	c7 45 fc 1c cf 11 00 	movl   $0x11cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1044df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1044e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1044e5:	89 50 04             	mov    %edx,0x4(%eax)
  1044e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1044eb:	8b 50 04             	mov    0x4(%eax),%edx
  1044ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1044f1:	89 10                	mov    %edx,(%eax)
}
  1044f3:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  1044f4:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  1044fb:	00 00 00 
}
  1044fe:	90                   	nop
  1044ff:	c9                   	leave  
  104500:	c3                   	ret    

00104501 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n)
{
  104501:	f3 0f 1e fb          	endbr32 
  104505:	55                   	push   %ebp
  104506:	89 e5                	mov    %esp,%ebp
  104508:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10450b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10450f:	75 24                	jne    104535 <default_init_memmap+0x34>
  104511:	c7 44 24 0c d8 6f 10 	movl   $0x106fd8,0xc(%esp)
  104518:	00 
  104519:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104520:	00 
  104521:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
  104528:	00 
  104529:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104530:	e8 10 bf ff ff       	call   100445 <__panic>
    struct Page *p = base;
  104535:	8b 45 08             	mov    0x8(%ebp),%eax
  104538:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  10453b:	eb 7d                	jmp    1045ba <default_init_memmap+0xb9>
    {
        assert(PageReserved(p));
  10453d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104540:	83 c0 04             	add    $0x4,%eax
  104543:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10454a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10454d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104550:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104553:	0f a3 10             	bt     %edx,(%eax)
  104556:	19 c0                	sbb    %eax,%eax
  104558:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10455b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10455f:	0f 95 c0             	setne  %al
  104562:	0f b6 c0             	movzbl %al,%eax
  104565:	85 c0                	test   %eax,%eax
  104567:	75 24                	jne    10458d <default_init_memmap+0x8c>
  104569:	c7 44 24 0c 09 70 10 	movl   $0x107009,0xc(%esp)
  104570:	00 
  104571:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104578:	00 
  104579:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
  104580:	00 
  104581:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104588:	e8 b8 be ff ff       	call   100445 <__panic>
        p->flags = p->property = 0;
  10458d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104590:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10459a:	8b 50 08             	mov    0x8(%eax),%edx
  10459d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a0:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1045a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1045aa:	00 
  1045ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ae:	89 04 24             	mov    %eax,(%esp)
  1045b1:	e8 0a ff ff ff       	call   1044c0 <set_page_ref>
    for (; p != base + n; p++)
  1045b6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1045ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  1045bd:	89 d0                	mov    %edx,%eax
  1045bf:	c1 e0 02             	shl    $0x2,%eax
  1045c2:	01 d0                	add    %edx,%eax
  1045c4:	c1 e0 02             	shl    $0x2,%eax
  1045c7:	89 c2                	mov    %eax,%edx
  1045c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1045cc:	01 d0                	add    %edx,%eax
  1045ce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1045d1:	0f 85 66 ff ff ff    	jne    10453d <default_init_memmap+0x3c>
    }
    base->property = n;
  1045d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1045da:	8b 55 0c             	mov    0xc(%ebp),%edx
  1045dd:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1045e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1045e3:	83 c0 04             	add    $0x4,%eax
  1045e6:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  1045ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1045f0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1045f3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1045f6:	0f ab 10             	bts    %edx,(%eax)
}
  1045f9:	90                   	nop
    nr_free += n;
  1045fa:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  104600:	8b 45 0c             	mov    0xc(%ebp),%eax
  104603:	01 d0                	add    %edx,%eax
  104605:	a3 24 cf 11 00       	mov    %eax,0x11cf24
    //注意这里新页面插入时应该插入进末尾
    // list_add(&free_list, &(base->page_link));  原版错误，插在了Free之后的第一个位置
    // 修改方法：
    list_add(free_list.prev, &(base->page_link));
  10460a:	8b 45 08             	mov    0x8(%ebp),%eax
  10460d:	8d 50 0c             	lea    0xc(%eax),%edx
  104610:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  104615:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104618:	89 55 e0             	mov    %edx,-0x20(%ebp)
  10461b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10461e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104621:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104624:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104627:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10462a:	8b 40 04             	mov    0x4(%eax),%eax
  10462d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104630:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104633:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104636:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104639:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10463c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10463f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104642:	89 10                	mov    %edx,(%eax)
  104644:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104647:	8b 10                	mov    (%eax),%edx
  104649:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10464c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10464f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104652:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104655:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104658:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10465b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10465e:	89 10                	mov    %edx,(%eax)
}
  104660:	90                   	nop
}
  104661:	90                   	nop
}
  104662:	90                   	nop
    // list_add_before(&free_list, &(base->page_link));
}
  104663:	90                   	nop
  104664:	c9                   	leave  
  104665:	c3                   	ret    

00104666 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n)
{
  104666:	f3 0f 1e fb          	endbr32 
  10466a:	55                   	push   %ebp
  10466b:	89 e5                	mov    %esp,%ebp
  10466d:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  104670:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104674:	75 24                	jne    10469a <default_alloc_pages+0x34>
  104676:	c7 44 24 0c d8 6f 10 	movl   $0x106fd8,0xc(%esp)
  10467d:	00 
  10467e:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104685:	00 
  104686:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  10468d:	00 
  10468e:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104695:	e8 ab bd ff ff       	call   100445 <__panic>
    if (n > nr_free)
  10469a:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  10469f:	39 45 08             	cmp    %eax,0x8(%ebp)
  1046a2:	76 0a                	jbe    1046ae <default_alloc_pages+0x48>
    {
        return NULL;
  1046a4:	b8 00 00 00 00       	mov    $0x0,%eax
  1046a9:	e9 43 01 00 00       	jmp    1047f1 <default_alloc_pages+0x18b>
    }
    struct Page *page = NULL;
  1046ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1046b5:	c7 45 f0 1c cf 11 00 	movl   $0x11cf1c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list)
  1046bc:	eb 1c                	jmp    1046da <default_alloc_pages+0x74>
    {
        struct Page *p = le2page(le, page_link);
  1046be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046c1:	83 e8 0c             	sub    $0xc,%eax
  1046c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n)
  1046c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046ca:	8b 40 08             	mov    0x8(%eax),%eax
  1046cd:	39 45 08             	cmp    %eax,0x8(%ebp)
  1046d0:	77 08                	ja     1046da <default_alloc_pages+0x74>
        {
            page = p;
  1046d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  1046d8:	eb 18                	jmp    1046f2 <default_alloc_pages+0x8c>
  1046da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  1046e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1046e3:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  1046e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1046e9:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  1046f0:	75 cc                	jne    1046be <default_alloc_pages+0x58>
        }
    }
    if (page != NULL)
  1046f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046f6:	0f 84 f2 00 00 00    	je     1047ee <default_alloc_pages+0x188>
    {
        // list_del(&(page->page_link));
        if (page->property > n)
  1046fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ff:	8b 40 08             	mov    0x8(%eax),%eax
  104702:	39 45 08             	cmp    %eax,0x8(%ebp)
  104705:	0f 83 8f 00 00 00    	jae    10479a <default_alloc_pages+0x134>
        {
            struct Page *p = page + n;
  10470b:	8b 55 08             	mov    0x8(%ebp),%edx
  10470e:	89 d0                	mov    %edx,%eax
  104710:	c1 e0 02             	shl    $0x2,%eax
  104713:	01 d0                	add    %edx,%eax
  104715:	c1 e0 02             	shl    $0x2,%eax
  104718:	89 c2                	mov    %eax,%edx
  10471a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10471d:	01 d0                	add    %edx,%eax
  10471f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  104722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104725:	8b 40 08             	mov    0x8(%eax),%eax
  104728:	2b 45 08             	sub    0x8(%ebp),%eax
  10472b:	89 c2                	mov    %eax,%edx
  10472d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104730:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  104733:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104736:	83 c0 04             	add    $0x4,%eax
  104739:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  104740:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104743:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104746:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104749:	0f ab 10             	bts    %edx,(%eax)
}
  10474c:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
  10474d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104750:	83 c0 0c             	add    $0xc,%eax
  104753:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104756:	83 c2 0c             	add    $0xc,%edx
  104759:	89 55 e0             	mov    %edx,-0x20(%ebp)
  10475c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
  10475f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104762:	8b 40 04             	mov    0x4(%eax),%eax
  104765:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104768:	89 55 d8             	mov    %edx,-0x28(%ebp)
  10476b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10476e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104771:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
  104774:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104777:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10477a:	89 10                	mov    %edx,(%eax)
  10477c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10477f:	8b 10                	mov    (%eax),%edx
  104781:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104784:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104787:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10478a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10478d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104790:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104793:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104796:	89 10                	mov    %edx,(%eax)
}
  104798:	90                   	nop
}
  104799:	90                   	nop
        }
        list_del(&(page->page_link));
  10479a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10479d:	83 c0 0c             	add    $0xc,%eax
  1047a0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  1047a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1047a6:	8b 40 04             	mov    0x4(%eax),%eax
  1047a9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1047ac:	8b 12                	mov    (%edx),%edx
  1047ae:	89 55 b8             	mov    %edx,-0x48(%ebp)
  1047b1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1047b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1047b7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1047ba:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1047bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1047c0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1047c3:	89 10                	mov    %edx,(%eax)
}
  1047c5:	90                   	nop
}
  1047c6:	90                   	nop
        nr_free -= n;
  1047c7:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  1047cc:	2b 45 08             	sub    0x8(%ebp),%eax
  1047cf:	a3 24 cf 11 00       	mov    %eax,0x11cf24
        ClearPageProperty(page);
  1047d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047d7:	83 c0 04             	add    $0x4,%eax
  1047da:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  1047e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1047e4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1047e7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1047ea:	0f b3 10             	btr    %edx,(%eax)
}
  1047ed:	90                   	nop
    }
    return page;
  1047ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1047f1:	c9                   	leave  
  1047f2:	c3                   	ret    

001047f3 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n)
{
  1047f3:	f3 0f 1e fb          	endbr32 
  1047f7:	55                   	push   %ebp
  1047f8:	89 e5                	mov    %esp,%ebp
  1047fa:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  104800:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104804:	75 24                	jne    10482a <default_free_pages+0x37>
  104806:	c7 44 24 0c d8 6f 10 	movl   $0x106fd8,0xc(%esp)
  10480d:	00 
  10480e:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104815:	00 
  104816:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  10481d:	00 
  10481e:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104825:	e8 1b bc ff ff       	call   100445 <__panic>
    struct Page *p = base;
  10482a:	8b 45 08             	mov    0x8(%ebp),%eax
  10482d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p++)
  104830:	e9 9d 00 00 00       	jmp    1048d2 <default_free_pages+0xdf>
    {
        assert(!PageReserved(p) && !PageProperty(p));
  104835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104838:	83 c0 04             	add    $0x4,%eax
  10483b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  104842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104848:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10484b:	0f a3 10             	bt     %edx,(%eax)
  10484e:	19 c0                	sbb    %eax,%eax
  104850:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  104853:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104857:	0f 95 c0             	setne  %al
  10485a:	0f b6 c0             	movzbl %al,%eax
  10485d:	85 c0                	test   %eax,%eax
  10485f:	75 2c                	jne    10488d <default_free_pages+0x9a>
  104861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104864:	83 c0 04             	add    $0x4,%eax
  104867:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  10486e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104871:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104874:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104877:	0f a3 10             	bt     %edx,(%eax)
  10487a:	19 c0                	sbb    %eax,%eax
  10487c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
  10487f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  104883:	0f 95 c0             	setne  %al
  104886:	0f b6 c0             	movzbl %al,%eax
  104889:	85 c0                	test   %eax,%eax
  10488b:	74 24                	je     1048b1 <default_free_pages+0xbe>
  10488d:	c7 44 24 0c 1c 70 10 	movl   $0x10701c,0xc(%esp)
  104894:	00 
  104895:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  10489c:	00 
  10489d:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  1048a4:	00 
  1048a5:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  1048ac:	e8 94 bb ff ff       	call   100445 <__panic>
        p->flags = 0;
  1048b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1048bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048c2:	00 
  1048c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048c6:	89 04 24             	mov    %eax,(%esp)
  1048c9:	e8 f2 fb ff ff       	call   1044c0 <set_page_ref>
    for (; p != base + n; p++)
  1048ce:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1048d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1048d5:	89 d0                	mov    %edx,%eax
  1048d7:	c1 e0 02             	shl    $0x2,%eax
  1048da:	01 d0                	add    %edx,%eax
  1048dc:	c1 e0 02             	shl    $0x2,%eax
  1048df:	89 c2                	mov    %eax,%edx
  1048e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1048e4:	01 d0                	add    %edx,%eax
  1048e6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1048e9:	0f 85 46 ff ff ff    	jne    104835 <default_free_pages+0x42>
    }
    base->property = n;
  1048ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1048f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1048f5:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1048f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1048fb:	83 c0 04             	add    $0x4,%eax
  1048fe:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  104905:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104908:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10490b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10490e:	0f ab 10             	bts    %edx,(%eax)
}
  104911:	90                   	nop
  104912:	c7 45 d0 1c cf 11 00 	movl   $0x11cf1c,-0x30(%ebp)
    return listelm->next;
  104919:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10491c:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  10491f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *pos = free_list.prev;
  104922:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  104927:	89 45 ec             	mov    %eax,-0x14(%ebp)
    while (le != &free_list)
  10492a:	e9 20 01 00 00       	jmp    104a4f <default_free_pages+0x25c>
    {
        p = le2page(le, page_link);
  10492f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104932:	83 e8 0c             	sub    $0xc,%eax
  104935:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // le = list_next(le);
        if (base + base->property == p)
  104938:	8b 45 08             	mov    0x8(%ebp),%eax
  10493b:	8b 50 08             	mov    0x8(%eax),%edx
  10493e:	89 d0                	mov    %edx,%eax
  104940:	c1 e0 02             	shl    $0x2,%eax
  104943:	01 d0                	add    %edx,%eax
  104945:	c1 e0 02             	shl    $0x2,%eax
  104948:	89 c2                	mov    %eax,%edx
  10494a:	8b 45 08             	mov    0x8(%ebp),%eax
  10494d:	01 d0                	add    %edx,%eax
  10494f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104952:	75 67                	jne    1049bb <default_free_pages+0x1c8>
        {
            base->property += p->property;
  104954:	8b 45 08             	mov    0x8(%ebp),%eax
  104957:	8b 50 08             	mov    0x8(%eax),%edx
  10495a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10495d:	8b 40 08             	mov    0x8(%eax),%eax
  104960:	01 c2                	add    %eax,%edx
  104962:	8b 45 08             	mov    0x8(%ebp),%eax
  104965:	89 50 08             	mov    %edx,0x8(%eax)
            pos = le->prev;
  104968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10496b:	8b 00                	mov    (%eax),%eax
  10496d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            ClearPageProperty(p);
  104970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104973:	83 c0 04             	add    $0x4,%eax
  104976:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  10497d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104980:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104983:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104986:	0f b3 10             	btr    %edx,(%eax)
}
  104989:	90                   	nop
            list_del(&(p->page_link));
  10498a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10498d:	83 c0 0c             	add    $0xc,%eax
  104990:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104993:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104996:	8b 40 04             	mov    0x4(%eax),%eax
  104999:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10499c:	8b 12                	mov    (%edx),%edx
  10499e:	89 55 c0             	mov    %edx,-0x40(%ebp)
  1049a1:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  1049a4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1049a7:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1049aa:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1049ad:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1049b0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1049b3:	89 10                	mov    %edx,(%eax)
}
  1049b5:	90                   	nop
}
  1049b6:	e9 85 00 00 00       	jmp    104a40 <default_free_pages+0x24d>
        }
        else if (p + p->property == base)
  1049bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049be:	8b 50 08             	mov    0x8(%eax),%edx
  1049c1:	89 d0                	mov    %edx,%eax
  1049c3:	c1 e0 02             	shl    $0x2,%eax
  1049c6:	01 d0                	add    %edx,%eax
  1049c8:	c1 e0 02             	shl    $0x2,%eax
  1049cb:	89 c2                	mov    %eax,%edx
  1049cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d0:	01 d0                	add    %edx,%eax
  1049d2:	39 45 08             	cmp    %eax,0x8(%ebp)
  1049d5:	75 69                	jne    104a40 <default_free_pages+0x24d>
        {
            p->property += base->property;
  1049d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049da:	8b 50 08             	mov    0x8(%eax),%edx
  1049dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1049e0:	8b 40 08             	mov    0x8(%eax),%eax
  1049e3:	01 c2                	add    %eax,%edx
  1049e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049e8:	89 50 08             	mov    %edx,0x8(%eax)
            pos = le->prev;
  1049eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049ee:	8b 00                	mov    (%eax),%eax
  1049f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
            ClearPageProperty(base);
  1049f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1049f6:	83 c0 04             	add    $0x4,%eax
  1049f9:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  104a00:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104a03:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104a06:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104a09:	0f b3 10             	btr    %edx,(%eax)
}
  104a0c:	90                   	nop
            base = p;
  104a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a10:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  104a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a16:	83 c0 0c             	add    $0xc,%eax
  104a19:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  104a1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104a1f:	8b 40 04             	mov    0x4(%eax),%eax
  104a22:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104a25:	8b 12                	mov    (%edx),%edx
  104a27:	89 55 ac             	mov    %edx,-0x54(%ebp)
  104a2a:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  104a2d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104a30:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104a33:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104a36:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104a39:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104a3c:	89 10                	mov    %edx,(%eax)
}
  104a3e:	90                   	nop
}
  104a3f:	90                   	nop
  104a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a43:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return listelm->next;
  104a46:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104a49:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
  104a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list)
  104a4f:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  104a56:	0f 85 d3 fe ff ff    	jne    10492f <default_free_pages+0x13c>
    }
    nr_free += n;
  104a5c:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  104a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  104a65:	01 d0                	add    %edx,%eax
  104a67:	a3 24 cf 11 00       	mov    %eax,0x11cf24
    // list_add_before(le, &(base->page_link));
    // list_add(le->prev, &(base->page_link));
    list_add(pos, &(base->page_link));
  104a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  104a6f:	8d 50 0c             	lea    0xc(%eax),%edx
  104a72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a75:	89 45 98             	mov    %eax,-0x68(%ebp)
  104a78:	89 55 94             	mov    %edx,-0x6c(%ebp)
  104a7b:	8b 45 98             	mov    -0x68(%ebp),%eax
  104a7e:	89 45 90             	mov    %eax,-0x70(%ebp)
  104a81:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104a84:	89 45 8c             	mov    %eax,-0x74(%ebp)
    __list_add(elm, listelm, listelm->next);
  104a87:	8b 45 90             	mov    -0x70(%ebp),%eax
  104a8a:	8b 40 04             	mov    0x4(%eax),%eax
  104a8d:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104a90:	89 55 88             	mov    %edx,-0x78(%ebp)
  104a93:	8b 55 90             	mov    -0x70(%ebp),%edx
  104a96:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104a99:	89 45 80             	mov    %eax,-0x80(%ebp)
    prev->next = next->prev = elm;
  104a9c:	8b 45 80             	mov    -0x80(%ebp),%eax
  104a9f:	8b 55 88             	mov    -0x78(%ebp),%edx
  104aa2:	89 10                	mov    %edx,(%eax)
  104aa4:	8b 45 80             	mov    -0x80(%ebp),%eax
  104aa7:	8b 10                	mov    (%eax),%edx
  104aa9:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104aac:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104aaf:	8b 45 88             	mov    -0x78(%ebp),%eax
  104ab2:	8b 55 80             	mov    -0x80(%ebp),%edx
  104ab5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104ab8:	8b 45 88             	mov    -0x78(%ebp),%eax
  104abb:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104abe:	89 10                	mov    %edx,(%eax)
}
  104ac0:	90                   	nop
}
  104ac1:	90                   	nop
}
  104ac2:	90                   	nop
}
  104ac3:	90                   	nop
  104ac4:	c9                   	leave  
  104ac5:	c3                   	ret    

00104ac6 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
  104ac6:	f3 0f 1e fb          	endbr32 
  104aca:	55                   	push   %ebp
  104acb:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104acd:	a1 24 cf 11 00       	mov    0x11cf24,%eax
}
  104ad2:	5d                   	pop    %ebp
  104ad3:	c3                   	ret    

00104ad4 <basic_check>:

static void
basic_check(void)
{
  104ad4:	f3 0f 1e fb          	endbr32 
  104ad8:	55                   	push   %ebp
  104ad9:	89 e5                	mov    %esp,%ebp
  104adb:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104ade:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104aee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104af1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104af8:	e8 b4 e2 ff ff       	call   102db1 <alloc_pages>
  104afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104b04:	75 24                	jne    104b2a <basic_check+0x56>
  104b06:	c7 44 24 0c 41 70 10 	movl   $0x107041,0xc(%esp)
  104b0d:	00 
  104b0e:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104b15:	00 
  104b16:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  104b1d:	00 
  104b1e:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104b25:	e8 1b b9 ff ff       	call   100445 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104b2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b31:	e8 7b e2 ff ff       	call   102db1 <alloc_pages>
  104b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b3d:	75 24                	jne    104b63 <basic_check+0x8f>
  104b3f:	c7 44 24 0c 5d 70 10 	movl   $0x10705d,0xc(%esp)
  104b46:	00 
  104b47:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104b4e:	00 
  104b4f:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104b56:	00 
  104b57:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104b5e:	e8 e2 b8 ff ff       	call   100445 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104b63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b6a:	e8 42 e2 ff ff       	call   102db1 <alloc_pages>
  104b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104b72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104b76:	75 24                	jne    104b9c <basic_check+0xc8>
  104b78:	c7 44 24 0c 79 70 10 	movl   $0x107079,0xc(%esp)
  104b7f:	00 
  104b80:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104b87:	00 
  104b88:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  104b8f:	00 
  104b90:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104b97:	e8 a9 b8 ff ff       	call   100445 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b9f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104ba2:	74 10                	je     104bb4 <basic_check+0xe0>
  104ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ba7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104baa:	74 08                	je     104bb4 <basic_check+0xe0>
  104bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104baf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104bb2:	75 24                	jne    104bd8 <basic_check+0x104>
  104bb4:	c7 44 24 0c 98 70 10 	movl   $0x107098,0xc(%esp)
  104bbb:	00 
  104bbc:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104bc3:	00 
  104bc4:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  104bcb:	00 
  104bcc:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104bd3:	e8 6d b8 ff ff       	call   100445 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bdb:	89 04 24             	mov    %eax,(%esp)
  104bde:	e8 d3 f8 ff ff       	call   1044b6 <page_ref>
  104be3:	85 c0                	test   %eax,%eax
  104be5:	75 1e                	jne    104c05 <basic_check+0x131>
  104be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bea:	89 04 24             	mov    %eax,(%esp)
  104bed:	e8 c4 f8 ff ff       	call   1044b6 <page_ref>
  104bf2:	85 c0                	test   %eax,%eax
  104bf4:	75 0f                	jne    104c05 <basic_check+0x131>
  104bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bf9:	89 04 24             	mov    %eax,(%esp)
  104bfc:	e8 b5 f8 ff ff       	call   1044b6 <page_ref>
  104c01:	85 c0                	test   %eax,%eax
  104c03:	74 24                	je     104c29 <basic_check+0x155>
  104c05:	c7 44 24 0c bc 70 10 	movl   $0x1070bc,0xc(%esp)
  104c0c:	00 
  104c0d:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104c14:	00 
  104c15:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  104c1c:	00 
  104c1d:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104c24:	e8 1c b8 ff ff       	call   100445 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c2c:	89 04 24             	mov    %eax,(%esp)
  104c2f:	e8 6c f8 ff ff       	call   1044a0 <page2pa>
  104c34:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104c3a:	c1 e2 0c             	shl    $0xc,%edx
  104c3d:	39 d0                	cmp    %edx,%eax
  104c3f:	72 24                	jb     104c65 <basic_check+0x191>
  104c41:	c7 44 24 0c f8 70 10 	movl   $0x1070f8,0xc(%esp)
  104c48:	00 
  104c49:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104c50:	00 
  104c51:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  104c58:	00 
  104c59:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104c60:	e8 e0 b7 ff ff       	call   100445 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c68:	89 04 24             	mov    %eax,(%esp)
  104c6b:	e8 30 f8 ff ff       	call   1044a0 <page2pa>
  104c70:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104c76:	c1 e2 0c             	shl    $0xc,%edx
  104c79:	39 d0                	cmp    %edx,%eax
  104c7b:	72 24                	jb     104ca1 <basic_check+0x1cd>
  104c7d:	c7 44 24 0c 15 71 10 	movl   $0x107115,0xc(%esp)
  104c84:	00 
  104c85:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104c8c:	00 
  104c8d:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  104c94:	00 
  104c95:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104c9c:	e8 a4 b7 ff ff       	call   100445 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ca4:	89 04 24             	mov    %eax,(%esp)
  104ca7:	e8 f4 f7 ff ff       	call   1044a0 <page2pa>
  104cac:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104cb2:	c1 e2 0c             	shl    $0xc,%edx
  104cb5:	39 d0                	cmp    %edx,%eax
  104cb7:	72 24                	jb     104cdd <basic_check+0x209>
  104cb9:	c7 44 24 0c 32 71 10 	movl   $0x107132,0xc(%esp)
  104cc0:	00 
  104cc1:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104cc8:	00 
  104cc9:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  104cd0:	00 
  104cd1:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104cd8:	e8 68 b7 ff ff       	call   100445 <__panic>

    list_entry_t free_list_store = free_list;
  104cdd:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  104ce2:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  104ce8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104ceb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104cee:	c7 45 dc 1c cf 11 00 	movl   $0x11cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104cf5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104cf8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104cfb:	89 50 04             	mov    %edx,0x4(%eax)
  104cfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d01:	8b 50 04             	mov    0x4(%eax),%edx
  104d04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d07:	89 10                	mov    %edx,(%eax)
}
  104d09:	90                   	nop
  104d0a:	c7 45 e0 1c cf 11 00 	movl   $0x11cf1c,-0x20(%ebp)
    return list->next == list;
  104d11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d14:	8b 40 04             	mov    0x4(%eax),%eax
  104d17:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104d1a:	0f 94 c0             	sete   %al
  104d1d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104d20:	85 c0                	test   %eax,%eax
  104d22:	75 24                	jne    104d48 <basic_check+0x274>
  104d24:	c7 44 24 0c 4f 71 10 	movl   $0x10714f,0xc(%esp)
  104d2b:	00 
  104d2c:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104d33:	00 
  104d34:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  104d3b:	00 
  104d3c:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104d43:	e8 fd b6 ff ff       	call   100445 <__panic>

    unsigned int nr_free_store = nr_free;
  104d48:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104d4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104d50:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  104d57:	00 00 00 

    assert(alloc_page() == NULL);
  104d5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d61:	e8 4b e0 ff ff       	call   102db1 <alloc_pages>
  104d66:	85 c0                	test   %eax,%eax
  104d68:	74 24                	je     104d8e <basic_check+0x2ba>
  104d6a:	c7 44 24 0c 66 71 10 	movl   $0x107166,0xc(%esp)
  104d71:	00 
  104d72:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104d79:	00 
  104d7a:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  104d81:	00 
  104d82:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104d89:	e8 b7 b6 ff ff       	call   100445 <__panic>

    free_page(p0);
  104d8e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d95:	00 
  104d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d99:	89 04 24             	mov    %eax,(%esp)
  104d9c:	e8 4c e0 ff ff       	call   102ded <free_pages>
    free_page(p1);
  104da1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104da8:	00 
  104da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dac:	89 04 24             	mov    %eax,(%esp)
  104daf:	e8 39 e0 ff ff       	call   102ded <free_pages>
    free_page(p2);
  104db4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104dbb:	00 
  104dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dbf:	89 04 24             	mov    %eax,(%esp)
  104dc2:	e8 26 e0 ff ff       	call   102ded <free_pages>
    assert(nr_free == 3);
  104dc7:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104dcc:	83 f8 03             	cmp    $0x3,%eax
  104dcf:	74 24                	je     104df5 <basic_check+0x321>
  104dd1:	c7 44 24 0c 7b 71 10 	movl   $0x10717b,0xc(%esp)
  104dd8:	00 
  104dd9:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104de0:	00 
  104de1:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  104de8:	00 
  104de9:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104df0:	e8 50 b6 ff ff       	call   100445 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104df5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104dfc:	e8 b0 df ff ff       	call   102db1 <alloc_pages>
  104e01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104e08:	75 24                	jne    104e2e <basic_check+0x35a>
  104e0a:	c7 44 24 0c 41 70 10 	movl   $0x107041,0xc(%esp)
  104e11:	00 
  104e12:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104e19:	00 
  104e1a:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  104e21:	00 
  104e22:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104e29:	e8 17 b6 ff ff       	call   100445 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104e2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e35:	e8 77 df ff ff       	call   102db1 <alloc_pages>
  104e3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104e41:	75 24                	jne    104e67 <basic_check+0x393>
  104e43:	c7 44 24 0c 5d 70 10 	movl   $0x10705d,0xc(%esp)
  104e4a:	00 
  104e4b:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104e52:	00 
  104e53:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  104e5a:	00 
  104e5b:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104e62:	e8 de b5 ff ff       	call   100445 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e6e:	e8 3e df ff ff       	call   102db1 <alloc_pages>
  104e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104e76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104e7a:	75 24                	jne    104ea0 <basic_check+0x3cc>
  104e7c:	c7 44 24 0c 79 70 10 	movl   $0x107079,0xc(%esp)
  104e83:	00 
  104e84:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104e8b:	00 
  104e8c:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  104e93:	00 
  104e94:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104e9b:	e8 a5 b5 ff ff       	call   100445 <__panic>

    assert(alloc_page() == NULL);
  104ea0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ea7:	e8 05 df ff ff       	call   102db1 <alloc_pages>
  104eac:	85 c0                	test   %eax,%eax
  104eae:	74 24                	je     104ed4 <basic_check+0x400>
  104eb0:	c7 44 24 0c 66 71 10 	movl   $0x107166,0xc(%esp)
  104eb7:	00 
  104eb8:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104ebf:	00 
  104ec0:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  104ec7:	00 
  104ec8:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104ecf:	e8 71 b5 ff ff       	call   100445 <__panic>

    free_page(p0);
  104ed4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104edb:	00 
  104edc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104edf:	89 04 24             	mov    %eax,(%esp)
  104ee2:	e8 06 df ff ff       	call   102ded <free_pages>
  104ee7:	c7 45 d8 1c cf 11 00 	movl   $0x11cf1c,-0x28(%ebp)
  104eee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104ef1:	8b 40 04             	mov    0x4(%eax),%eax
  104ef4:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104ef7:	0f 94 c0             	sete   %al
  104efa:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104efd:	85 c0                	test   %eax,%eax
  104eff:	74 24                	je     104f25 <basic_check+0x451>
  104f01:	c7 44 24 0c 88 71 10 	movl   $0x107188,0xc(%esp)
  104f08:	00 
  104f09:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104f10:	00 
  104f11:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  104f18:	00 
  104f19:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104f20:	e8 20 b5 ff ff       	call   100445 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104f25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f2c:	e8 80 de ff ff       	call   102db1 <alloc_pages>
  104f31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f37:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104f3a:	74 24                	je     104f60 <basic_check+0x48c>
  104f3c:	c7 44 24 0c a0 71 10 	movl   $0x1071a0,0xc(%esp)
  104f43:	00 
  104f44:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104f4b:	00 
  104f4c:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  104f53:	00 
  104f54:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104f5b:	e8 e5 b4 ff ff       	call   100445 <__panic>
    assert(alloc_page() == NULL);
  104f60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f67:	e8 45 de ff ff       	call   102db1 <alloc_pages>
  104f6c:	85 c0                	test   %eax,%eax
  104f6e:	74 24                	je     104f94 <basic_check+0x4c0>
  104f70:	c7 44 24 0c 66 71 10 	movl   $0x107166,0xc(%esp)
  104f77:	00 
  104f78:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104f7f:	00 
  104f80:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  104f87:	00 
  104f88:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104f8f:	e8 b1 b4 ff ff       	call   100445 <__panic>

    assert(nr_free == 0);
  104f94:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104f99:	85 c0                	test   %eax,%eax
  104f9b:	74 24                	je     104fc1 <basic_check+0x4ed>
  104f9d:	c7 44 24 0c b9 71 10 	movl   $0x1071b9,0xc(%esp)
  104fa4:	00 
  104fa5:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  104fac:	00 
  104fad:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  104fb4:	00 
  104fb5:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104fbc:	e8 84 b4 ff ff       	call   100445 <__panic>
    free_list = free_list_store;
  104fc1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104fc4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104fc7:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  104fcc:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    nr_free = nr_free_store;
  104fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fd5:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_page(p);
  104fda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fe1:	00 
  104fe2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fe5:	89 04 24             	mov    %eax,(%esp)
  104fe8:	e8 00 de ff ff       	call   102ded <free_pages>
    free_page(p1);
  104fed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ff4:	00 
  104ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ff8:	89 04 24             	mov    %eax,(%esp)
  104ffb:	e8 ed dd ff ff       	call   102ded <free_pages>
    free_page(p2);
  105000:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105007:	00 
  105008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10500b:	89 04 24             	mov    %eax,(%esp)
  10500e:	e8 da dd ff ff       	call   102ded <free_pages>
}
  105013:	90                   	nop
  105014:	c9                   	leave  
  105015:	c3                   	ret    

00105016 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
  105016:	f3 0f 1e fb          	endbr32 
  10501a:	55                   	push   %ebp
  10501b:	89 e5                	mov    %esp,%ebp
  10501d:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  105023:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10502a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  105031:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  105038:	eb 6a                	jmp    1050a4 <default_check+0x8e>
    {
        struct Page *p = le2page(le, page_link);
  10503a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10503d:	83 e8 0c             	sub    $0xc,%eax
  105040:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  105043:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105046:	83 c0 04             	add    $0x4,%eax
  105049:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105050:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105053:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105056:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105059:	0f a3 10             	bt     %edx,(%eax)
  10505c:	19 c0                	sbb    %eax,%eax
  10505e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  105061:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  105065:	0f 95 c0             	setne  %al
  105068:	0f b6 c0             	movzbl %al,%eax
  10506b:	85 c0                	test   %eax,%eax
  10506d:	75 24                	jne    105093 <default_check+0x7d>
  10506f:	c7 44 24 0c c6 71 10 	movl   $0x1071c6,0xc(%esp)
  105076:	00 
  105077:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  10507e:	00 
  10507f:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  105086:	00 
  105087:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  10508e:	e8 b2 b3 ff ff       	call   100445 <__panic>
        count++, total += p->property;
  105093:	ff 45 f4             	incl   -0xc(%ebp)
  105096:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105099:	8b 50 08             	mov    0x8(%eax),%edx
  10509c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10509f:	01 d0                	add    %edx,%eax
  1050a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1050a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  1050aa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1050ad:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  1050b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1050b3:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  1050ba:	0f 85 7a ff ff ff    	jne    10503a <default_check+0x24>
    }
    assert(total == nr_free_pages());
  1050c0:	e8 5f dd ff ff       	call   102e24 <nr_free_pages>
  1050c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1050c8:	39 d0                	cmp    %edx,%eax
  1050ca:	74 24                	je     1050f0 <default_check+0xda>
  1050cc:	c7 44 24 0c d6 71 10 	movl   $0x1071d6,0xc(%esp)
  1050d3:	00 
  1050d4:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  1050db:	00 
  1050dc:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1050e3:	00 
  1050e4:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  1050eb:	e8 55 b3 ff ff       	call   100445 <__panic>

    basic_check();
  1050f0:	e8 df f9 ff ff       	call   104ad4 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1050f5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1050fc:	e8 b0 dc ff ff       	call   102db1 <alloc_pages>
  105101:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  105104:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105108:	75 24                	jne    10512e <default_check+0x118>
  10510a:	c7 44 24 0c ef 71 10 	movl   $0x1071ef,0xc(%esp)
  105111:	00 
  105112:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105119:	00 
  10511a:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  105121:	00 
  105122:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105129:	e8 17 b3 ff ff       	call   100445 <__panic>
    assert(!PageProperty(p0));
  10512e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105131:	83 c0 04             	add    $0x4,%eax
  105134:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10513b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10513e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105141:	8b 55 c0             	mov    -0x40(%ebp),%edx
  105144:	0f a3 10             	bt     %edx,(%eax)
  105147:	19 c0                	sbb    %eax,%eax
  105149:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10514c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  105150:	0f 95 c0             	setne  %al
  105153:	0f b6 c0             	movzbl %al,%eax
  105156:	85 c0                	test   %eax,%eax
  105158:	74 24                	je     10517e <default_check+0x168>
  10515a:	c7 44 24 0c fa 71 10 	movl   $0x1071fa,0xc(%esp)
  105161:	00 
  105162:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105169:	00 
  10516a:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  105171:	00 
  105172:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105179:	e8 c7 b2 ff ff       	call   100445 <__panic>

    list_entry_t free_list_store = free_list;
  10517e:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  105183:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  105189:	89 45 80             	mov    %eax,-0x80(%ebp)
  10518c:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10518f:	c7 45 b0 1c cf 11 00 	movl   $0x11cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  105196:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105199:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10519c:	89 50 04             	mov    %edx,0x4(%eax)
  10519f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1051a2:	8b 50 04             	mov    0x4(%eax),%edx
  1051a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1051a8:	89 10                	mov    %edx,(%eax)
}
  1051aa:	90                   	nop
  1051ab:	c7 45 b4 1c cf 11 00 	movl   $0x11cf1c,-0x4c(%ebp)
    return list->next == list;
  1051b2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1051b5:	8b 40 04             	mov    0x4(%eax),%eax
  1051b8:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  1051bb:	0f 94 c0             	sete   %al
  1051be:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1051c1:	85 c0                	test   %eax,%eax
  1051c3:	75 24                	jne    1051e9 <default_check+0x1d3>
  1051c5:	c7 44 24 0c 4f 71 10 	movl   $0x10714f,0xc(%esp)
  1051cc:	00 
  1051cd:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  1051d4:	00 
  1051d5:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  1051dc:	00 
  1051dd:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  1051e4:	e8 5c b2 ff ff       	call   100445 <__panic>
    assert(alloc_page() == NULL);
  1051e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051f0:	e8 bc db ff ff       	call   102db1 <alloc_pages>
  1051f5:	85 c0                	test   %eax,%eax
  1051f7:	74 24                	je     10521d <default_check+0x207>
  1051f9:	c7 44 24 0c 66 71 10 	movl   $0x107166,0xc(%esp)
  105200:	00 
  105201:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105208:	00 
  105209:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  105210:	00 
  105211:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105218:	e8 28 b2 ff ff       	call   100445 <__panic>

    unsigned int nr_free_store = nr_free;
  10521d:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  105222:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  105225:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  10522c:	00 00 00 

    free_pages(p0 + 2, 3);
  10522f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105232:	83 c0 28             	add    $0x28,%eax
  105235:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10523c:	00 
  10523d:	89 04 24             	mov    %eax,(%esp)
  105240:	e8 a8 db ff ff       	call   102ded <free_pages>
    assert(alloc_pages(4) == NULL);
  105245:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10524c:	e8 60 db ff ff       	call   102db1 <alloc_pages>
  105251:	85 c0                	test   %eax,%eax
  105253:	74 24                	je     105279 <default_check+0x263>
  105255:	c7 44 24 0c 0c 72 10 	movl   $0x10720c,0xc(%esp)
  10525c:	00 
  10525d:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105264:	00 
  105265:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  10526c:	00 
  10526d:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105274:	e8 cc b1 ff ff       	call   100445 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  105279:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10527c:	83 c0 28             	add    $0x28,%eax
  10527f:	83 c0 04             	add    $0x4,%eax
  105282:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  105289:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10528c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10528f:	8b 55 ac             	mov    -0x54(%ebp),%edx
  105292:	0f a3 10             	bt     %edx,(%eax)
  105295:	19 c0                	sbb    %eax,%eax
  105297:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  10529a:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10529e:	0f 95 c0             	setne  %al
  1052a1:	0f b6 c0             	movzbl %al,%eax
  1052a4:	85 c0                	test   %eax,%eax
  1052a6:	74 0e                	je     1052b6 <default_check+0x2a0>
  1052a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052ab:	83 c0 28             	add    $0x28,%eax
  1052ae:	8b 40 08             	mov    0x8(%eax),%eax
  1052b1:	83 f8 03             	cmp    $0x3,%eax
  1052b4:	74 24                	je     1052da <default_check+0x2c4>
  1052b6:	c7 44 24 0c 24 72 10 	movl   $0x107224,0xc(%esp)
  1052bd:	00 
  1052be:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  1052c5:	00 
  1052c6:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  1052cd:	00 
  1052ce:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  1052d5:	e8 6b b1 ff ff       	call   100445 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1052da:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1052e1:	e8 cb da ff ff       	call   102db1 <alloc_pages>
  1052e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1052e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1052ed:	75 24                	jne    105313 <default_check+0x2fd>
  1052ef:	c7 44 24 0c 50 72 10 	movl   $0x107250,0xc(%esp)
  1052f6:	00 
  1052f7:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  1052fe:	00 
  1052ff:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  105306:	00 
  105307:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  10530e:	e8 32 b1 ff ff       	call   100445 <__panic>
    assert(alloc_page() == NULL);
  105313:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10531a:	e8 92 da ff ff       	call   102db1 <alloc_pages>
  10531f:	85 c0                	test   %eax,%eax
  105321:	74 24                	je     105347 <default_check+0x331>
  105323:	c7 44 24 0c 66 71 10 	movl   $0x107166,0xc(%esp)
  10532a:	00 
  10532b:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105332:	00 
  105333:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  10533a:	00 
  10533b:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105342:	e8 fe b0 ff ff       	call   100445 <__panic>
    assert(p0 + 2 == p1);
  105347:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10534a:	83 c0 28             	add    $0x28,%eax
  10534d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105350:	74 24                	je     105376 <default_check+0x360>
  105352:	c7 44 24 0c 6e 72 10 	movl   $0x10726e,0xc(%esp)
  105359:	00 
  10535a:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105361:	00 
  105362:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  105369:	00 
  10536a:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105371:	e8 cf b0 ff ff       	call   100445 <__panic>

    p2 = p0 + 1;
  105376:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105379:	83 c0 14             	add    $0x14,%eax
  10537c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  10537f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105386:	00 
  105387:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10538a:	89 04 24             	mov    %eax,(%esp)
  10538d:	e8 5b da ff ff       	call   102ded <free_pages>
    free_pages(p1, 3);
  105392:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105399:	00 
  10539a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10539d:	89 04 24             	mov    %eax,(%esp)
  1053a0:	e8 48 da ff ff       	call   102ded <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1053a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053a8:	83 c0 04             	add    $0x4,%eax
  1053ab:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1053b2:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1053b5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1053b8:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1053bb:	0f a3 10             	bt     %edx,(%eax)
  1053be:	19 c0                	sbb    %eax,%eax
  1053c0:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1053c3:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1053c7:	0f 95 c0             	setne  %al
  1053ca:	0f b6 c0             	movzbl %al,%eax
  1053cd:	85 c0                	test   %eax,%eax
  1053cf:	74 0b                	je     1053dc <default_check+0x3c6>
  1053d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053d4:	8b 40 08             	mov    0x8(%eax),%eax
  1053d7:	83 f8 01             	cmp    $0x1,%eax
  1053da:	74 24                	je     105400 <default_check+0x3ea>
  1053dc:	c7 44 24 0c 7c 72 10 	movl   $0x10727c,0xc(%esp)
  1053e3:	00 
  1053e4:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  1053eb:	00 
  1053ec:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1053f3:	00 
  1053f4:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  1053fb:	e8 45 b0 ff ff       	call   100445 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  105400:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105403:	83 c0 04             	add    $0x4,%eax
  105406:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10540d:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105410:	8b 45 90             	mov    -0x70(%ebp),%eax
  105413:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105416:	0f a3 10             	bt     %edx,(%eax)
  105419:	19 c0                	sbb    %eax,%eax
  10541b:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10541e:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105422:	0f 95 c0             	setne  %al
  105425:	0f b6 c0             	movzbl %al,%eax
  105428:	85 c0                	test   %eax,%eax
  10542a:	74 0b                	je     105437 <default_check+0x421>
  10542c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10542f:	8b 40 08             	mov    0x8(%eax),%eax
  105432:	83 f8 03             	cmp    $0x3,%eax
  105435:	74 24                	je     10545b <default_check+0x445>
  105437:	c7 44 24 0c a4 72 10 	movl   $0x1072a4,0xc(%esp)
  10543e:	00 
  10543f:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105446:	00 
  105447:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  10544e:	00 
  10544f:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105456:	e8 ea af ff ff       	call   100445 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10545b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105462:	e8 4a d9 ff ff       	call   102db1 <alloc_pages>
  105467:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10546a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10546d:	83 e8 14             	sub    $0x14,%eax
  105470:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105473:	74 24                	je     105499 <default_check+0x483>
  105475:	c7 44 24 0c ca 72 10 	movl   $0x1072ca,0xc(%esp)
  10547c:	00 
  10547d:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105484:	00 
  105485:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  10548c:	00 
  10548d:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105494:	e8 ac af ff ff       	call   100445 <__panic>
    free_page(p0);
  105499:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1054a0:	00 
  1054a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054a4:	89 04 24             	mov    %eax,(%esp)
  1054a7:	e8 41 d9 ff ff       	call   102ded <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1054ac:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1054b3:	e8 f9 d8 ff ff       	call   102db1 <alloc_pages>
  1054b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054be:	83 c0 14             	add    $0x14,%eax
  1054c1:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1054c4:	74 24                	je     1054ea <default_check+0x4d4>
  1054c6:	c7 44 24 0c e8 72 10 	movl   $0x1072e8,0xc(%esp)
  1054cd:	00 
  1054ce:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  1054d5:	00 
  1054d6:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  1054dd:	00 
  1054de:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  1054e5:	e8 5b af ff ff       	call   100445 <__panic>

    free_pages(p0, 2);
  1054ea:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1054f1:	00 
  1054f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054f5:	89 04 24             	mov    %eax,(%esp)
  1054f8:	e8 f0 d8 ff ff       	call   102ded <free_pages>
    free_page(p2);
  1054fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105504:	00 
  105505:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105508:	89 04 24             	mov    %eax,(%esp)
  10550b:	e8 dd d8 ff ff       	call   102ded <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  105510:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105517:	e8 95 d8 ff ff       	call   102db1 <alloc_pages>
  10551c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10551f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105523:	75 24                	jne    105549 <default_check+0x533>
  105525:	c7 44 24 0c 08 73 10 	movl   $0x107308,0xc(%esp)
  10552c:	00 
  10552d:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105534:	00 
  105535:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
  10553c:	00 
  10553d:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105544:	e8 fc ae ff ff       	call   100445 <__panic>
    assert(alloc_page() == NULL);
  105549:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105550:	e8 5c d8 ff ff       	call   102db1 <alloc_pages>
  105555:	85 c0                	test   %eax,%eax
  105557:	74 24                	je     10557d <default_check+0x567>
  105559:	c7 44 24 0c 66 71 10 	movl   $0x107166,0xc(%esp)
  105560:	00 
  105561:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105568:	00 
  105569:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  105570:	00 
  105571:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105578:	e8 c8 ae ff ff       	call   100445 <__panic>

    assert(nr_free == 0);
  10557d:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  105582:	85 c0                	test   %eax,%eax
  105584:	74 24                	je     1055aa <default_check+0x594>
  105586:	c7 44 24 0c b9 71 10 	movl   $0x1071b9,0xc(%esp)
  10558d:	00 
  10558e:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105595:	00 
  105596:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  10559d:	00 
  10559e:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  1055a5:	e8 9b ae ff ff       	call   100445 <__panic>
    nr_free = nr_free_store;
  1055aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055ad:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_list = free_list_store;
  1055b2:	8b 45 80             	mov    -0x80(%ebp),%eax
  1055b5:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1055b8:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  1055bd:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    free_pages(p0, 5);
  1055c3:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1055ca:	00 
  1055cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055ce:	89 04 24             	mov    %eax,(%esp)
  1055d1:	e8 17 d8 ff ff       	call   102ded <free_pages>

    le = &free_list;
  1055d6:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list)
  1055dd:	eb 5a                	jmp    105639 <default_check+0x623>
    {
        assert(le->next->prev == le && le->prev->next == le);
  1055df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1055e2:	8b 40 04             	mov    0x4(%eax),%eax
  1055e5:	8b 00                	mov    (%eax),%eax
  1055e7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1055ea:	75 0d                	jne    1055f9 <default_check+0x5e3>
  1055ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1055ef:	8b 00                	mov    (%eax),%eax
  1055f1:	8b 40 04             	mov    0x4(%eax),%eax
  1055f4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1055f7:	74 24                	je     10561d <default_check+0x607>
  1055f9:	c7 44 24 0c 28 73 10 	movl   $0x107328,0xc(%esp)
  105600:	00 
  105601:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105608:	00 
  105609:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
  105610:	00 
  105611:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105618:	e8 28 ae ff ff       	call   100445 <__panic>
        struct Page *p = le2page(le, page_link);
  10561d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105620:	83 e8 0c             	sub    $0xc,%eax
  105623:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count--, total -= p->property;
  105626:	ff 4d f4             	decl   -0xc(%ebp)
  105629:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10562c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10562f:	8b 40 08             	mov    0x8(%eax),%eax
  105632:	29 c2                	sub    %eax,%edx
  105634:	89 d0                	mov    %edx,%eax
  105636:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10563c:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  10563f:	8b 45 88             	mov    -0x78(%ebp),%eax
  105642:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list)
  105645:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105648:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  10564f:	75 8e                	jne    1055df <default_check+0x5c9>
    }
    assert(count == 0);
  105651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105655:	74 24                	je     10567b <default_check+0x665>
  105657:	c7 44 24 0c 55 73 10 	movl   $0x107355,0xc(%esp)
  10565e:	00 
  10565f:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105666:	00 
  105667:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  10566e:	00 
  10566f:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  105676:	e8 ca ad ff ff       	call   100445 <__panic>
    assert(total == 0);
  10567b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10567f:	74 24                	je     1056a5 <default_check+0x68f>
  105681:	c7 44 24 0c 60 73 10 	movl   $0x107360,0xc(%esp)
  105688:	00 
  105689:	c7 44 24 08 de 6f 10 	movl   $0x106fde,0x8(%esp)
  105690:	00 
  105691:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
  105698:	00 
  105699:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  1056a0:	e8 a0 ad ff ff       	call   100445 <__panic>
}
  1056a5:	90                   	nop
  1056a6:	c9                   	leave  
  1056a7:	c3                   	ret    

001056a8 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1056a8:	f3 0f 1e fb          	endbr32 
  1056ac:	55                   	push   %ebp
  1056ad:	89 e5                	mov    %esp,%ebp
  1056af:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1056b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1056b9:	eb 03                	jmp    1056be <strlen+0x16>
        cnt ++;
  1056bb:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1056be:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c1:	8d 50 01             	lea    0x1(%eax),%edx
  1056c4:	89 55 08             	mov    %edx,0x8(%ebp)
  1056c7:	0f b6 00             	movzbl (%eax),%eax
  1056ca:	84 c0                	test   %al,%al
  1056cc:	75 ed                	jne    1056bb <strlen+0x13>
    }
    return cnt;
  1056ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1056d1:	c9                   	leave  
  1056d2:	c3                   	ret    

001056d3 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1056d3:	f3 0f 1e fb          	endbr32 
  1056d7:	55                   	push   %ebp
  1056d8:	89 e5                	mov    %esp,%ebp
  1056da:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1056dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1056e4:	eb 03                	jmp    1056e9 <strnlen+0x16>
        cnt ++;
  1056e6:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1056e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1056ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1056ef:	73 10                	jae    105701 <strnlen+0x2e>
  1056f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1056f4:	8d 50 01             	lea    0x1(%eax),%edx
  1056f7:	89 55 08             	mov    %edx,0x8(%ebp)
  1056fa:	0f b6 00             	movzbl (%eax),%eax
  1056fd:	84 c0                	test   %al,%al
  1056ff:	75 e5                	jne    1056e6 <strnlen+0x13>
    }
    return cnt;
  105701:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105704:	c9                   	leave  
  105705:	c3                   	ret    

00105706 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105706:	f3 0f 1e fb          	endbr32 
  10570a:	55                   	push   %ebp
  10570b:	89 e5                	mov    %esp,%ebp
  10570d:	57                   	push   %edi
  10570e:	56                   	push   %esi
  10570f:	83 ec 20             	sub    $0x20,%esp
  105712:	8b 45 08             	mov    0x8(%ebp),%eax
  105715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105718:	8b 45 0c             	mov    0xc(%ebp),%eax
  10571b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10571e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105724:	89 d1                	mov    %edx,%ecx
  105726:	89 c2                	mov    %eax,%edx
  105728:	89 ce                	mov    %ecx,%esi
  10572a:	89 d7                	mov    %edx,%edi
  10572c:	ac                   	lods   %ds:(%esi),%al
  10572d:	aa                   	stos   %al,%es:(%edi)
  10572e:	84 c0                	test   %al,%al
  105730:	75 fa                	jne    10572c <strcpy+0x26>
  105732:	89 fa                	mov    %edi,%edx
  105734:	89 f1                	mov    %esi,%ecx
  105736:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105739:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10573c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  10573f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105742:	83 c4 20             	add    $0x20,%esp
  105745:	5e                   	pop    %esi
  105746:	5f                   	pop    %edi
  105747:	5d                   	pop    %ebp
  105748:	c3                   	ret    

00105749 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105749:	f3 0f 1e fb          	endbr32 
  10574d:	55                   	push   %ebp
  10574e:	89 e5                	mov    %esp,%ebp
  105750:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105753:	8b 45 08             	mov    0x8(%ebp),%eax
  105756:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105759:	eb 1e                	jmp    105779 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  10575b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10575e:	0f b6 10             	movzbl (%eax),%edx
  105761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105764:	88 10                	mov    %dl,(%eax)
  105766:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105769:	0f b6 00             	movzbl (%eax),%eax
  10576c:	84 c0                	test   %al,%al
  10576e:	74 03                	je     105773 <strncpy+0x2a>
            src ++;
  105770:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105773:	ff 45 fc             	incl   -0x4(%ebp)
  105776:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105779:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10577d:	75 dc                	jne    10575b <strncpy+0x12>
    }
    return dst;
  10577f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105782:	c9                   	leave  
  105783:	c3                   	ret    

00105784 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105784:	f3 0f 1e fb          	endbr32 
  105788:	55                   	push   %ebp
  105789:	89 e5                	mov    %esp,%ebp
  10578b:	57                   	push   %edi
  10578c:	56                   	push   %esi
  10578d:	83 ec 20             	sub    $0x20,%esp
  105790:	8b 45 08             	mov    0x8(%ebp),%eax
  105793:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105796:	8b 45 0c             	mov    0xc(%ebp),%eax
  105799:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  10579c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10579f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057a2:	89 d1                	mov    %edx,%ecx
  1057a4:	89 c2                	mov    %eax,%edx
  1057a6:	89 ce                	mov    %ecx,%esi
  1057a8:	89 d7                	mov    %edx,%edi
  1057aa:	ac                   	lods   %ds:(%esi),%al
  1057ab:	ae                   	scas   %es:(%edi),%al
  1057ac:	75 08                	jne    1057b6 <strcmp+0x32>
  1057ae:	84 c0                	test   %al,%al
  1057b0:	75 f8                	jne    1057aa <strcmp+0x26>
  1057b2:	31 c0                	xor    %eax,%eax
  1057b4:	eb 04                	jmp    1057ba <strcmp+0x36>
  1057b6:	19 c0                	sbb    %eax,%eax
  1057b8:	0c 01                	or     $0x1,%al
  1057ba:	89 fa                	mov    %edi,%edx
  1057bc:	89 f1                	mov    %esi,%ecx
  1057be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1057c1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1057c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1057c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1057ca:	83 c4 20             	add    $0x20,%esp
  1057cd:	5e                   	pop    %esi
  1057ce:	5f                   	pop    %edi
  1057cf:	5d                   	pop    %ebp
  1057d0:	c3                   	ret    

001057d1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1057d1:	f3 0f 1e fb          	endbr32 
  1057d5:	55                   	push   %ebp
  1057d6:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1057d8:	eb 09                	jmp    1057e3 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  1057da:	ff 4d 10             	decl   0x10(%ebp)
  1057dd:	ff 45 08             	incl   0x8(%ebp)
  1057e0:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1057e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1057e7:	74 1a                	je     105803 <strncmp+0x32>
  1057e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ec:	0f b6 00             	movzbl (%eax),%eax
  1057ef:	84 c0                	test   %al,%al
  1057f1:	74 10                	je     105803 <strncmp+0x32>
  1057f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f6:	0f b6 10             	movzbl (%eax),%edx
  1057f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057fc:	0f b6 00             	movzbl (%eax),%eax
  1057ff:	38 c2                	cmp    %al,%dl
  105801:	74 d7                	je     1057da <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105803:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105807:	74 18                	je     105821 <strncmp+0x50>
  105809:	8b 45 08             	mov    0x8(%ebp),%eax
  10580c:	0f b6 00             	movzbl (%eax),%eax
  10580f:	0f b6 d0             	movzbl %al,%edx
  105812:	8b 45 0c             	mov    0xc(%ebp),%eax
  105815:	0f b6 00             	movzbl (%eax),%eax
  105818:	0f b6 c0             	movzbl %al,%eax
  10581b:	29 c2                	sub    %eax,%edx
  10581d:	89 d0                	mov    %edx,%eax
  10581f:	eb 05                	jmp    105826 <strncmp+0x55>
  105821:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105826:	5d                   	pop    %ebp
  105827:	c3                   	ret    

00105828 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105828:	f3 0f 1e fb          	endbr32 
  10582c:	55                   	push   %ebp
  10582d:	89 e5                	mov    %esp,%ebp
  10582f:	83 ec 04             	sub    $0x4,%esp
  105832:	8b 45 0c             	mov    0xc(%ebp),%eax
  105835:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105838:	eb 13                	jmp    10584d <strchr+0x25>
        if (*s == c) {
  10583a:	8b 45 08             	mov    0x8(%ebp),%eax
  10583d:	0f b6 00             	movzbl (%eax),%eax
  105840:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105843:	75 05                	jne    10584a <strchr+0x22>
            return (char *)s;
  105845:	8b 45 08             	mov    0x8(%ebp),%eax
  105848:	eb 12                	jmp    10585c <strchr+0x34>
        }
        s ++;
  10584a:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10584d:	8b 45 08             	mov    0x8(%ebp),%eax
  105850:	0f b6 00             	movzbl (%eax),%eax
  105853:	84 c0                	test   %al,%al
  105855:	75 e3                	jne    10583a <strchr+0x12>
    }
    return NULL;
  105857:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10585c:	c9                   	leave  
  10585d:	c3                   	ret    

0010585e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10585e:	f3 0f 1e fb          	endbr32 
  105862:	55                   	push   %ebp
  105863:	89 e5                	mov    %esp,%ebp
  105865:	83 ec 04             	sub    $0x4,%esp
  105868:	8b 45 0c             	mov    0xc(%ebp),%eax
  10586b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10586e:	eb 0e                	jmp    10587e <strfind+0x20>
        if (*s == c) {
  105870:	8b 45 08             	mov    0x8(%ebp),%eax
  105873:	0f b6 00             	movzbl (%eax),%eax
  105876:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105879:	74 0f                	je     10588a <strfind+0x2c>
            break;
        }
        s ++;
  10587b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10587e:	8b 45 08             	mov    0x8(%ebp),%eax
  105881:	0f b6 00             	movzbl (%eax),%eax
  105884:	84 c0                	test   %al,%al
  105886:	75 e8                	jne    105870 <strfind+0x12>
  105888:	eb 01                	jmp    10588b <strfind+0x2d>
            break;
  10588a:	90                   	nop
    }
    return (char *)s;
  10588b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10588e:	c9                   	leave  
  10588f:	c3                   	ret    

00105890 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105890:	f3 0f 1e fb          	endbr32 
  105894:	55                   	push   %ebp
  105895:	89 e5                	mov    %esp,%ebp
  105897:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10589a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1058a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1058a8:	eb 03                	jmp    1058ad <strtol+0x1d>
        s ++;
  1058aa:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1058ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1058b0:	0f b6 00             	movzbl (%eax),%eax
  1058b3:	3c 20                	cmp    $0x20,%al
  1058b5:	74 f3                	je     1058aa <strtol+0x1a>
  1058b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ba:	0f b6 00             	movzbl (%eax),%eax
  1058bd:	3c 09                	cmp    $0x9,%al
  1058bf:	74 e9                	je     1058aa <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  1058c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c4:	0f b6 00             	movzbl (%eax),%eax
  1058c7:	3c 2b                	cmp    $0x2b,%al
  1058c9:	75 05                	jne    1058d0 <strtol+0x40>
        s ++;
  1058cb:	ff 45 08             	incl   0x8(%ebp)
  1058ce:	eb 14                	jmp    1058e4 <strtol+0x54>
    }
    else if (*s == '-') {
  1058d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1058d3:	0f b6 00             	movzbl (%eax),%eax
  1058d6:	3c 2d                	cmp    $0x2d,%al
  1058d8:	75 0a                	jne    1058e4 <strtol+0x54>
        s ++, neg = 1;
  1058da:	ff 45 08             	incl   0x8(%ebp)
  1058dd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1058e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1058e8:	74 06                	je     1058f0 <strtol+0x60>
  1058ea:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1058ee:	75 22                	jne    105912 <strtol+0x82>
  1058f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f3:	0f b6 00             	movzbl (%eax),%eax
  1058f6:	3c 30                	cmp    $0x30,%al
  1058f8:	75 18                	jne    105912 <strtol+0x82>
  1058fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1058fd:	40                   	inc    %eax
  1058fe:	0f b6 00             	movzbl (%eax),%eax
  105901:	3c 78                	cmp    $0x78,%al
  105903:	75 0d                	jne    105912 <strtol+0x82>
        s += 2, base = 16;
  105905:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105909:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105910:	eb 29                	jmp    10593b <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  105912:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105916:	75 16                	jne    10592e <strtol+0x9e>
  105918:	8b 45 08             	mov    0x8(%ebp),%eax
  10591b:	0f b6 00             	movzbl (%eax),%eax
  10591e:	3c 30                	cmp    $0x30,%al
  105920:	75 0c                	jne    10592e <strtol+0x9e>
        s ++, base = 8;
  105922:	ff 45 08             	incl   0x8(%ebp)
  105925:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10592c:	eb 0d                	jmp    10593b <strtol+0xab>
    }
    else if (base == 0) {
  10592e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105932:	75 07                	jne    10593b <strtol+0xab>
        base = 10;
  105934:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10593b:	8b 45 08             	mov    0x8(%ebp),%eax
  10593e:	0f b6 00             	movzbl (%eax),%eax
  105941:	3c 2f                	cmp    $0x2f,%al
  105943:	7e 1b                	jle    105960 <strtol+0xd0>
  105945:	8b 45 08             	mov    0x8(%ebp),%eax
  105948:	0f b6 00             	movzbl (%eax),%eax
  10594b:	3c 39                	cmp    $0x39,%al
  10594d:	7f 11                	jg     105960 <strtol+0xd0>
            dig = *s - '0';
  10594f:	8b 45 08             	mov    0x8(%ebp),%eax
  105952:	0f b6 00             	movzbl (%eax),%eax
  105955:	0f be c0             	movsbl %al,%eax
  105958:	83 e8 30             	sub    $0x30,%eax
  10595b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10595e:	eb 48                	jmp    1059a8 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105960:	8b 45 08             	mov    0x8(%ebp),%eax
  105963:	0f b6 00             	movzbl (%eax),%eax
  105966:	3c 60                	cmp    $0x60,%al
  105968:	7e 1b                	jle    105985 <strtol+0xf5>
  10596a:	8b 45 08             	mov    0x8(%ebp),%eax
  10596d:	0f b6 00             	movzbl (%eax),%eax
  105970:	3c 7a                	cmp    $0x7a,%al
  105972:	7f 11                	jg     105985 <strtol+0xf5>
            dig = *s - 'a' + 10;
  105974:	8b 45 08             	mov    0x8(%ebp),%eax
  105977:	0f b6 00             	movzbl (%eax),%eax
  10597a:	0f be c0             	movsbl %al,%eax
  10597d:	83 e8 57             	sub    $0x57,%eax
  105980:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105983:	eb 23                	jmp    1059a8 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105985:	8b 45 08             	mov    0x8(%ebp),%eax
  105988:	0f b6 00             	movzbl (%eax),%eax
  10598b:	3c 40                	cmp    $0x40,%al
  10598d:	7e 3b                	jle    1059ca <strtol+0x13a>
  10598f:	8b 45 08             	mov    0x8(%ebp),%eax
  105992:	0f b6 00             	movzbl (%eax),%eax
  105995:	3c 5a                	cmp    $0x5a,%al
  105997:	7f 31                	jg     1059ca <strtol+0x13a>
            dig = *s - 'A' + 10;
  105999:	8b 45 08             	mov    0x8(%ebp),%eax
  10599c:	0f b6 00             	movzbl (%eax),%eax
  10599f:	0f be c0             	movsbl %al,%eax
  1059a2:	83 e8 37             	sub    $0x37,%eax
  1059a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1059a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059ab:	3b 45 10             	cmp    0x10(%ebp),%eax
  1059ae:	7d 19                	jge    1059c9 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  1059b0:	ff 45 08             	incl   0x8(%ebp)
  1059b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1059b6:	0f af 45 10          	imul   0x10(%ebp),%eax
  1059ba:	89 c2                	mov    %eax,%edx
  1059bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059bf:	01 d0                	add    %edx,%eax
  1059c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1059c4:	e9 72 ff ff ff       	jmp    10593b <strtol+0xab>
            break;
  1059c9:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1059ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1059ce:	74 08                	je     1059d8 <strtol+0x148>
        *endptr = (char *) s;
  1059d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059d3:	8b 55 08             	mov    0x8(%ebp),%edx
  1059d6:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1059d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1059dc:	74 07                	je     1059e5 <strtol+0x155>
  1059de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1059e1:	f7 d8                	neg    %eax
  1059e3:	eb 03                	jmp    1059e8 <strtol+0x158>
  1059e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1059e8:	c9                   	leave  
  1059e9:	c3                   	ret    

001059ea <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1059ea:	f3 0f 1e fb          	endbr32 
  1059ee:	55                   	push   %ebp
  1059ef:	89 e5                	mov    %esp,%ebp
  1059f1:	57                   	push   %edi
  1059f2:	83 ec 24             	sub    $0x24,%esp
  1059f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f8:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1059fb:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  1059ff:	8b 45 08             	mov    0x8(%ebp),%eax
  105a02:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105a05:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105a08:	8b 45 10             	mov    0x10(%ebp),%eax
  105a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105a0e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105a11:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105a15:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105a18:	89 d7                	mov    %edx,%edi
  105a1a:	f3 aa                	rep stos %al,%es:(%edi)
  105a1c:	89 fa                	mov    %edi,%edx
  105a1e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105a21:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105a24:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105a27:	83 c4 24             	add    $0x24,%esp
  105a2a:	5f                   	pop    %edi
  105a2b:	5d                   	pop    %ebp
  105a2c:	c3                   	ret    

00105a2d <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105a2d:	f3 0f 1e fb          	endbr32 
  105a31:	55                   	push   %ebp
  105a32:	89 e5                	mov    %esp,%ebp
  105a34:	57                   	push   %edi
  105a35:	56                   	push   %esi
  105a36:	53                   	push   %ebx
  105a37:	83 ec 30             	sub    $0x30,%esp
  105a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a43:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a46:	8b 45 10             	mov    0x10(%ebp),%eax
  105a49:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a4f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105a52:	73 42                	jae    105a96 <memmove+0x69>
  105a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a63:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105a66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105a69:	c1 e8 02             	shr    $0x2,%eax
  105a6c:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105a6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105a71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a74:	89 d7                	mov    %edx,%edi
  105a76:	89 c6                	mov    %eax,%esi
  105a78:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105a7a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105a7d:	83 e1 03             	and    $0x3,%ecx
  105a80:	74 02                	je     105a84 <memmove+0x57>
  105a82:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105a84:	89 f0                	mov    %esi,%eax
  105a86:	89 fa                	mov    %edi,%edx
  105a88:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105a8b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105a8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105a91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  105a94:	eb 36                	jmp    105acc <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105a96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a99:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a9f:	01 c2                	add    %eax,%edx
  105aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105aa4:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aaa:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105aad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ab0:	89 c1                	mov    %eax,%ecx
  105ab2:	89 d8                	mov    %ebx,%eax
  105ab4:	89 d6                	mov    %edx,%esi
  105ab6:	89 c7                	mov    %eax,%edi
  105ab8:	fd                   	std    
  105ab9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105abb:	fc                   	cld    
  105abc:	89 f8                	mov    %edi,%eax
  105abe:	89 f2                	mov    %esi,%edx
  105ac0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105ac3:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105ac6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105acc:	83 c4 30             	add    $0x30,%esp
  105acf:	5b                   	pop    %ebx
  105ad0:	5e                   	pop    %esi
  105ad1:	5f                   	pop    %edi
  105ad2:	5d                   	pop    %ebp
  105ad3:	c3                   	ret    

00105ad4 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105ad4:	f3 0f 1e fb          	endbr32 
  105ad8:	55                   	push   %ebp
  105ad9:	89 e5                	mov    %esp,%ebp
  105adb:	57                   	push   %edi
  105adc:	56                   	push   %esi
  105add:	83 ec 20             	sub    $0x20,%esp
  105ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105aec:	8b 45 10             	mov    0x10(%ebp),%eax
  105aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105af5:	c1 e8 02             	shr    $0x2,%eax
  105af8:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b00:	89 d7                	mov    %edx,%edi
  105b02:	89 c6                	mov    %eax,%esi
  105b04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105b06:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105b09:	83 e1 03             	and    $0x3,%ecx
  105b0c:	74 02                	je     105b10 <memcpy+0x3c>
  105b0e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105b10:	89 f0                	mov    %esi,%eax
  105b12:	89 fa                	mov    %edi,%edx
  105b14:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105b17:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105b1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105b20:	83 c4 20             	add    $0x20,%esp
  105b23:	5e                   	pop    %esi
  105b24:	5f                   	pop    %edi
  105b25:	5d                   	pop    %ebp
  105b26:	c3                   	ret    

00105b27 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105b27:	f3 0f 1e fb          	endbr32 
  105b2b:	55                   	push   %ebp
  105b2c:	89 e5                	mov    %esp,%ebp
  105b2e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105b31:	8b 45 08             	mov    0x8(%ebp),%eax
  105b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105b3d:	eb 2e                	jmp    105b6d <memcmp+0x46>
        if (*s1 != *s2) {
  105b3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b42:	0f b6 10             	movzbl (%eax),%edx
  105b45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105b48:	0f b6 00             	movzbl (%eax),%eax
  105b4b:	38 c2                	cmp    %al,%dl
  105b4d:	74 18                	je     105b67 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105b4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b52:	0f b6 00             	movzbl (%eax),%eax
  105b55:	0f b6 d0             	movzbl %al,%edx
  105b58:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105b5b:	0f b6 00             	movzbl (%eax),%eax
  105b5e:	0f b6 c0             	movzbl %al,%eax
  105b61:	29 c2                	sub    %eax,%edx
  105b63:	89 d0                	mov    %edx,%eax
  105b65:	eb 18                	jmp    105b7f <memcmp+0x58>
        }
        s1 ++, s2 ++;
  105b67:	ff 45 fc             	incl   -0x4(%ebp)
  105b6a:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  105b70:	8d 50 ff             	lea    -0x1(%eax),%edx
  105b73:	89 55 10             	mov    %edx,0x10(%ebp)
  105b76:	85 c0                	test   %eax,%eax
  105b78:	75 c5                	jne    105b3f <memcmp+0x18>
    }
    return 0;
  105b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105b7f:	c9                   	leave  
  105b80:	c3                   	ret    

00105b81 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105b81:	f3 0f 1e fb          	endbr32 
  105b85:	55                   	push   %ebp
  105b86:	89 e5                	mov    %esp,%ebp
  105b88:	83 ec 58             	sub    $0x58,%esp
  105b8b:	8b 45 10             	mov    0x10(%ebp),%eax
  105b8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105b91:	8b 45 14             	mov    0x14(%ebp),%eax
  105b94:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105b97:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105b9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105b9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105ba0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105ba3:	8b 45 18             	mov    0x18(%ebp),%eax
  105ba6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105bac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105baf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105bb2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105bbf:	74 1c                	je     105bdd <printnum+0x5c>
  105bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  105bc9:	f7 75 e4             	divl   -0x1c(%ebp)
  105bcc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  105bd7:	f7 75 e4             	divl   -0x1c(%ebp)
  105bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105be3:	f7 75 e4             	divl   -0x1c(%ebp)
  105be6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105be9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105bec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105bef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105bf2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105bf5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105bf8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105bfb:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105bfe:	8b 45 18             	mov    0x18(%ebp),%eax
  105c01:	ba 00 00 00 00       	mov    $0x0,%edx
  105c06:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105c09:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105c0c:	19 d1                	sbb    %edx,%ecx
  105c0e:	72 4c                	jb     105c5c <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  105c10:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105c13:	8d 50 ff             	lea    -0x1(%eax),%edx
  105c16:	8b 45 20             	mov    0x20(%ebp),%eax
  105c19:	89 44 24 18          	mov    %eax,0x18(%esp)
  105c1d:	89 54 24 14          	mov    %edx,0x14(%esp)
  105c21:	8b 45 18             	mov    0x18(%ebp),%eax
  105c24:	89 44 24 10          	mov    %eax,0x10(%esp)
  105c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105c2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105c2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c32:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c40:	89 04 24             	mov    %eax,(%esp)
  105c43:	e8 39 ff ff ff       	call   105b81 <printnum>
  105c48:	eb 1b                	jmp    105c65 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c51:	8b 45 20             	mov    0x20(%ebp),%eax
  105c54:	89 04 24             	mov    %eax,(%esp)
  105c57:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5a:	ff d0                	call   *%eax
        while (-- width > 0)
  105c5c:	ff 4d 1c             	decl   0x1c(%ebp)
  105c5f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105c63:	7f e5                	jg     105c4a <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105c65:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105c68:	05 1c 74 10 00       	add    $0x10741c,%eax
  105c6d:	0f b6 00             	movzbl (%eax),%eax
  105c70:	0f be c0             	movsbl %al,%eax
  105c73:	8b 55 0c             	mov    0xc(%ebp),%edx
  105c76:	89 54 24 04          	mov    %edx,0x4(%esp)
  105c7a:	89 04 24             	mov    %eax,(%esp)
  105c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c80:	ff d0                	call   *%eax
}
  105c82:	90                   	nop
  105c83:	c9                   	leave  
  105c84:	c3                   	ret    

00105c85 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105c85:	f3 0f 1e fb          	endbr32 
  105c89:	55                   	push   %ebp
  105c8a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105c8c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105c90:	7e 14                	jle    105ca6 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  105c92:	8b 45 08             	mov    0x8(%ebp),%eax
  105c95:	8b 00                	mov    (%eax),%eax
  105c97:	8d 48 08             	lea    0x8(%eax),%ecx
  105c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  105c9d:	89 0a                	mov    %ecx,(%edx)
  105c9f:	8b 50 04             	mov    0x4(%eax),%edx
  105ca2:	8b 00                	mov    (%eax),%eax
  105ca4:	eb 30                	jmp    105cd6 <getuint+0x51>
    }
    else if (lflag) {
  105ca6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105caa:	74 16                	je     105cc2 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  105cac:	8b 45 08             	mov    0x8(%ebp),%eax
  105caf:	8b 00                	mov    (%eax),%eax
  105cb1:	8d 48 04             	lea    0x4(%eax),%ecx
  105cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  105cb7:	89 0a                	mov    %ecx,(%edx)
  105cb9:	8b 00                	mov    (%eax),%eax
  105cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  105cc0:	eb 14                	jmp    105cd6 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  105cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc5:	8b 00                	mov    (%eax),%eax
  105cc7:	8d 48 04             	lea    0x4(%eax),%ecx
  105cca:	8b 55 08             	mov    0x8(%ebp),%edx
  105ccd:	89 0a                	mov    %ecx,(%edx)
  105ccf:	8b 00                	mov    (%eax),%eax
  105cd1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105cd6:	5d                   	pop    %ebp
  105cd7:	c3                   	ret    

00105cd8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105cd8:	f3 0f 1e fb          	endbr32 
  105cdc:	55                   	push   %ebp
  105cdd:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105cdf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105ce3:	7e 14                	jle    105cf9 <getint+0x21>
        return va_arg(*ap, long long);
  105ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce8:	8b 00                	mov    (%eax),%eax
  105cea:	8d 48 08             	lea    0x8(%eax),%ecx
  105ced:	8b 55 08             	mov    0x8(%ebp),%edx
  105cf0:	89 0a                	mov    %ecx,(%edx)
  105cf2:	8b 50 04             	mov    0x4(%eax),%edx
  105cf5:	8b 00                	mov    (%eax),%eax
  105cf7:	eb 28                	jmp    105d21 <getint+0x49>
    }
    else if (lflag) {
  105cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105cfd:	74 12                	je     105d11 <getint+0x39>
        return va_arg(*ap, long);
  105cff:	8b 45 08             	mov    0x8(%ebp),%eax
  105d02:	8b 00                	mov    (%eax),%eax
  105d04:	8d 48 04             	lea    0x4(%eax),%ecx
  105d07:	8b 55 08             	mov    0x8(%ebp),%edx
  105d0a:	89 0a                	mov    %ecx,(%edx)
  105d0c:	8b 00                	mov    (%eax),%eax
  105d0e:	99                   	cltd   
  105d0f:	eb 10                	jmp    105d21 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  105d11:	8b 45 08             	mov    0x8(%ebp),%eax
  105d14:	8b 00                	mov    (%eax),%eax
  105d16:	8d 48 04             	lea    0x4(%eax),%ecx
  105d19:	8b 55 08             	mov    0x8(%ebp),%edx
  105d1c:	89 0a                	mov    %ecx,(%edx)
  105d1e:	8b 00                	mov    (%eax),%eax
  105d20:	99                   	cltd   
    }
}
  105d21:	5d                   	pop    %ebp
  105d22:	c3                   	ret    

00105d23 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105d23:	f3 0f 1e fb          	endbr32 
  105d27:	55                   	push   %ebp
  105d28:	89 e5                	mov    %esp,%ebp
  105d2a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105d2d:	8d 45 14             	lea    0x14(%ebp),%eax
  105d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d36:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  105d3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d48:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4b:	89 04 24             	mov    %eax,(%esp)
  105d4e:	e8 03 00 00 00       	call   105d56 <vprintfmt>
    va_end(ap);
}
  105d53:	90                   	nop
  105d54:	c9                   	leave  
  105d55:	c3                   	ret    

00105d56 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105d56:	f3 0f 1e fb          	endbr32 
  105d5a:	55                   	push   %ebp
  105d5b:	89 e5                	mov    %esp,%ebp
  105d5d:	56                   	push   %esi
  105d5e:	53                   	push   %ebx
  105d5f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105d62:	eb 17                	jmp    105d7b <vprintfmt+0x25>
            if (ch == '\0') {
  105d64:	85 db                	test   %ebx,%ebx
  105d66:	0f 84 c0 03 00 00    	je     10612c <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  105d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d73:	89 1c 24             	mov    %ebx,(%esp)
  105d76:	8b 45 08             	mov    0x8(%ebp),%eax
  105d79:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  105d7e:	8d 50 01             	lea    0x1(%eax),%edx
  105d81:	89 55 10             	mov    %edx,0x10(%ebp)
  105d84:	0f b6 00             	movzbl (%eax),%eax
  105d87:	0f b6 d8             	movzbl %al,%ebx
  105d8a:	83 fb 25             	cmp    $0x25,%ebx
  105d8d:	75 d5                	jne    105d64 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105d8f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105d93:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105da0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105da7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105daa:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105dad:	8b 45 10             	mov    0x10(%ebp),%eax
  105db0:	8d 50 01             	lea    0x1(%eax),%edx
  105db3:	89 55 10             	mov    %edx,0x10(%ebp)
  105db6:	0f b6 00             	movzbl (%eax),%eax
  105db9:	0f b6 d8             	movzbl %al,%ebx
  105dbc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105dbf:	83 f8 55             	cmp    $0x55,%eax
  105dc2:	0f 87 38 03 00 00    	ja     106100 <vprintfmt+0x3aa>
  105dc8:	8b 04 85 40 74 10 00 	mov    0x107440(,%eax,4),%eax
  105dcf:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105dd2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105dd6:	eb d5                	jmp    105dad <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105dd8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105ddc:	eb cf                	jmp    105dad <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105dde:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105de5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105de8:	89 d0                	mov    %edx,%eax
  105dea:	c1 e0 02             	shl    $0x2,%eax
  105ded:	01 d0                	add    %edx,%eax
  105def:	01 c0                	add    %eax,%eax
  105df1:	01 d8                	add    %ebx,%eax
  105df3:	83 e8 30             	sub    $0x30,%eax
  105df6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105df9:	8b 45 10             	mov    0x10(%ebp),%eax
  105dfc:	0f b6 00             	movzbl (%eax),%eax
  105dff:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105e02:	83 fb 2f             	cmp    $0x2f,%ebx
  105e05:	7e 38                	jle    105e3f <vprintfmt+0xe9>
  105e07:	83 fb 39             	cmp    $0x39,%ebx
  105e0a:	7f 33                	jg     105e3f <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  105e0c:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105e0f:	eb d4                	jmp    105de5 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105e11:	8b 45 14             	mov    0x14(%ebp),%eax
  105e14:	8d 50 04             	lea    0x4(%eax),%edx
  105e17:	89 55 14             	mov    %edx,0x14(%ebp)
  105e1a:	8b 00                	mov    (%eax),%eax
  105e1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105e1f:	eb 1f                	jmp    105e40 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  105e21:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e25:	79 86                	jns    105dad <vprintfmt+0x57>
                width = 0;
  105e27:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105e2e:	e9 7a ff ff ff       	jmp    105dad <vprintfmt+0x57>

        case '#':
            altflag = 1;
  105e33:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105e3a:	e9 6e ff ff ff       	jmp    105dad <vprintfmt+0x57>
            goto process_precision;
  105e3f:	90                   	nop

        process_precision:
            if (width < 0)
  105e40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e44:	0f 89 63 ff ff ff    	jns    105dad <vprintfmt+0x57>
                width = precision, precision = -1;
  105e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105e4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105e50:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105e57:	e9 51 ff ff ff       	jmp    105dad <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105e5c:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105e5f:	e9 49 ff ff ff       	jmp    105dad <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105e64:	8b 45 14             	mov    0x14(%ebp),%eax
  105e67:	8d 50 04             	lea    0x4(%eax),%edx
  105e6a:	89 55 14             	mov    %edx,0x14(%ebp)
  105e6d:	8b 00                	mov    (%eax),%eax
  105e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105e72:	89 54 24 04          	mov    %edx,0x4(%esp)
  105e76:	89 04 24             	mov    %eax,(%esp)
  105e79:	8b 45 08             	mov    0x8(%ebp),%eax
  105e7c:	ff d0                	call   *%eax
            break;
  105e7e:	e9 a4 02 00 00       	jmp    106127 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105e83:	8b 45 14             	mov    0x14(%ebp),%eax
  105e86:	8d 50 04             	lea    0x4(%eax),%edx
  105e89:	89 55 14             	mov    %edx,0x14(%ebp)
  105e8c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105e8e:	85 db                	test   %ebx,%ebx
  105e90:	79 02                	jns    105e94 <vprintfmt+0x13e>
                err = -err;
  105e92:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105e94:	83 fb 06             	cmp    $0x6,%ebx
  105e97:	7f 0b                	jg     105ea4 <vprintfmt+0x14e>
  105e99:	8b 34 9d 00 74 10 00 	mov    0x107400(,%ebx,4),%esi
  105ea0:	85 f6                	test   %esi,%esi
  105ea2:	75 23                	jne    105ec7 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  105ea4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105ea8:	c7 44 24 08 2d 74 10 	movl   $0x10742d,0x8(%esp)
  105eaf:	00 
  105eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105eb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  105eba:	89 04 24             	mov    %eax,(%esp)
  105ebd:	e8 61 fe ff ff       	call   105d23 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105ec2:	e9 60 02 00 00       	jmp    106127 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  105ec7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105ecb:	c7 44 24 08 36 74 10 	movl   $0x107436,0x8(%esp)
  105ed2:	00 
  105ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ed6:	89 44 24 04          	mov    %eax,0x4(%esp)
  105eda:	8b 45 08             	mov    0x8(%ebp),%eax
  105edd:	89 04 24             	mov    %eax,(%esp)
  105ee0:	e8 3e fe ff ff       	call   105d23 <printfmt>
            break;
  105ee5:	e9 3d 02 00 00       	jmp    106127 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105eea:	8b 45 14             	mov    0x14(%ebp),%eax
  105eed:	8d 50 04             	lea    0x4(%eax),%edx
  105ef0:	89 55 14             	mov    %edx,0x14(%ebp)
  105ef3:	8b 30                	mov    (%eax),%esi
  105ef5:	85 f6                	test   %esi,%esi
  105ef7:	75 05                	jne    105efe <vprintfmt+0x1a8>
                p = "(null)";
  105ef9:	be 39 74 10 00       	mov    $0x107439,%esi
            }
            if (width > 0 && padc != '-') {
  105efe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105f02:	7e 76                	jle    105f7a <vprintfmt+0x224>
  105f04:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105f08:	74 70                	je     105f7a <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105f0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f11:	89 34 24             	mov    %esi,(%esp)
  105f14:	e8 ba f7 ff ff       	call   1056d3 <strnlen>
  105f19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105f1c:	29 c2                	sub    %eax,%edx
  105f1e:	89 d0                	mov    %edx,%eax
  105f20:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105f23:	eb 16                	jmp    105f3b <vprintfmt+0x1e5>
                    putch(padc, putdat);
  105f25:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  105f2c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105f30:	89 04 24             	mov    %eax,(%esp)
  105f33:	8b 45 08             	mov    0x8(%ebp),%eax
  105f36:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105f38:	ff 4d e8             	decl   -0x18(%ebp)
  105f3b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105f3f:	7f e4                	jg     105f25 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105f41:	eb 37                	jmp    105f7a <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  105f43:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105f47:	74 1f                	je     105f68 <vprintfmt+0x212>
  105f49:	83 fb 1f             	cmp    $0x1f,%ebx
  105f4c:	7e 05                	jle    105f53 <vprintfmt+0x1fd>
  105f4e:	83 fb 7e             	cmp    $0x7e,%ebx
  105f51:	7e 15                	jle    105f68 <vprintfmt+0x212>
                    putch('?', putdat);
  105f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f56:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f5a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105f61:	8b 45 08             	mov    0x8(%ebp),%eax
  105f64:	ff d0                	call   *%eax
  105f66:	eb 0f                	jmp    105f77 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  105f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f6f:	89 1c 24             	mov    %ebx,(%esp)
  105f72:	8b 45 08             	mov    0x8(%ebp),%eax
  105f75:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105f77:	ff 4d e8             	decl   -0x18(%ebp)
  105f7a:	89 f0                	mov    %esi,%eax
  105f7c:	8d 70 01             	lea    0x1(%eax),%esi
  105f7f:	0f b6 00             	movzbl (%eax),%eax
  105f82:	0f be d8             	movsbl %al,%ebx
  105f85:	85 db                	test   %ebx,%ebx
  105f87:	74 27                	je     105fb0 <vprintfmt+0x25a>
  105f89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105f8d:	78 b4                	js     105f43 <vprintfmt+0x1ed>
  105f8f:	ff 4d e4             	decl   -0x1c(%ebp)
  105f92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105f96:	79 ab                	jns    105f43 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  105f98:	eb 16                	jmp    105fb0 <vprintfmt+0x25a>
                putch(' ', putdat);
  105f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fa1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  105fab:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105fad:	ff 4d e8             	decl   -0x18(%ebp)
  105fb0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105fb4:	7f e4                	jg     105f9a <vprintfmt+0x244>
            }
            break;
  105fb6:	e9 6c 01 00 00       	jmp    106127 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fc2:	8d 45 14             	lea    0x14(%ebp),%eax
  105fc5:	89 04 24             	mov    %eax,(%esp)
  105fc8:	e8 0b fd ff ff       	call   105cd8 <getint>
  105fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105fd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105fd9:	85 d2                	test   %edx,%edx
  105fdb:	79 26                	jns    106003 <vprintfmt+0x2ad>
                putch('-', putdat);
  105fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fe4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105feb:	8b 45 08             	mov    0x8(%ebp),%eax
  105fee:	ff d0                	call   *%eax
                num = -(long long)num;
  105ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ff3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ff6:	f7 d8                	neg    %eax
  105ff8:	83 d2 00             	adc    $0x0,%edx
  105ffb:	f7 da                	neg    %edx
  105ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106000:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  106003:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10600a:	e9 a8 00 00 00       	jmp    1060b7 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10600f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106012:	89 44 24 04          	mov    %eax,0x4(%esp)
  106016:	8d 45 14             	lea    0x14(%ebp),%eax
  106019:	89 04 24             	mov    %eax,(%esp)
  10601c:	e8 64 fc ff ff       	call   105c85 <getuint>
  106021:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106024:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  106027:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10602e:	e9 84 00 00 00       	jmp    1060b7 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  106033:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106036:	89 44 24 04          	mov    %eax,0x4(%esp)
  10603a:	8d 45 14             	lea    0x14(%ebp),%eax
  10603d:	89 04 24             	mov    %eax,(%esp)
  106040:	e8 40 fc ff ff       	call   105c85 <getuint>
  106045:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106048:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10604b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  106052:	eb 63                	jmp    1060b7 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  106054:	8b 45 0c             	mov    0xc(%ebp),%eax
  106057:	89 44 24 04          	mov    %eax,0x4(%esp)
  10605b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  106062:	8b 45 08             	mov    0x8(%ebp),%eax
  106065:	ff d0                	call   *%eax
            putch('x', putdat);
  106067:	8b 45 0c             	mov    0xc(%ebp),%eax
  10606a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10606e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  106075:	8b 45 08             	mov    0x8(%ebp),%eax
  106078:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10607a:	8b 45 14             	mov    0x14(%ebp),%eax
  10607d:	8d 50 04             	lea    0x4(%eax),%edx
  106080:	89 55 14             	mov    %edx,0x14(%ebp)
  106083:	8b 00                	mov    (%eax),%eax
  106085:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106088:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10608f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  106096:	eb 1f                	jmp    1060b7 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  106098:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10609b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10609f:	8d 45 14             	lea    0x14(%ebp),%eax
  1060a2:	89 04 24             	mov    %eax,(%esp)
  1060a5:	e8 db fb ff ff       	call   105c85 <getuint>
  1060aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1060b0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1060b7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1060bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060be:	89 54 24 18          	mov    %edx,0x18(%esp)
  1060c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1060c5:	89 54 24 14          	mov    %edx,0x14(%esp)
  1060c9:	89 44 24 10          	mov    %eax,0x10(%esp)
  1060cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1060d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1060d7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1060db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1060e5:	89 04 24             	mov    %eax,(%esp)
  1060e8:	e8 94 fa ff ff       	call   105b81 <printnum>
            break;
  1060ed:	eb 38                	jmp    106127 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1060ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060f6:	89 1c 24             	mov    %ebx,(%esp)
  1060f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1060fc:	ff d0                	call   *%eax
            break;
  1060fe:	eb 27                	jmp    106127 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  106100:	8b 45 0c             	mov    0xc(%ebp),%eax
  106103:	89 44 24 04          	mov    %eax,0x4(%esp)
  106107:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10610e:	8b 45 08             	mov    0x8(%ebp),%eax
  106111:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  106113:	ff 4d 10             	decl   0x10(%ebp)
  106116:	eb 03                	jmp    10611b <vprintfmt+0x3c5>
  106118:	ff 4d 10             	decl   0x10(%ebp)
  10611b:	8b 45 10             	mov    0x10(%ebp),%eax
  10611e:	48                   	dec    %eax
  10611f:	0f b6 00             	movzbl (%eax),%eax
  106122:	3c 25                	cmp    $0x25,%al
  106124:	75 f2                	jne    106118 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  106126:	90                   	nop
    while (1) {
  106127:	e9 36 fc ff ff       	jmp    105d62 <vprintfmt+0xc>
                return;
  10612c:	90                   	nop
        }
    }
}
  10612d:	83 c4 40             	add    $0x40,%esp
  106130:	5b                   	pop    %ebx
  106131:	5e                   	pop    %esi
  106132:	5d                   	pop    %ebp
  106133:	c3                   	ret    

00106134 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  106134:	f3 0f 1e fb          	endbr32 
  106138:	55                   	push   %ebp
  106139:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10613b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10613e:	8b 40 08             	mov    0x8(%eax),%eax
  106141:	8d 50 01             	lea    0x1(%eax),%edx
  106144:	8b 45 0c             	mov    0xc(%ebp),%eax
  106147:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10614a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10614d:	8b 10                	mov    (%eax),%edx
  10614f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106152:	8b 40 04             	mov    0x4(%eax),%eax
  106155:	39 c2                	cmp    %eax,%edx
  106157:	73 12                	jae    10616b <sprintputch+0x37>
        *b->buf ++ = ch;
  106159:	8b 45 0c             	mov    0xc(%ebp),%eax
  10615c:	8b 00                	mov    (%eax),%eax
  10615e:	8d 48 01             	lea    0x1(%eax),%ecx
  106161:	8b 55 0c             	mov    0xc(%ebp),%edx
  106164:	89 0a                	mov    %ecx,(%edx)
  106166:	8b 55 08             	mov    0x8(%ebp),%edx
  106169:	88 10                	mov    %dl,(%eax)
    }
}
  10616b:	90                   	nop
  10616c:	5d                   	pop    %ebp
  10616d:	c3                   	ret    

0010616e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10616e:	f3 0f 1e fb          	endbr32 
  106172:	55                   	push   %ebp
  106173:	89 e5                	mov    %esp,%ebp
  106175:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106178:	8d 45 14             	lea    0x14(%ebp),%eax
  10617b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10617e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106181:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106185:	8b 45 10             	mov    0x10(%ebp),%eax
  106188:	89 44 24 08          	mov    %eax,0x8(%esp)
  10618c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10618f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106193:	8b 45 08             	mov    0x8(%ebp),%eax
  106196:	89 04 24             	mov    %eax,(%esp)
  106199:	e8 08 00 00 00       	call   1061a6 <vsnprintf>
  10619e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1061a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1061a4:	c9                   	leave  
  1061a5:	c3                   	ret    

001061a6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1061a6:	f3 0f 1e fb          	endbr32 
  1061aa:	55                   	push   %ebp
  1061ab:	89 e5                	mov    %esp,%ebp
  1061ad:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1061b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1061b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1061b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1061bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1061bf:	01 d0                	add    %edx,%eax
  1061c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1061c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1061cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1061cf:	74 0a                	je     1061db <vsnprintf+0x35>
  1061d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1061d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061d7:	39 c2                	cmp    %eax,%edx
  1061d9:	76 07                	jbe    1061e2 <vsnprintf+0x3c>
        return -E_INVAL;
  1061db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1061e0:	eb 2a                	jmp    10620c <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1061e2:	8b 45 14             	mov    0x14(%ebp),%eax
  1061e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1061e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1061ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1061f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1061f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1061f7:	c7 04 24 34 61 10 00 	movl   $0x106134,(%esp)
  1061fe:	e8 53 fb ff ff       	call   105d56 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  106203:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106206:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  106209:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10620c:	c9                   	leave  
  10620d:	c3                   	ret    
