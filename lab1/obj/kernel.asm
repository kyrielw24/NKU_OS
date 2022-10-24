
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int kern_init(void)
{
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10000a:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  10000f:	2d 16 0a 11 00       	sub    $0x110a16,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 0a 11 00 	movl   $0x110a16,(%esp)
  100027:	e8 e1 2e 00 00       	call   102f0d <memset>

    cons_init(); // init the console
  10002c:	e8 37 16 00 00       	call   101668 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 40 37 10 00 	movl   $0x103740,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 5c 37 10 00 	movl   $0x10375c,(%esp)
  100046:	e8 58 02 00 00       	call   1002a3 <cprintf>

    print_kerninfo();
  10004b:	e8 16 09 00 00       	call   100966 <print_kerninfo>

    grade_backtrace();
  100050:	e8 9a 00 00 00       	call   1000ef <grade_backtrace>

    pmm_init(); // init physical memory management
  100055:	e8 62 2b 00 00       	call   102bbc <pmm_init>

    pic_init(); // init interrupt controller
  10005a:	e8 5e 17 00 00       	call   1017bd <pic_init>
    idt_init(); // init interrupt descriptor table
  10005f:	e8 03 19 00 00       	call   101967 <idt_init>

    clock_init();  // init clock interrupt
  100064:	e8 84 0d 00 00       	call   100ded <clock_init>
    intr_enable(); // enable irq interrupt
  100069:	e8 9b 18 00 00       	call   101909 <intr_enable>

    // LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    //  user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 96 01 00 00       	call   100209 <lab1_switch_test>

    /* do nothing */
    while (1)
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
        ;
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3)
{
  100075:	f3 0f 1e fb          	endbr32 
  100079:	55                   	push   %ebp
  10007a:	89 e5                	mov    %esp,%ebp
  10007c:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100086:	00 
  100087:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008e:	00 
  10008f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100096:	e8 3c 0d 00 00       	call   100dd7 <mon_backtrace>
}
  10009b:	90                   	nop
  10009c:	c9                   	leave  
  10009d:	c3                   	ret    

0010009e <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1)
{
  10009e:	f3 0f 1e fb          	endbr32 
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	53                   	push   %ebx
  1000a6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000af:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000c1:	89 04 24             	mov    %eax,(%esp)
  1000c4:	e8 ac ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c9:	90                   	nop
  1000ca:	83 c4 14             	add    $0x14,%esp
  1000cd:	5b                   	pop    %ebx
  1000ce:	5d                   	pop    %ebp
  1000cf:	c3                   	ret    

001000d0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2)
{
  1000d0:	f3 0f 1e fb          	endbr32 
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	8b 45 10             	mov    0x10(%ebp),%eax
  1000dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e4:	89 04 24             	mov    %eax,(%esp)
  1000e7:	e8 b2 ff ff ff       	call   10009e <grade_backtrace1>
}
  1000ec:	90                   	nop
  1000ed:	c9                   	leave  
  1000ee:	c3                   	ret    

001000ef <grade_backtrace>:

void grade_backtrace(void)
{
  1000ef:	f3 0f 1e fb          	endbr32 
  1000f3:	55                   	push   %ebp
  1000f4:	89 e5                	mov    %esp,%ebp
  1000f6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000fe:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100105:	ff 
  100106:	89 44 24 04          	mov    %eax,0x4(%esp)
  10010a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100111:	e8 ba ff ff ff       	call   1000d0 <grade_backtrace0>
}
  100116:	90                   	nop
  100117:	c9                   	leave  
  100118:	c3                   	ret    

00100119 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void)
{
  100119:	f3 0f 1e fb          	endbr32 
  10011d:	55                   	push   %ebp
  10011e:	89 e5                	mov    %esp,%ebp
  100120:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile(
  100123:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100126:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100129:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10012c:	8c 55 f0             	mov    %ss,-0x10(%ebp)
        "mov %%cs, %0;"
        "mov %%ds, %1;"
        "mov %%es, %2;"
        "mov %%ss, %3;"
        : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100133:	83 e0 03             	and    $0x3,%eax
  100136:	89 c2                	mov    %eax,%edx
  100138:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10013d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100141:	89 44 24 04          	mov    %eax,0x4(%esp)
  100145:	c7 04 24 61 37 10 00 	movl   $0x103761,(%esp)
  10014c:	e8 52 01 00 00       	call   1002a3 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	89 c2                	mov    %eax,%edx
  100157:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10015c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100160:	89 44 24 04          	mov    %eax,0x4(%esp)
  100164:	c7 04 24 6f 37 10 00 	movl   $0x10376f,(%esp)
  10016b:	e8 33 01 00 00       	call   1002a3 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100170:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100174:	89 c2                	mov    %eax,%edx
  100176:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10017b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100183:	c7 04 24 7d 37 10 00 	movl   $0x10377d,(%esp)
  10018a:	e8 14 01 00 00       	call   1002a3 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10018f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100193:	89 c2                	mov    %eax,%edx
  100195:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10019a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a2:	c7 04 24 8b 37 10 00 	movl   $0x10378b,(%esp)
  1001a9:	e8 f5 00 00 00       	call   1002a3 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001ae:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001b2:	89 c2                	mov    %eax,%edx
  1001b4:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 99 37 10 00 	movl   $0x103799,(%esp)
  1001c8:	e8 d6 00 00 00       	call   1002a3 <cprintf>
    round++;
  1001cd:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001d2:	40                   	inc    %eax
  1001d3:	a3 20 0a 11 00       	mov    %eax,0x110a20
}
  1001d8:	90                   	nop
  1001d9:	c9                   	leave  
  1001da:	c3                   	ret    

001001db <lab1_switch_to_user>:

static void
lab1_switch_to_user(void)
{
  1001db:	f3 0f 1e fb          	endbr32 
  1001df:	55                   	push   %ebp
  1001e0:	89 e5                	mov    %esp,%ebp
  1001e2:	83 ec 18             	sub    $0x18,%esp
    // LAB1 CHALLENGE 1 : TODO
    cprintf("1");
  1001e5:	c7 04 24 a7 37 10 00 	movl   $0x1037a7,(%esp)
  1001ec:	e8 b2 00 00 00       	call   1002a3 <cprintf>
    asm volatile(
  1001f1:	83 ec 08             	sub    $0x8,%esp
  1001f4:	cd 78                	int    $0x78
  1001f6:	89 ec                	mov    %ebp,%esp
        "sub $0x8, %%esp \n"
        "int %0 \n"
        "movl %%ebp, %%esp" ::"i"(T_SWITCH_TOU));
}
  1001f8:	90                   	nop
  1001f9:	c9                   	leave  
  1001fa:	c3                   	ret    

001001fb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void)
{
  1001fb:	f3 0f 1e fb          	endbr32 
  1001ff:	55                   	push   %ebp
  100200:	89 e5                	mov    %esp,%ebp
    // LAB1 CHALLENGE 1 :  TODO
    asm volatile(
  100202:	cd 79                	int    $0x79
  100204:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp" ::"i"(T_SWITCH_TOK));
}
  100206:	90                   	nop
  100207:	5d                   	pop    %ebp
  100208:	c3                   	ret    

00100209 <lab1_switch_test>:

static void
lab1_switch_test(void)
{
  100209:	f3 0f 1e fb          	endbr32 
  10020d:	55                   	push   %ebp
  10020e:	89 e5                	mov    %esp,%ebp
  100210:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100213:	e8 01 ff ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100218:	c7 04 24 ac 37 10 00 	movl   $0x1037ac,(%esp)
  10021f:	e8 7f 00 00 00       	call   1002a3 <cprintf>
    lab1_switch_to_user();
  100224:	e8 b2 ff ff ff       	call   1001db <lab1_switch_to_user>
    lab1_print_cur_status();
  100229:	e8 eb fe ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10022e:	c7 04 24 cc 37 10 00 	movl   $0x1037cc,(%esp)
  100235:	e8 69 00 00 00       	call   1002a3 <cprintf>
    lab1_switch_to_kernel();
  10023a:	e8 bc ff ff ff       	call   1001fb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10023f:	e8 d5 fe ff ff       	call   100119 <lab1_print_cur_status>
}
  100244:	90                   	nop
  100245:	c9                   	leave  
  100246:	c3                   	ret    

00100247 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100247:	f3 0f 1e fb          	endbr32 
  10024b:	55                   	push   %ebp
  10024c:	89 e5                	mov    %esp,%ebp
  10024e:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100251:	8b 45 08             	mov    0x8(%ebp),%eax
  100254:	89 04 24             	mov    %eax,(%esp)
  100257:	e8 3d 14 00 00       	call   101699 <cons_putc>
    (*cnt) ++;
  10025c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10025f:	8b 00                	mov    (%eax),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	8b 45 0c             	mov    0xc(%ebp),%eax
  100267:	89 10                	mov    %edx,(%eax)
}
  100269:	90                   	nop
  10026a:	c9                   	leave  
  10026b:	c3                   	ret    

0010026c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10026c:	f3 0f 1e fb          	endbr32 
  100270:	55                   	push   %ebp
  100271:	89 e5                	mov    %esp,%ebp
  100273:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100276:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10027d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100280:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100284:	8b 45 08             	mov    0x8(%ebp),%eax
  100287:	89 44 24 08          	mov    %eax,0x8(%esp)
  10028b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10028e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100292:	c7 04 24 47 02 10 00 	movl   $0x100247,(%esp)
  100299:	e8 db 2f 00 00       	call   103279 <vprintfmt>
    return cnt;
  10029e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002a1:	c9                   	leave  
  1002a2:	c3                   	ret    

001002a3 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002a3:	f3 0f 1e fb          	endbr32 
  1002a7:	55                   	push   %ebp
  1002a8:	89 e5                	mov    %esp,%ebp
  1002aa:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002ad:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1002bd:	89 04 24             	mov    %eax,(%esp)
  1002c0:	e8 a7 ff ff ff       	call   10026c <vcprintf>
  1002c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002cb:	c9                   	leave  
  1002cc:	c3                   	ret    

001002cd <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002cd:	f3 0f 1e fb          	endbr32 
  1002d1:	55                   	push   %ebp
  1002d2:	89 e5                	mov    %esp,%ebp
  1002d4:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002da:	89 04 24             	mov    %eax,(%esp)
  1002dd:	e8 b7 13 00 00       	call   101699 <cons_putc>
}
  1002e2:	90                   	nop
  1002e3:	c9                   	leave  
  1002e4:	c3                   	ret    

001002e5 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002e5:	f3 0f 1e fb          	endbr32 
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002f6:	eb 13                	jmp    10030b <cputs+0x26>
        cputch(c, &cnt);
  1002f8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002fc:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002ff:	89 54 24 04          	mov    %edx,0x4(%esp)
  100303:	89 04 24             	mov    %eax,(%esp)
  100306:	e8 3c ff ff ff       	call   100247 <cputch>
    while ((c = *str ++) != '\0') {
  10030b:	8b 45 08             	mov    0x8(%ebp),%eax
  10030e:	8d 50 01             	lea    0x1(%eax),%edx
  100311:	89 55 08             	mov    %edx,0x8(%ebp)
  100314:	0f b6 00             	movzbl (%eax),%eax
  100317:	88 45 f7             	mov    %al,-0x9(%ebp)
  10031a:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10031e:	75 d8                	jne    1002f8 <cputs+0x13>
    }
    cputch('\n', &cnt);
  100320:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100323:	89 44 24 04          	mov    %eax,0x4(%esp)
  100327:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10032e:	e8 14 ff ff ff       	call   100247 <cputch>
    return cnt;
  100333:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100338:	f3 0f 1e fb          	endbr32 
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100342:	90                   	nop
  100343:	e8 7f 13 00 00       	call   1016c7 <cons_getc>
  100348:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10034b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10034f:	74 f2                	je     100343 <getchar+0xb>
        /* do nothing */;
    return c;
  100351:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100354:	c9                   	leave  
  100355:	c3                   	ret    

00100356 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100356:	f3 0f 1e fb          	endbr32 
  10035a:	55                   	push   %ebp
  10035b:	89 e5                	mov    %esp,%ebp
  10035d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100360:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100364:	74 13                	je     100379 <readline+0x23>
        cprintf("%s", prompt);
  100366:	8b 45 08             	mov    0x8(%ebp),%eax
  100369:	89 44 24 04          	mov    %eax,0x4(%esp)
  10036d:	c7 04 24 eb 37 10 00 	movl   $0x1037eb,(%esp)
  100374:	e8 2a ff ff ff       	call   1002a3 <cprintf>
    }
    int i = 0, c;
  100379:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100380:	e8 b3 ff ff ff       	call   100338 <getchar>
  100385:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100388:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10038c:	79 07                	jns    100395 <readline+0x3f>
            return NULL;
  10038e:	b8 00 00 00 00       	mov    $0x0,%eax
  100393:	eb 78                	jmp    10040d <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100395:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100399:	7e 28                	jle    1003c3 <readline+0x6d>
  10039b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  1003a2:	7f 1f                	jg     1003c3 <readline+0x6d>
            cputchar(c);
  1003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003a7:	89 04 24             	mov    %eax,(%esp)
  1003aa:	e8 1e ff ff ff       	call   1002cd <cputchar>
            buf[i ++] = c;
  1003af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003b2:	8d 50 01             	lea    0x1(%eax),%edx
  1003b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003bb:	88 90 40 0a 11 00    	mov    %dl,0x110a40(%eax)
  1003c1:	eb 45                	jmp    100408 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003c3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003c7:	75 16                	jne    1003df <readline+0x89>
  1003c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003cd:	7e 10                	jle    1003df <readline+0x89>
            cputchar(c);
  1003cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003d2:	89 04 24             	mov    %eax,(%esp)
  1003d5:	e8 f3 fe ff ff       	call   1002cd <cputchar>
            i --;
  1003da:	ff 4d f4             	decl   -0xc(%ebp)
  1003dd:	eb 29                	jmp    100408 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003df:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003e3:	74 06                	je     1003eb <readline+0x95>
  1003e5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003e9:	75 95                	jne    100380 <readline+0x2a>
            cputchar(c);
  1003eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003ee:	89 04 24             	mov    %eax,(%esp)
  1003f1:	e8 d7 fe ff ff       	call   1002cd <cputchar>
            buf[i] = '\0';
  1003f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003f9:	05 40 0a 11 00       	add    $0x110a40,%eax
  1003fe:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100401:	b8 40 0a 11 00       	mov    $0x110a40,%eax
  100406:	eb 05                	jmp    10040d <readline+0xb7>
        c = getchar();
  100408:	e9 73 ff ff ff       	jmp    100380 <readline+0x2a>
        }
    }
}
  10040d:	c9                   	leave  
  10040e:	c3                   	ret    

0010040f <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  10040f:	f3 0f 1e fb          	endbr32 
  100413:	55                   	push   %ebp
  100414:	89 e5                	mov    %esp,%ebp
  100416:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100419:	a1 40 0e 11 00       	mov    0x110e40,%eax
  10041e:	85 c0                	test   %eax,%eax
  100420:	75 5b                	jne    10047d <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100422:	c7 05 40 0e 11 00 01 	movl   $0x1,0x110e40
  100429:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10042c:	8d 45 14             	lea    0x14(%ebp),%eax
  10042f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100432:	8b 45 0c             	mov    0xc(%ebp),%eax
  100435:	89 44 24 08          	mov    %eax,0x8(%esp)
  100439:	8b 45 08             	mov    0x8(%ebp),%eax
  10043c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100440:	c7 04 24 ee 37 10 00 	movl   $0x1037ee,(%esp)
  100447:	e8 57 fe ff ff       	call   1002a3 <cprintf>
    vcprintf(fmt, ap);
  10044c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10044f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100453:	8b 45 10             	mov    0x10(%ebp),%eax
  100456:	89 04 24             	mov    %eax,(%esp)
  100459:	e8 0e fe ff ff       	call   10026c <vcprintf>
    cprintf("\n");
  10045e:	c7 04 24 0a 38 10 00 	movl   $0x10380a,(%esp)
  100465:	e8 39 fe ff ff       	call   1002a3 <cprintf>
    
    cprintf("stack trackback:\n");
  10046a:	c7 04 24 0c 38 10 00 	movl   $0x10380c,(%esp)
  100471:	e8 2d fe ff ff       	call   1002a3 <cprintf>
    print_stackframe();
  100476:	e8 3d 06 00 00       	call   100ab8 <print_stackframe>
  10047b:	eb 01                	jmp    10047e <__panic+0x6f>
        goto panic_dead;
  10047d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10047e:	e8 92 14 00 00       	call   101915 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100483:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10048a:	e8 6f 08 00 00       	call   100cfe <kmonitor>
  10048f:	eb f2                	jmp    100483 <__panic+0x74>

00100491 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100491:	f3 0f 1e fb          	endbr32 
  100495:	55                   	push   %ebp
  100496:	89 e5                	mov    %esp,%ebp
  100498:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10049b:	8d 45 14             	lea    0x14(%ebp),%eax
  10049e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  1004a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004af:	c7 04 24 1e 38 10 00 	movl   $0x10381e,(%esp)
  1004b6:	e8 e8 fd ff ff       	call   1002a3 <cprintf>
    vcprintf(fmt, ap);
  1004bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004c2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c5:	89 04 24             	mov    %eax,(%esp)
  1004c8:	e8 9f fd ff ff       	call   10026c <vcprintf>
    cprintf("\n");
  1004cd:	c7 04 24 0a 38 10 00 	movl   $0x10380a,(%esp)
  1004d4:	e8 ca fd ff ff       	call   1002a3 <cprintf>
    va_end(ap);
}
  1004d9:	90                   	nop
  1004da:	c9                   	leave  
  1004db:	c3                   	ret    

001004dc <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004dc:	f3 0f 1e fb          	endbr32 
  1004e0:	55                   	push   %ebp
  1004e1:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004e3:	a1 40 0e 11 00       	mov    0x110e40,%eax
}
  1004e8:	5d                   	pop    %ebp
  1004e9:	c3                   	ret    

001004ea <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004ea:	f3 0f 1e fb          	endbr32 
  1004ee:	55                   	push   %ebp
  1004ef:	89 e5                	mov    %esp,%ebp
  1004f1:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f7:	8b 00                	mov    (%eax),%eax
  1004f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004fc:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ff:	8b 00                	mov    (%eax),%eax
  100501:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100504:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10050b:	e9 ca 00 00 00       	jmp    1005da <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100510:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100513:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100516:	01 d0                	add    %edx,%eax
  100518:	89 c2                	mov    %eax,%edx
  10051a:	c1 ea 1f             	shr    $0x1f,%edx
  10051d:	01 d0                	add    %edx,%eax
  10051f:	d1 f8                	sar    %eax
  100521:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100527:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10052a:	eb 03                	jmp    10052f <stab_binsearch+0x45>
            m --;
  10052c:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10052f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100532:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100535:	7c 1f                	jl     100556 <stab_binsearch+0x6c>
  100537:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10053a:	89 d0                	mov    %edx,%eax
  10053c:	01 c0                	add    %eax,%eax
  10053e:	01 d0                	add    %edx,%eax
  100540:	c1 e0 02             	shl    $0x2,%eax
  100543:	89 c2                	mov    %eax,%edx
  100545:	8b 45 08             	mov    0x8(%ebp),%eax
  100548:	01 d0                	add    %edx,%eax
  10054a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10054e:	0f b6 c0             	movzbl %al,%eax
  100551:	39 45 14             	cmp    %eax,0x14(%ebp)
  100554:	75 d6                	jne    10052c <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100559:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10055c:	7d 09                	jge    100567 <stab_binsearch+0x7d>
            l = true_m + 1;
  10055e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100561:	40                   	inc    %eax
  100562:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100565:	eb 73                	jmp    1005da <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100567:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10056e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100571:	89 d0                	mov    %edx,%eax
  100573:	01 c0                	add    %eax,%eax
  100575:	01 d0                	add    %edx,%eax
  100577:	c1 e0 02             	shl    $0x2,%eax
  10057a:	89 c2                	mov    %eax,%edx
  10057c:	8b 45 08             	mov    0x8(%ebp),%eax
  10057f:	01 d0                	add    %edx,%eax
  100581:	8b 40 08             	mov    0x8(%eax),%eax
  100584:	39 45 18             	cmp    %eax,0x18(%ebp)
  100587:	76 11                	jbe    10059a <stab_binsearch+0xb0>
            *region_left = m;
  100589:	8b 45 0c             	mov    0xc(%ebp),%eax
  10058c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058f:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100591:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100594:	40                   	inc    %eax
  100595:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100598:	eb 40                	jmp    1005da <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  10059a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10059d:	89 d0                	mov    %edx,%eax
  10059f:	01 c0                	add    %eax,%eax
  1005a1:	01 d0                	add    %edx,%eax
  1005a3:	c1 e0 02             	shl    $0x2,%eax
  1005a6:	89 c2                	mov    %eax,%edx
  1005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ab:	01 d0                	add    %edx,%eax
  1005ad:	8b 40 08             	mov    0x8(%eax),%eax
  1005b0:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005b3:	73 14                	jae    1005c9 <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1005be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005c3:	48                   	dec    %eax
  1005c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005c7:	eb 11                	jmp    1005da <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005cf:	89 10                	mov    %edx,(%eax)
            l = m;
  1005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005d7:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005e0:	0f 8e 2a ff ff ff    	jle    100510 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005ea:	75 0f                	jne    1005fb <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  1005ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ef:	8b 00                	mov    (%eax),%eax
  1005f1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1005f7:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005f9:	eb 3e                	jmp    100639 <stab_binsearch+0x14f>
        l = *region_right;
  1005fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1005fe:	8b 00                	mov    (%eax),%eax
  100600:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100603:	eb 03                	jmp    100608 <stab_binsearch+0x11e>
  100605:	ff 4d fc             	decl   -0x4(%ebp)
  100608:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060b:	8b 00                	mov    (%eax),%eax
  10060d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100610:	7e 1f                	jle    100631 <stab_binsearch+0x147>
  100612:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100615:	89 d0                	mov    %edx,%eax
  100617:	01 c0                	add    %eax,%eax
  100619:	01 d0                	add    %edx,%eax
  10061b:	c1 e0 02             	shl    $0x2,%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	8b 45 08             	mov    0x8(%ebp),%eax
  100623:	01 d0                	add    %edx,%eax
  100625:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100629:	0f b6 c0             	movzbl %al,%eax
  10062c:	39 45 14             	cmp    %eax,0x14(%ebp)
  10062f:	75 d4                	jne    100605 <stab_binsearch+0x11b>
        *region_left = l;
  100631:	8b 45 0c             	mov    0xc(%ebp),%eax
  100634:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100637:	89 10                	mov    %edx,(%eax)
}
  100639:	90                   	nop
  10063a:	c9                   	leave  
  10063b:	c3                   	ret    

