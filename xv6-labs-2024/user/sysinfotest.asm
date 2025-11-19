
user/_sysinfotest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <testcall>:
#include "user/user.h"
#include "kernel/sysinfo.h"

void
testcall()
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
    struct sysinfo info;
    
    printf("sysinfotest: test sysinfo\n");
   8:	00001517          	auipc	a0,0x1
   c:	99850513          	addi	a0,a0,-1640 # 9a0 <malloc+0x102>
  10:	7da000ef          	jal	7ea <printf>
    
    if (sysinfo(&info) < 0) {
  14:	fe040513          	addi	a0,s0,-32
  18:	452000ef          	jal	46a <sysinfo>
  1c:	00054c63          	bltz	a0,34 <testcall+0x34>
        printf("sysinfo failed\n");
        exit(1);
    }
    
    printf("sysinfo success\n");
  20:	00001517          	auipc	a0,0x1
  24:	9b050513          	addi	a0,a0,-1616 # 9d0 <malloc+0x132>
  28:	7c2000ef          	jal	7ea <printf>
}
  2c:	60e2                	ld	ra,24(sp)
  2e:	6442                	ld	s0,16(sp)
  30:	6105                	addi	sp,sp,32
  32:	8082                	ret
        printf("sysinfo failed\n");
  34:	00001517          	auipc	a0,0x1
  38:	98c50513          	addi	a0,a0,-1652 # 9c0 <malloc+0x122>
  3c:	7ae000ef          	jal	7ea <printf>
        exit(1);
  40:	4505                	li	a0,1
  42:	380000ef          	jal	3c2 <exit>

0000000000000046 <testmem>:

void
testmem()
{
  46:	1101                	addi	sp,sp,-32
  48:	ec06                	sd	ra,24(sp)
  4a:	e822                	sd	s0,16(sp)
  4c:	1000                	addi	s0,sp,32
    struct sysinfo info;
    
    printf("sysinfotest: test memory\n");
  4e:	00001517          	auipc	a0,0x1
  52:	99a50513          	addi	a0,a0,-1638 # 9e8 <malloc+0x14a>
  56:	794000ef          	jal	7ea <printf>
    
    if (sysinfo(&info) < 0) {
  5a:	fe040513          	addi	a0,s0,-32
  5e:	40c000ef          	jal	46a <sysinfo>
  62:	02054763          	bltz	a0,90 <testmem+0x4a>
        printf("sysinfo failed\n");
        exit(1);
    }
    
    printf("free memory: %d bytes\n", (int)info.freemem);
  66:	fe042583          	lw	a1,-32(s0)
  6a:	00001517          	auipc	a0,0x1
  6e:	99e50513          	addi	a0,a0,-1634 # a08 <malloc+0x16a>
  72:	778000ef          	jal	7ea <printf>
    
    if (info.freemem <= 0) {
  76:	fe043783          	ld	a5,-32(s0)
  7a:	c785                	beqz	a5,a2 <testmem+0x5c>
        printf("invalid free memory: %d\n", (int)info.freemem);
        exit(1);
    }
    
    printf("memory test success\n");
  7c:	00001517          	auipc	a0,0x1
  80:	9c450513          	addi	a0,a0,-1596 # a40 <malloc+0x1a2>
  84:	766000ef          	jal	7ea <printf>
}
  88:	60e2                	ld	ra,24(sp)
  8a:	6442                	ld	s0,16(sp)
  8c:	6105                	addi	sp,sp,32
  8e:	8082                	ret
        printf("sysinfo failed\n");
  90:	00001517          	auipc	a0,0x1
  94:	93050513          	addi	a0,a0,-1744 # 9c0 <malloc+0x122>
  98:	752000ef          	jal	7ea <printf>
        exit(1);
  9c:	4505                	li	a0,1
  9e:	324000ef          	jal	3c2 <exit>
        printf("invalid free memory: %d\n", (int)info.freemem);
  a2:	4581                	li	a1,0
  a4:	00001517          	auipc	a0,0x1
  a8:	97c50513          	addi	a0,a0,-1668 # a20 <malloc+0x182>
  ac:	73e000ef          	jal	7ea <printf>
        exit(1);
  b0:	4505                	li	a0,1
  b2:	310000ef          	jal	3c2 <exit>

00000000000000b6 <testproc>:

void
testproc()
{
  b6:	1101                	addi	sp,sp,-32
  b8:	ec06                	sd	ra,24(sp)
  ba:	e822                	sd	s0,16(sp)
  bc:	1000                	addi	s0,sp,32
    struct sysinfo info;
    
    printf("sysinfotest: test processes\n");
  be:	00001517          	auipc	a0,0x1
  c2:	99a50513          	addi	a0,a0,-1638 # a58 <malloc+0x1ba>
  c6:	724000ef          	jal	7ea <printf>
    
    if (sysinfo(&info) < 0) {
  ca:	fe040513          	addi	a0,s0,-32
  ce:	39c000ef          	jal	46a <sysinfo>
  d2:	02054763          	bltz	a0,100 <testproc+0x4a>
        printf("sysinfo failed\n");
        exit(1);
    }
    
    printf("number of processes: %d\n", (int)info.nproc);
  d6:	fe842583          	lw	a1,-24(s0)
  da:	00001517          	auipc	a0,0x1
  de:	99e50513          	addi	a0,a0,-1634 # a78 <malloc+0x1da>
  e2:	708000ef          	jal	7ea <printf>
    
    if (info.nproc <= 0) {
  e6:	fe843783          	ld	a5,-24(s0)
  ea:	c785                	beqz	a5,112 <testproc+0x5c>
        printf("invalid process count: %d\n", (int)info.nproc);
        exit(1);
    }
    
    printf("process test success\n");
  ec:	00001517          	auipc	a0,0x1
  f0:	9cc50513          	addi	a0,a0,-1588 # ab8 <malloc+0x21a>
  f4:	6f6000ef          	jal	7ea <printf>
}
  f8:	60e2                	ld	ra,24(sp)
  fa:	6442                	ld	s0,16(sp)
  fc:	6105                	addi	sp,sp,32
  fe:	8082                	ret
        printf("sysinfo failed\n");
 100:	00001517          	auipc	a0,0x1
 104:	8c050513          	addi	a0,a0,-1856 # 9c0 <malloc+0x122>
 108:	6e2000ef          	jal	7ea <printf>
        exit(1);
 10c:	4505                	li	a0,1
 10e:	2b4000ef          	jal	3c2 <exit>
        printf("invalid process count: %d\n", (int)info.nproc);
 112:	4581                	li	a1,0
 114:	00001517          	auipc	a0,0x1
 118:	98450513          	addi	a0,a0,-1660 # a98 <malloc+0x1fa>
 11c:	6ce000ef          	jal	7ea <printf>
        exit(1);
 120:	4505                	li	a0,1
 122:	2a0000ef          	jal	3c2 <exit>

0000000000000126 <main>:

int
main(int argc, char *argv[])
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
    printf("sysinfotest: starting\n");
 12e:	00001517          	auipc	a0,0x1
 132:	9a250513          	addi	a0,a0,-1630 # ad0 <malloc+0x232>
 136:	6b4000ef          	jal	7ea <printf>
    
    testcall();
 13a:	ec7ff0ef          	jal	0 <testcall>
    testmem();
 13e:	f09ff0ef          	jal	46 <testmem>
    testproc();
 142:	f75ff0ef          	jal	b6 <testproc>
    
    printf("sysinfotest: OK\n");
 146:	00001517          	auipc	a0,0x1
 14a:	9a250513          	addi	a0,a0,-1630 # ae8 <malloc+0x24a>
 14e:	69c000ef          	jal	7ea <printf>
    exit(0);
 152:	4501                	li	a0,0
 154:	26e000ef          	jal	3c2 <exit>

0000000000000158 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 158:	1141                	addi	sp,sp,-16
 15a:	e406                	sd	ra,8(sp)
 15c:	e022                	sd	s0,0(sp)
 15e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 160:	fc7ff0ef          	jal	126 <main>
  exit(0);
 164:	4501                	li	a0,0
 166:	25c000ef          	jal	3c2 <exit>

000000000000016a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 170:	87aa                	mv	a5,a0
 172:	0585                	addi	a1,a1,1
 174:	0785                	addi	a5,a5,1
 176:	fff5c703          	lbu	a4,-1(a1)
 17a:	fee78fa3          	sb	a4,-1(a5)
 17e:	fb75                	bnez	a4,172 <strcpy+0x8>
    ;
  return os;
}
 180:	6422                	ld	s0,8(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 18c:	00054783          	lbu	a5,0(a0)
 190:	cb91                	beqz	a5,1a4 <strcmp+0x1e>
 192:	0005c703          	lbu	a4,0(a1)
 196:	00f71763          	bne	a4,a5,1a4 <strcmp+0x1e>
    p++, q++;
 19a:	0505                	addi	a0,a0,1
 19c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	fbe5                	bnez	a5,192 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a4:	0005c503          	lbu	a0,0(a1)
}
 1a8:	40a7853b          	subw	a0,a5,a0
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strlen>:

uint
strlen(const char *s)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cf91                	beqz	a5,1d8 <strlen+0x26>
 1be:	0505                	addi	a0,a0,1
 1c0:	87aa                	mv	a5,a0
 1c2:	86be                	mv	a3,a5
 1c4:	0785                	addi	a5,a5,1
 1c6:	fff7c703          	lbu	a4,-1(a5)
 1ca:	ff65                	bnez	a4,1c2 <strlen+0x10>
 1cc:	40a6853b          	subw	a0,a3,a0
 1d0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret
  for(n = 0; s[n]; n++)
 1d8:	4501                	li	a0,0
 1da:	bfe5                	j	1d2 <strlen+0x20>