0010063c <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10063c:	f3 0f 1e fb          	endbr32 
  100640:	55                   	push   %ebp
  100641:	89 e5                	mov    %esp,%ebp
  100643:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100646:	8b 45 0c             	mov    0xc(%ebp),%eax
  100649:	c7 00 3c 38 10 00    	movl   $0x10383c,(%eax)
    info->eip_line = 0;
  10064f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100652:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100659:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065c:	c7 40 08 3c 38 10 00 	movl   $0x10383c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100663:	8b 45 0c             	mov    0xc(%ebp),%eax
  100666:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10066d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100670:	8b 55 08             	mov    0x8(%ebp),%edx
  100673:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100676:	8b 45 0c             	mov    0xc(%ebp),%eax
  100679:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100680:	c7 45 f4 8c 40 10 00 	movl   $0x10408c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100687:	c7 45 f0 90 cf 10 00 	movl   $0x10cf90,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10068e:	c7 45 ec 91 cf 10 00 	movl   $0x10cf91,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100695:	c7 45 e8 ce f0 10 00 	movl   $0x10f0ce,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10069c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10069f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1006a2:	76 0b                	jbe    1006af <debuginfo_eip+0x73>
  1006a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006a7:	48                   	dec    %eax
  1006a8:	0f b6 00             	movzbl (%eax),%eax
  1006ab:	84 c0                	test   %al,%al
  1006ad:	74 0a                	je     1006b9 <debuginfo_eip+0x7d>
        return -1;
  1006af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006b4:	e9 ab 02 00 00       	jmp    100964 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006c3:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006c6:	c1 f8 02             	sar    $0x2,%eax
  1006c9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006cf:	48                   	dec    %eax
  1006d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d6:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006da:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006e1:	00 
  1006e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f3:	89 04 24             	mov    %eax,(%esp)
  1006f6:	e8 ef fd ff ff       	call   1004ea <stab_binsearch>
    if (lfile == 0)
  1006fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006fe:	85 c0                	test   %eax,%eax
  100700:	75 0a                	jne    10070c <debuginfo_eip+0xd0>
        return -1;
  100702:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100707:	e9 58 02 00 00       	jmp    100964 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10070c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10070f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100715:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100718:	8b 45 08             	mov    0x8(%ebp),%eax
  10071b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10071f:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100726:	00 
  100727:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10072a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10072e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100731:	89 44 24 04          	mov    %eax,0x4(%esp)
  100735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100738:	89 04 24             	mov    %eax,(%esp)
  10073b:	e8 aa fd ff ff       	call   1004ea <stab_binsearch>

    if (lfun <= rfun) {
  100740:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100743:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100746:	39 c2                	cmp    %eax,%edx
  100748:	7f 78                	jg     1007c2 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10074a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074d:	89 c2                	mov    %eax,%edx
  10074f:	89 d0                	mov    %edx,%eax
  100751:	01 c0                	add    %eax,%eax
  100753:	01 d0                	add    %edx,%eax
  100755:	c1 e0 02             	shl    $0x2,%eax
  100758:	89 c2                	mov    %eax,%edx
  10075a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075d:	01 d0                	add    %edx,%eax
  10075f:	8b 10                	mov    (%eax),%edx
  100761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100764:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100767:	39 c2                	cmp    %eax,%edx
  100769:	73 22                	jae    10078d <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10076b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10076e:	89 c2                	mov    %eax,%edx
  100770:	89 d0                	mov    %edx,%eax
  100772:	01 c0                	add    %eax,%eax
  100774:	01 d0                	add    %edx,%eax
  100776:	c1 e0 02             	shl    $0x2,%eax
  100779:	89 c2                	mov    %eax,%edx
  10077b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10077e:	01 d0                	add    %edx,%eax
  100780:	8b 10                	mov    (%eax),%edx
  100782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100785:	01 c2                	add    %eax,%edx
  100787:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10078d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	89 d0                	mov    %edx,%eax
  100794:	01 c0                	add    %eax,%eax
  100796:	01 d0                	add    %edx,%eax
  100798:	c1 e0 02             	shl    $0x2,%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a0:	01 d0                	add    %edx,%eax
  1007a2:	8b 50 08             	mov    0x8(%eax),%edx
  1007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a8:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1007ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ae:	8b 40 10             	mov    0x10(%eax),%eax
  1007b1:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007c0:	eb 15                	jmp    1007d7 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c5:	8b 55 08             	mov    0x8(%ebp),%edx
  1007c8:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007da:	8b 40 08             	mov    0x8(%eax),%eax
  1007dd:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007e4:	00 
  1007e5:	89 04 24             	mov    %eax,(%esp)
  1007e8:	e8 94 25 00 00       	call   102d81 <strfind>
  1007ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007f0:	8b 52 08             	mov    0x8(%edx),%edx
  1007f3:	29 d0                	sub    %edx,%eax
  1007f5:	89 c2                	mov    %eax,%edx
  1007f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007fa:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100800:	89 44 24 10          	mov    %eax,0x10(%esp)
  100804:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10080b:	00 
  10080c:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10080f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100813:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100816:	89 44 24 04          	mov    %eax,0x4(%esp)
  10081a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10081d:	89 04 24             	mov    %eax,(%esp)
  100820:	e8 c5 fc ff ff       	call   1004ea <stab_binsearch>
    if (lline <= rline) {
  100825:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10082b:	39 c2                	cmp    %eax,%edx
  10082d:	7f 23                	jg     100852 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  10082f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100832:	89 c2                	mov    %eax,%edx
  100834:	89 d0                	mov    %edx,%eax
  100836:	01 c0                	add    %eax,%eax
  100838:	01 d0                	add    %edx,%eax
  10083a:	c1 e0 02             	shl    $0x2,%eax
  10083d:	89 c2                	mov    %eax,%edx
  10083f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100842:	01 d0                	add    %edx,%eax
  100844:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100848:	89 c2                	mov    %eax,%edx
  10084a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10084d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100850:	eb 11                	jmp    100863 <debuginfo_eip+0x227>
        return -1;
  100852:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100857:	e9 08 01 00 00       	jmp    100964 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10085c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085f:	48                   	dec    %eax
  100860:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100863:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100869:	39 c2                	cmp    %eax,%edx
  10086b:	7c 56                	jl     1008c3 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  10086d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100870:	89 c2                	mov    %eax,%edx
  100872:	89 d0                	mov    %edx,%eax
  100874:	01 c0                	add    %eax,%eax
  100876:	01 d0                	add    %edx,%eax
  100878:	c1 e0 02             	shl    $0x2,%eax
  10087b:	89 c2                	mov    %eax,%edx
  10087d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100880:	01 d0                	add    %edx,%eax
  100882:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100886:	3c 84                	cmp    $0x84,%al
  100888:	74 39                	je     1008c3 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10088a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10088d:	89 c2                	mov    %eax,%edx
  10088f:	89 d0                	mov    %edx,%eax
  100891:	01 c0                	add    %eax,%eax
  100893:	01 d0                	add    %edx,%eax
  100895:	c1 e0 02             	shl    $0x2,%eax
  100898:	89 c2                	mov    %eax,%edx
  10089a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10089d:	01 d0                	add    %edx,%eax
  10089f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008a3:	3c 64                	cmp    $0x64,%al
  1008a5:	75 b5                	jne    10085c <debuginfo_eip+0x220>
  1008a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008aa:	89 c2                	mov    %eax,%edx
  1008ac:	89 d0                	mov    %edx,%eax
  1008ae:	01 c0                	add    %eax,%eax
  1008b0:	01 d0                	add    %edx,%eax
  1008b2:	c1 e0 02             	shl    $0x2,%eax
  1008b5:	89 c2                	mov    %eax,%edx
  1008b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ba:	01 d0                	add    %edx,%eax
  1008bc:	8b 40 08             	mov    0x8(%eax),%eax
  1008bf:	85 c0                	test   %eax,%eax
  1008c1:	74 99                	je     10085c <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008c9:	39 c2                	cmp    %eax,%edx
  1008cb:	7c 42                	jl     10090f <debuginfo_eip+0x2d3>
  1008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d0:	89 c2                	mov    %eax,%edx
  1008d2:	89 d0                	mov    %edx,%eax
  1008d4:	01 c0                	add    %eax,%eax
  1008d6:	01 d0                	add    %edx,%eax
  1008d8:	c1 e0 02             	shl    $0x2,%eax
  1008db:	89 c2                	mov    %eax,%edx
  1008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e0:	01 d0                	add    %edx,%eax
  1008e2:	8b 10                	mov    (%eax),%edx
  1008e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008e7:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008ea:	39 c2                	cmp    %eax,%edx
  1008ec:	73 21                	jae    10090f <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f1:	89 c2                	mov    %eax,%edx
  1008f3:	89 d0                	mov    %edx,%eax
  1008f5:	01 c0                	add    %eax,%eax
  1008f7:	01 d0                	add    %edx,%eax
  1008f9:	c1 e0 02             	shl    $0x2,%eax
  1008fc:	89 c2                	mov    %eax,%edx
  1008fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100901:	01 d0                	add    %edx,%eax
  100903:	8b 10                	mov    (%eax),%edx
  100905:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100908:	01 c2                	add    %eax,%edx
  10090a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10090d:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10090f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100912:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100915:	39 c2                	cmp    %eax,%edx
  100917:	7d 46                	jge    10095f <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  100919:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10091c:	40                   	inc    %eax
  10091d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100920:	eb 16                	jmp    100938 <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100922:	8b 45 0c             	mov    0xc(%ebp),%eax
  100925:	8b 40 14             	mov    0x14(%eax),%eax
  100928:	8d 50 01             	lea    0x1(%eax),%edx
  10092b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10092e:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100931:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100934:	40                   	inc    %eax
  100935:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100938:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10093b:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10093e:	39 c2                	cmp    %eax,%edx
  100940:	7d 1d                	jge    10095f <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100945:	89 c2                	mov    %eax,%edx
  100947:	89 d0                	mov    %edx,%eax
  100949:	01 c0                	add    %eax,%eax
  10094b:	01 d0                	add    %edx,%eax
  10094d:	c1 e0 02             	shl    $0x2,%eax
  100950:	89 c2                	mov    %eax,%edx
  100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100955:	01 d0                	add    %edx,%eax
  100957:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10095b:	3c a0                	cmp    $0xa0,%al
  10095d:	74 c3                	je     100922 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  10095f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100964:	c9                   	leave  
  100965:	c3                   	ret    

00100966 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100966:	f3 0f 1e fb          	endbr32 
  10096a:	55                   	push   %ebp
  10096b:	89 e5                	mov    %esp,%ebp
  10096d:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100970:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  100977:	e8 27 f9 ff ff       	call   1002a3 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10097c:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100983:	00 
  100984:	c7 04 24 5f 38 10 00 	movl   $0x10385f,(%esp)
  10098b:	e8 13 f9 ff ff       	call   1002a3 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100990:	c7 44 24 04 31 37 10 	movl   $0x103731,0x4(%esp)
  100997:	00 
  100998:	c7 04 24 77 38 10 00 	movl   $0x103877,(%esp)
  10099f:	e8 ff f8 ff ff       	call   1002a3 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009a4:	c7 44 24 04 16 0a 11 	movl   $0x110a16,0x4(%esp)
  1009ab:	00 
  1009ac:	c7 04 24 8f 38 10 00 	movl   $0x10388f,(%esp)
  1009b3:	e8 eb f8 ff ff       	call   1002a3 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009b8:	c7 44 24 04 80 1d 11 	movl   $0x111d80,0x4(%esp)
  1009bf:	00 
  1009c0:	c7 04 24 a7 38 10 00 	movl   $0x1038a7,(%esp)
  1009c7:	e8 d7 f8 ff ff       	call   1002a3 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009cc:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  1009d1:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009d6:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009db:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009e1:	85 c0                	test   %eax,%eax
  1009e3:	0f 48 c2             	cmovs  %edx,%eax
  1009e6:	c1 f8 0a             	sar    $0xa,%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 c0 38 10 00 	movl   $0x1038c0,(%esp)
  1009f4:	e8 aa f8 ff ff       	call   1002a3 <cprintf>
}
  1009f9:	90                   	nop
  1009fa:	c9                   	leave  
  1009fb:	c3                   	ret    

001009fc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009fc:	f3 0f 1e fb          	endbr32 
  100a00:	55                   	push   %ebp
  100a01:	89 e5                	mov    %esp,%ebp
  100a03:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100a09:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a10:	8b 45 08             	mov    0x8(%ebp),%eax
  100a13:	89 04 24             	mov    %eax,(%esp)
  100a16:	e8 21 fc ff ff       	call   10063c <debuginfo_eip>
  100a1b:	85 c0                	test   %eax,%eax
  100a1d:	74 15                	je     100a34 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a22:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a26:	c7 04 24 ea 38 10 00 	movl   $0x1038ea,(%esp)
  100a2d:	e8 71 f8 ff ff       	call   1002a3 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a32:	eb 6c                	jmp    100aa0 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a3b:	eb 1b                	jmp    100a58 <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a43:	01 d0                	add    %edx,%eax
  100a45:	0f b6 10             	movzbl (%eax),%edx
  100a48:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a51:	01 c8                	add    %ecx,%eax
  100a53:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a55:	ff 45 f4             	incl   -0xc(%ebp)
  100a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a5b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a5e:	7c dd                	jl     100a3d <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a60:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a69:	01 d0                	add    %edx,%eax
  100a6b:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a71:	8b 55 08             	mov    0x8(%ebp),%edx
  100a74:	89 d1                	mov    %edx,%ecx
  100a76:	29 c1                	sub    %eax,%ecx
  100a78:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a7e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a82:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a88:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a8c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a90:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a94:	c7 04 24 06 39 10 00 	movl   $0x103906,(%esp)
  100a9b:	e8 03 f8 ff ff       	call   1002a3 <cprintf>
}
  100aa0:	90                   	nop
  100aa1:	c9                   	leave  
  100aa2:	c3                   	ret    

00100aa3 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100aa3:	f3 0f 1e fb          	endbr32 
  100aa7:	55                   	push   %ebp
  100aa8:	89 e5                	mov    %esp,%ebp
  100aaa:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100aad:	8b 45 04             	mov    0x4(%ebp),%eax
  100ab0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100ab3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100ab6:	c9                   	leave  
  100ab7:	c3                   	ret    

00100ab8 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100ab8:	f3 0f 1e fb          	endbr32 
  100abc:	55                   	push   %ebp
  100abd:	89 e5                	mov    %esp,%ebp
  100abf:	53                   	push   %ebx
  100ac0:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ac3:	89 e8                	mov    %ebp,%eax
  100ac5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100ac8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp();
  100acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip = read_eip();
  100ace:	e8 d0 ff ff ff       	call   100aa3 <read_eip>
  100ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
     for(int i =0;i<=STACKFRAME_DEPTH;i++)
  100ad6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100add:	e9 94 00 00 00       	jmp    100b76 <print_stackframe+0xbe>
     {
        if(ebp==0)
  100ae2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ae6:	0f 84 96 00 00 00    	je     100b82 <print_stackframe+0xca>
        {
            break;
        }    
        cprintf("ebp:0x%08x eip:0x%08x",ebp,eip);
  100aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aef:	89 44 24 08          	mov    %eax,0x8(%esp)
  100af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100afa:	c7 04 24 18 39 10 00 	movl   $0x103918,(%esp)
  100b01:	e8 9d f7 ff ff       	call   1002a3 <cprintf>
        uint32_t *argu;
        argu = (uint32_t)ebp +2;
  100b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b09:	83 c0 02             	add    $0x2,%eax
  100b0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x",argu[0],argu[1],argu[2],argu[3]);
  100b0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b12:	83 c0 0c             	add    $0xc,%eax
  100b15:	8b 18                	mov    (%eax),%ebx
  100b17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b1a:	83 c0 08             	add    $0x8,%eax
  100b1d:	8b 08                	mov    (%eax),%ecx
  100b1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b22:	83 c0 04             	add    $0x4,%eax
  100b25:	8b 10                	mov    (%eax),%edx
  100b27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b2a:	8b 00                	mov    (%eax),%eax
  100b2c:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100b30:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100b34:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b3c:	c7 04 24 30 39 10 00 	movl   $0x103930,(%esp)
  100b43:	e8 5b f7 ff ff       	call   1002a3 <cprintf>
        cprintf("\n");
  100b48:	c7 04 24 51 39 10 00 	movl   $0x103951,(%esp)
  100b4f:	e8 4f f7 ff ff       	call   1002a3 <cprintf>
        print_debuginfo(eip-1);
  100b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b57:	48                   	dec    %eax
  100b58:	89 04 24             	mov    %eax,(%esp)
  100b5b:	e8 9c fe ff ff       	call   1009fc <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b63:	83 c0 04             	add    $0x4,%eax
  100b66:	8b 00                	mov    (%eax),%eax
  100b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];      
  100b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b6e:	8b 00                	mov    (%eax),%eax
  100b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
     for(int i =0;i<=STACKFRAME_DEPTH;i++)
  100b73:	ff 45 ec             	incl   -0x14(%ebp)
  100b76:	83 7d ec 14          	cmpl   $0x14,-0x14(%ebp)
  100b7a:	0f 8e 62 ff ff ff    	jle    100ae2 <print_stackframe+0x2a>
     }
}
  100b80:	eb 01                	jmp    100b83 <print_stackframe+0xcb>
            break;
  100b82:	90                   	nop
}
  100b83:	90                   	nop
  100b84:	83 c4 44             	add    $0x44,%esp
  100b87:	5b                   	pop    %ebx
  100b88:	5d                   	pop    %ebp
  100b89:	c3                   	ret    

00100b8a <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b8a:	f3 0f 1e fb          	endbr32 
  100b8e:	55                   	push   %ebp
  100b8f:	89 e5                	mov    %esp,%ebp
  100b91:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b9b:	eb 0c                	jmp    100ba9 <parse+0x1f>
            *buf ++ = '\0';
  100b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba0:	8d 50 01             	lea    0x1(%eax),%edx
  100ba3:	89 55 08             	mov    %edx,0x8(%ebp)
  100ba6:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bac:	0f b6 00             	movzbl (%eax),%eax
  100baf:	84 c0                	test   %al,%al
  100bb1:	74 1d                	je     100bd0 <parse+0x46>
  100bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb6:	0f b6 00             	movzbl (%eax),%eax
  100bb9:	0f be c0             	movsbl %al,%eax
  100bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc0:	c7 04 24 d4 39 10 00 	movl   $0x1039d4,(%esp)
  100bc7:	e8 7f 21 00 00       	call   102d4b <strchr>
  100bcc:	85 c0                	test   %eax,%eax
  100bce:	75 cd                	jne    100b9d <parse+0x13>
        }
        if (*buf == '\0') {
  100bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd3:	0f b6 00             	movzbl (%eax),%eax
  100bd6:	84 c0                	test   %al,%al
  100bd8:	74 65                	je     100c3f <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bde:	75 14                	jne    100bf4 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100be0:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100be7:	00 
  100be8:	c7 04 24 d9 39 10 00 	movl   $0x1039d9,(%esp)
  100bef:	e8 af f6 ff ff       	call   1002a3 <cprintf>
        }
        argv[argc ++] = buf;
  100bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bf7:	8d 50 01             	lea    0x1(%eax),%edx
  100bfa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bfd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c07:	01 c2                	add    %eax,%edx
  100c09:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0c:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c0e:	eb 03                	jmp    100c13 <parse+0x89>
            buf ++;
  100c10:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c13:	8b 45 08             	mov    0x8(%ebp),%eax
  100c16:	0f b6 00             	movzbl (%eax),%eax
  100c19:	84 c0                	test   %al,%al
  100c1b:	74 8c                	je     100ba9 <parse+0x1f>
  100c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  100c20:	0f b6 00             	movzbl (%eax),%eax
  100c23:	0f be c0             	movsbl %al,%eax
  100c26:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c2a:	c7 04 24 d4 39 10 00 	movl   $0x1039d4,(%esp)
  100c31:	e8 15 21 00 00       	call   102d4b <strchr>
  100c36:	85 c0                	test   %eax,%eax
  100c38:	74 d6                	je     100c10 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c3a:	e9 6a ff ff ff       	jmp    100ba9 <parse+0x1f>
            break;
  100c3f:	90                   	nop
        }
    }
    return argc;
  100c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c43:	c9                   	leave  
  100c44:	c3                   	ret    

00100c45 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c45:	f3 0f 1e fb          	endbr32 
  100c49:	55                   	push   %ebp
  100c4a:	89 e5                	mov    %esp,%ebp
  100c4c:	53                   	push   %ebx
  100c4d:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c50:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c53:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c57:	8b 45 08             	mov    0x8(%ebp),%eax
  100c5a:	89 04 24             	mov    %eax,(%esp)
  100c5d:	e8 28 ff ff ff       	call   100b8a <parse>
  100c62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c69:	75 0a                	jne    100c75 <runcmd+0x30>
        return 0;
  100c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  100c70:	e9 83 00 00 00       	jmp    100cf8 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c7c:	eb 5a                	jmp    100cd8 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c7e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c84:	89 d0                	mov    %edx,%eax
  100c86:	01 c0                	add    %eax,%eax
  100c88:	01 d0                	add    %edx,%eax
  100c8a:	c1 e0 02             	shl    $0x2,%eax
  100c8d:	05 00 00 11 00       	add    $0x110000,%eax
  100c92:	8b 00                	mov    (%eax),%eax
  100c94:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c98:	89 04 24             	mov    %eax,(%esp)
  100c9b:	e8 07 20 00 00       	call   102ca7 <strcmp>
  100ca0:	85 c0                	test   %eax,%eax
  100ca2:	75 31                	jne    100cd5 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ca4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ca7:	89 d0                	mov    %edx,%eax
  100ca9:	01 c0                	add    %eax,%eax
  100cab:	01 d0                	add    %edx,%eax
  100cad:	c1 e0 02             	shl    $0x2,%eax
  100cb0:	05 08 00 11 00       	add    $0x110008,%eax
  100cb5:	8b 10                	mov    (%eax),%edx
  100cb7:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cba:	83 c0 04             	add    $0x4,%eax
  100cbd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100cc0:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100cc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cc6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cca:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cce:	89 1c 24             	mov    %ebx,(%esp)
  100cd1:	ff d2                	call   *%edx
  100cd3:	eb 23                	jmp    100cf8 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cd5:	ff 45 f4             	incl   -0xc(%ebp)
  100cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cdb:	83 f8 02             	cmp    $0x2,%eax
  100cde:	76 9e                	jbe    100c7e <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ce0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce7:	c7 04 24 f7 39 10 00 	movl   $0x1039f7,(%esp)
  100cee:	e8 b0 f5 ff ff       	call   1002a3 <cprintf>
    return 0;
  100cf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cf8:	83 c4 64             	add    $0x64,%esp
  100cfb:	5b                   	pop    %ebx
  100cfc:	5d                   	pop    %ebp
  100cfd:	c3                   	ret    

00100cfe <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cfe:	f3 0f 1e fb          	endbr32 
  100d02:	55                   	push   %ebp
  100d03:	89 e5                	mov    %esp,%ebp
  100d05:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d08:	c7 04 24 10 3a 10 00 	movl   $0x103a10,(%esp)
  100d0f:	e8 8f f5 ff ff       	call   1002a3 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d14:	c7 04 24 38 3a 10 00 	movl   $0x103a38,(%esp)
  100d1b:	e8 83 f5 ff ff       	call   1002a3 <cprintf>

    if (tf != NULL) {
  100d20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d24:	74 0b                	je     100d31 <kmonitor+0x33>
        print_trapframe(tf);
  100d26:	8b 45 08             	mov    0x8(%ebp),%eax
  100d29:	89 04 24             	mov    %eax,(%esp)
  100d2c:	e8 fa 0d 00 00       	call   101b2b <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d31:	c7 04 24 5d 3a 10 00 	movl   $0x103a5d,(%esp)
  100d38:	e8 19 f6 ff ff       	call   100356 <readline>
  100d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d44:	74 eb                	je     100d31 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d46:	8b 45 08             	mov    0x8(%ebp),%eax
  100d49:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d50:	89 04 24             	mov    %eax,(%esp)
  100d53:	e8 ed fe ff ff       	call   100c45 <runcmd>
  100d58:	85 c0                	test   %eax,%eax
  100d5a:	78 02                	js     100d5e <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d5c:	eb d3                	jmp    100d31 <kmonitor+0x33>
                break;
  100d5e:	90                   	nop
            }
        }
    }
}
  100d5f:	90                   	nop
  100d60:	c9                   	leave  
  100d61:	c3                   	ret    

00100d62 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d62:	f3 0f 1e fb          	endbr32 
  100d66:	55                   	push   %ebp
  100d67:	89 e5                	mov    %esp,%ebp
  100d69:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d73:	eb 3d                	jmp    100db2 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d78:	89 d0                	mov    %edx,%eax
  100d7a:	01 c0                	add    %eax,%eax
  100d7c:	01 d0                	add    %edx,%eax
  100d7e:	c1 e0 02             	shl    $0x2,%eax
  100d81:	05 04 00 11 00       	add    $0x110004,%eax
  100d86:	8b 08                	mov    (%eax),%ecx
  100d88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d8b:	89 d0                	mov    %edx,%eax
  100d8d:	01 c0                	add    %eax,%eax
  100d8f:	01 d0                	add    %edx,%eax
  100d91:	c1 e0 02             	shl    $0x2,%eax
  100d94:	05 00 00 11 00       	add    $0x110000,%eax
  100d99:	8b 00                	mov    (%eax),%eax
  100d9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100da3:	c7 04 24 61 3a 10 00 	movl   $0x103a61,(%esp)
  100daa:	e8 f4 f4 ff ff       	call   1002a3 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100daf:	ff 45 f4             	incl   -0xc(%ebp)
  100db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100db5:	83 f8 02             	cmp    $0x2,%eax
  100db8:	76 bb                	jbe    100d75 <mon_help+0x13>
    }
    return 0;
  100dba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dbf:	c9                   	leave  
  100dc0:	c3                   	ret    

00100dc1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100dc1:	f3 0f 1e fb          	endbr32 
  100dc5:	55                   	push   %ebp
  100dc6:	89 e5                	mov    %esp,%ebp
  100dc8:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100dcb:	e8 96 fb ff ff       	call   100966 <print_kerninfo>
    return 0;
  100dd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dd5:	c9                   	leave  
  100dd6:	c3                   	ret    

00100dd7 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100dd7:	f3 0f 1e fb          	endbr32 
  100ddb:	55                   	push   %ebp
  100ddc:	89 e5                	mov    %esp,%ebp
  100dde:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100de1:	e8 d2 fc ff ff       	call   100ab8 <print_stackframe>
    return 0;
  100de6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100deb:	c9                   	leave  
  100dec:	c3                   	ret    

00100ded <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100ded:	f3 0f 1e fb          	endbr32 
  100df1:	55                   	push   %ebp
  100df2:	89 e5                	mov    %esp,%ebp
  100df4:	83 ec 28             	sub    $0x28,%esp
  100df7:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dfd:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e01:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e05:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e09:	ee                   	out    %al,(%dx)
}
  100e0a:	90                   	nop
  100e0b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e11:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e15:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e19:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e1d:	ee                   	out    %al,(%dx)
}
  100e1e:	90                   	nop
  100e1f:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e25:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e29:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e2d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e31:	ee                   	out    %al,(%dx)
}
  100e32:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e33:	c7 05 08 19 11 00 00 	movl   $0x0,0x111908
  100e3a:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e3d:	c7 04 24 6a 3a 10 00 	movl   $0x103a6a,(%esp)
  100e44:	e8 5a f4 ff ff       	call   1002a3 <cprintf>
    pic_enable(IRQ_TIMER);
  100e49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e50:	e8 31 09 00 00       	call   101786 <pic_enable>
}
  100e55:	90                   	nop
  100e56:	c9                   	leave  
  100e57:	c3                   	ret    

00100e58 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e58:	f3 0f 1e fb          	endbr32 
  100e5c:	55                   	push   %ebp
  100e5d:	89 e5                	mov    %esp,%ebp
  100e5f:	83 ec 10             	sub    $0x10,%esp
  100e62:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e68:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e6c:	89 c2                	mov    %eax,%edx
  100e6e:	ec                   	in     (%dx),%al
  100e6f:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e72:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e78:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e7c:	89 c2                	mov    %eax,%edx
  100e7e:	ec                   	in     (%dx),%al
  100e7f:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e82:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e88:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e8c:	89 c2                	mov    %eax,%edx
  100e8e:	ec                   	in     (%dx),%al
  100e8f:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e92:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e98:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e9c:	89 c2                	mov    %eax,%edx
  100e9e:	ec                   	in     (%dx),%al
  100e9f:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ea2:	90                   	nop
  100ea3:	c9                   	leave  
  100ea4:	c3                   	ret    

00100ea5 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100ea5:	f3 0f 1e fb          	endbr32 
  100ea9:	55                   	push   %ebp
  100eaa:	89 e5                	mov    %esp,%ebp
  100eac:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100eaf:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb9:	0f b7 00             	movzwl (%eax),%eax
  100ebc:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec3:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecb:	0f b7 00             	movzwl (%eax),%eax
  100ece:	0f b7 c0             	movzwl %ax,%eax
  100ed1:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ed6:	74 12                	je     100eea <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100ed8:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100edf:	66 c7 05 66 0e 11 00 	movw   $0x3b4,0x110e66
  100ee6:	b4 03 
  100ee8:	eb 13                	jmp    100efd <cga_init+0x58>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100eea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eed:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ef1:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100ef4:	66 c7 05 66 0e 11 00 	movw   $0x3d4,0x110e66
  100efb:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100efd:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f04:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f08:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f0c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f10:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f14:	ee                   	out    %al,(%dx)
}
  100f15:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100f16:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f1d:	40                   	inc    %eax
  100f1e:	0f b7 c0             	movzwl %ax,%eax
  100f21:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f25:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f29:	89 c2                	mov    %eax,%edx
  100f2b:	ec                   	in     (%dx),%al
  100f2c:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f2f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f33:	0f b6 c0             	movzbl %al,%eax
  100f36:	c1 e0 08             	shl    $0x8,%eax
  100f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f3c:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f43:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f47:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f4b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f4f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f53:	ee                   	out    %al,(%dx)
}
  100f54:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f55:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f5c:	40                   	inc    %eax
  100f5d:	0f b7 c0             	movzwl %ax,%eax
  100f60:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f64:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f68:	89 c2                	mov    %eax,%edx
  100f6a:	ec                   	in     (%dx),%al
  100f6b:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f6e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f72:	0f b6 c0             	movzbl %al,%eax
  100f75:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f7b:	a3 60 0e 11 00       	mov    %eax,0x110e60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f83:	0f b7 c0             	movzwl %ax,%eax
  100f86:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
}
  100f8c:	90                   	nop
  100f8d:	c9                   	leave  
  100f8e:	c3                   	ret    

00100f8f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f8f:	f3 0f 1e fb          	endbr32 
  100f93:	55                   	push   %ebp
  100f94:	89 e5                	mov    %esp,%ebp
  100f96:	83 ec 48             	sub    $0x48,%esp
  100f99:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f9f:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fa3:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fa7:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fab:	ee                   	out    %al,(%dx)
}
  100fac:	90                   	nop
  100fad:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100fb3:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fb7:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fbb:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fbf:	ee                   	out    %al,(%dx)
}
  100fc0:	90                   	nop
  100fc1:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fc7:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fcb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fcf:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fd3:	ee                   	out    %al,(%dx)
}
  100fd4:	90                   	nop
  100fd5:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fdb:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fdf:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fe3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fe7:	ee                   	out    %al,(%dx)
}
  100fe8:	90                   	nop
  100fe9:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fef:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ff3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100ff7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100ffb:	ee                   	out    %al,(%dx)
}
  100ffc:	90                   	nop
  100ffd:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101003:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101007:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10100b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10100f:	ee                   	out    %al,(%dx)
}
  101010:	90                   	nop
  101011:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101017:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10101b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10101f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101023:	ee                   	out    %al,(%dx)
}
  101024:	90                   	nop
  101025:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10102b:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10102f:	89 c2                	mov    %eax,%edx
  101031:	ec                   	in     (%dx),%al
  101032:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101035:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101039:	3c ff                	cmp    $0xff,%al
  10103b:	0f 95 c0             	setne  %al
  10103e:	0f b6 c0             	movzbl %al,%eax
  101041:	a3 68 0e 11 00       	mov    %eax,0x110e68
  101046:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10104c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101050:	89 c2                	mov    %eax,%edx
  101052:	ec                   	in     (%dx),%al
  101053:	88 45 f1             	mov    %al,-0xf(%ebp)
  101056:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10105c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101060:	89 c2                	mov    %eax,%edx
  101062:	ec                   	in     (%dx),%al
  101063:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101066:	a1 68 0e 11 00       	mov    0x110e68,%eax
  10106b:	85 c0                	test   %eax,%eax
  10106d:	74 0c                	je     10107b <serial_init+0xec>
        pic_enable(IRQ_COM1);
  10106f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101076:	e8 0b 07 00 00       	call   101786 <pic_enable>
    }
}
  10107b:	90                   	nop
  10107c:	c9                   	leave  
  10107d:	c3                   	ret    

0010107e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10107e:	f3 0f 1e fb          	endbr32 
  101082:	55                   	push   %ebp
  101083:	89 e5                	mov    %esp,%ebp
  101085:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101088:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10108f:	eb 08                	jmp    101099 <lpt_putc_sub+0x1b>
        delay();
  101091:	e8 c2 fd ff ff       	call   100e58 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101096:	ff 45 fc             	incl   -0x4(%ebp)
  101099:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10109f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010a3:	89 c2                	mov    %eax,%edx
  1010a5:	ec                   	in     (%dx),%al
  1010a6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010a9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010ad:	84 c0                	test   %al,%al
  1010af:	78 09                	js     1010ba <lpt_putc_sub+0x3c>
  1010b1:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010b8:	7e d7                	jle    101091 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  1010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bd:	0f b6 c0             	movzbl %al,%eax
  1010c0:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010c6:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010c9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010cd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010d1:	ee                   	out    %al,(%dx)
}
  1010d2:	90                   	nop
  1010d3:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010d9:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010dd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010e1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010e5:	ee                   	out    %al,(%dx)
}
  1010e6:	90                   	nop
  1010e7:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010ed:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010f1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010f5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010f9:	ee                   	out    %al,(%dx)
}
  1010fa:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010fb:	90                   	nop
  1010fc:	c9                   	leave  
  1010fd:	c3                   	ret    

001010fe <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010fe:	f3 0f 1e fb          	endbr32 
  101102:	55                   	push   %ebp
  101103:	89 e5                	mov    %esp,%ebp
  101105:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101108:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10110c:	74 0d                	je     10111b <lpt_putc+0x1d>
        lpt_putc_sub(c);
  10110e:	8b 45 08             	mov    0x8(%ebp),%eax
  101111:	89 04 24             	mov    %eax,(%esp)
  101114:	e8 65 ff ff ff       	call   10107e <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101119:	eb 24                	jmp    10113f <lpt_putc+0x41>
        lpt_putc_sub('\b');
  10111b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101122:	e8 57 ff ff ff       	call   10107e <lpt_putc_sub>
        lpt_putc_sub(' ');
  101127:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10112e:	e8 4b ff ff ff       	call   10107e <lpt_putc_sub>
        lpt_putc_sub('\b');
  101133:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10113a:	e8 3f ff ff ff       	call   10107e <lpt_putc_sub>
}
  10113f:	90                   	nop
  101140:	c9                   	leave  
  101141:	c3                   	ret    

00101142 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101142:	f3 0f 1e fb          	endbr32 
  101146:	55                   	push   %ebp
  101147:	89 e5                	mov    %esp,%ebp
  101149:	53                   	push   %ebx
  10114a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10114d:	8b 45 08             	mov    0x8(%ebp),%eax
  101150:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101155:	85 c0                	test   %eax,%eax
  101157:	75 07                	jne    101160 <cga_putc+0x1e>
        c |= 0x0700;
  101159:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101160:	8b 45 08             	mov    0x8(%ebp),%eax
  101163:	0f b6 c0             	movzbl %al,%eax
  101166:	83 f8 0d             	cmp    $0xd,%eax
  101169:	74 72                	je     1011dd <cga_putc+0x9b>
  10116b:	83 f8 0d             	cmp    $0xd,%eax
  10116e:	0f 8f a3 00 00 00    	jg     101217 <cga_putc+0xd5>
  101174:	83 f8 08             	cmp    $0x8,%eax
  101177:	74 0a                	je     101183 <cga_putc+0x41>
  101179:	83 f8 0a             	cmp    $0xa,%eax
  10117c:	74 4c                	je     1011ca <cga_putc+0x88>
  10117e:	e9 94 00 00 00       	jmp    101217 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  101183:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10118a:	85 c0                	test   %eax,%eax
  10118c:	0f 84 af 00 00 00    	je     101241 <cga_putc+0xff>
            crt_pos --;
  101192:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101199:	48                   	dec    %eax
  10119a:	0f b7 c0             	movzwl %ax,%eax
  10119d:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1011a6:	98                   	cwtl   
  1011a7:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011ac:	98                   	cwtl   
  1011ad:	83 c8 20             	or     $0x20,%eax
  1011b0:	98                   	cwtl   
  1011b1:	8b 15 60 0e 11 00    	mov    0x110e60,%edx
  1011b7:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011be:	01 c9                	add    %ecx,%ecx
  1011c0:	01 ca                	add    %ecx,%edx
  1011c2:	0f b7 c0             	movzwl %ax,%eax
  1011c5:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011c8:	eb 77                	jmp    101241 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  1011ca:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011d1:	83 c0 50             	add    $0x50,%eax
  1011d4:	0f b7 c0             	movzwl %ax,%eax
  1011d7:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011dd:	0f b7 1d 64 0e 11 00 	movzwl 0x110e64,%ebx
  1011e4:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011eb:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011f0:	89 c8                	mov    %ecx,%eax
  1011f2:	f7 e2                	mul    %edx
  1011f4:	c1 ea 06             	shr    $0x6,%edx
  1011f7:	89 d0                	mov    %edx,%eax
  1011f9:	c1 e0 02             	shl    $0x2,%eax
  1011fc:	01 d0                	add    %edx,%eax
  1011fe:	c1 e0 04             	shl    $0x4,%eax
  101201:	29 c1                	sub    %eax,%ecx
  101203:	89 c8                	mov    %ecx,%eax
  101205:	0f b7 c0             	movzwl %ax,%eax
  101208:	29 c3                	sub    %eax,%ebx
  10120a:	89 d8                	mov    %ebx,%eax
  10120c:	0f b7 c0             	movzwl %ax,%eax
  10120f:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
        break;
  101215:	eb 2b                	jmp    101242 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101217:	8b 0d 60 0e 11 00    	mov    0x110e60,%ecx
  10121d:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101224:	8d 50 01             	lea    0x1(%eax),%edx
  101227:	0f b7 d2             	movzwl %dx,%edx
  10122a:	66 89 15 64 0e 11 00 	mov    %dx,0x110e64
  101231:	01 c0                	add    %eax,%eax
  101233:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101236:	8b 45 08             	mov    0x8(%ebp),%eax
  101239:	0f b7 c0             	movzwl %ax,%eax
  10123c:	66 89 02             	mov    %ax,(%edx)
        break;
  10123f:	eb 01                	jmp    101242 <cga_putc+0x100>
        break;
  101241:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101242:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101249:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10124e:	76 5d                	jbe    1012ad <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101250:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101255:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10125b:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101260:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101267:	00 
  101268:	89 54 24 04          	mov    %edx,0x4(%esp)
  10126c:	89 04 24             	mov    %eax,(%esp)
  10126f:	e8 dc 1c 00 00       	call   102f50 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101274:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10127b:	eb 14                	jmp    101291 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  10127d:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101282:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101285:	01 d2                	add    %edx,%edx
  101287:	01 d0                	add    %edx,%eax
  101289:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10128e:	ff 45 f4             	incl   -0xc(%ebp)
  101291:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101298:	7e e3                	jle    10127d <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  10129a:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012a1:	83 e8 50             	sub    $0x50,%eax
  1012a4:	0f b7 c0             	movzwl %ax,%eax
  1012a7:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012ad:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  1012b4:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012b8:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012bc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012c0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012c4:	ee                   	out    %al,(%dx)
}
  1012c5:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012c6:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012cd:	c1 e8 08             	shr    $0x8,%eax
  1012d0:	0f b7 c0             	movzwl %ax,%eax
  1012d3:	0f b6 c0             	movzbl %al,%eax
  1012d6:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012dd:	42                   	inc    %edx
  1012de:	0f b7 d2             	movzwl %dx,%edx
  1012e1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012e5:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012e8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012ec:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012f0:	ee                   	out    %al,(%dx)
}
  1012f1:	90                   	nop
    outb(addr_6845, 15);
  1012f2:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  1012f9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012fd:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101301:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101305:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101309:	ee                   	out    %al,(%dx)
}
  10130a:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  10130b:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101312:	0f b6 c0             	movzbl %al,%eax
  101315:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  10131c:	42                   	inc    %edx
  10131d:	0f b7 d2             	movzwl %dx,%edx
  101320:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101324:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101327:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10132b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10132f:	ee                   	out    %al,(%dx)
}
  101330:	90                   	nop
}
  101331:	90                   	nop
  101332:	83 c4 34             	add    $0x34,%esp
  101335:	5b                   	pop    %ebx
  101336:	5d                   	pop    %ebp
  101337:	c3                   	ret    

00101338 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101338:	f3 0f 1e fb          	endbr32 
  10133c:	55                   	push   %ebp
  10133d:	89 e5                	mov    %esp,%ebp
  10133f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101349:	eb 08                	jmp    101353 <serial_putc_sub+0x1b>
        delay();
  10134b:	e8 08 fb ff ff       	call   100e58 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101350:	ff 45 fc             	incl   -0x4(%ebp)
  101353:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101359:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10135d:	89 c2                	mov    %eax,%edx
  10135f:	ec                   	in     (%dx),%al
  101360:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101363:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101367:	0f b6 c0             	movzbl %al,%eax
  10136a:	83 e0 20             	and    $0x20,%eax
  10136d:	85 c0                	test   %eax,%eax
  10136f:	75 09                	jne    10137a <serial_putc_sub+0x42>
  101371:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101378:	7e d1                	jle    10134b <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  10137a:	8b 45 08             	mov    0x8(%ebp),%eax
  10137d:	0f b6 c0             	movzbl %al,%eax
  101380:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101386:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101389:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10138d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101391:	ee                   	out    %al,(%dx)
}
  101392:	90                   	nop
}
  101393:	90                   	nop
  101394:	c9                   	leave  
  101395:	c3                   	ret    

00101396 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101396:	f3 0f 1e fb          	endbr32 
  10139a:	55                   	push   %ebp
  10139b:	89 e5                	mov    %esp,%ebp
  10139d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013a0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013a4:	74 0d                	je     1013b3 <serial_putc+0x1d>
        serial_putc_sub(c);
  1013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a9:	89 04 24             	mov    %eax,(%esp)
  1013ac:	e8 87 ff ff ff       	call   101338 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013b1:	eb 24                	jmp    1013d7 <serial_putc+0x41>
        serial_putc_sub('\b');
  1013b3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013ba:	e8 79 ff ff ff       	call   101338 <serial_putc_sub>
        serial_putc_sub(' ');
  1013bf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013c6:	e8 6d ff ff ff       	call   101338 <serial_putc_sub>
        serial_putc_sub('\b');
  1013cb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013d2:	e8 61 ff ff ff       	call   101338 <serial_putc_sub>
}
  1013d7:	90                   	nop
  1013d8:	c9                   	leave  
  1013d9:	c3                   	ret    

001013da <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013da:	f3 0f 1e fb          	endbr32 
  1013de:	55                   	push   %ebp
  1013df:	89 e5                	mov    %esp,%ebp
  1013e1:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013e4:	eb 33                	jmp    101419 <cons_intr+0x3f>
        if (c != 0) {
  1013e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013ea:	74 2d                	je     101419 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013ec:	a1 84 10 11 00       	mov    0x111084,%eax
  1013f1:	8d 50 01             	lea    0x1(%eax),%edx
  1013f4:	89 15 84 10 11 00    	mov    %edx,0x111084
  1013fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013fd:	88 90 80 0e 11 00    	mov    %dl,0x110e80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101403:	a1 84 10 11 00       	mov    0x111084,%eax
  101408:	3d 00 02 00 00       	cmp    $0x200,%eax
  10140d:	75 0a                	jne    101419 <cons_intr+0x3f>
                cons.wpos = 0;
  10140f:	c7 05 84 10 11 00 00 	movl   $0x0,0x111084
  101416:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101419:	8b 45 08             	mov    0x8(%ebp),%eax
  10141c:	ff d0                	call   *%eax
  10141e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101421:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101425:	75 bf                	jne    1013e6 <cons_intr+0xc>
            }
        }
    }
}
  101427:	90                   	nop
  101428:	90                   	nop
  101429:	c9                   	leave  
  10142a:	c3                   	ret    

0010142b <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10142b:	f3 0f 1e fb          	endbr32 
  10142f:	55                   	push   %ebp
  101430:	89 e5                	mov    %esp,%ebp
  101432:	83 ec 10             	sub    $0x10,%esp
  101435:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10143b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10143f:	89 c2                	mov    %eax,%edx
  101441:	ec                   	in     (%dx),%al
  101442:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101445:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101449:	0f b6 c0             	movzbl %al,%eax
  10144c:	83 e0 01             	and    $0x1,%eax
  10144f:	85 c0                	test   %eax,%eax
  101451:	75 07                	jne    10145a <serial_proc_data+0x2f>
        return -1;
  101453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101458:	eb 2a                	jmp    101484 <serial_proc_data+0x59>
  10145a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101460:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101464:	89 c2                	mov    %eax,%edx
  101466:	ec                   	in     (%dx),%al
  101467:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10146a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10146e:	0f b6 c0             	movzbl %al,%eax
  101471:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101474:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101478:	75 07                	jne    101481 <serial_proc_data+0x56>
        c = '\b';
  10147a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101481:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101484:	c9                   	leave  
  101485:	c3                   	ret    

00101486 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101486:	f3 0f 1e fb          	endbr32 
  10148a:	55                   	push   %ebp
  10148b:	89 e5                	mov    %esp,%ebp
  10148d:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101490:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101495:	85 c0                	test   %eax,%eax
  101497:	74 0c                	je     1014a5 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101499:	c7 04 24 2b 14 10 00 	movl   $0x10142b,(%esp)
  1014a0:	e8 35 ff ff ff       	call   1013da <cons_intr>
    }
}
  1014a5:	90                   	nop
  1014a6:	c9                   	leave  
  1014a7:	c3                   	ret    

001014a8 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014a8:	f3 0f 1e fb          	endbr32 
  1014ac:	55                   	push   %ebp
  1014ad:	89 e5                	mov    %esp,%ebp
  1014af:	83 ec 38             	sub    $0x38,%esp
  1014b2:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014bb:	89 c2                	mov    %eax,%edx
  1014bd:	ec                   	in     (%dx),%al
  1014be:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014c1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014c5:	0f b6 c0             	movzbl %al,%eax
  1014c8:	83 e0 01             	and    $0x1,%eax
  1014cb:	85 c0                	test   %eax,%eax
  1014cd:	75 0a                	jne    1014d9 <kbd_proc_data+0x31>
        return -1;
  1014cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014d4:	e9 56 01 00 00       	jmp    10162f <kbd_proc_data+0x187>
  1014d9:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014e2:	89 c2                	mov    %eax,%edx
  1014e4:	ec                   	in     (%dx),%al
  1014e5:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014e8:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014ec:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014ef:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014f3:	75 17                	jne    10150c <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  1014f5:	a1 88 10 11 00       	mov    0x111088,%eax
  1014fa:	83 c8 40             	or     $0x40,%eax
  1014fd:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  101502:	b8 00 00 00 00       	mov    $0x0,%eax
  101507:	e9 23 01 00 00       	jmp    10162f <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10150c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101510:	84 c0                	test   %al,%al
  101512:	79 45                	jns    101559 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101514:	a1 88 10 11 00       	mov    0x111088,%eax
  101519:	83 e0 40             	and    $0x40,%eax
  10151c:	85 c0                	test   %eax,%eax
  10151e:	75 08                	jne    101528 <kbd_proc_data+0x80>
  101520:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101524:	24 7f                	and    $0x7f,%al
  101526:	eb 04                	jmp    10152c <kbd_proc_data+0x84>
  101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152c:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10152f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101533:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  10153a:	0c 40                	or     $0x40,%al
  10153c:	0f b6 c0             	movzbl %al,%eax
  10153f:	f7 d0                	not    %eax
  101541:	89 c2                	mov    %eax,%edx
  101543:	a1 88 10 11 00       	mov    0x111088,%eax
  101548:	21 d0                	and    %edx,%eax
  10154a:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  10154f:	b8 00 00 00 00       	mov    $0x0,%eax
  101554:	e9 d6 00 00 00       	jmp    10162f <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101559:	a1 88 10 11 00       	mov    0x111088,%eax
  10155e:	83 e0 40             	and    $0x40,%eax
  101561:	85 c0                	test   %eax,%eax
  101563:	74 11                	je     101576 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101565:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101569:	a1 88 10 11 00       	mov    0x111088,%eax
  10156e:	83 e0 bf             	and    $0xffffffbf,%eax
  101571:	a3 88 10 11 00       	mov    %eax,0x111088
    }

    shift |= shiftcode[data];
  101576:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10157a:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101581:	0f b6 d0             	movzbl %al,%edx
  101584:	a1 88 10 11 00       	mov    0x111088,%eax
  101589:	09 d0                	or     %edx,%eax
  10158b:	a3 88 10 11 00       	mov    %eax,0x111088
    shift ^= togglecode[data];
  101590:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101594:	0f b6 80 40 01 11 00 	movzbl 0x110140(%eax),%eax
  10159b:	0f b6 d0             	movzbl %al,%edx
  10159e:	a1 88 10 11 00       	mov    0x111088,%eax
  1015a3:	31 d0                	xor    %edx,%eax
  1015a5:	a3 88 10 11 00       	mov    %eax,0x111088

    c = charcode[shift & (CTL | SHIFT)][data];
  1015aa:	a1 88 10 11 00       	mov    0x111088,%eax
  1015af:	83 e0 03             	and    $0x3,%eax
  1015b2:	8b 14 85 40 05 11 00 	mov    0x110540(,%eax,4),%edx
  1015b9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015bd:	01 d0                	add    %edx,%eax
  1015bf:	0f b6 00             	movzbl (%eax),%eax
  1015c2:	0f b6 c0             	movzbl %al,%eax
  1015c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015c8:	a1 88 10 11 00       	mov    0x111088,%eax
  1015cd:	83 e0 08             	and    $0x8,%eax
  1015d0:	85 c0                	test   %eax,%eax
  1015d2:	74 22                	je     1015f6 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015d4:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015d8:	7e 0c                	jle    1015e6 <kbd_proc_data+0x13e>
  1015da:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015de:	7f 06                	jg     1015e6 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015e0:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015e4:	eb 10                	jmp    1015f6 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015e6:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015ea:	7e 0a                	jle    1015f6 <kbd_proc_data+0x14e>
  1015ec:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015f0:	7f 04                	jg     1015f6 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015f2:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015f6:	a1 88 10 11 00       	mov    0x111088,%eax
  1015fb:	f7 d0                	not    %eax
  1015fd:	83 e0 06             	and    $0x6,%eax
  101600:	85 c0                	test   %eax,%eax
  101602:	75 28                	jne    10162c <kbd_proc_data+0x184>
  101604:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10160b:	75 1f                	jne    10162c <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10160d:	c7 04 24 85 3a 10 00 	movl   $0x103a85,(%esp)
  101614:	e8 8a ec ff ff       	call   1002a3 <cprintf>
  101619:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10161f:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101623:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101627:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10162a:	ee                   	out    %al,(%dx)
}
  10162b:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10162f:	c9                   	leave  
  101630:	c3                   	ret    

00101631 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101631:	f3 0f 1e fb          	endbr32 
  101635:	55                   	push   %ebp
  101636:	89 e5                	mov    %esp,%ebp
  101638:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10163b:	c7 04 24 a8 14 10 00 	movl   $0x1014a8,(%esp)
  101642:	e8 93 fd ff ff       	call   1013da <cons_intr>
}
  101647:	90                   	nop
  101648:	c9                   	leave  
  101649:	c3                   	ret    

0010164a <kbd_init>:

static void
kbd_init(void) {
  10164a:	f3 0f 1e fb          	endbr32 
  10164e:	55                   	push   %ebp
  10164f:	89 e5                	mov    %esp,%ebp
  101651:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101654:	e8 d8 ff ff ff       	call   101631 <kbd_intr>
    pic_enable(IRQ_KBD);
  101659:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101660:	e8 21 01 00 00       	call   101786 <pic_enable>
}
  101665:	90                   	nop
  101666:	c9                   	leave  
  101667:	c3                   	ret    

00101668 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101668:	f3 0f 1e fb          	endbr32 
  10166c:	55                   	push   %ebp
  10166d:	89 e5                	mov    %esp,%ebp
  10166f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101672:	e8 2e f8 ff ff       	call   100ea5 <cga_init>
    serial_init();
  101677:	e8 13 f9 ff ff       	call   100f8f <serial_init>
    kbd_init();
  10167c:	e8 c9 ff ff ff       	call   10164a <kbd_init>
    if (!serial_exists) {
  101681:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101686:	85 c0                	test   %eax,%eax
  101688:	75 0c                	jne    101696 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10168a:	c7 04 24 91 3a 10 00 	movl   $0x103a91,(%esp)
  101691:	e8 0d ec ff ff       	call   1002a3 <cprintf>
    }
}
  101696:	90                   	nop
  101697:	c9                   	leave  
  101698:	c3                   	ret    

00101699 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101699:	f3 0f 1e fb          	endbr32 
  10169d:	55                   	push   %ebp
  10169e:	89 e5                	mov    %esp,%ebp
  1016a0:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a6:	89 04 24             	mov    %eax,(%esp)
  1016a9:	e8 50 fa ff ff       	call   1010fe <lpt_putc>
    cga_putc(c);
  1016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b1:	89 04 24             	mov    %eax,(%esp)
  1016b4:	e8 89 fa ff ff       	call   101142 <cga_putc>
    serial_putc(c);
  1016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1016bc:	89 04 24             	mov    %eax,(%esp)
  1016bf:	e8 d2 fc ff ff       	call   101396 <serial_putc>
}
  1016c4:	90                   	nop
  1016c5:	c9                   	leave  
  1016c6:	c3                   	ret    

001016c7 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016c7:	f3 0f 1e fb          	endbr32 
  1016cb:	55                   	push   %ebp
  1016cc:	89 e5                	mov    %esp,%ebp
  1016ce:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016d1:	e8 b0 fd ff ff       	call   101486 <serial_intr>
    kbd_intr();
  1016d6:	e8 56 ff ff ff       	call   101631 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016db:	8b 15 80 10 11 00    	mov    0x111080,%edx
  1016e1:	a1 84 10 11 00       	mov    0x111084,%eax
  1016e6:	39 c2                	cmp    %eax,%edx
  1016e8:	74 36                	je     101720 <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016ea:	a1 80 10 11 00       	mov    0x111080,%eax
  1016ef:	8d 50 01             	lea    0x1(%eax),%edx
  1016f2:	89 15 80 10 11 00    	mov    %edx,0x111080
  1016f8:	0f b6 80 80 0e 11 00 	movzbl 0x110e80(%eax),%eax
  1016ff:	0f b6 c0             	movzbl %al,%eax
  101702:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101705:	a1 80 10 11 00       	mov    0x111080,%eax
  10170a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10170f:	75 0a                	jne    10171b <cons_getc+0x54>
            cons.rpos = 0;
  101711:	c7 05 80 10 11 00 00 	movl   $0x0,0x111080
  101718:	00 00 00 
        }
        return c;
  10171b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10171e:	eb 05                	jmp    101725 <cons_getc+0x5e>
    }
    return 0;
  101720:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101725:	c9                   	leave  
  101726:	c3                   	ret    