00000000000001dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e422                	sd	s0,8(sp)
 1e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e2:	ca19                	beqz	a2,1f8 <memset+0x1c>
 1e4:	87aa                	mv	a5,a0
 1e6:	1602                	slli	a2,a2,0x20
 1e8:	9201                	srli	a2,a2,0x20
 1ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f2:	0785                	addi	a5,a5,1
 1f4:	fee79de3          	bne	a5,a4,1ee <memset+0x12>
  }
  return dst;
}
 1f8:	6422                	ld	s0,8(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret

00000000000001fe <strchr>:

char*
strchr(const char *s, char c)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  for(; *s; s++)
 204:	00054783          	lbu	a5,0(a0)
 208:	cb99                	beqz	a5,21e <strchr+0x20>
    if(*s == c)
 20a:	00f58763          	beq	a1,a5,218 <strchr+0x1a>
  for(; *s; s++)
 20e:	0505                	addi	a0,a0,1
 210:	00054783          	lbu	a5,0(a0)
 214:	fbfd                	bnez	a5,20a <strchr+0xc>
      return (char*)s;
  return 0;
 216:	4501                	li	a0,0
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  return 0;
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <strchr+0x1a>

0000000000000222 <gets>:

char*
gets(char *buf, int max)
{
 222:	711d                	addi	sp,sp,-96
 224:	ec86                	sd	ra,88(sp)
 226:	e8a2                	sd	s0,80(sp)
 228:	e4a6                	sd	s1,72(sp)
 22a:	e0ca                	sd	s2,64(sp)
 22c:	fc4e                	sd	s3,56(sp)
 22e:	f852                	sd	s4,48(sp)
 230:	f456                	sd	s5,40(sp)
 232:	f05a                	sd	s6,32(sp)
 234:	ec5e                	sd	s7,24(sp)
 236:	1080                	addi	s0,sp,96
 238:	8baa                	mv	s7,a0
 23a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23c:	892a                	mv	s2,a0
 23e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 240:	4aa9                	li	s5,10
 242:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 244:	89a6                	mv	s3,s1
 246:	2485                	addiw	s1,s1,1
 248:	0344d663          	bge	s1,s4,274 <gets+0x52>
    cc = read(0, &c, 1);
 24c:	4605                	li	a2,1
 24e:	faf40593          	addi	a1,s0,-81
 252:	4501                	li	a0,0
 254:	186000ef          	jal	3da <read>
    if(cc < 1)
 258:	00a05e63          	blez	a0,274 <gets+0x52>
    buf[i++] = c;
 25c:	faf44783          	lbu	a5,-81(s0)
 260:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 264:	01578763          	beq	a5,s5,272 <gets+0x50>
 268:	0905                	addi	s2,s2,1
 26a:	fd679de3          	bne	a5,s6,244 <gets+0x22>
    buf[i++] = c;
 26e:	89a6                	mv	s3,s1
 270:	a011                	j	274 <gets+0x52>
 272:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 274:	99de                	add	s3,s3,s7
 276:	00098023          	sb	zero,0(s3)
  return buf;
}
 27a:	855e                	mv	a0,s7
 27c:	60e6                	ld	ra,88(sp)
 27e:	6446                	ld	s0,80(sp)
 280:	64a6                	ld	s1,72(sp)
 282:	6906                	ld	s2,64(sp)
 284:	79e2                	ld	s3,56(sp)
 286:	7a42                	ld	s4,48(sp)
 288:	7aa2                	ld	s5,40(sp)
 28a:	7b02                	ld	s6,32(sp)
 28c:	6be2                	ld	s7,24(sp)
 28e:	6125                	addi	sp,sp,96
 290:	8082                	ret

0000000000000292 <stat>:

int
stat(const char *n, struct stat *st)
{
 292:	1101                	addi	sp,sp,-32
 294:	ec06                	sd	ra,24(sp)
 296:	e822                	sd	s0,16(sp)
 298:	e04a                	sd	s2,0(sp)
 29a:	1000                	addi	s0,sp,32
 29c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29e:	4581                	li	a1,0
 2a0:	162000ef          	jal	402 <open>
  if(fd < 0)
 2a4:	02054263          	bltz	a0,2c8 <stat+0x36>
 2a8:	e426                	sd	s1,8(sp)
 2aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ac:	85ca                	mv	a1,s2
 2ae:	16c000ef          	jal	41a <fstat>
 2b2:	892a                	mv	s2,a0
  close(fd);
 2b4:	8526                	mv	a0,s1
 2b6:	134000ef          	jal	3ea <close>
  return r;
 2ba:	64a2                	ld	s1,8(sp)
}
 2bc:	854a                	mv	a0,s2
 2be:	60e2                	ld	ra,24(sp)
 2c0:	6442                	ld	s0,16(sp)
 2c2:	6902                	ld	s2,0(sp)
 2c4:	6105                	addi	sp,sp,32
 2c6:	8082                	ret
    return -1;
 2c8:	597d                	li	s2,-1
 2ca:	bfcd                	j	2bc <stat+0x2a>

00000000000002cc <atoi>:

int
atoi(const char *s)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d2:	00054683          	lbu	a3,0(a0)
 2d6:	fd06879b          	addiw	a5,a3,-48
 2da:	0ff7f793          	zext.b	a5,a5
 2de:	4625                	li	a2,9
 2e0:	02f66863          	bltu	a2,a5,310 <atoi+0x44>
 2e4:	872a                	mv	a4,a0
  n = 0;
 2e6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2e8:	0705                	addi	a4,a4,1
 2ea:	0025179b          	slliw	a5,a0,0x2
 2ee:	9fa9                	addw	a5,a5,a0
 2f0:	0017979b          	slliw	a5,a5,0x1
 2f4:	9fb5                	addw	a5,a5,a3
 2f6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2fa:	00074683          	lbu	a3,0(a4)
 2fe:	fd06879b          	addiw	a5,a3,-48
 302:	0ff7f793          	zext.b	a5,a5
 306:	fef671e3          	bgeu	a2,a5,2e8 <atoi+0x1c>
  return n;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
  n = 0;
 310:	4501                	li	a0,0
 312:	bfe5                	j	30a <atoi+0x3e>

0000000000000314 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 31a:	02b57463          	bgeu	a0,a1,342 <memmove+0x2e>
    while(n-- > 0)
 31e:	00c05f63          	blez	a2,33c <memmove+0x28>
 322:	1602                	slli	a2,a2,0x20
 324:	9201                	srli	a2,a2,0x20
 326:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 32a:	872a                	mv	a4,a0
      *dst++ = *src++;
 32c:	0585                	addi	a1,a1,1
 32e:	0705                	addi	a4,a4,1
 330:	fff5c683          	lbu	a3,-1(a1)
 334:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 338:	fef71ae3          	bne	a4,a5,32c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
    dst += n;
 342:	00c50733          	add	a4,a0,a2
    src += n;
 346:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 348:	fec05ae3          	blez	a2,33c <memmove+0x28>
 34c:	fff6079b          	addiw	a5,a2,-1
 350:	1782                	slli	a5,a5,0x20
 352:	9381                	srli	a5,a5,0x20
 354:	fff7c793          	not	a5,a5
 358:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 35a:	15fd                	addi	a1,a1,-1
 35c:	177d                	addi	a4,a4,-1
 35e:	0005c683          	lbu	a3,0(a1)
 362:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 366:	fee79ae3          	bne	a5,a4,35a <memmove+0x46>
 36a:	bfc9                	j	33c <memmove+0x28>

000000000000036c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e422                	sd	s0,8(sp)
 370:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 372:	ca05                	beqz	a2,3a2 <memcmp+0x36>
 374:	fff6069b          	addiw	a3,a2,-1
 378:	1682                	slli	a3,a3,0x20
 37a:	9281                	srli	a3,a3,0x20
 37c:	0685                	addi	a3,a3,1
 37e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 380:	00054783          	lbu	a5,0(a0)
 384:	0005c703          	lbu	a4,0(a1)
 388:	00e79863          	bne	a5,a4,398 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 38c:	0505                	addi	a0,a0,1
    p2++;
 38e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 390:	fed518e3          	bne	a0,a3,380 <memcmp+0x14>
  }
  return 0;
 394:	4501                	li	a0,0
 396:	a019                	j	39c <memcmp+0x30>
      return *p1 - *p2;
 398:	40e7853b          	subw	a0,a5,a4
}
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
  return 0;
 3a2:	4501                	li	a0,0
 3a4:	bfe5                	j	39c <memcmp+0x30>