00101727 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101727:	f3 0f 1e fb          	endbr32 
  10172b:	55                   	push   %ebp
  10172c:	89 e5                	mov    %esp,%ebp
  10172e:	83 ec 14             	sub    $0x14,%esp
  101731:	8b 45 08             	mov    0x8(%ebp),%eax
  101734:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10173b:	66 a3 50 05 11 00    	mov    %ax,0x110550
    if (did_init) {
  101741:	a1 8c 10 11 00       	mov    0x11108c,%eax
  101746:	85 c0                	test   %eax,%eax
  101748:	74 39                	je     101783 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  10174a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10174d:	0f b6 c0             	movzbl %al,%eax
  101750:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101756:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101759:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10175d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101761:	ee                   	out    %al,(%dx)
}
  101762:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101763:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101767:	c1 e8 08             	shr    $0x8,%eax
  10176a:	0f b7 c0             	movzwl %ax,%eax
  10176d:	0f b6 c0             	movzbl %al,%eax
  101770:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101776:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101779:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10177d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101781:	ee                   	out    %al,(%dx)
}
  101782:	90                   	nop
    }
}
  101783:	90                   	nop
  101784:	c9                   	leave  
  101785:	c3                   	ret    

00101786 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101786:	f3 0f 1e fb          	endbr32 
  10178a:	55                   	push   %ebp
  10178b:	89 e5                	mov    %esp,%ebp
  10178d:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101790:	8b 45 08             	mov    0x8(%ebp),%eax
  101793:	ba 01 00 00 00       	mov    $0x1,%edx
  101798:	88 c1                	mov    %al,%cl
  10179a:	d3 e2                	shl    %cl,%edx
  10179c:	89 d0                	mov    %edx,%eax
  10179e:	98                   	cwtl   
  10179f:	f7 d0                	not    %eax
  1017a1:	0f bf d0             	movswl %ax,%edx
  1017a4:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1017ab:	98                   	cwtl   
  1017ac:	21 d0                	and    %edx,%eax
  1017ae:	98                   	cwtl   
  1017af:	0f b7 c0             	movzwl %ax,%eax
  1017b2:	89 04 24             	mov    %eax,(%esp)
  1017b5:	e8 6d ff ff ff       	call   101727 <pic_setmask>
}
  1017ba:	90                   	nop
  1017bb:	c9                   	leave  
  1017bc:	c3                   	ret    

001017bd <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017bd:	f3 0f 1e fb          	endbr32 
  1017c1:	55                   	push   %ebp
  1017c2:	89 e5                	mov    %esp,%ebp
  1017c4:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017c7:	c7 05 8c 10 11 00 01 	movl   $0x1,0x11108c
  1017ce:	00 00 00 
  1017d1:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017d7:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017db:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017df:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017e3:	ee                   	out    %al,(%dx)
}
  1017e4:	90                   	nop
  1017e5:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017eb:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ef:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017f3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017f7:	ee                   	out    %al,(%dx)
}
  1017f8:	90                   	nop
  1017f9:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017ff:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101803:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101807:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10180b:	ee                   	out    %al,(%dx)
}
  10180c:	90                   	nop
  10180d:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101813:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101817:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10181b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10181f:	ee                   	out    %al,(%dx)
}
  101820:	90                   	nop
  101821:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101827:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10182b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10182f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101833:	ee                   	out    %al,(%dx)
}
  101834:	90                   	nop
  101835:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10183b:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10183f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101843:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101847:	ee                   	out    %al,(%dx)
}
  101848:	90                   	nop
  101849:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10184f:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101853:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101857:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10185b:	ee                   	out    %al,(%dx)
}
  10185c:	90                   	nop
  10185d:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101863:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101867:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10186b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10186f:	ee                   	out    %al,(%dx)
}
  101870:	90                   	nop
  101871:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101877:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10187b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10187f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101883:	ee                   	out    %al,(%dx)
}
  101884:	90                   	nop
  101885:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10188b:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10188f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101893:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101897:	ee                   	out    %al,(%dx)
}
  101898:	90                   	nop
  101899:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10189f:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018a3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1018a7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1018ab:	ee                   	out    %al,(%dx)
}
  1018ac:	90                   	nop
  1018ad:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1018b3:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018b7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018bb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018bf:	ee                   	out    %al,(%dx)
}
  1018c0:	90                   	nop
  1018c1:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018c7:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018cb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018cf:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018d3:	ee                   	out    %al,(%dx)
}
  1018d4:	90                   	nop
  1018d5:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018db:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018e7:	ee                   	out    %al,(%dx)
}
  1018e8:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018e9:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018f0:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1018f5:	74 0f                	je     101906 <pic_init+0x149>
        pic_setmask(irq_mask);
  1018f7:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018fe:	89 04 24             	mov    %eax,(%esp)
  101901:	e8 21 fe ff ff       	call   101727 <pic_setmask>
    }
}
  101906:	90                   	nop
  101907:	c9                   	leave  
  101908:	c3                   	ret    

00101909 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101909:	f3 0f 1e fb          	endbr32 
  10190d:	55                   	push   %ebp
  10190e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101910:	fb                   	sti    
}
  101911:	90                   	nop
    sti();
}
  101912:	90                   	nop
  101913:	5d                   	pop    %ebp
  101914:	c3                   	ret    

00101915 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101915:	f3 0f 1e fb          	endbr32 
  101919:	55                   	push   %ebp
  10191a:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  10191c:	fa                   	cli    
}
  10191d:	90                   	nop
    cli();
}
  10191e:	90                   	nop
  10191f:	5d                   	pop    %ebp
  101920:	c3                   	ret    

00101921 <print_ticks>:
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks()
{
  101921:	f3 0f 1e fb          	endbr32 
  101925:	55                   	push   %ebp
  101926:	89 e5                	mov    %esp,%ebp
  101928:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n", TICK_NUM);
  10192b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101932:	00 
  101933:	c7 04 24 c0 3a 10 00 	movl   $0x103ac0,(%esp)
  10193a:	e8 64 e9 ff ff       	call   1002a3 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10193f:	c7 04 24 ca 3a 10 00 	movl   $0x103aca,(%esp)
  101946:	e8 58 e9 ff ff       	call   1002a3 <cprintf>
    panic("EOT: kernel seems ok.");
  10194b:	c7 44 24 08 d8 3a 10 	movl   $0x103ad8,0x8(%esp)
  101952:	00 
  101953:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  10195a:	00 
  10195b:	c7 04 24 ee 3a 10 00 	movl   $0x103aee,(%esp)
  101962:	e8 a8 ea ff ff       	call   10040f <__panic>

00101967 <idt_init>:
static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void)
{
  101967:	f3 0f 1e fb          	endbr32 
  10196b:	55                   	push   %ebp
  10196c:	89 e5                	mov    %esp,%ebp
  10196e:	83 ec 10             	sub    $0x10,%esp
     * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
     *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
     *     Notice: the argument of lidt is idt_pd. try to find it!
     */
    extern uintptr_t __vectors[];
    for (int i = 0; i < 256; ++i)
  101971:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101978:	e9 c4 00 00 00       	jmp    101a41 <idt_init+0xda>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101980:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101987:	0f b7 d0             	movzwl %ax,%edx
  10198a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198d:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  101994:	00 
  101995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101998:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  10199f:	00 08 00 
  1019a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a5:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1019ac:	00 
  1019ad:	80 e2 e0             	and    $0xe0,%dl
  1019b0:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ba:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1019c1:	00 
  1019c2:	80 e2 1f             	and    $0x1f,%dl
  1019c5:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019cf:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019d6:	00 
  1019d7:	80 e2 f0             	and    $0xf0,%dl
  1019da:	80 ca 0e             	or     $0xe,%dl
  1019dd:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e7:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019ee:	00 
  1019ef:	80 e2 ef             	and    $0xef,%dl
  1019f2:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fc:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101a03:	00 
  101a04:	80 e2 9f             	and    $0x9f,%dl
  101a07:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a11:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101a18:	00 
  101a19:	80 ca 80             	or     $0x80,%dl
  101a1c:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101a23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a26:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101a2d:	c1 e8 10             	shr    $0x10,%eax
  101a30:	0f b7 d0             	movzwl %ax,%edx
  101a33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a36:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  101a3d:	00 
    for (int i = 0; i < 256; ++i)
  101a3e:	ff 45 fc             	incl   -0x4(%ebp)
  101a41:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101a48:	0f 8e 2f ff ff ff    	jle    10197d <idt_init+0x16>
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a4e:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101a53:	0f b7 c0             	movzwl %ax,%eax
  101a56:	66 a3 68 14 11 00    	mov    %ax,0x111468
  101a5c:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  101a63:	08 00 
  101a65:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a6c:	24 e0                	and    $0xe0,%al
  101a6e:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a73:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a7a:	24 1f                	and    $0x1f,%al
  101a7c:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a81:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a88:	24 f0                	and    $0xf0,%al
  101a8a:	0c 0e                	or     $0xe,%al
  101a8c:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a91:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a98:	24 ef                	and    $0xef,%al
  101a9a:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a9f:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101aa6:	0c 60                	or     $0x60,%al
  101aa8:	a2 6d 14 11 00       	mov    %al,0x11146d
  101aad:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101ab4:	0c 80                	or     $0x80,%al
  101ab6:	a2 6d 14 11 00       	mov    %al,0x11146d
  101abb:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101ac0:	c1 e8 10             	shr    $0x10,%eax
  101ac3:	0f b7 c0             	movzwl %ax,%eax
  101ac6:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
  101acc:	c7 45 f8 60 05 11 00 	movl   $0x110560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101ad3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ad6:	0f 01 18             	lidtl  (%eax)
}
  101ad9:	90                   	nop
    lidt(&idt_pd);
}
  101ada:	90                   	nop
  101adb:	c9                   	leave  
  101adc:	c3                   	ret    

00101add <trapname>:

static const char *
trapname(int trapno)
{
  101add:	f3 0f 1e fb          	endbr32 
  101ae1:	55                   	push   %ebp
  101ae2:	89 e5                	mov    %esp,%ebp
        "x87 FPU Floating-Point Error",
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"};

    if (trapno < sizeof(excnames) / sizeof(const char *const))
  101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae7:	83 f8 13             	cmp    $0x13,%eax
  101aea:	77 0c                	ja     101af8 <trapname+0x1b>
    {
        return excnames[trapno];
  101aec:	8b 45 08             	mov    0x8(%ebp),%eax
  101aef:	8b 04 85 40 3e 10 00 	mov    0x103e40(,%eax,4),%eax
  101af6:	eb 18                	jmp    101b10 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
  101af8:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101afc:	7e 0d                	jle    101b0b <trapname+0x2e>
  101afe:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b02:	7f 07                	jg     101b0b <trapname+0x2e>
    {
        return "Hardware Interrupt";
  101b04:	b8 ff 3a 10 00       	mov    $0x103aff,%eax
  101b09:	eb 05                	jmp    101b10 <trapname+0x33>
    }
    return "(unknown trap)";
  101b0b:	b8 12 3b 10 00       	mov    $0x103b12,%eax
}
  101b10:	5d                   	pop    %ebp
  101b11:	c3                   	ret    

00101b12 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf)
{
  101b12:	f3 0f 1e fb          	endbr32 
  101b16:	55                   	push   %ebp
  101b17:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b19:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b20:	83 f8 08             	cmp    $0x8,%eax
  101b23:	0f 94 c0             	sete   %al
  101b26:	0f b6 c0             	movzbl %al,%eax
}
  101b29:	5d                   	pop    %ebp
  101b2a:	c3                   	ret    

00101b2b <print_trapframe>:
    NULL,
    NULL,
};

void print_trapframe(struct trapframe *tf)
{
  101b2b:	f3 0f 1e fb          	endbr32 
  101b2f:	55                   	push   %ebp
  101b30:	89 e5                	mov    %esp,%ebp
  101b32:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b35:	8b 45 08             	mov    0x8(%ebp),%eax
  101b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3c:	c7 04 24 53 3b 10 00 	movl   $0x103b53,(%esp)
  101b43:	e8 5b e7 ff ff       	call   1002a3 <cprintf>
    print_regs(&tf->tf_regs);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	89 04 24             	mov    %eax,(%esp)
  101b4e:	e8 8d 01 00 00       	call   101ce0 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b53:	8b 45 08             	mov    0x8(%ebp),%eax
  101b56:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5e:	c7 04 24 64 3b 10 00 	movl   $0x103b64,(%esp)
  101b65:	e8 39 e7 ff ff       	call   1002a3 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b75:	c7 04 24 77 3b 10 00 	movl   $0x103b77,(%esp)
  101b7c:	e8 22 e7 ff ff       	call   1002a3 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b81:	8b 45 08             	mov    0x8(%ebp),%eax
  101b84:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8c:	c7 04 24 8a 3b 10 00 	movl   $0x103b8a,(%esp)
  101b93:	e8 0b e7 ff ff       	call   1002a3 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b98:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9b:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba3:	c7 04 24 9d 3b 10 00 	movl   $0x103b9d,(%esp)
  101baa:	e8 f4 e6 ff ff       	call   1002a3 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101baf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb2:	8b 40 30             	mov    0x30(%eax),%eax
  101bb5:	89 04 24             	mov    %eax,(%esp)
  101bb8:	e8 20 ff ff ff       	call   101add <trapname>
  101bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  101bc0:	8b 52 30             	mov    0x30(%edx),%edx
  101bc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bc7:	89 54 24 04          	mov    %edx,0x4(%esp)
  101bcb:	c7 04 24 b0 3b 10 00 	movl   $0x103bb0,(%esp)
  101bd2:	e8 cc e6 ff ff       	call   1002a3 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bda:	8b 40 34             	mov    0x34(%eax),%eax
  101bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be1:	c7 04 24 c2 3b 10 00 	movl   $0x103bc2,(%esp)
  101be8:	e8 b6 e6 ff ff       	call   1002a3 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	8b 40 38             	mov    0x38(%eax),%eax
  101bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf7:	c7 04 24 d1 3b 10 00 	movl   $0x103bd1,(%esp)
  101bfe:	e8 a0 e6 ff ff       	call   1002a3 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c03:	8b 45 08             	mov    0x8(%ebp),%eax
  101c06:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0e:	c7 04 24 e0 3b 10 00 	movl   $0x103be0,(%esp)
  101c15:	e8 89 e6 ff ff       	call   1002a3 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1d:	8b 40 40             	mov    0x40(%eax),%eax
  101c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c24:	c7 04 24 f3 3b 10 00 	movl   $0x103bf3,(%esp)
  101c2b:	e8 73 e6 ff ff       	call   1002a3 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101c30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c37:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c3e:	eb 3d                	jmp    101c7d <print_trapframe+0x152>
    {
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL)
  101c40:	8b 45 08             	mov    0x8(%ebp),%eax
  101c43:	8b 50 40             	mov    0x40(%eax),%edx
  101c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c49:	21 d0                	and    %edx,%eax
  101c4b:	85 c0                	test   %eax,%eax
  101c4d:	74 28                	je     101c77 <print_trapframe+0x14c>
  101c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c52:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c59:	85 c0                	test   %eax,%eax
  101c5b:	74 1a                	je     101c77 <print_trapframe+0x14c>
        {
            cprintf("%s,", IA32flags[i]);
  101c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c60:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6b:	c7 04 24 02 3c 10 00 	movl   $0x103c02,(%esp)
  101c72:	e8 2c e6 ff ff       	call   1002a3 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1)
  101c77:	ff 45 f4             	incl   -0xc(%ebp)
  101c7a:	d1 65 f0             	shll   -0x10(%ebp)
  101c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c80:	83 f8 17             	cmp    $0x17,%eax
  101c83:	76 bb                	jbe    101c40 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c85:	8b 45 08             	mov    0x8(%ebp),%eax
  101c88:	8b 40 40             	mov    0x40(%eax),%eax
  101c8b:	c1 e8 0c             	shr    $0xc,%eax
  101c8e:	83 e0 03             	and    $0x3,%eax
  101c91:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c95:	c7 04 24 06 3c 10 00 	movl   $0x103c06,(%esp)
  101c9c:	e8 02 e6 ff ff       	call   1002a3 <cprintf>

    if (!trap_in_kernel(tf))
  101ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca4:	89 04 24             	mov    %eax,(%esp)
  101ca7:	e8 66 fe ff ff       	call   101b12 <trap_in_kernel>
  101cac:	85 c0                	test   %eax,%eax
  101cae:	75 2d                	jne    101cdd <print_trapframe+0x1b2>
    {
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb3:	8b 40 44             	mov    0x44(%eax),%eax
  101cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cba:	c7 04 24 0f 3c 10 00 	movl   $0x103c0f,(%esp)
  101cc1:	e8 dd e5 ff ff       	call   1002a3 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc9:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd1:	c7 04 24 1e 3c 10 00 	movl   $0x103c1e,(%esp)
  101cd8:	e8 c6 e5 ff ff       	call   1002a3 <cprintf>
    }
}
  101cdd:	90                   	nop
  101cde:	c9                   	leave  
  101cdf:	c3                   	ret    

00101ce0 <print_regs>:

void print_regs(struct pushregs *regs)
{
  101ce0:	f3 0f 1e fb          	endbr32 
  101ce4:	55                   	push   %ebp
  101ce5:	89 e5                	mov    %esp,%ebp
  101ce7:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cea:	8b 45 08             	mov    0x8(%ebp),%eax
  101ced:	8b 00                	mov    (%eax),%eax
  101cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf3:	c7 04 24 31 3c 10 00 	movl   $0x103c31,(%esp)
  101cfa:	e8 a4 e5 ff ff       	call   1002a3 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cff:	8b 45 08             	mov    0x8(%ebp),%eax
  101d02:	8b 40 04             	mov    0x4(%eax),%eax
  101d05:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d09:	c7 04 24 40 3c 10 00 	movl   $0x103c40,(%esp)
  101d10:	e8 8e e5 ff ff       	call   1002a3 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d15:	8b 45 08             	mov    0x8(%ebp),%eax
  101d18:	8b 40 08             	mov    0x8(%eax),%eax
  101d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1f:	c7 04 24 4f 3c 10 00 	movl   $0x103c4f,(%esp)
  101d26:	e8 78 e5 ff ff       	call   1002a3 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  101d31:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d35:	c7 04 24 5e 3c 10 00 	movl   $0x103c5e,(%esp)
  101d3c:	e8 62 e5 ff ff       	call   1002a3 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d41:	8b 45 08             	mov    0x8(%ebp),%eax
  101d44:	8b 40 10             	mov    0x10(%eax),%eax
  101d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d4b:	c7 04 24 6d 3c 10 00 	movl   $0x103c6d,(%esp)
  101d52:	e8 4c e5 ff ff       	call   1002a3 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d57:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5a:	8b 40 14             	mov    0x14(%eax),%eax
  101d5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d61:	c7 04 24 7c 3c 10 00 	movl   $0x103c7c,(%esp)
  101d68:	e8 36 e5 ff ff       	call   1002a3 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d70:	8b 40 18             	mov    0x18(%eax),%eax
  101d73:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d77:	c7 04 24 8b 3c 10 00 	movl   $0x103c8b,(%esp)
  101d7e:	e8 20 e5 ff ff       	call   1002a3 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d83:	8b 45 08             	mov    0x8(%ebp),%eax
  101d86:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8d:	c7 04 24 9a 3c 10 00 	movl   $0x103c9a,(%esp)
  101d94:	e8 0a e5 ff ff       	call   1002a3 <cprintf>
}
  101d99:	90                   	nop
  101d9a:	c9                   	leave  
  101d9b:	c3                   	ret    

00101d9c <switch_to_kernel>:

static void
switch_to_kernel(struct trapframe *tf)
{
  101d9c:	f3 0f 1e fb          	endbr32 
  101da0:	55                   	push   %ebp
  101da1:	89 e5                	mov    %esp,%ebp
    tf->tf_cs = KERNEL_CS;
  101da3:	8b 45 08             	mov    0x8(%ebp),%eax
  101da6:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
    tf->tf_ds = KERNEL_DS;
  101dac:	8b 45 08             	mov    0x8(%ebp),%eax
  101daf:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
    tf->tf_es = KERNEL_DS;
  101db5:	8b 45 08             	mov    0x8(%ebp),%eax
  101db8:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
    tf->tf_ss = KERNEL_DS;
  101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc1:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
    tf->tf_eflags &= ~FL_IOPL_MASK;
  101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dca:	8b 40 40             	mov    0x40(%eax),%eax
  101dcd:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101dd2:	89 c2                	mov    %eax,%edx
  101dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd7:	89 50 40             	mov    %edx,0x40(%eax)
}
  101dda:	90                   	nop
  101ddb:	5d                   	pop    %ebp
  101ddc:	c3                   	ret    

00101ddd <switch_to_user>:

static void
switch_to_user(struct trapframe *tf)
{
  101ddd:	f3 0f 1e fb          	endbr32 
  101de1:	55                   	push   %ebp
  101de2:	89 e5                	mov    %esp,%ebp
    tf->tf_cs = USER_CS;
  101de4:	8b 45 08             	mov    0x8(%ebp),%eax
  101de7:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    tf->tf_ds = USER_DS;
  101ded:	8b 45 08             	mov    0x8(%ebp),%eax
  101df0:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
    tf->tf_es = USER_DS;
  101df6:	8b 45 08             	mov    0x8(%ebp),%eax
  101df9:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
    tf->tf_ss = USER_DS;
  101dff:	8b 45 08             	mov    0x8(%ebp),%eax
  101e02:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
    tf->tf_eflags |= FL_IOPL_MASK;
  101e08:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0b:	8b 40 40             	mov    0x40(%eax),%eax
  101e0e:	0d 00 30 00 00       	or     $0x3000,%eax
  101e13:	89 c2                	mov    %eax,%edx
  101e15:	8b 45 08             	mov    0x8(%ebp),%eax
  101e18:	89 50 40             	mov    %edx,0x40(%eax)
}
  101e1b:	90                   	nop
  101e1c:	5d                   	pop    %ebp
  101e1d:	c3                   	ret    

00101e1e <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
struct trapframe k2u, *u2k;
static void
trap_dispatch(struct trapframe *tf)
{
  101e1e:	f3 0f 1e fb          	endbr32 
  101e22:	55                   	push   %ebp
  101e23:	89 e5                	mov    %esp,%ebp
  101e25:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno)
  101e28:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2b:	8b 40 30             	mov    0x30(%eax),%eax
  101e2e:	83 f8 79             	cmp    $0x79,%eax
  101e31:	0f 84 2d 01 00 00    	je     101f64 <trap_dispatch+0x146>
  101e37:	83 f8 79             	cmp    $0x79,%eax
  101e3a:	0f 87 5d 01 00 00    	ja     101f9d <trap_dispatch+0x17f>
  101e40:	83 f8 78             	cmp    $0x78,%eax
  101e43:	0f 84 e2 00 00 00    	je     101f2b <trap_dispatch+0x10d>
  101e49:	83 f8 78             	cmp    $0x78,%eax
  101e4c:	0f 87 4b 01 00 00    	ja     101f9d <trap_dispatch+0x17f>
  101e52:	83 f8 2f             	cmp    $0x2f,%eax
  101e55:	0f 87 42 01 00 00    	ja     101f9d <trap_dispatch+0x17f>
  101e5b:	83 f8 2e             	cmp    $0x2e,%eax
  101e5e:	0f 83 6e 01 00 00    	jae    101fd2 <trap_dispatch+0x1b4>
  101e64:	83 f8 24             	cmp    $0x24,%eax
  101e67:	74 45                	je     101eae <trap_dispatch+0x90>
  101e69:	83 f8 24             	cmp    $0x24,%eax
  101e6c:	0f 87 2b 01 00 00    	ja     101f9d <trap_dispatch+0x17f>
  101e72:	83 f8 20             	cmp    $0x20,%eax
  101e75:	74 0a                	je     101e81 <trap_dispatch+0x63>
  101e77:	83 f8 21             	cmp    $0x21,%eax
  101e7a:	74 5b                	je     101ed7 <trap_dispatch+0xb9>
  101e7c:	e9 1c 01 00 00       	jmp    101f9d <trap_dispatch+0x17f>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101e81:	a1 08 19 11 00       	mov    0x111908,%eax
  101e86:	40                   	inc    %eax
  101e87:	a3 08 19 11 00       	mov    %eax,0x111908
        if (ticks == TICK_NUM)
  101e8c:	a1 08 19 11 00       	mov    0x111908,%eax
  101e91:	83 f8 64             	cmp    $0x64,%eax
  101e94:	0f 85 3b 01 00 00    	jne    101fd5 <trap_dispatch+0x1b7>
        {
            ticks = 0;
  101e9a:	c7 05 08 19 11 00 00 	movl   $0x0,0x111908
  101ea1:	00 00 00 
            print_ticks();
  101ea4:	e8 78 fa ff ff       	call   101921 <print_ticks>
        }
        break;
  101ea9:	e9 27 01 00 00       	jmp    101fd5 <trap_dispatch+0x1b7>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101eae:	e8 14 f8 ff ff       	call   1016c7 <cons_getc>
  101eb3:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101eb6:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101eba:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ebe:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ec6:	c7 04 24 a9 3c 10 00 	movl   $0x103ca9,(%esp)
  101ecd:	e8 d1 e3 ff ff       	call   1002a3 <cprintf>
        break;
  101ed2:	e9 02 01 00 00       	jmp    101fd9 <trap_dispatch+0x1bb>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ed7:	e8 eb f7 ff ff       	call   1016c7 <cons_getc>
  101edc:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101edf:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ee3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ee7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101eef:	c7 04 24 bb 3c 10 00 	movl   $0x103cbb,(%esp)
  101ef6:	e8 a8 e3 ff ff       	call   1002a3 <cprintf>
        if (c == '0')
  101efb:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
  101eff:	75 10                	jne    101f11 <trap_dispatch+0xf3>
        {
            //切换为内核态
            switch_to_kernel(tf);
  101f01:	8b 45 08             	mov    0x8(%ebp),%eax
  101f04:	89 04 24             	mov    %eax,(%esp)
  101f07:	e8 90 fe ff ff       	call   101d9c <switch_to_kernel>
        else if (c == '3')
        {
            //切换为用户态
            switch_to_user(tf);
        }
        break;
  101f0c:	e9 c7 00 00 00       	jmp    101fd8 <trap_dispatch+0x1ba>
        else if (c == '3')
  101f11:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
  101f15:	0f 85 bd 00 00 00    	jne    101fd8 <trap_dispatch+0x1ba>
            switch_to_user(tf);
  101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1e:	89 04 24             	mov    %eax,(%esp)
  101f21:	e8 b7 fe ff ff       	call   101ddd <switch_to_user>
        break;
  101f26:	e9 ad 00 00 00       	jmp    101fd8 <trap_dispatch+0x1ba>
    // LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        tf->tf_cs = USER_CS;
  101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2e:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
        tf->tf_ds = USER_DS;
  101f34:	8b 45 08             	mov    0x8(%ebp),%eax
  101f37:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
        tf->tf_es = USER_DS;
  101f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f40:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
        tf->tf_ss = USER_DS;
  101f46:	8b 45 08             	mov    0x8(%ebp),%eax
  101f49:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
        tf->tf_eflags |= FL_IOPL_MASK;
  101f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f52:	8b 40 40             	mov    0x40(%eax),%eax
  101f55:	0d 00 30 00 00       	or     $0x3000,%eax
  101f5a:	89 c2                	mov    %eax,%edx
  101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5f:	89 50 40             	mov    %edx,0x40(%eax)
        break;
  101f62:	eb 75                	jmp    101fd9 <trap_dispatch+0x1bb>
    case T_SWITCH_TOK:
        tf->tf_cs = KERNEL_CS;
  101f64:	8b 45 08             	mov    0x8(%ebp),%eax
  101f67:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
  101f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f70:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
  101f76:	8b 45 08             	mov    0x8(%ebp),%eax
  101f79:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_ss = KERNEL_DS;
  101f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f82:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101f88:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8b:	8b 40 40             	mov    0x40(%eax),%eax
  101f8e:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f93:	89 c2                	mov    %eax,%edx
  101f95:	8b 45 08             	mov    0x8(%ebp),%eax
  101f98:	89 50 40             	mov    %edx,0x40(%eax)
        // panic("T_SWITCH_** ??\n");
        break;
  101f9b:	eb 3c                	jmp    101fd9 <trap_dispatch+0x1bb>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0)
  101f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fa4:	83 e0 03             	and    $0x3,%eax
  101fa7:	85 c0                	test   %eax,%eax
  101fa9:	75 2e                	jne    101fd9 <trap_dispatch+0x1bb>
        {
            print_trapframe(tf);
  101fab:	8b 45 08             	mov    0x8(%ebp),%eax
  101fae:	89 04 24             	mov    %eax,(%esp)
  101fb1:	e8 75 fb ff ff       	call   101b2b <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101fb6:	c7 44 24 08 ca 3c 10 	movl   $0x103cca,0x8(%esp)
  101fbd:	00 
  101fbe:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  101fc5:	00 
  101fc6:	c7 04 24 ee 3a 10 00 	movl   $0x103aee,(%esp)
  101fcd:	e8 3d e4 ff ff       	call   10040f <__panic>
        break;
  101fd2:	90                   	nop
  101fd3:	eb 04                	jmp    101fd9 <trap_dispatch+0x1bb>
        break;
  101fd5:	90                   	nop
  101fd6:	eb 01                	jmp    101fd9 <trap_dispatch+0x1bb>
        break;
  101fd8:	90                   	nop
        }
    }
}
  101fd9:	90                   	nop
  101fda:	c9                   	leave  
  101fdb:	c3                   	ret    

00101fdc <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
  101fdc:	f3 0f 1e fb          	endbr32 
  101fe0:	55                   	push   %ebp
  101fe1:	89 e5                	mov    %esp,%ebp
  101fe3:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe9:	89 04 24             	mov    %eax,(%esp)
  101fec:	e8 2d fe ff ff       	call   101e1e <trap_dispatch>
}
  101ff1:	90                   	nop
  101ff2:	c9                   	leave  
  101ff3:	c3                   	ret    

00101ff4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $0
  101ff6:	6a 00                	push   $0x0
  jmp __alltraps
  101ff8:	e9 69 0a 00 00       	jmp    102a66 <__alltraps>

00101ffd <vector1>:
.globl vector1
vector1:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $1
  101fff:	6a 01                	push   $0x1
  jmp __alltraps
  102001:	e9 60 0a 00 00       	jmp    102a66 <__alltraps>

00102006 <vector2>:
.globl vector2
vector2:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $2
  102008:	6a 02                	push   $0x2
  jmp __alltraps
  10200a:	e9 57 0a 00 00       	jmp    102a66 <__alltraps>

0010200f <vector3>:
.globl vector3
vector3:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $3
  102011:	6a 03                	push   $0x3
  jmp __alltraps
  102013:	e9 4e 0a 00 00       	jmp    102a66 <__alltraps>

00102018 <vector4>:
.globl vector4
vector4:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $4
  10201a:	6a 04                	push   $0x4
  jmp __alltraps
  10201c:	e9 45 0a 00 00       	jmp    102a66 <__alltraps>

00102021 <vector5>:
.globl vector5
vector5:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $5
  102023:	6a 05                	push   $0x5
  jmp __alltraps
  102025:	e9 3c 0a 00 00       	jmp    102a66 <__alltraps>

0010202a <vector6>:
.globl vector6
vector6:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $6
  10202c:	6a 06                	push   $0x6
  jmp __alltraps
  10202e:	e9 33 0a 00 00       	jmp    102a66 <__alltraps>

00102033 <vector7>:
.globl vector7
vector7:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $7
  102035:	6a 07                	push   $0x7
  jmp __alltraps
  102037:	e9 2a 0a 00 00       	jmp    102a66 <__alltraps>

0010203c <vector8>:
.globl vector8
vector8:
  pushl $8
  10203c:	6a 08                	push   $0x8
  jmp __alltraps
  10203e:	e9 23 0a 00 00       	jmp    102a66 <__alltraps>

00102043 <vector9>:
.globl vector9
vector9:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $9
  102045:	6a 09                	push   $0x9
  jmp __alltraps
  102047:	e9 1a 0a 00 00       	jmp    102a66 <__alltraps>

0010204c <vector10>:
.globl vector10
vector10:
  pushl $10
  10204c:	6a 0a                	push   $0xa
  jmp __alltraps
  10204e:	e9 13 0a 00 00       	jmp    102a66 <__alltraps>

00102053 <vector11>:
.globl vector11
vector11:
  pushl $11
  102053:	6a 0b                	push   $0xb
  jmp __alltraps
  102055:	e9 0c 0a 00 00       	jmp    102a66 <__alltraps>

0010205a <vector12>:
.globl vector12
vector12:
  pushl $12
  10205a:	6a 0c                	push   $0xc
  jmp __alltraps
  10205c:	e9 05 0a 00 00       	jmp    102a66 <__alltraps>

00102061 <vector13>:
.globl vector13
vector13:
  pushl $13
  102061:	6a 0d                	push   $0xd
  jmp __alltraps
  102063:	e9 fe 09 00 00       	jmp    102a66 <__alltraps>

00102068 <vector14>:
.globl vector14
vector14:
  pushl $14
  102068:	6a 0e                	push   $0xe
  jmp __alltraps
  10206a:	e9 f7 09 00 00       	jmp    102a66 <__alltraps>

0010206f <vector15>:
.globl vector15
vector15:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $15
  102071:	6a 0f                	push   $0xf
  jmp __alltraps
  102073:	e9 ee 09 00 00       	jmp    102a66 <__alltraps>

00102078 <vector16>:
.globl vector16
vector16:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $16
  10207a:	6a 10                	push   $0x10
  jmp __alltraps
  10207c:	e9 e5 09 00 00       	jmp    102a66 <__alltraps>

00102081 <vector17>:
.globl vector17
vector17:
  pushl $17
  102081:	6a 11                	push   $0x11
  jmp __alltraps
  102083:	e9 de 09 00 00       	jmp    102a66 <__alltraps>

00102088 <vector18>:
.globl vector18
vector18:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $18
  10208a:	6a 12                	push   $0x12
  jmp __alltraps
  10208c:	e9 d5 09 00 00       	jmp    102a66 <__alltraps>

00102091 <vector19>:
.globl vector19
vector19:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $19
  102093:	6a 13                	push   $0x13
  jmp __alltraps
  102095:	e9 cc 09 00 00       	jmp    102a66 <__alltraps>

0010209a <vector20>:
.globl vector20
vector20:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $20
  10209c:	6a 14                	push   $0x14
  jmp __alltraps
  10209e:	e9 c3 09 00 00       	jmp    102a66 <__alltraps>

001020a3 <vector21>:
.globl vector21
vector21:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $21
  1020a5:	6a 15                	push   $0x15
  jmp __alltraps
  1020a7:	e9 ba 09 00 00       	jmp    102a66 <__alltraps>

001020ac <vector22>:
.globl vector22
vector22:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $22
  1020ae:	6a 16                	push   $0x16
  jmp __alltraps
  1020b0:	e9 b1 09 00 00       	jmp    102a66 <__alltraps>

001020b5 <vector23>:
.globl vector23
vector23:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $23
  1020b7:	6a 17                	push   $0x17
  jmp __alltraps
  1020b9:	e9 a8 09 00 00       	jmp    102a66 <__alltraps>

001020be <vector24>:
.globl vector24
vector24:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $24
  1020c0:	6a 18                	push   $0x18
  jmp __alltraps
  1020c2:	e9 9f 09 00 00       	jmp    102a66 <__alltraps>

001020c7 <vector25>:
.globl vector25
vector25:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $25
  1020c9:	6a 19                	push   $0x19
  jmp __alltraps
  1020cb:	e9 96 09 00 00       	jmp    102a66 <__alltraps>

001020d0 <vector26>:
.globl vector26
vector26:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $26
  1020d2:	6a 1a                	push   $0x1a
  jmp __alltraps
  1020d4:	e9 8d 09 00 00       	jmp    102a66 <__alltraps>

001020d9 <vector27>:
.globl vector27
vector27:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $27
  1020db:	6a 1b                	push   $0x1b
  jmp __alltraps
  1020dd:	e9 84 09 00 00       	jmp    102a66 <__alltraps>

001020e2 <vector28>:
.globl vector28
vector28:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $28
  1020e4:	6a 1c                	push   $0x1c
  jmp __alltraps
  1020e6:	e9 7b 09 00 00       	jmp    102a66 <__alltraps>

001020eb <vector29>:
.globl vector29
vector29:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $29
  1020ed:	6a 1d                	push   $0x1d
  jmp __alltraps
  1020ef:	e9 72 09 00 00       	jmp    102a66 <__alltraps>

001020f4 <vector30>:
.globl vector30
vector30:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $30
  1020f6:	6a 1e                	push   $0x1e
  jmp __alltraps
  1020f8:	e9 69 09 00 00       	jmp    102a66 <__alltraps>

001020fd <vector31>:
.globl vector31
vector31:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $31
  1020ff:	6a 1f                	push   $0x1f
  jmp __alltraps
  102101:	e9 60 09 00 00       	jmp    102a66 <__alltraps>

00102106 <vector32>:
.globl vector32
vector32:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $32
  102108:	6a 20                	push   $0x20
  jmp __alltraps
  10210a:	e9 57 09 00 00       	jmp    102a66 <__alltraps>

0010210f <vector33>:
.globl vector33
vector33:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $33
  102111:	6a 21                	push   $0x21
  jmp __alltraps
  102113:	e9 4e 09 00 00       	jmp    102a66 <__alltraps>

00102118 <vector34>:
.globl vector34
vector34:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $34
  10211a:	6a 22                	push   $0x22
  jmp __alltraps
  10211c:	e9 45 09 00 00       	jmp    102a66 <__alltraps>

00102121 <vector35>:
.globl vector35
vector35:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $35
  102123:	6a 23                	push   $0x23
  jmp __alltraps
  102125:	e9 3c 09 00 00       	jmp    102a66 <__alltraps>

0010212a <vector36>:
.globl vector36
vector36:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $36
  10212c:	6a 24                	push   $0x24
  jmp __alltraps
  10212e:	e9 33 09 00 00       	jmp    102a66 <__alltraps>

00102133 <vector37>:
.globl vector37
vector37:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $37
  102135:	6a 25                	push   $0x25
  jmp __alltraps
  102137:	e9 2a 09 00 00       	jmp    102a66 <__alltraps>

0010213c <vector38>:
.globl vector38
vector38:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $38
  10213e:	6a 26                	push   $0x26
  jmp __alltraps
  102140:	e9 21 09 00 00       	jmp    102a66 <__alltraps>

00102145 <vector39>:
.globl vector39
vector39:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $39
  102147:	6a 27                	push   $0x27
  jmp __alltraps
  102149:	e9 18 09 00 00       	jmp    102a66 <__alltraps>

0010214e <vector40>:
.globl vector40
vector40:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $40
  102150:	6a 28                	push   $0x28
  jmp __alltraps
  102152:	e9 0f 09 00 00       	jmp    102a66 <__alltraps>

00102157 <vector41>:
.globl vector41
vector41:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $41
  102159:	6a 29                	push   $0x29
  jmp __alltraps
  10215b:	e9 06 09 00 00       	jmp    102a66 <__alltraps>

00102160 <vector42>:
.globl vector42
vector42:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $42
  102162:	6a 2a                	push   $0x2a
  jmp __alltraps
  102164:	e9 fd 08 00 00       	jmp    102a66 <__alltraps>

00102169 <vector43>:
.globl vector43
vector43:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $43
  10216b:	6a 2b                	push   $0x2b
  jmp __alltraps
  10216d:	e9 f4 08 00 00       	jmp    102a66 <__alltraps>

00102172 <vector44>:
.globl vector44
vector44:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $44
  102174:	6a 2c                	push   $0x2c
  jmp __alltraps
  102176:	e9 eb 08 00 00       	jmp    102a66 <__alltraps>

0010217b <vector45>:
.globl vector45
vector45:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $45
  10217d:	6a 2d                	push   $0x2d
  jmp __alltraps
  10217f:	e9 e2 08 00 00       	jmp    102a66 <__alltraps>

00102184 <vector46>:
.globl vector46
vector46:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $46
  102186:	6a 2e                	push   $0x2e
  jmp __alltraps
  102188:	e9 d9 08 00 00       	jmp    102a66 <__alltraps>

0010218d <vector47>:
.globl vector47
vector47:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $47
  10218f:	6a 2f                	push   $0x2f
  jmp __alltraps
  102191:	e9 d0 08 00 00       	jmp    102a66 <__alltraps>

00102196 <vector48>:
.globl vector48
vector48:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $48
  102198:	6a 30                	push   $0x30
  jmp __alltraps
  10219a:	e9 c7 08 00 00       	jmp    102a66 <__alltraps>

0010219f <vector49>:
.globl vector49
vector49:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $49
  1021a1:	6a 31                	push   $0x31
  jmp __alltraps
  1021a3:	e9 be 08 00 00       	jmp    102a66 <__alltraps>

001021a8 <vector50>:
.globl vector50
vector50:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $50
  1021aa:	6a 32                	push   $0x32
  jmp __alltraps
  1021ac:	e9 b5 08 00 00       	jmp    102a66 <__alltraps>

001021b1 <vector51>:
.globl vector51
vector51:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $51
  1021b3:	6a 33                	push   $0x33
  jmp __alltraps
  1021b5:	e9 ac 08 00 00       	jmp    102a66 <__alltraps>

001021ba <vector52>:
.globl vector52
vector52:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $52
  1021bc:	6a 34                	push   $0x34
  jmp __alltraps
  1021be:	e9 a3 08 00 00       	jmp    102a66 <__alltraps>

001021c3 <vector53>:
.globl vector53
vector53:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $53
  1021c5:	6a 35                	push   $0x35
  jmp __alltraps
  1021c7:	e9 9a 08 00 00       	jmp    102a66 <__alltraps>

001021cc <vector54>:
.globl vector54
vector54:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $54
  1021ce:	6a 36                	push   $0x36
  jmp __alltraps
  1021d0:	e9 91 08 00 00       	jmp    102a66 <__alltraps>

001021d5 <vector55>:
.globl vector55
vector55:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $55
  1021d7:	6a 37                	push   $0x37
  jmp __alltraps
  1021d9:	e9 88 08 00 00       	jmp    102a66 <__alltraps>

001021de <vector56>:
.globl vector56
vector56:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $56
  1021e0:	6a 38                	push   $0x38
  jmp __alltraps
  1021e2:	e9 7f 08 00 00       	jmp    102a66 <__alltraps>

001021e7 <vector57>:
.globl vector57
vector57:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $57
  1021e9:	6a 39                	push   $0x39
  jmp __alltraps
  1021eb:	e9 76 08 00 00       	jmp    102a66 <__alltraps>

001021f0 <vector58>:
.globl vector58
vector58:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $58
  1021f2:	6a 3a                	push   $0x3a
  jmp __alltraps
  1021f4:	e9 6d 08 00 00       	jmp    102a66 <__alltraps>

001021f9 <vector59>:
.globl vector59
vector59:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $59
  1021fb:	6a 3b                	push   $0x3b
  jmp __alltraps
  1021fd:	e9 64 08 00 00       	jmp    102a66 <__alltraps>

00102202 <vector60>:
.globl vector60
vector60:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $60
  102204:	6a 3c                	push   $0x3c
  jmp __alltraps
  102206:	e9 5b 08 00 00       	jmp    102a66 <__alltraps>

0010220b <vector61>:
.globl vector61
vector61:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $61
  10220d:	6a 3d                	push   $0x3d
  jmp __alltraps
  10220f:	e9 52 08 00 00       	jmp    102a66 <__alltraps>

00102214 <vector62>:
.globl vector62
vector62:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $62
  102216:	6a 3e                	push   $0x3e
  jmp __alltraps
  102218:	e9 49 08 00 00       	jmp    102a66 <__alltraps>

0010221d <vector63>:
.globl vector63
vector63:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $63
  10221f:	6a 3f                	push   $0x3f
  jmp __alltraps
  102221:	e9 40 08 00 00       	jmp    102a66 <__alltraps>

00102226 <vector64>:
.globl vector64
vector64:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $64
  102228:	6a 40                	push   $0x40
  jmp __alltraps
  10222a:	e9 37 08 00 00       	jmp    102a66 <__alltraps>

0010222f <vector65>:
.globl vector65
vector65:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $65
  102231:	6a 41                	push   $0x41
  jmp __alltraps
  102233:	e9 2e 08 00 00       	jmp    102a66 <__alltraps>

00102238 <vector66>:
.globl vector66
vector66:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $66
  10223a:	6a 42                	push   $0x42
  jmp __alltraps
  10223c:	e9 25 08 00 00       	jmp    102a66 <__alltraps>

00102241 <vector67>:
.globl vector67
vector67:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $67
  102243:	6a 43                	push   $0x43
  jmp __alltraps
  102245:	e9 1c 08 00 00       	jmp    102a66 <__alltraps>

0010224a <vector68>:
.globl vector68
vector68:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $68
  10224c:	6a 44                	push   $0x44
  jmp __alltraps
  10224e:	e9 13 08 00 00       	jmp    102a66 <__alltraps>

00102253 <vector69>:
.globl vector69
vector69:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $69
  102255:	6a 45                	push   $0x45
  jmp __alltraps
  102257:	e9 0a 08 00 00       	jmp    102a66 <__alltraps>

0010225c <vector70>:
.globl vector70
vector70:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $70
  10225e:	6a 46                	push   $0x46
  jmp __alltraps
  102260:	e9 01 08 00 00       	jmp    102a66 <__alltraps>

00102265 <vector71>:
.globl vector71
vector71:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $71
  102267:	6a 47                	push   $0x47
  jmp __alltraps
  102269:	e9 f8 07 00 00       	jmp    102a66 <__alltraps>

0010226e <vector72>:
.globl vector72
vector72:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $72
  102270:	6a 48                	push   $0x48
  jmp __alltraps
  102272:	e9 ef 07 00 00       	jmp    102a66 <__alltraps>

00102277 <vector73>:
.globl vector73
vector73:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $73
  102279:	6a 49                	push   $0x49
  jmp __alltraps
  10227b:	e9 e6 07 00 00       	jmp    102a66 <__alltraps>

00102280 <vector74>:
.globl vector74
vector74:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $74
  102282:	6a 4a                	push   $0x4a
  jmp __alltraps
  102284:	e9 dd 07 00 00       	jmp    102a66 <__alltraps>

00102289 <vector75>:
.globl vector75
vector75:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $75
  10228b:	6a 4b                	push   $0x4b
  jmp __alltraps
  10228d:	e9 d4 07 00 00       	jmp    102a66 <__alltraps>

00102292 <vector76>:
.globl vector76
vector76:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $76
  102294:	6a 4c                	push   $0x4c
  jmp __alltraps
  102296:	e9 cb 07 00 00       	jmp    102a66 <__alltraps>

0010229b <vector77>:
.globl vector77
vector77:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $77
  10229d:	6a 4d                	push   $0x4d
  jmp __alltraps
  10229f:	e9 c2 07 00 00       	jmp    102a66 <__alltraps>

001022a4 <vector78>:
.globl vector78
vector78:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $78
  1022a6:	6a 4e                	push   $0x4e
  jmp __alltraps
  1022a8:	e9 b9 07 00 00       	jmp    102a66 <__alltraps>

001022ad <vector79>:
.globl vector79
vector79:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $79
  1022af:	6a 4f                	push   $0x4f
  jmp __alltraps
  1022b1:	e9 b0 07 00 00       	jmp    102a66 <__alltraps>

001022b6 <vector80>:
.globl vector80
vector80:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $80
  1022b8:	6a 50                	push   $0x50
  jmp __alltraps
  1022ba:	e9 a7 07 00 00       	jmp    102a66 <__alltraps>

001022bf <vector81>:
.globl vector81
vector81:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $81
  1022c1:	6a 51                	push   $0x51
  jmp __alltraps
  1022c3:	e9 9e 07 00 00       	jmp    102a66 <__alltraps>

001022c8 <vector82>:
.globl vector82
vector82:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $82
  1022ca:	6a 52                	push   $0x52
  jmp __alltraps
  1022cc:	e9 95 07 00 00       	jmp    102a66 <__alltraps>

001022d1 <vector83>:
.globl vector83
vector83:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $83
  1022d3:	6a 53                	push   $0x53
  jmp __alltraps
  1022d5:	e9 8c 07 00 00       	jmp    102a66 <__alltraps>

001022da <vector84>:
.globl vector84
vector84:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $84
  1022dc:	6a 54                	push   $0x54
  jmp __alltraps
  1022de:	e9 83 07 00 00       	jmp    102a66 <__alltraps>

001022e3 <vector85>:
.globl vector85
vector85:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $85
  1022e5:	6a 55                	push   $0x55
  jmp __alltraps
  1022e7:	e9 7a 07 00 00       	jmp    102a66 <__alltraps>

001022ec <vector86>:
.globl vector86
vector86:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $86
  1022ee:	6a 56                	push   $0x56
  jmp __alltraps
  1022f0:	e9 71 07 00 00       	jmp    102a66 <__alltraps>

001022f5 <vector87>:
.globl vector87
vector87:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $87
  1022f7:	6a 57                	push   $0x57
  jmp __alltraps
  1022f9:	e9 68 07 00 00       	jmp    102a66 <__alltraps>

001022fe <vector88>:
.globl vector88
vector88:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $88
  102300:	6a 58                	push   $0x58
  jmp __alltraps
  102302:	e9 5f 07 00 00       	jmp    102a66 <__alltraps>

00102307 <vector89>:
.globl vector89
vector89:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $89
  102309:	6a 59                	push   $0x59
  jmp __alltraps
  10230b:	e9 56 07 00 00       	jmp    102a66 <__alltraps>

00102310 <vector90>:
.globl vector90
vector90:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $90
  102312:	6a 5a                	push   $0x5a
  jmp __alltraps
  102314:	e9 4d 07 00 00       	jmp    102a66 <__alltraps>

00102319 <vector91>:
.globl vector91
vector91:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $91
  10231b:	6a 5b                	push   $0x5b
  jmp __alltraps
  10231d:	e9 44 07 00 00       	jmp    102a66 <__alltraps>

00102322 <vector92>:
.globl vector92
vector92:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $92
  102324:	6a 5c                	push   $0x5c
  jmp __alltraps
  102326:	e9 3b 07 00 00       	jmp    102a66 <__alltraps>

0010232b <vector93>:
.globl vector93
vector93:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $93
  10232d:	6a 5d                	push   $0x5d
  jmp __alltraps
  10232f:	e9 32 07 00 00       	jmp    102a66 <__alltraps>

00102334 <vector94>:
.globl vector94
vector94:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $94
  102336:	6a 5e                	push   $0x5e
  jmp __alltraps
  102338:	e9 29 07 00 00       	jmp    102a66 <__alltraps>

0010233d <vector95>:
.globl vector95
vector95:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $95
  10233f:	6a 5f                	push   $0x5f
  jmp __alltraps
  102341:	e9 20 07 00 00       	jmp    102a66 <__alltraps>

00102346 <vector96>:
.globl vector96
vector96:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $96
  102348:	6a 60                	push   $0x60
  jmp __alltraps
  10234a:	e9 17 07 00 00       	jmp    102a66 <__alltraps>

0010234f <vector97>:
.globl vector97
vector97:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $97
  102351:	6a 61                	push   $0x61
  jmp __alltraps
  102353:	e9 0e 07 00 00       	jmp    102a66 <__alltraps>

00102358 <vector98>:
.globl vector98
vector98:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $98
  10235a:	6a 62                	push   $0x62
  jmp __alltraps
  10235c:	e9 05 07 00 00       	jmp    102a66 <__alltraps>

00102361 <vector99>:
.globl vector99
vector99:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $99
  102363:	6a 63                	push   $0x63
  jmp __alltraps
  102365:	e9 fc 06 00 00       	jmp    102a66 <__alltraps>

0010236a <vector100>:
.globl vector100
vector100:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $100
  10236c:	6a 64                	push   $0x64
  jmp __alltraps
  10236e:	e9 f3 06 00 00       	jmp    102a66 <__alltraps>

00102373 <vector101>:
.globl vector101
vector101:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $101
  102375:	6a 65                	push   $0x65
  jmp __alltraps
  102377:	e9 ea 06 00 00       	jmp    102a66 <__alltraps>