00000000000003a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e406                	sd	ra,8(sp)
 3aa:	e022                	sd	s0,0(sp)
 3ac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ae:	f67ff0ef          	jal	314 <memmove>
}
 3b2:	60a2                	ld	ra,8(sp)
 3b4:	6402                	ld	s0,0(sp)
 3b6:	0141                	addi	sp,sp,16
 3b8:	8082                	ret

00000000000003ba <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ba:	4885                	li	a7,1
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c2:	4889                	li	a7,2
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ca:	488d                	li	a7,3
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d2:	4891                	li	a7,4
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <read>:
.global read
read:
 li a7, SYS_read
 3da:	4895                	li	a7,5
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <write>:
.global write
write:
 li a7, SYS_write
 3e2:	48c1                	li	a7,16
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <close>:
.global close
close:
 li a7, SYS_close
 3ea:	48d5                	li	a7,21
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f2:	4899                	li	a7,6
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <exec>:
.global exec
exec:
 li a7, SYS_exec
 3fa:	489d                	li	a7,7
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <open>:
.global open
open:
 li a7, SYS_open
 402:	48bd                	li	a7,15
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 40a:	48c5                	li	a7,17
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 412:	48c9                	li	a7,18
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 41a:	48a1                	li	a7,8
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <link>:
.global link
link:
 li a7, SYS_link
 422:	48cd                	li	a7,19
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 42a:	48d1                	li	a7,20
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 432:	48a5                	li	a7,9
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <dup>:
.global dup
dup:
 li a7, SYS_dup
 43a:	48a9                	li	a7,10
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 442:	48ad                	li	a7,11
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 44a:	48b1                	li	a7,12
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 452:	48b5                	li	a7,13
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 45a:	48b9                	li	a7,14
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <trace>:
.global trace
trace:
 li a7, SYS_trace
 462:	48d9                	li	a7,22
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 46a:	48dd                	li	a7,23
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 472:	1101                	addi	sp,sp,-32
 474:	ec06                	sd	ra,24(sp)
 476:	e822                	sd	s0,16(sp)
 478:	1000                	addi	s0,sp,32
 47a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47e:	4605                	li	a2,1
 480:	fef40593          	addi	a1,s0,-17
 484:	f5fff0ef          	jal	3e2 <write>
}
 488:	60e2                	ld	ra,24(sp)
 48a:	6442                	ld	s0,16(sp)
 48c:	6105                	addi	sp,sp,32
 48e:	8082                	ret