0010237c <vector102>:
.globl vector102
vector102:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $102
  10237e:	6a 66                	push   $0x66
  jmp __alltraps
  102380:	e9 e1 06 00 00       	jmp    102a66 <__alltraps>

00102385 <vector103>:
.globl vector103
vector103:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $103
  102387:	6a 67                	push   $0x67
  jmp __alltraps
  102389:	e9 d8 06 00 00       	jmp    102a66 <__alltraps>

0010238e <vector104>:
.globl vector104
vector104:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $104
  102390:	6a 68                	push   $0x68
  jmp __alltraps
  102392:	e9 cf 06 00 00       	jmp    102a66 <__alltraps>

00102397 <vector105>:
.globl vector105
vector105:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $105
  102399:	6a 69                	push   $0x69
  jmp __alltraps
  10239b:	e9 c6 06 00 00       	jmp    102a66 <__alltraps>

001023a0 <vector106>:
.globl vector106
vector106:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $106
  1023a2:	6a 6a                	push   $0x6a
  jmp __alltraps
  1023a4:	e9 bd 06 00 00       	jmp    102a66 <__alltraps>

001023a9 <vector107>:
.globl vector107
vector107:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $107
  1023ab:	6a 6b                	push   $0x6b
  jmp __alltraps
  1023ad:	e9 b4 06 00 00       	jmp    102a66 <__alltraps>

001023b2 <vector108>:
.globl vector108
vector108:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $108
  1023b4:	6a 6c                	push   $0x6c
  jmp __alltraps
  1023b6:	e9 ab 06 00 00       	jmp    102a66 <__alltraps>

001023bb <vector109>:
.globl vector109
vector109:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $109
  1023bd:	6a 6d                	push   $0x6d
  jmp __alltraps
  1023bf:	e9 a2 06 00 00       	jmp    102a66 <__alltraps>

001023c4 <vector110>:
.globl vector110
vector110:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $110
  1023c6:	6a 6e                	push   $0x6e
  jmp __alltraps
  1023c8:	e9 99 06 00 00       	jmp    102a66 <__alltraps>

001023cd <vector111>:
.globl vector111
vector111:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $111
  1023cf:	6a 6f                	push   $0x6f
  jmp __alltraps
  1023d1:	e9 90 06 00 00       	jmp    102a66 <__alltraps>

001023d6 <vector112>:
.globl vector112
vector112:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $112
  1023d8:	6a 70                	push   $0x70
  jmp __alltraps
  1023da:	e9 87 06 00 00       	jmp    102a66 <__alltraps>

001023df <vector113>:
.globl vector113
vector113:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $113
  1023e1:	6a 71                	push   $0x71
  jmp __alltraps
  1023e3:	e9 7e 06 00 00       	jmp    102a66 <__alltraps>

001023e8 <vector114>:
.globl vector114
vector114:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $114
  1023ea:	6a 72                	push   $0x72
  jmp __alltraps
  1023ec:	e9 75 06 00 00       	jmp    102a66 <__alltraps>

001023f1 <vector115>:
.globl vector115
vector115:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $115
  1023f3:	6a 73                	push   $0x73
  jmp __alltraps
  1023f5:	e9 6c 06 00 00       	jmp    102a66 <__alltraps>

001023fa <vector116>:
.globl vector116
vector116:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $116
  1023fc:	6a 74                	push   $0x74
  jmp __alltraps
  1023fe:	e9 63 06 00 00       	jmp    102a66 <__alltraps>

00102403 <vector117>:
.globl vector117
vector117:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $117
  102405:	6a 75                	push   $0x75
  jmp __alltraps
  102407:	e9 5a 06 00 00       	jmp    102a66 <__alltraps>

0010240c <vector118>:
.globl vector118
vector118:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $118
  10240e:	6a 76                	push   $0x76
  jmp __alltraps
  102410:	e9 51 06 00 00       	jmp    102a66 <__alltraps>

00102415 <vector119>:
.globl vector119
vector119:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $119
  102417:	6a 77                	push   $0x77
  jmp __alltraps
  102419:	e9 48 06 00 00       	jmp    102a66 <__alltraps>

0010241e <vector120>:
.globl vector120
vector120:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $120
  102420:	6a 78                	push   $0x78
  jmp __alltraps
  102422:	e9 3f 06 00 00       	jmp    102a66 <__alltraps>

00102427 <vector121>:
.globl vector121
vector121:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $121
  102429:	6a 79                	push   $0x79
  jmp __alltraps
  10242b:	e9 36 06 00 00       	jmp    102a66 <__alltraps>

00102430 <vector122>:
.globl vector122
vector122:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $122
  102432:	6a 7a                	push   $0x7a
  jmp __alltraps
  102434:	e9 2d 06 00 00       	jmp    102a66 <__alltraps>

00102439 <vector123>:
.globl vector123
vector123:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $123
  10243b:	6a 7b                	push   $0x7b
  jmp __alltraps
  10243d:	e9 24 06 00 00       	jmp    102a66 <__alltraps>

00102442 <vector124>:
.globl vector124
vector124:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $124
  102444:	6a 7c                	push   $0x7c
  jmp __alltraps
  102446:	e9 1b 06 00 00       	jmp    102a66 <__alltraps>

0010244b <vector125>:
.globl vector125
vector125:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $125
  10244d:	6a 7d                	push   $0x7d
  jmp __alltraps
  10244f:	e9 12 06 00 00       	jmp    102a66 <__alltraps>

00102454 <vector126>:
.globl vector126
vector126:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $126
  102456:	6a 7e                	push   $0x7e
  jmp __alltraps
  102458:	e9 09 06 00 00       	jmp    102a66 <__alltraps>

0010245d <vector127>:
.globl vector127
vector127:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $127
  10245f:	6a 7f                	push   $0x7f
  jmp __alltraps
  102461:	e9 00 06 00 00       	jmp    102a66 <__alltraps>

00102466 <vector128>:
.globl vector128
vector128:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $128
  102468:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10246d:	e9 f4 05 00 00       	jmp    102a66 <__alltraps>

00102472 <vector129>:
.globl vector129
vector129:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $129
  102474:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102479:	e9 e8 05 00 00       	jmp    102a66 <__alltraps>

0010247e <vector130>:
.globl vector130
vector130:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $130
  102480:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102485:	e9 dc 05 00 00       	jmp    102a66 <__alltraps>

0010248a <vector131>:
.globl vector131
vector131:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $131
  10248c:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102491:	e9 d0 05 00 00       	jmp    102a66 <__alltraps>

00102496 <vector132>:
.globl vector132
vector132:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $132
  102498:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10249d:	e9 c4 05 00 00       	jmp    102a66 <__alltraps>

001024a2 <vector133>:
.globl vector133
vector133:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $133
  1024a4:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1024a9:	e9 b8 05 00 00       	jmp    102a66 <__alltraps>

001024ae <vector134>:
.globl vector134
vector134:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $134
  1024b0:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1024b5:	e9 ac 05 00 00       	jmp    102a66 <__alltraps>

001024ba <vector135>:
.globl vector135
vector135:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $135
  1024bc:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1024c1:	e9 a0 05 00 00       	jmp    102a66 <__alltraps>

001024c6 <vector136>:
.globl vector136
vector136:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $136
  1024c8:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1024cd:	e9 94 05 00 00       	jmp    102a66 <__alltraps>

001024d2 <vector137>:
.globl vector137
vector137:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $137
  1024d4:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1024d9:	e9 88 05 00 00       	jmp    102a66 <__alltraps>

001024de <vector138>:
.globl vector138
vector138:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $138
  1024e0:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1024e5:	e9 7c 05 00 00       	jmp    102a66 <__alltraps>

001024ea <vector139>:
.globl vector139
vector139:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $139
  1024ec:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1024f1:	e9 70 05 00 00       	jmp    102a66 <__alltraps>

001024f6 <vector140>:
.globl vector140
vector140:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $140
  1024f8:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1024fd:	e9 64 05 00 00       	jmp    102a66 <__alltraps>

00102502 <vector141>:
.globl vector141
vector141:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $141
  102504:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102509:	e9 58 05 00 00       	jmp    102a66 <__alltraps>

0010250e <vector142>:
.globl vector142
vector142:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $142
  102510:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102515:	e9 4c 05 00 00       	jmp    102a66 <__alltraps>

0010251a <vector143>:
.globl vector143
vector143:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $143
  10251c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102521:	e9 40 05 00 00       	jmp    102a66 <__alltraps>

00102526 <vector144>:
.globl vector144
vector144:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $144
  102528:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10252d:	e9 34 05 00 00       	jmp    102a66 <__alltraps>

00102532 <vector145>:
.globl vector145
vector145:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $145
  102534:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102539:	e9 28 05 00 00       	jmp    102a66 <__alltraps>

0010253e <vector146>:
.globl vector146
vector146:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $146
  102540:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102545:	e9 1c 05 00 00       	jmp    102a66 <__alltraps>

0010254a <vector147>:
.globl vector147
vector147:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $147
  10254c:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102551:	e9 10 05 00 00       	jmp    102a66 <__alltraps>

00102556 <vector148>:
.globl vector148
vector148:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $148
  102558:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10255d:	e9 04 05 00 00       	jmp    102a66 <__alltraps>

00102562 <vector149>:
.globl vector149
vector149:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $149
  102564:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102569:	e9 f8 04 00 00       	jmp    102a66 <__alltraps>

0010256e <vector150>:
.globl vector150
vector150:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $150
  102570:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102575:	e9 ec 04 00 00       	jmp    102a66 <__alltraps>

0010257a <vector151>:
.globl vector151
vector151:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $151
  10257c:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102581:	e9 e0 04 00 00       	jmp    102a66 <__alltraps>

00102586 <vector152>:
.globl vector152
vector152:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $152
  102588:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10258d:	e9 d4 04 00 00       	jmp    102a66 <__alltraps>

00102592 <vector153>:
.globl vector153
vector153:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $153
  102594:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102599:	e9 c8 04 00 00       	jmp    102a66 <__alltraps>

0010259e <vector154>:
.globl vector154
vector154:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $154
  1025a0:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1025a5:	e9 bc 04 00 00       	jmp    102a66 <__alltraps>

001025aa <vector155>:
.globl vector155
vector155:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $155
  1025ac:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1025b1:	e9 b0 04 00 00       	jmp    102a66 <__alltraps>

001025b6 <vector156>:
.globl vector156
vector156:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $156
  1025b8:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1025bd:	e9 a4 04 00 00       	jmp    102a66 <__alltraps>

001025c2 <vector157>:
.globl vector157
vector157:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $157
  1025c4:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1025c9:	e9 98 04 00 00       	jmp    102a66 <__alltraps>

001025ce <vector158>:
.globl vector158
vector158:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $158
  1025d0:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1025d5:	e9 8c 04 00 00       	jmp    102a66 <__alltraps>

001025da <vector159>:
.globl vector159
vector159:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $159
  1025dc:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1025e1:	e9 80 04 00 00       	jmp    102a66 <__alltraps>

001025e6 <vector160>:
.globl vector160
vector160:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $160
  1025e8:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1025ed:	e9 74 04 00 00       	jmp    102a66 <__alltraps>

001025f2 <vector161>:
.globl vector161
vector161:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $161
  1025f4:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1025f9:	e9 68 04 00 00       	jmp    102a66 <__alltraps>

001025fe <vector162>:
.globl vector162
vector162:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $162
  102600:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102605:	e9 5c 04 00 00       	jmp    102a66 <__alltraps>

0010260a <vector163>:
.globl vector163
vector163:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $163
  10260c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102611:	e9 50 04 00 00       	jmp    102a66 <__alltraps>

00102616 <vector164>:
.globl vector164
vector164:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $164
  102618:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10261d:	e9 44 04 00 00       	jmp    102a66 <__alltraps>

00102622 <vector165>:
.globl vector165
vector165:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $165
  102624:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102629:	e9 38 04 00 00       	jmp    102a66 <__alltraps>

0010262e <vector166>:
.globl vector166
vector166:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $166
  102630:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102635:	e9 2c 04 00 00       	jmp    102a66 <__alltraps>

0010263a <vector167>:
.globl vector167
vector167:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $167
  10263c:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102641:	e9 20 04 00 00       	jmp    102a66 <__alltraps>

00102646 <vector168>:
.globl vector168
vector168:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $168
  102648:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10264d:	e9 14 04 00 00       	jmp    102a66 <__alltraps>

00102652 <vector169>:
.globl vector169
vector169:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $169
  102654:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102659:	e9 08 04 00 00       	jmp    102a66 <__alltraps>

0010265e <vector170>:
.globl vector170
vector170:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $170
  102660:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102665:	e9 fc 03 00 00       	jmp    102a66 <__alltraps>

0010266a <vector171>:
.globl vector171
vector171:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $171
  10266c:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102671:	e9 f0 03 00 00       	jmp    102a66 <__alltraps>

00102676 <vector172>:
.globl vector172
vector172:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $172
  102678:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10267d:	e9 e4 03 00 00       	jmp    102a66 <__alltraps>

00102682 <vector173>:
.globl vector173
vector173:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $173
  102684:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102689:	e9 d8 03 00 00       	jmp    102a66 <__alltraps>

0010268e <vector174>:
.globl vector174
vector174:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $174
  102690:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102695:	e9 cc 03 00 00       	jmp    102a66 <__alltraps>

0010269a <vector175>:
.globl vector175
vector175:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $175
  10269c:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1026a1:	e9 c0 03 00 00       	jmp    102a66 <__alltraps>

001026a6 <vector176>:
.globl vector176
vector176:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $176
  1026a8:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1026ad:	e9 b4 03 00 00       	jmp    102a66 <__alltraps>

001026b2 <vector177>:
.globl vector177
vector177:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $177
  1026b4:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1026b9:	e9 a8 03 00 00       	jmp    102a66 <__alltraps>

001026be <vector178>:
.globl vector178
vector178:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $178
  1026c0:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1026c5:	e9 9c 03 00 00       	jmp    102a66 <__alltraps>

001026ca <vector179>:
.globl vector179
vector179:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $179
  1026cc:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1026d1:	e9 90 03 00 00       	jmp    102a66 <__alltraps>

001026d6 <vector180>:
.globl vector180
vector180:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $180
  1026d8:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1026dd:	e9 84 03 00 00       	jmp    102a66 <__alltraps>

001026e2 <vector181>:
.globl vector181
vector181:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $181
  1026e4:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1026e9:	e9 78 03 00 00       	jmp    102a66 <__alltraps>

001026ee <vector182>:
.globl vector182
vector182:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $182
  1026f0:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1026f5:	e9 6c 03 00 00       	jmp    102a66 <__alltraps>

001026fa <vector183>:
.globl vector183
vector183:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $183
  1026fc:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102701:	e9 60 03 00 00       	jmp    102a66 <__alltraps>

00102706 <vector184>:
.globl vector184
vector184:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $184
  102708:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10270d:	e9 54 03 00 00       	jmp    102a66 <__alltraps>

00102712 <vector185>:
.globl vector185
vector185:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $185
  102714:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102719:	e9 48 03 00 00       	jmp    102a66 <__alltraps>

0010271e <vector186>:
.globl vector186
vector186:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $186
  102720:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102725:	e9 3c 03 00 00       	jmp    102a66 <__alltraps>

0010272a <vector187>:
.globl vector187
vector187:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $187
  10272c:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102731:	e9 30 03 00 00       	jmp    102a66 <__alltraps>

00102736 <vector188>:
.globl vector188
vector188:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $188
  102738:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10273d:	e9 24 03 00 00       	jmp    102a66 <__alltraps>

00102742 <vector189>:
.globl vector189
vector189:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $189
  102744:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102749:	e9 18 03 00 00       	jmp    102a66 <__alltraps>

0010274e <vector190>:
.globl vector190
vector190:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $190
  102750:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102755:	e9 0c 03 00 00       	jmp    102a66 <__alltraps>

0010275a <vector191>:
.globl vector191
vector191:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $191
  10275c:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102761:	e9 00 03 00 00       	jmp    102a66 <__alltraps>

00102766 <vector192>:
.globl vector192
vector192:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $192
  102768:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10276d:	e9 f4 02 00 00       	jmp    102a66 <__alltraps>

00102772 <vector193>:
.globl vector193
vector193:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $193
  102774:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102779:	e9 e8 02 00 00       	jmp    102a66 <__alltraps>

0010277e <vector194>:
.globl vector194
vector194:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $194
  102780:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102785:	e9 dc 02 00 00       	jmp    102a66 <__alltraps>

0010278a <vector195>:
.globl vector195
vector195:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $195
  10278c:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102791:	e9 d0 02 00 00       	jmp    102a66 <__alltraps>

00102796 <vector196>:
.globl vector196
vector196:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $196
  102798:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10279d:	e9 c4 02 00 00       	jmp    102a66 <__alltraps>

001027a2 <vector197>:
.globl vector197
vector197:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $197
  1027a4:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1027a9:	e9 b8 02 00 00       	jmp    102a66 <__alltraps>

001027ae <vector198>:
.globl vector198
vector198:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $198
  1027b0:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1027b5:	e9 ac 02 00 00       	jmp    102a66 <__alltraps>

001027ba <vector199>:
.globl vector199
vector199:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $199
  1027bc:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1027c1:	e9 a0 02 00 00       	jmp    102a66 <__alltraps>

001027c6 <vector200>:
.globl vector200
vector200:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $200
  1027c8:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1027cd:	e9 94 02 00 00       	jmp    102a66 <__alltraps>

001027d2 <vector201>:
.globl vector201
vector201:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $201
  1027d4:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1027d9:	e9 88 02 00 00       	jmp    102a66 <__alltraps>

001027de <vector202>:
.globl vector202
vector202:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $202
  1027e0:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1027e5:	e9 7c 02 00 00       	jmp    102a66 <__alltraps>

001027ea <vector203>:
.globl vector203
vector203:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $203
  1027ec:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1027f1:	e9 70 02 00 00       	jmp    102a66 <__alltraps>

001027f6 <vector204>:
.globl vector204
vector204:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $204
  1027f8:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1027fd:	e9 64 02 00 00       	jmp    102a66 <__alltraps>

00102802 <vector205>:
.globl vector205
vector205:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $205
  102804:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102809:	e9 58 02 00 00       	jmp    102a66 <__alltraps>

0010280e <vector206>:
.globl vector206
vector206:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $206
  102810:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102815:	e9 4c 02 00 00       	jmp    102a66 <__alltraps>

0010281a <vector207>:
.globl vector207
vector207:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $207
  10281c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102821:	e9 40 02 00 00       	jmp    102a66 <__alltraps>

00102826 <vector208>:
.globl vector208
vector208:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $208
  102828:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10282d:	e9 34 02 00 00       	jmp    102a66 <__alltraps>

00102832 <vector209>:
.globl vector209
vector209:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $209
  102834:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102839:	e9 28 02 00 00       	jmp    102a66 <__alltraps>

0010283e <vector210>:
.globl vector210
vector210:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $210
  102840:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102845:	e9 1c 02 00 00       	jmp    102a66 <__alltraps>

0010284a <vector211>:
.globl vector211
vector211:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $211
  10284c:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102851:	e9 10 02 00 00       	jmp    102a66 <__alltraps>

00102856 <vector212>:
.globl vector212
vector212:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $212
  102858:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10285d:	e9 04 02 00 00       	jmp    102a66 <__alltraps>

00102862 <vector213>:
.globl vector213
vector213:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $213
  102864:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102869:	e9 f8 01 00 00       	jmp    102a66 <__alltraps>

0010286e <vector214>:
.globl vector214
vector214:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $214
  102870:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102875:	e9 ec 01 00 00       	jmp    102a66 <__alltraps>

0010287a <vector215>:
.globl vector215
vector215:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $215
  10287c:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102881:	e9 e0 01 00 00       	jmp    102a66 <__alltraps>

00102886 <vector216>:
.globl vector216
vector216:
  pushl $0
  102886:	6a 00                	push   $0x0
  pushl $216
  102888:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10288d:	e9 d4 01 00 00       	jmp    102a66 <__alltraps>

00102892 <vector217>:
.globl vector217
vector217:
  pushl $0
  102892:	6a 00                	push   $0x0
  pushl $217
  102894:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102899:	e9 c8 01 00 00       	jmp    102a66 <__alltraps>

0010289e <vector218>:
.globl vector218
vector218:
  pushl $0
  10289e:	6a 00                	push   $0x0
  pushl $218
  1028a0:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1028a5:	e9 bc 01 00 00       	jmp    102a66 <__alltraps>

001028aa <vector219>:
.globl vector219
vector219:
  pushl $0
  1028aa:	6a 00                	push   $0x0
  pushl $219
  1028ac:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1028b1:	e9 b0 01 00 00       	jmp    102a66 <__alltraps>

001028b6 <vector220>:
.globl vector220
vector220:
  pushl $0
  1028b6:	6a 00                	push   $0x0
  pushl $220
  1028b8:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1028bd:	e9 a4 01 00 00       	jmp    102a66 <__alltraps>

001028c2 <vector221>:
.globl vector221
vector221:
  pushl $0
  1028c2:	6a 00                	push   $0x0
  pushl $221
  1028c4:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1028c9:	e9 98 01 00 00       	jmp    102a66 <__alltraps>

001028ce <vector222>:
.globl vector222
vector222:
  pushl $0
  1028ce:	6a 00                	push   $0x0
  pushl $222
  1028d0:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1028d5:	e9 8c 01 00 00       	jmp    102a66 <__alltraps>

001028da <vector223>:
.globl vector223
vector223:
  pushl $0
  1028da:	6a 00                	push   $0x0
  pushl $223
  1028dc:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1028e1:	e9 80 01 00 00       	jmp    102a66 <__alltraps>

001028e6 <vector224>:
.globl vector224
vector224:
  pushl $0
  1028e6:	6a 00                	push   $0x0
  pushl $224
  1028e8:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1028ed:	e9 74 01 00 00       	jmp    102a66 <__alltraps>

001028f2 <vector225>:
.globl vector225
vector225:
  pushl $0
  1028f2:	6a 00                	push   $0x0
  pushl $225
  1028f4:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1028f9:	e9 68 01 00 00       	jmp    102a66 <__alltraps>

001028fe <vector226>:
.globl vector226
vector226:
  pushl $0
  1028fe:	6a 00                	push   $0x0
  pushl $226
  102900:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102905:	e9 5c 01 00 00       	jmp    102a66 <__alltraps>

0010290a <vector227>:
.globl vector227
vector227:
  pushl $0
  10290a:	6a 00                	push   $0x0
  pushl $227
  10290c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102911:	e9 50 01 00 00       	jmp    102a66 <__alltraps>

00102916 <vector228>:
.globl vector228
vector228:
  pushl $0
  102916:	6a 00                	push   $0x0
  pushl $228
  102918:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10291d:	e9 44 01 00 00       	jmp    102a66 <__alltraps>

00102922 <vector229>:
.globl vector229
vector229:
  pushl $0
  102922:	6a 00                	push   $0x0
  pushl $229
  102924:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102929:	e9 38 01 00 00       	jmp    102a66 <__alltraps>

0010292e <vector230>:
.globl vector230
vector230:
  pushl $0
  10292e:	6a 00                	push   $0x0
  pushl $230
  102930:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102935:	e9 2c 01 00 00       	jmp    102a66 <__alltraps>

0010293a <vector231>:
.globl vector231
vector231:
  pushl $0
  10293a:	6a 00                	push   $0x0
  pushl $231
  10293c:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102941:	e9 20 01 00 00       	jmp    102a66 <__alltraps>

00102946 <vector232>:
.globl vector232
vector232:
  pushl $0
  102946:	6a 00                	push   $0x0
  pushl $232
  102948:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10294d:	e9 14 01 00 00       	jmp    102a66 <__alltraps>

00102952 <vector233>:
.globl vector233
vector233:
  pushl $0
  102952:	6a 00                	push   $0x0
  pushl $233
  102954:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102959:	e9 08 01 00 00       	jmp    102a66 <__alltraps>

0010295e <vector234>:
.globl vector234
vector234:
  pushl $0
  10295e:	6a 00                	push   $0x0
  pushl $234
  102960:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102965:	e9 fc 00 00 00       	jmp    102a66 <__alltraps>

0010296a <vector235>:
.globl vector235
vector235:
  pushl $0
  10296a:	6a 00                	push   $0x0
  pushl $235
  10296c:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102971:	e9 f0 00 00 00       	jmp    102a66 <__alltraps>

00102976 <vector236>:
.globl vector236
vector236:
  pushl $0
  102976:	6a 00                	push   $0x0
  pushl $236
  102978:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10297d:	e9 e4 00 00 00       	jmp    102a66 <__alltraps>

00102982 <vector237>:
.globl vector237
vector237:
  pushl $0
  102982:	6a 00                	push   $0x0
  pushl $237
  102984:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102989:	e9 d8 00 00 00       	jmp    102a66 <__alltraps>

0010298e <vector238>:
.globl vector238
vector238:
  pushl $0
  10298e:	6a 00                	push   $0x0
  pushl $238
  102990:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102995:	e9 cc 00 00 00       	jmp    102a66 <__alltraps>

0010299a <vector239>:
.globl vector239
vector239:
  pushl $0
  10299a:	6a 00                	push   $0x0
  pushl $239
  10299c:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1029a1:	e9 c0 00 00 00       	jmp    102a66 <__alltraps>

001029a6 <vector240>:
.globl vector240
vector240:
  pushl $0
  1029a6:	6a 00                	push   $0x0
  pushl $240
  1029a8:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1029ad:	e9 b4 00 00 00       	jmp    102a66 <__alltraps>

001029b2 <vector241>:
.globl vector241
vector241:
  pushl $0
  1029b2:	6a 00                	push   $0x0
  pushl $241
  1029b4:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1029b9:	e9 a8 00 00 00       	jmp    102a66 <__alltraps>

001029be <vector242>:
.globl vector242
vector242:
  pushl $0
  1029be:	6a 00                	push   $0x0
  pushl $242
  1029c0:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1029c5:	e9 9c 00 00 00       	jmp    102a66 <__alltraps>

001029ca <vector243>:
.globl vector243
vector243:
  pushl $0
  1029ca:	6a 00                	push   $0x0
  pushl $243
  1029cc:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1029d1:	e9 90 00 00 00       	jmp    102a66 <__alltraps>

001029d6 <vector244>:
.globl vector244
vector244:
  pushl $0
  1029d6:	6a 00                	push   $0x0
  pushl $244
  1029d8:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1029dd:	e9 84 00 00 00       	jmp    102a66 <__alltraps>

001029e2 <vector245>:
.globl vector245
vector245:
  pushl $0
  1029e2:	6a 00                	push   $0x0
  pushl $245
  1029e4:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1029e9:	e9 78 00 00 00       	jmp    102a66 <__alltraps>

001029ee <vector246>:
.globl vector246
vector246:
  pushl $0
  1029ee:	6a 00                	push   $0x0
  pushl $246
  1029f0:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1029f5:	e9 6c 00 00 00       	jmp    102a66 <__alltraps>

001029fa <vector247>:
.globl vector247
vector247:
  pushl $0
  1029fa:	6a 00                	push   $0x0
  pushl $247
  1029fc:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a01:	e9 60 00 00 00       	jmp    102a66 <__alltraps>

00102a06 <vector248>:
.globl vector248
vector248:
  pushl $0
  102a06:	6a 00                	push   $0x0
  pushl $248
  102a08:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a0d:	e9 54 00 00 00       	jmp    102a66 <__alltraps>

00102a12 <vector249>:
.globl vector249
vector249:
  pushl $0
  102a12:	6a 00                	push   $0x0
  pushl $249
  102a14:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a19:	e9 48 00 00 00       	jmp    102a66 <__alltraps>

00102a1e <vector250>:
.globl vector250
vector250:
  pushl $0
  102a1e:	6a 00                	push   $0x0
  pushl $250
  102a20:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a25:	e9 3c 00 00 00       	jmp    102a66 <__alltraps>

00102a2a <vector251>:
.globl vector251
vector251:
  pushl $0
  102a2a:	6a 00                	push   $0x0
  pushl $251
  102a2c:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a31:	e9 30 00 00 00       	jmp    102a66 <__alltraps>

00102a36 <vector252>:
.globl vector252
vector252:
  pushl $0
  102a36:	6a 00                	push   $0x0
  pushl $252
  102a38:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a3d:	e9 24 00 00 00       	jmp    102a66 <__alltraps>

00102a42 <vector253>:
.globl vector253
vector253:
  pushl $0
  102a42:	6a 00                	push   $0x0
  pushl $253
  102a44:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a49:	e9 18 00 00 00       	jmp    102a66 <__alltraps>

00102a4e <vector254>:
.globl vector254
vector254:
  pushl $0
  102a4e:	6a 00                	push   $0x0
  pushl $254
  102a50:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a55:	e9 0c 00 00 00       	jmp    102a66 <__alltraps>

00102a5a <vector255>:
.globl vector255
vector255:
  pushl $0
  102a5a:	6a 00                	push   $0x0
  pushl $255
  102a5c:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a61:	e9 00 00 00 00       	jmp    102a66 <__alltraps>

00102a66 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102a66:	1e                   	push   %ds
    pushl %es
  102a67:	06                   	push   %es
    pushl %fs
  102a68:	0f a0                	push   %fs
    pushl %gs
  102a6a:	0f a8                	push   %gs
    pushal
  102a6c:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102a6d:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102a72:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102a74:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102a76:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102a77:	e8 60 f5 ff ff       	call   101fdc <trap>

    # pop the pushed stack pointer
    popl %esp
  102a7c:	5c                   	pop    %esp

00102a7d <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102a7d:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102a7e:	0f a9                	pop    %gs
    popl %fs
  102a80:	0f a1                	pop    %fs
    popl %es
  102a82:	07                   	pop    %es
    popl %ds
  102a83:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102a84:	83 c4 08             	add    $0x8,%esp
    iret
  102a87:	cf                   	iret   

00102a88 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102a88:	55                   	push   %ebp
  102a89:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102a91:	b8 23 00 00 00       	mov    $0x23,%eax
  102a96:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102a98:	b8 23 00 00 00       	mov    $0x23,%eax
  102a9d:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102a9f:	b8 10 00 00 00       	mov    $0x10,%eax
  102aa4:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102aa6:	b8 10 00 00 00       	mov    $0x10,%eax
  102aab:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102aad:	b8 10 00 00 00       	mov    $0x10,%eax
  102ab2:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102ab4:	ea bb 2a 10 00 08 00 	ljmp   $0x8,$0x102abb
}
  102abb:	90                   	nop
  102abc:	5d                   	pop    %ebp
  102abd:	c3                   	ret    

00102abe <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102abe:	f3 0f 1e fb          	endbr32 
  102ac2:	55                   	push   %ebp
  102ac3:	89 e5                	mov    %esp,%ebp
  102ac5:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102ac8:	b8 80 19 11 00       	mov    $0x111980,%eax
  102acd:	05 00 04 00 00       	add    $0x400,%eax
  102ad2:	a3 a4 18 11 00       	mov    %eax,0x1118a4
    ts.ts_ss0 = KERNEL_DS;
  102ad7:	66 c7 05 a8 18 11 00 	movw   $0x10,0x1118a8
  102ade:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102ae0:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102ae7:	68 00 
  102ae9:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102aee:	0f b7 c0             	movzwl %ax,%eax
  102af1:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102af7:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102afc:	c1 e8 10             	shr    $0x10,%eax
  102aff:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102b04:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b0b:	24 f0                	and    $0xf0,%al
  102b0d:	0c 09                	or     $0x9,%al
  102b0f:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b14:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b1b:	0c 10                	or     $0x10,%al
  102b1d:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b22:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b29:	24 9f                	and    $0x9f,%al
  102b2b:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b30:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b37:	0c 80                	or     $0x80,%al
  102b39:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b3e:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b45:	24 f0                	and    $0xf0,%al
  102b47:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b4c:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b53:	24 ef                	and    $0xef,%al
  102b55:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b5a:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b61:	24 df                	and    $0xdf,%al
  102b63:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b68:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b6f:	0c 40                	or     $0x40,%al
  102b71:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b76:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b7d:	24 7f                	and    $0x7f,%al
  102b7f:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b84:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b89:	c1 e8 18             	shr    $0x18,%eax
  102b8c:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102b91:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b98:	24 ef                	and    $0xef,%al
  102b9a:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102b9f:	c7 04 24 10 0a 11 00 	movl   $0x110a10,(%esp)
  102ba6:	e8 dd fe ff ff       	call   102a88 <lgdt>
  102bab:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102bb1:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102bb5:	0f 00 d8             	ltr    %ax
}
  102bb8:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102bb9:	90                   	nop
  102bba:	c9                   	leave  
  102bbb:	c3                   	ret    

00102bbc <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102bbc:	f3 0f 1e fb          	endbr32 
  102bc0:	55                   	push   %ebp
  102bc1:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102bc3:	e8 f6 fe ff ff       	call   102abe <gdt_init>
}
  102bc8:	90                   	nop
  102bc9:	5d                   	pop    %ebp
  102bca:	c3                   	ret    

00102bcb <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102bcb:	f3 0f 1e fb          	endbr32 
  102bcf:	55                   	push   %ebp
  102bd0:	89 e5                	mov    %esp,%ebp
  102bd2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102bdc:	eb 03                	jmp    102be1 <strlen+0x16>
        cnt ++;
  102bde:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102be1:	8b 45 08             	mov    0x8(%ebp),%eax
  102be4:	8d 50 01             	lea    0x1(%eax),%edx
  102be7:	89 55 08             	mov    %edx,0x8(%ebp)
  102bea:	0f b6 00             	movzbl (%eax),%eax
  102bed:	84 c0                	test   %al,%al
  102bef:	75 ed                	jne    102bde <strlen+0x13>
    }
    return cnt;
  102bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102bf4:	c9                   	leave  
  102bf5:	c3                   	ret    

00102bf6 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102bf6:	f3 0f 1e fb          	endbr32 
  102bfa:	55                   	push   %ebp
  102bfb:	89 e5                	mov    %esp,%ebp
  102bfd:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c07:	eb 03                	jmp    102c0c <strnlen+0x16>
        cnt ++;
  102c09:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c0f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102c12:	73 10                	jae    102c24 <strnlen+0x2e>
  102c14:	8b 45 08             	mov    0x8(%ebp),%eax
  102c17:	8d 50 01             	lea    0x1(%eax),%edx
  102c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  102c1d:	0f b6 00             	movzbl (%eax),%eax
  102c20:	84 c0                	test   %al,%al
  102c22:	75 e5                	jne    102c09 <strnlen+0x13>
    }
    return cnt;
  102c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c27:	c9                   	leave  
  102c28:	c3                   	ret    

00102c29 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102c29:	f3 0f 1e fb          	endbr32 
  102c2d:	55                   	push   %ebp
  102c2e:	89 e5                	mov    %esp,%ebp
  102c30:	57                   	push   %edi
  102c31:	56                   	push   %esi
  102c32:	83 ec 20             	sub    $0x20,%esp
  102c35:	8b 45 08             	mov    0x8(%ebp),%eax
  102c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102c41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c47:	89 d1                	mov    %edx,%ecx
  102c49:	89 c2                	mov    %eax,%edx
  102c4b:	89 ce                	mov    %ecx,%esi
  102c4d:	89 d7                	mov    %edx,%edi
  102c4f:	ac                   	lods   %ds:(%esi),%al
  102c50:	aa                   	stos   %al,%es:(%edi)
  102c51:	84 c0                	test   %al,%al
  102c53:	75 fa                	jne    102c4f <strcpy+0x26>
  102c55:	89 fa                	mov    %edi,%edx
  102c57:	89 f1                	mov    %esi,%ecx
  102c59:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102c5c:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102c5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102c65:	83 c4 20             	add    $0x20,%esp
  102c68:	5e                   	pop    %esi
  102c69:	5f                   	pop    %edi
  102c6a:	5d                   	pop    %ebp
  102c6b:	c3                   	ret    

00102c6c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102c6c:	f3 0f 1e fb          	endbr32 
  102c70:	55                   	push   %ebp
  102c71:	89 e5                	mov    %esp,%ebp
  102c73:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102c76:	8b 45 08             	mov    0x8(%ebp),%eax
  102c79:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102c7c:	eb 1e                	jmp    102c9c <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c81:	0f b6 10             	movzbl (%eax),%edx
  102c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c87:	88 10                	mov    %dl,(%eax)
  102c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c8c:	0f b6 00             	movzbl (%eax),%eax
  102c8f:	84 c0                	test   %al,%al
  102c91:	74 03                	je     102c96 <strncpy+0x2a>
            src ++;
  102c93:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102c96:	ff 45 fc             	incl   -0x4(%ebp)
  102c99:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102c9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ca0:	75 dc                	jne    102c7e <strncpy+0x12>
    }
    return dst;
  102ca2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ca5:	c9                   	leave  
  102ca6:	c3                   	ret    

00102ca7 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102ca7:	f3 0f 1e fb          	endbr32 
  102cab:	55                   	push   %ebp
  102cac:	89 e5                	mov    %esp,%ebp
  102cae:	57                   	push   %edi
  102caf:	56                   	push   %esi
  102cb0:	83 ec 20             	sub    $0x20,%esp
  102cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cc5:	89 d1                	mov    %edx,%ecx
  102cc7:	89 c2                	mov    %eax,%edx
  102cc9:	89 ce                	mov    %ecx,%esi
  102ccb:	89 d7                	mov    %edx,%edi
  102ccd:	ac                   	lods   %ds:(%esi),%al
  102cce:	ae                   	scas   %es:(%edi),%al
  102ccf:	75 08                	jne    102cd9 <strcmp+0x32>
  102cd1:	84 c0                	test   %al,%al
  102cd3:	75 f8                	jne    102ccd <strcmp+0x26>
  102cd5:	31 c0                	xor    %eax,%eax
  102cd7:	eb 04                	jmp    102cdd <strcmp+0x36>
  102cd9:	19 c0                	sbb    %eax,%eax
  102cdb:	0c 01                	or     $0x1,%al
  102cdd:	89 fa                	mov    %edi,%edx
  102cdf:	89 f1                	mov    %esi,%ecx
  102ce1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ce4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102ce7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102ced:	83 c4 20             	add    $0x20,%esp
  102cf0:	5e                   	pop    %esi
  102cf1:	5f                   	pop    %edi
  102cf2:	5d                   	pop    %ebp
  102cf3:	c3                   	ret    

00102cf4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102cf4:	f3 0f 1e fb          	endbr32 
  102cf8:	55                   	push   %ebp
  102cf9:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102cfb:	eb 09                	jmp    102d06 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102cfd:	ff 4d 10             	decl   0x10(%ebp)
  102d00:	ff 45 08             	incl   0x8(%ebp)
  102d03:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d0a:	74 1a                	je     102d26 <strncmp+0x32>
  102d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0f:	0f b6 00             	movzbl (%eax),%eax
  102d12:	84 c0                	test   %al,%al
  102d14:	74 10                	je     102d26 <strncmp+0x32>
  102d16:	8b 45 08             	mov    0x8(%ebp),%eax
  102d19:	0f b6 10             	movzbl (%eax),%edx
  102d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d1f:	0f b6 00             	movzbl (%eax),%eax
  102d22:	38 c2                	cmp    %al,%dl
  102d24:	74 d7                	je     102cfd <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d2a:	74 18                	je     102d44 <strncmp+0x50>
  102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2f:	0f b6 00             	movzbl (%eax),%eax
  102d32:	0f b6 d0             	movzbl %al,%edx
  102d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d38:	0f b6 00             	movzbl (%eax),%eax
  102d3b:	0f b6 c0             	movzbl %al,%eax
  102d3e:	29 c2                	sub    %eax,%edx
  102d40:	89 d0                	mov    %edx,%eax
  102d42:	eb 05                	jmp    102d49 <strncmp+0x55>
  102d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d49:	5d                   	pop    %ebp
  102d4a:	c3                   	ret    

00102d4b <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102d4b:	f3 0f 1e fb          	endbr32 
  102d4f:	55                   	push   %ebp
  102d50:	89 e5                	mov    %esp,%ebp
  102d52:	83 ec 04             	sub    $0x4,%esp
  102d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d58:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102d5b:	eb 13                	jmp    102d70 <strchr+0x25>
        if (*s == c) {
  102d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d60:	0f b6 00             	movzbl (%eax),%eax
  102d63:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102d66:	75 05                	jne    102d6d <strchr+0x22>
            return (char *)s;
  102d68:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6b:	eb 12                	jmp    102d7f <strchr+0x34>
        }
        s ++;
  102d6d:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102d70:	8b 45 08             	mov    0x8(%ebp),%eax
  102d73:	0f b6 00             	movzbl (%eax),%eax
  102d76:	84 c0                	test   %al,%al
  102d78:	75 e3                	jne    102d5d <strchr+0x12>
    }
    return NULL;
  102d7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d7f:	c9                   	leave  
  102d80:	c3                   	ret    

00102d81 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102d81:	f3 0f 1e fb          	endbr32 
  102d85:	55                   	push   %ebp
  102d86:	89 e5                	mov    %esp,%ebp
  102d88:	83 ec 04             	sub    $0x4,%esp
  102d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102d91:	eb 0e                	jmp    102da1 <strfind+0x20>
        if (*s == c) {
  102d93:	8b 45 08             	mov    0x8(%ebp),%eax
  102d96:	0f b6 00             	movzbl (%eax),%eax
  102d99:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102d9c:	74 0f                	je     102dad <strfind+0x2c>
            break;
        }
        s ++;
  102d9e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102da1:	8b 45 08             	mov    0x8(%ebp),%eax
  102da4:	0f b6 00             	movzbl (%eax),%eax
  102da7:	84 c0                	test   %al,%al
  102da9:	75 e8                	jne    102d93 <strfind+0x12>
  102dab:	eb 01                	jmp    102dae <strfind+0x2d>
            break;
  102dad:	90                   	nop
    }
    return (char *)s;
  102dae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102db1:	c9                   	leave  
  102db2:	c3                   	ret    

00102db3 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102db3:	f3 0f 1e fb          	endbr32 
  102db7:	55                   	push   %ebp
  102db8:	89 e5                	mov    %esp,%ebp
  102dba:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102dbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102dc4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102dcb:	eb 03                	jmp    102dd0 <strtol+0x1d>
        s ++;
  102dcd:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd3:	0f b6 00             	movzbl (%eax),%eax
  102dd6:	3c 20                	cmp    $0x20,%al
  102dd8:	74 f3                	je     102dcd <strtol+0x1a>
  102dda:	8b 45 08             	mov    0x8(%ebp),%eax
  102ddd:	0f b6 00             	movzbl (%eax),%eax
  102de0:	3c 09                	cmp    $0x9,%al
  102de2:	74 e9                	je     102dcd <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102de4:	8b 45 08             	mov    0x8(%ebp),%eax
  102de7:	0f b6 00             	movzbl (%eax),%eax
  102dea:	3c 2b                	cmp    $0x2b,%al
  102dec:	75 05                	jne    102df3 <strtol+0x40>
        s ++;
  102dee:	ff 45 08             	incl   0x8(%ebp)
  102df1:	eb 14                	jmp    102e07 <strtol+0x54>
    }
    else if (*s == '-') {
  102df3:	8b 45 08             	mov    0x8(%ebp),%eax
  102df6:	0f b6 00             	movzbl (%eax),%eax
  102df9:	3c 2d                	cmp    $0x2d,%al
  102dfb:	75 0a                	jne    102e07 <strtol+0x54>
        s ++, neg = 1;
  102dfd:	ff 45 08             	incl   0x8(%ebp)
  102e00:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e0b:	74 06                	je     102e13 <strtol+0x60>
  102e0d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102e11:	75 22                	jne    102e35 <strtol+0x82>
  102e13:	8b 45 08             	mov    0x8(%ebp),%eax
  102e16:	0f b6 00             	movzbl (%eax),%eax
  102e19:	3c 30                	cmp    $0x30,%al
  102e1b:	75 18                	jne    102e35 <strtol+0x82>
  102e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e20:	40                   	inc    %eax
  102e21:	0f b6 00             	movzbl (%eax),%eax
  102e24:	3c 78                	cmp    $0x78,%al
  102e26:	75 0d                	jne    102e35 <strtol+0x82>
        s += 2, base = 16;
  102e28:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102e2c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102e33:	eb 29                	jmp    102e5e <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  102e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e39:	75 16                	jne    102e51 <strtol+0x9e>
  102e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3e:	0f b6 00             	movzbl (%eax),%eax
  102e41:	3c 30                	cmp    $0x30,%al
  102e43:	75 0c                	jne    102e51 <strtol+0x9e>
        s ++, base = 8;
  102e45:	ff 45 08             	incl   0x8(%ebp)
  102e48:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102e4f:	eb 0d                	jmp    102e5e <strtol+0xab>
    }
    else if (base == 0) {
  102e51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e55:	75 07                	jne    102e5e <strtol+0xab>
        base = 10;
  102e57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e61:	0f b6 00             	movzbl (%eax),%eax
  102e64:	3c 2f                	cmp    $0x2f,%al
  102e66:	7e 1b                	jle    102e83 <strtol+0xd0>
  102e68:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6b:	0f b6 00             	movzbl (%eax),%eax
  102e6e:	3c 39                	cmp    $0x39,%al
  102e70:	7f 11                	jg     102e83 <strtol+0xd0>
            dig = *s - '0';
  102e72:	8b 45 08             	mov    0x8(%ebp),%eax
  102e75:	0f b6 00             	movzbl (%eax),%eax
  102e78:	0f be c0             	movsbl %al,%eax
  102e7b:	83 e8 30             	sub    $0x30,%eax
  102e7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e81:	eb 48                	jmp    102ecb <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102e83:	8b 45 08             	mov    0x8(%ebp),%eax
  102e86:	0f b6 00             	movzbl (%eax),%eax
  102e89:	3c 60                	cmp    $0x60,%al
  102e8b:	7e 1b                	jle    102ea8 <strtol+0xf5>
  102e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e90:	0f b6 00             	movzbl (%eax),%eax
  102e93:	3c 7a                	cmp    $0x7a,%al
  102e95:	7f 11                	jg     102ea8 <strtol+0xf5>
            dig = *s - 'a' + 10;
  102e97:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9a:	0f b6 00             	movzbl (%eax),%eax
  102e9d:	0f be c0             	movsbl %al,%eax
  102ea0:	83 e8 57             	sub    $0x57,%eax
  102ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ea6:	eb 23                	jmp    102ecb <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  102eab:	0f b6 00             	movzbl (%eax),%eax
  102eae:	3c 40                	cmp    $0x40,%al
  102eb0:	7e 3b                	jle    102eed <strtol+0x13a>
  102eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb5:	0f b6 00             	movzbl (%eax),%eax
  102eb8:	3c 5a                	cmp    $0x5a,%al
  102eba:	7f 31                	jg     102eed <strtol+0x13a>
            dig = *s - 'A' + 10;
  102ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebf:	0f b6 00             	movzbl (%eax),%eax
  102ec2:	0f be c0             	movsbl %al,%eax
  102ec5:	83 e8 37             	sub    $0x37,%eax
  102ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ece:	3b 45 10             	cmp    0x10(%ebp),%eax
  102ed1:	7d 19                	jge    102eec <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  102ed3:	ff 45 08             	incl   0x8(%ebp)
  102ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ed9:	0f af 45 10          	imul   0x10(%ebp),%eax
  102edd:	89 c2                	mov    %eax,%edx
  102edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ee2:	01 d0                	add    %edx,%eax
  102ee4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102ee7:	e9 72 ff ff ff       	jmp    102e5e <strtol+0xab>
            break;
  102eec:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102eed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ef1:	74 08                	je     102efb <strtol+0x148>
        *endptr = (char *) s;
  102ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  102ef9:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102efb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102eff:	74 07                	je     102f08 <strtol+0x155>
  102f01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f04:	f7 d8                	neg    %eax
  102f06:	eb 03                	jmp    102f0b <strtol+0x158>
  102f08:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102f0b:	c9                   	leave  
  102f0c:	c3                   	ret    

00102f0d <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102f0d:	f3 0f 1e fb          	endbr32 
  102f11:	55                   	push   %ebp
  102f12:	89 e5                	mov    %esp,%ebp
  102f14:	57                   	push   %edi
  102f15:	83 ec 24             	sub    $0x24,%esp
  102f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102f1e:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  102f22:	8b 45 08             	mov    0x8(%ebp),%eax
  102f25:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102f28:	88 55 f7             	mov    %dl,-0x9(%ebp)
  102f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  102f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102f31:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102f34:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102f38:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102f3b:	89 d7                	mov    %edx,%edi
  102f3d:	f3 aa                	rep stos %al,%es:(%edi)
  102f3f:	89 fa                	mov    %edi,%edx
  102f41:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f44:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102f47:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102f4a:	83 c4 24             	add    $0x24,%esp
  102f4d:	5f                   	pop    %edi
  102f4e:	5d                   	pop    %ebp
  102f4f:	c3                   	ret    

00102f50 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102f50:	f3 0f 1e fb          	endbr32 
  102f54:	55                   	push   %ebp
  102f55:	89 e5                	mov    %esp,%ebp
  102f57:	57                   	push   %edi
  102f58:	56                   	push   %esi
  102f59:	53                   	push   %ebx
  102f5a:	83 ec 30             	sub    $0x30,%esp
  102f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f66:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f69:	8b 45 10             	mov    0x10(%ebp),%eax
  102f6c:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f72:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102f75:	73 42                	jae    102fb9 <memmove+0x69>
  102f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f80:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f86:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102f89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f8c:	c1 e8 02             	shr    $0x2,%eax
  102f8f:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102f91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f97:	89 d7                	mov    %edx,%edi
  102f99:	89 c6                	mov    %eax,%esi
  102f9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102f9d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102fa0:	83 e1 03             	and    $0x3,%ecx
  102fa3:	74 02                	je     102fa7 <memmove+0x57>
  102fa5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102fa7:	89 f0                	mov    %esi,%eax
  102fa9:	89 fa                	mov    %edi,%edx
  102fab:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102fae:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fb1:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102fb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  102fb7:	eb 36                	jmp    102fef <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc2:	01 c2                	add    %eax,%edx
  102fc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fc7:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fcd:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102fd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fd3:	89 c1                	mov    %eax,%ecx
  102fd5:	89 d8                	mov    %ebx,%eax
  102fd7:	89 d6                	mov    %edx,%esi
  102fd9:	89 c7                	mov    %eax,%edi
  102fdb:	fd                   	std    
  102fdc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102fde:	fc                   	cld    
  102fdf:	89 f8                	mov    %edi,%eax
  102fe1:	89 f2                	mov    %esi,%edx
  102fe3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102fe6:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102fe9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102fef:	83 c4 30             	add    $0x30,%esp
  102ff2:	5b                   	pop    %ebx
  102ff3:	5e                   	pop    %esi
  102ff4:	5f                   	pop    %edi
  102ff5:	5d                   	pop    %ebp
  102ff6:	c3                   	ret    

00102ff7 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102ff7:	f3 0f 1e fb          	endbr32 
  102ffb:	55                   	push   %ebp
  102ffc:	89 e5                	mov    %esp,%ebp
  102ffe:	57                   	push   %edi
  102fff:	56                   	push   %esi
  103000:	83 ec 20             	sub    $0x20,%esp
  103003:	8b 45 08             	mov    0x8(%ebp),%eax
  103006:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103009:	8b 45 0c             	mov    0xc(%ebp),%eax
  10300c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10300f:	8b 45 10             	mov    0x10(%ebp),%eax
  103012:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103015:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103018:	c1 e8 02             	shr    $0x2,%eax
  10301b:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10301d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103023:	89 d7                	mov    %edx,%edi
  103025:	89 c6                	mov    %eax,%esi
  103027:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103029:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10302c:	83 e1 03             	and    $0x3,%ecx
  10302f:	74 02                	je     103033 <memcpy+0x3c>
  103031:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103033:	89 f0                	mov    %esi,%eax
  103035:	89 fa                	mov    %edi,%edx
  103037:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10303a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10303d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103040:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103043:	83 c4 20             	add    $0x20,%esp
  103046:	5e                   	pop    %esi
  103047:	5f                   	pop    %edi
  103048:	5d                   	pop    %ebp
  103049:	c3                   	ret    

0010304a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10304a:	f3 0f 1e fb          	endbr32 
  10304e:	55                   	push   %ebp
  10304f:	89 e5                	mov    %esp,%ebp
  103051:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103054:	8b 45 08             	mov    0x8(%ebp),%eax
  103057:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10305a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10305d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103060:	eb 2e                	jmp    103090 <memcmp+0x46>
        if (*s1 != *s2) {
  103062:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103065:	0f b6 10             	movzbl (%eax),%edx
  103068:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10306b:	0f b6 00             	movzbl (%eax),%eax
  10306e:	38 c2                	cmp    %al,%dl
  103070:	74 18                	je     10308a <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103075:	0f b6 00             	movzbl (%eax),%eax
  103078:	0f b6 d0             	movzbl %al,%edx
  10307b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10307e:	0f b6 00             	movzbl (%eax),%eax
  103081:	0f b6 c0             	movzbl %al,%eax
  103084:	29 c2                	sub    %eax,%edx
  103086:	89 d0                	mov    %edx,%eax
  103088:	eb 18                	jmp    1030a2 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  10308a:	ff 45 fc             	incl   -0x4(%ebp)
  10308d:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103090:	8b 45 10             	mov    0x10(%ebp),%eax
  103093:	8d 50 ff             	lea    -0x1(%eax),%edx
  103096:	89 55 10             	mov    %edx,0x10(%ebp)
  103099:	85 c0                	test   %eax,%eax
  10309b:	75 c5                	jne    103062 <memcmp+0x18>
    }
    return 0;
  10309d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030a2:	c9                   	leave  
  1030a3:	c3                   	ret    

001030a4 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1030a4:	f3 0f 1e fb          	endbr32 
  1030a8:	55                   	push   %ebp
  1030a9:	89 e5                	mov    %esp,%ebp
  1030ab:	83 ec 58             	sub    $0x58,%esp
  1030ae:	8b 45 10             	mov    0x10(%ebp),%eax
  1030b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030b4:	8b 45 14             	mov    0x14(%ebp),%eax
  1030b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1030ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1030c6:	8b 45 18             	mov    0x18(%ebp),%eax
  1030c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1030d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1030d5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1030d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030e2:	74 1c                	je     103100 <printnum+0x5c>
  1030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030e7:	ba 00 00 00 00       	mov    $0x0,%edx
  1030ec:	f7 75 e4             	divl   -0x1c(%ebp)
  1030ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1030f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030f5:	ba 00 00 00 00       	mov    $0x0,%edx
  1030fa:	f7 75 e4             	divl   -0x1c(%ebp)
  1030fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103100:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103103:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103106:	f7 75 e4             	divl   -0x1c(%ebp)
  103109:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10310c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10310f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103112:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103115:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103118:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10311b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10311e:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103121:	8b 45 18             	mov    0x18(%ebp),%eax
  103124:	ba 00 00 00 00       	mov    $0x0,%edx
  103129:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10312c:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10312f:	19 d1                	sbb    %edx,%ecx
  103131:	72 4c                	jb     10317f <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  103133:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103136:	8d 50 ff             	lea    -0x1(%eax),%edx
  103139:	8b 45 20             	mov    0x20(%ebp),%eax
  10313c:	89 44 24 18          	mov    %eax,0x18(%esp)
  103140:	89 54 24 14          	mov    %edx,0x14(%esp)
  103144:	8b 45 18             	mov    0x18(%ebp),%eax
  103147:	89 44 24 10          	mov    %eax,0x10(%esp)
  10314b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10314e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103151:	89 44 24 08          	mov    %eax,0x8(%esp)
  103155:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103159:	8b 45 0c             	mov    0xc(%ebp),%eax
  10315c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103160:	8b 45 08             	mov    0x8(%ebp),%eax
  103163:	89 04 24             	mov    %eax,(%esp)
  103166:	e8 39 ff ff ff       	call   1030a4 <printnum>
  10316b:	eb 1b                	jmp    103188 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10316d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103170:	89 44 24 04          	mov    %eax,0x4(%esp)
  103174:	8b 45 20             	mov    0x20(%ebp),%eax
  103177:	89 04 24             	mov    %eax,(%esp)
  10317a:	8b 45 08             	mov    0x8(%ebp),%eax
  10317d:	ff d0                	call   *%eax
        while (-- width > 0)
  10317f:	ff 4d 1c             	decl   0x1c(%ebp)
  103182:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103186:	7f e5                	jg     10316d <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103188:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10318b:	05 10 3f 10 00       	add    $0x103f10,%eax
  103190:	0f b6 00             	movzbl (%eax),%eax
  103193:	0f be c0             	movsbl %al,%eax
  103196:	8b 55 0c             	mov    0xc(%ebp),%edx
  103199:	89 54 24 04          	mov    %edx,0x4(%esp)
  10319d:	89 04 24             	mov    %eax,(%esp)
  1031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a3:	ff d0                	call   *%eax
}
  1031a5:	90                   	nop
  1031a6:	c9                   	leave  
  1031a7:	c3                   	ret    