0000000000000490 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 490:	7139                	addi	sp,sp,-64
 492:	fc06                	sd	ra,56(sp)
 494:	f822                	sd	s0,48(sp)
 496:	f426                	sd	s1,40(sp)
 498:	0080                	addi	s0,sp,64
 49a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 49c:	c299                	beqz	a3,4a2 <printint+0x12>
 49e:	0805c963          	bltz	a1,530 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4a2:	2581                	sext.w	a1,a1
  neg = 0;
 4a4:	4881                	li	a7,0
 4a6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4aa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ac:	2601                	sext.w	a2,a2
 4ae:	00000517          	auipc	a0,0x0
 4b2:	65a50513          	addi	a0,a0,1626 # b08 <digits>
 4b6:	883a                	mv	a6,a4
 4b8:	2705                	addiw	a4,a4,1
 4ba:	02c5f7bb          	remuw	a5,a1,a2
 4be:	1782                	slli	a5,a5,0x20
 4c0:	9381                	srli	a5,a5,0x20
 4c2:	97aa                	add	a5,a5,a0
 4c4:	0007c783          	lbu	a5,0(a5)
 4c8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4cc:	0005879b          	sext.w	a5,a1
 4d0:	02c5d5bb          	divuw	a1,a1,a2
 4d4:	0685                	addi	a3,a3,1
 4d6:	fec7f0e3          	bgeu	a5,a2,4b6 <printint+0x26>
  if(neg)
 4da:	00088c63          	beqz	a7,4f2 <printint+0x62>
    buf[i++] = '-';
 4de:	fd070793          	addi	a5,a4,-48
 4e2:	00878733          	add	a4,a5,s0
 4e6:	02d00793          	li	a5,45
 4ea:	fef70823          	sb	a5,-16(a4)
 4ee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f2:	02e05a63          	blez	a4,526 <printint+0x96>
 4f6:	f04a                	sd	s2,32(sp)
 4f8:	ec4e                	sd	s3,24(sp)
 4fa:	fc040793          	addi	a5,s0,-64
 4fe:	00e78933          	add	s2,a5,a4
 502:	fff78993          	addi	s3,a5,-1
 506:	99ba                	add	s3,s3,a4
 508:	377d                	addiw	a4,a4,-1
 50a:	1702                	slli	a4,a4,0x20
 50c:	9301                	srli	a4,a4,0x20
 50e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 512:	fff94583          	lbu	a1,-1(s2)
 516:	8526                	mv	a0,s1
 518:	f5bff0ef          	jal	472 <putc>
  while(--i >= 0)
 51c:	197d                	addi	s2,s2,-1
 51e:	ff391ae3          	bne	s2,s3,512 <printint+0x82>
 522:	7902                	ld	s2,32(sp)
 524:	69e2                	ld	s3,24(sp)
}
 526:	70e2                	ld	ra,56(sp)
 528:	7442                	ld	s0,48(sp)
 52a:	74a2                	ld	s1,40(sp)
 52c:	6121                	addi	sp,sp,64
 52e:	8082                	ret
    x = -xx;
 530:	40b005bb          	negw	a1,a1
    neg = 1;
 534:	4885                	li	a7,1
    x = -xx;
 536:	bf85                	j	4a6 <printint+0x16>