001031a8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1031a8:	f3 0f 1e fb          	endbr32 
  1031ac:	55                   	push   %ebp
  1031ad:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1031af:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1031b3:	7e 14                	jle    1031c9 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  1031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b8:	8b 00                	mov    (%eax),%eax
  1031ba:	8d 48 08             	lea    0x8(%eax),%ecx
  1031bd:	8b 55 08             	mov    0x8(%ebp),%edx
  1031c0:	89 0a                	mov    %ecx,(%edx)
  1031c2:	8b 50 04             	mov    0x4(%eax),%edx
  1031c5:	8b 00                	mov    (%eax),%eax
  1031c7:	eb 30                	jmp    1031f9 <getuint+0x51>
    }
    else if (lflag) {
  1031c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1031cd:	74 16                	je     1031e5 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  1031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d2:	8b 00                	mov    (%eax),%eax
  1031d4:	8d 48 04             	lea    0x4(%eax),%ecx
  1031d7:	8b 55 08             	mov    0x8(%ebp),%edx
  1031da:	89 0a                	mov    %ecx,(%edx)
  1031dc:	8b 00                	mov    (%eax),%eax
  1031de:	ba 00 00 00 00       	mov    $0x0,%edx
  1031e3:	eb 14                	jmp    1031f9 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  1031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e8:	8b 00                	mov    (%eax),%eax
  1031ea:	8d 48 04             	lea    0x4(%eax),%ecx
  1031ed:	8b 55 08             	mov    0x8(%ebp),%edx
  1031f0:	89 0a                	mov    %ecx,(%edx)
  1031f2:	8b 00                	mov    (%eax),%eax
  1031f4:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1031f9:	5d                   	pop    %ebp
  1031fa:	c3                   	ret    

001031fb <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1031fb:	f3 0f 1e fb          	endbr32 
  1031ff:	55                   	push   %ebp
  103200:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103202:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103206:	7e 14                	jle    10321c <getint+0x21>
        return va_arg(*ap, long long);
  103208:	8b 45 08             	mov    0x8(%ebp),%eax
  10320b:	8b 00                	mov    (%eax),%eax
  10320d:	8d 48 08             	lea    0x8(%eax),%ecx
  103210:	8b 55 08             	mov    0x8(%ebp),%edx
  103213:	89 0a                	mov    %ecx,(%edx)
  103215:	8b 50 04             	mov    0x4(%eax),%edx
  103218:	8b 00                	mov    (%eax),%eax
  10321a:	eb 28                	jmp    103244 <getint+0x49>
    }
    else if (lflag) {
  10321c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103220:	74 12                	je     103234 <getint+0x39>
        return va_arg(*ap, long);
  103222:	8b 45 08             	mov    0x8(%ebp),%eax
  103225:	8b 00                	mov    (%eax),%eax
  103227:	8d 48 04             	lea    0x4(%eax),%ecx
  10322a:	8b 55 08             	mov    0x8(%ebp),%edx
  10322d:	89 0a                	mov    %ecx,(%edx)
  10322f:	8b 00                	mov    (%eax),%eax
  103231:	99                   	cltd   
  103232:	eb 10                	jmp    103244 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  103234:	8b 45 08             	mov    0x8(%ebp),%eax
  103237:	8b 00                	mov    (%eax),%eax
  103239:	8d 48 04             	lea    0x4(%eax),%ecx
  10323c:	8b 55 08             	mov    0x8(%ebp),%edx
  10323f:	89 0a                	mov    %ecx,(%edx)
  103241:	8b 00                	mov    (%eax),%eax
  103243:	99                   	cltd   
    }
}
  103244:	5d                   	pop    %ebp
  103245:	c3                   	ret    

00103246 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  103246:	f3 0f 1e fb          	endbr32 
  10324a:	55                   	push   %ebp
  10324b:	89 e5                	mov    %esp,%ebp
  10324d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  103250:	8d 45 14             	lea    0x14(%ebp),%eax
  103253:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103259:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10325d:	8b 45 10             	mov    0x10(%ebp),%eax
  103260:	89 44 24 08          	mov    %eax,0x8(%esp)
  103264:	8b 45 0c             	mov    0xc(%ebp),%eax
  103267:	89 44 24 04          	mov    %eax,0x4(%esp)
  10326b:	8b 45 08             	mov    0x8(%ebp),%eax
  10326e:	89 04 24             	mov    %eax,(%esp)
  103271:	e8 03 00 00 00       	call   103279 <vprintfmt>
    va_end(ap);
}
  103276:	90                   	nop
  103277:	c9                   	leave  
  103278:	c3                   	ret    

00103279 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  103279:	f3 0f 1e fb          	endbr32 
  10327d:	55                   	push   %ebp
  10327e:	89 e5                	mov    %esp,%ebp
  103280:	56                   	push   %esi
  103281:	53                   	push   %ebx
  103282:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103285:	eb 17                	jmp    10329e <vprintfmt+0x25>
            if (ch == '\0') {
  103287:	85 db                	test   %ebx,%ebx
  103289:	0f 84 c0 03 00 00    	je     10364f <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  10328f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103292:	89 44 24 04          	mov    %eax,0x4(%esp)
  103296:	89 1c 24             	mov    %ebx,(%esp)
  103299:	8b 45 08             	mov    0x8(%ebp),%eax
  10329c:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10329e:	8b 45 10             	mov    0x10(%ebp),%eax
  1032a1:	8d 50 01             	lea    0x1(%eax),%edx
  1032a4:	89 55 10             	mov    %edx,0x10(%ebp)
  1032a7:	0f b6 00             	movzbl (%eax),%eax
  1032aa:	0f b6 d8             	movzbl %al,%ebx
  1032ad:	83 fb 25             	cmp    $0x25,%ebx
  1032b0:	75 d5                	jne    103287 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1032b2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1032b6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1032bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1032c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1032ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1032cd:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1032d0:	8b 45 10             	mov    0x10(%ebp),%eax
  1032d3:	8d 50 01             	lea    0x1(%eax),%edx
  1032d6:	89 55 10             	mov    %edx,0x10(%ebp)
  1032d9:	0f b6 00             	movzbl (%eax),%eax
  1032dc:	0f b6 d8             	movzbl %al,%ebx
  1032df:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1032e2:	83 f8 55             	cmp    $0x55,%eax
  1032e5:	0f 87 38 03 00 00    	ja     103623 <vprintfmt+0x3aa>
  1032eb:	8b 04 85 34 3f 10 00 	mov    0x103f34(,%eax,4),%eax
  1032f2:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1032f5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1032f9:	eb d5                	jmp    1032d0 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1032fb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1032ff:	eb cf                	jmp    1032d0 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103301:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103308:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10330b:	89 d0                	mov    %edx,%eax
  10330d:	c1 e0 02             	shl    $0x2,%eax
  103310:	01 d0                	add    %edx,%eax
  103312:	01 c0                	add    %eax,%eax
  103314:	01 d8                	add    %ebx,%eax
  103316:	83 e8 30             	sub    $0x30,%eax
  103319:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10331c:	8b 45 10             	mov    0x10(%ebp),%eax
  10331f:	0f b6 00             	movzbl (%eax),%eax
  103322:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103325:	83 fb 2f             	cmp    $0x2f,%ebx
  103328:	7e 38                	jle    103362 <vprintfmt+0xe9>
  10332a:	83 fb 39             	cmp    $0x39,%ebx
  10332d:	7f 33                	jg     103362 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  10332f:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103332:	eb d4                	jmp    103308 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103334:	8b 45 14             	mov    0x14(%ebp),%eax
  103337:	8d 50 04             	lea    0x4(%eax),%edx
  10333a:	89 55 14             	mov    %edx,0x14(%ebp)
  10333d:	8b 00                	mov    (%eax),%eax
  10333f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103342:	eb 1f                	jmp    103363 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  103344:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103348:	79 86                	jns    1032d0 <vprintfmt+0x57>
                width = 0;
  10334a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103351:	e9 7a ff ff ff       	jmp    1032d0 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  103356:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10335d:	e9 6e ff ff ff       	jmp    1032d0 <vprintfmt+0x57>
            goto process_precision;
  103362:	90                   	nop

        process_precision:
            if (width < 0)
  103363:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103367:	0f 89 63 ff ff ff    	jns    1032d0 <vprintfmt+0x57>
                width = precision, precision = -1;
  10336d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103370:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103373:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10337a:	e9 51 ff ff ff       	jmp    1032d0 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10337f:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  103382:	e9 49 ff ff ff       	jmp    1032d0 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103387:	8b 45 14             	mov    0x14(%ebp),%eax
  10338a:	8d 50 04             	lea    0x4(%eax),%edx
  10338d:	89 55 14             	mov    %edx,0x14(%ebp)
  103390:	8b 00                	mov    (%eax),%eax
  103392:	8b 55 0c             	mov    0xc(%ebp),%edx
  103395:	89 54 24 04          	mov    %edx,0x4(%esp)
  103399:	89 04 24             	mov    %eax,(%esp)
  10339c:	8b 45 08             	mov    0x8(%ebp),%eax
  10339f:	ff d0                	call   *%eax
            break;
  1033a1:	e9 a4 02 00 00       	jmp    10364a <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1033a6:	8b 45 14             	mov    0x14(%ebp),%eax
  1033a9:	8d 50 04             	lea    0x4(%eax),%edx
  1033ac:	89 55 14             	mov    %edx,0x14(%ebp)
  1033af:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1033b1:	85 db                	test   %ebx,%ebx
  1033b3:	79 02                	jns    1033b7 <vprintfmt+0x13e>
                err = -err;
  1033b5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1033b7:	83 fb 06             	cmp    $0x6,%ebx
  1033ba:	7f 0b                	jg     1033c7 <vprintfmt+0x14e>
  1033bc:	8b 34 9d f4 3e 10 00 	mov    0x103ef4(,%ebx,4),%esi
  1033c3:	85 f6                	test   %esi,%esi
  1033c5:	75 23                	jne    1033ea <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  1033c7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1033cb:	c7 44 24 08 21 3f 10 	movl   $0x103f21,0x8(%esp)
  1033d2:	00 
  1033d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033da:	8b 45 08             	mov    0x8(%ebp),%eax
  1033dd:	89 04 24             	mov    %eax,(%esp)
  1033e0:	e8 61 fe ff ff       	call   103246 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1033e5:	e9 60 02 00 00       	jmp    10364a <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  1033ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1033ee:	c7 44 24 08 2a 3f 10 	movl   $0x103f2a,0x8(%esp)
  1033f5:	00 
  1033f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103400:	89 04 24             	mov    %eax,(%esp)
  103403:	e8 3e fe ff ff       	call   103246 <printfmt>
            break;
  103408:	e9 3d 02 00 00       	jmp    10364a <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10340d:	8b 45 14             	mov    0x14(%ebp),%eax
  103410:	8d 50 04             	lea    0x4(%eax),%edx
  103413:	89 55 14             	mov    %edx,0x14(%ebp)
  103416:	8b 30                	mov    (%eax),%esi
  103418:	85 f6                	test   %esi,%esi
  10341a:	75 05                	jne    103421 <vprintfmt+0x1a8>
                p = "(null)";
  10341c:	be 2d 3f 10 00       	mov    $0x103f2d,%esi
            }
            if (width > 0 && padc != '-') {
  103421:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103425:	7e 76                	jle    10349d <vprintfmt+0x224>
  103427:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10342b:	74 70                	je     10349d <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10342d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103430:	89 44 24 04          	mov    %eax,0x4(%esp)
  103434:	89 34 24             	mov    %esi,(%esp)
  103437:	e8 ba f7 ff ff       	call   102bf6 <strnlen>
  10343c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10343f:	29 c2                	sub    %eax,%edx
  103441:	89 d0                	mov    %edx,%eax
  103443:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103446:	eb 16                	jmp    10345e <vprintfmt+0x1e5>
                    putch(padc, putdat);
  103448:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10344c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10344f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103453:	89 04 24             	mov    %eax,(%esp)
  103456:	8b 45 08             	mov    0x8(%ebp),%eax
  103459:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  10345b:	ff 4d e8             	decl   -0x18(%ebp)
  10345e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103462:	7f e4                	jg     103448 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103464:	eb 37                	jmp    10349d <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  103466:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10346a:	74 1f                	je     10348b <vprintfmt+0x212>
  10346c:	83 fb 1f             	cmp    $0x1f,%ebx
  10346f:	7e 05                	jle    103476 <vprintfmt+0x1fd>
  103471:	83 fb 7e             	cmp    $0x7e,%ebx
  103474:	7e 15                	jle    10348b <vprintfmt+0x212>
                    putch('?', putdat);
  103476:	8b 45 0c             	mov    0xc(%ebp),%eax
  103479:	89 44 24 04          	mov    %eax,0x4(%esp)
  10347d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103484:	8b 45 08             	mov    0x8(%ebp),%eax
  103487:	ff d0                	call   *%eax
  103489:	eb 0f                	jmp    10349a <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  10348b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10348e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103492:	89 1c 24             	mov    %ebx,(%esp)
  103495:	8b 45 08             	mov    0x8(%ebp),%eax
  103498:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10349a:	ff 4d e8             	decl   -0x18(%ebp)
  10349d:	89 f0                	mov    %esi,%eax
  10349f:	8d 70 01             	lea    0x1(%eax),%esi
  1034a2:	0f b6 00             	movzbl (%eax),%eax
  1034a5:	0f be d8             	movsbl %al,%ebx
  1034a8:	85 db                	test   %ebx,%ebx
  1034aa:	74 27                	je     1034d3 <vprintfmt+0x25a>
  1034ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034b0:	78 b4                	js     103466 <vprintfmt+0x1ed>
  1034b2:	ff 4d e4             	decl   -0x1c(%ebp)
  1034b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034b9:	79 ab                	jns    103466 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  1034bb:	eb 16                	jmp    1034d3 <vprintfmt+0x25a>
                putch(' ', putdat);
  1034bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034c4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1034cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ce:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1034d0:	ff 4d e8             	decl   -0x18(%ebp)
  1034d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034d7:	7f e4                	jg     1034bd <vprintfmt+0x244>
            }
            break;
  1034d9:	e9 6c 01 00 00       	jmp    10364a <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1034de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034e5:	8d 45 14             	lea    0x14(%ebp),%eax
  1034e8:	89 04 24             	mov    %eax,(%esp)
  1034eb:	e8 0b fd ff ff       	call   1031fb <getint>
  1034f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1034f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034fc:	85 d2                	test   %edx,%edx
  1034fe:	79 26                	jns    103526 <vprintfmt+0x2ad>
                putch('-', putdat);
  103500:	8b 45 0c             	mov    0xc(%ebp),%eax
  103503:	89 44 24 04          	mov    %eax,0x4(%esp)
  103507:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10350e:	8b 45 08             	mov    0x8(%ebp),%eax
  103511:	ff d0                	call   *%eax
                num = -(long long)num;
  103513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103516:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103519:	f7 d8                	neg    %eax
  10351b:	83 d2 00             	adc    $0x0,%edx
  10351e:	f7 da                	neg    %edx
  103520:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103523:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103526:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10352d:	e9 a8 00 00 00       	jmp    1035da <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103535:	89 44 24 04          	mov    %eax,0x4(%esp)
  103539:	8d 45 14             	lea    0x14(%ebp),%eax
  10353c:	89 04 24             	mov    %eax,(%esp)
  10353f:	e8 64 fc ff ff       	call   1031a8 <getuint>
  103544:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103547:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10354a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103551:	e9 84 00 00 00       	jmp    1035da <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103559:	89 44 24 04          	mov    %eax,0x4(%esp)
  10355d:	8d 45 14             	lea    0x14(%ebp),%eax
  103560:	89 04 24             	mov    %eax,(%esp)
  103563:	e8 40 fc ff ff       	call   1031a8 <getuint>
  103568:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10356b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10356e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103575:	eb 63                	jmp    1035da <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  103577:	8b 45 0c             	mov    0xc(%ebp),%eax
  10357a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10357e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103585:	8b 45 08             	mov    0x8(%ebp),%eax
  103588:	ff d0                	call   *%eax
            putch('x', putdat);
  10358a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10358d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103591:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103598:	8b 45 08             	mov    0x8(%ebp),%eax
  10359b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10359d:	8b 45 14             	mov    0x14(%ebp),%eax
  1035a0:	8d 50 04             	lea    0x4(%eax),%edx
  1035a3:	89 55 14             	mov    %edx,0x14(%ebp)
  1035a6:	8b 00                	mov    (%eax),%eax
  1035a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1035b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1035b9:	eb 1f                	jmp    1035da <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1035bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035c2:	8d 45 14             	lea    0x14(%ebp),%eax
  1035c5:	89 04 24             	mov    %eax,(%esp)
  1035c8:	e8 db fb ff ff       	call   1031a8 <getuint>
  1035cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1035d3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1035da:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1035de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035e1:	89 54 24 18          	mov    %edx,0x18(%esp)
  1035e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1035e8:	89 54 24 14          	mov    %edx,0x14(%esp)
  1035ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1035f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1035fa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1035fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103601:	89 44 24 04          	mov    %eax,0x4(%esp)
  103605:	8b 45 08             	mov    0x8(%ebp),%eax
  103608:	89 04 24             	mov    %eax,(%esp)
  10360b:	e8 94 fa ff ff       	call   1030a4 <printnum>
            break;
  103610:	eb 38                	jmp    10364a <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103612:	8b 45 0c             	mov    0xc(%ebp),%eax
  103615:	89 44 24 04          	mov    %eax,0x4(%esp)
  103619:	89 1c 24             	mov    %ebx,(%esp)
  10361c:	8b 45 08             	mov    0x8(%ebp),%eax
  10361f:	ff d0                	call   *%eax
            break;
  103621:	eb 27                	jmp    10364a <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103623:	8b 45 0c             	mov    0xc(%ebp),%eax
  103626:	89 44 24 04          	mov    %eax,0x4(%esp)
  10362a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103631:	8b 45 08             	mov    0x8(%ebp),%eax
  103634:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103636:	ff 4d 10             	decl   0x10(%ebp)
  103639:	eb 03                	jmp    10363e <vprintfmt+0x3c5>
  10363b:	ff 4d 10             	decl   0x10(%ebp)
  10363e:	8b 45 10             	mov    0x10(%ebp),%eax
  103641:	48                   	dec    %eax
  103642:	0f b6 00             	movzbl (%eax),%eax
  103645:	3c 25                	cmp    $0x25,%al
  103647:	75 f2                	jne    10363b <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  103649:	90                   	nop
    while (1) {
  10364a:	e9 36 fc ff ff       	jmp    103285 <vprintfmt+0xc>
                return;
  10364f:	90                   	nop
        }
    }
}
  103650:	83 c4 40             	add    $0x40,%esp
  103653:	5b                   	pop    %ebx
  103654:	5e                   	pop    %esi
  103655:	5d                   	pop    %ebp
  103656:	c3                   	ret    

00103657 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103657:	f3 0f 1e fb          	endbr32 
  10365b:	55                   	push   %ebp
  10365c:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10365e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103661:	8b 40 08             	mov    0x8(%eax),%eax
  103664:	8d 50 01             	lea    0x1(%eax),%edx
  103667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10366a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10366d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103670:	8b 10                	mov    (%eax),%edx
  103672:	8b 45 0c             	mov    0xc(%ebp),%eax
  103675:	8b 40 04             	mov    0x4(%eax),%eax
  103678:	39 c2                	cmp    %eax,%edx
  10367a:	73 12                	jae    10368e <sprintputch+0x37>
        *b->buf ++ = ch;
  10367c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10367f:	8b 00                	mov    (%eax),%eax
  103681:	8d 48 01             	lea    0x1(%eax),%ecx
  103684:	8b 55 0c             	mov    0xc(%ebp),%edx
  103687:	89 0a                	mov    %ecx,(%edx)
  103689:	8b 55 08             	mov    0x8(%ebp),%edx
  10368c:	88 10                	mov    %dl,(%eax)
    }
}
  10368e:	90                   	nop
  10368f:	5d                   	pop    %ebp
  103690:	c3                   	ret    

00103691 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103691:	f3 0f 1e fb          	endbr32 
  103695:	55                   	push   %ebp
  103696:	89 e5                	mov    %esp,%ebp
  103698:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10369b:	8d 45 14             	lea    0x14(%ebp),%eax
  10369e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1036a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1036ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1036b9:	89 04 24             	mov    %eax,(%esp)
  1036bc:	e8 08 00 00 00       	call   1036c9 <vsnprintf>
  1036c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1036c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1036c7:	c9                   	leave  
  1036c8:	c3                   	ret    

001036c9 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1036c9:	f3 0f 1e fb          	endbr32 
  1036cd:	55                   	push   %ebp
  1036ce:	89 e5                	mov    %esp,%ebp
  1036d0:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1036d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1036d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1036df:	8b 45 08             	mov    0x8(%ebp),%eax
  1036e2:	01 d0                	add    %edx,%eax
  1036e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1036ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1036f2:	74 0a                	je     1036fe <vsnprintf+0x35>
  1036f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1036f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036fa:	39 c2                	cmp    %eax,%edx
  1036fc:	76 07                	jbe    103705 <vsnprintf+0x3c>
        return -E_INVAL;
  1036fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103703:	eb 2a                	jmp    10372f <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103705:	8b 45 14             	mov    0x14(%ebp),%eax
  103708:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10370c:	8b 45 10             	mov    0x10(%ebp),%eax
  10370f:	89 44 24 08          	mov    %eax,0x8(%esp)
  103713:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103716:	89 44 24 04          	mov    %eax,0x4(%esp)
  10371a:	c7 04 24 57 36 10 00 	movl   $0x103657,(%esp)
  103721:	e8 53 fb ff ff       	call   103279 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103726:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103729:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10372f:	c9                   	leave  
  103730:	c3                   	ret    