0000000000000538 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 538:	711d                	addi	sp,sp,-96
 53a:	ec86                	sd	ra,88(sp)
 53c:	e8a2                	sd	s0,80(sp)
 53e:	e0ca                	sd	s2,64(sp)
 540:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 542:	0005c903          	lbu	s2,0(a1)
 546:	26090863          	beqz	s2,7b6 <vprintf+0x27e>
 54a:	e4a6                	sd	s1,72(sp)
 54c:	fc4e                	sd	s3,56(sp)
 54e:	f852                	sd	s4,48(sp)
 550:	f456                	sd	s5,40(sp)
 552:	f05a                	sd	s6,32(sp)
 554:	ec5e                	sd	s7,24(sp)
 556:	e862                	sd	s8,16(sp)
 558:	e466                	sd	s9,8(sp)
 55a:	8b2a                	mv	s6,a0
 55c:	8a2e                	mv	s4,a1
 55e:	8bb2                	mv	s7,a2
  state = 0;
 560:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 562:	4481                	li	s1,0
 564:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 566:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 56a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 56e:	06c00c93          	li	s9,108
 572:	a005                	j	592 <vprintf+0x5a>
        putc(fd, c0);
 574:	85ca                	mv	a1,s2
 576:	855a                	mv	a0,s6
 578:	efbff0ef          	jal	472 <putc>
 57c:	a019                	j	582 <vprintf+0x4a>
    } else if(state == '%'){
 57e:	03598263          	beq	s3,s5,5a2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 582:	2485                	addiw	s1,s1,1
 584:	8726                	mv	a4,s1
 586:	009a07b3          	add	a5,s4,s1
 58a:	0007c903          	lbu	s2,0(a5)
 58e:	20090c63          	beqz	s2,7a6 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 592:	0009079b          	sext.w	a5,s2
    if(state == 0){
 596:	fe0994e3          	bnez	s3,57e <vprintf+0x46>
      if(c0 == '%'){
 59a:	fd579de3          	bne	a5,s5,574 <vprintf+0x3c>
        state = '%';
 59e:	89be                	mv	s3,a5
 5a0:	b7cd                	j	582 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5a2:	00ea06b3          	add	a3,s4,a4
 5a6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5aa:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5ac:	c681                	beqz	a3,5b4 <vprintf+0x7c>
 5ae:	9752                	add	a4,a4,s4
 5b0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5b4:	03878f63          	beq	a5,s8,5f2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5b8:	05978963          	beq	a5,s9,60a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5bc:	07500713          	li	a4,117
 5c0:	0ee78363          	beq	a5,a4,6a6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5c4:	07800713          	li	a4,120
 5c8:	12e78563          	beq	a5,a4,6f2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5cc:	07000713          	li	a4,112
 5d0:	14e78a63          	beq	a5,a4,724 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5d4:	07300713          	li	a4,115
 5d8:	18e78a63          	beq	a5,a4,76c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5dc:	02500713          	li	a4,37
 5e0:	04e79563          	bne	a5,a4,62a <vprintf+0xf2>
        putc(fd, '%');
 5e4:	02500593          	li	a1,37
 5e8:	855a                	mv	a0,s6
 5ea:	e89ff0ef          	jal	472 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bf49                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	4685                	li	a3,1
 5f8:	4629                	li	a2,10
 5fa:	000ba583          	lw	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	e91ff0ef          	jal	490 <printint>
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	bfad                	j	582 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 60a:	06400793          	li	a5,100
 60e:	02f68963          	beq	a3,a5,640 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 612:	06c00793          	li	a5,108
 616:	04f68263          	beq	a3,a5,65a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 61a:	07500793          	li	a5,117
 61e:	0af68063          	beq	a3,a5,6be <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 622:	07800793          	li	a5,120
 626:	0ef68263          	beq	a3,a5,70a <vprintf+0x1d2>
        putc(fd, '%');
 62a:	02500593          	li	a1,37
 62e:	855a                	mv	a0,s6
 630:	e43ff0ef          	jal	472 <putc>
        putc(fd, c0);
 634:	85ca                	mv	a1,s2
 636:	855a                	mv	a0,s6
 638:	e3bff0ef          	jal	472 <putc>
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b791                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 640:	008b8913          	addi	s2,s7,8
 644:	4685                	li	a3,1
 646:	4629                	li	a2,10
 648:	000ba583          	lw	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	e43ff0ef          	jal	490 <printint>
        i += 1;
 652:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
        i += 1;
 658:	b72d                	j	582 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 65a:	06400793          	li	a5,100
 65e:	02f60763          	beq	a2,a5,68c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 662:	07500793          	li	a5,117
 666:	06f60963          	beq	a2,a5,6d8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 66a:	07800793          	li	a5,120
 66e:	faf61ee3          	bne	a2,a5,62a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 672:	008b8913          	addi	s2,s7,8
 676:	4681                	li	a3,0
 678:	4641                	li	a2,16
 67a:	000ba583          	lw	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	e11ff0ef          	jal	490 <printint>
        i += 2;
 684:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 686:	8bca                	mv	s7,s2
      state = 0;
 688:	4981                	li	s3,0
        i += 2;
 68a:	bde5                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 68c:	008b8913          	addi	s2,s7,8
 690:	4685                	li	a3,1
 692:	4629                	li	a2,10
 694:	000ba583          	lw	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	df7ff0ef          	jal	490 <printint>
        i += 2;
 69e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
        i += 2;
 6a4:	bdf9                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4629                	li	a2,10
 6ae:	000ba583          	lw	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	dddff0ef          	jal	490 <printint>
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b5d9                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	008b8913          	addi	s2,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4629                	li	a2,10
 6c6:	000ba583          	lw	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	dc5ff0ef          	jal	490 <printint>
        i += 1;
 6d0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d2:	8bca                	mv	s7,s2
      state = 0;
 6d4:	4981                	li	s3,0
        i += 1;
 6d6:	b575                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4681                	li	a3,0
 6de:	4629                	li	a2,10
 6e0:	000ba583          	lw	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	dabff0ef          	jal	490 <printint>
        i += 2;
 6ea:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
        i += 2;
 6f0:	bd49                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000ba583          	lw	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	d91ff0ef          	jal	490 <printint>
 704:	8bca                	mv	s7,s2
      state = 0;
 706:	4981                	li	s3,0
 708:	bdad                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 70a:	008b8913          	addi	s2,s7,8
 70e:	4681                	li	a3,0
 710:	4641                	li	a2,16
 712:	000ba583          	lw	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	d79ff0ef          	jal	490 <printint>
        i += 1;
 71c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
        i += 1;
 722:	b585                	j	582 <vprintf+0x4a>
 724:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 726:	008b8d13          	addi	s10,s7,8
 72a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 72e:	03000593          	li	a1,48
 732:	855a                	mv	a0,s6
 734:	d3fff0ef          	jal	472 <putc>
  putc(fd, 'x');
 738:	07800593          	li	a1,120
 73c:	855a                	mv	a0,s6
 73e:	d35ff0ef          	jal	472 <putc>
 742:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 744:	00000b97          	auipc	s7,0x0
 748:	3c4b8b93          	addi	s7,s7,964 # b08 <digits>
 74c:	03c9d793          	srli	a5,s3,0x3c
 750:	97de                	add	a5,a5,s7
 752:	0007c583          	lbu	a1,0(a5)
 756:	855a                	mv	a0,s6
 758:	d1bff0ef          	jal	472 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 75c:	0992                	slli	s3,s3,0x4
 75e:	397d                	addiw	s2,s2,-1
 760:	fe0916e3          	bnez	s2,74c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 764:	8bea                	mv	s7,s10
      state = 0;
 766:	4981                	li	s3,0
 768:	6d02                	ld	s10,0(sp)
 76a:	bd21                	j	582 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 76c:	008b8993          	addi	s3,s7,8
 770:	000bb903          	ld	s2,0(s7)
 774:	00090f63          	beqz	s2,792 <vprintf+0x25a>
        for(; *s; s++)
 778:	00094583          	lbu	a1,0(s2)
 77c:	c195                	beqz	a1,7a0 <vprintf+0x268>
          putc(fd, *s);
 77e:	855a                	mv	a0,s6
 780:	cf3ff0ef          	jal	472 <putc>
        for(; *s; s++)
 784:	0905                	addi	s2,s2,1
 786:	00094583          	lbu	a1,0(s2)
 78a:	f9f5                	bnez	a1,77e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 78c:	8bce                	mv	s7,s3
      state = 0;
 78e:	4981                	li	s3,0
 790:	bbcd                	j	582 <vprintf+0x4a>
          s = "(null)";
 792:	00000917          	auipc	s2,0x0
 796:	36e90913          	addi	s2,s2,878 # b00 <malloc+0x262>
        for(; *s; s++)
 79a:	02800593          	li	a1,40
 79e:	b7c5                	j	77e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7a0:	8bce                	mv	s7,s3
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	bbf9                	j	582 <vprintf+0x4a>
 7a6:	64a6                	ld	s1,72(sp)
 7a8:	79e2                	ld	s3,56(sp)
 7aa:	7a42                	ld	s4,48(sp)
 7ac:	7aa2                	ld	s5,40(sp)
 7ae:	7b02                	ld	s6,32(sp)
 7b0:	6be2                	ld	s7,24(sp)
 7b2:	6c42                	ld	s8,16(sp)
 7b4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7b6:	60e6                	ld	ra,88(sp)
 7b8:	6446                	ld	s0,80(sp)
 7ba:	6906                	ld	s2,64(sp)
 7bc:	6125                	addi	sp,sp,96
 7be:	8082                	ret

00000000000007c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c0:	715d                	addi	sp,sp,-80
 7c2:	ec06                	sd	ra,24(sp)
 7c4:	e822                	sd	s0,16(sp)
 7c6:	1000                	addi	s0,sp,32
 7c8:	e010                	sd	a2,0(s0)
 7ca:	e414                	sd	a3,8(s0)
 7cc:	e818                	sd	a4,16(s0)
 7ce:	ec1c                	sd	a5,24(s0)
 7d0:	03043023          	sd	a6,32(s0)
 7d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7dc:	8622                	mv	a2,s0
 7de:	d5bff0ef          	jal	538 <vprintf>
}
 7e2:	60e2                	ld	ra,24(sp)
 7e4:	6442                	ld	s0,16(sp)
 7e6:	6161                	addi	sp,sp,80
 7e8:	8082                	ret

00000000000007ea <printf>:

void
printf(const char *fmt, ...)
{
 7ea:	711d                	addi	sp,sp,-96
 7ec:	ec06                	sd	ra,24(sp)
 7ee:	e822                	sd	s0,16(sp)
 7f0:	1000                	addi	s0,sp,32
 7f2:	e40c                	sd	a1,8(s0)
 7f4:	e810                	sd	a2,16(s0)
 7f6:	ec14                	sd	a3,24(s0)
 7f8:	f018                	sd	a4,32(s0)
 7fa:	f41c                	sd	a5,40(s0)
 7fc:	03043823          	sd	a6,48(s0)
 800:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 804:	00840613          	addi	a2,s0,8
 808:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80c:	85aa                	mv	a1,a0
 80e:	4505                	li	a0,1
 810:	d29ff0ef          	jal	538 <vprintf>
}
 814:	60e2                	ld	ra,24(sp)
 816:	6442                	ld	s0,16(sp)
 818:	6125                	addi	sp,sp,96
 81a:	8082                	ret

000000000000081c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81c:	1141                	addi	sp,sp,-16
 81e:	e422                	sd	s0,8(sp)
 820:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 822:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 826:	00000797          	auipc	a5,0x0
 82a:	7da7b783          	ld	a5,2010(a5) # 1000 <freep>
 82e:	a02d                	j	858 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 830:	4618                	lw	a4,8(a2)
 832:	9f2d                	addw	a4,a4,a1
 834:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 838:	6398                	ld	a4,0(a5)
 83a:	6310                	ld	a2,0(a4)
 83c:	a83d                	j	87a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 83e:	ff852703          	lw	a4,-8(a0)
 842:	9f31                	addw	a4,a4,a2
 844:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 846:	ff053683          	ld	a3,-16(a0)
 84a:	a091                	j	88e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84c:	6398                	ld	a4,0(a5)
 84e:	00e7e463          	bltu	a5,a4,856 <free+0x3a>
 852:	00e6ea63          	bltu	a3,a4,866 <free+0x4a>
{
 856:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 858:	fed7fae3          	bgeu	a5,a3,84c <free+0x30>
 85c:	6398                	ld	a4,0(a5)
 85e:	00e6e463          	bltu	a3,a4,866 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 862:	fee7eae3          	bltu	a5,a4,856 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 866:	ff852583          	lw	a1,-8(a0)
 86a:	6390                	ld	a2,0(a5)
 86c:	02059813          	slli	a6,a1,0x20
 870:	01c85713          	srli	a4,a6,0x1c
 874:	9736                	add	a4,a4,a3
 876:	fae60de3          	beq	a2,a4,830 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 87a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 87e:	4790                	lw	a2,8(a5)
 880:	02061593          	slli	a1,a2,0x20
 884:	01c5d713          	srli	a4,a1,0x1c
 888:	973e                	add	a4,a4,a5
 88a:	fae68ae3          	beq	a3,a4,83e <free+0x22>
    p->s.ptr = bp->s.ptr;
 88e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 890:	00000717          	auipc	a4,0x0
 894:	76f73823          	sd	a5,1904(a4) # 1000 <freep>
}
 898:	6422                	ld	s0,8(sp)
 89a:	0141                	addi	sp,sp,16
 89c:	8082                	ret

000000000000089e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 89e:	7139                	addi	sp,sp,-64
 8a0:	fc06                	sd	ra,56(sp)
 8a2:	f822                	sd	s0,48(sp)
 8a4:	f426                	sd	s1,40(sp)
 8a6:	ec4e                	sd	s3,24(sp)
 8a8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8aa:	02051493          	slli	s1,a0,0x20
 8ae:	9081                	srli	s1,s1,0x20
 8b0:	04bd                	addi	s1,s1,15
 8b2:	8091                	srli	s1,s1,0x4
 8b4:	0014899b          	addiw	s3,s1,1
 8b8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ba:	00000517          	auipc	a0,0x0
 8be:	74653503          	ld	a0,1862(a0) # 1000 <freep>
 8c2:	c915                	beqz	a0,8f6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c6:	4798                	lw	a4,8(a5)
 8c8:	08977a63          	bgeu	a4,s1,95c <malloc+0xbe>
 8cc:	f04a                	sd	s2,32(sp)
 8ce:	e852                	sd	s4,16(sp)
 8d0:	e456                	sd	s5,8(sp)
 8d2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8d4:	8a4e                	mv	s4,s3
 8d6:	0009871b          	sext.w	a4,s3
 8da:	6685                	lui	a3,0x1
 8dc:	00d77363          	bgeu	a4,a3,8e2 <malloc+0x44>
 8e0:	6a05                	lui	s4,0x1
 8e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ea:	00000917          	auipc	s2,0x0
 8ee:	71690913          	addi	s2,s2,1814 # 1000 <freep>
  if(p == (char*)-1)
 8f2:	5afd                	li	s5,-1
 8f4:	a081                	j	934 <malloc+0x96>
 8f6:	f04a                	sd	s2,32(sp)
 8f8:	e852                	sd	s4,16(sp)
 8fa:	e456                	sd	s5,8(sp)
 8fc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8fe:	00000797          	auipc	a5,0x0
 902:	71278793          	addi	a5,a5,1810 # 1010 <base>
 906:	00000717          	auipc	a4,0x0
 90a:	6ef73d23          	sd	a5,1786(a4) # 1000 <freep>
 90e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 910:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 914:	b7c1                	j	8d4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 916:	6398                	ld	a4,0(a5)
 918:	e118                	sd	a4,0(a0)
 91a:	a8a9                	j	974 <malloc+0xd6>
  hp->s.size = nu;
 91c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 920:	0541                	addi	a0,a0,16
 922:	efbff0ef          	jal	81c <free>
  return freep;
 926:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 92a:	c12d                	beqz	a0,98c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92e:	4798                	lw	a4,8(a5)
 930:	02977263          	bgeu	a4,s1,954 <malloc+0xb6>
    if(p == freep)
 934:	00093703          	ld	a4,0(s2)
 938:	853e                	mv	a0,a5
 93a:	fef719e3          	bne	a4,a5,92c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 93e:	8552                	mv	a0,s4
 940:	b0bff0ef          	jal	44a <sbrk>
  if(p == (char*)-1)
 944:	fd551ce3          	bne	a0,s5,91c <malloc+0x7e>
        return 0;
 948:	4501                	li	a0,0
 94a:	7902                	ld	s2,32(sp)
 94c:	6a42                	ld	s4,16(sp)
 94e:	6aa2                	ld	s5,8(sp)
 950:	6b02                	ld	s6,0(sp)
 952:	a03d                	j	980 <malloc+0xe2>
 954:	7902                	ld	s2,32(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 95c:	fae48de3          	beq	s1,a4,916 <malloc+0x78>
        p->s.size -= nunits;
 960:	4137073b          	subw	a4,a4,s3
 964:	c798                	sw	a4,8(a5)
        p += p->s.size;
 966:	02071693          	slli	a3,a4,0x20
 96a:	01c6d713          	srli	a4,a3,0x1c
 96e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 970:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 974:	00000717          	auipc	a4,0x0
 978:	68a73623          	sd	a0,1676(a4) # 1000 <freep>
      return (void*)(p + 1);
 97c:	01078513          	addi	a0,a5,16
  }
}
 980:	70e2                	ld	ra,56(sp)
 982:	7442                	ld	s0,48(sp)
 984:	74a2                	ld	s1,40(sp)
 986:	69e2                	ld	s3,24(sp)
 988:	6121                	addi	sp,sp,64
 98a:	8082                	ret
 98c:	7902                	ld	s2,32(sp)
 98e:	6a42                	ld	s4,16(sp)
 990:	6aa2                	ld	s5,8(sp)
 992:	6b02                	ld	s6,0(sp)
 994:	b7f5                	j	980 <malloc+0xe2>
