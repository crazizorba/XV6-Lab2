
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	41013103          	ld	sp,1040(sp) # 8000a410 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	5d9040ef          	jal	80004dee <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00023797          	auipc	a5,0x23
    80000034:	76078793          	addi	a5,a5,1888 # 80023790 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	148000ef          	jal	80000190 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	41490913          	addi	s2,s2,1044 # 8000a460 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	7fa050ef          	jal	80005850 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	083050ef          	jal	800058e8 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	4a4050ef          	jal	80005522 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	38650513          	addi	a0,a0,902 # 8000a460 <kmem>
    800000e2:	6ee050ef          	jal	800057d0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	6a650513          	addi	a0,a0,1702 # 80023790 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	35848493          	addi	s1,s1,856 # 8000a460 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	73e050ef          	jal	80005850 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	34450513          	addi	a0,a0,836 # 8000a460 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	7c2050ef          	jal	800058e8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	060000ef          	jal	80000190 <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	32050513          	addi	a0,a0,800 # 8000a460 <kmem>
    80000148:	7a0050ef          	jal	800058e8 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <getfreemem>:

uint64
getfreemem(void)
{
    8000014e:	1101                	addi	sp,sp,-32
    80000150:	ec06                	sd	ra,24(sp)
    80000152:	e822                	sd	s0,16(sp)
    80000154:	e426                	sd	s1,8(sp)
    80000156:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 freemem = 0;
  
  acquire(&kmem.lock);
    80000158:	0000a497          	auipc	s1,0xa
    8000015c:	30848493          	addi	s1,s1,776 # 8000a460 <kmem>
    80000160:	8526                	mv	a0,s1
    80000162:	6ee050ef          	jal	80005850 <acquire>
  r = kmem.freelist;
    80000166:	6c9c                	ld	a5,24(s1)

  while(r){
    80000168:	c395                	beqz	a5,8000018c <getfreemem+0x3e>
  uint64 freemem = 0;
    8000016a:	4481                	li	s1,0
    freemem += PGSIZE;
    8000016c:	6705                	lui	a4,0x1
    8000016e:	94ba                	add	s1,s1,a4
    r = r->next;
    80000170:	639c                	ld	a5,0(a5)
  while(r){
    80000172:	fff5                	bnez	a5,8000016e <getfreemem+0x20>
  }
  
  release(&kmem.lock);
    80000174:	0000a517          	auipc	a0,0xa
    80000178:	2ec50513          	addi	a0,a0,748 # 8000a460 <kmem>
    8000017c:	76c050ef          	jal	800058e8 <release>
  return freemem;
    80000180:	8526                	mv	a0,s1
    80000182:	60e2                	ld	ra,24(sp)
    80000184:	6442                	ld	s0,16(sp)
    80000186:	64a2                	ld	s1,8(sp)
    80000188:	6105                	addi	sp,sp,32
    8000018a:	8082                	ret
  uint64 freemem = 0;
    8000018c:	4481                	li	s1,0
    8000018e:	b7dd                	j	80000174 <getfreemem+0x26>

0000000080000190 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000190:	1141                	addi	sp,sp,-16
    80000192:	e422                	sd	s0,8(sp)
    80000194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000196:	ca19                	beqz	a2,800001ac <memset+0x1c>
    80000198:	87aa                	mv	a5,a0
    8000019a:	1602                	slli	a2,a2,0x20
    8000019c:	9201                	srli	a2,a2,0x20
    8000019e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001a6:	0785                	addi	a5,a5,1
    800001a8:	fee79de3          	bne	a5,a4,800001a2 <memset+0x12>
  }
  return dst;
}
    800001ac:	6422                	ld	s0,8(sp)
    800001ae:	0141                	addi	sp,sp,16
    800001b0:	8082                	ret

00000000800001b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e422                	sd	s0,8(sp)
    800001b6:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001b8:	ca05                	beqz	a2,800001e8 <memcmp+0x36>
    800001ba:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001be:	1682                	slli	a3,a3,0x20
    800001c0:	9281                	srli	a3,a3,0x20
    800001c2:	0685                	addi	a3,a3,1
    800001c4:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001c6:	00054783          	lbu	a5,0(a0)
    800001ca:	0005c703          	lbu	a4,0(a1)
    800001ce:	00e79863          	bne	a5,a4,800001de <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001d2:	0505                	addi	a0,a0,1
    800001d4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001d6:	fed518e3          	bne	a0,a3,800001c6 <memcmp+0x14>
  }

  return 0;
    800001da:	4501                	li	a0,0
    800001dc:	a019                	j	800001e2 <memcmp+0x30>
      return *s1 - *s2;
    800001de:	40e7853b          	subw	a0,a5,a4
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret
  return 0;
    800001e8:	4501                	li	a0,0
    800001ea:	bfe5                	j	800001e2 <memcmp+0x30>

00000000800001ec <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001ec:	1141                	addi	sp,sp,-16
    800001ee:	e422                	sd	s0,8(sp)
    800001f0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001f2:	c205                	beqz	a2,80000212 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001f4:	02a5e263          	bltu	a1,a0,80000218 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f8:	1602                	slli	a2,a2,0x20
    800001fa:	9201                	srli	a2,a2,0x20
    800001fc:	00c587b3          	add	a5,a1,a2
{
    80000200:	872a                	mv	a4,a0
      *d++ = *s++;
    80000202:	0585                	addi	a1,a1,1
    80000204:	0705                	addi	a4,a4,1 # 1001 <_entry-0x7fffefff>
    80000206:	fff5c683          	lbu	a3,-1(a1)
    8000020a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020e:	feb79ae3          	bne	a5,a1,80000202 <memmove+0x16>

  return dst;
}
    80000212:	6422                	ld	s0,8(sp)
    80000214:	0141                	addi	sp,sp,16
    80000216:	8082                	ret
  if(s < d && s + n > d){
    80000218:	02061693          	slli	a3,a2,0x20
    8000021c:	9281                	srli	a3,a3,0x20
    8000021e:	00d58733          	add	a4,a1,a3
    80000222:	fce57be3          	bgeu	a0,a4,800001f8 <memmove+0xc>
    d += n;
    80000226:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000228:	fff6079b          	addiw	a5,a2,-1
    8000022c:	1782                	slli	a5,a5,0x20
    8000022e:	9381                	srli	a5,a5,0x20
    80000230:	fff7c793          	not	a5,a5
    80000234:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000236:	177d                	addi	a4,a4,-1
    80000238:	16fd                	addi	a3,a3,-1
    8000023a:	00074603          	lbu	a2,0(a4)
    8000023e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000242:	fef71ae3          	bne	a4,a5,80000236 <memmove+0x4a>
    80000246:	b7f1                	j	80000212 <memmove+0x26>

0000000080000248 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e406                	sd	ra,8(sp)
    8000024c:	e022                	sd	s0,0(sp)
    8000024e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000250:	f9dff0ef          	jal	800001ec <memmove>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret

000000008000025c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000025c:	1141                	addi	sp,sp,-16
    8000025e:	e422                	sd	s0,8(sp)
    80000260:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000262:	ce11                	beqz	a2,8000027e <strncmp+0x22>
    80000264:	00054783          	lbu	a5,0(a0)
    80000268:	cf89                	beqz	a5,80000282 <strncmp+0x26>
    8000026a:	0005c703          	lbu	a4,0(a1)
    8000026e:	00f71a63          	bne	a4,a5,80000282 <strncmp+0x26>
    n--, p++, q++;
    80000272:	367d                	addiw	a2,a2,-1
    80000274:	0505                	addi	a0,a0,1
    80000276:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000278:	f675                	bnez	a2,80000264 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000027a:	4501                	li	a0,0
    8000027c:	a801                	j	8000028c <strncmp+0x30>
    8000027e:	4501                	li	a0,0
    80000280:	a031                	j	8000028c <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000282:	00054503          	lbu	a0,0(a0)
    80000286:	0005c783          	lbu	a5,0(a1)
    8000028a:	9d1d                	subw	a0,a0,a5
}
    8000028c:	6422                	ld	s0,8(sp)
    8000028e:	0141                	addi	sp,sp,16
    80000290:	8082                	ret

0000000080000292 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000292:	1141                	addi	sp,sp,-16
    80000294:	e422                	sd	s0,8(sp)
    80000296:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000298:	87aa                	mv	a5,a0
    8000029a:	86b2                	mv	a3,a2
    8000029c:	367d                	addiw	a2,a2,-1
    8000029e:	02d05563          	blez	a3,800002c8 <strncpy+0x36>
    800002a2:	0785                	addi	a5,a5,1
    800002a4:	0005c703          	lbu	a4,0(a1)
    800002a8:	fee78fa3          	sb	a4,-1(a5)
    800002ac:	0585                	addi	a1,a1,1
    800002ae:	f775                	bnez	a4,8000029a <strncpy+0x8>
    ;
  while(n-- > 0)
    800002b0:	873e                	mv	a4,a5
    800002b2:	9fb5                	addw	a5,a5,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	00c05963          	blez	a2,800002c8 <strncpy+0x36>
    *s++ = 0;
    800002ba:	0705                	addi	a4,a4,1
    800002bc:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002c0:	40e786bb          	subw	a3,a5,a4
    800002c4:	fed04be3          	bgtz	a3,800002ba <strncpy+0x28>
  return os;
}
    800002c8:	6422                	ld	s0,8(sp)
    800002ca:	0141                	addi	sp,sp,16
    800002cc:	8082                	ret

00000000800002ce <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ce:	1141                	addi	sp,sp,-16
    800002d0:	e422                	sd	s0,8(sp)
    800002d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d4:	02c05363          	blez	a2,800002fa <safestrcpy+0x2c>
    800002d8:	fff6069b          	addiw	a3,a2,-1
    800002dc:	1682                	slli	a3,a3,0x20
    800002de:	9281                	srli	a3,a3,0x20
    800002e0:	96ae                	add	a3,a3,a1
    800002e2:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e4:	00d58963          	beq	a1,a3,800002f6 <safestrcpy+0x28>
    800002e8:	0585                	addi	a1,a1,1
    800002ea:	0785                	addi	a5,a5,1
    800002ec:	fff5c703          	lbu	a4,-1(a1)
    800002f0:	fee78fa3          	sb	a4,-1(a5)
    800002f4:	fb65                	bnez	a4,800002e4 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f6:	00078023          	sb	zero,0(a5)
  return os;
}
    800002fa:	6422                	ld	s0,8(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret

0000000080000300 <strlen>:

int
strlen(const char *s)
{
    80000300:	1141                	addi	sp,sp,-16
    80000302:	e422                	sd	s0,8(sp)
    80000304:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000306:	00054783          	lbu	a5,0(a0)
    8000030a:	cf91                	beqz	a5,80000326 <strlen+0x26>
    8000030c:	0505                	addi	a0,a0,1
    8000030e:	87aa                	mv	a5,a0
    80000310:	86be                	mv	a3,a5
    80000312:	0785                	addi	a5,a5,1
    80000314:	fff7c703          	lbu	a4,-1(a5)
    80000318:	ff65                	bnez	a4,80000310 <strlen+0x10>
    8000031a:	40a6853b          	subw	a0,a3,a0
    8000031e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000320:	6422                	ld	s0,8(sp)
    80000322:	0141                	addi	sp,sp,16
    80000324:	8082                	ret
  for(n = 0; s[n]; n++)
    80000326:	4501                	li	a0,0
    80000328:	bfe5                	j	80000320 <strlen+0x20>

000000008000032a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000032a:	1141                	addi	sp,sp,-16
    8000032c:	e406                	sd	ra,8(sp)
    8000032e:	e022                	sd	s0,0(sp)
    80000330:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000332:	24b000ef          	jal	80000d7c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	0000a717          	auipc	a4,0xa
    8000033a:	0fa70713          	addi	a4,a4,250 # 8000a430 <started>
  if(cpuid() == 0){
    8000033e:	c51d                	beqz	a0,8000036c <main+0x42>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x16>
      ;
    __sync_synchronize();
    80000346:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000034a:	233000ef          	jal	80000d7c <cpuid>
    8000034e:	85aa                	mv	a1,a0
    80000350:	00007517          	auipc	a0,0x7
    80000354:	ce850513          	addi	a0,a0,-792 # 80007038 <etext+0x38>
    80000358:	6f9040ef          	jal	80005250 <printf>
    kvminithart();    // turn on paging
    8000035c:	080000ef          	jal	800003dc <kvminithart>
    trapinithart();   // install kernel trap vector
    80000360:	58c010ef          	jal	800018ec <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000364:	4a4040ef          	jal	80004808 <plicinithart>
  }

  scheduler();        
    80000368:	67d000ef          	jal	800011e4 <scheduler>
    consoleinit();
    8000036c:	60f040ef          	jal	8000517a <consoleinit>
    printfinit();
    80000370:	1ec050ef          	jal	8000555c <printfinit>
    printf("\n");
    80000374:	00007517          	auipc	a0,0x7
    80000378:	ca450513          	addi	a0,a0,-860 # 80007018 <etext+0x18>
    8000037c:	6d5040ef          	jal	80005250 <printf>
    printf("xv6 kernel is booting\n");
    80000380:	00007517          	auipc	a0,0x7
    80000384:	ca050513          	addi	a0,a0,-864 # 80007020 <etext+0x20>
    80000388:	6c9040ef          	jal	80005250 <printf>
    printf("\n");
    8000038c:	00007517          	auipc	a0,0x7
    80000390:	c8c50513          	addi	a0,a0,-884 # 80007018 <etext+0x18>
    80000394:	6bd040ef          	jal	80005250 <printf>
    kinit();         // physical page allocator
    80000398:	d33ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000039c:	2ca000ef          	jal	80000666 <kvminit>
    kvminithart();   // turn on paging
    800003a0:	03c000ef          	jal	800003dc <kvminithart>
    procinit();      // process table
    800003a4:	123000ef          	jal	80000cc6 <procinit>
    trapinit();      // trap vectors
    800003a8:	520010ef          	jal	800018c8 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ac:	540010ef          	jal	800018ec <trapinithart>
    plicinit();      // set up interrupt controller
    800003b0:	43e040ef          	jal	800047ee <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003b4:	454040ef          	jal	80004808 <plicinithart>
    binit();         // buffer cache
    800003b8:	3f5010ef          	jal	80001fac <binit>
    iinit();         // inode table
    800003bc:	1e6020ef          	jal	800025a2 <iinit>
    fileinit();      // file table
    800003c0:	793020ef          	jal	80003352 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003c4:	534040ef          	jal	800048f8 <virtio_disk_init>
    userinit();      // first user process
    800003c8:	449000ef          	jal	80001010 <userinit>
    __sync_synchronize();
    800003cc:	0330000f          	fence	rw,rw
    started = 1;
    800003d0:	4785                	li	a5,1
    800003d2:	0000a717          	auipc	a4,0xa
    800003d6:	04f72f23          	sw	a5,94(a4) # 8000a430 <started>
    800003da:	b779                	j	80000368 <main+0x3e>

00000000800003dc <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003dc:	1141                	addi	sp,sp,-16
    800003de:	e422                	sd	s0,8(sp)
    800003e0:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003e2:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003e6:	0000a797          	auipc	a5,0xa
    800003ea:	0527b783          	ld	a5,82(a5) # 8000a438 <kernel_pagetable>
    800003ee:	83b1                	srli	a5,a5,0xc
    800003f0:	577d                	li	a4,-1
    800003f2:	177e                	slli	a4,a4,0x3f
    800003f4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003f6:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003fa:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003fe:	6422                	ld	s0,8(sp)
    80000400:	0141                	addi	sp,sp,16
    80000402:	8082                	ret

0000000080000404 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000404:	7139                	addi	sp,sp,-64
    80000406:	fc06                	sd	ra,56(sp)
    80000408:	f822                	sd	s0,48(sp)
    8000040a:	f426                	sd	s1,40(sp)
    8000040c:	f04a                	sd	s2,32(sp)
    8000040e:	ec4e                	sd	s3,24(sp)
    80000410:	e852                	sd	s4,16(sp)
    80000412:	e456                	sd	s5,8(sp)
    80000414:	e05a                	sd	s6,0(sp)
    80000416:	0080                	addi	s0,sp,64
    80000418:	84aa                	mv	s1,a0
    8000041a:	89ae                	mv	s3,a1
    8000041c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000041e:	57fd                	li	a5,-1
    80000420:	83e9                	srli	a5,a5,0x1a
    80000422:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000424:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000426:	02b7fc63          	bgeu	a5,a1,8000045e <walk+0x5a>
    panic("walk");
    8000042a:	00007517          	auipc	a0,0x7
    8000042e:	c2650513          	addi	a0,a0,-986 # 80007050 <etext+0x50>
    80000432:	0f0050ef          	jal	80005522 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000436:	060a8263          	beqz	s5,8000049a <walk+0x96>
    8000043a:	cc5ff0ef          	jal	800000fe <kalloc>
    8000043e:	84aa                	mv	s1,a0
    80000440:	c139                	beqz	a0,80000486 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000442:	6605                	lui	a2,0x1
    80000444:	4581                	li	a1,0
    80000446:	d4bff0ef          	jal	80000190 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000044a:	00c4d793          	srli	a5,s1,0xc
    8000044e:	07aa                	slli	a5,a5,0xa
    80000450:	0017e793          	ori	a5,a5,1
    80000454:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000458:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb867>
    8000045a:	036a0063          	beq	s4,s6,8000047a <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000045e:	0149d933          	srl	s2,s3,s4
    80000462:	1ff97913          	andi	s2,s2,511
    80000466:	090e                	slli	s2,s2,0x3
    80000468:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000046a:	00093483          	ld	s1,0(s2)
    8000046e:	0014f793          	andi	a5,s1,1
    80000472:	d3f1                	beqz	a5,80000436 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000474:	80a9                	srli	s1,s1,0xa
    80000476:	04b2                	slli	s1,s1,0xc
    80000478:	b7c5                	j	80000458 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    8000047a:	00c9d513          	srli	a0,s3,0xc
    8000047e:	1ff57513          	andi	a0,a0,511
    80000482:	050e                	slli	a0,a0,0x3
    80000484:	9526                	add	a0,a0,s1
}
    80000486:	70e2                	ld	ra,56(sp)
    80000488:	7442                	ld	s0,48(sp)
    8000048a:	74a2                	ld	s1,40(sp)
    8000048c:	7902                	ld	s2,32(sp)
    8000048e:	69e2                	ld	s3,24(sp)
    80000490:	6a42                	ld	s4,16(sp)
    80000492:	6aa2                	ld	s5,8(sp)
    80000494:	6b02                	ld	s6,0(sp)
    80000496:	6121                	addi	sp,sp,64
    80000498:	8082                	ret
        return 0;
    8000049a:	4501                	li	a0,0
    8000049c:	b7ed                	j	80000486 <walk+0x82>

000000008000049e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000049e:	57fd                	li	a5,-1
    800004a0:	83e9                	srli	a5,a5,0x1a
    800004a2:	00b7f463          	bgeu	a5,a1,800004aa <walkaddr+0xc>
    return 0;
    800004a6:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800004a8:	8082                	ret
{
    800004aa:	1141                	addi	sp,sp,-16
    800004ac:	e406                	sd	ra,8(sp)
    800004ae:	e022                	sd	s0,0(sp)
    800004b0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004b2:	4601                	li	a2,0
    800004b4:	f51ff0ef          	jal	80000404 <walk>
  if(pte == 0)
    800004b8:	c105                	beqz	a0,800004d8 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    800004ba:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004bc:	0117f693          	andi	a3,a5,17
    800004c0:	4745                	li	a4,17
    return 0;
    800004c2:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004c4:	00e68663          	beq	a3,a4,800004d0 <walkaddr+0x32>
}
    800004c8:	60a2                	ld	ra,8(sp)
    800004ca:	6402                	ld	s0,0(sp)
    800004cc:	0141                	addi	sp,sp,16
    800004ce:	8082                	ret
  pa = PTE2PA(*pte);
    800004d0:	83a9                	srli	a5,a5,0xa
    800004d2:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004d6:	bfcd                	j	800004c8 <walkaddr+0x2a>
    return 0;
    800004d8:	4501                	li	a0,0
    800004da:	b7fd                	j	800004c8 <walkaddr+0x2a>

00000000800004dc <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004dc:	715d                	addi	sp,sp,-80
    800004de:	e486                	sd	ra,72(sp)
    800004e0:	e0a2                	sd	s0,64(sp)
    800004e2:	fc26                	sd	s1,56(sp)
    800004e4:	f84a                	sd	s2,48(sp)
    800004e6:	f44e                	sd	s3,40(sp)
    800004e8:	f052                	sd	s4,32(sp)
    800004ea:	ec56                	sd	s5,24(sp)
    800004ec:	e85a                	sd	s6,16(sp)
    800004ee:	e45e                	sd	s7,8(sp)
    800004f0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004f2:	03459793          	slli	a5,a1,0x34
    800004f6:	e7a9                	bnez	a5,80000540 <mappages+0x64>
    800004f8:	8aaa                	mv	s5,a0
    800004fa:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004fc:	03461793          	slli	a5,a2,0x34
    80000500:	e7b1                	bnez	a5,8000054c <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80000502:	ca39                	beqz	a2,80000558 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000504:	77fd                	lui	a5,0xfffff
    80000506:	963e                	add	a2,a2,a5
    80000508:	00b609b3          	add	s3,a2,a1
  a = va;
    8000050c:	892e                	mv	s2,a1
    8000050e:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000512:	6b85                	lui	s7,0x1
    80000514:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000518:	4605                	li	a2,1
    8000051a:	85ca                	mv	a1,s2
    8000051c:	8556                	mv	a0,s5
    8000051e:	ee7ff0ef          	jal	80000404 <walk>
    80000522:	c539                	beqz	a0,80000570 <mappages+0x94>
    if(*pte & PTE_V)
    80000524:	611c                	ld	a5,0(a0)
    80000526:	8b85                	andi	a5,a5,1
    80000528:	ef95                	bnez	a5,80000564 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000052a:	80b1                	srli	s1,s1,0xc
    8000052c:	04aa                	slli	s1,s1,0xa
    8000052e:	0164e4b3          	or	s1,s1,s6
    80000532:	0014e493          	ori	s1,s1,1
    80000536:	e104                	sd	s1,0(a0)
    if(a == last)
    80000538:	05390863          	beq	s2,s3,80000588 <mappages+0xac>
    a += PGSIZE;
    8000053c:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000053e:	bfd9                	j	80000514 <mappages+0x38>
    panic("mappages: va not aligned");
    80000540:	00007517          	auipc	a0,0x7
    80000544:	b1850513          	addi	a0,a0,-1256 # 80007058 <etext+0x58>
    80000548:	7db040ef          	jal	80005522 <panic>
    panic("mappages: size not aligned");
    8000054c:	00007517          	auipc	a0,0x7
    80000550:	b2c50513          	addi	a0,a0,-1236 # 80007078 <etext+0x78>
    80000554:	7cf040ef          	jal	80005522 <panic>
    panic("mappages: size");
    80000558:	00007517          	auipc	a0,0x7
    8000055c:	b4050513          	addi	a0,a0,-1216 # 80007098 <etext+0x98>
    80000560:	7c3040ef          	jal	80005522 <panic>
      panic("mappages: remap");
    80000564:	00007517          	auipc	a0,0x7
    80000568:	b4450513          	addi	a0,a0,-1212 # 800070a8 <etext+0xa8>
    8000056c:	7b7040ef          	jal	80005522 <panic>
      return -1;
    80000570:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000572:	60a6                	ld	ra,72(sp)
    80000574:	6406                	ld	s0,64(sp)
    80000576:	74e2                	ld	s1,56(sp)
    80000578:	7942                	ld	s2,48(sp)
    8000057a:	79a2                	ld	s3,40(sp)
    8000057c:	7a02                	ld	s4,32(sp)
    8000057e:	6ae2                	ld	s5,24(sp)
    80000580:	6b42                	ld	s6,16(sp)
    80000582:	6ba2                	ld	s7,8(sp)
    80000584:	6161                	addi	sp,sp,80
    80000586:	8082                	ret
  return 0;
    80000588:	4501                	li	a0,0
    8000058a:	b7e5                	j	80000572 <mappages+0x96>

000000008000058c <kvmmap>:
{
    8000058c:	1141                	addi	sp,sp,-16
    8000058e:	e406                	sd	ra,8(sp)
    80000590:	e022                	sd	s0,0(sp)
    80000592:	0800                	addi	s0,sp,16
    80000594:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000596:	86b2                	mv	a3,a2
    80000598:	863e                	mv	a2,a5
    8000059a:	f43ff0ef          	jal	800004dc <mappages>
    8000059e:	e509                	bnez	a0,800005a8 <kvmmap+0x1c>
}
    800005a0:	60a2                	ld	ra,8(sp)
    800005a2:	6402                	ld	s0,0(sp)
    800005a4:	0141                	addi	sp,sp,16
    800005a6:	8082                	ret
    panic("kvmmap");
    800005a8:	00007517          	auipc	a0,0x7
    800005ac:	b1050513          	addi	a0,a0,-1264 # 800070b8 <etext+0xb8>
    800005b0:	773040ef          	jal	80005522 <panic>

00000000800005b4 <kvmmake>:
{
    800005b4:	1101                	addi	sp,sp,-32
    800005b6:	ec06                	sd	ra,24(sp)
    800005b8:	e822                	sd	s0,16(sp)
    800005ba:	e426                	sd	s1,8(sp)
    800005bc:	e04a                	sd	s2,0(sp)
    800005be:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005c0:	b3fff0ef          	jal	800000fe <kalloc>
    800005c4:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005c6:	6605                	lui	a2,0x1
    800005c8:	4581                	li	a1,0
    800005ca:	bc7ff0ef          	jal	80000190 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005ce:	4719                	li	a4,6
    800005d0:	6685                	lui	a3,0x1
    800005d2:	10000637          	lui	a2,0x10000
    800005d6:	100005b7          	lui	a1,0x10000
    800005da:	8526                	mv	a0,s1
    800005dc:	fb1ff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005e0:	4719                	li	a4,6
    800005e2:	6685                	lui	a3,0x1
    800005e4:	10001637          	lui	a2,0x10001
    800005e8:	100015b7          	lui	a1,0x10001
    800005ec:	8526                	mv	a0,s1
    800005ee:	f9fff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005f2:	4719                	li	a4,6
    800005f4:	040006b7          	lui	a3,0x4000
    800005f8:	0c000637          	lui	a2,0xc000
    800005fc:	0c0005b7          	lui	a1,0xc000
    80000600:	8526                	mv	a0,s1
    80000602:	f8bff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000606:	00007917          	auipc	s2,0x7
    8000060a:	9fa90913          	addi	s2,s2,-1542 # 80007000 <etext>
    8000060e:	4729                	li	a4,10
    80000610:	80007697          	auipc	a3,0x80007
    80000614:	9f068693          	addi	a3,a3,-1552 # 7000 <_entry-0x7fff9000>
    80000618:	4605                	li	a2,1
    8000061a:	067e                	slli	a2,a2,0x1f
    8000061c:	85b2                	mv	a1,a2
    8000061e:	8526                	mv	a0,s1
    80000620:	f6dff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000624:	46c5                	li	a3,17
    80000626:	06ee                	slli	a3,a3,0x1b
    80000628:	4719                	li	a4,6
    8000062a:	412686b3          	sub	a3,a3,s2
    8000062e:	864a                	mv	a2,s2
    80000630:	85ca                	mv	a1,s2
    80000632:	8526                	mv	a0,s1
    80000634:	f59ff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000638:	4729                	li	a4,10
    8000063a:	6685                	lui	a3,0x1
    8000063c:	00006617          	auipc	a2,0x6
    80000640:	9c460613          	addi	a2,a2,-1596 # 80006000 <_trampoline>
    80000644:	040005b7          	lui	a1,0x4000
    80000648:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000064a:	05b2                	slli	a1,a1,0xc
    8000064c:	8526                	mv	a0,s1
    8000064e:	f3fff0ef          	jal	8000058c <kvmmap>
  proc_mapstacks(kpgtbl);
    80000652:	8526                	mv	a0,s1
    80000654:	5da000ef          	jal	80000c2e <proc_mapstacks>
}
    80000658:	8526                	mv	a0,s1
    8000065a:	60e2                	ld	ra,24(sp)
    8000065c:	6442                	ld	s0,16(sp)
    8000065e:	64a2                	ld	s1,8(sp)
    80000660:	6902                	ld	s2,0(sp)
    80000662:	6105                	addi	sp,sp,32
    80000664:	8082                	ret

0000000080000666 <kvminit>:
{
    80000666:	1141                	addi	sp,sp,-16
    80000668:	e406                	sd	ra,8(sp)
    8000066a:	e022                	sd	s0,0(sp)
    8000066c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000066e:	f47ff0ef          	jal	800005b4 <kvmmake>
    80000672:	0000a797          	auipc	a5,0xa
    80000676:	dca7b323          	sd	a0,-570(a5) # 8000a438 <kernel_pagetable>
}
    8000067a:	60a2                	ld	ra,8(sp)
    8000067c:	6402                	ld	s0,0(sp)
    8000067e:	0141                	addi	sp,sp,16
    80000680:	8082                	ret

0000000080000682 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000682:	715d                	addi	sp,sp,-80
    80000684:	e486                	sd	ra,72(sp)
    80000686:	e0a2                	sd	s0,64(sp)
    80000688:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000068a:	03459793          	slli	a5,a1,0x34
    8000068e:	e39d                	bnez	a5,800006b4 <uvmunmap+0x32>
    80000690:	f84a                	sd	s2,48(sp)
    80000692:	f44e                	sd	s3,40(sp)
    80000694:	f052                	sd	s4,32(sp)
    80000696:	ec56                	sd	s5,24(sp)
    80000698:	e85a                	sd	s6,16(sp)
    8000069a:	e45e                	sd	s7,8(sp)
    8000069c:	8a2a                	mv	s4,a0
    8000069e:	892e                	mv	s2,a1
    800006a0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006a2:	0632                	slli	a2,a2,0xc
    800006a4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800006a8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006aa:	6b05                	lui	s6,0x1
    800006ac:	0735ff63          	bgeu	a1,s3,8000072a <uvmunmap+0xa8>
    800006b0:	fc26                	sd	s1,56(sp)
    800006b2:	a0a9                	j	800006fc <uvmunmap+0x7a>
    800006b4:	fc26                	sd	s1,56(sp)
    800006b6:	f84a                	sd	s2,48(sp)
    800006b8:	f44e                	sd	s3,40(sp)
    800006ba:	f052                	sd	s4,32(sp)
    800006bc:	ec56                	sd	s5,24(sp)
    800006be:	e85a                	sd	s6,16(sp)
    800006c0:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006c2:	00007517          	auipc	a0,0x7
    800006c6:	9fe50513          	addi	a0,a0,-1538 # 800070c0 <etext+0xc0>
    800006ca:	659040ef          	jal	80005522 <panic>
      panic("uvmunmap: walk");
    800006ce:	00007517          	auipc	a0,0x7
    800006d2:	a0a50513          	addi	a0,a0,-1526 # 800070d8 <etext+0xd8>
    800006d6:	64d040ef          	jal	80005522 <panic>
      panic("uvmunmap: not mapped");
    800006da:	00007517          	auipc	a0,0x7
    800006de:	a0e50513          	addi	a0,a0,-1522 # 800070e8 <etext+0xe8>
    800006e2:	641040ef          	jal	80005522 <panic>
      panic("uvmunmap: not a leaf");
    800006e6:	00007517          	auipc	a0,0x7
    800006ea:	a1a50513          	addi	a0,a0,-1510 # 80007100 <etext+0x100>
    800006ee:	635040ef          	jal	80005522 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006f2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006f6:	995a                	add	s2,s2,s6
    800006f8:	03397863          	bgeu	s2,s3,80000728 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006fc:	4601                	li	a2,0
    800006fe:	85ca                	mv	a1,s2
    80000700:	8552                	mv	a0,s4
    80000702:	d03ff0ef          	jal	80000404 <walk>
    80000706:	84aa                	mv	s1,a0
    80000708:	d179                	beqz	a0,800006ce <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    8000070a:	6108                	ld	a0,0(a0)
    8000070c:	00157793          	andi	a5,a0,1
    80000710:	d7e9                	beqz	a5,800006da <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000712:	3ff57793          	andi	a5,a0,1023
    80000716:	fd7788e3          	beq	a5,s7,800006e6 <uvmunmap+0x64>
    if(do_free){
    8000071a:	fc0a8ce3          	beqz	s5,800006f2 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000071e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000720:	0532                	slli	a0,a0,0xc
    80000722:	8fbff0ef          	jal	8000001c <kfree>
    80000726:	b7f1                	j	800006f2 <uvmunmap+0x70>
    80000728:	74e2                	ld	s1,56(sp)
    8000072a:	7942                	ld	s2,48(sp)
    8000072c:	79a2                	ld	s3,40(sp)
    8000072e:	7a02                	ld	s4,32(sp)
    80000730:	6ae2                	ld	s5,24(sp)
    80000732:	6b42                	ld	s6,16(sp)
    80000734:	6ba2                	ld	s7,8(sp)
  }
}
    80000736:	60a6                	ld	ra,72(sp)
    80000738:	6406                	ld	s0,64(sp)
    8000073a:	6161                	addi	sp,sp,80
    8000073c:	8082                	ret

000000008000073e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000073e:	1101                	addi	sp,sp,-32
    80000740:	ec06                	sd	ra,24(sp)
    80000742:	e822                	sd	s0,16(sp)
    80000744:	e426                	sd	s1,8(sp)
    80000746:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000748:	9b7ff0ef          	jal	800000fe <kalloc>
    8000074c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000074e:	c509                	beqz	a0,80000758 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000750:	6605                	lui	a2,0x1
    80000752:	4581                	li	a1,0
    80000754:	a3dff0ef          	jal	80000190 <memset>
  return pagetable;
}
    80000758:	8526                	mv	a0,s1
    8000075a:	60e2                	ld	ra,24(sp)
    8000075c:	6442                	ld	s0,16(sp)
    8000075e:	64a2                	ld	s1,8(sp)
    80000760:	6105                	addi	sp,sp,32
    80000762:	8082                	ret

0000000080000764 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000764:	7179                	addi	sp,sp,-48
    80000766:	f406                	sd	ra,40(sp)
    80000768:	f022                	sd	s0,32(sp)
    8000076a:	ec26                	sd	s1,24(sp)
    8000076c:	e84a                	sd	s2,16(sp)
    8000076e:	e44e                	sd	s3,8(sp)
    80000770:	e052                	sd	s4,0(sp)
    80000772:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000774:	6785                	lui	a5,0x1
    80000776:	04f67063          	bgeu	a2,a5,800007b6 <uvmfirst+0x52>
    8000077a:	8a2a                	mv	s4,a0
    8000077c:	89ae                	mv	s3,a1
    8000077e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000780:	97fff0ef          	jal	800000fe <kalloc>
    80000784:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000786:	6605                	lui	a2,0x1
    80000788:	4581                	li	a1,0
    8000078a:	a07ff0ef          	jal	80000190 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000078e:	4779                	li	a4,30
    80000790:	86ca                	mv	a3,s2
    80000792:	6605                	lui	a2,0x1
    80000794:	4581                	li	a1,0
    80000796:	8552                	mv	a0,s4
    80000798:	d45ff0ef          	jal	800004dc <mappages>
  memmove(mem, src, sz);
    8000079c:	8626                	mv	a2,s1
    8000079e:	85ce                	mv	a1,s3
    800007a0:	854a                	mv	a0,s2
    800007a2:	a4bff0ef          	jal	800001ec <memmove>
}
    800007a6:	70a2                	ld	ra,40(sp)
    800007a8:	7402                	ld	s0,32(sp)
    800007aa:	64e2                	ld	s1,24(sp)
    800007ac:	6942                	ld	s2,16(sp)
    800007ae:	69a2                	ld	s3,8(sp)
    800007b0:	6a02                	ld	s4,0(sp)
    800007b2:	6145                	addi	sp,sp,48
    800007b4:	8082                	ret
    panic("uvmfirst: more than a page");
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	96250513          	addi	a0,a0,-1694 # 80007118 <etext+0x118>
    800007be:	565040ef          	jal	80005522 <panic>

00000000800007c2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007c2:	1101                	addi	sp,sp,-32
    800007c4:	ec06                	sd	ra,24(sp)
    800007c6:	e822                	sd	s0,16(sp)
    800007c8:	e426                	sd	s1,8(sp)
    800007ca:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007cc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007ce:	00b67d63          	bgeu	a2,a1,800007e8 <uvmdealloc+0x26>
    800007d2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007d4:	6785                	lui	a5,0x1
    800007d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007d8:	00f60733          	add	a4,a2,a5
    800007dc:	76fd                	lui	a3,0xfffff
    800007de:	8f75                	and	a4,a4,a3
    800007e0:	97ae                	add	a5,a5,a1
    800007e2:	8ff5                	and	a5,a5,a3
    800007e4:	00f76863          	bltu	a4,a5,800007f4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007e8:	8526                	mv	a0,s1
    800007ea:	60e2                	ld	ra,24(sp)
    800007ec:	6442                	ld	s0,16(sp)
    800007ee:	64a2                	ld	s1,8(sp)
    800007f0:	6105                	addi	sp,sp,32
    800007f2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007f4:	8f99                	sub	a5,a5,a4
    800007f6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007f8:	4685                	li	a3,1
    800007fa:	0007861b          	sext.w	a2,a5
    800007fe:	85ba                	mv	a1,a4
    80000800:	e83ff0ef          	jal	80000682 <uvmunmap>
    80000804:	b7d5                	j	800007e8 <uvmdealloc+0x26>

0000000080000806 <uvmalloc>:
  if(newsz < oldsz)
    80000806:	08b66f63          	bltu	a2,a1,800008a4 <uvmalloc+0x9e>
{
    8000080a:	7139                	addi	sp,sp,-64
    8000080c:	fc06                	sd	ra,56(sp)
    8000080e:	f822                	sd	s0,48(sp)
    80000810:	ec4e                	sd	s3,24(sp)
    80000812:	e852                	sd	s4,16(sp)
    80000814:	e456                	sd	s5,8(sp)
    80000816:	0080                	addi	s0,sp,64
    80000818:	8aaa                	mv	s5,a0
    8000081a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000081c:	6785                	lui	a5,0x1
    8000081e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000820:	95be                	add	a1,a1,a5
    80000822:	77fd                	lui	a5,0xfffff
    80000824:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000828:	08c9f063          	bgeu	s3,a2,800008a8 <uvmalloc+0xa2>
    8000082c:	f426                	sd	s1,40(sp)
    8000082e:	f04a                	sd	s2,32(sp)
    80000830:	e05a                	sd	s6,0(sp)
    80000832:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000834:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000838:	8c7ff0ef          	jal	800000fe <kalloc>
    8000083c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000083e:	c515                	beqz	a0,8000086a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000840:	6605                	lui	a2,0x1
    80000842:	4581                	li	a1,0
    80000844:	94dff0ef          	jal	80000190 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000848:	875a                	mv	a4,s6
    8000084a:	86a6                	mv	a3,s1
    8000084c:	6605                	lui	a2,0x1
    8000084e:	85ca                	mv	a1,s2
    80000850:	8556                	mv	a0,s5
    80000852:	c8bff0ef          	jal	800004dc <mappages>
    80000856:	e915                	bnez	a0,8000088a <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000858:	6785                	lui	a5,0x1
    8000085a:	993e                	add	s2,s2,a5
    8000085c:	fd496ee3          	bltu	s2,s4,80000838 <uvmalloc+0x32>
  return newsz;
    80000860:	8552                	mv	a0,s4
    80000862:	74a2                	ld	s1,40(sp)
    80000864:	7902                	ld	s2,32(sp)
    80000866:	6b02                	ld	s6,0(sp)
    80000868:	a811                	j	8000087c <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    8000086a:	864e                	mv	a2,s3
    8000086c:	85ca                	mv	a1,s2
    8000086e:	8556                	mv	a0,s5
    80000870:	f53ff0ef          	jal	800007c2 <uvmdealloc>
      return 0;
    80000874:	4501                	li	a0,0
    80000876:	74a2                	ld	s1,40(sp)
    80000878:	7902                	ld	s2,32(sp)
    8000087a:	6b02                	ld	s6,0(sp)
}
    8000087c:	70e2                	ld	ra,56(sp)
    8000087e:	7442                	ld	s0,48(sp)
    80000880:	69e2                	ld	s3,24(sp)
    80000882:	6a42                	ld	s4,16(sp)
    80000884:	6aa2                	ld	s5,8(sp)
    80000886:	6121                	addi	sp,sp,64
    80000888:	8082                	ret
      kfree(mem);
    8000088a:	8526                	mv	a0,s1
    8000088c:	f90ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000890:	864e                	mv	a2,s3
    80000892:	85ca                	mv	a1,s2
    80000894:	8556                	mv	a0,s5
    80000896:	f2dff0ef          	jal	800007c2 <uvmdealloc>
      return 0;
    8000089a:	4501                	li	a0,0
    8000089c:	74a2                	ld	s1,40(sp)
    8000089e:	7902                	ld	s2,32(sp)
    800008a0:	6b02                	ld	s6,0(sp)
    800008a2:	bfe9                	j	8000087c <uvmalloc+0x76>
    return oldsz;
    800008a4:	852e                	mv	a0,a1
}
    800008a6:	8082                	ret
  return newsz;
    800008a8:	8532                	mv	a0,a2
    800008aa:	bfc9                	j	8000087c <uvmalloc+0x76>

00000000800008ac <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800008ac:	7179                	addi	sp,sp,-48
    800008ae:	f406                	sd	ra,40(sp)
    800008b0:	f022                	sd	s0,32(sp)
    800008b2:	ec26                	sd	s1,24(sp)
    800008b4:	e84a                	sd	s2,16(sp)
    800008b6:	e44e                	sd	s3,8(sp)
    800008b8:	e052                	sd	s4,0(sp)
    800008ba:	1800                	addi	s0,sp,48
    800008bc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008be:	84aa                	mv	s1,a0
    800008c0:	6905                	lui	s2,0x1
    800008c2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008c4:	4985                	li	s3,1
    800008c6:	a819                	j	800008dc <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008c8:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008ca:	00c79513          	slli	a0,a5,0xc
    800008ce:	fdfff0ef          	jal	800008ac <freewalk>
      pagetable[i] = 0;
    800008d2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008d6:	04a1                	addi	s1,s1,8
    800008d8:	01248f63          	beq	s1,s2,800008f6 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008dc:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008de:	00f7f713          	andi	a4,a5,15
    800008e2:	ff3703e3          	beq	a4,s3,800008c8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008e6:	8b85                	andi	a5,a5,1
    800008e8:	d7fd                	beqz	a5,800008d6 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008ea:	00007517          	auipc	a0,0x7
    800008ee:	84e50513          	addi	a0,a0,-1970 # 80007138 <etext+0x138>
    800008f2:	431040ef          	jal	80005522 <panic>
    }
  }
  kfree((void*)pagetable);
    800008f6:	8552                	mv	a0,s4
    800008f8:	f24ff0ef          	jal	8000001c <kfree>
}
    800008fc:	70a2                	ld	ra,40(sp)
    800008fe:	7402                	ld	s0,32(sp)
    80000900:	64e2                	ld	s1,24(sp)
    80000902:	6942                	ld	s2,16(sp)
    80000904:	69a2                	ld	s3,8(sp)
    80000906:	6a02                	ld	s4,0(sp)
    80000908:	6145                	addi	sp,sp,48
    8000090a:	8082                	ret

000000008000090c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000090c:	1101                	addi	sp,sp,-32
    8000090e:	ec06                	sd	ra,24(sp)
    80000910:	e822                	sd	s0,16(sp)
    80000912:	e426                	sd	s1,8(sp)
    80000914:	1000                	addi	s0,sp,32
    80000916:	84aa                	mv	s1,a0
  if(sz > 0)
    80000918:	e989                	bnez	a1,8000092a <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000091a:	8526                	mv	a0,s1
    8000091c:	f91ff0ef          	jal	800008ac <freewalk>
}
    80000920:	60e2                	ld	ra,24(sp)
    80000922:	6442                	ld	s0,16(sp)
    80000924:	64a2                	ld	s1,8(sp)
    80000926:	6105                	addi	sp,sp,32
    80000928:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000092a:	6785                	lui	a5,0x1
    8000092c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000092e:	95be                	add	a1,a1,a5
    80000930:	4685                	li	a3,1
    80000932:	00c5d613          	srli	a2,a1,0xc
    80000936:	4581                	li	a1,0
    80000938:	d4bff0ef          	jal	80000682 <uvmunmap>
    8000093c:	bff9                	j	8000091a <uvmfree+0xe>

000000008000093e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000093e:	c65d                	beqz	a2,800009ec <uvmcopy+0xae>
{
    80000940:	715d                	addi	sp,sp,-80
    80000942:	e486                	sd	ra,72(sp)
    80000944:	e0a2                	sd	s0,64(sp)
    80000946:	fc26                	sd	s1,56(sp)
    80000948:	f84a                	sd	s2,48(sp)
    8000094a:	f44e                	sd	s3,40(sp)
    8000094c:	f052                	sd	s4,32(sp)
    8000094e:	ec56                	sd	s5,24(sp)
    80000950:	e85a                	sd	s6,16(sp)
    80000952:	e45e                	sd	s7,8(sp)
    80000954:	0880                	addi	s0,sp,80
    80000956:	8b2a                	mv	s6,a0
    80000958:	8aae                	mv	s5,a1
    8000095a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000095c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000095e:	4601                	li	a2,0
    80000960:	85ce                	mv	a1,s3
    80000962:	855a                	mv	a0,s6
    80000964:	aa1ff0ef          	jal	80000404 <walk>
    80000968:	c121                	beqz	a0,800009a8 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000096a:	6118                	ld	a4,0(a0)
    8000096c:	00177793          	andi	a5,a4,1
    80000970:	c3b1                	beqz	a5,800009b4 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000972:	00a75593          	srli	a1,a4,0xa
    80000976:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000097a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000097e:	f80ff0ef          	jal	800000fe <kalloc>
    80000982:	892a                	mv	s2,a0
    80000984:	c129                	beqz	a0,800009c6 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000986:	6605                	lui	a2,0x1
    80000988:	85de                	mv	a1,s7
    8000098a:	863ff0ef          	jal	800001ec <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000098e:	8726                	mv	a4,s1
    80000990:	86ca                	mv	a3,s2
    80000992:	6605                	lui	a2,0x1
    80000994:	85ce                	mv	a1,s3
    80000996:	8556                	mv	a0,s5
    80000998:	b45ff0ef          	jal	800004dc <mappages>
    8000099c:	e115                	bnez	a0,800009c0 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000099e:	6785                	lui	a5,0x1
    800009a0:	99be                	add	s3,s3,a5
    800009a2:	fb49eee3          	bltu	s3,s4,8000095e <uvmcopy+0x20>
    800009a6:	a805                	j	800009d6 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800009a8:	00006517          	auipc	a0,0x6
    800009ac:	7a050513          	addi	a0,a0,1952 # 80007148 <etext+0x148>
    800009b0:	373040ef          	jal	80005522 <panic>
      panic("uvmcopy: page not present");
    800009b4:	00006517          	auipc	a0,0x6
    800009b8:	7b450513          	addi	a0,a0,1972 # 80007168 <etext+0x168>
    800009bc:	367040ef          	jal	80005522 <panic>
      kfree(mem);
    800009c0:	854a                	mv	a0,s2
    800009c2:	e5aff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009c6:	4685                	li	a3,1
    800009c8:	00c9d613          	srli	a2,s3,0xc
    800009cc:	4581                	li	a1,0
    800009ce:	8556                	mv	a0,s5
    800009d0:	cb3ff0ef          	jal	80000682 <uvmunmap>
  return -1;
    800009d4:	557d                	li	a0,-1
}
    800009d6:	60a6                	ld	ra,72(sp)
    800009d8:	6406                	ld	s0,64(sp)
    800009da:	74e2                	ld	s1,56(sp)
    800009dc:	7942                	ld	s2,48(sp)
    800009de:	79a2                	ld	s3,40(sp)
    800009e0:	7a02                	ld	s4,32(sp)
    800009e2:	6ae2                	ld	s5,24(sp)
    800009e4:	6b42                	ld	s6,16(sp)
    800009e6:	6ba2                	ld	s7,8(sp)
    800009e8:	6161                	addi	sp,sp,80
    800009ea:	8082                	ret
  return 0;
    800009ec:	4501                	li	a0,0
}
    800009ee:	8082                	ret

00000000800009f0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009f0:	1141                	addi	sp,sp,-16
    800009f2:	e406                	sd	ra,8(sp)
    800009f4:	e022                	sd	s0,0(sp)
    800009f6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009f8:	4601                	li	a2,0
    800009fa:	a0bff0ef          	jal	80000404 <walk>
  if(pte == 0)
    800009fe:	c901                	beqz	a0,80000a0e <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000a00:	611c                	ld	a5,0(a0)
    80000a02:	9bbd                	andi	a5,a5,-17
    80000a04:	e11c                	sd	a5,0(a0)
}
    80000a06:	60a2                	ld	ra,8(sp)
    80000a08:	6402                	ld	s0,0(sp)
    80000a0a:	0141                	addi	sp,sp,16
    80000a0c:	8082                	ret
    panic("uvmclear");
    80000a0e:	00006517          	auipc	a0,0x6
    80000a12:	77a50513          	addi	a0,a0,1914 # 80007188 <etext+0x188>
    80000a16:	30d040ef          	jal	80005522 <panic>

0000000080000a1a <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a1a:	cad1                	beqz	a3,80000aae <copyout+0x94>
{
    80000a1c:	711d                	addi	sp,sp,-96
    80000a1e:	ec86                	sd	ra,88(sp)
    80000a20:	e8a2                	sd	s0,80(sp)
    80000a22:	e4a6                	sd	s1,72(sp)
    80000a24:	fc4e                	sd	s3,56(sp)
    80000a26:	f456                	sd	s5,40(sp)
    80000a28:	f05a                	sd	s6,32(sp)
    80000a2a:	ec5e                	sd	s7,24(sp)
    80000a2c:	1080                	addi	s0,sp,96
    80000a2e:	8baa                	mv	s7,a0
    80000a30:	8aae                	mv	s5,a1
    80000a32:	8b32                	mv	s6,a2
    80000a34:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a36:	74fd                	lui	s1,0xfffff
    80000a38:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000a3a:	57fd                	li	a5,-1
    80000a3c:	83e9                	srli	a5,a5,0x1a
    80000a3e:	0697ea63          	bltu	a5,s1,80000ab2 <copyout+0x98>
    80000a42:	e0ca                	sd	s2,64(sp)
    80000a44:	f852                	sd	s4,48(sp)
    80000a46:	e862                	sd	s8,16(sp)
    80000a48:	e466                	sd	s9,8(sp)
    80000a4a:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a4c:	4cd5                	li	s9,21
    80000a4e:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000a50:	8c3e                	mv	s8,a5
    80000a52:	a025                	j	80000a7a <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000a54:	83a9                	srli	a5,a5,0xa
    80000a56:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a58:	409a8533          	sub	a0,s5,s1
    80000a5c:	0009061b          	sext.w	a2,s2
    80000a60:	85da                	mv	a1,s6
    80000a62:	953e                	add	a0,a0,a5
    80000a64:	f88ff0ef          	jal	800001ec <memmove>

    len -= n;
    80000a68:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a6c:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000a6e:	02098963          	beqz	s3,80000aa0 <copyout+0x86>
    if(va0 >= MAXVA)
    80000a72:	054c6263          	bltu	s8,s4,80000ab6 <copyout+0x9c>
    80000a76:	84d2                	mv	s1,s4
    80000a78:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000a7a:	4601                	li	a2,0
    80000a7c:	85a6                	mv	a1,s1
    80000a7e:	855e                	mv	a0,s7
    80000a80:	985ff0ef          	jal	80000404 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a84:	c121                	beqz	a0,80000ac4 <copyout+0xaa>
    80000a86:	611c                	ld	a5,0(a0)
    80000a88:	0157f713          	andi	a4,a5,21
    80000a8c:	05971b63          	bne	a4,s9,80000ae2 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80000a90:	01a48a33          	add	s4,s1,s10
    80000a94:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000a98:	fb29fee3          	bgeu	s3,s2,80000a54 <copyout+0x3a>
    80000a9c:	894e                	mv	s2,s3
    80000a9e:	bf5d                	j	80000a54 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000aa0:	4501                	li	a0,0
    80000aa2:	6906                	ld	s2,64(sp)
    80000aa4:	7a42                	ld	s4,48(sp)
    80000aa6:	6c42                	ld	s8,16(sp)
    80000aa8:	6ca2                	ld	s9,8(sp)
    80000aaa:	6d02                	ld	s10,0(sp)
    80000aac:	a015                	j	80000ad0 <copyout+0xb6>
    80000aae:	4501                	li	a0,0
}
    80000ab0:	8082                	ret
      return -1;
    80000ab2:	557d                	li	a0,-1
    80000ab4:	a831                	j	80000ad0 <copyout+0xb6>
    80000ab6:	557d                	li	a0,-1
    80000ab8:	6906                	ld	s2,64(sp)
    80000aba:	7a42                	ld	s4,48(sp)
    80000abc:	6c42                	ld	s8,16(sp)
    80000abe:	6ca2                	ld	s9,8(sp)
    80000ac0:	6d02                	ld	s10,0(sp)
    80000ac2:	a039                	j	80000ad0 <copyout+0xb6>
      return -1;
    80000ac4:	557d                	li	a0,-1
    80000ac6:	6906                	ld	s2,64(sp)
    80000ac8:	7a42                	ld	s4,48(sp)
    80000aca:	6c42                	ld	s8,16(sp)
    80000acc:	6ca2                	ld	s9,8(sp)
    80000ace:	6d02                	ld	s10,0(sp)
}
    80000ad0:	60e6                	ld	ra,88(sp)
    80000ad2:	6446                	ld	s0,80(sp)
    80000ad4:	64a6                	ld	s1,72(sp)
    80000ad6:	79e2                	ld	s3,56(sp)
    80000ad8:	7aa2                	ld	s5,40(sp)
    80000ada:	7b02                	ld	s6,32(sp)
    80000adc:	6be2                	ld	s7,24(sp)
    80000ade:	6125                	addi	sp,sp,96
    80000ae0:	8082                	ret
      return -1;
    80000ae2:	557d                	li	a0,-1
    80000ae4:	6906                	ld	s2,64(sp)
    80000ae6:	7a42                	ld	s4,48(sp)
    80000ae8:	6c42                	ld	s8,16(sp)
    80000aea:	6ca2                	ld	s9,8(sp)
    80000aec:	6d02                	ld	s10,0(sp)
    80000aee:	b7cd                	j	80000ad0 <copyout+0xb6>

0000000080000af0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000af0:	c6a5                	beqz	a3,80000b58 <copyin+0x68>
{
    80000af2:	715d                	addi	sp,sp,-80
    80000af4:	e486                	sd	ra,72(sp)
    80000af6:	e0a2                	sd	s0,64(sp)
    80000af8:	fc26                	sd	s1,56(sp)
    80000afa:	f84a                	sd	s2,48(sp)
    80000afc:	f44e                	sd	s3,40(sp)
    80000afe:	f052                	sd	s4,32(sp)
    80000b00:	ec56                	sd	s5,24(sp)
    80000b02:	e85a                	sd	s6,16(sp)
    80000b04:	e45e                	sd	s7,8(sp)
    80000b06:	e062                	sd	s8,0(sp)
    80000b08:	0880                	addi	s0,sp,80
    80000b0a:	8b2a                	mv	s6,a0
    80000b0c:	8a2e                	mv	s4,a1
    80000b0e:	8c32                	mv	s8,a2
    80000b10:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b12:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b14:	6a85                	lui	s5,0x1
    80000b16:	a00d                	j	80000b38 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b18:	018505b3          	add	a1,a0,s8
    80000b1c:	0004861b          	sext.w	a2,s1
    80000b20:	412585b3          	sub	a1,a1,s2
    80000b24:	8552                	mv	a0,s4
    80000b26:	ec6ff0ef          	jal	800001ec <memmove>

    len -= n;
    80000b2a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b2e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b30:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b34:	02098063          	beqz	s3,80000b54 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b38:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b3c:	85ca                	mv	a1,s2
    80000b3e:	855a                	mv	a0,s6
    80000b40:	95fff0ef          	jal	8000049e <walkaddr>
    if(pa0 == 0)
    80000b44:	cd01                	beqz	a0,80000b5c <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b46:	418904b3          	sub	s1,s2,s8
    80000b4a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b4c:	fc99f6e3          	bgeu	s3,s1,80000b18 <copyin+0x28>
    80000b50:	84ce                	mv	s1,s3
    80000b52:	b7d9                	j	80000b18 <copyin+0x28>
  }
  return 0;
    80000b54:	4501                	li	a0,0
    80000b56:	a021                	j	80000b5e <copyin+0x6e>
    80000b58:	4501                	li	a0,0
}
    80000b5a:	8082                	ret
      return -1;
    80000b5c:	557d                	li	a0,-1
}
    80000b5e:	60a6                	ld	ra,72(sp)
    80000b60:	6406                	ld	s0,64(sp)
    80000b62:	74e2                	ld	s1,56(sp)
    80000b64:	7942                	ld	s2,48(sp)
    80000b66:	79a2                	ld	s3,40(sp)
    80000b68:	7a02                	ld	s4,32(sp)
    80000b6a:	6ae2                	ld	s5,24(sp)
    80000b6c:	6b42                	ld	s6,16(sp)
    80000b6e:	6ba2                	ld	s7,8(sp)
    80000b70:	6c02                	ld	s8,0(sp)
    80000b72:	6161                	addi	sp,sp,80
    80000b74:	8082                	ret

0000000080000b76 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b76:	c6dd                	beqz	a3,80000c24 <copyinstr+0xae>
{
    80000b78:	715d                	addi	sp,sp,-80
    80000b7a:	e486                	sd	ra,72(sp)
    80000b7c:	e0a2                	sd	s0,64(sp)
    80000b7e:	fc26                	sd	s1,56(sp)
    80000b80:	f84a                	sd	s2,48(sp)
    80000b82:	f44e                	sd	s3,40(sp)
    80000b84:	f052                	sd	s4,32(sp)
    80000b86:	ec56                	sd	s5,24(sp)
    80000b88:	e85a                	sd	s6,16(sp)
    80000b8a:	e45e                	sd	s7,8(sp)
    80000b8c:	0880                	addi	s0,sp,80
    80000b8e:	8a2a                	mv	s4,a0
    80000b90:	8b2e                	mv	s6,a1
    80000b92:	8bb2                	mv	s7,a2
    80000b94:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b96:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b98:	6985                	lui	s3,0x1
    80000b9a:	a825                	j	80000bd2 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b9c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ba0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ba2:	37fd                	addiw	a5,a5,-1
    80000ba4:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ba8:	60a6                	ld	ra,72(sp)
    80000baa:	6406                	ld	s0,64(sp)
    80000bac:	74e2                	ld	s1,56(sp)
    80000bae:	7942                	ld	s2,48(sp)
    80000bb0:	79a2                	ld	s3,40(sp)
    80000bb2:	7a02                	ld	s4,32(sp)
    80000bb4:	6ae2                	ld	s5,24(sp)
    80000bb6:	6b42                	ld	s6,16(sp)
    80000bb8:	6ba2                	ld	s7,8(sp)
    80000bba:	6161                	addi	sp,sp,80
    80000bbc:	8082                	ret
    80000bbe:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000bc2:	9742                	add	a4,a4,a6
      --max;
    80000bc4:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000bc8:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000bcc:	04e58463          	beq	a1,a4,80000c14 <copyinstr+0x9e>
{
    80000bd0:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000bd2:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000bd6:	85a6                	mv	a1,s1
    80000bd8:	8552                	mv	a0,s4
    80000bda:	8c5ff0ef          	jal	8000049e <walkaddr>
    if(pa0 == 0)
    80000bde:	cd0d                	beqz	a0,80000c18 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000be0:	417486b3          	sub	a3,s1,s7
    80000be4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000be6:	00d97363          	bgeu	s2,a3,80000bec <copyinstr+0x76>
    80000bea:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000bec:	955e                	add	a0,a0,s7
    80000bee:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000bf0:	c695                	beqz	a3,80000c1c <copyinstr+0xa6>
    80000bf2:	87da                	mv	a5,s6
    80000bf4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000bf6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bfa:	96da                	add	a3,a3,s6
    80000bfc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bfe:	00f60733          	add	a4,a2,a5
    80000c02:	00074703          	lbu	a4,0(a4)
    80000c06:	db59                	beqz	a4,80000b9c <copyinstr+0x26>
        *dst = *p;
    80000c08:	00e78023          	sb	a4,0(a5)
      dst++;
    80000c0c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c0e:	fed797e3          	bne	a5,a3,80000bfc <copyinstr+0x86>
    80000c12:	b775                	j	80000bbe <copyinstr+0x48>
    80000c14:	4781                	li	a5,0
    80000c16:	b771                	j	80000ba2 <copyinstr+0x2c>
      return -1;
    80000c18:	557d                	li	a0,-1
    80000c1a:	b779                	j	80000ba8 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000c1c:	6b85                	lui	s7,0x1
    80000c1e:	9ba6                	add	s7,s7,s1
    80000c20:	87da                	mv	a5,s6
    80000c22:	b77d                	j	80000bd0 <copyinstr+0x5a>
  int got_null = 0;
    80000c24:	4781                	li	a5,0
  if(got_null){
    80000c26:	37fd                	addiw	a5,a5,-1
    80000c28:	0007851b          	sext.w	a0,a5
}
    80000c2c:	8082                	ret

0000000080000c2e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c2e:	7139                	addi	sp,sp,-64
    80000c30:	fc06                	sd	ra,56(sp)
    80000c32:	f822                	sd	s0,48(sp)
    80000c34:	f426                	sd	s1,40(sp)
    80000c36:	f04a                	sd	s2,32(sp)
    80000c38:	ec4e                	sd	s3,24(sp)
    80000c3a:	e852                	sd	s4,16(sp)
    80000c3c:	e456                	sd	s5,8(sp)
    80000c3e:	e05a                	sd	s6,0(sp)
    80000c40:	0080                	addi	s0,sp,64
    80000c42:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c44:	0000a497          	auipc	s1,0xa
    80000c48:	c6c48493          	addi	s1,s1,-916 # 8000a8b0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c4c:	8b26                	mv	s6,s1
    80000c4e:	04fa5937          	lui	s2,0x4fa5
    80000c52:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c56:	0932                	slli	s2,s2,0xc
    80000c58:	fa590913          	addi	s2,s2,-91
    80000c5c:	0932                	slli	s2,s2,0xc
    80000c5e:	fa590913          	addi	s2,s2,-91
    80000c62:	0932                	slli	s2,s2,0xc
    80000c64:	fa590913          	addi	s2,s2,-91
    80000c68:	040009b7          	lui	s3,0x4000
    80000c6c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c6e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c70:	0000fa97          	auipc	s5,0xf
    80000c74:	640a8a93          	addi	s5,s5,1600 # 800102b0 <tickslock>
    char *pa = kalloc();
    80000c78:	c86ff0ef          	jal	800000fe <kalloc>
    80000c7c:	862a                	mv	a2,a0
    if(pa == 0)
    80000c7e:	cd15                	beqz	a0,80000cba <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c80:	416485b3          	sub	a1,s1,s6
    80000c84:	858d                	srai	a1,a1,0x3
    80000c86:	032585b3          	mul	a1,a1,s2
    80000c8a:	2585                	addiw	a1,a1,1
    80000c8c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c90:	4719                	li	a4,6
    80000c92:	6685                	lui	a3,0x1
    80000c94:	40b985b3          	sub	a1,s3,a1
    80000c98:	8552                	mv	a0,s4
    80000c9a:	8f3ff0ef          	jal	8000058c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c9e:	16848493          	addi	s1,s1,360
    80000ca2:	fd549be3          	bne	s1,s5,80000c78 <proc_mapstacks+0x4a>
  }
}
    80000ca6:	70e2                	ld	ra,56(sp)
    80000ca8:	7442                	ld	s0,48(sp)
    80000caa:	74a2                	ld	s1,40(sp)
    80000cac:	7902                	ld	s2,32(sp)
    80000cae:	69e2                	ld	s3,24(sp)
    80000cb0:	6a42                	ld	s4,16(sp)
    80000cb2:	6aa2                	ld	s5,8(sp)
    80000cb4:	6b02                	ld	s6,0(sp)
    80000cb6:	6121                	addi	sp,sp,64
    80000cb8:	8082                	ret
      panic("kalloc");
    80000cba:	00006517          	auipc	a0,0x6
    80000cbe:	4de50513          	addi	a0,a0,1246 # 80007198 <etext+0x198>
    80000cc2:	061040ef          	jal	80005522 <panic>

0000000080000cc6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cc6:	7139                	addi	sp,sp,-64
    80000cc8:	fc06                	sd	ra,56(sp)
    80000cca:	f822                	sd	s0,48(sp)
    80000ccc:	f426                	sd	s1,40(sp)
    80000cce:	f04a                	sd	s2,32(sp)
    80000cd0:	ec4e                	sd	s3,24(sp)
    80000cd2:	e852                	sd	s4,16(sp)
    80000cd4:	e456                	sd	s5,8(sp)
    80000cd6:	e05a                	sd	s6,0(sp)
    80000cd8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cda:	00006597          	auipc	a1,0x6
    80000cde:	4c658593          	addi	a1,a1,1222 # 800071a0 <etext+0x1a0>
    80000ce2:	00009517          	auipc	a0,0x9
    80000ce6:	79e50513          	addi	a0,a0,1950 # 8000a480 <pid_lock>
    80000cea:	2e7040ef          	jal	800057d0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cee:	00006597          	auipc	a1,0x6
    80000cf2:	4ba58593          	addi	a1,a1,1210 # 800071a8 <etext+0x1a8>
    80000cf6:	00009517          	auipc	a0,0x9
    80000cfa:	7a250513          	addi	a0,a0,1954 # 8000a498 <wait_lock>
    80000cfe:	2d3040ef          	jal	800057d0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d02:	0000a497          	auipc	s1,0xa
    80000d06:	bae48493          	addi	s1,s1,-1106 # 8000a8b0 <proc>
      initlock(&p->lock, "proc");
    80000d0a:	00006b17          	auipc	s6,0x6
    80000d0e:	4aeb0b13          	addi	s6,s6,1198 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d12:	8aa6                	mv	s5,s1
    80000d14:	04fa5937          	lui	s2,0x4fa5
    80000d18:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d1c:	0932                	slli	s2,s2,0xc
    80000d1e:	fa590913          	addi	s2,s2,-91
    80000d22:	0932                	slli	s2,s2,0xc
    80000d24:	fa590913          	addi	s2,s2,-91
    80000d28:	0932                	slli	s2,s2,0xc
    80000d2a:	fa590913          	addi	s2,s2,-91
    80000d2e:	040009b7          	lui	s3,0x4000
    80000d32:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d34:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	0000fa17          	auipc	s4,0xf
    80000d3a:	57aa0a13          	addi	s4,s4,1402 # 800102b0 <tickslock>
      initlock(&p->lock, "proc");
    80000d3e:	85da                	mv	a1,s6
    80000d40:	8526                	mv	a0,s1
    80000d42:	28f040ef          	jal	800057d0 <initlock>
      p->state = UNUSED;
    80000d46:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d4a:	415487b3          	sub	a5,s1,s5
    80000d4e:	878d                	srai	a5,a5,0x3
    80000d50:	032787b3          	mul	a5,a5,s2
    80000d54:	2785                	addiw	a5,a5,1
    80000d56:	00d7979b          	slliw	a5,a5,0xd
    80000d5a:	40f987b3          	sub	a5,s3,a5
    80000d5e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d60:	16848493          	addi	s1,s1,360
    80000d64:	fd449de3          	bne	s1,s4,80000d3e <procinit+0x78>
  }
}
    80000d68:	70e2                	ld	ra,56(sp)
    80000d6a:	7442                	ld	s0,48(sp)
    80000d6c:	74a2                	ld	s1,40(sp)
    80000d6e:	7902                	ld	s2,32(sp)
    80000d70:	69e2                	ld	s3,24(sp)
    80000d72:	6a42                	ld	s4,16(sp)
    80000d74:	6aa2                	ld	s5,8(sp)
    80000d76:	6b02                	ld	s6,0(sp)
    80000d78:	6121                	addi	sp,sp,64
    80000d7a:	8082                	ret

0000000080000d7c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d7c:	1141                	addi	sp,sp,-16
    80000d7e:	e422                	sd	s0,8(sp)
    80000d80:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d82:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d84:	2501                	sext.w	a0,a0
    80000d86:	6422                	ld	s0,8(sp)
    80000d88:	0141                	addi	sp,sp,16
    80000d8a:	8082                	ret

0000000080000d8c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d8c:	1141                	addi	sp,sp,-16
    80000d8e:	e422                	sd	s0,8(sp)
    80000d90:	0800                	addi	s0,sp,16
    80000d92:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d94:	2781                	sext.w	a5,a5
    80000d96:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d98:	00009517          	auipc	a0,0x9
    80000d9c:	71850513          	addi	a0,a0,1816 # 8000a4b0 <cpus>
    80000da0:	953e                	add	a0,a0,a5
    80000da2:	6422                	ld	s0,8(sp)
    80000da4:	0141                	addi	sp,sp,16
    80000da6:	8082                	ret

0000000080000da8 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000da8:	1101                	addi	sp,sp,-32
    80000daa:	ec06                	sd	ra,24(sp)
    80000dac:	e822                	sd	s0,16(sp)
    80000dae:	e426                	sd	s1,8(sp)
    80000db0:	1000                	addi	s0,sp,32
  push_off();
    80000db2:	25f040ef          	jal	80005810 <push_off>
    80000db6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000db8:	2781                	sext.w	a5,a5
    80000dba:	079e                	slli	a5,a5,0x7
    80000dbc:	00009717          	auipc	a4,0x9
    80000dc0:	6c470713          	addi	a4,a4,1732 # 8000a480 <pid_lock>
    80000dc4:	97ba                	add	a5,a5,a4
    80000dc6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000dc8:	2cd040ef          	jal	80005894 <pop_off>
  return p;
}
    80000dcc:	8526                	mv	a0,s1
    80000dce:	60e2                	ld	ra,24(sp)
    80000dd0:	6442                	ld	s0,16(sp)
    80000dd2:	64a2                	ld	s1,8(sp)
    80000dd4:	6105                	addi	sp,sp,32
    80000dd6:	8082                	ret

0000000080000dd8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e406                	sd	ra,8(sp)
    80000ddc:	e022                	sd	s0,0(sp)
    80000dde:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000de0:	fc9ff0ef          	jal	80000da8 <myproc>
    80000de4:	305040ef          	jal	800058e8 <release>

  if (first) {
    80000de8:	00009797          	auipc	a5,0x9
    80000dec:	5d87a783          	lw	a5,1496(a5) # 8000a3c0 <first.1>
    80000df0:	e799                	bnez	a5,80000dfe <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000df2:	313000ef          	jal	80001904 <usertrapret>
}
    80000df6:	60a2                	ld	ra,8(sp)
    80000df8:	6402                	ld	s0,0(sp)
    80000dfa:	0141                	addi	sp,sp,16
    80000dfc:	8082                	ret
    fsinit(ROOTDEV);
    80000dfe:	4505                	li	a0,1
    80000e00:	736010ef          	jal	80002536 <fsinit>
    first = 0;
    80000e04:	00009797          	auipc	a5,0x9
    80000e08:	5a07ae23          	sw	zero,1468(a5) # 8000a3c0 <first.1>
    __sync_synchronize();
    80000e0c:	0330000f          	fence	rw,rw
    80000e10:	b7cd                	j	80000df2 <forkret+0x1a>

0000000080000e12 <allocpid>:
{
    80000e12:	1101                	addi	sp,sp,-32
    80000e14:	ec06                	sd	ra,24(sp)
    80000e16:	e822                	sd	s0,16(sp)
    80000e18:	e426                	sd	s1,8(sp)
    80000e1a:	e04a                	sd	s2,0(sp)
    80000e1c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e1e:	00009917          	auipc	s2,0x9
    80000e22:	66290913          	addi	s2,s2,1634 # 8000a480 <pid_lock>
    80000e26:	854a                	mv	a0,s2
    80000e28:	229040ef          	jal	80005850 <acquire>
  pid = nextpid;
    80000e2c:	00009797          	auipc	a5,0x9
    80000e30:	59878793          	addi	a5,a5,1432 # 8000a3c4 <nextpid>
    80000e34:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e36:	0014871b          	addiw	a4,s1,1
    80000e3a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e3c:	854a                	mv	a0,s2
    80000e3e:	2ab040ef          	jal	800058e8 <release>
}
    80000e42:	8526                	mv	a0,s1
    80000e44:	60e2                	ld	ra,24(sp)
    80000e46:	6442                	ld	s0,16(sp)
    80000e48:	64a2                	ld	s1,8(sp)
    80000e4a:	6902                	ld	s2,0(sp)
    80000e4c:	6105                	addi	sp,sp,32
    80000e4e:	8082                	ret

0000000080000e50 <proc_pagetable>:
{
    80000e50:	1101                	addi	sp,sp,-32
    80000e52:	ec06                	sd	ra,24(sp)
    80000e54:	e822                	sd	s0,16(sp)
    80000e56:	e426                	sd	s1,8(sp)
    80000e58:	e04a                	sd	s2,0(sp)
    80000e5a:	1000                	addi	s0,sp,32
    80000e5c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e5e:	8e1ff0ef          	jal	8000073e <uvmcreate>
    80000e62:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e64:	cd05                	beqz	a0,80000e9c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e66:	4729                	li	a4,10
    80000e68:	00005697          	auipc	a3,0x5
    80000e6c:	19868693          	addi	a3,a3,408 # 80006000 <_trampoline>
    80000e70:	6605                	lui	a2,0x1
    80000e72:	040005b7          	lui	a1,0x4000
    80000e76:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e78:	05b2                	slli	a1,a1,0xc
    80000e7a:	e62ff0ef          	jal	800004dc <mappages>
    80000e7e:	02054663          	bltz	a0,80000eaa <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e82:	4719                	li	a4,6
    80000e84:	05893683          	ld	a3,88(s2)
    80000e88:	6605                	lui	a2,0x1
    80000e8a:	020005b7          	lui	a1,0x2000
    80000e8e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e90:	05b6                	slli	a1,a1,0xd
    80000e92:	8526                	mv	a0,s1
    80000e94:	e48ff0ef          	jal	800004dc <mappages>
    80000e98:	00054f63          	bltz	a0,80000eb6 <proc_pagetable+0x66>
}
    80000e9c:	8526                	mv	a0,s1
    80000e9e:	60e2                	ld	ra,24(sp)
    80000ea0:	6442                	ld	s0,16(sp)
    80000ea2:	64a2                	ld	s1,8(sp)
    80000ea4:	6902                	ld	s2,0(sp)
    80000ea6:	6105                	addi	sp,sp,32
    80000ea8:	8082                	ret
    uvmfree(pagetable, 0);
    80000eaa:	4581                	li	a1,0
    80000eac:	8526                	mv	a0,s1
    80000eae:	a5fff0ef          	jal	8000090c <uvmfree>
    return 0;
    80000eb2:	4481                	li	s1,0
    80000eb4:	b7e5                	j	80000e9c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000eb6:	4681                	li	a3,0
    80000eb8:	4605                	li	a2,1
    80000eba:	040005b7          	lui	a1,0x4000
    80000ebe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ec0:	05b2                	slli	a1,a1,0xc
    80000ec2:	8526                	mv	a0,s1
    80000ec4:	fbeff0ef          	jal	80000682 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ec8:	4581                	li	a1,0
    80000eca:	8526                	mv	a0,s1
    80000ecc:	a41ff0ef          	jal	8000090c <uvmfree>
    return 0;
    80000ed0:	4481                	li	s1,0
    80000ed2:	b7e9                	j	80000e9c <proc_pagetable+0x4c>

0000000080000ed4 <proc_freepagetable>:
{
    80000ed4:	1101                	addi	sp,sp,-32
    80000ed6:	ec06                	sd	ra,24(sp)
    80000ed8:	e822                	sd	s0,16(sp)
    80000eda:	e426                	sd	s1,8(sp)
    80000edc:	e04a                	sd	s2,0(sp)
    80000ede:	1000                	addi	s0,sp,32
    80000ee0:	84aa                	mv	s1,a0
    80000ee2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ee4:	4681                	li	a3,0
    80000ee6:	4605                	li	a2,1
    80000ee8:	040005b7          	lui	a1,0x4000
    80000eec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eee:	05b2                	slli	a1,a1,0xc
    80000ef0:	f92ff0ef          	jal	80000682 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ef4:	4681                	li	a3,0
    80000ef6:	4605                	li	a2,1
    80000ef8:	020005b7          	lui	a1,0x2000
    80000efc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000efe:	05b6                	slli	a1,a1,0xd
    80000f00:	8526                	mv	a0,s1
    80000f02:	f80ff0ef          	jal	80000682 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f06:	85ca                	mv	a1,s2
    80000f08:	8526                	mv	a0,s1
    80000f0a:	a03ff0ef          	jal	8000090c <uvmfree>
}
    80000f0e:	60e2                	ld	ra,24(sp)
    80000f10:	6442                	ld	s0,16(sp)
    80000f12:	64a2                	ld	s1,8(sp)
    80000f14:	6902                	ld	s2,0(sp)
    80000f16:	6105                	addi	sp,sp,32
    80000f18:	8082                	ret

0000000080000f1a <freeproc>:
{
    80000f1a:	1101                	addi	sp,sp,-32
    80000f1c:	ec06                	sd	ra,24(sp)
    80000f1e:	e822                	sd	s0,16(sp)
    80000f20:	e426                	sd	s1,8(sp)
    80000f22:	1000                	addi	s0,sp,32
    80000f24:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f26:	6d28                	ld	a0,88(a0)
    80000f28:	c119                	beqz	a0,80000f2e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f2a:	8f2ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f2e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f32:	68a8                	ld	a0,80(s1)
    80000f34:	c501                	beqz	a0,80000f3c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f36:	64ac                	ld	a1,72(s1)
    80000f38:	f9dff0ef          	jal	80000ed4 <proc_freepagetable>
  p->pagetable = 0;
    80000f3c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f40:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f44:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f48:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f4c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f50:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f54:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f58:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f5c:	0004ac23          	sw	zero,24(s1)
}
    80000f60:	60e2                	ld	ra,24(sp)
    80000f62:	6442                	ld	s0,16(sp)
    80000f64:	64a2                	ld	s1,8(sp)
    80000f66:	6105                	addi	sp,sp,32
    80000f68:	8082                	ret

0000000080000f6a <allocproc>:
{
    80000f6a:	1101                	addi	sp,sp,-32
    80000f6c:	ec06                	sd	ra,24(sp)
    80000f6e:	e822                	sd	s0,16(sp)
    80000f70:	e426                	sd	s1,8(sp)
    80000f72:	e04a                	sd	s2,0(sp)
    80000f74:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f76:	0000a497          	auipc	s1,0xa
    80000f7a:	93a48493          	addi	s1,s1,-1734 # 8000a8b0 <proc>
    80000f7e:	0000f917          	auipc	s2,0xf
    80000f82:	33290913          	addi	s2,s2,818 # 800102b0 <tickslock>
    acquire(&p->lock);
    80000f86:	8526                	mv	a0,s1
    80000f88:	0c9040ef          	jal	80005850 <acquire>
    if(p->state == UNUSED) {
    80000f8c:	4c9c                	lw	a5,24(s1)
    80000f8e:	cb91                	beqz	a5,80000fa2 <allocproc+0x38>
      release(&p->lock);
    80000f90:	8526                	mv	a0,s1
    80000f92:	157040ef          	jal	800058e8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f96:	16848493          	addi	s1,s1,360
    80000f9a:	ff2496e3          	bne	s1,s2,80000f86 <allocproc+0x1c>
  return 0;
    80000f9e:	4481                	li	s1,0
    80000fa0:	a089                	j	80000fe2 <allocproc+0x78>
  p->pid = allocpid();
    80000fa2:	e71ff0ef          	jal	80000e12 <allocpid>
    80000fa6:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000fa8:	4785                	li	a5,1
    80000faa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fac:	952ff0ef          	jal	800000fe <kalloc>
    80000fb0:	892a                	mv	s2,a0
    80000fb2:	eca8                	sd	a0,88(s1)
    80000fb4:	cd15                	beqz	a0,80000ff0 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	e99ff0ef          	jal	80000e50 <proc_pagetable>
    80000fbc:	892a                	mv	s2,a0
    80000fbe:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fc0:	c121                	beqz	a0,80001000 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000fc2:	07000613          	li	a2,112
    80000fc6:	4581                	li	a1,0
    80000fc8:	06048513          	addi	a0,s1,96
    80000fcc:	9c4ff0ef          	jal	80000190 <memset>
  p->context.ra = (uint64)forkret;
    80000fd0:	00000797          	auipc	a5,0x0
    80000fd4:	e0878793          	addi	a5,a5,-504 # 80000dd8 <forkret>
    80000fd8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000fda:	60bc                	ld	a5,64(s1)
    80000fdc:	6705                	lui	a4,0x1
    80000fde:	97ba                	add	a5,a5,a4
    80000fe0:	f4bc                	sd	a5,104(s1)
}
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	60e2                	ld	ra,24(sp)
    80000fe6:	6442                	ld	s0,16(sp)
    80000fe8:	64a2                	ld	s1,8(sp)
    80000fea:	6902                	ld	s2,0(sp)
    80000fec:	6105                	addi	sp,sp,32
    80000fee:	8082                	ret
    freeproc(p);
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	f29ff0ef          	jal	80000f1a <freeproc>
    release(&p->lock);
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	0f1040ef          	jal	800058e8 <release>
    return 0;
    80000ffc:	84ca                	mv	s1,s2
    80000ffe:	b7d5                	j	80000fe2 <allocproc+0x78>
    freeproc(p);
    80001000:	8526                	mv	a0,s1
    80001002:	f19ff0ef          	jal	80000f1a <freeproc>
    release(&p->lock);
    80001006:	8526                	mv	a0,s1
    80001008:	0e1040ef          	jal	800058e8 <release>
    return 0;
    8000100c:	84ca                	mv	s1,s2
    8000100e:	bfd1                	j	80000fe2 <allocproc+0x78>

0000000080001010 <userinit>:
{
    80001010:	1101                	addi	sp,sp,-32
    80001012:	ec06                	sd	ra,24(sp)
    80001014:	e822                	sd	s0,16(sp)
    80001016:	e426                	sd	s1,8(sp)
    80001018:	1000                	addi	s0,sp,32
  p = allocproc();
    8000101a:	f51ff0ef          	jal	80000f6a <allocproc>
    8000101e:	84aa                	mv	s1,a0
  initproc = p;
    80001020:	00009797          	auipc	a5,0x9
    80001024:	42a7b023          	sd	a0,1056(a5) # 8000a440 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001028:	03400613          	li	a2,52
    8000102c:	00009597          	auipc	a1,0x9
    80001030:	3a458593          	addi	a1,a1,932 # 8000a3d0 <initcode>
    80001034:	6928                	ld	a0,80(a0)
    80001036:	f2eff0ef          	jal	80000764 <uvmfirst>
  p->sz = PGSIZE;
    8000103a:	6785                	lui	a5,0x1
    8000103c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000103e:	6cb8                	ld	a4,88(s1)
    80001040:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001044:	6cb8                	ld	a4,88(s1)
    80001046:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001048:	4641                	li	a2,16
    8000104a:	00006597          	auipc	a1,0x6
    8000104e:	17658593          	addi	a1,a1,374 # 800071c0 <etext+0x1c0>
    80001052:	15848513          	addi	a0,s1,344
    80001056:	a78ff0ef          	jal	800002ce <safestrcpy>
  p->cwd = namei("/");
    8000105a:	00006517          	auipc	a0,0x6
    8000105e:	17650513          	addi	a0,a0,374 # 800071d0 <etext+0x1d0>
    80001062:	5e3010ef          	jal	80002e44 <namei>
    80001066:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000106a:	478d                	li	a5,3
    8000106c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	079040ef          	jal	800058e8 <release>
}
    80001074:	60e2                	ld	ra,24(sp)
    80001076:	6442                	ld	s0,16(sp)
    80001078:	64a2                	ld	s1,8(sp)
    8000107a:	6105                	addi	sp,sp,32
    8000107c:	8082                	ret

000000008000107e <growproc>:
{
    8000107e:	1101                	addi	sp,sp,-32
    80001080:	ec06                	sd	ra,24(sp)
    80001082:	e822                	sd	s0,16(sp)
    80001084:	e426                	sd	s1,8(sp)
    80001086:	e04a                	sd	s2,0(sp)
    80001088:	1000                	addi	s0,sp,32
    8000108a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000108c:	d1dff0ef          	jal	80000da8 <myproc>
    80001090:	84aa                	mv	s1,a0
  sz = p->sz;
    80001092:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001094:	01204c63          	bgtz	s2,800010ac <growproc+0x2e>
  } else if(n < 0){
    80001098:	02094463          	bltz	s2,800010c0 <growproc+0x42>
  p->sz = sz;
    8000109c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000109e:	4501                	li	a0,0
}
    800010a0:	60e2                	ld	ra,24(sp)
    800010a2:	6442                	ld	s0,16(sp)
    800010a4:	64a2                	ld	s1,8(sp)
    800010a6:	6902                	ld	s2,0(sp)
    800010a8:	6105                	addi	sp,sp,32
    800010aa:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010ac:	4691                	li	a3,4
    800010ae:	00b90633          	add	a2,s2,a1
    800010b2:	6928                	ld	a0,80(a0)
    800010b4:	f52ff0ef          	jal	80000806 <uvmalloc>
    800010b8:	85aa                	mv	a1,a0
    800010ba:	f16d                	bnez	a0,8000109c <growproc+0x1e>
      return -1;
    800010bc:	557d                	li	a0,-1
    800010be:	b7cd                	j	800010a0 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010c0:	00b90633          	add	a2,s2,a1
    800010c4:	6928                	ld	a0,80(a0)
    800010c6:	efcff0ef          	jal	800007c2 <uvmdealloc>
    800010ca:	85aa                	mv	a1,a0
    800010cc:	bfc1                	j	8000109c <growproc+0x1e>

00000000800010ce <fork>:
{
    800010ce:	7139                	addi	sp,sp,-64
    800010d0:	fc06                	sd	ra,56(sp)
    800010d2:	f822                	sd	s0,48(sp)
    800010d4:	f04a                	sd	s2,32(sp)
    800010d6:	e456                	sd	s5,8(sp)
    800010d8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010da:	ccfff0ef          	jal	80000da8 <myproc>
    800010de:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010e0:	e8bff0ef          	jal	80000f6a <allocproc>
    800010e4:	0e050e63          	beqz	a0,800011e0 <fork+0x112>
    800010e8:	ec4e                	sd	s3,24(sp)
    800010ea:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010ec:	048ab603          	ld	a2,72(s5)
    800010f0:	692c                	ld	a1,80(a0)
    800010f2:	050ab503          	ld	a0,80(s5)
    800010f6:	849ff0ef          	jal	8000093e <uvmcopy>
    800010fa:	04054a63          	bltz	a0,8000114e <fork+0x80>
    800010fe:	f426                	sd	s1,40(sp)
    80001100:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001102:	048ab783          	ld	a5,72(s5)
    80001106:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000110a:	058ab683          	ld	a3,88(s5)
    8000110e:	87b6                	mv	a5,a3
    80001110:	0589b703          	ld	a4,88(s3)
    80001114:	12068693          	addi	a3,a3,288
    80001118:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000111c:	6788                	ld	a0,8(a5)
    8000111e:	6b8c                	ld	a1,16(a5)
    80001120:	6f90                	ld	a2,24(a5)
    80001122:	01073023          	sd	a6,0(a4)
    80001126:	e708                	sd	a0,8(a4)
    80001128:	eb0c                	sd	a1,16(a4)
    8000112a:	ef10                	sd	a2,24(a4)
    8000112c:	02078793          	addi	a5,a5,32
    80001130:	02070713          	addi	a4,a4,32
    80001134:	fed792e3          	bne	a5,a3,80001118 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001138:	0589b783          	ld	a5,88(s3)
    8000113c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001140:	0d0a8493          	addi	s1,s5,208
    80001144:	0d098913          	addi	s2,s3,208
    80001148:	150a8a13          	addi	s4,s5,336
    8000114c:	a831                	j	80001168 <fork+0x9a>
    freeproc(np);
    8000114e:	854e                	mv	a0,s3
    80001150:	dcbff0ef          	jal	80000f1a <freeproc>
    release(&np->lock);
    80001154:	854e                	mv	a0,s3
    80001156:	792040ef          	jal	800058e8 <release>
    return -1;
    8000115a:	597d                	li	s2,-1
    8000115c:	69e2                	ld	s3,24(sp)
    8000115e:	a895                	j	800011d2 <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    80001160:	04a1                	addi	s1,s1,8
    80001162:	0921                	addi	s2,s2,8
    80001164:	01448963          	beq	s1,s4,80001176 <fork+0xa8>
    if(p->ofile[i])
    80001168:	6088                	ld	a0,0(s1)
    8000116a:	d97d                	beqz	a0,80001160 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000116c:	268020ef          	jal	800033d4 <filedup>
    80001170:	00a93023          	sd	a0,0(s2)
    80001174:	b7f5                	j	80001160 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001176:	150ab503          	ld	a0,336(s5)
    8000117a:	5ba010ef          	jal	80002734 <idup>
    8000117e:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001182:	4641                	li	a2,16
    80001184:	158a8593          	addi	a1,s5,344
    80001188:	15898513          	addi	a0,s3,344
    8000118c:	942ff0ef          	jal	800002ce <safestrcpy>
  pid = np->pid;
    80001190:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001194:	854e                	mv	a0,s3
    80001196:	752040ef          	jal	800058e8 <release>
  acquire(&wait_lock);
    8000119a:	00009497          	auipc	s1,0x9
    8000119e:	2fe48493          	addi	s1,s1,766 # 8000a498 <wait_lock>
    800011a2:	8526                	mv	a0,s1
    800011a4:	6ac040ef          	jal	80005850 <acquire>
  np->parent = p;
    800011a8:	0359bc23          	sd	s5,56(s3)
  np->tracemask = p->tracemask; // inherit tracemask from parent
    800011ac:	034aa783          	lw	a5,52(s5)
    800011b0:	02f9aa23          	sw	a5,52(s3)
  release(&wait_lock);
    800011b4:	8526                	mv	a0,s1
    800011b6:	732040ef          	jal	800058e8 <release>
  acquire(&np->lock);
    800011ba:	854e                	mv	a0,s3
    800011bc:	694040ef          	jal	80005850 <acquire>
  np->state = RUNNABLE;
    800011c0:	478d                	li	a5,3
    800011c2:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800011c6:	854e                	mv	a0,s3
    800011c8:	720040ef          	jal	800058e8 <release>
  return pid;
    800011cc:	74a2                	ld	s1,40(sp)
    800011ce:	69e2                	ld	s3,24(sp)
    800011d0:	6a42                	ld	s4,16(sp)
}
    800011d2:	854a                	mv	a0,s2
    800011d4:	70e2                	ld	ra,56(sp)
    800011d6:	7442                	ld	s0,48(sp)
    800011d8:	7902                	ld	s2,32(sp)
    800011da:	6aa2                	ld	s5,8(sp)
    800011dc:	6121                	addi	sp,sp,64
    800011de:	8082                	ret
    return -1;
    800011e0:	597d                	li	s2,-1
    800011e2:	bfc5                	j	800011d2 <fork+0x104>

00000000800011e4 <scheduler>:
{
    800011e4:	715d                	addi	sp,sp,-80
    800011e6:	e486                	sd	ra,72(sp)
    800011e8:	e0a2                	sd	s0,64(sp)
    800011ea:	fc26                	sd	s1,56(sp)
    800011ec:	f84a                	sd	s2,48(sp)
    800011ee:	f44e                	sd	s3,40(sp)
    800011f0:	f052                	sd	s4,32(sp)
    800011f2:	ec56                	sd	s5,24(sp)
    800011f4:	e85a                	sd	s6,16(sp)
    800011f6:	e45e                	sd	s7,8(sp)
    800011f8:	e062                	sd	s8,0(sp)
    800011fa:	0880                	addi	s0,sp,80
    800011fc:	8792                	mv	a5,tp
  int id = r_tp();
    800011fe:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001200:	00779b13          	slli	s6,a5,0x7
    80001204:	00009717          	auipc	a4,0x9
    80001208:	27c70713          	addi	a4,a4,636 # 8000a480 <pid_lock>
    8000120c:	975a                	add	a4,a4,s6
    8000120e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001212:	00009717          	auipc	a4,0x9
    80001216:	2a670713          	addi	a4,a4,678 # 8000a4b8 <cpus+0x8>
    8000121a:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000121c:	4c11                	li	s8,4
        c->proc = p;
    8000121e:	079e                	slli	a5,a5,0x7
    80001220:	00009a17          	auipc	s4,0x9
    80001224:	260a0a13          	addi	s4,s4,608 # 8000a480 <pid_lock>
    80001228:	9a3e                	add	s4,s4,a5
        found = 1;
    8000122a:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    8000122c:	0000f997          	auipc	s3,0xf
    80001230:	08498993          	addi	s3,s3,132 # 800102b0 <tickslock>
    80001234:	a0a9                	j	8000127e <scheduler+0x9a>
      release(&p->lock);
    80001236:	8526                	mv	a0,s1
    80001238:	6b0040ef          	jal	800058e8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000123c:	16848493          	addi	s1,s1,360
    80001240:	03348563          	beq	s1,s3,8000126a <scheduler+0x86>
      acquire(&p->lock);
    80001244:	8526                	mv	a0,s1
    80001246:	60a040ef          	jal	80005850 <acquire>
      if(p->state == RUNNABLE) {
    8000124a:	4c9c                	lw	a5,24(s1)
    8000124c:	ff2795e3          	bne	a5,s2,80001236 <scheduler+0x52>
        p->state = RUNNING;
    80001250:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001254:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001258:	06048593          	addi	a1,s1,96
    8000125c:	855a                	mv	a0,s6
    8000125e:	600000ef          	jal	8000185e <swtch>
        c->proc = 0;
    80001262:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001266:	8ade                	mv	s5,s7
    80001268:	b7f9                	j	80001236 <scheduler+0x52>
    if(found == 0) {
    8000126a:	000a9a63          	bnez	s5,8000127e <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000126e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001272:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001276:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000127a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000127e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001282:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001286:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000128a:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000128c:	00009497          	auipc	s1,0x9
    80001290:	62448493          	addi	s1,s1,1572 # 8000a8b0 <proc>
      if(p->state == RUNNABLE) {
    80001294:	490d                	li	s2,3
    80001296:	b77d                	j	80001244 <scheduler+0x60>

0000000080001298 <sched>:
{
    80001298:	7179                	addi	sp,sp,-48
    8000129a:	f406                	sd	ra,40(sp)
    8000129c:	f022                	sd	s0,32(sp)
    8000129e:	ec26                	sd	s1,24(sp)
    800012a0:	e84a                	sd	s2,16(sp)
    800012a2:	e44e                	sd	s3,8(sp)
    800012a4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012a6:	b03ff0ef          	jal	80000da8 <myproc>
    800012aa:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012ac:	53a040ef          	jal	800057e6 <holding>
    800012b0:	c92d                	beqz	a0,80001322 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012b2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012b4:	2781                	sext.w	a5,a5
    800012b6:	079e                	slli	a5,a5,0x7
    800012b8:	00009717          	auipc	a4,0x9
    800012bc:	1c870713          	addi	a4,a4,456 # 8000a480 <pid_lock>
    800012c0:	97ba                	add	a5,a5,a4
    800012c2:	0a87a703          	lw	a4,168(a5)
    800012c6:	4785                	li	a5,1
    800012c8:	06f71363          	bne	a4,a5,8000132e <sched+0x96>
  if(p->state == RUNNING)
    800012cc:	4c98                	lw	a4,24(s1)
    800012ce:	4791                	li	a5,4
    800012d0:	06f70563          	beq	a4,a5,8000133a <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012d4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012d8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012da:	e7b5                	bnez	a5,80001346 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012dc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012de:	00009917          	auipc	s2,0x9
    800012e2:	1a290913          	addi	s2,s2,418 # 8000a480 <pid_lock>
    800012e6:	2781                	sext.w	a5,a5
    800012e8:	079e                	slli	a5,a5,0x7
    800012ea:	97ca                	add	a5,a5,s2
    800012ec:	0ac7a983          	lw	s3,172(a5)
    800012f0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012f2:	2781                	sext.w	a5,a5
    800012f4:	079e                	slli	a5,a5,0x7
    800012f6:	00009597          	auipc	a1,0x9
    800012fa:	1c258593          	addi	a1,a1,450 # 8000a4b8 <cpus+0x8>
    800012fe:	95be                	add	a1,a1,a5
    80001300:	06048513          	addi	a0,s1,96
    80001304:	55a000ef          	jal	8000185e <swtch>
    80001308:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000130a:	2781                	sext.w	a5,a5
    8000130c:	079e                	slli	a5,a5,0x7
    8000130e:	993e                	add	s2,s2,a5
    80001310:	0b392623          	sw	s3,172(s2)
}
    80001314:	70a2                	ld	ra,40(sp)
    80001316:	7402                	ld	s0,32(sp)
    80001318:	64e2                	ld	s1,24(sp)
    8000131a:	6942                	ld	s2,16(sp)
    8000131c:	69a2                	ld	s3,8(sp)
    8000131e:	6145                	addi	sp,sp,48
    80001320:	8082                	ret
    panic("sched p->lock");
    80001322:	00006517          	auipc	a0,0x6
    80001326:	eb650513          	addi	a0,a0,-330 # 800071d8 <etext+0x1d8>
    8000132a:	1f8040ef          	jal	80005522 <panic>
    panic("sched locks");
    8000132e:	00006517          	auipc	a0,0x6
    80001332:	eba50513          	addi	a0,a0,-326 # 800071e8 <etext+0x1e8>
    80001336:	1ec040ef          	jal	80005522 <panic>
    panic("sched running");
    8000133a:	00006517          	auipc	a0,0x6
    8000133e:	ebe50513          	addi	a0,a0,-322 # 800071f8 <etext+0x1f8>
    80001342:	1e0040ef          	jal	80005522 <panic>
    panic("sched interruptible");
    80001346:	00006517          	auipc	a0,0x6
    8000134a:	ec250513          	addi	a0,a0,-318 # 80007208 <etext+0x208>
    8000134e:	1d4040ef          	jal	80005522 <panic>

0000000080001352 <yield>:
{
    80001352:	1101                	addi	sp,sp,-32
    80001354:	ec06                	sd	ra,24(sp)
    80001356:	e822                	sd	s0,16(sp)
    80001358:	e426                	sd	s1,8(sp)
    8000135a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000135c:	a4dff0ef          	jal	80000da8 <myproc>
    80001360:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001362:	4ee040ef          	jal	80005850 <acquire>
  p->state = RUNNABLE;
    80001366:	478d                	li	a5,3
    80001368:	cc9c                	sw	a5,24(s1)
  sched();
    8000136a:	f2fff0ef          	jal	80001298 <sched>
  release(&p->lock);
    8000136e:	8526                	mv	a0,s1
    80001370:	578040ef          	jal	800058e8 <release>
}
    80001374:	60e2                	ld	ra,24(sp)
    80001376:	6442                	ld	s0,16(sp)
    80001378:	64a2                	ld	s1,8(sp)
    8000137a:	6105                	addi	sp,sp,32
    8000137c:	8082                	ret

000000008000137e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000137e:	7179                	addi	sp,sp,-48
    80001380:	f406                	sd	ra,40(sp)
    80001382:	f022                	sd	s0,32(sp)
    80001384:	ec26                	sd	s1,24(sp)
    80001386:	e84a                	sd	s2,16(sp)
    80001388:	e44e                	sd	s3,8(sp)
    8000138a:	1800                	addi	s0,sp,48
    8000138c:	89aa                	mv	s3,a0
    8000138e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001390:	a19ff0ef          	jal	80000da8 <myproc>
    80001394:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001396:	4ba040ef          	jal	80005850 <acquire>
  release(lk);
    8000139a:	854a                	mv	a0,s2
    8000139c:	54c040ef          	jal	800058e8 <release>

  // Go to sleep.
  p->chan = chan;
    800013a0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800013a4:	4789                	li	a5,2
    800013a6:	cc9c                	sw	a5,24(s1)

  sched();
    800013a8:	ef1ff0ef          	jal	80001298 <sched>

  // Tidy up.
  p->chan = 0;
    800013ac:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013b0:	8526                	mv	a0,s1
    800013b2:	536040ef          	jal	800058e8 <release>
  acquire(lk);
    800013b6:	854a                	mv	a0,s2
    800013b8:	498040ef          	jal	80005850 <acquire>
}
    800013bc:	70a2                	ld	ra,40(sp)
    800013be:	7402                	ld	s0,32(sp)
    800013c0:	64e2                	ld	s1,24(sp)
    800013c2:	6942                	ld	s2,16(sp)
    800013c4:	69a2                	ld	s3,8(sp)
    800013c6:	6145                	addi	sp,sp,48
    800013c8:	8082                	ret

00000000800013ca <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800013ca:	7139                	addi	sp,sp,-64
    800013cc:	fc06                	sd	ra,56(sp)
    800013ce:	f822                	sd	s0,48(sp)
    800013d0:	f426                	sd	s1,40(sp)
    800013d2:	f04a                	sd	s2,32(sp)
    800013d4:	ec4e                	sd	s3,24(sp)
    800013d6:	e852                	sd	s4,16(sp)
    800013d8:	e456                	sd	s5,8(sp)
    800013da:	0080                	addi	s0,sp,64
    800013dc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013de:	00009497          	auipc	s1,0x9
    800013e2:	4d248493          	addi	s1,s1,1234 # 8000a8b0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013e6:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013e8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ea:	0000f917          	auipc	s2,0xf
    800013ee:	ec690913          	addi	s2,s2,-314 # 800102b0 <tickslock>
    800013f2:	a801                	j	80001402 <wakeup+0x38>
      }
      release(&p->lock);
    800013f4:	8526                	mv	a0,s1
    800013f6:	4f2040ef          	jal	800058e8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013fa:	16848493          	addi	s1,s1,360
    800013fe:	03248263          	beq	s1,s2,80001422 <wakeup+0x58>
    if(p != myproc()){
    80001402:	9a7ff0ef          	jal	80000da8 <myproc>
    80001406:	fea48ae3          	beq	s1,a0,800013fa <wakeup+0x30>
      acquire(&p->lock);
    8000140a:	8526                	mv	a0,s1
    8000140c:	444040ef          	jal	80005850 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001410:	4c9c                	lw	a5,24(s1)
    80001412:	ff3791e3          	bne	a5,s3,800013f4 <wakeup+0x2a>
    80001416:	709c                	ld	a5,32(s1)
    80001418:	fd479ee3          	bne	a5,s4,800013f4 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000141c:	0154ac23          	sw	s5,24(s1)
    80001420:	bfd1                	j	800013f4 <wakeup+0x2a>
    }
  }
}
    80001422:	70e2                	ld	ra,56(sp)
    80001424:	7442                	ld	s0,48(sp)
    80001426:	74a2                	ld	s1,40(sp)
    80001428:	7902                	ld	s2,32(sp)
    8000142a:	69e2                	ld	s3,24(sp)
    8000142c:	6a42                	ld	s4,16(sp)
    8000142e:	6aa2                	ld	s5,8(sp)
    80001430:	6121                	addi	sp,sp,64
    80001432:	8082                	ret

0000000080001434 <reparent>:
{
    80001434:	7179                	addi	sp,sp,-48
    80001436:	f406                	sd	ra,40(sp)
    80001438:	f022                	sd	s0,32(sp)
    8000143a:	ec26                	sd	s1,24(sp)
    8000143c:	e84a                	sd	s2,16(sp)
    8000143e:	e44e                	sd	s3,8(sp)
    80001440:	e052                	sd	s4,0(sp)
    80001442:	1800                	addi	s0,sp,48
    80001444:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001446:	00009497          	auipc	s1,0x9
    8000144a:	46a48493          	addi	s1,s1,1130 # 8000a8b0 <proc>
      pp->parent = initproc;
    8000144e:	00009a17          	auipc	s4,0x9
    80001452:	ff2a0a13          	addi	s4,s4,-14 # 8000a440 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001456:	0000f997          	auipc	s3,0xf
    8000145a:	e5a98993          	addi	s3,s3,-422 # 800102b0 <tickslock>
    8000145e:	a029                	j	80001468 <reparent+0x34>
    80001460:	16848493          	addi	s1,s1,360
    80001464:	01348b63          	beq	s1,s3,8000147a <reparent+0x46>
    if(pp->parent == p){
    80001468:	7c9c                	ld	a5,56(s1)
    8000146a:	ff279be3          	bne	a5,s2,80001460 <reparent+0x2c>
      pp->parent = initproc;
    8000146e:	000a3503          	ld	a0,0(s4)
    80001472:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001474:	f57ff0ef          	jal	800013ca <wakeup>
    80001478:	b7e5                	j	80001460 <reparent+0x2c>
}
    8000147a:	70a2                	ld	ra,40(sp)
    8000147c:	7402                	ld	s0,32(sp)
    8000147e:	64e2                	ld	s1,24(sp)
    80001480:	6942                	ld	s2,16(sp)
    80001482:	69a2                	ld	s3,8(sp)
    80001484:	6a02                	ld	s4,0(sp)
    80001486:	6145                	addi	sp,sp,48
    80001488:	8082                	ret

000000008000148a <exit>:
{
    8000148a:	7179                	addi	sp,sp,-48
    8000148c:	f406                	sd	ra,40(sp)
    8000148e:	f022                	sd	s0,32(sp)
    80001490:	ec26                	sd	s1,24(sp)
    80001492:	e84a                	sd	s2,16(sp)
    80001494:	e44e                	sd	s3,8(sp)
    80001496:	e052                	sd	s4,0(sp)
    80001498:	1800                	addi	s0,sp,48
    8000149a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000149c:	90dff0ef          	jal	80000da8 <myproc>
    800014a0:	89aa                	mv	s3,a0
  if(p == initproc)
    800014a2:	00009797          	auipc	a5,0x9
    800014a6:	f9e7b783          	ld	a5,-98(a5) # 8000a440 <initproc>
    800014aa:	0d050493          	addi	s1,a0,208
    800014ae:	15050913          	addi	s2,a0,336
    800014b2:	00a79f63          	bne	a5,a0,800014d0 <exit+0x46>
    panic("init exiting");
    800014b6:	00006517          	auipc	a0,0x6
    800014ba:	d6a50513          	addi	a0,a0,-662 # 80007220 <etext+0x220>
    800014be:	064040ef          	jal	80005522 <panic>
      fileclose(f);
    800014c2:	759010ef          	jal	8000341a <fileclose>
      p->ofile[fd] = 0;
    800014c6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014ca:	04a1                	addi	s1,s1,8
    800014cc:	01248563          	beq	s1,s2,800014d6 <exit+0x4c>
    if(p->ofile[fd]){
    800014d0:	6088                	ld	a0,0(s1)
    800014d2:	f965                	bnez	a0,800014c2 <exit+0x38>
    800014d4:	bfdd                	j	800014ca <exit+0x40>
  begin_op();
    800014d6:	32b010ef          	jal	80003000 <begin_op>
  iput(p->cwd);
    800014da:	1509b503          	ld	a0,336(s3)
    800014de:	40e010ef          	jal	800028ec <iput>
  end_op();
    800014e2:	389010ef          	jal	8000306a <end_op>
  p->cwd = 0;
    800014e6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014ea:	00009497          	auipc	s1,0x9
    800014ee:	fae48493          	addi	s1,s1,-82 # 8000a498 <wait_lock>
    800014f2:	8526                	mv	a0,s1
    800014f4:	35c040ef          	jal	80005850 <acquire>
  reparent(p);
    800014f8:	854e                	mv	a0,s3
    800014fa:	f3bff0ef          	jal	80001434 <reparent>
  wakeup(p->parent);
    800014fe:	0389b503          	ld	a0,56(s3)
    80001502:	ec9ff0ef          	jal	800013ca <wakeup>
  acquire(&p->lock);
    80001506:	854e                	mv	a0,s3
    80001508:	348040ef          	jal	80005850 <acquire>
  p->xstate = status;
    8000150c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001510:	4795                	li	a5,5
    80001512:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001516:	8526                	mv	a0,s1
    80001518:	3d0040ef          	jal	800058e8 <release>
  sched();
    8000151c:	d7dff0ef          	jal	80001298 <sched>
  panic("zombie exit");
    80001520:	00006517          	auipc	a0,0x6
    80001524:	d1050513          	addi	a0,a0,-752 # 80007230 <etext+0x230>
    80001528:	7fb030ef          	jal	80005522 <panic>

000000008000152c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000152c:	7179                	addi	sp,sp,-48
    8000152e:	f406                	sd	ra,40(sp)
    80001530:	f022                	sd	s0,32(sp)
    80001532:	ec26                	sd	s1,24(sp)
    80001534:	e84a                	sd	s2,16(sp)
    80001536:	e44e                	sd	s3,8(sp)
    80001538:	1800                	addi	s0,sp,48
    8000153a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000153c:	00009497          	auipc	s1,0x9
    80001540:	37448493          	addi	s1,s1,884 # 8000a8b0 <proc>
    80001544:	0000f997          	auipc	s3,0xf
    80001548:	d6c98993          	addi	s3,s3,-660 # 800102b0 <tickslock>
    acquire(&p->lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	302040ef          	jal	80005850 <acquire>
    if(p->pid == pid){
    80001552:	589c                	lw	a5,48(s1)
    80001554:	01278b63          	beq	a5,s2,8000156a <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001558:	8526                	mv	a0,s1
    8000155a:	38e040ef          	jal	800058e8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000155e:	16848493          	addi	s1,s1,360
    80001562:	ff3495e3          	bne	s1,s3,8000154c <kill+0x20>
  }
  return -1;
    80001566:	557d                	li	a0,-1
    80001568:	a819                	j	8000157e <kill+0x52>
      p->killed = 1;
    8000156a:	4785                	li	a5,1
    8000156c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000156e:	4c98                	lw	a4,24(s1)
    80001570:	4789                	li	a5,2
    80001572:	00f70d63          	beq	a4,a5,8000158c <kill+0x60>
      release(&p->lock);
    80001576:	8526                	mv	a0,s1
    80001578:	370040ef          	jal	800058e8 <release>
      return 0;
    8000157c:	4501                	li	a0,0
}
    8000157e:	70a2                	ld	ra,40(sp)
    80001580:	7402                	ld	s0,32(sp)
    80001582:	64e2                	ld	s1,24(sp)
    80001584:	6942                	ld	s2,16(sp)
    80001586:	69a2                	ld	s3,8(sp)
    80001588:	6145                	addi	sp,sp,48
    8000158a:	8082                	ret
        p->state = RUNNABLE;
    8000158c:	478d                	li	a5,3
    8000158e:	cc9c                	sw	a5,24(s1)
    80001590:	b7dd                	j	80001576 <kill+0x4a>

0000000080001592 <setkilled>:

void
setkilled(struct proc *p)
{
    80001592:	1101                	addi	sp,sp,-32
    80001594:	ec06                	sd	ra,24(sp)
    80001596:	e822                	sd	s0,16(sp)
    80001598:	e426                	sd	s1,8(sp)
    8000159a:	1000                	addi	s0,sp,32
    8000159c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000159e:	2b2040ef          	jal	80005850 <acquire>
  p->killed = 1;
    800015a2:	4785                	li	a5,1
    800015a4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800015a6:	8526                	mv	a0,s1
    800015a8:	340040ef          	jal	800058e8 <release>
}
    800015ac:	60e2                	ld	ra,24(sp)
    800015ae:	6442                	ld	s0,16(sp)
    800015b0:	64a2                	ld	s1,8(sp)
    800015b2:	6105                	addi	sp,sp,32
    800015b4:	8082                	ret

00000000800015b6 <killed>:

int
killed(struct proc *p)
{
    800015b6:	1101                	addi	sp,sp,-32
    800015b8:	ec06                	sd	ra,24(sp)
    800015ba:	e822                	sd	s0,16(sp)
    800015bc:	e426                	sd	s1,8(sp)
    800015be:	e04a                	sd	s2,0(sp)
    800015c0:	1000                	addi	s0,sp,32
    800015c2:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015c4:	28c040ef          	jal	80005850 <acquire>
  k = p->killed;
    800015c8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015cc:	8526                	mv	a0,s1
    800015ce:	31a040ef          	jal	800058e8 <release>
  return k;
}
    800015d2:	854a                	mv	a0,s2
    800015d4:	60e2                	ld	ra,24(sp)
    800015d6:	6442                	ld	s0,16(sp)
    800015d8:	64a2                	ld	s1,8(sp)
    800015da:	6902                	ld	s2,0(sp)
    800015dc:	6105                	addi	sp,sp,32
    800015de:	8082                	ret

00000000800015e0 <wait>:
{
    800015e0:	715d                	addi	sp,sp,-80
    800015e2:	e486                	sd	ra,72(sp)
    800015e4:	e0a2                	sd	s0,64(sp)
    800015e6:	fc26                	sd	s1,56(sp)
    800015e8:	f84a                	sd	s2,48(sp)
    800015ea:	f44e                	sd	s3,40(sp)
    800015ec:	f052                	sd	s4,32(sp)
    800015ee:	ec56                	sd	s5,24(sp)
    800015f0:	e85a                	sd	s6,16(sp)
    800015f2:	e45e                	sd	s7,8(sp)
    800015f4:	e062                	sd	s8,0(sp)
    800015f6:	0880                	addi	s0,sp,80
    800015f8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015fa:	faeff0ef          	jal	80000da8 <myproc>
    800015fe:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001600:	00009517          	auipc	a0,0x9
    80001604:	e9850513          	addi	a0,a0,-360 # 8000a498 <wait_lock>
    80001608:	248040ef          	jal	80005850 <acquire>
    havekids = 0;
    8000160c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000160e:	4a15                	li	s4,5
        havekids = 1;
    80001610:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001612:	0000f997          	auipc	s3,0xf
    80001616:	c9e98993          	addi	s3,s3,-866 # 800102b0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000161a:	00009c17          	auipc	s8,0x9
    8000161e:	e7ec0c13          	addi	s8,s8,-386 # 8000a498 <wait_lock>
    80001622:	a871                	j	800016be <wait+0xde>
          pid = pp->pid;
    80001624:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001628:	000b0c63          	beqz	s6,80001640 <wait+0x60>
    8000162c:	4691                	li	a3,4
    8000162e:	02c48613          	addi	a2,s1,44
    80001632:	85da                	mv	a1,s6
    80001634:	05093503          	ld	a0,80(s2)
    80001638:	be2ff0ef          	jal	80000a1a <copyout>
    8000163c:	02054b63          	bltz	a0,80001672 <wait+0x92>
          freeproc(pp);
    80001640:	8526                	mv	a0,s1
    80001642:	8d9ff0ef          	jal	80000f1a <freeproc>
          release(&pp->lock);
    80001646:	8526                	mv	a0,s1
    80001648:	2a0040ef          	jal	800058e8 <release>
          release(&wait_lock);
    8000164c:	00009517          	auipc	a0,0x9
    80001650:	e4c50513          	addi	a0,a0,-436 # 8000a498 <wait_lock>
    80001654:	294040ef          	jal	800058e8 <release>
}
    80001658:	854e                	mv	a0,s3
    8000165a:	60a6                	ld	ra,72(sp)
    8000165c:	6406                	ld	s0,64(sp)
    8000165e:	74e2                	ld	s1,56(sp)
    80001660:	7942                	ld	s2,48(sp)
    80001662:	79a2                	ld	s3,40(sp)
    80001664:	7a02                	ld	s4,32(sp)
    80001666:	6ae2                	ld	s5,24(sp)
    80001668:	6b42                	ld	s6,16(sp)
    8000166a:	6ba2                	ld	s7,8(sp)
    8000166c:	6c02                	ld	s8,0(sp)
    8000166e:	6161                	addi	sp,sp,80
    80001670:	8082                	ret
            release(&pp->lock);
    80001672:	8526                	mv	a0,s1
    80001674:	274040ef          	jal	800058e8 <release>
            release(&wait_lock);
    80001678:	00009517          	auipc	a0,0x9
    8000167c:	e2050513          	addi	a0,a0,-480 # 8000a498 <wait_lock>
    80001680:	268040ef          	jal	800058e8 <release>
            return -1;
    80001684:	59fd                	li	s3,-1
    80001686:	bfc9                	j	80001658 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001688:	16848493          	addi	s1,s1,360
    8000168c:	03348063          	beq	s1,s3,800016ac <wait+0xcc>
      if(pp->parent == p){
    80001690:	7c9c                	ld	a5,56(s1)
    80001692:	ff279be3          	bne	a5,s2,80001688 <wait+0xa8>
        acquire(&pp->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	1b8040ef          	jal	80005850 <acquire>
        if(pp->state == ZOMBIE){
    8000169c:	4c9c                	lw	a5,24(s1)
    8000169e:	f94783e3          	beq	a5,s4,80001624 <wait+0x44>
        release(&pp->lock);
    800016a2:	8526                	mv	a0,s1
    800016a4:	244040ef          	jal	800058e8 <release>
        havekids = 1;
    800016a8:	8756                	mv	a4,s5
    800016aa:	bff9                	j	80001688 <wait+0xa8>
    if(!havekids || killed(p)){
    800016ac:	cf19                	beqz	a4,800016ca <wait+0xea>
    800016ae:	854a                	mv	a0,s2
    800016b0:	f07ff0ef          	jal	800015b6 <killed>
    800016b4:	e919                	bnez	a0,800016ca <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016b6:	85e2                	mv	a1,s8
    800016b8:	854a                	mv	a0,s2
    800016ba:	cc5ff0ef          	jal	8000137e <sleep>
    havekids = 0;
    800016be:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016c0:	00009497          	auipc	s1,0x9
    800016c4:	1f048493          	addi	s1,s1,496 # 8000a8b0 <proc>
    800016c8:	b7e1                	j	80001690 <wait+0xb0>
      release(&wait_lock);
    800016ca:	00009517          	auipc	a0,0x9
    800016ce:	dce50513          	addi	a0,a0,-562 # 8000a498 <wait_lock>
    800016d2:	216040ef          	jal	800058e8 <release>
      return -1;
    800016d6:	59fd                	li	s3,-1
    800016d8:	b741                	j	80001658 <wait+0x78>

00000000800016da <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016da:	7179                	addi	sp,sp,-48
    800016dc:	f406                	sd	ra,40(sp)
    800016de:	f022                	sd	s0,32(sp)
    800016e0:	ec26                	sd	s1,24(sp)
    800016e2:	e84a                	sd	s2,16(sp)
    800016e4:	e44e                	sd	s3,8(sp)
    800016e6:	e052                	sd	s4,0(sp)
    800016e8:	1800                	addi	s0,sp,48
    800016ea:	84aa                	mv	s1,a0
    800016ec:	892e                	mv	s2,a1
    800016ee:	89b2                	mv	s3,a2
    800016f0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016f2:	eb6ff0ef          	jal	80000da8 <myproc>
  if(user_dst){
    800016f6:	cc99                	beqz	s1,80001714 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016f8:	86d2                	mv	a3,s4
    800016fa:	864e                	mv	a2,s3
    800016fc:	85ca                	mv	a1,s2
    800016fe:	6928                	ld	a0,80(a0)
    80001700:	b1aff0ef          	jal	80000a1a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001704:	70a2                	ld	ra,40(sp)
    80001706:	7402                	ld	s0,32(sp)
    80001708:	64e2                	ld	s1,24(sp)
    8000170a:	6942                	ld	s2,16(sp)
    8000170c:	69a2                	ld	s3,8(sp)
    8000170e:	6a02                	ld	s4,0(sp)
    80001710:	6145                	addi	sp,sp,48
    80001712:	8082                	ret
    memmove((char *)dst, src, len);
    80001714:	000a061b          	sext.w	a2,s4
    80001718:	85ce                	mv	a1,s3
    8000171a:	854a                	mv	a0,s2
    8000171c:	ad1fe0ef          	jal	800001ec <memmove>
    return 0;
    80001720:	8526                	mv	a0,s1
    80001722:	b7cd                	j	80001704 <either_copyout+0x2a>

0000000080001724 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001724:	7179                	addi	sp,sp,-48
    80001726:	f406                	sd	ra,40(sp)
    80001728:	f022                	sd	s0,32(sp)
    8000172a:	ec26                	sd	s1,24(sp)
    8000172c:	e84a                	sd	s2,16(sp)
    8000172e:	e44e                	sd	s3,8(sp)
    80001730:	e052                	sd	s4,0(sp)
    80001732:	1800                	addi	s0,sp,48
    80001734:	892a                	mv	s2,a0
    80001736:	84ae                	mv	s1,a1
    80001738:	89b2                	mv	s3,a2
    8000173a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000173c:	e6cff0ef          	jal	80000da8 <myproc>
  if(user_src){
    80001740:	cc99                	beqz	s1,8000175e <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001742:	86d2                	mv	a3,s4
    80001744:	864e                	mv	a2,s3
    80001746:	85ca                	mv	a1,s2
    80001748:	6928                	ld	a0,80(a0)
    8000174a:	ba6ff0ef          	jal	80000af0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000174e:	70a2                	ld	ra,40(sp)
    80001750:	7402                	ld	s0,32(sp)
    80001752:	64e2                	ld	s1,24(sp)
    80001754:	6942                	ld	s2,16(sp)
    80001756:	69a2                	ld	s3,8(sp)
    80001758:	6a02                	ld	s4,0(sp)
    8000175a:	6145                	addi	sp,sp,48
    8000175c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000175e:	000a061b          	sext.w	a2,s4
    80001762:	85ce                	mv	a1,s3
    80001764:	854a                	mv	a0,s2
    80001766:	a87fe0ef          	jal	800001ec <memmove>
    return 0;
    8000176a:	8526                	mv	a0,s1
    8000176c:	b7cd                	j	8000174e <either_copyin+0x2a>

000000008000176e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000176e:	715d                	addi	sp,sp,-80
    80001770:	e486                	sd	ra,72(sp)
    80001772:	e0a2                	sd	s0,64(sp)
    80001774:	fc26                	sd	s1,56(sp)
    80001776:	f84a                	sd	s2,48(sp)
    80001778:	f44e                	sd	s3,40(sp)
    8000177a:	f052                	sd	s4,32(sp)
    8000177c:	ec56                	sd	s5,24(sp)
    8000177e:	e85a                	sd	s6,16(sp)
    80001780:	e45e                	sd	s7,8(sp)
    80001782:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001784:	00006517          	auipc	a0,0x6
    80001788:	89450513          	addi	a0,a0,-1900 # 80007018 <etext+0x18>
    8000178c:	2c5030ef          	jal	80005250 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001790:	00009497          	auipc	s1,0x9
    80001794:	27848493          	addi	s1,s1,632 # 8000aa08 <proc+0x158>
    80001798:	0000f917          	auipc	s2,0xf
    8000179c:	c7090913          	addi	s2,s2,-912 # 80010408 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017a0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017a2:	00006997          	auipc	s3,0x6
    800017a6:	a9e98993          	addi	s3,s3,-1378 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    800017aa:	00006a97          	auipc	s5,0x6
    800017ae:	a9ea8a93          	addi	s5,s5,-1378 # 80007248 <etext+0x248>
    printf("\n");
    800017b2:	00006a17          	auipc	s4,0x6
    800017b6:	866a0a13          	addi	s4,s4,-1946 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ba:	00006b97          	auipc	s7,0x6
    800017be:	076b8b93          	addi	s7,s7,118 # 80007830 <states.0>
    800017c2:	a829                	j	800017dc <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017c4:	ed86a583          	lw	a1,-296(a3)
    800017c8:	8556                	mv	a0,s5
    800017ca:	287030ef          	jal	80005250 <printf>
    printf("\n");
    800017ce:	8552                	mv	a0,s4
    800017d0:	281030ef          	jal	80005250 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017d4:	16848493          	addi	s1,s1,360
    800017d8:	03248263          	beq	s1,s2,800017fc <procdump+0x8e>
    if(p->state == UNUSED)
    800017dc:	86a6                	mv	a3,s1
    800017de:	ec04a783          	lw	a5,-320(s1)
    800017e2:	dbed                	beqz	a5,800017d4 <procdump+0x66>
      state = "???";
    800017e4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017e6:	fcfb6fe3          	bltu	s6,a5,800017c4 <procdump+0x56>
    800017ea:	02079713          	slli	a4,a5,0x20
    800017ee:	01d75793          	srli	a5,a4,0x1d
    800017f2:	97de                	add	a5,a5,s7
    800017f4:	6390                	ld	a2,0(a5)
    800017f6:	f679                	bnez	a2,800017c4 <procdump+0x56>
      state = "???";
    800017f8:	864e                	mv	a2,s3
    800017fa:	b7e9                	j	800017c4 <procdump+0x56>
  }
}
    800017fc:	60a6                	ld	ra,72(sp)
    800017fe:	6406                	ld	s0,64(sp)
    80001800:	74e2                	ld	s1,56(sp)
    80001802:	7942                	ld	s2,48(sp)
    80001804:	79a2                	ld	s3,40(sp)
    80001806:	7a02                	ld	s4,32(sp)
    80001808:	6ae2                	ld	s5,24(sp)
    8000180a:	6b42                	ld	s6,16(sp)
    8000180c:	6ba2                	ld	s7,8(sp)
    8000180e:	6161                	addi	sp,sp,80
    80001810:	8082                	ret

0000000080001812 <getnproc>:

uint64
getnproc(void)
{
    80001812:	7179                	addi	sp,sp,-48
    80001814:	f406                	sd	ra,40(sp)
    80001816:	f022                	sd	s0,32(sp)
    80001818:	ec26                	sd	s1,24(sp)
    8000181a:	e84a                	sd	s2,16(sp)
    8000181c:	e44e                	sd	s3,8(sp)
    8000181e:	1800                	addi	s0,sp,48
  struct proc* p;
  uint64 nproc = 0;
    80001820:	4901                	li	s2,0

  for(p = proc; p < &proc[NPROC]; p++){
    80001822:	00009497          	auipc	s1,0x9
    80001826:	08e48493          	addi	s1,s1,142 # 8000a8b0 <proc>
    8000182a:	0000f997          	auipc	s3,0xf
    8000182e:	a8698993          	addi	s3,s3,-1402 # 800102b0 <tickslock>
    acquire(&p->lock);
    80001832:	8526                	mv	a0,s1
    80001834:	01c040ef          	jal	80005850 <acquire>
    if(p->state != UNUSED){
    80001838:	4c9c                	lw	a5,24(s1)
      nproc++;
    8000183a:	00f037b3          	snez	a5,a5
    8000183e:	993e                	add	s2,s2,a5
    }
    release(&p->lock);
    80001840:	8526                	mv	a0,s1
    80001842:	0a6040ef          	jal	800058e8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001846:	16848493          	addi	s1,s1,360
    8000184a:	ff3494e3          	bne	s1,s3,80001832 <getnproc+0x20>
  }

  return nproc;
}
    8000184e:	854a                	mv	a0,s2
    80001850:	70a2                	ld	ra,40(sp)
    80001852:	7402                	ld	s0,32(sp)
    80001854:	64e2                	ld	s1,24(sp)
    80001856:	6942                	ld	s2,16(sp)
    80001858:	69a2                	ld	s3,8(sp)
    8000185a:	6145                	addi	sp,sp,48
    8000185c:	8082                	ret

000000008000185e <swtch>:
    8000185e:	00153023          	sd	ra,0(a0)
    80001862:	00253423          	sd	sp,8(a0)
    80001866:	e900                	sd	s0,16(a0)
    80001868:	ed04                	sd	s1,24(a0)
    8000186a:	03253023          	sd	s2,32(a0)
    8000186e:	03353423          	sd	s3,40(a0)
    80001872:	03453823          	sd	s4,48(a0)
    80001876:	03553c23          	sd	s5,56(a0)
    8000187a:	05653023          	sd	s6,64(a0)
    8000187e:	05753423          	sd	s7,72(a0)
    80001882:	05853823          	sd	s8,80(a0)
    80001886:	05953c23          	sd	s9,88(a0)
    8000188a:	07a53023          	sd	s10,96(a0)
    8000188e:	07b53423          	sd	s11,104(a0)
    80001892:	0005b083          	ld	ra,0(a1)
    80001896:	0085b103          	ld	sp,8(a1)
    8000189a:	6980                	ld	s0,16(a1)
    8000189c:	6d84                	ld	s1,24(a1)
    8000189e:	0205b903          	ld	s2,32(a1)
    800018a2:	0285b983          	ld	s3,40(a1)
    800018a6:	0305ba03          	ld	s4,48(a1)
    800018aa:	0385ba83          	ld	s5,56(a1)
    800018ae:	0405bb03          	ld	s6,64(a1)
    800018b2:	0485bb83          	ld	s7,72(a1)
    800018b6:	0505bc03          	ld	s8,80(a1)
    800018ba:	0585bc83          	ld	s9,88(a1)
    800018be:	0605bd03          	ld	s10,96(a1)
    800018c2:	0685bd83          	ld	s11,104(a1)
    800018c6:	8082                	ret

00000000800018c8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018c8:	1141                	addi	sp,sp,-16
    800018ca:	e406                	sd	ra,8(sp)
    800018cc:	e022                	sd	s0,0(sp)
    800018ce:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018d0:	00006597          	auipc	a1,0x6
    800018d4:	9b858593          	addi	a1,a1,-1608 # 80007288 <etext+0x288>
    800018d8:	0000f517          	auipc	a0,0xf
    800018dc:	9d850513          	addi	a0,a0,-1576 # 800102b0 <tickslock>
    800018e0:	6f1030ef          	jal	800057d0 <initlock>
}
    800018e4:	60a2                	ld	ra,8(sp)
    800018e6:	6402                	ld	s0,0(sp)
    800018e8:	0141                	addi	sp,sp,16
    800018ea:	8082                	ret

00000000800018ec <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018ec:	1141                	addi	sp,sp,-16
    800018ee:	e422                	sd	s0,8(sp)
    800018f0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018f2:	00003797          	auipc	a5,0x3
    800018f6:	e9e78793          	addi	a5,a5,-354 # 80004790 <kernelvec>
    800018fa:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018fe:	6422                	ld	s0,8(sp)
    80001900:	0141                	addi	sp,sp,16
    80001902:	8082                	ret

0000000080001904 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001904:	1141                	addi	sp,sp,-16
    80001906:	e406                	sd	ra,8(sp)
    80001908:	e022                	sd	s0,0(sp)
    8000190a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000190c:	c9cff0ef          	jal	80000da8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001910:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001914:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001916:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000191a:	00004697          	auipc	a3,0x4
    8000191e:	6e668693          	addi	a3,a3,1766 # 80006000 <_trampoline>
    80001922:	00004717          	auipc	a4,0x4
    80001926:	6de70713          	addi	a4,a4,1758 # 80006000 <_trampoline>
    8000192a:	8f15                	sub	a4,a4,a3
    8000192c:	040007b7          	lui	a5,0x4000
    80001930:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001932:	07b2                	slli	a5,a5,0xc
    80001934:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001936:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000193a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000193c:	18002673          	csrr	a2,satp
    80001940:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001942:	6d30                	ld	a2,88(a0)
    80001944:	6138                	ld	a4,64(a0)
    80001946:	6585                	lui	a1,0x1
    80001948:	972e                	add	a4,a4,a1
    8000194a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000194c:	6d38                	ld	a4,88(a0)
    8000194e:	00000617          	auipc	a2,0x0
    80001952:	11060613          	addi	a2,a2,272 # 80001a5e <usertrap>
    80001956:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001958:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000195a:	8612                	mv	a2,tp
    8000195c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000195e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001962:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001966:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000196a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000196e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001970:	6f18                	ld	a4,24(a4)
    80001972:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001976:	6928                	ld	a0,80(a0)
    80001978:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000197a:	00004717          	auipc	a4,0x4
    8000197e:	72270713          	addi	a4,a4,1826 # 8000609c <userret>
    80001982:	8f15                	sub	a4,a4,a3
    80001984:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001986:	577d                	li	a4,-1
    80001988:	177e                	slli	a4,a4,0x3f
    8000198a:	8d59                	or	a0,a0,a4
    8000198c:	9782                	jalr	a5
}
    8000198e:	60a2                	ld	ra,8(sp)
    80001990:	6402                	ld	s0,0(sp)
    80001992:	0141                	addi	sp,sp,16
    80001994:	8082                	ret

0000000080001996 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001996:	1101                	addi	sp,sp,-32
    80001998:	ec06                	sd	ra,24(sp)
    8000199a:	e822                	sd	s0,16(sp)
    8000199c:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000199e:	bdeff0ef          	jal	80000d7c <cpuid>
    800019a2:	cd11                	beqz	a0,800019be <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800019a4:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800019a8:	000f4737          	lui	a4,0xf4
    800019ac:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800019b0:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800019b2:	14d79073          	csrw	stimecmp,a5
}
    800019b6:	60e2                	ld	ra,24(sp)
    800019b8:	6442                	ld	s0,16(sp)
    800019ba:	6105                	addi	sp,sp,32
    800019bc:	8082                	ret
    800019be:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800019c0:	0000f497          	auipc	s1,0xf
    800019c4:	8f048493          	addi	s1,s1,-1808 # 800102b0 <tickslock>
    800019c8:	8526                	mv	a0,s1
    800019ca:	687030ef          	jal	80005850 <acquire>
    ticks++;
    800019ce:	00009517          	auipc	a0,0x9
    800019d2:	a7a50513          	addi	a0,a0,-1414 # 8000a448 <ticks>
    800019d6:	411c                	lw	a5,0(a0)
    800019d8:	2785                	addiw	a5,a5,1
    800019da:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019dc:	9efff0ef          	jal	800013ca <wakeup>
    release(&tickslock);
    800019e0:	8526                	mv	a0,s1
    800019e2:	707030ef          	jal	800058e8 <release>
    800019e6:	64a2                	ld	s1,8(sp)
    800019e8:	bf75                	j	800019a4 <clockintr+0xe>

00000000800019ea <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019ea:	1101                	addi	sp,sp,-32
    800019ec:	ec06                	sd	ra,24(sp)
    800019ee:	e822                	sd	s0,16(sp)
    800019f0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019f2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019f6:	57fd                	li	a5,-1
    800019f8:	17fe                	slli	a5,a5,0x3f
    800019fa:	07a5                	addi	a5,a5,9
    800019fc:	00f70c63          	beq	a4,a5,80001a14 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a00:	57fd                	li	a5,-1
    80001a02:	17fe                	slli	a5,a5,0x3f
    80001a04:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a06:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a08:	04f70763          	beq	a4,a5,80001a56 <devintr+0x6c>
  }
}
    80001a0c:	60e2                	ld	ra,24(sp)
    80001a0e:	6442                	ld	s0,16(sp)
    80001a10:	6105                	addi	sp,sp,32
    80001a12:	8082                	ret
    80001a14:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a16:	627020ef          	jal	8000483c <plic_claim>
    80001a1a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a1c:	47a9                	li	a5,10
    80001a1e:	00f50963          	beq	a0,a5,80001a30 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001a22:	4785                	li	a5,1
    80001a24:	00f50963          	beq	a0,a5,80001a36 <devintr+0x4c>
    return 1;
    80001a28:	4505                	li	a0,1
    } else if(irq){
    80001a2a:	e889                	bnez	s1,80001a3c <devintr+0x52>
    80001a2c:	64a2                	ld	s1,8(sp)
    80001a2e:	bff9                	j	80001a0c <devintr+0x22>
      uartintr();
    80001a30:	565030ef          	jal	80005794 <uartintr>
    if(irq)
    80001a34:	a819                	j	80001a4a <devintr+0x60>
      virtio_disk_intr();
    80001a36:	2cc030ef          	jal	80004d02 <virtio_disk_intr>
    if(irq)
    80001a3a:	a801                	j	80001a4a <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a3c:	85a6                	mv	a1,s1
    80001a3e:	00006517          	auipc	a0,0x6
    80001a42:	85250513          	addi	a0,a0,-1966 # 80007290 <etext+0x290>
    80001a46:	00b030ef          	jal	80005250 <printf>
      plic_complete(irq);
    80001a4a:	8526                	mv	a0,s1
    80001a4c:	611020ef          	jal	8000485c <plic_complete>
    return 1;
    80001a50:	4505                	li	a0,1
    80001a52:	64a2                	ld	s1,8(sp)
    80001a54:	bf65                	j	80001a0c <devintr+0x22>
    clockintr();
    80001a56:	f41ff0ef          	jal	80001996 <clockintr>
    return 2;
    80001a5a:	4509                	li	a0,2
    80001a5c:	bf45                	j	80001a0c <devintr+0x22>

0000000080001a5e <usertrap>:
{
    80001a5e:	1101                	addi	sp,sp,-32
    80001a60:	ec06                	sd	ra,24(sp)
    80001a62:	e822                	sd	s0,16(sp)
    80001a64:	e426                	sd	s1,8(sp)
    80001a66:	e04a                	sd	s2,0(sp)
    80001a68:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a6a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a6e:	1007f793          	andi	a5,a5,256
    80001a72:	ef85                	bnez	a5,80001aaa <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a74:	00003797          	auipc	a5,0x3
    80001a78:	d1c78793          	addi	a5,a5,-740 # 80004790 <kernelvec>
    80001a7c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a80:	b28ff0ef          	jal	80000da8 <myproc>
    80001a84:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a86:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a88:	14102773          	csrr	a4,sepc
    80001a8c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a8e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a92:	47a1                	li	a5,8
    80001a94:	02f70163          	beq	a4,a5,80001ab6 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a98:	f53ff0ef          	jal	800019ea <devintr>
    80001a9c:	892a                	mv	s2,a0
    80001a9e:	c135                	beqz	a0,80001b02 <usertrap+0xa4>
  if(killed(p))
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	b15ff0ef          	jal	800015b6 <killed>
    80001aa6:	cd1d                	beqz	a0,80001ae4 <usertrap+0x86>
    80001aa8:	a81d                	j	80001ade <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001aaa:	00006517          	auipc	a0,0x6
    80001aae:	80650513          	addi	a0,a0,-2042 # 800072b0 <etext+0x2b0>
    80001ab2:	271030ef          	jal	80005522 <panic>
    if(killed(p))
    80001ab6:	b01ff0ef          	jal	800015b6 <killed>
    80001aba:	e121                	bnez	a0,80001afa <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001abc:	6cb8                	ld	a4,88(s1)
    80001abe:	6f1c                	ld	a5,24(a4)
    80001ac0:	0791                	addi	a5,a5,4
    80001ac2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ac8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001acc:	10079073          	csrw	sstatus,a5
    syscall();
    80001ad0:	248000ef          	jal	80001d18 <syscall>
  if(killed(p))
    80001ad4:	8526                	mv	a0,s1
    80001ad6:	ae1ff0ef          	jal	800015b6 <killed>
    80001ada:	c901                	beqz	a0,80001aea <usertrap+0x8c>
    80001adc:	4901                	li	s2,0
    exit(-1);
    80001ade:	557d                	li	a0,-1
    80001ae0:	9abff0ef          	jal	8000148a <exit>
  if(which_dev == 2)
    80001ae4:	4789                	li	a5,2
    80001ae6:	04f90563          	beq	s2,a5,80001b30 <usertrap+0xd2>
  usertrapret();
    80001aea:	e1bff0ef          	jal	80001904 <usertrapret>
}
    80001aee:	60e2                	ld	ra,24(sp)
    80001af0:	6442                	ld	s0,16(sp)
    80001af2:	64a2                	ld	s1,8(sp)
    80001af4:	6902                	ld	s2,0(sp)
    80001af6:	6105                	addi	sp,sp,32
    80001af8:	8082                	ret
      exit(-1);
    80001afa:	557d                	li	a0,-1
    80001afc:	98fff0ef          	jal	8000148a <exit>
    80001b00:	bf75                	j	80001abc <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b02:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b06:	5890                	lw	a2,48(s1)
    80001b08:	00005517          	auipc	a0,0x5
    80001b0c:	7c850513          	addi	a0,a0,1992 # 800072d0 <etext+0x2d0>
    80001b10:	740030ef          	jal	80005250 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b14:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b18:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b1c:	00005517          	auipc	a0,0x5
    80001b20:	7e450513          	addi	a0,a0,2020 # 80007300 <etext+0x300>
    80001b24:	72c030ef          	jal	80005250 <printf>
    setkilled(p);
    80001b28:	8526                	mv	a0,s1
    80001b2a:	a69ff0ef          	jal	80001592 <setkilled>
    80001b2e:	b75d                	j	80001ad4 <usertrap+0x76>
    yield();
    80001b30:	823ff0ef          	jal	80001352 <yield>
    80001b34:	bf5d                	j	80001aea <usertrap+0x8c>

0000000080001b36 <kerneltrap>:
{
    80001b36:	7179                	addi	sp,sp,-48
    80001b38:	f406                	sd	ra,40(sp)
    80001b3a:	f022                	sd	s0,32(sp)
    80001b3c:	ec26                	sd	s1,24(sp)
    80001b3e:	e84a                	sd	s2,16(sp)
    80001b40:	e44e                	sd	s3,8(sp)
    80001b42:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b44:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b48:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b4c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b50:	1004f793          	andi	a5,s1,256
    80001b54:	c795                	beqz	a5,80001b80 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b56:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b5a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b5c:	eb85                	bnez	a5,80001b8c <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b5e:	e8dff0ef          	jal	800019ea <devintr>
    80001b62:	c91d                	beqz	a0,80001b98 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b64:	4789                	li	a5,2
    80001b66:	04f50a63          	beq	a0,a5,80001bba <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b6a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6e:	10049073          	csrw	sstatus,s1
}
    80001b72:	70a2                	ld	ra,40(sp)
    80001b74:	7402                	ld	s0,32(sp)
    80001b76:	64e2                	ld	s1,24(sp)
    80001b78:	6942                	ld	s2,16(sp)
    80001b7a:	69a2                	ld	s3,8(sp)
    80001b7c:	6145                	addi	sp,sp,48
    80001b7e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b80:	00005517          	auipc	a0,0x5
    80001b84:	7a850513          	addi	a0,a0,1960 # 80007328 <etext+0x328>
    80001b88:	19b030ef          	jal	80005522 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b8c:	00005517          	auipc	a0,0x5
    80001b90:	7c450513          	addi	a0,a0,1988 # 80007350 <etext+0x350>
    80001b94:	18f030ef          	jal	80005522 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b98:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b9c:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001ba0:	85ce                	mv	a1,s3
    80001ba2:	00005517          	auipc	a0,0x5
    80001ba6:	7ce50513          	addi	a0,a0,1998 # 80007370 <etext+0x370>
    80001baa:	6a6030ef          	jal	80005250 <printf>
    panic("kerneltrap");
    80001bae:	00005517          	auipc	a0,0x5
    80001bb2:	7ea50513          	addi	a0,a0,2026 # 80007398 <etext+0x398>
    80001bb6:	16d030ef          	jal	80005522 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001bba:	9eeff0ef          	jal	80000da8 <myproc>
    80001bbe:	d555                	beqz	a0,80001b6a <kerneltrap+0x34>
    yield();
    80001bc0:	f92ff0ef          	jal	80001352 <yield>
    80001bc4:	b75d                	j	80001b6a <kerneltrap+0x34>

0000000080001bc6 <argraw>:
	return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bc6:	1101                	addi	sp,sp,-32
    80001bc8:	ec06                	sd	ra,24(sp)
    80001bca:	e822                	sd	s0,16(sp)
    80001bcc:	e426                	sd	s1,8(sp)
    80001bce:	1000                	addi	s0,sp,32
    80001bd0:	84aa                	mv	s1,a0
	struct proc* p = myproc();
    80001bd2:	9d6ff0ef          	jal	80000da8 <myproc>
	switch (n) {
    80001bd6:	4795                	li	a5,5
    80001bd8:	0497e163          	bltu	a5,s1,80001c1a <argraw+0x54>
    80001bdc:	048a                	slli	s1,s1,0x2
    80001bde:	00006717          	auipc	a4,0x6
    80001be2:	c8270713          	addi	a4,a4,-894 # 80007860 <states.0+0x30>
    80001be6:	94ba                	add	s1,s1,a4
    80001be8:	409c                	lw	a5,0(s1)
    80001bea:	97ba                	add	a5,a5,a4
    80001bec:	8782                	jr	a5
	case 0:
		return p->trapframe->a0;
    80001bee:	6d3c                	ld	a5,88(a0)
    80001bf0:	7ba8                	ld	a0,112(a5)
	case 5:
		return p->trapframe->a5;
	}
	panic("argraw");
	return -1;
}
    80001bf2:	60e2                	ld	ra,24(sp)
    80001bf4:	6442                	ld	s0,16(sp)
    80001bf6:	64a2                	ld	s1,8(sp)
    80001bf8:	6105                	addi	sp,sp,32
    80001bfa:	8082                	ret
		return p->trapframe->a1;
    80001bfc:	6d3c                	ld	a5,88(a0)
    80001bfe:	7fa8                	ld	a0,120(a5)
    80001c00:	bfcd                	j	80001bf2 <argraw+0x2c>
		return p->trapframe->a2;
    80001c02:	6d3c                	ld	a5,88(a0)
    80001c04:	63c8                	ld	a0,128(a5)
    80001c06:	b7f5                	j	80001bf2 <argraw+0x2c>
		return p->trapframe->a3;
    80001c08:	6d3c                	ld	a5,88(a0)
    80001c0a:	67c8                	ld	a0,136(a5)
    80001c0c:	b7dd                	j	80001bf2 <argraw+0x2c>
		return p->trapframe->a4;
    80001c0e:	6d3c                	ld	a5,88(a0)
    80001c10:	6bc8                	ld	a0,144(a5)
    80001c12:	b7c5                	j	80001bf2 <argraw+0x2c>
		return p->trapframe->a5;
    80001c14:	6d3c                	ld	a5,88(a0)
    80001c16:	6fc8                	ld	a0,152(a5)
    80001c18:	bfe9                	j	80001bf2 <argraw+0x2c>
	panic("argraw");
    80001c1a:	00005517          	auipc	a0,0x5
    80001c1e:	78e50513          	addi	a0,a0,1934 # 800073a8 <etext+0x3a8>
    80001c22:	101030ef          	jal	80005522 <panic>

0000000080001c26 <fetchaddr>:
{
    80001c26:	1101                	addi	sp,sp,-32
    80001c28:	ec06                	sd	ra,24(sp)
    80001c2a:	e822                	sd	s0,16(sp)
    80001c2c:	e426                	sd	s1,8(sp)
    80001c2e:	e04a                	sd	s2,0(sp)
    80001c30:	1000                	addi	s0,sp,32
    80001c32:	84aa                	mv	s1,a0
    80001c34:	892e                	mv	s2,a1
	struct proc* p = myproc();
    80001c36:	972ff0ef          	jal	80000da8 <myproc>
	if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c3a:	653c                	ld	a5,72(a0)
    80001c3c:	02f4f663          	bgeu	s1,a5,80001c68 <fetchaddr+0x42>
    80001c40:	00848713          	addi	a4,s1,8
    80001c44:	02e7e463          	bltu	a5,a4,80001c6c <fetchaddr+0x46>
	if (copyin(p->pagetable, (char*)ip, addr, sizeof(*ip)) != 0)
    80001c48:	46a1                	li	a3,8
    80001c4a:	8626                	mv	a2,s1
    80001c4c:	85ca                	mv	a1,s2
    80001c4e:	6928                	ld	a0,80(a0)
    80001c50:	ea1fe0ef          	jal	80000af0 <copyin>
    80001c54:	00a03533          	snez	a0,a0
    80001c58:	40a00533          	neg	a0,a0
}
    80001c5c:	60e2                	ld	ra,24(sp)
    80001c5e:	6442                	ld	s0,16(sp)
    80001c60:	64a2                	ld	s1,8(sp)
    80001c62:	6902                	ld	s2,0(sp)
    80001c64:	6105                	addi	sp,sp,32
    80001c66:	8082                	ret
		return -1;
    80001c68:	557d                	li	a0,-1
    80001c6a:	bfcd                	j	80001c5c <fetchaddr+0x36>
    80001c6c:	557d                	li	a0,-1
    80001c6e:	b7fd                	j	80001c5c <fetchaddr+0x36>

0000000080001c70 <fetchstr>:
{
    80001c70:	7179                	addi	sp,sp,-48
    80001c72:	f406                	sd	ra,40(sp)
    80001c74:	f022                	sd	s0,32(sp)
    80001c76:	ec26                	sd	s1,24(sp)
    80001c78:	e84a                	sd	s2,16(sp)
    80001c7a:	e44e                	sd	s3,8(sp)
    80001c7c:	1800                	addi	s0,sp,48
    80001c7e:	892a                	mv	s2,a0
    80001c80:	84ae                	mv	s1,a1
    80001c82:	89b2                	mv	s3,a2
	struct proc* p = myproc();
    80001c84:	924ff0ef          	jal	80000da8 <myproc>
	if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c88:	86ce                	mv	a3,s3
    80001c8a:	864a                	mv	a2,s2
    80001c8c:	85a6                	mv	a1,s1
    80001c8e:	6928                	ld	a0,80(a0)
    80001c90:	ee7fe0ef          	jal	80000b76 <copyinstr>
    80001c94:	00054c63          	bltz	a0,80001cac <fetchstr+0x3c>
	return strlen(buf);
    80001c98:	8526                	mv	a0,s1
    80001c9a:	e66fe0ef          	jal	80000300 <strlen>
}
    80001c9e:	70a2                	ld	ra,40(sp)
    80001ca0:	7402                	ld	s0,32(sp)
    80001ca2:	64e2                	ld	s1,24(sp)
    80001ca4:	6942                	ld	s2,16(sp)
    80001ca6:	69a2                	ld	s3,8(sp)
    80001ca8:	6145                	addi	sp,sp,48
    80001caa:	8082                	ret
		return -1;
    80001cac:	557d                	li	a0,-1
    80001cae:	bfc5                	j	80001c9e <fetchstr+0x2e>

0000000080001cb0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int* ip)
{
    80001cb0:	1101                	addi	sp,sp,-32
    80001cb2:	ec06                	sd	ra,24(sp)
    80001cb4:	e822                	sd	s0,16(sp)
    80001cb6:	e426                	sd	s1,8(sp)
    80001cb8:	1000                	addi	s0,sp,32
    80001cba:	84ae                	mv	s1,a1
	*ip = argraw(n);
    80001cbc:	f0bff0ef          	jal	80001bc6 <argraw>
    80001cc0:	c088                	sw	a0,0(s1)
}
    80001cc2:	60e2                	ld	ra,24(sp)
    80001cc4:	6442                	ld	s0,16(sp)
    80001cc6:	64a2                	ld	s1,8(sp)
    80001cc8:	6105                	addi	sp,sp,32
    80001cca:	8082                	ret

0000000080001ccc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64* ip)
{
    80001ccc:	1101                	addi	sp,sp,-32
    80001cce:	ec06                	sd	ra,24(sp)
    80001cd0:	e822                	sd	s0,16(sp)
    80001cd2:	e426                	sd	s1,8(sp)
    80001cd4:	1000                	addi	s0,sp,32
    80001cd6:	84ae                	mv	s1,a1
	*ip = argraw(n);
    80001cd8:	eefff0ef          	jal	80001bc6 <argraw>
    80001cdc:	e088                	sd	a0,0(s1)
}
    80001cde:	60e2                	ld	ra,24(sp)
    80001ce0:	6442                	ld	s0,16(sp)
    80001ce2:	64a2                	ld	s1,8(sp)
    80001ce4:	6105                	addi	sp,sp,32
    80001ce6:	8082                	ret

0000000080001ce8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char* buf, int max)
{
    80001ce8:	7179                	addi	sp,sp,-48
    80001cea:	f406                	sd	ra,40(sp)
    80001cec:	f022                	sd	s0,32(sp)
    80001cee:	ec26                	sd	s1,24(sp)
    80001cf0:	e84a                	sd	s2,16(sp)
    80001cf2:	1800                	addi	s0,sp,48
    80001cf4:	84ae                	mv	s1,a1
    80001cf6:	8932                	mv	s2,a2
	uint64 addr;
	argaddr(n, &addr);
    80001cf8:	fd840593          	addi	a1,s0,-40
    80001cfc:	fd1ff0ef          	jal	80001ccc <argaddr>
	return fetchstr(addr, buf, max);
    80001d00:	864a                	mv	a2,s2
    80001d02:	85a6                	mv	a1,s1
    80001d04:	fd843503          	ld	a0,-40(s0)
    80001d08:	f69ff0ef          	jal	80001c70 <fetchstr>
}
    80001d0c:	70a2                	ld	ra,40(sp)
    80001d0e:	7402                	ld	s0,32(sp)
    80001d10:	64e2                	ld	s1,24(sp)
    80001d12:	6942                	ld	s2,16(sp)
    80001d14:	6145                	addi	sp,sp,48
    80001d16:	8082                	ret

0000000080001d18 <syscall>:

};

void
syscall(void)
{
    80001d18:	1101                	addi	sp,sp,-32
    80001d1a:	ec06                	sd	ra,24(sp)
    80001d1c:	e822                	sd	s0,16(sp)
    80001d1e:	e426                	sd	s1,8(sp)
    80001d20:	e04a                	sd	s2,0(sp)
    80001d22:	1000                	addi	s0,sp,32
  	int num;
  	struct proc* p = myproc();
    80001d24:	884ff0ef          	jal	80000da8 <myproc>
    80001d28:	84aa                	mv	s1,a0

  	num = p->trapframe->a7;
    80001d2a:	6d3c                	ld	a5,88(a0)
    80001d2c:	77dc                	ld	a5,168(a5)
    80001d2e:	0007891b          	sext.w	s2,a5
  	int ret = -1;
  	if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d32:	37fd                	addiw	a5,a5,-1
    80001d34:	4759                	li	a4,22
    80001d36:	04f76463          	bltu	a4,a5,80001d7e <syscall+0x66>
    80001d3a:	00391713          	slli	a4,s2,0x3
    80001d3e:	00006797          	auipc	a5,0x6
    80001d42:	b3a78793          	addi	a5,a5,-1222 # 80007878 <syscalls>
    80001d46:	97ba                	add	a5,a5,a4
    80001d48:	639c                	ld	a5,0(a5)
    80001d4a:	cb95                	beqz	a5,80001d7e <syscall+0x66>
	  // Use num to lookup the system call function for num, call it,
	  // and store its return value in p->trapframe->a0
		ret = syscalls[num]();
    80001d4c:	9782                	jalr	a5
    80001d4e:	0005069b          	sext.w	a3,a0
		p->trapframe->a0 = ret;
    80001d52:	6cbc                	ld	a5,88(s1)
    80001d54:	fbb4                	sd	a3,112(a5)

		if (p->tracemask & (1 << num)) {
    80001d56:	58dc                	lw	a5,52(s1)
    80001d58:	4127d7bb          	sraw	a5,a5,s2
    80001d5c:	8b85                	andi	a5,a5,1
    80001d5e:	cf8d                	beqz	a5,80001d98 <syscall+0x80>
			printf("%d : syscall %s -> %d\n",
    80001d60:	090e                	slli	s2,s2,0x3
    80001d62:	00006797          	auipc	a5,0x6
    80001d66:	b1678793          	addi	a5,a5,-1258 # 80007878 <syscalls>
    80001d6a:	97ca                	add	a5,a5,s2
    80001d6c:	63f0                	ld	a2,192(a5)
    80001d6e:	588c                	lw	a1,48(s1)
    80001d70:	00005517          	auipc	a0,0x5
    80001d74:	64050513          	addi	a0,a0,1600 # 800073b0 <etext+0x3b0>
    80001d78:	4d8030ef          	jal	80005250 <printf>
    80001d7c:	a831                	j	80001d98 <syscall+0x80>
				p->pid, syscall_names[num], ret);
		}
		}
	else {
	printf("%d %s: unknown sys call %d\n",
    80001d7e:	86ca                	mv	a3,s2
    80001d80:	15848613          	addi	a2,s1,344
    80001d84:	588c                	lw	a1,48(s1)
    80001d86:	00005517          	auipc	a0,0x5
    80001d8a:	64250513          	addi	a0,a0,1602 # 800073c8 <etext+0x3c8>
    80001d8e:	4c2030ef          	jal	80005250 <printf>
			p->pid, p->name, num);
	p->trapframe->a0 = -1;
    80001d92:	6cbc                	ld	a5,88(s1)
    80001d94:	577d                	li	a4,-1
    80001d96:	fbb8                	sd	a4,112(a5)
	}
}
    80001d98:	60e2                	ld	ra,24(sp)
    80001d9a:	6442                	ld	s0,16(sp)
    80001d9c:	64a2                	ld	s1,8(sp)
    80001d9e:	6902                	ld	s2,0(sp)
    80001da0:	6105                	addi	sp,sp,32
    80001da2:	8082                	ret

0000000080001da4 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80001da4:	1101                	addi	sp,sp,-32
    80001da6:	ec06                	sd	ra,24(sp)
    80001da8:	e822                	sd	s0,16(sp)
    80001daa:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001dac:	fec40593          	addi	a1,s0,-20
    80001db0:	4501                	li	a0,0
    80001db2:	effff0ef          	jal	80001cb0 <argint>
  exit(n);
    80001db6:	fec42503          	lw	a0,-20(s0)
    80001dba:	ed0ff0ef          	jal	8000148a <exit>
  return 0;  // not reached
}
    80001dbe:	4501                	li	a0,0
    80001dc0:	60e2                	ld	ra,24(sp)
    80001dc2:	6442                	ld	s0,16(sp)
    80001dc4:	6105                	addi	sp,sp,32
    80001dc6:	8082                	ret

0000000080001dc8 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001dc8:	1141                	addi	sp,sp,-16
    80001dca:	e406                	sd	ra,8(sp)
    80001dcc:	e022                	sd	s0,0(sp)
    80001dce:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001dd0:	fd9fe0ef          	jal	80000da8 <myproc>
}
    80001dd4:	5908                	lw	a0,48(a0)
    80001dd6:	60a2                	ld	ra,8(sp)
    80001dd8:	6402                	ld	s0,0(sp)
    80001dda:	0141                	addi	sp,sp,16
    80001ddc:	8082                	ret

0000000080001dde <sys_fork>:

uint64
sys_fork(void)
{
    80001dde:	1141                	addi	sp,sp,-16
    80001de0:	e406                	sd	ra,8(sp)
    80001de2:	e022                	sd	s0,0(sp)
    80001de4:	0800                	addi	s0,sp,16
  return fork();
    80001de6:	ae8ff0ef          	jal	800010ce <fork>
}
    80001dea:	60a2                	ld	ra,8(sp)
    80001dec:	6402                	ld	s0,0(sp)
    80001dee:	0141                	addi	sp,sp,16
    80001df0:	8082                	ret

0000000080001df2 <sys_wait>:

uint64
sys_wait(void)
{
    80001df2:	1101                	addi	sp,sp,-32
    80001df4:	ec06                	sd	ra,24(sp)
    80001df6:	e822                	sd	s0,16(sp)
    80001df8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001dfa:	fe840593          	addi	a1,s0,-24
    80001dfe:	4501                	li	a0,0
    80001e00:	ecdff0ef          	jal	80001ccc <argaddr>
  return wait(p);
    80001e04:	fe843503          	ld	a0,-24(s0)
    80001e08:	fd8ff0ef          	jal	800015e0 <wait>
}
    80001e0c:	60e2                	ld	ra,24(sp)
    80001e0e:	6442                	ld	s0,16(sp)
    80001e10:	6105                	addi	sp,sp,32
    80001e12:	8082                	ret

0000000080001e14 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e14:	7179                	addi	sp,sp,-48
    80001e16:	f406                	sd	ra,40(sp)
    80001e18:	f022                	sd	s0,32(sp)
    80001e1a:	ec26                	sd	s1,24(sp)
    80001e1c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e1e:	fdc40593          	addi	a1,s0,-36
    80001e22:	4501                	li	a0,0
    80001e24:	e8dff0ef          	jal	80001cb0 <argint>
  addr = myproc()->sz;
    80001e28:	f81fe0ef          	jal	80000da8 <myproc>
    80001e2c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e2e:	fdc42503          	lw	a0,-36(s0)
    80001e32:	a4cff0ef          	jal	8000107e <growproc>
    80001e36:	00054863          	bltz	a0,80001e46 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e3a:	8526                	mv	a0,s1
    80001e3c:	70a2                	ld	ra,40(sp)
    80001e3e:	7402                	ld	s0,32(sp)
    80001e40:	64e2                	ld	s1,24(sp)
    80001e42:	6145                	addi	sp,sp,48
    80001e44:	8082                	ret
    return -1;
    80001e46:	54fd                	li	s1,-1
    80001e48:	bfcd                	j	80001e3a <sys_sbrk+0x26>

0000000080001e4a <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e4a:	7139                	addi	sp,sp,-64
    80001e4c:	fc06                	sd	ra,56(sp)
    80001e4e:	f822                	sd	s0,48(sp)
    80001e50:	f04a                	sd	s2,32(sp)
    80001e52:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e54:	fcc40593          	addi	a1,s0,-52
    80001e58:	4501                	li	a0,0
    80001e5a:	e57ff0ef          	jal	80001cb0 <argint>
  if(n < 0)
    80001e5e:	fcc42783          	lw	a5,-52(s0)
    80001e62:	0607c763          	bltz	a5,80001ed0 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e66:	0000e517          	auipc	a0,0xe
    80001e6a:	44a50513          	addi	a0,a0,1098 # 800102b0 <tickslock>
    80001e6e:	1e3030ef          	jal	80005850 <acquire>
  ticks0 = ticks;
    80001e72:	00008917          	auipc	s2,0x8
    80001e76:	5d692903          	lw	s2,1494(s2) # 8000a448 <ticks>
  while(ticks - ticks0 < n){
    80001e7a:	fcc42783          	lw	a5,-52(s0)
    80001e7e:	cf8d                	beqz	a5,80001eb8 <sys_sleep+0x6e>
    80001e80:	f426                	sd	s1,40(sp)
    80001e82:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e84:	0000e997          	auipc	s3,0xe
    80001e88:	42c98993          	addi	s3,s3,1068 # 800102b0 <tickslock>
    80001e8c:	00008497          	auipc	s1,0x8
    80001e90:	5bc48493          	addi	s1,s1,1468 # 8000a448 <ticks>
    if(killed(myproc())){
    80001e94:	f15fe0ef          	jal	80000da8 <myproc>
    80001e98:	f1eff0ef          	jal	800015b6 <killed>
    80001e9c:	ed0d                	bnez	a0,80001ed6 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001e9e:	85ce                	mv	a1,s3
    80001ea0:	8526                	mv	a0,s1
    80001ea2:	cdcff0ef          	jal	8000137e <sleep>
  while(ticks - ticks0 < n){
    80001ea6:	409c                	lw	a5,0(s1)
    80001ea8:	412787bb          	subw	a5,a5,s2
    80001eac:	fcc42703          	lw	a4,-52(s0)
    80001eb0:	fee7e2e3          	bltu	a5,a4,80001e94 <sys_sleep+0x4a>
    80001eb4:	74a2                	ld	s1,40(sp)
    80001eb6:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001eb8:	0000e517          	auipc	a0,0xe
    80001ebc:	3f850513          	addi	a0,a0,1016 # 800102b0 <tickslock>
    80001ec0:	229030ef          	jal	800058e8 <release>
  return 0;
    80001ec4:	4501                	li	a0,0
}
    80001ec6:	70e2                	ld	ra,56(sp)
    80001ec8:	7442                	ld	s0,48(sp)
    80001eca:	7902                	ld	s2,32(sp)
    80001ecc:	6121                	addi	sp,sp,64
    80001ece:	8082                	ret
    n = 0;
    80001ed0:	fc042623          	sw	zero,-52(s0)
    80001ed4:	bf49                	j	80001e66 <sys_sleep+0x1c>
      release(&tickslock);
    80001ed6:	0000e517          	auipc	a0,0xe
    80001eda:	3da50513          	addi	a0,a0,986 # 800102b0 <tickslock>
    80001ede:	20b030ef          	jal	800058e8 <release>
      return -1;
    80001ee2:	557d                	li	a0,-1
    80001ee4:	74a2                	ld	s1,40(sp)
    80001ee6:	69e2                	ld	s3,24(sp)
    80001ee8:	bff9                	j	80001ec6 <sys_sleep+0x7c>

0000000080001eea <sys_kill>:

uint64
sys_kill(void)
{
    80001eea:	1101                	addi	sp,sp,-32
    80001eec:	ec06                	sd	ra,24(sp)
    80001eee:	e822                	sd	s0,16(sp)
    80001ef0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ef2:	fec40593          	addi	a1,s0,-20
    80001ef6:	4501                	li	a0,0
    80001ef8:	db9ff0ef          	jal	80001cb0 <argint>
  return kill(pid);
    80001efc:	fec42503          	lw	a0,-20(s0)
    80001f00:	e2cff0ef          	jal	8000152c <kill>
}
    80001f04:	60e2                	ld	ra,24(sp)
    80001f06:	6442                	ld	s0,16(sp)
    80001f08:	6105                	addi	sp,sp,32
    80001f0a:	8082                	ret

0000000080001f0c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f0c:	1101                	addi	sp,sp,-32
    80001f0e:	ec06                	sd	ra,24(sp)
    80001f10:	e822                	sd	s0,16(sp)
    80001f12:	e426                	sd	s1,8(sp)
    80001f14:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f16:	0000e517          	auipc	a0,0xe
    80001f1a:	39a50513          	addi	a0,a0,922 # 800102b0 <tickslock>
    80001f1e:	133030ef          	jal	80005850 <acquire>
  xticks = ticks;
    80001f22:	00008497          	auipc	s1,0x8
    80001f26:	5264a483          	lw	s1,1318(s1) # 8000a448 <ticks>
  release(&tickslock);
    80001f2a:	0000e517          	auipc	a0,0xe
    80001f2e:	38650513          	addi	a0,a0,902 # 800102b0 <tickslock>
    80001f32:	1b7030ef          	jal	800058e8 <release>
  return xticks;
}
    80001f36:	02049513          	slli	a0,s1,0x20
    80001f3a:	9101                	srli	a0,a0,0x20
    80001f3c:	60e2                	ld	ra,24(sp)
    80001f3e:	6442                	ld	s0,16(sp)
    80001f40:	64a2                	ld	s1,8(sp)
    80001f42:	6105                	addi	sp,sp,32
    80001f44:	8082                	ret

0000000080001f46 <sys_trace>:

uint64
sys_trace(void)
{
    80001f46:	1101                	addi	sp,sp,-32
    80001f48:	ec06                	sd	ra,24(sp)
    80001f4a:	e822                	sd	s0,16(sp)
    80001f4c:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    80001f4e:	fec40593          	addi	a1,s0,-20
    80001f52:	4501                	li	a0,0
    80001f54:	d5dff0ef          	jal	80001cb0 <argint>
  myproc()->tracemask = mask;
    80001f58:	e51fe0ef          	jal	80000da8 <myproc>
    80001f5c:	fec42783          	lw	a5,-20(s0)
    80001f60:	d95c                	sw	a5,52(a0)
  return 0;
}
    80001f62:	4501                	li	a0,0
    80001f64:	60e2                	ld	ra,24(sp)
    80001f66:	6442                	ld	s0,16(sp)
    80001f68:	6105                	addi	sp,sp,32
    80001f6a:	8082                	ret

0000000080001f6c <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80001f6c:	7179                	addi	sp,sp,-48
    80001f6e:	f406                	sd	ra,40(sp)
    80001f70:	f022                	sd	s0,32(sp)
    80001f72:	1800                	addi	s0,sp,48
  struct sysinfo info;
  uint64 addr;

  argaddr(0, &addr);
    80001f74:	fd840593          	addi	a1,s0,-40
    80001f78:	4501                	li	a0,0
    80001f7a:	d53ff0ef          	jal	80001ccc <argaddr>

  info.freemem = getfreemem();
    80001f7e:	9d0fe0ef          	jal	8000014e <getfreemem>
    80001f82:	fea43023          	sd	a0,-32(s0)
  info.nproc = getnproc();
    80001f86:	88dff0ef          	jal	80001812 <getnproc>
    80001f8a:	fea43423          	sd	a0,-24(s0)

  if(copyout(myproc()->pagetable, addr, (char*)&info, sizeof(info)) < 0){
    80001f8e:	e1bfe0ef          	jal	80000da8 <myproc>
    80001f92:	46c1                	li	a3,16
    80001f94:	fe040613          	addi	a2,s0,-32
    80001f98:	fd843583          	ld	a1,-40(s0)
    80001f9c:	6928                	ld	a0,80(a0)
    80001f9e:	a7dfe0ef          	jal	80000a1a <copyout>
    return -1;
  }

  return 0;
}
    80001fa2:	957d                	srai	a0,a0,0x3f
    80001fa4:	70a2                	ld	ra,40(sp)
    80001fa6:	7402                	ld	s0,32(sp)
    80001fa8:	6145                	addi	sp,sp,48
    80001faa:	8082                	ret

0000000080001fac <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001fac:	7179                	addi	sp,sp,-48
    80001fae:	f406                	sd	ra,40(sp)
    80001fb0:	f022                	sd	s0,32(sp)
    80001fb2:	ec26                	sd	s1,24(sp)
    80001fb4:	e84a                	sd	s2,16(sp)
    80001fb6:	e44e                	sd	s3,8(sp)
    80001fb8:	e052                	sd	s4,0(sp)
    80001fba:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001fbc:	00005597          	auipc	a1,0x5
    80001fc0:	4dc58593          	addi	a1,a1,1244 # 80007498 <etext+0x498>
    80001fc4:	0000e517          	auipc	a0,0xe
    80001fc8:	30450513          	addi	a0,a0,772 # 800102c8 <bcache>
    80001fcc:	005030ef          	jal	800057d0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001fd0:	00016797          	auipc	a5,0x16
    80001fd4:	2f878793          	addi	a5,a5,760 # 800182c8 <bcache+0x8000>
    80001fd8:	00016717          	auipc	a4,0x16
    80001fdc:	55870713          	addi	a4,a4,1368 # 80018530 <bcache+0x8268>
    80001fe0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fe4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fe8:	0000e497          	auipc	s1,0xe
    80001fec:	2f848493          	addi	s1,s1,760 # 800102e0 <bcache+0x18>
    b->next = bcache.head.next;
    80001ff0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001ff2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001ff4:	00005a17          	auipc	s4,0x5
    80001ff8:	4aca0a13          	addi	s4,s4,1196 # 800074a0 <etext+0x4a0>
    b->next = bcache.head.next;
    80001ffc:	2b893783          	ld	a5,696(s2)
    80002000:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002002:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002006:	85d2                	mv	a1,s4
    80002008:	01048513          	addi	a0,s1,16
    8000200c:	248010ef          	jal	80003254 <initsleeplock>
    bcache.head.next->prev = b;
    80002010:	2b893783          	ld	a5,696(s2)
    80002014:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002016:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000201a:	45848493          	addi	s1,s1,1112
    8000201e:	fd349fe3          	bne	s1,s3,80001ffc <binit+0x50>
  }
}
    80002022:	70a2                	ld	ra,40(sp)
    80002024:	7402                	ld	s0,32(sp)
    80002026:	64e2                	ld	s1,24(sp)
    80002028:	6942                	ld	s2,16(sp)
    8000202a:	69a2                	ld	s3,8(sp)
    8000202c:	6a02                	ld	s4,0(sp)
    8000202e:	6145                	addi	sp,sp,48
    80002030:	8082                	ret

0000000080002032 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002032:	7179                	addi	sp,sp,-48
    80002034:	f406                	sd	ra,40(sp)
    80002036:	f022                	sd	s0,32(sp)
    80002038:	ec26                	sd	s1,24(sp)
    8000203a:	e84a                	sd	s2,16(sp)
    8000203c:	e44e                	sd	s3,8(sp)
    8000203e:	1800                	addi	s0,sp,48
    80002040:	892a                	mv	s2,a0
    80002042:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002044:	0000e517          	auipc	a0,0xe
    80002048:	28450513          	addi	a0,a0,644 # 800102c8 <bcache>
    8000204c:	005030ef          	jal	80005850 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002050:	00016497          	auipc	s1,0x16
    80002054:	5304b483          	ld	s1,1328(s1) # 80018580 <bcache+0x82b8>
    80002058:	00016797          	auipc	a5,0x16
    8000205c:	4d878793          	addi	a5,a5,1240 # 80018530 <bcache+0x8268>
    80002060:	02f48b63          	beq	s1,a5,80002096 <bread+0x64>
    80002064:	873e                	mv	a4,a5
    80002066:	a021                	j	8000206e <bread+0x3c>
    80002068:	68a4                	ld	s1,80(s1)
    8000206a:	02e48663          	beq	s1,a4,80002096 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000206e:	449c                	lw	a5,8(s1)
    80002070:	ff279ce3          	bne	a5,s2,80002068 <bread+0x36>
    80002074:	44dc                	lw	a5,12(s1)
    80002076:	ff3799e3          	bne	a5,s3,80002068 <bread+0x36>
      b->refcnt++;
    8000207a:	40bc                	lw	a5,64(s1)
    8000207c:	2785                	addiw	a5,a5,1
    8000207e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002080:	0000e517          	auipc	a0,0xe
    80002084:	24850513          	addi	a0,a0,584 # 800102c8 <bcache>
    80002088:	061030ef          	jal	800058e8 <release>
      acquiresleep(&b->lock);
    8000208c:	01048513          	addi	a0,s1,16
    80002090:	1fa010ef          	jal	8000328a <acquiresleep>
      return b;
    80002094:	a889                	j	800020e6 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002096:	00016497          	auipc	s1,0x16
    8000209a:	4e24b483          	ld	s1,1250(s1) # 80018578 <bcache+0x82b0>
    8000209e:	00016797          	auipc	a5,0x16
    800020a2:	49278793          	addi	a5,a5,1170 # 80018530 <bcache+0x8268>
    800020a6:	00f48863          	beq	s1,a5,800020b6 <bread+0x84>
    800020aa:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800020ac:	40bc                	lw	a5,64(s1)
    800020ae:	cb91                	beqz	a5,800020c2 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020b0:	64a4                	ld	s1,72(s1)
    800020b2:	fee49de3          	bne	s1,a4,800020ac <bread+0x7a>
  panic("bget: no buffers");
    800020b6:	00005517          	auipc	a0,0x5
    800020ba:	3f250513          	addi	a0,a0,1010 # 800074a8 <etext+0x4a8>
    800020be:	464030ef          	jal	80005522 <panic>
      b->dev = dev;
    800020c2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020c6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020ca:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020ce:	4785                	li	a5,1
    800020d0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020d2:	0000e517          	auipc	a0,0xe
    800020d6:	1f650513          	addi	a0,a0,502 # 800102c8 <bcache>
    800020da:	00f030ef          	jal	800058e8 <release>
      acquiresleep(&b->lock);
    800020de:	01048513          	addi	a0,s1,16
    800020e2:	1a8010ef          	jal	8000328a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020e6:	409c                	lw	a5,0(s1)
    800020e8:	cb89                	beqz	a5,800020fa <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020ea:	8526                	mv	a0,s1
    800020ec:	70a2                	ld	ra,40(sp)
    800020ee:	7402                	ld	s0,32(sp)
    800020f0:	64e2                	ld	s1,24(sp)
    800020f2:	6942                	ld	s2,16(sp)
    800020f4:	69a2                	ld	s3,8(sp)
    800020f6:	6145                	addi	sp,sp,48
    800020f8:	8082                	ret
    virtio_disk_rw(b, 0);
    800020fa:	4581                	li	a1,0
    800020fc:	8526                	mv	a0,s1
    800020fe:	1f3020ef          	jal	80004af0 <virtio_disk_rw>
    b->valid = 1;
    80002102:	4785                	li	a5,1
    80002104:	c09c                	sw	a5,0(s1)
  return b;
    80002106:	b7d5                	j	800020ea <bread+0xb8>

0000000080002108 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002108:	1101                	addi	sp,sp,-32
    8000210a:	ec06                	sd	ra,24(sp)
    8000210c:	e822                	sd	s0,16(sp)
    8000210e:	e426                	sd	s1,8(sp)
    80002110:	1000                	addi	s0,sp,32
    80002112:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002114:	0541                	addi	a0,a0,16
    80002116:	1f2010ef          	jal	80003308 <holdingsleep>
    8000211a:	c911                	beqz	a0,8000212e <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000211c:	4585                	li	a1,1
    8000211e:	8526                	mv	a0,s1
    80002120:	1d1020ef          	jal	80004af0 <virtio_disk_rw>
}
    80002124:	60e2                	ld	ra,24(sp)
    80002126:	6442                	ld	s0,16(sp)
    80002128:	64a2                	ld	s1,8(sp)
    8000212a:	6105                	addi	sp,sp,32
    8000212c:	8082                	ret
    panic("bwrite");
    8000212e:	00005517          	auipc	a0,0x5
    80002132:	39250513          	addi	a0,a0,914 # 800074c0 <etext+0x4c0>
    80002136:	3ec030ef          	jal	80005522 <panic>

000000008000213a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000213a:	1101                	addi	sp,sp,-32
    8000213c:	ec06                	sd	ra,24(sp)
    8000213e:	e822                	sd	s0,16(sp)
    80002140:	e426                	sd	s1,8(sp)
    80002142:	e04a                	sd	s2,0(sp)
    80002144:	1000                	addi	s0,sp,32
    80002146:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002148:	01050913          	addi	s2,a0,16
    8000214c:	854a                	mv	a0,s2
    8000214e:	1ba010ef          	jal	80003308 <holdingsleep>
    80002152:	c135                	beqz	a0,800021b6 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002154:	854a                	mv	a0,s2
    80002156:	17a010ef          	jal	800032d0 <releasesleep>

  acquire(&bcache.lock);
    8000215a:	0000e517          	auipc	a0,0xe
    8000215e:	16e50513          	addi	a0,a0,366 # 800102c8 <bcache>
    80002162:	6ee030ef          	jal	80005850 <acquire>
  b->refcnt--;
    80002166:	40bc                	lw	a5,64(s1)
    80002168:	37fd                	addiw	a5,a5,-1
    8000216a:	0007871b          	sext.w	a4,a5
    8000216e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002170:	e71d                	bnez	a4,8000219e <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002172:	68b8                	ld	a4,80(s1)
    80002174:	64bc                	ld	a5,72(s1)
    80002176:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002178:	68b8                	ld	a4,80(s1)
    8000217a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000217c:	00016797          	auipc	a5,0x16
    80002180:	14c78793          	addi	a5,a5,332 # 800182c8 <bcache+0x8000>
    80002184:	2b87b703          	ld	a4,696(a5)
    80002188:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000218a:	00016717          	auipc	a4,0x16
    8000218e:	3a670713          	addi	a4,a4,934 # 80018530 <bcache+0x8268>
    80002192:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002194:	2b87b703          	ld	a4,696(a5)
    80002198:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000219a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000219e:	0000e517          	auipc	a0,0xe
    800021a2:	12a50513          	addi	a0,a0,298 # 800102c8 <bcache>
    800021a6:	742030ef          	jal	800058e8 <release>
}
    800021aa:	60e2                	ld	ra,24(sp)
    800021ac:	6442                	ld	s0,16(sp)
    800021ae:	64a2                	ld	s1,8(sp)
    800021b0:	6902                	ld	s2,0(sp)
    800021b2:	6105                	addi	sp,sp,32
    800021b4:	8082                	ret
    panic("brelse");
    800021b6:	00005517          	auipc	a0,0x5
    800021ba:	31250513          	addi	a0,a0,786 # 800074c8 <etext+0x4c8>
    800021be:	364030ef          	jal	80005522 <panic>

00000000800021c2 <bpin>:

void
bpin(struct buf *b) {
    800021c2:	1101                	addi	sp,sp,-32
    800021c4:	ec06                	sd	ra,24(sp)
    800021c6:	e822                	sd	s0,16(sp)
    800021c8:	e426                	sd	s1,8(sp)
    800021ca:	1000                	addi	s0,sp,32
    800021cc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021ce:	0000e517          	auipc	a0,0xe
    800021d2:	0fa50513          	addi	a0,a0,250 # 800102c8 <bcache>
    800021d6:	67a030ef          	jal	80005850 <acquire>
  b->refcnt++;
    800021da:	40bc                	lw	a5,64(s1)
    800021dc:	2785                	addiw	a5,a5,1
    800021de:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021e0:	0000e517          	auipc	a0,0xe
    800021e4:	0e850513          	addi	a0,a0,232 # 800102c8 <bcache>
    800021e8:	700030ef          	jal	800058e8 <release>
}
    800021ec:	60e2                	ld	ra,24(sp)
    800021ee:	6442                	ld	s0,16(sp)
    800021f0:	64a2                	ld	s1,8(sp)
    800021f2:	6105                	addi	sp,sp,32
    800021f4:	8082                	ret

00000000800021f6 <bunpin>:

void
bunpin(struct buf *b) {
    800021f6:	1101                	addi	sp,sp,-32
    800021f8:	ec06                	sd	ra,24(sp)
    800021fa:	e822                	sd	s0,16(sp)
    800021fc:	e426                	sd	s1,8(sp)
    800021fe:	1000                	addi	s0,sp,32
    80002200:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002202:	0000e517          	auipc	a0,0xe
    80002206:	0c650513          	addi	a0,a0,198 # 800102c8 <bcache>
    8000220a:	646030ef          	jal	80005850 <acquire>
  b->refcnt--;
    8000220e:	40bc                	lw	a5,64(s1)
    80002210:	37fd                	addiw	a5,a5,-1
    80002212:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002214:	0000e517          	auipc	a0,0xe
    80002218:	0b450513          	addi	a0,a0,180 # 800102c8 <bcache>
    8000221c:	6cc030ef          	jal	800058e8 <release>
}
    80002220:	60e2                	ld	ra,24(sp)
    80002222:	6442                	ld	s0,16(sp)
    80002224:	64a2                	ld	s1,8(sp)
    80002226:	6105                	addi	sp,sp,32
    80002228:	8082                	ret

000000008000222a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000222a:	1101                	addi	sp,sp,-32
    8000222c:	ec06                	sd	ra,24(sp)
    8000222e:	e822                	sd	s0,16(sp)
    80002230:	e426                	sd	s1,8(sp)
    80002232:	e04a                	sd	s2,0(sp)
    80002234:	1000                	addi	s0,sp,32
    80002236:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002238:	00d5d59b          	srliw	a1,a1,0xd
    8000223c:	00016797          	auipc	a5,0x16
    80002240:	7687a783          	lw	a5,1896(a5) # 800189a4 <sb+0x1c>
    80002244:	9dbd                	addw	a1,a1,a5
    80002246:	dedff0ef          	jal	80002032 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000224a:	0074f713          	andi	a4,s1,7
    8000224e:	4785                	li	a5,1
    80002250:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002254:	14ce                	slli	s1,s1,0x33
    80002256:	90d9                	srli	s1,s1,0x36
    80002258:	00950733          	add	a4,a0,s1
    8000225c:	05874703          	lbu	a4,88(a4)
    80002260:	00e7f6b3          	and	a3,a5,a4
    80002264:	c29d                	beqz	a3,8000228a <bfree+0x60>
    80002266:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002268:	94aa                	add	s1,s1,a0
    8000226a:	fff7c793          	not	a5,a5
    8000226e:	8f7d                	and	a4,a4,a5
    80002270:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002274:	711000ef          	jal	80003184 <log_write>
  brelse(bp);
    80002278:	854a                	mv	a0,s2
    8000227a:	ec1ff0ef          	jal	8000213a <brelse>
}
    8000227e:	60e2                	ld	ra,24(sp)
    80002280:	6442                	ld	s0,16(sp)
    80002282:	64a2                	ld	s1,8(sp)
    80002284:	6902                	ld	s2,0(sp)
    80002286:	6105                	addi	sp,sp,32
    80002288:	8082                	ret
    panic("freeing free block");
    8000228a:	00005517          	auipc	a0,0x5
    8000228e:	24650513          	addi	a0,a0,582 # 800074d0 <etext+0x4d0>
    80002292:	290030ef          	jal	80005522 <panic>

0000000080002296 <balloc>:
{
    80002296:	711d                	addi	sp,sp,-96
    80002298:	ec86                	sd	ra,88(sp)
    8000229a:	e8a2                	sd	s0,80(sp)
    8000229c:	e4a6                	sd	s1,72(sp)
    8000229e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800022a0:	00016797          	auipc	a5,0x16
    800022a4:	6ec7a783          	lw	a5,1772(a5) # 8001898c <sb+0x4>
    800022a8:	0e078f63          	beqz	a5,800023a6 <balloc+0x110>
    800022ac:	e0ca                	sd	s2,64(sp)
    800022ae:	fc4e                	sd	s3,56(sp)
    800022b0:	f852                	sd	s4,48(sp)
    800022b2:	f456                	sd	s5,40(sp)
    800022b4:	f05a                	sd	s6,32(sp)
    800022b6:	ec5e                	sd	s7,24(sp)
    800022b8:	e862                	sd	s8,16(sp)
    800022ba:	e466                	sd	s9,8(sp)
    800022bc:	8baa                	mv	s7,a0
    800022be:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022c0:	00016b17          	auipc	s6,0x16
    800022c4:	6c8b0b13          	addi	s6,s6,1736 # 80018988 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022c8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800022ca:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022cc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022ce:	6c89                	lui	s9,0x2
    800022d0:	a0b5                	j	8000233c <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022d2:	97ca                	add	a5,a5,s2
    800022d4:	8e55                	or	a2,a2,a3
    800022d6:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800022da:	854a                	mv	a0,s2
    800022dc:	6a9000ef          	jal	80003184 <log_write>
        brelse(bp);
    800022e0:	854a                	mv	a0,s2
    800022e2:	e59ff0ef          	jal	8000213a <brelse>
  bp = bread(dev, bno);
    800022e6:	85a6                	mv	a1,s1
    800022e8:	855e                	mv	a0,s7
    800022ea:	d49ff0ef          	jal	80002032 <bread>
    800022ee:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022f0:	40000613          	li	a2,1024
    800022f4:	4581                	li	a1,0
    800022f6:	05850513          	addi	a0,a0,88
    800022fa:	e97fd0ef          	jal	80000190 <memset>
  log_write(bp);
    800022fe:	854a                	mv	a0,s2
    80002300:	685000ef          	jal	80003184 <log_write>
  brelse(bp);
    80002304:	854a                	mv	a0,s2
    80002306:	e35ff0ef          	jal	8000213a <brelse>
}
    8000230a:	6906                	ld	s2,64(sp)
    8000230c:	79e2                	ld	s3,56(sp)
    8000230e:	7a42                	ld	s4,48(sp)
    80002310:	7aa2                	ld	s5,40(sp)
    80002312:	7b02                	ld	s6,32(sp)
    80002314:	6be2                	ld	s7,24(sp)
    80002316:	6c42                	ld	s8,16(sp)
    80002318:	6ca2                	ld	s9,8(sp)
}
    8000231a:	8526                	mv	a0,s1
    8000231c:	60e6                	ld	ra,88(sp)
    8000231e:	6446                	ld	s0,80(sp)
    80002320:	64a6                	ld	s1,72(sp)
    80002322:	6125                	addi	sp,sp,96
    80002324:	8082                	ret
    brelse(bp);
    80002326:	854a                	mv	a0,s2
    80002328:	e13ff0ef          	jal	8000213a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000232c:	015c87bb          	addw	a5,s9,s5
    80002330:	00078a9b          	sext.w	s5,a5
    80002334:	004b2703          	lw	a4,4(s6)
    80002338:	04eaff63          	bgeu	s5,a4,80002396 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    8000233c:	41fad79b          	sraiw	a5,s5,0x1f
    80002340:	0137d79b          	srliw	a5,a5,0x13
    80002344:	015787bb          	addw	a5,a5,s5
    80002348:	40d7d79b          	sraiw	a5,a5,0xd
    8000234c:	01cb2583          	lw	a1,28(s6)
    80002350:	9dbd                	addw	a1,a1,a5
    80002352:	855e                	mv	a0,s7
    80002354:	cdfff0ef          	jal	80002032 <bread>
    80002358:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000235a:	004b2503          	lw	a0,4(s6)
    8000235e:	000a849b          	sext.w	s1,s5
    80002362:	8762                	mv	a4,s8
    80002364:	fca4f1e3          	bgeu	s1,a0,80002326 <balloc+0x90>
      m = 1 << (bi % 8);
    80002368:	00777693          	andi	a3,a4,7
    8000236c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002370:	41f7579b          	sraiw	a5,a4,0x1f
    80002374:	01d7d79b          	srliw	a5,a5,0x1d
    80002378:	9fb9                	addw	a5,a5,a4
    8000237a:	4037d79b          	sraiw	a5,a5,0x3
    8000237e:	00f90633          	add	a2,s2,a5
    80002382:	05864603          	lbu	a2,88(a2)
    80002386:	00c6f5b3          	and	a1,a3,a2
    8000238a:	d5a1                	beqz	a1,800022d2 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000238c:	2705                	addiw	a4,a4,1
    8000238e:	2485                	addiw	s1,s1,1
    80002390:	fd471ae3          	bne	a4,s4,80002364 <balloc+0xce>
    80002394:	bf49                	j	80002326 <balloc+0x90>
    80002396:	6906                	ld	s2,64(sp)
    80002398:	79e2                	ld	s3,56(sp)
    8000239a:	7a42                	ld	s4,48(sp)
    8000239c:	7aa2                	ld	s5,40(sp)
    8000239e:	7b02                	ld	s6,32(sp)
    800023a0:	6be2                	ld	s7,24(sp)
    800023a2:	6c42                	ld	s8,16(sp)
    800023a4:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800023a6:	00005517          	auipc	a0,0x5
    800023aa:	14250513          	addi	a0,a0,322 # 800074e8 <etext+0x4e8>
    800023ae:	6a3020ef          	jal	80005250 <printf>
  return 0;
    800023b2:	4481                	li	s1,0
    800023b4:	b79d                	j	8000231a <balloc+0x84>

00000000800023b6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023b6:	7179                	addi	sp,sp,-48
    800023b8:	f406                	sd	ra,40(sp)
    800023ba:	f022                	sd	s0,32(sp)
    800023bc:	ec26                	sd	s1,24(sp)
    800023be:	e84a                	sd	s2,16(sp)
    800023c0:	e44e                	sd	s3,8(sp)
    800023c2:	1800                	addi	s0,sp,48
    800023c4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023c6:	47ad                	li	a5,11
    800023c8:	02b7e663          	bltu	a5,a1,800023f4 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800023cc:	02059793          	slli	a5,a1,0x20
    800023d0:	01e7d593          	srli	a1,a5,0x1e
    800023d4:	00b504b3          	add	s1,a0,a1
    800023d8:	0504a903          	lw	s2,80(s1)
    800023dc:	06091a63          	bnez	s2,80002450 <bmap+0x9a>
      addr = balloc(ip->dev);
    800023e0:	4108                	lw	a0,0(a0)
    800023e2:	eb5ff0ef          	jal	80002296 <balloc>
    800023e6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023ea:	06090363          	beqz	s2,80002450 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800023ee:	0524a823          	sw	s2,80(s1)
    800023f2:	a8b9                	j	80002450 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023f4:	ff45849b          	addiw	s1,a1,-12
    800023f8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800023fc:	0ff00793          	li	a5,255
    80002400:	06e7ee63          	bltu	a5,a4,8000247c <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002404:	08052903          	lw	s2,128(a0)
    80002408:	00091d63          	bnez	s2,80002422 <bmap+0x6c>
      addr = balloc(ip->dev);
    8000240c:	4108                	lw	a0,0(a0)
    8000240e:	e89ff0ef          	jal	80002296 <balloc>
    80002412:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002416:	02090d63          	beqz	s2,80002450 <bmap+0x9a>
    8000241a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000241c:	0929a023          	sw	s2,128(s3)
    80002420:	a011                	j	80002424 <bmap+0x6e>
    80002422:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002424:	85ca                	mv	a1,s2
    80002426:	0009a503          	lw	a0,0(s3)
    8000242a:	c09ff0ef          	jal	80002032 <bread>
    8000242e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002430:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002434:	02049713          	slli	a4,s1,0x20
    80002438:	01e75593          	srli	a1,a4,0x1e
    8000243c:	00b784b3          	add	s1,a5,a1
    80002440:	0004a903          	lw	s2,0(s1)
    80002444:	00090e63          	beqz	s2,80002460 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002448:	8552                	mv	a0,s4
    8000244a:	cf1ff0ef          	jal	8000213a <brelse>
    return addr;
    8000244e:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002450:	854a                	mv	a0,s2
    80002452:	70a2                	ld	ra,40(sp)
    80002454:	7402                	ld	s0,32(sp)
    80002456:	64e2                	ld	s1,24(sp)
    80002458:	6942                	ld	s2,16(sp)
    8000245a:	69a2                	ld	s3,8(sp)
    8000245c:	6145                	addi	sp,sp,48
    8000245e:	8082                	ret
      addr = balloc(ip->dev);
    80002460:	0009a503          	lw	a0,0(s3)
    80002464:	e33ff0ef          	jal	80002296 <balloc>
    80002468:	0005091b          	sext.w	s2,a0
      if(addr){
    8000246c:	fc090ee3          	beqz	s2,80002448 <bmap+0x92>
        a[bn] = addr;
    80002470:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002474:	8552                	mv	a0,s4
    80002476:	50f000ef          	jal	80003184 <log_write>
    8000247a:	b7f9                	j	80002448 <bmap+0x92>
    8000247c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000247e:	00005517          	auipc	a0,0x5
    80002482:	08250513          	addi	a0,a0,130 # 80007500 <etext+0x500>
    80002486:	09c030ef          	jal	80005522 <panic>

000000008000248a <iget>:
{
    8000248a:	7179                	addi	sp,sp,-48
    8000248c:	f406                	sd	ra,40(sp)
    8000248e:	f022                	sd	s0,32(sp)
    80002490:	ec26                	sd	s1,24(sp)
    80002492:	e84a                	sd	s2,16(sp)
    80002494:	e44e                	sd	s3,8(sp)
    80002496:	e052                	sd	s4,0(sp)
    80002498:	1800                	addi	s0,sp,48
    8000249a:	89aa                	mv	s3,a0
    8000249c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000249e:	00016517          	auipc	a0,0x16
    800024a2:	50a50513          	addi	a0,a0,1290 # 800189a8 <itable>
    800024a6:	3aa030ef          	jal	80005850 <acquire>
  empty = 0;
    800024aa:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024ac:	00016497          	auipc	s1,0x16
    800024b0:	51448493          	addi	s1,s1,1300 # 800189c0 <itable+0x18>
    800024b4:	00018697          	auipc	a3,0x18
    800024b8:	f9c68693          	addi	a3,a3,-100 # 8001a450 <log>
    800024bc:	a039                	j	800024ca <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024be:	02090963          	beqz	s2,800024f0 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024c2:	08848493          	addi	s1,s1,136
    800024c6:	02d48863          	beq	s1,a3,800024f6 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024ca:	449c                	lw	a5,8(s1)
    800024cc:	fef059e3          	blez	a5,800024be <iget+0x34>
    800024d0:	4098                	lw	a4,0(s1)
    800024d2:	ff3716e3          	bne	a4,s3,800024be <iget+0x34>
    800024d6:	40d8                	lw	a4,4(s1)
    800024d8:	ff4713e3          	bne	a4,s4,800024be <iget+0x34>
      ip->ref++;
    800024dc:	2785                	addiw	a5,a5,1
    800024de:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024e0:	00016517          	auipc	a0,0x16
    800024e4:	4c850513          	addi	a0,a0,1224 # 800189a8 <itable>
    800024e8:	400030ef          	jal	800058e8 <release>
      return ip;
    800024ec:	8926                	mv	s2,s1
    800024ee:	a02d                	j	80002518 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024f0:	fbe9                	bnez	a5,800024c2 <iget+0x38>
      empty = ip;
    800024f2:	8926                	mv	s2,s1
    800024f4:	b7f9                	j	800024c2 <iget+0x38>
  if(empty == 0)
    800024f6:	02090a63          	beqz	s2,8000252a <iget+0xa0>
  ip->dev = dev;
    800024fa:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024fe:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002502:	4785                	li	a5,1
    80002504:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002508:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000250c:	00016517          	auipc	a0,0x16
    80002510:	49c50513          	addi	a0,a0,1180 # 800189a8 <itable>
    80002514:	3d4030ef          	jal	800058e8 <release>
}
    80002518:	854a                	mv	a0,s2
    8000251a:	70a2                	ld	ra,40(sp)
    8000251c:	7402                	ld	s0,32(sp)
    8000251e:	64e2                	ld	s1,24(sp)
    80002520:	6942                	ld	s2,16(sp)
    80002522:	69a2                	ld	s3,8(sp)
    80002524:	6a02                	ld	s4,0(sp)
    80002526:	6145                	addi	sp,sp,48
    80002528:	8082                	ret
    panic("iget: no inodes");
    8000252a:	00005517          	auipc	a0,0x5
    8000252e:	fee50513          	addi	a0,a0,-18 # 80007518 <etext+0x518>
    80002532:	7f1020ef          	jal	80005522 <panic>

0000000080002536 <fsinit>:
fsinit(int dev) {
    80002536:	7179                	addi	sp,sp,-48
    80002538:	f406                	sd	ra,40(sp)
    8000253a:	f022                	sd	s0,32(sp)
    8000253c:	ec26                	sd	s1,24(sp)
    8000253e:	e84a                	sd	s2,16(sp)
    80002540:	e44e                	sd	s3,8(sp)
    80002542:	1800                	addi	s0,sp,48
    80002544:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002546:	4585                	li	a1,1
    80002548:	aebff0ef          	jal	80002032 <bread>
    8000254c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000254e:	00016997          	auipc	s3,0x16
    80002552:	43a98993          	addi	s3,s3,1082 # 80018988 <sb>
    80002556:	02000613          	li	a2,32
    8000255a:	05850593          	addi	a1,a0,88
    8000255e:	854e                	mv	a0,s3
    80002560:	c8dfd0ef          	jal	800001ec <memmove>
  brelse(bp);
    80002564:	8526                	mv	a0,s1
    80002566:	bd5ff0ef          	jal	8000213a <brelse>
  if(sb.magic != FSMAGIC)
    8000256a:	0009a703          	lw	a4,0(s3)
    8000256e:	102037b7          	lui	a5,0x10203
    80002572:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002576:	02f71063          	bne	a4,a5,80002596 <fsinit+0x60>
  initlog(dev, &sb);
    8000257a:	00016597          	auipc	a1,0x16
    8000257e:	40e58593          	addi	a1,a1,1038 # 80018988 <sb>
    80002582:	854a                	mv	a0,s2
    80002584:	1f9000ef          	jal	80002f7c <initlog>
}
    80002588:	70a2                	ld	ra,40(sp)
    8000258a:	7402                	ld	s0,32(sp)
    8000258c:	64e2                	ld	s1,24(sp)
    8000258e:	6942                	ld	s2,16(sp)
    80002590:	69a2                	ld	s3,8(sp)
    80002592:	6145                	addi	sp,sp,48
    80002594:	8082                	ret
    panic("invalid file system");
    80002596:	00005517          	auipc	a0,0x5
    8000259a:	f9250513          	addi	a0,a0,-110 # 80007528 <etext+0x528>
    8000259e:	785020ef          	jal	80005522 <panic>

00000000800025a2 <iinit>:
{
    800025a2:	7179                	addi	sp,sp,-48
    800025a4:	f406                	sd	ra,40(sp)
    800025a6:	f022                	sd	s0,32(sp)
    800025a8:	ec26                	sd	s1,24(sp)
    800025aa:	e84a                	sd	s2,16(sp)
    800025ac:	e44e                	sd	s3,8(sp)
    800025ae:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800025b0:	00005597          	auipc	a1,0x5
    800025b4:	f9058593          	addi	a1,a1,-112 # 80007540 <etext+0x540>
    800025b8:	00016517          	auipc	a0,0x16
    800025bc:	3f050513          	addi	a0,a0,1008 # 800189a8 <itable>
    800025c0:	210030ef          	jal	800057d0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800025c4:	00016497          	auipc	s1,0x16
    800025c8:	40c48493          	addi	s1,s1,1036 # 800189d0 <itable+0x28>
    800025cc:	00018997          	auipc	s3,0x18
    800025d0:	e9498993          	addi	s3,s3,-364 # 8001a460 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800025d4:	00005917          	auipc	s2,0x5
    800025d8:	f7490913          	addi	s2,s2,-140 # 80007548 <etext+0x548>
    800025dc:	85ca                	mv	a1,s2
    800025de:	8526                	mv	a0,s1
    800025e0:	475000ef          	jal	80003254 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800025e4:	08848493          	addi	s1,s1,136
    800025e8:	ff349ae3          	bne	s1,s3,800025dc <iinit+0x3a>
}
    800025ec:	70a2                	ld	ra,40(sp)
    800025ee:	7402                	ld	s0,32(sp)
    800025f0:	64e2                	ld	s1,24(sp)
    800025f2:	6942                	ld	s2,16(sp)
    800025f4:	69a2                	ld	s3,8(sp)
    800025f6:	6145                	addi	sp,sp,48
    800025f8:	8082                	ret

00000000800025fa <ialloc>:
{
    800025fa:	7139                	addi	sp,sp,-64
    800025fc:	fc06                	sd	ra,56(sp)
    800025fe:	f822                	sd	s0,48(sp)
    80002600:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002602:	00016717          	auipc	a4,0x16
    80002606:	39272703          	lw	a4,914(a4) # 80018994 <sb+0xc>
    8000260a:	4785                	li	a5,1
    8000260c:	06e7f063          	bgeu	a5,a4,8000266c <ialloc+0x72>
    80002610:	f426                	sd	s1,40(sp)
    80002612:	f04a                	sd	s2,32(sp)
    80002614:	ec4e                	sd	s3,24(sp)
    80002616:	e852                	sd	s4,16(sp)
    80002618:	e456                	sd	s5,8(sp)
    8000261a:	e05a                	sd	s6,0(sp)
    8000261c:	8aaa                	mv	s5,a0
    8000261e:	8b2e                	mv	s6,a1
    80002620:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002622:	00016a17          	auipc	s4,0x16
    80002626:	366a0a13          	addi	s4,s4,870 # 80018988 <sb>
    8000262a:	00495593          	srli	a1,s2,0x4
    8000262e:	018a2783          	lw	a5,24(s4)
    80002632:	9dbd                	addw	a1,a1,a5
    80002634:	8556                	mv	a0,s5
    80002636:	9fdff0ef          	jal	80002032 <bread>
    8000263a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000263c:	05850993          	addi	s3,a0,88
    80002640:	00f97793          	andi	a5,s2,15
    80002644:	079a                	slli	a5,a5,0x6
    80002646:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002648:	00099783          	lh	a5,0(s3)
    8000264c:	cb9d                	beqz	a5,80002682 <ialloc+0x88>
    brelse(bp);
    8000264e:	aedff0ef          	jal	8000213a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002652:	0905                	addi	s2,s2,1
    80002654:	00ca2703          	lw	a4,12(s4)
    80002658:	0009079b          	sext.w	a5,s2
    8000265c:	fce7e7e3          	bltu	a5,a4,8000262a <ialloc+0x30>
    80002660:	74a2                	ld	s1,40(sp)
    80002662:	7902                	ld	s2,32(sp)
    80002664:	69e2                	ld	s3,24(sp)
    80002666:	6a42                	ld	s4,16(sp)
    80002668:	6aa2                	ld	s5,8(sp)
    8000266a:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000266c:	00005517          	auipc	a0,0x5
    80002670:	ee450513          	addi	a0,a0,-284 # 80007550 <etext+0x550>
    80002674:	3dd020ef          	jal	80005250 <printf>
  return 0;
    80002678:	4501                	li	a0,0
}
    8000267a:	70e2                	ld	ra,56(sp)
    8000267c:	7442                	ld	s0,48(sp)
    8000267e:	6121                	addi	sp,sp,64
    80002680:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002682:	04000613          	li	a2,64
    80002686:	4581                	li	a1,0
    80002688:	854e                	mv	a0,s3
    8000268a:	b07fd0ef          	jal	80000190 <memset>
      dip->type = type;
    8000268e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002692:	8526                	mv	a0,s1
    80002694:	2f1000ef          	jal	80003184 <log_write>
      brelse(bp);
    80002698:	8526                	mv	a0,s1
    8000269a:	aa1ff0ef          	jal	8000213a <brelse>
      return iget(dev, inum);
    8000269e:	0009059b          	sext.w	a1,s2
    800026a2:	8556                	mv	a0,s5
    800026a4:	de7ff0ef          	jal	8000248a <iget>
    800026a8:	74a2                	ld	s1,40(sp)
    800026aa:	7902                	ld	s2,32(sp)
    800026ac:	69e2                	ld	s3,24(sp)
    800026ae:	6a42                	ld	s4,16(sp)
    800026b0:	6aa2                	ld	s5,8(sp)
    800026b2:	6b02                	ld	s6,0(sp)
    800026b4:	b7d9                	j	8000267a <ialloc+0x80>

00000000800026b6 <iupdate>:
{
    800026b6:	1101                	addi	sp,sp,-32
    800026b8:	ec06                	sd	ra,24(sp)
    800026ba:	e822                	sd	s0,16(sp)
    800026bc:	e426                	sd	s1,8(sp)
    800026be:	e04a                	sd	s2,0(sp)
    800026c0:	1000                	addi	s0,sp,32
    800026c2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026c4:	415c                	lw	a5,4(a0)
    800026c6:	0047d79b          	srliw	a5,a5,0x4
    800026ca:	00016597          	auipc	a1,0x16
    800026ce:	2d65a583          	lw	a1,726(a1) # 800189a0 <sb+0x18>
    800026d2:	9dbd                	addw	a1,a1,a5
    800026d4:	4108                	lw	a0,0(a0)
    800026d6:	95dff0ef          	jal	80002032 <bread>
    800026da:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026dc:	05850793          	addi	a5,a0,88
    800026e0:	40d8                	lw	a4,4(s1)
    800026e2:	8b3d                	andi	a4,a4,15
    800026e4:	071a                	slli	a4,a4,0x6
    800026e6:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800026e8:	04449703          	lh	a4,68(s1)
    800026ec:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800026f0:	04649703          	lh	a4,70(s1)
    800026f4:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800026f8:	04849703          	lh	a4,72(s1)
    800026fc:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002700:	04a49703          	lh	a4,74(s1)
    80002704:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002708:	44f8                	lw	a4,76(s1)
    8000270a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000270c:	03400613          	li	a2,52
    80002710:	05048593          	addi	a1,s1,80
    80002714:	00c78513          	addi	a0,a5,12
    80002718:	ad5fd0ef          	jal	800001ec <memmove>
  log_write(bp);
    8000271c:	854a                	mv	a0,s2
    8000271e:	267000ef          	jal	80003184 <log_write>
  brelse(bp);
    80002722:	854a                	mv	a0,s2
    80002724:	a17ff0ef          	jal	8000213a <brelse>
}
    80002728:	60e2                	ld	ra,24(sp)
    8000272a:	6442                	ld	s0,16(sp)
    8000272c:	64a2                	ld	s1,8(sp)
    8000272e:	6902                	ld	s2,0(sp)
    80002730:	6105                	addi	sp,sp,32
    80002732:	8082                	ret

0000000080002734 <idup>:
{
    80002734:	1101                	addi	sp,sp,-32
    80002736:	ec06                	sd	ra,24(sp)
    80002738:	e822                	sd	s0,16(sp)
    8000273a:	e426                	sd	s1,8(sp)
    8000273c:	1000                	addi	s0,sp,32
    8000273e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002740:	00016517          	auipc	a0,0x16
    80002744:	26850513          	addi	a0,a0,616 # 800189a8 <itable>
    80002748:	108030ef          	jal	80005850 <acquire>
  ip->ref++;
    8000274c:	449c                	lw	a5,8(s1)
    8000274e:	2785                	addiw	a5,a5,1
    80002750:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002752:	00016517          	auipc	a0,0x16
    80002756:	25650513          	addi	a0,a0,598 # 800189a8 <itable>
    8000275a:	18e030ef          	jal	800058e8 <release>
}
    8000275e:	8526                	mv	a0,s1
    80002760:	60e2                	ld	ra,24(sp)
    80002762:	6442                	ld	s0,16(sp)
    80002764:	64a2                	ld	s1,8(sp)
    80002766:	6105                	addi	sp,sp,32
    80002768:	8082                	ret

000000008000276a <ilock>:
{
    8000276a:	1101                	addi	sp,sp,-32
    8000276c:	ec06                	sd	ra,24(sp)
    8000276e:	e822                	sd	s0,16(sp)
    80002770:	e426                	sd	s1,8(sp)
    80002772:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002774:	cd19                	beqz	a0,80002792 <ilock+0x28>
    80002776:	84aa                	mv	s1,a0
    80002778:	451c                	lw	a5,8(a0)
    8000277a:	00f05c63          	blez	a5,80002792 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000277e:	0541                	addi	a0,a0,16
    80002780:	30b000ef          	jal	8000328a <acquiresleep>
  if(ip->valid == 0){
    80002784:	40bc                	lw	a5,64(s1)
    80002786:	cf89                	beqz	a5,800027a0 <ilock+0x36>
}
    80002788:	60e2                	ld	ra,24(sp)
    8000278a:	6442                	ld	s0,16(sp)
    8000278c:	64a2                	ld	s1,8(sp)
    8000278e:	6105                	addi	sp,sp,32
    80002790:	8082                	ret
    80002792:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002794:	00005517          	auipc	a0,0x5
    80002798:	dd450513          	addi	a0,a0,-556 # 80007568 <etext+0x568>
    8000279c:	587020ef          	jal	80005522 <panic>
    800027a0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800027a2:	40dc                	lw	a5,4(s1)
    800027a4:	0047d79b          	srliw	a5,a5,0x4
    800027a8:	00016597          	auipc	a1,0x16
    800027ac:	1f85a583          	lw	a1,504(a1) # 800189a0 <sb+0x18>
    800027b0:	9dbd                	addw	a1,a1,a5
    800027b2:	4088                	lw	a0,0(s1)
    800027b4:	87fff0ef          	jal	80002032 <bread>
    800027b8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027ba:	05850593          	addi	a1,a0,88
    800027be:	40dc                	lw	a5,4(s1)
    800027c0:	8bbd                	andi	a5,a5,15
    800027c2:	079a                	slli	a5,a5,0x6
    800027c4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027c6:	00059783          	lh	a5,0(a1)
    800027ca:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027ce:	00259783          	lh	a5,2(a1)
    800027d2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800027d6:	00459783          	lh	a5,4(a1)
    800027da:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800027de:	00659783          	lh	a5,6(a1)
    800027e2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027e6:	459c                	lw	a5,8(a1)
    800027e8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800027ea:	03400613          	li	a2,52
    800027ee:	05b1                	addi	a1,a1,12
    800027f0:	05048513          	addi	a0,s1,80
    800027f4:	9f9fd0ef          	jal	800001ec <memmove>
    brelse(bp);
    800027f8:	854a                	mv	a0,s2
    800027fa:	941ff0ef          	jal	8000213a <brelse>
    ip->valid = 1;
    800027fe:	4785                	li	a5,1
    80002800:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002802:	04449783          	lh	a5,68(s1)
    80002806:	c399                	beqz	a5,8000280c <ilock+0xa2>
    80002808:	6902                	ld	s2,0(sp)
    8000280a:	bfbd                	j	80002788 <ilock+0x1e>
      panic("ilock: no type");
    8000280c:	00005517          	auipc	a0,0x5
    80002810:	d6450513          	addi	a0,a0,-668 # 80007570 <etext+0x570>
    80002814:	50f020ef          	jal	80005522 <panic>

0000000080002818 <iunlock>:
{
    80002818:	1101                	addi	sp,sp,-32
    8000281a:	ec06                	sd	ra,24(sp)
    8000281c:	e822                	sd	s0,16(sp)
    8000281e:	e426                	sd	s1,8(sp)
    80002820:	e04a                	sd	s2,0(sp)
    80002822:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002824:	c505                	beqz	a0,8000284c <iunlock+0x34>
    80002826:	84aa                	mv	s1,a0
    80002828:	01050913          	addi	s2,a0,16
    8000282c:	854a                	mv	a0,s2
    8000282e:	2db000ef          	jal	80003308 <holdingsleep>
    80002832:	cd09                	beqz	a0,8000284c <iunlock+0x34>
    80002834:	449c                	lw	a5,8(s1)
    80002836:	00f05b63          	blez	a5,8000284c <iunlock+0x34>
  releasesleep(&ip->lock);
    8000283a:	854a                	mv	a0,s2
    8000283c:	295000ef          	jal	800032d0 <releasesleep>
}
    80002840:	60e2                	ld	ra,24(sp)
    80002842:	6442                	ld	s0,16(sp)
    80002844:	64a2                	ld	s1,8(sp)
    80002846:	6902                	ld	s2,0(sp)
    80002848:	6105                	addi	sp,sp,32
    8000284a:	8082                	ret
    panic("iunlock");
    8000284c:	00005517          	auipc	a0,0x5
    80002850:	d3450513          	addi	a0,a0,-716 # 80007580 <etext+0x580>
    80002854:	4cf020ef          	jal	80005522 <panic>

0000000080002858 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002858:	7179                	addi	sp,sp,-48
    8000285a:	f406                	sd	ra,40(sp)
    8000285c:	f022                	sd	s0,32(sp)
    8000285e:	ec26                	sd	s1,24(sp)
    80002860:	e84a                	sd	s2,16(sp)
    80002862:	e44e                	sd	s3,8(sp)
    80002864:	1800                	addi	s0,sp,48
    80002866:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002868:	05050493          	addi	s1,a0,80
    8000286c:	08050913          	addi	s2,a0,128
    80002870:	a021                	j	80002878 <itrunc+0x20>
    80002872:	0491                	addi	s1,s1,4
    80002874:	01248b63          	beq	s1,s2,8000288a <itrunc+0x32>
    if(ip->addrs[i]){
    80002878:	408c                	lw	a1,0(s1)
    8000287a:	dde5                	beqz	a1,80002872 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000287c:	0009a503          	lw	a0,0(s3)
    80002880:	9abff0ef          	jal	8000222a <bfree>
      ip->addrs[i] = 0;
    80002884:	0004a023          	sw	zero,0(s1)
    80002888:	b7ed                	j	80002872 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000288a:	0809a583          	lw	a1,128(s3)
    8000288e:	ed89                	bnez	a1,800028a8 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002890:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002894:	854e                	mv	a0,s3
    80002896:	e21ff0ef          	jal	800026b6 <iupdate>
}
    8000289a:	70a2                	ld	ra,40(sp)
    8000289c:	7402                	ld	s0,32(sp)
    8000289e:	64e2                	ld	s1,24(sp)
    800028a0:	6942                	ld	s2,16(sp)
    800028a2:	69a2                	ld	s3,8(sp)
    800028a4:	6145                	addi	sp,sp,48
    800028a6:	8082                	ret
    800028a8:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800028aa:	0009a503          	lw	a0,0(s3)
    800028ae:	f84ff0ef          	jal	80002032 <bread>
    800028b2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800028b4:	05850493          	addi	s1,a0,88
    800028b8:	45850913          	addi	s2,a0,1112
    800028bc:	a021                	j	800028c4 <itrunc+0x6c>
    800028be:	0491                	addi	s1,s1,4
    800028c0:	01248963          	beq	s1,s2,800028d2 <itrunc+0x7a>
      if(a[j])
    800028c4:	408c                	lw	a1,0(s1)
    800028c6:	dde5                	beqz	a1,800028be <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800028c8:	0009a503          	lw	a0,0(s3)
    800028cc:	95fff0ef          	jal	8000222a <bfree>
    800028d0:	b7fd                	j	800028be <itrunc+0x66>
    brelse(bp);
    800028d2:	8552                	mv	a0,s4
    800028d4:	867ff0ef          	jal	8000213a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800028d8:	0809a583          	lw	a1,128(s3)
    800028dc:	0009a503          	lw	a0,0(s3)
    800028e0:	94bff0ef          	jal	8000222a <bfree>
    ip->addrs[NDIRECT] = 0;
    800028e4:	0809a023          	sw	zero,128(s3)
    800028e8:	6a02                	ld	s4,0(sp)
    800028ea:	b75d                	j	80002890 <itrunc+0x38>

00000000800028ec <iput>:
{
    800028ec:	1101                	addi	sp,sp,-32
    800028ee:	ec06                	sd	ra,24(sp)
    800028f0:	e822                	sd	s0,16(sp)
    800028f2:	e426                	sd	s1,8(sp)
    800028f4:	1000                	addi	s0,sp,32
    800028f6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028f8:	00016517          	auipc	a0,0x16
    800028fc:	0b050513          	addi	a0,a0,176 # 800189a8 <itable>
    80002900:	751020ef          	jal	80005850 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002904:	4498                	lw	a4,8(s1)
    80002906:	4785                	li	a5,1
    80002908:	02f70063          	beq	a4,a5,80002928 <iput+0x3c>
  ip->ref--;
    8000290c:	449c                	lw	a5,8(s1)
    8000290e:	37fd                	addiw	a5,a5,-1
    80002910:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002912:	00016517          	auipc	a0,0x16
    80002916:	09650513          	addi	a0,a0,150 # 800189a8 <itable>
    8000291a:	7cf020ef          	jal	800058e8 <release>
}
    8000291e:	60e2                	ld	ra,24(sp)
    80002920:	6442                	ld	s0,16(sp)
    80002922:	64a2                	ld	s1,8(sp)
    80002924:	6105                	addi	sp,sp,32
    80002926:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002928:	40bc                	lw	a5,64(s1)
    8000292a:	d3ed                	beqz	a5,8000290c <iput+0x20>
    8000292c:	04a49783          	lh	a5,74(s1)
    80002930:	fff1                	bnez	a5,8000290c <iput+0x20>
    80002932:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002934:	01048913          	addi	s2,s1,16
    80002938:	854a                	mv	a0,s2
    8000293a:	151000ef          	jal	8000328a <acquiresleep>
    release(&itable.lock);
    8000293e:	00016517          	auipc	a0,0x16
    80002942:	06a50513          	addi	a0,a0,106 # 800189a8 <itable>
    80002946:	7a3020ef          	jal	800058e8 <release>
    itrunc(ip);
    8000294a:	8526                	mv	a0,s1
    8000294c:	f0dff0ef          	jal	80002858 <itrunc>
    ip->type = 0;
    80002950:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002954:	8526                	mv	a0,s1
    80002956:	d61ff0ef          	jal	800026b6 <iupdate>
    ip->valid = 0;
    8000295a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000295e:	854a                	mv	a0,s2
    80002960:	171000ef          	jal	800032d0 <releasesleep>
    acquire(&itable.lock);
    80002964:	00016517          	auipc	a0,0x16
    80002968:	04450513          	addi	a0,a0,68 # 800189a8 <itable>
    8000296c:	6e5020ef          	jal	80005850 <acquire>
    80002970:	6902                	ld	s2,0(sp)
    80002972:	bf69                	j	8000290c <iput+0x20>

0000000080002974 <iunlockput>:
{
    80002974:	1101                	addi	sp,sp,-32
    80002976:	ec06                	sd	ra,24(sp)
    80002978:	e822                	sd	s0,16(sp)
    8000297a:	e426                	sd	s1,8(sp)
    8000297c:	1000                	addi	s0,sp,32
    8000297e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002980:	e99ff0ef          	jal	80002818 <iunlock>
  iput(ip);
    80002984:	8526                	mv	a0,s1
    80002986:	f67ff0ef          	jal	800028ec <iput>
}
    8000298a:	60e2                	ld	ra,24(sp)
    8000298c:	6442                	ld	s0,16(sp)
    8000298e:	64a2                	ld	s1,8(sp)
    80002990:	6105                	addi	sp,sp,32
    80002992:	8082                	ret

0000000080002994 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002994:	1141                	addi	sp,sp,-16
    80002996:	e422                	sd	s0,8(sp)
    80002998:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000299a:	411c                	lw	a5,0(a0)
    8000299c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000299e:	415c                	lw	a5,4(a0)
    800029a0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800029a2:	04451783          	lh	a5,68(a0)
    800029a6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800029aa:	04a51783          	lh	a5,74(a0)
    800029ae:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800029b2:	04c56783          	lwu	a5,76(a0)
    800029b6:	e99c                	sd	a5,16(a1)
}
    800029b8:	6422                	ld	s0,8(sp)
    800029ba:	0141                	addi	sp,sp,16
    800029bc:	8082                	ret

00000000800029be <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029be:	457c                	lw	a5,76(a0)
    800029c0:	0ed7eb63          	bltu	a5,a3,80002ab6 <readi+0xf8>
{
    800029c4:	7159                	addi	sp,sp,-112
    800029c6:	f486                	sd	ra,104(sp)
    800029c8:	f0a2                	sd	s0,96(sp)
    800029ca:	eca6                	sd	s1,88(sp)
    800029cc:	e0d2                	sd	s4,64(sp)
    800029ce:	fc56                	sd	s5,56(sp)
    800029d0:	f85a                	sd	s6,48(sp)
    800029d2:	f45e                	sd	s7,40(sp)
    800029d4:	1880                	addi	s0,sp,112
    800029d6:	8b2a                	mv	s6,a0
    800029d8:	8bae                	mv	s7,a1
    800029da:	8a32                	mv	s4,a2
    800029dc:	84b6                	mv	s1,a3
    800029de:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800029e0:	9f35                	addw	a4,a4,a3
    return 0;
    800029e2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800029e4:	0cd76063          	bltu	a4,a3,80002aa4 <readi+0xe6>
    800029e8:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800029ea:	00e7f463          	bgeu	a5,a4,800029f2 <readi+0x34>
    n = ip->size - off;
    800029ee:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029f2:	080a8f63          	beqz	s5,80002a90 <readi+0xd2>
    800029f6:	e8ca                	sd	s2,80(sp)
    800029f8:	f062                	sd	s8,32(sp)
    800029fa:	ec66                	sd	s9,24(sp)
    800029fc:	e86a                	sd	s10,16(sp)
    800029fe:	e46e                	sd	s11,8(sp)
    80002a00:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a02:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a06:	5c7d                	li	s8,-1
    80002a08:	a80d                	j	80002a3a <readi+0x7c>
    80002a0a:	020d1d93          	slli	s11,s10,0x20
    80002a0e:	020ddd93          	srli	s11,s11,0x20
    80002a12:	05890613          	addi	a2,s2,88
    80002a16:	86ee                	mv	a3,s11
    80002a18:	963a                	add	a2,a2,a4
    80002a1a:	85d2                	mv	a1,s4
    80002a1c:	855e                	mv	a0,s7
    80002a1e:	cbdfe0ef          	jal	800016da <either_copyout>
    80002a22:	05850763          	beq	a0,s8,80002a70 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a26:	854a                	mv	a0,s2
    80002a28:	f12ff0ef          	jal	8000213a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a2c:	013d09bb          	addw	s3,s10,s3
    80002a30:	009d04bb          	addw	s1,s10,s1
    80002a34:	9a6e                	add	s4,s4,s11
    80002a36:	0559f763          	bgeu	s3,s5,80002a84 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002a3a:	00a4d59b          	srliw	a1,s1,0xa
    80002a3e:	855a                	mv	a0,s6
    80002a40:	977ff0ef          	jal	800023b6 <bmap>
    80002a44:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a48:	c5b1                	beqz	a1,80002a94 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002a4a:	000b2503          	lw	a0,0(s6)
    80002a4e:	de4ff0ef          	jal	80002032 <bread>
    80002a52:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a54:	3ff4f713          	andi	a4,s1,1023
    80002a58:	40ec87bb          	subw	a5,s9,a4
    80002a5c:	413a86bb          	subw	a3,s5,s3
    80002a60:	8d3e                	mv	s10,a5
    80002a62:	2781                	sext.w	a5,a5
    80002a64:	0006861b          	sext.w	a2,a3
    80002a68:	faf671e3          	bgeu	a2,a5,80002a0a <readi+0x4c>
    80002a6c:	8d36                	mv	s10,a3
    80002a6e:	bf71                	j	80002a0a <readi+0x4c>
      brelse(bp);
    80002a70:	854a                	mv	a0,s2
    80002a72:	ec8ff0ef          	jal	8000213a <brelse>
      tot = -1;
    80002a76:	59fd                	li	s3,-1
      break;
    80002a78:	6946                	ld	s2,80(sp)
    80002a7a:	7c02                	ld	s8,32(sp)
    80002a7c:	6ce2                	ld	s9,24(sp)
    80002a7e:	6d42                	ld	s10,16(sp)
    80002a80:	6da2                	ld	s11,8(sp)
    80002a82:	a831                	j	80002a9e <readi+0xe0>
    80002a84:	6946                	ld	s2,80(sp)
    80002a86:	7c02                	ld	s8,32(sp)
    80002a88:	6ce2                	ld	s9,24(sp)
    80002a8a:	6d42                	ld	s10,16(sp)
    80002a8c:	6da2                	ld	s11,8(sp)
    80002a8e:	a801                	j	80002a9e <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a90:	89d6                	mv	s3,s5
    80002a92:	a031                	j	80002a9e <readi+0xe0>
    80002a94:	6946                	ld	s2,80(sp)
    80002a96:	7c02                	ld	s8,32(sp)
    80002a98:	6ce2                	ld	s9,24(sp)
    80002a9a:	6d42                	ld	s10,16(sp)
    80002a9c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a9e:	0009851b          	sext.w	a0,s3
    80002aa2:	69a6                	ld	s3,72(sp)
}
    80002aa4:	70a6                	ld	ra,104(sp)
    80002aa6:	7406                	ld	s0,96(sp)
    80002aa8:	64e6                	ld	s1,88(sp)
    80002aaa:	6a06                	ld	s4,64(sp)
    80002aac:	7ae2                	ld	s5,56(sp)
    80002aae:	7b42                	ld	s6,48(sp)
    80002ab0:	7ba2                	ld	s7,40(sp)
    80002ab2:	6165                	addi	sp,sp,112
    80002ab4:	8082                	ret
    return 0;
    80002ab6:	4501                	li	a0,0
}
    80002ab8:	8082                	ret

0000000080002aba <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002aba:	457c                	lw	a5,76(a0)
    80002abc:	10d7e063          	bltu	a5,a3,80002bbc <writei+0x102>
{
    80002ac0:	7159                	addi	sp,sp,-112
    80002ac2:	f486                	sd	ra,104(sp)
    80002ac4:	f0a2                	sd	s0,96(sp)
    80002ac6:	e8ca                	sd	s2,80(sp)
    80002ac8:	e0d2                	sd	s4,64(sp)
    80002aca:	fc56                	sd	s5,56(sp)
    80002acc:	f85a                	sd	s6,48(sp)
    80002ace:	f45e                	sd	s7,40(sp)
    80002ad0:	1880                	addi	s0,sp,112
    80002ad2:	8aaa                	mv	s5,a0
    80002ad4:	8bae                	mv	s7,a1
    80002ad6:	8a32                	mv	s4,a2
    80002ad8:	8936                	mv	s2,a3
    80002ada:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002adc:	00e687bb          	addw	a5,a3,a4
    80002ae0:	0ed7e063          	bltu	a5,a3,80002bc0 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ae4:	00043737          	lui	a4,0x43
    80002ae8:	0cf76e63          	bltu	a4,a5,80002bc4 <writei+0x10a>
    80002aec:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002aee:	0a0b0f63          	beqz	s6,80002bac <writei+0xf2>
    80002af2:	eca6                	sd	s1,88(sp)
    80002af4:	f062                	sd	s8,32(sp)
    80002af6:	ec66                	sd	s9,24(sp)
    80002af8:	e86a                	sd	s10,16(sp)
    80002afa:	e46e                	sd	s11,8(sp)
    80002afc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002afe:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b02:	5c7d                	li	s8,-1
    80002b04:	a825                	j	80002b3c <writei+0x82>
    80002b06:	020d1d93          	slli	s11,s10,0x20
    80002b0a:	020ddd93          	srli	s11,s11,0x20
    80002b0e:	05848513          	addi	a0,s1,88
    80002b12:	86ee                	mv	a3,s11
    80002b14:	8652                	mv	a2,s4
    80002b16:	85de                	mv	a1,s7
    80002b18:	953a                	add	a0,a0,a4
    80002b1a:	c0bfe0ef          	jal	80001724 <either_copyin>
    80002b1e:	05850a63          	beq	a0,s8,80002b72 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b22:	8526                	mv	a0,s1
    80002b24:	660000ef          	jal	80003184 <log_write>
    brelse(bp);
    80002b28:	8526                	mv	a0,s1
    80002b2a:	e10ff0ef          	jal	8000213a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b2e:	013d09bb          	addw	s3,s10,s3
    80002b32:	012d093b          	addw	s2,s10,s2
    80002b36:	9a6e                	add	s4,s4,s11
    80002b38:	0569f063          	bgeu	s3,s6,80002b78 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b3c:	00a9559b          	srliw	a1,s2,0xa
    80002b40:	8556                	mv	a0,s5
    80002b42:	875ff0ef          	jal	800023b6 <bmap>
    80002b46:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b4a:	c59d                	beqz	a1,80002b78 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002b4c:	000aa503          	lw	a0,0(s5)
    80002b50:	ce2ff0ef          	jal	80002032 <bread>
    80002b54:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b56:	3ff97713          	andi	a4,s2,1023
    80002b5a:	40ec87bb          	subw	a5,s9,a4
    80002b5e:	413b06bb          	subw	a3,s6,s3
    80002b62:	8d3e                	mv	s10,a5
    80002b64:	2781                	sext.w	a5,a5
    80002b66:	0006861b          	sext.w	a2,a3
    80002b6a:	f8f67ee3          	bgeu	a2,a5,80002b06 <writei+0x4c>
    80002b6e:	8d36                	mv	s10,a3
    80002b70:	bf59                	j	80002b06 <writei+0x4c>
      brelse(bp);
    80002b72:	8526                	mv	a0,s1
    80002b74:	dc6ff0ef          	jal	8000213a <brelse>
  }

  if(off > ip->size)
    80002b78:	04caa783          	lw	a5,76(s5)
    80002b7c:	0327fa63          	bgeu	a5,s2,80002bb0 <writei+0xf6>
    ip->size = off;
    80002b80:	052aa623          	sw	s2,76(s5)
    80002b84:	64e6                	ld	s1,88(sp)
    80002b86:	7c02                	ld	s8,32(sp)
    80002b88:	6ce2                	ld	s9,24(sp)
    80002b8a:	6d42                	ld	s10,16(sp)
    80002b8c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b8e:	8556                	mv	a0,s5
    80002b90:	b27ff0ef          	jal	800026b6 <iupdate>

  return tot;
    80002b94:	0009851b          	sext.w	a0,s3
    80002b98:	69a6                	ld	s3,72(sp)
}
    80002b9a:	70a6                	ld	ra,104(sp)
    80002b9c:	7406                	ld	s0,96(sp)
    80002b9e:	6946                	ld	s2,80(sp)
    80002ba0:	6a06                	ld	s4,64(sp)
    80002ba2:	7ae2                	ld	s5,56(sp)
    80002ba4:	7b42                	ld	s6,48(sp)
    80002ba6:	7ba2                	ld	s7,40(sp)
    80002ba8:	6165                	addi	sp,sp,112
    80002baa:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bac:	89da                	mv	s3,s6
    80002bae:	b7c5                	j	80002b8e <writei+0xd4>
    80002bb0:	64e6                	ld	s1,88(sp)
    80002bb2:	7c02                	ld	s8,32(sp)
    80002bb4:	6ce2                	ld	s9,24(sp)
    80002bb6:	6d42                	ld	s10,16(sp)
    80002bb8:	6da2                	ld	s11,8(sp)
    80002bba:	bfd1                	j	80002b8e <writei+0xd4>
    return -1;
    80002bbc:	557d                	li	a0,-1
}
    80002bbe:	8082                	ret
    return -1;
    80002bc0:	557d                	li	a0,-1
    80002bc2:	bfe1                	j	80002b9a <writei+0xe0>
    return -1;
    80002bc4:	557d                	li	a0,-1
    80002bc6:	bfd1                	j	80002b9a <writei+0xe0>

0000000080002bc8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002bc8:	1141                	addi	sp,sp,-16
    80002bca:	e406                	sd	ra,8(sp)
    80002bcc:	e022                	sd	s0,0(sp)
    80002bce:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002bd0:	4639                	li	a2,14
    80002bd2:	e8afd0ef          	jal	8000025c <strncmp>
}
    80002bd6:	60a2                	ld	ra,8(sp)
    80002bd8:	6402                	ld	s0,0(sp)
    80002bda:	0141                	addi	sp,sp,16
    80002bdc:	8082                	ret

0000000080002bde <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002bde:	7139                	addi	sp,sp,-64
    80002be0:	fc06                	sd	ra,56(sp)
    80002be2:	f822                	sd	s0,48(sp)
    80002be4:	f426                	sd	s1,40(sp)
    80002be6:	f04a                	sd	s2,32(sp)
    80002be8:	ec4e                	sd	s3,24(sp)
    80002bea:	e852                	sd	s4,16(sp)
    80002bec:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002bee:	04451703          	lh	a4,68(a0)
    80002bf2:	4785                	li	a5,1
    80002bf4:	00f71a63          	bne	a4,a5,80002c08 <dirlookup+0x2a>
    80002bf8:	892a                	mv	s2,a0
    80002bfa:	89ae                	mv	s3,a1
    80002bfc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bfe:	457c                	lw	a5,76(a0)
    80002c00:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c02:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c04:	e39d                	bnez	a5,80002c2a <dirlookup+0x4c>
    80002c06:	a095                	j	80002c6a <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c08:	00005517          	auipc	a0,0x5
    80002c0c:	98050513          	addi	a0,a0,-1664 # 80007588 <etext+0x588>
    80002c10:	113020ef          	jal	80005522 <panic>
      panic("dirlookup read");
    80002c14:	00005517          	auipc	a0,0x5
    80002c18:	98c50513          	addi	a0,a0,-1652 # 800075a0 <etext+0x5a0>
    80002c1c:	107020ef          	jal	80005522 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c20:	24c1                	addiw	s1,s1,16
    80002c22:	04c92783          	lw	a5,76(s2)
    80002c26:	04f4f163          	bgeu	s1,a5,80002c68 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c2a:	4741                	li	a4,16
    80002c2c:	86a6                	mv	a3,s1
    80002c2e:	fc040613          	addi	a2,s0,-64
    80002c32:	4581                	li	a1,0
    80002c34:	854a                	mv	a0,s2
    80002c36:	d89ff0ef          	jal	800029be <readi>
    80002c3a:	47c1                	li	a5,16
    80002c3c:	fcf51ce3          	bne	a0,a5,80002c14 <dirlookup+0x36>
    if(de.inum == 0)
    80002c40:	fc045783          	lhu	a5,-64(s0)
    80002c44:	dff1                	beqz	a5,80002c20 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002c46:	fc240593          	addi	a1,s0,-62
    80002c4a:	854e                	mv	a0,s3
    80002c4c:	f7dff0ef          	jal	80002bc8 <namecmp>
    80002c50:	f961                	bnez	a0,80002c20 <dirlookup+0x42>
      if(poff)
    80002c52:	000a0463          	beqz	s4,80002c5a <dirlookup+0x7c>
        *poff = off;
    80002c56:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002c5a:	fc045583          	lhu	a1,-64(s0)
    80002c5e:	00092503          	lw	a0,0(s2)
    80002c62:	829ff0ef          	jal	8000248a <iget>
    80002c66:	a011                	j	80002c6a <dirlookup+0x8c>
  return 0;
    80002c68:	4501                	li	a0,0
}
    80002c6a:	70e2                	ld	ra,56(sp)
    80002c6c:	7442                	ld	s0,48(sp)
    80002c6e:	74a2                	ld	s1,40(sp)
    80002c70:	7902                	ld	s2,32(sp)
    80002c72:	69e2                	ld	s3,24(sp)
    80002c74:	6a42                	ld	s4,16(sp)
    80002c76:	6121                	addi	sp,sp,64
    80002c78:	8082                	ret

0000000080002c7a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c7a:	711d                	addi	sp,sp,-96
    80002c7c:	ec86                	sd	ra,88(sp)
    80002c7e:	e8a2                	sd	s0,80(sp)
    80002c80:	e4a6                	sd	s1,72(sp)
    80002c82:	e0ca                	sd	s2,64(sp)
    80002c84:	fc4e                	sd	s3,56(sp)
    80002c86:	f852                	sd	s4,48(sp)
    80002c88:	f456                	sd	s5,40(sp)
    80002c8a:	f05a                	sd	s6,32(sp)
    80002c8c:	ec5e                	sd	s7,24(sp)
    80002c8e:	e862                	sd	s8,16(sp)
    80002c90:	e466                	sd	s9,8(sp)
    80002c92:	1080                	addi	s0,sp,96
    80002c94:	84aa                	mv	s1,a0
    80002c96:	8b2e                	mv	s6,a1
    80002c98:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c9a:	00054703          	lbu	a4,0(a0)
    80002c9e:	02f00793          	li	a5,47
    80002ca2:	00f70e63          	beq	a4,a5,80002cbe <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002ca6:	902fe0ef          	jal	80000da8 <myproc>
    80002caa:	15053503          	ld	a0,336(a0)
    80002cae:	a87ff0ef          	jal	80002734 <idup>
    80002cb2:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002cb4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002cb8:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002cba:	4b85                	li	s7,1
    80002cbc:	a871                	j	80002d58 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002cbe:	4585                	li	a1,1
    80002cc0:	4505                	li	a0,1
    80002cc2:	fc8ff0ef          	jal	8000248a <iget>
    80002cc6:	8a2a                	mv	s4,a0
    80002cc8:	b7f5                	j	80002cb4 <namex+0x3a>
      iunlockput(ip);
    80002cca:	8552                	mv	a0,s4
    80002ccc:	ca9ff0ef          	jal	80002974 <iunlockput>
      return 0;
    80002cd0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002cd2:	8552                	mv	a0,s4
    80002cd4:	60e6                	ld	ra,88(sp)
    80002cd6:	6446                	ld	s0,80(sp)
    80002cd8:	64a6                	ld	s1,72(sp)
    80002cda:	6906                	ld	s2,64(sp)
    80002cdc:	79e2                	ld	s3,56(sp)
    80002cde:	7a42                	ld	s4,48(sp)
    80002ce0:	7aa2                	ld	s5,40(sp)
    80002ce2:	7b02                	ld	s6,32(sp)
    80002ce4:	6be2                	ld	s7,24(sp)
    80002ce6:	6c42                	ld	s8,16(sp)
    80002ce8:	6ca2                	ld	s9,8(sp)
    80002cea:	6125                	addi	sp,sp,96
    80002cec:	8082                	ret
      iunlock(ip);
    80002cee:	8552                	mv	a0,s4
    80002cf0:	b29ff0ef          	jal	80002818 <iunlock>
      return ip;
    80002cf4:	bff9                	j	80002cd2 <namex+0x58>
      iunlockput(ip);
    80002cf6:	8552                	mv	a0,s4
    80002cf8:	c7dff0ef          	jal	80002974 <iunlockput>
      return 0;
    80002cfc:	8a4e                	mv	s4,s3
    80002cfe:	bfd1                	j	80002cd2 <namex+0x58>
  len = path - s;
    80002d00:	40998633          	sub	a2,s3,s1
    80002d04:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002d08:	099c5063          	bge	s8,s9,80002d88 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002d0c:	4639                	li	a2,14
    80002d0e:	85a6                	mv	a1,s1
    80002d10:	8556                	mv	a0,s5
    80002d12:	cdafd0ef          	jal	800001ec <memmove>
    80002d16:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d18:	0004c783          	lbu	a5,0(s1)
    80002d1c:	01279763          	bne	a5,s2,80002d2a <namex+0xb0>
    path++;
    80002d20:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d22:	0004c783          	lbu	a5,0(s1)
    80002d26:	ff278de3          	beq	a5,s2,80002d20 <namex+0xa6>
    ilock(ip);
    80002d2a:	8552                	mv	a0,s4
    80002d2c:	a3fff0ef          	jal	8000276a <ilock>
    if(ip->type != T_DIR){
    80002d30:	044a1783          	lh	a5,68(s4)
    80002d34:	f9779be3          	bne	a5,s7,80002cca <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002d38:	000b0563          	beqz	s6,80002d42 <namex+0xc8>
    80002d3c:	0004c783          	lbu	a5,0(s1)
    80002d40:	d7dd                	beqz	a5,80002cee <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d42:	4601                	li	a2,0
    80002d44:	85d6                	mv	a1,s5
    80002d46:	8552                	mv	a0,s4
    80002d48:	e97ff0ef          	jal	80002bde <dirlookup>
    80002d4c:	89aa                	mv	s3,a0
    80002d4e:	d545                	beqz	a0,80002cf6 <namex+0x7c>
    iunlockput(ip);
    80002d50:	8552                	mv	a0,s4
    80002d52:	c23ff0ef          	jal	80002974 <iunlockput>
    ip = next;
    80002d56:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d58:	0004c783          	lbu	a5,0(s1)
    80002d5c:	01279763          	bne	a5,s2,80002d6a <namex+0xf0>
    path++;
    80002d60:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d62:	0004c783          	lbu	a5,0(s1)
    80002d66:	ff278de3          	beq	a5,s2,80002d60 <namex+0xe6>
  if(*path == 0)
    80002d6a:	cb8d                	beqz	a5,80002d9c <namex+0x122>
  while(*path != '/' && *path != 0)
    80002d6c:	0004c783          	lbu	a5,0(s1)
    80002d70:	89a6                	mv	s3,s1
  len = path - s;
    80002d72:	4c81                	li	s9,0
    80002d74:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002d76:	01278963          	beq	a5,s2,80002d88 <namex+0x10e>
    80002d7a:	d3d9                	beqz	a5,80002d00 <namex+0x86>
    path++;
    80002d7c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d7e:	0009c783          	lbu	a5,0(s3)
    80002d82:	ff279ce3          	bne	a5,s2,80002d7a <namex+0x100>
    80002d86:	bfad                	j	80002d00 <namex+0x86>
    memmove(name, s, len);
    80002d88:	2601                	sext.w	a2,a2
    80002d8a:	85a6                	mv	a1,s1
    80002d8c:	8556                	mv	a0,s5
    80002d8e:	c5efd0ef          	jal	800001ec <memmove>
    name[len] = 0;
    80002d92:	9cd6                	add	s9,s9,s5
    80002d94:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002d98:	84ce                	mv	s1,s3
    80002d9a:	bfbd                	j	80002d18 <namex+0x9e>
  if(nameiparent){
    80002d9c:	f20b0be3          	beqz	s6,80002cd2 <namex+0x58>
    iput(ip);
    80002da0:	8552                	mv	a0,s4
    80002da2:	b4bff0ef          	jal	800028ec <iput>
    return 0;
    80002da6:	4a01                	li	s4,0
    80002da8:	b72d                	j	80002cd2 <namex+0x58>

0000000080002daa <dirlink>:
{
    80002daa:	7139                	addi	sp,sp,-64
    80002dac:	fc06                	sd	ra,56(sp)
    80002dae:	f822                	sd	s0,48(sp)
    80002db0:	f04a                	sd	s2,32(sp)
    80002db2:	ec4e                	sd	s3,24(sp)
    80002db4:	e852                	sd	s4,16(sp)
    80002db6:	0080                	addi	s0,sp,64
    80002db8:	892a                	mv	s2,a0
    80002dba:	8a2e                	mv	s4,a1
    80002dbc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002dbe:	4601                	li	a2,0
    80002dc0:	e1fff0ef          	jal	80002bde <dirlookup>
    80002dc4:	e535                	bnez	a0,80002e30 <dirlink+0x86>
    80002dc6:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dc8:	04c92483          	lw	s1,76(s2)
    80002dcc:	c48d                	beqz	s1,80002df6 <dirlink+0x4c>
    80002dce:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dd0:	4741                	li	a4,16
    80002dd2:	86a6                	mv	a3,s1
    80002dd4:	fc040613          	addi	a2,s0,-64
    80002dd8:	4581                	li	a1,0
    80002dda:	854a                	mv	a0,s2
    80002ddc:	be3ff0ef          	jal	800029be <readi>
    80002de0:	47c1                	li	a5,16
    80002de2:	04f51b63          	bne	a0,a5,80002e38 <dirlink+0x8e>
    if(de.inum == 0)
    80002de6:	fc045783          	lhu	a5,-64(s0)
    80002dea:	c791                	beqz	a5,80002df6 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dec:	24c1                	addiw	s1,s1,16
    80002dee:	04c92783          	lw	a5,76(s2)
    80002df2:	fcf4efe3          	bltu	s1,a5,80002dd0 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002df6:	4639                	li	a2,14
    80002df8:	85d2                	mv	a1,s4
    80002dfa:	fc240513          	addi	a0,s0,-62
    80002dfe:	c94fd0ef          	jal	80000292 <strncpy>
  de.inum = inum;
    80002e02:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e06:	4741                	li	a4,16
    80002e08:	86a6                	mv	a3,s1
    80002e0a:	fc040613          	addi	a2,s0,-64
    80002e0e:	4581                	li	a1,0
    80002e10:	854a                	mv	a0,s2
    80002e12:	ca9ff0ef          	jal	80002aba <writei>
    80002e16:	1541                	addi	a0,a0,-16
    80002e18:	00a03533          	snez	a0,a0
    80002e1c:	40a00533          	neg	a0,a0
    80002e20:	74a2                	ld	s1,40(sp)
}
    80002e22:	70e2                	ld	ra,56(sp)
    80002e24:	7442                	ld	s0,48(sp)
    80002e26:	7902                	ld	s2,32(sp)
    80002e28:	69e2                	ld	s3,24(sp)
    80002e2a:	6a42                	ld	s4,16(sp)
    80002e2c:	6121                	addi	sp,sp,64
    80002e2e:	8082                	ret
    iput(ip);
    80002e30:	abdff0ef          	jal	800028ec <iput>
    return -1;
    80002e34:	557d                	li	a0,-1
    80002e36:	b7f5                	j	80002e22 <dirlink+0x78>
      panic("dirlink read");
    80002e38:	00004517          	auipc	a0,0x4
    80002e3c:	77850513          	addi	a0,a0,1912 # 800075b0 <etext+0x5b0>
    80002e40:	6e2020ef          	jal	80005522 <panic>

0000000080002e44 <namei>:

struct inode*
namei(char *path)
{
    80002e44:	1101                	addi	sp,sp,-32
    80002e46:	ec06                	sd	ra,24(sp)
    80002e48:	e822                	sd	s0,16(sp)
    80002e4a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e4c:	fe040613          	addi	a2,s0,-32
    80002e50:	4581                	li	a1,0
    80002e52:	e29ff0ef          	jal	80002c7a <namex>
}
    80002e56:	60e2                	ld	ra,24(sp)
    80002e58:	6442                	ld	s0,16(sp)
    80002e5a:	6105                	addi	sp,sp,32
    80002e5c:	8082                	ret

0000000080002e5e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e5e:	1141                	addi	sp,sp,-16
    80002e60:	e406                	sd	ra,8(sp)
    80002e62:	e022                	sd	s0,0(sp)
    80002e64:	0800                	addi	s0,sp,16
    80002e66:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e68:	4585                	li	a1,1
    80002e6a:	e11ff0ef          	jal	80002c7a <namex>
}
    80002e6e:	60a2                	ld	ra,8(sp)
    80002e70:	6402                	ld	s0,0(sp)
    80002e72:	0141                	addi	sp,sp,16
    80002e74:	8082                	ret

0000000080002e76 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e76:	1101                	addi	sp,sp,-32
    80002e78:	ec06                	sd	ra,24(sp)
    80002e7a:	e822                	sd	s0,16(sp)
    80002e7c:	e426                	sd	s1,8(sp)
    80002e7e:	e04a                	sd	s2,0(sp)
    80002e80:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e82:	00017917          	auipc	s2,0x17
    80002e86:	5ce90913          	addi	s2,s2,1486 # 8001a450 <log>
    80002e8a:	01892583          	lw	a1,24(s2)
    80002e8e:	02892503          	lw	a0,40(s2)
    80002e92:	9a0ff0ef          	jal	80002032 <bread>
    80002e96:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e98:	02c92603          	lw	a2,44(s2)
    80002e9c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e9e:	00c05f63          	blez	a2,80002ebc <write_head+0x46>
    80002ea2:	00017717          	auipc	a4,0x17
    80002ea6:	5de70713          	addi	a4,a4,1502 # 8001a480 <log+0x30>
    80002eaa:	87aa                	mv	a5,a0
    80002eac:	060a                	slli	a2,a2,0x2
    80002eae:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002eb0:	4314                	lw	a3,0(a4)
    80002eb2:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002eb4:	0711                	addi	a4,a4,4
    80002eb6:	0791                	addi	a5,a5,4
    80002eb8:	fec79ce3          	bne	a5,a2,80002eb0 <write_head+0x3a>
  }
  bwrite(buf);
    80002ebc:	8526                	mv	a0,s1
    80002ebe:	a4aff0ef          	jal	80002108 <bwrite>
  brelse(buf);
    80002ec2:	8526                	mv	a0,s1
    80002ec4:	a76ff0ef          	jal	8000213a <brelse>
}
    80002ec8:	60e2                	ld	ra,24(sp)
    80002eca:	6442                	ld	s0,16(sp)
    80002ecc:	64a2                	ld	s1,8(sp)
    80002ece:	6902                	ld	s2,0(sp)
    80002ed0:	6105                	addi	sp,sp,32
    80002ed2:	8082                	ret

0000000080002ed4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ed4:	00017797          	auipc	a5,0x17
    80002ed8:	5a87a783          	lw	a5,1448(a5) # 8001a47c <log+0x2c>
    80002edc:	08f05f63          	blez	a5,80002f7a <install_trans+0xa6>
{
    80002ee0:	7139                	addi	sp,sp,-64
    80002ee2:	fc06                	sd	ra,56(sp)
    80002ee4:	f822                	sd	s0,48(sp)
    80002ee6:	f426                	sd	s1,40(sp)
    80002ee8:	f04a                	sd	s2,32(sp)
    80002eea:	ec4e                	sd	s3,24(sp)
    80002eec:	e852                	sd	s4,16(sp)
    80002eee:	e456                	sd	s5,8(sp)
    80002ef0:	e05a                	sd	s6,0(sp)
    80002ef2:	0080                	addi	s0,sp,64
    80002ef4:	8b2a                	mv	s6,a0
    80002ef6:	00017a97          	auipc	s5,0x17
    80002efa:	58aa8a93          	addi	s5,s5,1418 # 8001a480 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002efe:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f00:	00017997          	auipc	s3,0x17
    80002f04:	55098993          	addi	s3,s3,1360 # 8001a450 <log>
    80002f08:	a829                	j	80002f22 <install_trans+0x4e>
    brelse(lbuf);
    80002f0a:	854a                	mv	a0,s2
    80002f0c:	a2eff0ef          	jal	8000213a <brelse>
    brelse(dbuf);
    80002f10:	8526                	mv	a0,s1
    80002f12:	a28ff0ef          	jal	8000213a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f16:	2a05                	addiw	s4,s4,1
    80002f18:	0a91                	addi	s5,s5,4
    80002f1a:	02c9a783          	lw	a5,44(s3)
    80002f1e:	04fa5463          	bge	s4,a5,80002f66 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f22:	0189a583          	lw	a1,24(s3)
    80002f26:	014585bb          	addw	a1,a1,s4
    80002f2a:	2585                	addiw	a1,a1,1
    80002f2c:	0289a503          	lw	a0,40(s3)
    80002f30:	902ff0ef          	jal	80002032 <bread>
    80002f34:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f36:	000aa583          	lw	a1,0(s5)
    80002f3a:	0289a503          	lw	a0,40(s3)
    80002f3e:	8f4ff0ef          	jal	80002032 <bread>
    80002f42:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f44:	40000613          	li	a2,1024
    80002f48:	05890593          	addi	a1,s2,88
    80002f4c:	05850513          	addi	a0,a0,88
    80002f50:	a9cfd0ef          	jal	800001ec <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f54:	8526                	mv	a0,s1
    80002f56:	9b2ff0ef          	jal	80002108 <bwrite>
    if(recovering == 0)
    80002f5a:	fa0b18e3          	bnez	s6,80002f0a <install_trans+0x36>
      bunpin(dbuf);
    80002f5e:	8526                	mv	a0,s1
    80002f60:	a96ff0ef          	jal	800021f6 <bunpin>
    80002f64:	b75d                	j	80002f0a <install_trans+0x36>
}
    80002f66:	70e2                	ld	ra,56(sp)
    80002f68:	7442                	ld	s0,48(sp)
    80002f6a:	74a2                	ld	s1,40(sp)
    80002f6c:	7902                	ld	s2,32(sp)
    80002f6e:	69e2                	ld	s3,24(sp)
    80002f70:	6a42                	ld	s4,16(sp)
    80002f72:	6aa2                	ld	s5,8(sp)
    80002f74:	6b02                	ld	s6,0(sp)
    80002f76:	6121                	addi	sp,sp,64
    80002f78:	8082                	ret
    80002f7a:	8082                	ret

0000000080002f7c <initlog>:
{
    80002f7c:	7179                	addi	sp,sp,-48
    80002f7e:	f406                	sd	ra,40(sp)
    80002f80:	f022                	sd	s0,32(sp)
    80002f82:	ec26                	sd	s1,24(sp)
    80002f84:	e84a                	sd	s2,16(sp)
    80002f86:	e44e                	sd	s3,8(sp)
    80002f88:	1800                	addi	s0,sp,48
    80002f8a:	892a                	mv	s2,a0
    80002f8c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f8e:	00017497          	auipc	s1,0x17
    80002f92:	4c248493          	addi	s1,s1,1218 # 8001a450 <log>
    80002f96:	00004597          	auipc	a1,0x4
    80002f9a:	62a58593          	addi	a1,a1,1578 # 800075c0 <etext+0x5c0>
    80002f9e:	8526                	mv	a0,s1
    80002fa0:	031020ef          	jal	800057d0 <initlock>
  log.start = sb->logstart;
    80002fa4:	0149a583          	lw	a1,20(s3)
    80002fa8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002faa:	0109a783          	lw	a5,16(s3)
    80002fae:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002fb0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002fb4:	854a                	mv	a0,s2
    80002fb6:	87cff0ef          	jal	80002032 <bread>
  log.lh.n = lh->n;
    80002fba:	4d30                	lw	a2,88(a0)
    80002fbc:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002fbe:	00c05f63          	blez	a2,80002fdc <initlog+0x60>
    80002fc2:	87aa                	mv	a5,a0
    80002fc4:	00017717          	auipc	a4,0x17
    80002fc8:	4bc70713          	addi	a4,a4,1212 # 8001a480 <log+0x30>
    80002fcc:	060a                	slli	a2,a2,0x2
    80002fce:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002fd0:	4ff4                	lw	a3,92(a5)
    80002fd2:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002fd4:	0791                	addi	a5,a5,4
    80002fd6:	0711                	addi	a4,a4,4
    80002fd8:	fec79ce3          	bne	a5,a2,80002fd0 <initlog+0x54>
  brelse(buf);
    80002fdc:	95eff0ef          	jal	8000213a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002fe0:	4505                	li	a0,1
    80002fe2:	ef3ff0ef          	jal	80002ed4 <install_trans>
  log.lh.n = 0;
    80002fe6:	00017797          	auipc	a5,0x17
    80002fea:	4807ab23          	sw	zero,1174(a5) # 8001a47c <log+0x2c>
  write_head(); // clear the log
    80002fee:	e89ff0ef          	jal	80002e76 <write_head>
}
    80002ff2:	70a2                	ld	ra,40(sp)
    80002ff4:	7402                	ld	s0,32(sp)
    80002ff6:	64e2                	ld	s1,24(sp)
    80002ff8:	6942                	ld	s2,16(sp)
    80002ffa:	69a2                	ld	s3,8(sp)
    80002ffc:	6145                	addi	sp,sp,48
    80002ffe:	8082                	ret

0000000080003000 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003000:	1101                	addi	sp,sp,-32
    80003002:	ec06                	sd	ra,24(sp)
    80003004:	e822                	sd	s0,16(sp)
    80003006:	e426                	sd	s1,8(sp)
    80003008:	e04a                	sd	s2,0(sp)
    8000300a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000300c:	00017517          	auipc	a0,0x17
    80003010:	44450513          	addi	a0,a0,1092 # 8001a450 <log>
    80003014:	03d020ef          	jal	80005850 <acquire>
  while(1){
    if(log.committing){
    80003018:	00017497          	auipc	s1,0x17
    8000301c:	43848493          	addi	s1,s1,1080 # 8001a450 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003020:	4979                	li	s2,30
    80003022:	a029                	j	8000302c <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003024:	85a6                	mv	a1,s1
    80003026:	8526                	mv	a0,s1
    80003028:	b56fe0ef          	jal	8000137e <sleep>
    if(log.committing){
    8000302c:	50dc                	lw	a5,36(s1)
    8000302e:	fbfd                	bnez	a5,80003024 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003030:	5098                	lw	a4,32(s1)
    80003032:	2705                	addiw	a4,a4,1
    80003034:	0027179b          	slliw	a5,a4,0x2
    80003038:	9fb9                	addw	a5,a5,a4
    8000303a:	0017979b          	slliw	a5,a5,0x1
    8000303e:	54d4                	lw	a3,44(s1)
    80003040:	9fb5                	addw	a5,a5,a3
    80003042:	00f95763          	bge	s2,a5,80003050 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003046:	85a6                	mv	a1,s1
    80003048:	8526                	mv	a0,s1
    8000304a:	b34fe0ef          	jal	8000137e <sleep>
    8000304e:	bff9                	j	8000302c <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003050:	00017517          	auipc	a0,0x17
    80003054:	40050513          	addi	a0,a0,1024 # 8001a450 <log>
    80003058:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000305a:	08f020ef          	jal	800058e8 <release>
      break;
    }
  }
}
    8000305e:	60e2                	ld	ra,24(sp)
    80003060:	6442                	ld	s0,16(sp)
    80003062:	64a2                	ld	s1,8(sp)
    80003064:	6902                	ld	s2,0(sp)
    80003066:	6105                	addi	sp,sp,32
    80003068:	8082                	ret

000000008000306a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000306a:	7139                	addi	sp,sp,-64
    8000306c:	fc06                	sd	ra,56(sp)
    8000306e:	f822                	sd	s0,48(sp)
    80003070:	f426                	sd	s1,40(sp)
    80003072:	f04a                	sd	s2,32(sp)
    80003074:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003076:	00017497          	auipc	s1,0x17
    8000307a:	3da48493          	addi	s1,s1,986 # 8001a450 <log>
    8000307e:	8526                	mv	a0,s1
    80003080:	7d0020ef          	jal	80005850 <acquire>
  log.outstanding -= 1;
    80003084:	509c                	lw	a5,32(s1)
    80003086:	37fd                	addiw	a5,a5,-1
    80003088:	0007891b          	sext.w	s2,a5
    8000308c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000308e:	50dc                	lw	a5,36(s1)
    80003090:	ef9d                	bnez	a5,800030ce <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003092:	04091763          	bnez	s2,800030e0 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003096:	00017497          	auipc	s1,0x17
    8000309a:	3ba48493          	addi	s1,s1,954 # 8001a450 <log>
    8000309e:	4785                	li	a5,1
    800030a0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800030a2:	8526                	mv	a0,s1
    800030a4:	045020ef          	jal	800058e8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800030a8:	54dc                	lw	a5,44(s1)
    800030aa:	04f04b63          	bgtz	a5,80003100 <end_op+0x96>
    acquire(&log.lock);
    800030ae:	00017497          	auipc	s1,0x17
    800030b2:	3a248493          	addi	s1,s1,930 # 8001a450 <log>
    800030b6:	8526                	mv	a0,s1
    800030b8:	798020ef          	jal	80005850 <acquire>
    log.committing = 0;
    800030bc:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800030c0:	8526                	mv	a0,s1
    800030c2:	b08fe0ef          	jal	800013ca <wakeup>
    release(&log.lock);
    800030c6:	8526                	mv	a0,s1
    800030c8:	021020ef          	jal	800058e8 <release>
}
    800030cc:	a025                	j	800030f4 <end_op+0x8a>
    800030ce:	ec4e                	sd	s3,24(sp)
    800030d0:	e852                	sd	s4,16(sp)
    800030d2:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800030d4:	00004517          	auipc	a0,0x4
    800030d8:	4f450513          	addi	a0,a0,1268 # 800075c8 <etext+0x5c8>
    800030dc:	446020ef          	jal	80005522 <panic>
    wakeup(&log);
    800030e0:	00017497          	auipc	s1,0x17
    800030e4:	37048493          	addi	s1,s1,880 # 8001a450 <log>
    800030e8:	8526                	mv	a0,s1
    800030ea:	ae0fe0ef          	jal	800013ca <wakeup>
  release(&log.lock);
    800030ee:	8526                	mv	a0,s1
    800030f0:	7f8020ef          	jal	800058e8 <release>
}
    800030f4:	70e2                	ld	ra,56(sp)
    800030f6:	7442                	ld	s0,48(sp)
    800030f8:	74a2                	ld	s1,40(sp)
    800030fa:	7902                	ld	s2,32(sp)
    800030fc:	6121                	addi	sp,sp,64
    800030fe:	8082                	ret
    80003100:	ec4e                	sd	s3,24(sp)
    80003102:	e852                	sd	s4,16(sp)
    80003104:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003106:	00017a97          	auipc	s5,0x17
    8000310a:	37aa8a93          	addi	s5,s5,890 # 8001a480 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000310e:	00017a17          	auipc	s4,0x17
    80003112:	342a0a13          	addi	s4,s4,834 # 8001a450 <log>
    80003116:	018a2583          	lw	a1,24(s4)
    8000311a:	012585bb          	addw	a1,a1,s2
    8000311e:	2585                	addiw	a1,a1,1
    80003120:	028a2503          	lw	a0,40(s4)
    80003124:	f0ffe0ef          	jal	80002032 <bread>
    80003128:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000312a:	000aa583          	lw	a1,0(s5)
    8000312e:	028a2503          	lw	a0,40(s4)
    80003132:	f01fe0ef          	jal	80002032 <bread>
    80003136:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003138:	40000613          	li	a2,1024
    8000313c:	05850593          	addi	a1,a0,88
    80003140:	05848513          	addi	a0,s1,88
    80003144:	8a8fd0ef          	jal	800001ec <memmove>
    bwrite(to);  // write the log
    80003148:	8526                	mv	a0,s1
    8000314a:	fbffe0ef          	jal	80002108 <bwrite>
    brelse(from);
    8000314e:	854e                	mv	a0,s3
    80003150:	febfe0ef          	jal	8000213a <brelse>
    brelse(to);
    80003154:	8526                	mv	a0,s1
    80003156:	fe5fe0ef          	jal	8000213a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000315a:	2905                	addiw	s2,s2,1
    8000315c:	0a91                	addi	s5,s5,4
    8000315e:	02ca2783          	lw	a5,44(s4)
    80003162:	faf94ae3          	blt	s2,a5,80003116 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003166:	d11ff0ef          	jal	80002e76 <write_head>
    install_trans(0); // Now install writes to home locations
    8000316a:	4501                	li	a0,0
    8000316c:	d69ff0ef          	jal	80002ed4 <install_trans>
    log.lh.n = 0;
    80003170:	00017797          	auipc	a5,0x17
    80003174:	3007a623          	sw	zero,780(a5) # 8001a47c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003178:	cffff0ef          	jal	80002e76 <write_head>
    8000317c:	69e2                	ld	s3,24(sp)
    8000317e:	6a42                	ld	s4,16(sp)
    80003180:	6aa2                	ld	s5,8(sp)
    80003182:	b735                	j	800030ae <end_op+0x44>

0000000080003184 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003184:	1101                	addi	sp,sp,-32
    80003186:	ec06                	sd	ra,24(sp)
    80003188:	e822                	sd	s0,16(sp)
    8000318a:	e426                	sd	s1,8(sp)
    8000318c:	e04a                	sd	s2,0(sp)
    8000318e:	1000                	addi	s0,sp,32
    80003190:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003192:	00017917          	auipc	s2,0x17
    80003196:	2be90913          	addi	s2,s2,702 # 8001a450 <log>
    8000319a:	854a                	mv	a0,s2
    8000319c:	6b4020ef          	jal	80005850 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800031a0:	02c92603          	lw	a2,44(s2)
    800031a4:	47f5                	li	a5,29
    800031a6:	06c7c363          	blt	a5,a2,8000320c <log_write+0x88>
    800031aa:	00017797          	auipc	a5,0x17
    800031ae:	2c27a783          	lw	a5,706(a5) # 8001a46c <log+0x1c>
    800031b2:	37fd                	addiw	a5,a5,-1
    800031b4:	04f65c63          	bge	a2,a5,8000320c <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800031b8:	00017797          	auipc	a5,0x17
    800031bc:	2b87a783          	lw	a5,696(a5) # 8001a470 <log+0x20>
    800031c0:	04f05c63          	blez	a5,80003218 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031c4:	4781                	li	a5,0
    800031c6:	04c05f63          	blez	a2,80003224 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031ca:	44cc                	lw	a1,12(s1)
    800031cc:	00017717          	auipc	a4,0x17
    800031d0:	2b470713          	addi	a4,a4,692 # 8001a480 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800031d4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031d6:	4314                	lw	a3,0(a4)
    800031d8:	04b68663          	beq	a3,a1,80003224 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800031dc:	2785                	addiw	a5,a5,1
    800031de:	0711                	addi	a4,a4,4
    800031e0:	fef61be3          	bne	a2,a5,800031d6 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800031e4:	0621                	addi	a2,a2,8
    800031e6:	060a                	slli	a2,a2,0x2
    800031e8:	00017797          	auipc	a5,0x17
    800031ec:	26878793          	addi	a5,a5,616 # 8001a450 <log>
    800031f0:	97b2                	add	a5,a5,a2
    800031f2:	44d8                	lw	a4,12(s1)
    800031f4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800031f6:	8526                	mv	a0,s1
    800031f8:	fcbfe0ef          	jal	800021c2 <bpin>
    log.lh.n++;
    800031fc:	00017717          	auipc	a4,0x17
    80003200:	25470713          	addi	a4,a4,596 # 8001a450 <log>
    80003204:	575c                	lw	a5,44(a4)
    80003206:	2785                	addiw	a5,a5,1
    80003208:	d75c                	sw	a5,44(a4)
    8000320a:	a80d                	j	8000323c <log_write+0xb8>
    panic("too big a transaction");
    8000320c:	00004517          	auipc	a0,0x4
    80003210:	3cc50513          	addi	a0,a0,972 # 800075d8 <etext+0x5d8>
    80003214:	30e020ef          	jal	80005522 <panic>
    panic("log_write outside of trans");
    80003218:	00004517          	auipc	a0,0x4
    8000321c:	3d850513          	addi	a0,a0,984 # 800075f0 <etext+0x5f0>
    80003220:	302020ef          	jal	80005522 <panic>
  log.lh.block[i] = b->blockno;
    80003224:	00878693          	addi	a3,a5,8
    80003228:	068a                	slli	a3,a3,0x2
    8000322a:	00017717          	auipc	a4,0x17
    8000322e:	22670713          	addi	a4,a4,550 # 8001a450 <log>
    80003232:	9736                	add	a4,a4,a3
    80003234:	44d4                	lw	a3,12(s1)
    80003236:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003238:	faf60fe3          	beq	a2,a5,800031f6 <log_write+0x72>
  }
  release(&log.lock);
    8000323c:	00017517          	auipc	a0,0x17
    80003240:	21450513          	addi	a0,a0,532 # 8001a450 <log>
    80003244:	6a4020ef          	jal	800058e8 <release>
}
    80003248:	60e2                	ld	ra,24(sp)
    8000324a:	6442                	ld	s0,16(sp)
    8000324c:	64a2                	ld	s1,8(sp)
    8000324e:	6902                	ld	s2,0(sp)
    80003250:	6105                	addi	sp,sp,32
    80003252:	8082                	ret

0000000080003254 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003254:	1101                	addi	sp,sp,-32
    80003256:	ec06                	sd	ra,24(sp)
    80003258:	e822                	sd	s0,16(sp)
    8000325a:	e426                	sd	s1,8(sp)
    8000325c:	e04a                	sd	s2,0(sp)
    8000325e:	1000                	addi	s0,sp,32
    80003260:	84aa                	mv	s1,a0
    80003262:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003264:	00004597          	auipc	a1,0x4
    80003268:	3ac58593          	addi	a1,a1,940 # 80007610 <etext+0x610>
    8000326c:	0521                	addi	a0,a0,8
    8000326e:	562020ef          	jal	800057d0 <initlock>
  lk->name = name;
    80003272:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003276:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000327a:	0204a423          	sw	zero,40(s1)
}
    8000327e:	60e2                	ld	ra,24(sp)
    80003280:	6442                	ld	s0,16(sp)
    80003282:	64a2                	ld	s1,8(sp)
    80003284:	6902                	ld	s2,0(sp)
    80003286:	6105                	addi	sp,sp,32
    80003288:	8082                	ret

000000008000328a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000328a:	1101                	addi	sp,sp,-32
    8000328c:	ec06                	sd	ra,24(sp)
    8000328e:	e822                	sd	s0,16(sp)
    80003290:	e426                	sd	s1,8(sp)
    80003292:	e04a                	sd	s2,0(sp)
    80003294:	1000                	addi	s0,sp,32
    80003296:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003298:	00850913          	addi	s2,a0,8
    8000329c:	854a                	mv	a0,s2
    8000329e:	5b2020ef          	jal	80005850 <acquire>
  while (lk->locked) {
    800032a2:	409c                	lw	a5,0(s1)
    800032a4:	c799                	beqz	a5,800032b2 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800032a6:	85ca                	mv	a1,s2
    800032a8:	8526                	mv	a0,s1
    800032aa:	8d4fe0ef          	jal	8000137e <sleep>
  while (lk->locked) {
    800032ae:	409c                	lw	a5,0(s1)
    800032b0:	fbfd                	bnez	a5,800032a6 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800032b2:	4785                	li	a5,1
    800032b4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800032b6:	af3fd0ef          	jal	80000da8 <myproc>
    800032ba:	591c                	lw	a5,48(a0)
    800032bc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032be:	854a                	mv	a0,s2
    800032c0:	628020ef          	jal	800058e8 <release>
}
    800032c4:	60e2                	ld	ra,24(sp)
    800032c6:	6442                	ld	s0,16(sp)
    800032c8:	64a2                	ld	s1,8(sp)
    800032ca:	6902                	ld	s2,0(sp)
    800032cc:	6105                	addi	sp,sp,32
    800032ce:	8082                	ret

00000000800032d0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800032d0:	1101                	addi	sp,sp,-32
    800032d2:	ec06                	sd	ra,24(sp)
    800032d4:	e822                	sd	s0,16(sp)
    800032d6:	e426                	sd	s1,8(sp)
    800032d8:	e04a                	sd	s2,0(sp)
    800032da:	1000                	addi	s0,sp,32
    800032dc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032de:	00850913          	addi	s2,a0,8
    800032e2:	854a                	mv	a0,s2
    800032e4:	56c020ef          	jal	80005850 <acquire>
  lk->locked = 0;
    800032e8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032ec:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800032f0:	8526                	mv	a0,s1
    800032f2:	8d8fe0ef          	jal	800013ca <wakeup>
  release(&lk->lk);
    800032f6:	854a                	mv	a0,s2
    800032f8:	5f0020ef          	jal	800058e8 <release>
}
    800032fc:	60e2                	ld	ra,24(sp)
    800032fe:	6442                	ld	s0,16(sp)
    80003300:	64a2                	ld	s1,8(sp)
    80003302:	6902                	ld	s2,0(sp)
    80003304:	6105                	addi	sp,sp,32
    80003306:	8082                	ret

0000000080003308 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003308:	7179                	addi	sp,sp,-48
    8000330a:	f406                	sd	ra,40(sp)
    8000330c:	f022                	sd	s0,32(sp)
    8000330e:	ec26                	sd	s1,24(sp)
    80003310:	e84a                	sd	s2,16(sp)
    80003312:	1800                	addi	s0,sp,48
    80003314:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003316:	00850913          	addi	s2,a0,8
    8000331a:	854a                	mv	a0,s2
    8000331c:	534020ef          	jal	80005850 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003320:	409c                	lw	a5,0(s1)
    80003322:	ef81                	bnez	a5,8000333a <holdingsleep+0x32>
    80003324:	4481                	li	s1,0
  release(&lk->lk);
    80003326:	854a                	mv	a0,s2
    80003328:	5c0020ef          	jal	800058e8 <release>
  return r;
}
    8000332c:	8526                	mv	a0,s1
    8000332e:	70a2                	ld	ra,40(sp)
    80003330:	7402                	ld	s0,32(sp)
    80003332:	64e2                	ld	s1,24(sp)
    80003334:	6942                	ld	s2,16(sp)
    80003336:	6145                	addi	sp,sp,48
    80003338:	8082                	ret
    8000333a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000333c:	0284a983          	lw	s3,40(s1)
    80003340:	a69fd0ef          	jal	80000da8 <myproc>
    80003344:	5904                	lw	s1,48(a0)
    80003346:	413484b3          	sub	s1,s1,s3
    8000334a:	0014b493          	seqz	s1,s1
    8000334e:	69a2                	ld	s3,8(sp)
    80003350:	bfd9                	j	80003326 <holdingsleep+0x1e>

0000000080003352 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003352:	1141                	addi	sp,sp,-16
    80003354:	e406                	sd	ra,8(sp)
    80003356:	e022                	sd	s0,0(sp)
    80003358:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000335a:	00004597          	auipc	a1,0x4
    8000335e:	2c658593          	addi	a1,a1,710 # 80007620 <etext+0x620>
    80003362:	00017517          	auipc	a0,0x17
    80003366:	23650513          	addi	a0,a0,566 # 8001a598 <ftable>
    8000336a:	466020ef          	jal	800057d0 <initlock>
}
    8000336e:	60a2                	ld	ra,8(sp)
    80003370:	6402                	ld	s0,0(sp)
    80003372:	0141                	addi	sp,sp,16
    80003374:	8082                	ret

0000000080003376 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003376:	1101                	addi	sp,sp,-32
    80003378:	ec06                	sd	ra,24(sp)
    8000337a:	e822                	sd	s0,16(sp)
    8000337c:	e426                	sd	s1,8(sp)
    8000337e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003380:	00017517          	auipc	a0,0x17
    80003384:	21850513          	addi	a0,a0,536 # 8001a598 <ftable>
    80003388:	4c8020ef          	jal	80005850 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000338c:	00017497          	auipc	s1,0x17
    80003390:	22448493          	addi	s1,s1,548 # 8001a5b0 <ftable+0x18>
    80003394:	00018717          	auipc	a4,0x18
    80003398:	1bc70713          	addi	a4,a4,444 # 8001b550 <disk>
    if(f->ref == 0){
    8000339c:	40dc                	lw	a5,4(s1)
    8000339e:	cf89                	beqz	a5,800033b8 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033a0:	02848493          	addi	s1,s1,40
    800033a4:	fee49ce3          	bne	s1,a4,8000339c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800033a8:	00017517          	auipc	a0,0x17
    800033ac:	1f050513          	addi	a0,a0,496 # 8001a598 <ftable>
    800033b0:	538020ef          	jal	800058e8 <release>
  return 0;
    800033b4:	4481                	li	s1,0
    800033b6:	a809                	j	800033c8 <filealloc+0x52>
      f->ref = 1;
    800033b8:	4785                	li	a5,1
    800033ba:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033bc:	00017517          	auipc	a0,0x17
    800033c0:	1dc50513          	addi	a0,a0,476 # 8001a598 <ftable>
    800033c4:	524020ef          	jal	800058e8 <release>
}
    800033c8:	8526                	mv	a0,s1
    800033ca:	60e2                	ld	ra,24(sp)
    800033cc:	6442                	ld	s0,16(sp)
    800033ce:	64a2                	ld	s1,8(sp)
    800033d0:	6105                	addi	sp,sp,32
    800033d2:	8082                	ret

00000000800033d4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800033d4:	1101                	addi	sp,sp,-32
    800033d6:	ec06                	sd	ra,24(sp)
    800033d8:	e822                	sd	s0,16(sp)
    800033da:	e426                	sd	s1,8(sp)
    800033dc:	1000                	addi	s0,sp,32
    800033de:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800033e0:	00017517          	auipc	a0,0x17
    800033e4:	1b850513          	addi	a0,a0,440 # 8001a598 <ftable>
    800033e8:	468020ef          	jal	80005850 <acquire>
  if(f->ref < 1)
    800033ec:	40dc                	lw	a5,4(s1)
    800033ee:	02f05063          	blez	a5,8000340e <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800033f2:	2785                	addiw	a5,a5,1
    800033f4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800033f6:	00017517          	auipc	a0,0x17
    800033fa:	1a250513          	addi	a0,a0,418 # 8001a598 <ftable>
    800033fe:	4ea020ef          	jal	800058e8 <release>
  return f;
}
    80003402:	8526                	mv	a0,s1
    80003404:	60e2                	ld	ra,24(sp)
    80003406:	6442                	ld	s0,16(sp)
    80003408:	64a2                	ld	s1,8(sp)
    8000340a:	6105                	addi	sp,sp,32
    8000340c:	8082                	ret
    panic("filedup");
    8000340e:	00004517          	auipc	a0,0x4
    80003412:	21a50513          	addi	a0,a0,538 # 80007628 <etext+0x628>
    80003416:	10c020ef          	jal	80005522 <panic>

000000008000341a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000341a:	7139                	addi	sp,sp,-64
    8000341c:	fc06                	sd	ra,56(sp)
    8000341e:	f822                	sd	s0,48(sp)
    80003420:	f426                	sd	s1,40(sp)
    80003422:	0080                	addi	s0,sp,64
    80003424:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003426:	00017517          	auipc	a0,0x17
    8000342a:	17250513          	addi	a0,a0,370 # 8001a598 <ftable>
    8000342e:	422020ef          	jal	80005850 <acquire>
  if(f->ref < 1)
    80003432:	40dc                	lw	a5,4(s1)
    80003434:	04f05a63          	blez	a5,80003488 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003438:	37fd                	addiw	a5,a5,-1
    8000343a:	0007871b          	sext.w	a4,a5
    8000343e:	c0dc                	sw	a5,4(s1)
    80003440:	04e04e63          	bgtz	a4,8000349c <fileclose+0x82>
    80003444:	f04a                	sd	s2,32(sp)
    80003446:	ec4e                	sd	s3,24(sp)
    80003448:	e852                	sd	s4,16(sp)
    8000344a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000344c:	0004a903          	lw	s2,0(s1)
    80003450:	0094ca83          	lbu	s5,9(s1)
    80003454:	0104ba03          	ld	s4,16(s1)
    80003458:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000345c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003460:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003464:	00017517          	auipc	a0,0x17
    80003468:	13450513          	addi	a0,a0,308 # 8001a598 <ftable>
    8000346c:	47c020ef          	jal	800058e8 <release>

  if(ff.type == FD_PIPE){
    80003470:	4785                	li	a5,1
    80003472:	04f90063          	beq	s2,a5,800034b2 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003476:	3979                	addiw	s2,s2,-2
    80003478:	4785                	li	a5,1
    8000347a:	0527f563          	bgeu	a5,s2,800034c4 <fileclose+0xaa>
    8000347e:	7902                	ld	s2,32(sp)
    80003480:	69e2                	ld	s3,24(sp)
    80003482:	6a42                	ld	s4,16(sp)
    80003484:	6aa2                	ld	s5,8(sp)
    80003486:	a00d                	j	800034a8 <fileclose+0x8e>
    80003488:	f04a                	sd	s2,32(sp)
    8000348a:	ec4e                	sd	s3,24(sp)
    8000348c:	e852                	sd	s4,16(sp)
    8000348e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003490:	00004517          	auipc	a0,0x4
    80003494:	1a050513          	addi	a0,a0,416 # 80007630 <etext+0x630>
    80003498:	08a020ef          	jal	80005522 <panic>
    release(&ftable.lock);
    8000349c:	00017517          	auipc	a0,0x17
    800034a0:	0fc50513          	addi	a0,a0,252 # 8001a598 <ftable>
    800034a4:	444020ef          	jal	800058e8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800034a8:	70e2                	ld	ra,56(sp)
    800034aa:	7442                	ld	s0,48(sp)
    800034ac:	74a2                	ld	s1,40(sp)
    800034ae:	6121                	addi	sp,sp,64
    800034b0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800034b2:	85d6                	mv	a1,s5
    800034b4:	8552                	mv	a0,s4
    800034b6:	336000ef          	jal	800037ec <pipeclose>
    800034ba:	7902                	ld	s2,32(sp)
    800034bc:	69e2                	ld	s3,24(sp)
    800034be:	6a42                	ld	s4,16(sp)
    800034c0:	6aa2                	ld	s5,8(sp)
    800034c2:	b7dd                	j	800034a8 <fileclose+0x8e>
    begin_op();
    800034c4:	b3dff0ef          	jal	80003000 <begin_op>
    iput(ff.ip);
    800034c8:	854e                	mv	a0,s3
    800034ca:	c22ff0ef          	jal	800028ec <iput>
    end_op();
    800034ce:	b9dff0ef          	jal	8000306a <end_op>
    800034d2:	7902                	ld	s2,32(sp)
    800034d4:	69e2                	ld	s3,24(sp)
    800034d6:	6a42                	ld	s4,16(sp)
    800034d8:	6aa2                	ld	s5,8(sp)
    800034da:	b7f9                	j	800034a8 <fileclose+0x8e>

00000000800034dc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800034dc:	715d                	addi	sp,sp,-80
    800034de:	e486                	sd	ra,72(sp)
    800034e0:	e0a2                	sd	s0,64(sp)
    800034e2:	fc26                	sd	s1,56(sp)
    800034e4:	f44e                	sd	s3,40(sp)
    800034e6:	0880                	addi	s0,sp,80
    800034e8:	84aa                	mv	s1,a0
    800034ea:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800034ec:	8bdfd0ef          	jal	80000da8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800034f0:	409c                	lw	a5,0(s1)
    800034f2:	37f9                	addiw	a5,a5,-2
    800034f4:	4705                	li	a4,1
    800034f6:	04f76063          	bltu	a4,a5,80003536 <filestat+0x5a>
    800034fa:	f84a                	sd	s2,48(sp)
    800034fc:	892a                	mv	s2,a0
    ilock(f->ip);
    800034fe:	6c88                	ld	a0,24(s1)
    80003500:	a6aff0ef          	jal	8000276a <ilock>
    stati(f->ip, &st);
    80003504:	fb840593          	addi	a1,s0,-72
    80003508:	6c88                	ld	a0,24(s1)
    8000350a:	c8aff0ef          	jal	80002994 <stati>
    iunlock(f->ip);
    8000350e:	6c88                	ld	a0,24(s1)
    80003510:	b08ff0ef          	jal	80002818 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003514:	46e1                	li	a3,24
    80003516:	fb840613          	addi	a2,s0,-72
    8000351a:	85ce                	mv	a1,s3
    8000351c:	05093503          	ld	a0,80(s2)
    80003520:	cfafd0ef          	jal	80000a1a <copyout>
    80003524:	41f5551b          	sraiw	a0,a0,0x1f
    80003528:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000352a:	60a6                	ld	ra,72(sp)
    8000352c:	6406                	ld	s0,64(sp)
    8000352e:	74e2                	ld	s1,56(sp)
    80003530:	79a2                	ld	s3,40(sp)
    80003532:	6161                	addi	sp,sp,80
    80003534:	8082                	ret
  return -1;
    80003536:	557d                	li	a0,-1
    80003538:	bfcd                	j	8000352a <filestat+0x4e>

000000008000353a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000353a:	7179                	addi	sp,sp,-48
    8000353c:	f406                	sd	ra,40(sp)
    8000353e:	f022                	sd	s0,32(sp)
    80003540:	e84a                	sd	s2,16(sp)
    80003542:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003544:	00854783          	lbu	a5,8(a0)
    80003548:	cfd1                	beqz	a5,800035e4 <fileread+0xaa>
    8000354a:	ec26                	sd	s1,24(sp)
    8000354c:	e44e                	sd	s3,8(sp)
    8000354e:	84aa                	mv	s1,a0
    80003550:	89ae                	mv	s3,a1
    80003552:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003554:	411c                	lw	a5,0(a0)
    80003556:	4705                	li	a4,1
    80003558:	04e78363          	beq	a5,a4,8000359e <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000355c:	470d                	li	a4,3
    8000355e:	04e78763          	beq	a5,a4,800035ac <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003562:	4709                	li	a4,2
    80003564:	06e79a63          	bne	a5,a4,800035d8 <fileread+0x9e>
    ilock(f->ip);
    80003568:	6d08                	ld	a0,24(a0)
    8000356a:	a00ff0ef          	jal	8000276a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000356e:	874a                	mv	a4,s2
    80003570:	5094                	lw	a3,32(s1)
    80003572:	864e                	mv	a2,s3
    80003574:	4585                	li	a1,1
    80003576:	6c88                	ld	a0,24(s1)
    80003578:	c46ff0ef          	jal	800029be <readi>
    8000357c:	892a                	mv	s2,a0
    8000357e:	00a05563          	blez	a0,80003588 <fileread+0x4e>
      f->off += r;
    80003582:	509c                	lw	a5,32(s1)
    80003584:	9fa9                	addw	a5,a5,a0
    80003586:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003588:	6c88                	ld	a0,24(s1)
    8000358a:	a8eff0ef          	jal	80002818 <iunlock>
    8000358e:	64e2                	ld	s1,24(sp)
    80003590:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003592:	854a                	mv	a0,s2
    80003594:	70a2                	ld	ra,40(sp)
    80003596:	7402                	ld	s0,32(sp)
    80003598:	6942                	ld	s2,16(sp)
    8000359a:	6145                	addi	sp,sp,48
    8000359c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000359e:	6908                	ld	a0,16(a0)
    800035a0:	388000ef          	jal	80003928 <piperead>
    800035a4:	892a                	mv	s2,a0
    800035a6:	64e2                	ld	s1,24(sp)
    800035a8:	69a2                	ld	s3,8(sp)
    800035aa:	b7e5                	j	80003592 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800035ac:	02451783          	lh	a5,36(a0)
    800035b0:	03079693          	slli	a3,a5,0x30
    800035b4:	92c1                	srli	a3,a3,0x30
    800035b6:	4725                	li	a4,9
    800035b8:	02d76863          	bltu	a4,a3,800035e8 <fileread+0xae>
    800035bc:	0792                	slli	a5,a5,0x4
    800035be:	00017717          	auipc	a4,0x17
    800035c2:	f3a70713          	addi	a4,a4,-198 # 8001a4f8 <devsw>
    800035c6:	97ba                	add	a5,a5,a4
    800035c8:	639c                	ld	a5,0(a5)
    800035ca:	c39d                	beqz	a5,800035f0 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800035cc:	4505                	li	a0,1
    800035ce:	9782                	jalr	a5
    800035d0:	892a                	mv	s2,a0
    800035d2:	64e2                	ld	s1,24(sp)
    800035d4:	69a2                	ld	s3,8(sp)
    800035d6:	bf75                	j	80003592 <fileread+0x58>
    panic("fileread");
    800035d8:	00004517          	auipc	a0,0x4
    800035dc:	06850513          	addi	a0,a0,104 # 80007640 <etext+0x640>
    800035e0:	743010ef          	jal	80005522 <panic>
    return -1;
    800035e4:	597d                	li	s2,-1
    800035e6:	b775                	j	80003592 <fileread+0x58>
      return -1;
    800035e8:	597d                	li	s2,-1
    800035ea:	64e2                	ld	s1,24(sp)
    800035ec:	69a2                	ld	s3,8(sp)
    800035ee:	b755                	j	80003592 <fileread+0x58>
    800035f0:	597d                	li	s2,-1
    800035f2:	64e2                	ld	s1,24(sp)
    800035f4:	69a2                	ld	s3,8(sp)
    800035f6:	bf71                	j	80003592 <fileread+0x58>

00000000800035f8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800035f8:	00954783          	lbu	a5,9(a0)
    800035fc:	10078b63          	beqz	a5,80003712 <filewrite+0x11a>
{
    80003600:	715d                	addi	sp,sp,-80
    80003602:	e486                	sd	ra,72(sp)
    80003604:	e0a2                	sd	s0,64(sp)
    80003606:	f84a                	sd	s2,48(sp)
    80003608:	f052                	sd	s4,32(sp)
    8000360a:	e85a                	sd	s6,16(sp)
    8000360c:	0880                	addi	s0,sp,80
    8000360e:	892a                	mv	s2,a0
    80003610:	8b2e                	mv	s6,a1
    80003612:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003614:	411c                	lw	a5,0(a0)
    80003616:	4705                	li	a4,1
    80003618:	02e78763          	beq	a5,a4,80003646 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000361c:	470d                	li	a4,3
    8000361e:	02e78863          	beq	a5,a4,8000364e <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003622:	4709                	li	a4,2
    80003624:	0ce79c63          	bne	a5,a4,800036fc <filewrite+0x104>
    80003628:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000362a:	0ac05863          	blez	a2,800036da <filewrite+0xe2>
    8000362e:	fc26                	sd	s1,56(sp)
    80003630:	ec56                	sd	s5,24(sp)
    80003632:	e45e                	sd	s7,8(sp)
    80003634:	e062                	sd	s8,0(sp)
    int i = 0;
    80003636:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003638:	6b85                	lui	s7,0x1
    8000363a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000363e:	6c05                	lui	s8,0x1
    80003640:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003644:	a8b5                	j	800036c0 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003646:	6908                	ld	a0,16(a0)
    80003648:	1fc000ef          	jal	80003844 <pipewrite>
    8000364c:	a04d                	j	800036ee <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000364e:	02451783          	lh	a5,36(a0)
    80003652:	03079693          	slli	a3,a5,0x30
    80003656:	92c1                	srli	a3,a3,0x30
    80003658:	4725                	li	a4,9
    8000365a:	0ad76e63          	bltu	a4,a3,80003716 <filewrite+0x11e>
    8000365e:	0792                	slli	a5,a5,0x4
    80003660:	00017717          	auipc	a4,0x17
    80003664:	e9870713          	addi	a4,a4,-360 # 8001a4f8 <devsw>
    80003668:	97ba                	add	a5,a5,a4
    8000366a:	679c                	ld	a5,8(a5)
    8000366c:	c7dd                	beqz	a5,8000371a <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000366e:	4505                	li	a0,1
    80003670:	9782                	jalr	a5
    80003672:	a8b5                	j	800036ee <filewrite+0xf6>
      if(n1 > max)
    80003674:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003678:	989ff0ef          	jal	80003000 <begin_op>
      ilock(f->ip);
    8000367c:	01893503          	ld	a0,24(s2)
    80003680:	8eaff0ef          	jal	8000276a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003684:	8756                	mv	a4,s5
    80003686:	02092683          	lw	a3,32(s2)
    8000368a:	01698633          	add	a2,s3,s6
    8000368e:	4585                	li	a1,1
    80003690:	01893503          	ld	a0,24(s2)
    80003694:	c26ff0ef          	jal	80002aba <writei>
    80003698:	84aa                	mv	s1,a0
    8000369a:	00a05763          	blez	a0,800036a8 <filewrite+0xb0>
        f->off += r;
    8000369e:	02092783          	lw	a5,32(s2)
    800036a2:	9fa9                	addw	a5,a5,a0
    800036a4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800036a8:	01893503          	ld	a0,24(s2)
    800036ac:	96cff0ef          	jal	80002818 <iunlock>
      end_op();
    800036b0:	9bbff0ef          	jal	8000306a <end_op>

      if(r != n1){
    800036b4:	029a9563          	bne	s5,s1,800036de <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800036b8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800036bc:	0149da63          	bge	s3,s4,800036d0 <filewrite+0xd8>
      int n1 = n - i;
    800036c0:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800036c4:	0004879b          	sext.w	a5,s1
    800036c8:	fafbd6e3          	bge	s7,a5,80003674 <filewrite+0x7c>
    800036cc:	84e2                	mv	s1,s8
    800036ce:	b75d                	j	80003674 <filewrite+0x7c>
    800036d0:	74e2                	ld	s1,56(sp)
    800036d2:	6ae2                	ld	s5,24(sp)
    800036d4:	6ba2                	ld	s7,8(sp)
    800036d6:	6c02                	ld	s8,0(sp)
    800036d8:	a039                	j	800036e6 <filewrite+0xee>
    int i = 0;
    800036da:	4981                	li	s3,0
    800036dc:	a029                	j	800036e6 <filewrite+0xee>
    800036de:	74e2                	ld	s1,56(sp)
    800036e0:	6ae2                	ld	s5,24(sp)
    800036e2:	6ba2                	ld	s7,8(sp)
    800036e4:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800036e6:	033a1c63          	bne	s4,s3,8000371e <filewrite+0x126>
    800036ea:	8552                	mv	a0,s4
    800036ec:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800036ee:	60a6                	ld	ra,72(sp)
    800036f0:	6406                	ld	s0,64(sp)
    800036f2:	7942                	ld	s2,48(sp)
    800036f4:	7a02                	ld	s4,32(sp)
    800036f6:	6b42                	ld	s6,16(sp)
    800036f8:	6161                	addi	sp,sp,80
    800036fa:	8082                	ret
    800036fc:	fc26                	sd	s1,56(sp)
    800036fe:	f44e                	sd	s3,40(sp)
    80003700:	ec56                	sd	s5,24(sp)
    80003702:	e45e                	sd	s7,8(sp)
    80003704:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003706:	00004517          	auipc	a0,0x4
    8000370a:	f4a50513          	addi	a0,a0,-182 # 80007650 <etext+0x650>
    8000370e:	615010ef          	jal	80005522 <panic>
    return -1;
    80003712:	557d                	li	a0,-1
}
    80003714:	8082                	ret
      return -1;
    80003716:	557d                	li	a0,-1
    80003718:	bfd9                	j	800036ee <filewrite+0xf6>
    8000371a:	557d                	li	a0,-1
    8000371c:	bfc9                	j	800036ee <filewrite+0xf6>
    ret = (i == n ? n : -1);
    8000371e:	557d                	li	a0,-1
    80003720:	79a2                	ld	s3,40(sp)
    80003722:	b7f1                	j	800036ee <filewrite+0xf6>

0000000080003724 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003724:	7179                	addi	sp,sp,-48
    80003726:	f406                	sd	ra,40(sp)
    80003728:	f022                	sd	s0,32(sp)
    8000372a:	ec26                	sd	s1,24(sp)
    8000372c:	e052                	sd	s4,0(sp)
    8000372e:	1800                	addi	s0,sp,48
    80003730:	84aa                	mv	s1,a0
    80003732:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003734:	0005b023          	sd	zero,0(a1)
    80003738:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000373c:	c3bff0ef          	jal	80003376 <filealloc>
    80003740:	e088                	sd	a0,0(s1)
    80003742:	c549                	beqz	a0,800037cc <pipealloc+0xa8>
    80003744:	c33ff0ef          	jal	80003376 <filealloc>
    80003748:	00aa3023          	sd	a0,0(s4)
    8000374c:	cd25                	beqz	a0,800037c4 <pipealloc+0xa0>
    8000374e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003750:	9affc0ef          	jal	800000fe <kalloc>
    80003754:	892a                	mv	s2,a0
    80003756:	c12d                	beqz	a0,800037b8 <pipealloc+0x94>
    80003758:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000375a:	4985                	li	s3,1
    8000375c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003760:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003764:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003768:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000376c:	00004597          	auipc	a1,0x4
    80003770:	c9458593          	addi	a1,a1,-876 # 80007400 <etext+0x400>
    80003774:	05c020ef          	jal	800057d0 <initlock>
  (*f0)->type = FD_PIPE;
    80003778:	609c                	ld	a5,0(s1)
    8000377a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000377e:	609c                	ld	a5,0(s1)
    80003780:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003784:	609c                	ld	a5,0(s1)
    80003786:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000378a:	609c                	ld	a5,0(s1)
    8000378c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003790:	000a3783          	ld	a5,0(s4)
    80003794:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003798:	000a3783          	ld	a5,0(s4)
    8000379c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800037a0:	000a3783          	ld	a5,0(s4)
    800037a4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800037a8:	000a3783          	ld	a5,0(s4)
    800037ac:	0127b823          	sd	s2,16(a5)
  return 0;
    800037b0:	4501                	li	a0,0
    800037b2:	6942                	ld	s2,16(sp)
    800037b4:	69a2                	ld	s3,8(sp)
    800037b6:	a01d                	j	800037dc <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800037b8:	6088                	ld	a0,0(s1)
    800037ba:	c119                	beqz	a0,800037c0 <pipealloc+0x9c>
    800037bc:	6942                	ld	s2,16(sp)
    800037be:	a029                	j	800037c8 <pipealloc+0xa4>
    800037c0:	6942                	ld	s2,16(sp)
    800037c2:	a029                	j	800037cc <pipealloc+0xa8>
    800037c4:	6088                	ld	a0,0(s1)
    800037c6:	c10d                	beqz	a0,800037e8 <pipealloc+0xc4>
    fileclose(*f0);
    800037c8:	c53ff0ef          	jal	8000341a <fileclose>
  if(*f1)
    800037cc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800037d0:	557d                	li	a0,-1
  if(*f1)
    800037d2:	c789                	beqz	a5,800037dc <pipealloc+0xb8>
    fileclose(*f1);
    800037d4:	853e                	mv	a0,a5
    800037d6:	c45ff0ef          	jal	8000341a <fileclose>
  return -1;
    800037da:	557d                	li	a0,-1
}
    800037dc:	70a2                	ld	ra,40(sp)
    800037de:	7402                	ld	s0,32(sp)
    800037e0:	64e2                	ld	s1,24(sp)
    800037e2:	6a02                	ld	s4,0(sp)
    800037e4:	6145                	addi	sp,sp,48
    800037e6:	8082                	ret
  return -1;
    800037e8:	557d                	li	a0,-1
    800037ea:	bfcd                	j	800037dc <pipealloc+0xb8>

00000000800037ec <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800037ec:	1101                	addi	sp,sp,-32
    800037ee:	ec06                	sd	ra,24(sp)
    800037f0:	e822                	sd	s0,16(sp)
    800037f2:	e426                	sd	s1,8(sp)
    800037f4:	e04a                	sd	s2,0(sp)
    800037f6:	1000                	addi	s0,sp,32
    800037f8:	84aa                	mv	s1,a0
    800037fa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800037fc:	054020ef          	jal	80005850 <acquire>
  if(writable){
    80003800:	02090763          	beqz	s2,8000382e <pipeclose+0x42>
    pi->writeopen = 0;
    80003804:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003808:	21848513          	addi	a0,s1,536
    8000380c:	bbffd0ef          	jal	800013ca <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003810:	2204b783          	ld	a5,544(s1)
    80003814:	e785                	bnez	a5,8000383c <pipeclose+0x50>
    release(&pi->lock);
    80003816:	8526                	mv	a0,s1
    80003818:	0d0020ef          	jal	800058e8 <release>
    kfree((char*)pi);
    8000381c:	8526                	mv	a0,s1
    8000381e:	ffefc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003822:	60e2                	ld	ra,24(sp)
    80003824:	6442                	ld	s0,16(sp)
    80003826:	64a2                	ld	s1,8(sp)
    80003828:	6902                	ld	s2,0(sp)
    8000382a:	6105                	addi	sp,sp,32
    8000382c:	8082                	ret
    pi->readopen = 0;
    8000382e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003832:	21c48513          	addi	a0,s1,540
    80003836:	b95fd0ef          	jal	800013ca <wakeup>
    8000383a:	bfd9                	j	80003810 <pipeclose+0x24>
    release(&pi->lock);
    8000383c:	8526                	mv	a0,s1
    8000383e:	0aa020ef          	jal	800058e8 <release>
}
    80003842:	b7c5                	j	80003822 <pipeclose+0x36>

0000000080003844 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003844:	711d                	addi	sp,sp,-96
    80003846:	ec86                	sd	ra,88(sp)
    80003848:	e8a2                	sd	s0,80(sp)
    8000384a:	e4a6                	sd	s1,72(sp)
    8000384c:	e0ca                	sd	s2,64(sp)
    8000384e:	fc4e                	sd	s3,56(sp)
    80003850:	f852                	sd	s4,48(sp)
    80003852:	f456                	sd	s5,40(sp)
    80003854:	1080                	addi	s0,sp,96
    80003856:	84aa                	mv	s1,a0
    80003858:	8aae                	mv	s5,a1
    8000385a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000385c:	d4cfd0ef          	jal	80000da8 <myproc>
    80003860:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003862:	8526                	mv	a0,s1
    80003864:	7ed010ef          	jal	80005850 <acquire>
  while(i < n){
    80003868:	0b405a63          	blez	s4,8000391c <pipewrite+0xd8>
    8000386c:	f05a                	sd	s6,32(sp)
    8000386e:	ec5e                	sd	s7,24(sp)
    80003870:	e862                	sd	s8,16(sp)
  int i = 0;
    80003872:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003874:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003876:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000387a:	21c48b93          	addi	s7,s1,540
    8000387e:	a81d                	j	800038b4 <pipewrite+0x70>
      release(&pi->lock);
    80003880:	8526                	mv	a0,s1
    80003882:	066020ef          	jal	800058e8 <release>
      return -1;
    80003886:	597d                	li	s2,-1
    80003888:	7b02                	ld	s6,32(sp)
    8000388a:	6be2                	ld	s7,24(sp)
    8000388c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000388e:	854a                	mv	a0,s2
    80003890:	60e6                	ld	ra,88(sp)
    80003892:	6446                	ld	s0,80(sp)
    80003894:	64a6                	ld	s1,72(sp)
    80003896:	6906                	ld	s2,64(sp)
    80003898:	79e2                	ld	s3,56(sp)
    8000389a:	7a42                	ld	s4,48(sp)
    8000389c:	7aa2                	ld	s5,40(sp)
    8000389e:	6125                	addi	sp,sp,96
    800038a0:	8082                	ret
      wakeup(&pi->nread);
    800038a2:	8562                	mv	a0,s8
    800038a4:	b27fd0ef          	jal	800013ca <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800038a8:	85a6                	mv	a1,s1
    800038aa:	855e                	mv	a0,s7
    800038ac:	ad3fd0ef          	jal	8000137e <sleep>
  while(i < n){
    800038b0:	05495b63          	bge	s2,s4,80003906 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800038b4:	2204a783          	lw	a5,544(s1)
    800038b8:	d7e1                	beqz	a5,80003880 <pipewrite+0x3c>
    800038ba:	854e                	mv	a0,s3
    800038bc:	cfbfd0ef          	jal	800015b6 <killed>
    800038c0:	f161                	bnez	a0,80003880 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800038c2:	2184a783          	lw	a5,536(s1)
    800038c6:	21c4a703          	lw	a4,540(s1)
    800038ca:	2007879b          	addiw	a5,a5,512
    800038ce:	fcf70ae3          	beq	a4,a5,800038a2 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038d2:	4685                	li	a3,1
    800038d4:	01590633          	add	a2,s2,s5
    800038d8:	faf40593          	addi	a1,s0,-81
    800038dc:	0509b503          	ld	a0,80(s3)
    800038e0:	a10fd0ef          	jal	80000af0 <copyin>
    800038e4:	03650e63          	beq	a0,s6,80003920 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800038e8:	21c4a783          	lw	a5,540(s1)
    800038ec:	0017871b          	addiw	a4,a5,1
    800038f0:	20e4ae23          	sw	a4,540(s1)
    800038f4:	1ff7f793          	andi	a5,a5,511
    800038f8:	97a6                	add	a5,a5,s1
    800038fa:	faf44703          	lbu	a4,-81(s0)
    800038fe:	00e78c23          	sb	a4,24(a5)
      i++;
    80003902:	2905                	addiw	s2,s2,1
    80003904:	b775                	j	800038b0 <pipewrite+0x6c>
    80003906:	7b02                	ld	s6,32(sp)
    80003908:	6be2                	ld	s7,24(sp)
    8000390a:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000390c:	21848513          	addi	a0,s1,536
    80003910:	abbfd0ef          	jal	800013ca <wakeup>
  release(&pi->lock);
    80003914:	8526                	mv	a0,s1
    80003916:	7d3010ef          	jal	800058e8 <release>
  return i;
    8000391a:	bf95                	j	8000388e <pipewrite+0x4a>
  int i = 0;
    8000391c:	4901                	li	s2,0
    8000391e:	b7fd                	j	8000390c <pipewrite+0xc8>
    80003920:	7b02                	ld	s6,32(sp)
    80003922:	6be2                	ld	s7,24(sp)
    80003924:	6c42                	ld	s8,16(sp)
    80003926:	b7dd                	j	8000390c <pipewrite+0xc8>

0000000080003928 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003928:	715d                	addi	sp,sp,-80
    8000392a:	e486                	sd	ra,72(sp)
    8000392c:	e0a2                	sd	s0,64(sp)
    8000392e:	fc26                	sd	s1,56(sp)
    80003930:	f84a                	sd	s2,48(sp)
    80003932:	f44e                	sd	s3,40(sp)
    80003934:	f052                	sd	s4,32(sp)
    80003936:	ec56                	sd	s5,24(sp)
    80003938:	0880                	addi	s0,sp,80
    8000393a:	84aa                	mv	s1,a0
    8000393c:	892e                	mv	s2,a1
    8000393e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003940:	c68fd0ef          	jal	80000da8 <myproc>
    80003944:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003946:	8526                	mv	a0,s1
    80003948:	709010ef          	jal	80005850 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000394c:	2184a703          	lw	a4,536(s1)
    80003950:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003954:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003958:	02f71563          	bne	a4,a5,80003982 <piperead+0x5a>
    8000395c:	2244a783          	lw	a5,548(s1)
    80003960:	cb85                	beqz	a5,80003990 <piperead+0x68>
    if(killed(pr)){
    80003962:	8552                	mv	a0,s4
    80003964:	c53fd0ef          	jal	800015b6 <killed>
    80003968:	ed19                	bnez	a0,80003986 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000396a:	85a6                	mv	a1,s1
    8000396c:	854e                	mv	a0,s3
    8000396e:	a11fd0ef          	jal	8000137e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003972:	2184a703          	lw	a4,536(s1)
    80003976:	21c4a783          	lw	a5,540(s1)
    8000397a:	fef701e3          	beq	a4,a5,8000395c <piperead+0x34>
    8000397e:	e85a                	sd	s6,16(sp)
    80003980:	a809                	j	80003992 <piperead+0x6a>
    80003982:	e85a                	sd	s6,16(sp)
    80003984:	a039                	j	80003992 <piperead+0x6a>
      release(&pi->lock);
    80003986:	8526                	mv	a0,s1
    80003988:	761010ef          	jal	800058e8 <release>
      return -1;
    8000398c:	59fd                	li	s3,-1
    8000398e:	a8b1                	j	800039ea <piperead+0xc2>
    80003990:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003992:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003994:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003996:	05505263          	blez	s5,800039da <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    8000399a:	2184a783          	lw	a5,536(s1)
    8000399e:	21c4a703          	lw	a4,540(s1)
    800039a2:	02f70c63          	beq	a4,a5,800039da <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800039a6:	0017871b          	addiw	a4,a5,1
    800039aa:	20e4ac23          	sw	a4,536(s1)
    800039ae:	1ff7f793          	andi	a5,a5,511
    800039b2:	97a6                	add	a5,a5,s1
    800039b4:	0187c783          	lbu	a5,24(a5)
    800039b8:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039bc:	4685                	li	a3,1
    800039be:	fbf40613          	addi	a2,s0,-65
    800039c2:	85ca                	mv	a1,s2
    800039c4:	050a3503          	ld	a0,80(s4)
    800039c8:	852fd0ef          	jal	80000a1a <copyout>
    800039cc:	01650763          	beq	a0,s6,800039da <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039d0:	2985                	addiw	s3,s3,1
    800039d2:	0905                	addi	s2,s2,1
    800039d4:	fd3a93e3          	bne	s5,s3,8000399a <piperead+0x72>
    800039d8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800039da:	21c48513          	addi	a0,s1,540
    800039de:	9edfd0ef          	jal	800013ca <wakeup>
  release(&pi->lock);
    800039e2:	8526                	mv	a0,s1
    800039e4:	705010ef          	jal	800058e8 <release>
    800039e8:	6b42                	ld	s6,16(sp)
  return i;
}
    800039ea:	854e                	mv	a0,s3
    800039ec:	60a6                	ld	ra,72(sp)
    800039ee:	6406                	ld	s0,64(sp)
    800039f0:	74e2                	ld	s1,56(sp)
    800039f2:	7942                	ld	s2,48(sp)
    800039f4:	79a2                	ld	s3,40(sp)
    800039f6:	7a02                	ld	s4,32(sp)
    800039f8:	6ae2                	ld	s5,24(sp)
    800039fa:	6161                	addi	sp,sp,80
    800039fc:	8082                	ret

00000000800039fe <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800039fe:	1141                	addi	sp,sp,-16
    80003a00:	e422                	sd	s0,8(sp)
    80003a02:	0800                	addi	s0,sp,16
    80003a04:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a06:	8905                	andi	a0,a0,1
    80003a08:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003a0a:	8b89                	andi	a5,a5,2
    80003a0c:	c399                	beqz	a5,80003a12 <flags2perm+0x14>
      perm |= PTE_W;
    80003a0e:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a12:	6422                	ld	s0,8(sp)
    80003a14:	0141                	addi	sp,sp,16
    80003a16:	8082                	ret

0000000080003a18 <exec>:

int
exec(char *path, char **argv)
{
    80003a18:	df010113          	addi	sp,sp,-528
    80003a1c:	20113423          	sd	ra,520(sp)
    80003a20:	20813023          	sd	s0,512(sp)
    80003a24:	ffa6                	sd	s1,504(sp)
    80003a26:	fbca                	sd	s2,496(sp)
    80003a28:	0c00                	addi	s0,sp,528
    80003a2a:	892a                	mv	s2,a0
    80003a2c:	dea43c23          	sd	a0,-520(s0)
    80003a30:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a34:	b74fd0ef          	jal	80000da8 <myproc>
    80003a38:	84aa                	mv	s1,a0

  begin_op();
    80003a3a:	dc6ff0ef          	jal	80003000 <begin_op>

  if((ip = namei(path)) == 0){
    80003a3e:	854a                	mv	a0,s2
    80003a40:	c04ff0ef          	jal	80002e44 <namei>
    80003a44:	c931                	beqz	a0,80003a98 <exec+0x80>
    80003a46:	f3d2                	sd	s4,480(sp)
    80003a48:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003a4a:	d21fe0ef          	jal	8000276a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003a4e:	04000713          	li	a4,64
    80003a52:	4681                	li	a3,0
    80003a54:	e5040613          	addi	a2,s0,-432
    80003a58:	4581                	li	a1,0
    80003a5a:	8552                	mv	a0,s4
    80003a5c:	f63fe0ef          	jal	800029be <readi>
    80003a60:	04000793          	li	a5,64
    80003a64:	00f51a63          	bne	a0,a5,80003a78 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003a68:	e5042703          	lw	a4,-432(s0)
    80003a6c:	464c47b7          	lui	a5,0x464c4
    80003a70:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003a74:	02f70663          	beq	a4,a5,80003aa0 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003a78:	8552                	mv	a0,s4
    80003a7a:	efbfe0ef          	jal	80002974 <iunlockput>
    end_op();
    80003a7e:	decff0ef          	jal	8000306a <end_op>
  }
  return -1;
    80003a82:	557d                	li	a0,-1
    80003a84:	7a1e                	ld	s4,480(sp)
}
    80003a86:	20813083          	ld	ra,520(sp)
    80003a8a:	20013403          	ld	s0,512(sp)
    80003a8e:	74fe                	ld	s1,504(sp)
    80003a90:	795e                	ld	s2,496(sp)
    80003a92:	21010113          	addi	sp,sp,528
    80003a96:	8082                	ret
    end_op();
    80003a98:	dd2ff0ef          	jal	8000306a <end_op>
    return -1;
    80003a9c:	557d                	li	a0,-1
    80003a9e:	b7e5                	j	80003a86 <exec+0x6e>
    80003aa0:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003aa2:	8526                	mv	a0,s1
    80003aa4:	bacfd0ef          	jal	80000e50 <proc_pagetable>
    80003aa8:	8b2a                	mv	s6,a0
    80003aaa:	2c050b63          	beqz	a0,80003d80 <exec+0x368>
    80003aae:	f7ce                	sd	s3,488(sp)
    80003ab0:	efd6                	sd	s5,472(sp)
    80003ab2:	e7de                	sd	s7,456(sp)
    80003ab4:	e3e2                	sd	s8,448(sp)
    80003ab6:	ff66                	sd	s9,440(sp)
    80003ab8:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003aba:	e7042d03          	lw	s10,-400(s0)
    80003abe:	e8845783          	lhu	a5,-376(s0)
    80003ac2:	12078963          	beqz	a5,80003bf4 <exec+0x1dc>
    80003ac6:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ac8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003aca:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003acc:	6c85                	lui	s9,0x1
    80003ace:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003ad2:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003ad6:	6a85                	lui	s5,0x1
    80003ad8:	a085                	j	80003b38 <exec+0x120>
      panic("loadseg: address should exist");
    80003ada:	00004517          	auipc	a0,0x4
    80003ade:	b8650513          	addi	a0,a0,-1146 # 80007660 <etext+0x660>
    80003ae2:	241010ef          	jal	80005522 <panic>
    if(sz - i < PGSIZE)
    80003ae6:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003ae8:	8726                	mv	a4,s1
    80003aea:	012c06bb          	addw	a3,s8,s2
    80003aee:	4581                	li	a1,0
    80003af0:	8552                	mv	a0,s4
    80003af2:	ecdfe0ef          	jal	800029be <readi>
    80003af6:	2501                	sext.w	a0,a0
    80003af8:	24a49a63          	bne	s1,a0,80003d4c <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003afc:	012a893b          	addw	s2,s5,s2
    80003b00:	03397363          	bgeu	s2,s3,80003b26 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003b04:	02091593          	slli	a1,s2,0x20
    80003b08:	9181                	srli	a1,a1,0x20
    80003b0a:	95de                	add	a1,a1,s7
    80003b0c:	855a                	mv	a0,s6
    80003b0e:	991fc0ef          	jal	8000049e <walkaddr>
    80003b12:	862a                	mv	a2,a0
    if(pa == 0)
    80003b14:	d179                	beqz	a0,80003ada <exec+0xc2>
    if(sz - i < PGSIZE)
    80003b16:	412984bb          	subw	s1,s3,s2
    80003b1a:	0004879b          	sext.w	a5,s1
    80003b1e:	fcfcf4e3          	bgeu	s9,a5,80003ae6 <exec+0xce>
    80003b22:	84d6                	mv	s1,s5
    80003b24:	b7c9                	j	80003ae6 <exec+0xce>
    sz = sz1;
    80003b26:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b2a:	2d85                	addiw	s11,s11,1
    80003b2c:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003b30:	e8845783          	lhu	a5,-376(s0)
    80003b34:	08fdd063          	bge	s11,a5,80003bb4 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b38:	2d01                	sext.w	s10,s10
    80003b3a:	03800713          	li	a4,56
    80003b3e:	86ea                	mv	a3,s10
    80003b40:	e1840613          	addi	a2,s0,-488
    80003b44:	4581                	li	a1,0
    80003b46:	8552                	mv	a0,s4
    80003b48:	e77fe0ef          	jal	800029be <readi>
    80003b4c:	03800793          	li	a5,56
    80003b50:	1cf51663          	bne	a0,a5,80003d1c <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003b54:	e1842783          	lw	a5,-488(s0)
    80003b58:	4705                	li	a4,1
    80003b5a:	fce798e3          	bne	a5,a4,80003b2a <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003b5e:	e4043483          	ld	s1,-448(s0)
    80003b62:	e3843783          	ld	a5,-456(s0)
    80003b66:	1af4ef63          	bltu	s1,a5,80003d24 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003b6a:	e2843783          	ld	a5,-472(s0)
    80003b6e:	94be                	add	s1,s1,a5
    80003b70:	1af4ee63          	bltu	s1,a5,80003d2c <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003b74:	df043703          	ld	a4,-528(s0)
    80003b78:	8ff9                	and	a5,a5,a4
    80003b7a:	1a079d63          	bnez	a5,80003d34 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b7e:	e1c42503          	lw	a0,-484(s0)
    80003b82:	e7dff0ef          	jal	800039fe <flags2perm>
    80003b86:	86aa                	mv	a3,a0
    80003b88:	8626                	mv	a2,s1
    80003b8a:	85ca                	mv	a1,s2
    80003b8c:	855a                	mv	a0,s6
    80003b8e:	c79fc0ef          	jal	80000806 <uvmalloc>
    80003b92:	e0a43423          	sd	a0,-504(s0)
    80003b96:	1a050363          	beqz	a0,80003d3c <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003b9a:	e2843b83          	ld	s7,-472(s0)
    80003b9e:	e2042c03          	lw	s8,-480(s0)
    80003ba2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003ba6:	00098463          	beqz	s3,80003bae <exec+0x196>
    80003baa:	4901                	li	s2,0
    80003bac:	bfa1                	j	80003b04 <exec+0xec>
    sz = sz1;
    80003bae:	e0843903          	ld	s2,-504(s0)
    80003bb2:	bfa5                	j	80003b2a <exec+0x112>
    80003bb4:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003bb6:	8552                	mv	a0,s4
    80003bb8:	dbdfe0ef          	jal	80002974 <iunlockput>
  end_op();
    80003bbc:	caeff0ef          	jal	8000306a <end_op>
  p = myproc();
    80003bc0:	9e8fd0ef          	jal	80000da8 <myproc>
    80003bc4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003bc6:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003bca:	6985                	lui	s3,0x1
    80003bcc:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003bce:	99ca                	add	s3,s3,s2
    80003bd0:	77fd                	lui	a5,0xfffff
    80003bd2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003bd6:	4691                	li	a3,4
    80003bd8:	660d                	lui	a2,0x3
    80003bda:	964e                	add	a2,a2,s3
    80003bdc:	85ce                	mv	a1,s3
    80003bde:	855a                	mv	a0,s6
    80003be0:	c27fc0ef          	jal	80000806 <uvmalloc>
    80003be4:	892a                	mv	s2,a0
    80003be6:	e0a43423          	sd	a0,-504(s0)
    80003bea:	e519                	bnez	a0,80003bf8 <exec+0x1e0>
  if(pagetable)
    80003bec:	e1343423          	sd	s3,-504(s0)
    80003bf0:	4a01                	li	s4,0
    80003bf2:	aab1                	j	80003d4e <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003bf4:	4901                	li	s2,0
    80003bf6:	b7c1                	j	80003bb6 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003bf8:	75f5                	lui	a1,0xffffd
    80003bfa:	95aa                	add	a1,a1,a0
    80003bfc:	855a                	mv	a0,s6
    80003bfe:	df3fc0ef          	jal	800009f0 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c02:	7bf9                	lui	s7,0xffffe
    80003c04:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003c06:	e0043783          	ld	a5,-512(s0)
    80003c0a:	6388                	ld	a0,0(a5)
    80003c0c:	cd39                	beqz	a0,80003c6a <exec+0x252>
    80003c0e:	e9040993          	addi	s3,s0,-368
    80003c12:	f9040c13          	addi	s8,s0,-112
    80003c16:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003c18:	ee8fc0ef          	jal	80000300 <strlen>
    80003c1c:	0015079b          	addiw	a5,a0,1
    80003c20:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c24:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c28:	11796e63          	bltu	s2,s7,80003d44 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c2c:	e0043d03          	ld	s10,-512(s0)
    80003c30:	000d3a03          	ld	s4,0(s10)
    80003c34:	8552                	mv	a0,s4
    80003c36:	ecafc0ef          	jal	80000300 <strlen>
    80003c3a:	0015069b          	addiw	a3,a0,1
    80003c3e:	8652                	mv	a2,s4
    80003c40:	85ca                	mv	a1,s2
    80003c42:	855a                	mv	a0,s6
    80003c44:	dd7fc0ef          	jal	80000a1a <copyout>
    80003c48:	10054063          	bltz	a0,80003d48 <exec+0x330>
    ustack[argc] = sp;
    80003c4c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003c50:	0485                	addi	s1,s1,1
    80003c52:	008d0793          	addi	a5,s10,8
    80003c56:	e0f43023          	sd	a5,-512(s0)
    80003c5a:	008d3503          	ld	a0,8(s10)
    80003c5e:	c909                	beqz	a0,80003c70 <exec+0x258>
    if(argc >= MAXARG)
    80003c60:	09a1                	addi	s3,s3,8
    80003c62:	fb899be3          	bne	s3,s8,80003c18 <exec+0x200>
  ip = 0;
    80003c66:	4a01                	li	s4,0
    80003c68:	a0dd                	j	80003d4e <exec+0x336>
  sp = sz;
    80003c6a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003c6e:	4481                	li	s1,0
  ustack[argc] = 0;
    80003c70:	00349793          	slli	a5,s1,0x3
    80003c74:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb800>
    80003c78:	97a2                	add	a5,a5,s0
    80003c7a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003c7e:	00148693          	addi	a3,s1,1
    80003c82:	068e                	slli	a3,a3,0x3
    80003c84:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003c88:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003c8c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003c90:	f5796ee3          	bltu	s2,s7,80003bec <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003c94:	e9040613          	addi	a2,s0,-368
    80003c98:	85ca                	mv	a1,s2
    80003c9a:	855a                	mv	a0,s6
    80003c9c:	d7ffc0ef          	jal	80000a1a <copyout>
    80003ca0:	0e054263          	bltz	a0,80003d84 <exec+0x36c>
  p->trapframe->a1 = sp;
    80003ca4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003ca8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003cac:	df843783          	ld	a5,-520(s0)
    80003cb0:	0007c703          	lbu	a4,0(a5)
    80003cb4:	cf11                	beqz	a4,80003cd0 <exec+0x2b8>
    80003cb6:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003cb8:	02f00693          	li	a3,47
    80003cbc:	a039                	j	80003cca <exec+0x2b2>
      last = s+1;
    80003cbe:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003cc2:	0785                	addi	a5,a5,1
    80003cc4:	fff7c703          	lbu	a4,-1(a5)
    80003cc8:	c701                	beqz	a4,80003cd0 <exec+0x2b8>
    if(*s == '/')
    80003cca:	fed71ce3          	bne	a4,a3,80003cc2 <exec+0x2aa>
    80003cce:	bfc5                	j	80003cbe <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003cd0:	4641                	li	a2,16
    80003cd2:	df843583          	ld	a1,-520(s0)
    80003cd6:	158a8513          	addi	a0,s5,344
    80003cda:	df4fc0ef          	jal	800002ce <safestrcpy>
  oldpagetable = p->pagetable;
    80003cde:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003ce2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003ce6:	e0843783          	ld	a5,-504(s0)
    80003cea:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003cee:	058ab783          	ld	a5,88(s5)
    80003cf2:	e6843703          	ld	a4,-408(s0)
    80003cf6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003cf8:	058ab783          	ld	a5,88(s5)
    80003cfc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d00:	85e6                	mv	a1,s9
    80003d02:	9d2fd0ef          	jal	80000ed4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d06:	0004851b          	sext.w	a0,s1
    80003d0a:	79be                	ld	s3,488(sp)
    80003d0c:	7a1e                	ld	s4,480(sp)
    80003d0e:	6afe                	ld	s5,472(sp)
    80003d10:	6b5e                	ld	s6,464(sp)
    80003d12:	6bbe                	ld	s7,456(sp)
    80003d14:	6c1e                	ld	s8,448(sp)
    80003d16:	7cfa                	ld	s9,440(sp)
    80003d18:	7d5a                	ld	s10,432(sp)
    80003d1a:	b3b5                	j	80003a86 <exec+0x6e>
    80003d1c:	e1243423          	sd	s2,-504(s0)
    80003d20:	7dba                	ld	s11,424(sp)
    80003d22:	a035                	j	80003d4e <exec+0x336>
    80003d24:	e1243423          	sd	s2,-504(s0)
    80003d28:	7dba                	ld	s11,424(sp)
    80003d2a:	a015                	j	80003d4e <exec+0x336>
    80003d2c:	e1243423          	sd	s2,-504(s0)
    80003d30:	7dba                	ld	s11,424(sp)
    80003d32:	a831                	j	80003d4e <exec+0x336>
    80003d34:	e1243423          	sd	s2,-504(s0)
    80003d38:	7dba                	ld	s11,424(sp)
    80003d3a:	a811                	j	80003d4e <exec+0x336>
    80003d3c:	e1243423          	sd	s2,-504(s0)
    80003d40:	7dba                	ld	s11,424(sp)
    80003d42:	a031                	j	80003d4e <exec+0x336>
  ip = 0;
    80003d44:	4a01                	li	s4,0
    80003d46:	a021                	j	80003d4e <exec+0x336>
    80003d48:	4a01                	li	s4,0
  if(pagetable)
    80003d4a:	a011                	j	80003d4e <exec+0x336>
    80003d4c:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003d4e:	e0843583          	ld	a1,-504(s0)
    80003d52:	855a                	mv	a0,s6
    80003d54:	980fd0ef          	jal	80000ed4 <proc_freepagetable>
  return -1;
    80003d58:	557d                	li	a0,-1
  if(ip){
    80003d5a:	000a1b63          	bnez	s4,80003d70 <exec+0x358>
    80003d5e:	79be                	ld	s3,488(sp)
    80003d60:	7a1e                	ld	s4,480(sp)
    80003d62:	6afe                	ld	s5,472(sp)
    80003d64:	6b5e                	ld	s6,464(sp)
    80003d66:	6bbe                	ld	s7,456(sp)
    80003d68:	6c1e                	ld	s8,448(sp)
    80003d6a:	7cfa                	ld	s9,440(sp)
    80003d6c:	7d5a                	ld	s10,432(sp)
    80003d6e:	bb21                	j	80003a86 <exec+0x6e>
    80003d70:	79be                	ld	s3,488(sp)
    80003d72:	6afe                	ld	s5,472(sp)
    80003d74:	6b5e                	ld	s6,464(sp)
    80003d76:	6bbe                	ld	s7,456(sp)
    80003d78:	6c1e                	ld	s8,448(sp)
    80003d7a:	7cfa                	ld	s9,440(sp)
    80003d7c:	7d5a                	ld	s10,432(sp)
    80003d7e:	b9ed                	j	80003a78 <exec+0x60>
    80003d80:	6b5e                	ld	s6,464(sp)
    80003d82:	b9dd                	j	80003a78 <exec+0x60>
  sz = sz1;
    80003d84:	e0843983          	ld	s3,-504(s0)
    80003d88:	b595                	j	80003bec <exec+0x1d4>

0000000080003d8a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003d8a:	7179                	addi	sp,sp,-48
    80003d8c:	f406                	sd	ra,40(sp)
    80003d8e:	f022                	sd	s0,32(sp)
    80003d90:	ec26                	sd	s1,24(sp)
    80003d92:	e84a                	sd	s2,16(sp)
    80003d94:	1800                	addi	s0,sp,48
    80003d96:	892e                	mv	s2,a1
    80003d98:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003d9a:	fdc40593          	addi	a1,s0,-36
    80003d9e:	f13fd0ef          	jal	80001cb0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003da2:	fdc42703          	lw	a4,-36(s0)
    80003da6:	47bd                	li	a5,15
    80003da8:	02e7e963          	bltu	a5,a4,80003dda <argfd+0x50>
    80003dac:	ffdfc0ef          	jal	80000da8 <myproc>
    80003db0:	fdc42703          	lw	a4,-36(s0)
    80003db4:	01a70793          	addi	a5,a4,26
    80003db8:	078e                	slli	a5,a5,0x3
    80003dba:	953e                	add	a0,a0,a5
    80003dbc:	611c                	ld	a5,0(a0)
    80003dbe:	c385                	beqz	a5,80003dde <argfd+0x54>
    return -1;
  if(pfd)
    80003dc0:	00090463          	beqz	s2,80003dc8 <argfd+0x3e>
    *pfd = fd;
    80003dc4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003dc8:	4501                	li	a0,0
  if(pf)
    80003dca:	c091                	beqz	s1,80003dce <argfd+0x44>
    *pf = f;
    80003dcc:	e09c                	sd	a5,0(s1)
}
    80003dce:	70a2                	ld	ra,40(sp)
    80003dd0:	7402                	ld	s0,32(sp)
    80003dd2:	64e2                	ld	s1,24(sp)
    80003dd4:	6942                	ld	s2,16(sp)
    80003dd6:	6145                	addi	sp,sp,48
    80003dd8:	8082                	ret
    return -1;
    80003dda:	557d                	li	a0,-1
    80003ddc:	bfcd                	j	80003dce <argfd+0x44>
    80003dde:	557d                	li	a0,-1
    80003de0:	b7fd                	j	80003dce <argfd+0x44>

0000000080003de2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003de2:	1101                	addi	sp,sp,-32
    80003de4:	ec06                	sd	ra,24(sp)
    80003de6:	e822                	sd	s0,16(sp)
    80003de8:	e426                	sd	s1,8(sp)
    80003dea:	1000                	addi	s0,sp,32
    80003dec:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003dee:	fbbfc0ef          	jal	80000da8 <myproc>
    80003df2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003df4:	0d050793          	addi	a5,a0,208
    80003df8:	4501                	li	a0,0
    80003dfa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003dfc:	6398                	ld	a4,0(a5)
    80003dfe:	cb19                	beqz	a4,80003e14 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e00:	2505                	addiw	a0,a0,1
    80003e02:	07a1                	addi	a5,a5,8
    80003e04:	fed51ce3          	bne	a0,a3,80003dfc <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e08:	557d                	li	a0,-1
}
    80003e0a:	60e2                	ld	ra,24(sp)
    80003e0c:	6442                	ld	s0,16(sp)
    80003e0e:	64a2                	ld	s1,8(sp)
    80003e10:	6105                	addi	sp,sp,32
    80003e12:	8082                	ret
      p->ofile[fd] = f;
    80003e14:	01a50793          	addi	a5,a0,26
    80003e18:	078e                	slli	a5,a5,0x3
    80003e1a:	963e                	add	a2,a2,a5
    80003e1c:	e204                	sd	s1,0(a2)
      return fd;
    80003e1e:	b7f5                	j	80003e0a <fdalloc+0x28>

0000000080003e20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e20:	715d                	addi	sp,sp,-80
    80003e22:	e486                	sd	ra,72(sp)
    80003e24:	e0a2                	sd	s0,64(sp)
    80003e26:	fc26                	sd	s1,56(sp)
    80003e28:	f84a                	sd	s2,48(sp)
    80003e2a:	f44e                	sd	s3,40(sp)
    80003e2c:	ec56                	sd	s5,24(sp)
    80003e2e:	e85a                	sd	s6,16(sp)
    80003e30:	0880                	addi	s0,sp,80
    80003e32:	8b2e                	mv	s6,a1
    80003e34:	89b2                	mv	s3,a2
    80003e36:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e38:	fb040593          	addi	a1,s0,-80
    80003e3c:	822ff0ef          	jal	80002e5e <nameiparent>
    80003e40:	84aa                	mv	s1,a0
    80003e42:	10050a63          	beqz	a0,80003f56 <create+0x136>
    return 0;

  ilock(dp);
    80003e46:	925fe0ef          	jal	8000276a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e4a:	4601                	li	a2,0
    80003e4c:	fb040593          	addi	a1,s0,-80
    80003e50:	8526                	mv	a0,s1
    80003e52:	d8dfe0ef          	jal	80002bde <dirlookup>
    80003e56:	8aaa                	mv	s5,a0
    80003e58:	c129                	beqz	a0,80003e9a <create+0x7a>
    iunlockput(dp);
    80003e5a:	8526                	mv	a0,s1
    80003e5c:	b19fe0ef          	jal	80002974 <iunlockput>
    ilock(ip);
    80003e60:	8556                	mv	a0,s5
    80003e62:	909fe0ef          	jal	8000276a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003e66:	4789                	li	a5,2
    80003e68:	02fb1463          	bne	s6,a5,80003e90 <create+0x70>
    80003e6c:	044ad783          	lhu	a5,68(s5)
    80003e70:	37f9                	addiw	a5,a5,-2
    80003e72:	17c2                	slli	a5,a5,0x30
    80003e74:	93c1                	srli	a5,a5,0x30
    80003e76:	4705                	li	a4,1
    80003e78:	00f76c63          	bltu	a4,a5,80003e90 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003e7c:	8556                	mv	a0,s5
    80003e7e:	60a6                	ld	ra,72(sp)
    80003e80:	6406                	ld	s0,64(sp)
    80003e82:	74e2                	ld	s1,56(sp)
    80003e84:	7942                	ld	s2,48(sp)
    80003e86:	79a2                	ld	s3,40(sp)
    80003e88:	6ae2                	ld	s5,24(sp)
    80003e8a:	6b42                	ld	s6,16(sp)
    80003e8c:	6161                	addi	sp,sp,80
    80003e8e:	8082                	ret
    iunlockput(ip);
    80003e90:	8556                	mv	a0,s5
    80003e92:	ae3fe0ef          	jal	80002974 <iunlockput>
    return 0;
    80003e96:	4a81                	li	s5,0
    80003e98:	b7d5                	j	80003e7c <create+0x5c>
    80003e9a:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003e9c:	85da                	mv	a1,s6
    80003e9e:	4088                	lw	a0,0(s1)
    80003ea0:	f5afe0ef          	jal	800025fa <ialloc>
    80003ea4:	8a2a                	mv	s4,a0
    80003ea6:	cd15                	beqz	a0,80003ee2 <create+0xc2>
  ilock(ip);
    80003ea8:	8c3fe0ef          	jal	8000276a <ilock>
  ip->major = major;
    80003eac:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003eb0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003eb4:	4905                	li	s2,1
    80003eb6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003eba:	8552                	mv	a0,s4
    80003ebc:	ffafe0ef          	jal	800026b6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003ec0:	032b0763          	beq	s6,s2,80003eee <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003ec4:	004a2603          	lw	a2,4(s4)
    80003ec8:	fb040593          	addi	a1,s0,-80
    80003ecc:	8526                	mv	a0,s1
    80003ece:	eddfe0ef          	jal	80002daa <dirlink>
    80003ed2:	06054563          	bltz	a0,80003f3c <create+0x11c>
  iunlockput(dp);
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	a9dfe0ef          	jal	80002974 <iunlockput>
  return ip;
    80003edc:	8ad2                	mv	s5,s4
    80003ede:	7a02                	ld	s4,32(sp)
    80003ee0:	bf71                	j	80003e7c <create+0x5c>
    iunlockput(dp);
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	a91fe0ef          	jal	80002974 <iunlockput>
    return 0;
    80003ee8:	8ad2                	mv	s5,s4
    80003eea:	7a02                	ld	s4,32(sp)
    80003eec:	bf41                	j	80003e7c <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003eee:	004a2603          	lw	a2,4(s4)
    80003ef2:	00003597          	auipc	a1,0x3
    80003ef6:	78e58593          	addi	a1,a1,1934 # 80007680 <etext+0x680>
    80003efa:	8552                	mv	a0,s4
    80003efc:	eaffe0ef          	jal	80002daa <dirlink>
    80003f00:	02054e63          	bltz	a0,80003f3c <create+0x11c>
    80003f04:	40d0                	lw	a2,4(s1)
    80003f06:	00003597          	auipc	a1,0x3
    80003f0a:	78258593          	addi	a1,a1,1922 # 80007688 <etext+0x688>
    80003f0e:	8552                	mv	a0,s4
    80003f10:	e9bfe0ef          	jal	80002daa <dirlink>
    80003f14:	02054463          	bltz	a0,80003f3c <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f18:	004a2603          	lw	a2,4(s4)
    80003f1c:	fb040593          	addi	a1,s0,-80
    80003f20:	8526                	mv	a0,s1
    80003f22:	e89fe0ef          	jal	80002daa <dirlink>
    80003f26:	00054b63          	bltz	a0,80003f3c <create+0x11c>
    dp->nlink++;  // for ".."
    80003f2a:	04a4d783          	lhu	a5,74(s1)
    80003f2e:	2785                	addiw	a5,a5,1
    80003f30:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f34:	8526                	mv	a0,s1
    80003f36:	f80fe0ef          	jal	800026b6 <iupdate>
    80003f3a:	bf71                	j	80003ed6 <create+0xb6>
  ip->nlink = 0;
    80003f3c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f40:	8552                	mv	a0,s4
    80003f42:	f74fe0ef          	jal	800026b6 <iupdate>
  iunlockput(ip);
    80003f46:	8552                	mv	a0,s4
    80003f48:	a2dfe0ef          	jal	80002974 <iunlockput>
  iunlockput(dp);
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	a27fe0ef          	jal	80002974 <iunlockput>
  return 0;
    80003f52:	7a02                	ld	s4,32(sp)
    80003f54:	b725                	j	80003e7c <create+0x5c>
    return 0;
    80003f56:	8aaa                	mv	s5,a0
    80003f58:	b715                	j	80003e7c <create+0x5c>

0000000080003f5a <sys_dup>:
{
    80003f5a:	7179                	addi	sp,sp,-48
    80003f5c:	f406                	sd	ra,40(sp)
    80003f5e:	f022                	sd	s0,32(sp)
    80003f60:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003f62:	fd840613          	addi	a2,s0,-40
    80003f66:	4581                	li	a1,0
    80003f68:	4501                	li	a0,0
    80003f6a:	e21ff0ef          	jal	80003d8a <argfd>
    return -1;
    80003f6e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003f70:	02054363          	bltz	a0,80003f96 <sys_dup+0x3c>
    80003f74:	ec26                	sd	s1,24(sp)
    80003f76:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003f78:	fd843903          	ld	s2,-40(s0)
    80003f7c:	854a                	mv	a0,s2
    80003f7e:	e65ff0ef          	jal	80003de2 <fdalloc>
    80003f82:	84aa                	mv	s1,a0
    return -1;
    80003f84:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003f86:	00054d63          	bltz	a0,80003fa0 <sys_dup+0x46>
  filedup(f);
    80003f8a:	854a                	mv	a0,s2
    80003f8c:	c48ff0ef          	jal	800033d4 <filedup>
  return fd;
    80003f90:	87a6                	mv	a5,s1
    80003f92:	64e2                	ld	s1,24(sp)
    80003f94:	6942                	ld	s2,16(sp)
}
    80003f96:	853e                	mv	a0,a5
    80003f98:	70a2                	ld	ra,40(sp)
    80003f9a:	7402                	ld	s0,32(sp)
    80003f9c:	6145                	addi	sp,sp,48
    80003f9e:	8082                	ret
    80003fa0:	64e2                	ld	s1,24(sp)
    80003fa2:	6942                	ld	s2,16(sp)
    80003fa4:	bfcd                	j	80003f96 <sys_dup+0x3c>

0000000080003fa6 <sys_read>:
{
    80003fa6:	7179                	addi	sp,sp,-48
    80003fa8:	f406                	sd	ra,40(sp)
    80003faa:	f022                	sd	s0,32(sp)
    80003fac:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003fae:	fd840593          	addi	a1,s0,-40
    80003fb2:	4505                	li	a0,1
    80003fb4:	d19fd0ef          	jal	80001ccc <argaddr>
  argint(2, &n);
    80003fb8:	fe440593          	addi	a1,s0,-28
    80003fbc:	4509                	li	a0,2
    80003fbe:	cf3fd0ef          	jal	80001cb0 <argint>
  if(argfd(0, 0, &f) < 0)
    80003fc2:	fe840613          	addi	a2,s0,-24
    80003fc6:	4581                	li	a1,0
    80003fc8:	4501                	li	a0,0
    80003fca:	dc1ff0ef          	jal	80003d8a <argfd>
    80003fce:	87aa                	mv	a5,a0
    return -1;
    80003fd0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fd2:	0007ca63          	bltz	a5,80003fe6 <sys_read+0x40>
  return fileread(f, p, n);
    80003fd6:	fe442603          	lw	a2,-28(s0)
    80003fda:	fd843583          	ld	a1,-40(s0)
    80003fde:	fe843503          	ld	a0,-24(s0)
    80003fe2:	d58ff0ef          	jal	8000353a <fileread>
}
    80003fe6:	70a2                	ld	ra,40(sp)
    80003fe8:	7402                	ld	s0,32(sp)
    80003fea:	6145                	addi	sp,sp,48
    80003fec:	8082                	ret

0000000080003fee <sys_write>:
{
    80003fee:	7179                	addi	sp,sp,-48
    80003ff0:	f406                	sd	ra,40(sp)
    80003ff2:	f022                	sd	s0,32(sp)
    80003ff4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ff6:	fd840593          	addi	a1,s0,-40
    80003ffa:	4505                	li	a0,1
    80003ffc:	cd1fd0ef          	jal	80001ccc <argaddr>
  argint(2, &n);
    80004000:	fe440593          	addi	a1,s0,-28
    80004004:	4509                	li	a0,2
    80004006:	cabfd0ef          	jal	80001cb0 <argint>
  if(argfd(0, 0, &f) < 0)
    8000400a:	fe840613          	addi	a2,s0,-24
    8000400e:	4581                	li	a1,0
    80004010:	4501                	li	a0,0
    80004012:	d79ff0ef          	jal	80003d8a <argfd>
    80004016:	87aa                	mv	a5,a0
    return -1;
    80004018:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000401a:	0007ca63          	bltz	a5,8000402e <sys_write+0x40>
  return filewrite(f, p, n);
    8000401e:	fe442603          	lw	a2,-28(s0)
    80004022:	fd843583          	ld	a1,-40(s0)
    80004026:	fe843503          	ld	a0,-24(s0)
    8000402a:	dceff0ef          	jal	800035f8 <filewrite>
}
    8000402e:	70a2                	ld	ra,40(sp)
    80004030:	7402                	ld	s0,32(sp)
    80004032:	6145                	addi	sp,sp,48
    80004034:	8082                	ret

0000000080004036 <sys_close>:
{
    80004036:	1101                	addi	sp,sp,-32
    80004038:	ec06                	sd	ra,24(sp)
    8000403a:	e822                	sd	s0,16(sp)
    8000403c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000403e:	fe040613          	addi	a2,s0,-32
    80004042:	fec40593          	addi	a1,s0,-20
    80004046:	4501                	li	a0,0
    80004048:	d43ff0ef          	jal	80003d8a <argfd>
    return -1;
    8000404c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000404e:	02054063          	bltz	a0,8000406e <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004052:	d57fc0ef          	jal	80000da8 <myproc>
    80004056:	fec42783          	lw	a5,-20(s0)
    8000405a:	07e9                	addi	a5,a5,26
    8000405c:	078e                	slli	a5,a5,0x3
    8000405e:	953e                	add	a0,a0,a5
    80004060:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004064:	fe043503          	ld	a0,-32(s0)
    80004068:	bb2ff0ef          	jal	8000341a <fileclose>
  return 0;
    8000406c:	4781                	li	a5,0
}
    8000406e:	853e                	mv	a0,a5
    80004070:	60e2                	ld	ra,24(sp)
    80004072:	6442                	ld	s0,16(sp)
    80004074:	6105                	addi	sp,sp,32
    80004076:	8082                	ret

0000000080004078 <sys_fstat>:
{
    80004078:	1101                	addi	sp,sp,-32
    8000407a:	ec06                	sd	ra,24(sp)
    8000407c:	e822                	sd	s0,16(sp)
    8000407e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004080:	fe040593          	addi	a1,s0,-32
    80004084:	4505                	li	a0,1
    80004086:	c47fd0ef          	jal	80001ccc <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000408a:	fe840613          	addi	a2,s0,-24
    8000408e:	4581                	li	a1,0
    80004090:	4501                	li	a0,0
    80004092:	cf9ff0ef          	jal	80003d8a <argfd>
    80004096:	87aa                	mv	a5,a0
    return -1;
    80004098:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000409a:	0007c863          	bltz	a5,800040aa <sys_fstat+0x32>
  return filestat(f, st);
    8000409e:	fe043583          	ld	a1,-32(s0)
    800040a2:	fe843503          	ld	a0,-24(s0)
    800040a6:	c36ff0ef          	jal	800034dc <filestat>
}
    800040aa:	60e2                	ld	ra,24(sp)
    800040ac:	6442                	ld	s0,16(sp)
    800040ae:	6105                	addi	sp,sp,32
    800040b0:	8082                	ret

00000000800040b2 <sys_link>:
{
    800040b2:	7169                	addi	sp,sp,-304
    800040b4:	f606                	sd	ra,296(sp)
    800040b6:	f222                	sd	s0,288(sp)
    800040b8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040ba:	08000613          	li	a2,128
    800040be:	ed040593          	addi	a1,s0,-304
    800040c2:	4501                	li	a0,0
    800040c4:	c25fd0ef          	jal	80001ce8 <argstr>
    return -1;
    800040c8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040ca:	0c054e63          	bltz	a0,800041a6 <sys_link+0xf4>
    800040ce:	08000613          	li	a2,128
    800040d2:	f5040593          	addi	a1,s0,-176
    800040d6:	4505                	li	a0,1
    800040d8:	c11fd0ef          	jal	80001ce8 <argstr>
    return -1;
    800040dc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040de:	0c054463          	bltz	a0,800041a6 <sys_link+0xf4>
    800040e2:	ee26                	sd	s1,280(sp)
  begin_op();
    800040e4:	f1dfe0ef          	jal	80003000 <begin_op>
  if((ip = namei(old)) == 0){
    800040e8:	ed040513          	addi	a0,s0,-304
    800040ec:	d59fe0ef          	jal	80002e44 <namei>
    800040f0:	84aa                	mv	s1,a0
    800040f2:	c53d                	beqz	a0,80004160 <sys_link+0xae>
  ilock(ip);
    800040f4:	e76fe0ef          	jal	8000276a <ilock>
  if(ip->type == T_DIR){
    800040f8:	04449703          	lh	a4,68(s1)
    800040fc:	4785                	li	a5,1
    800040fe:	06f70663          	beq	a4,a5,8000416a <sys_link+0xb8>
    80004102:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004104:	04a4d783          	lhu	a5,74(s1)
    80004108:	2785                	addiw	a5,a5,1
    8000410a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000410e:	8526                	mv	a0,s1
    80004110:	da6fe0ef          	jal	800026b6 <iupdate>
  iunlock(ip);
    80004114:	8526                	mv	a0,s1
    80004116:	f02fe0ef          	jal	80002818 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000411a:	fd040593          	addi	a1,s0,-48
    8000411e:	f5040513          	addi	a0,s0,-176
    80004122:	d3dfe0ef          	jal	80002e5e <nameiparent>
    80004126:	892a                	mv	s2,a0
    80004128:	cd21                	beqz	a0,80004180 <sys_link+0xce>
  ilock(dp);
    8000412a:	e40fe0ef          	jal	8000276a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000412e:	00092703          	lw	a4,0(s2)
    80004132:	409c                	lw	a5,0(s1)
    80004134:	04f71363          	bne	a4,a5,8000417a <sys_link+0xc8>
    80004138:	40d0                	lw	a2,4(s1)
    8000413a:	fd040593          	addi	a1,s0,-48
    8000413e:	854a                	mv	a0,s2
    80004140:	c6bfe0ef          	jal	80002daa <dirlink>
    80004144:	02054b63          	bltz	a0,8000417a <sys_link+0xc8>
  iunlockput(dp);
    80004148:	854a                	mv	a0,s2
    8000414a:	82bfe0ef          	jal	80002974 <iunlockput>
  iput(ip);
    8000414e:	8526                	mv	a0,s1
    80004150:	f9cfe0ef          	jal	800028ec <iput>
  end_op();
    80004154:	f17fe0ef          	jal	8000306a <end_op>
  return 0;
    80004158:	4781                	li	a5,0
    8000415a:	64f2                	ld	s1,280(sp)
    8000415c:	6952                	ld	s2,272(sp)
    8000415e:	a0a1                	j	800041a6 <sys_link+0xf4>
    end_op();
    80004160:	f0bfe0ef          	jal	8000306a <end_op>
    return -1;
    80004164:	57fd                	li	a5,-1
    80004166:	64f2                	ld	s1,280(sp)
    80004168:	a83d                	j	800041a6 <sys_link+0xf4>
    iunlockput(ip);
    8000416a:	8526                	mv	a0,s1
    8000416c:	809fe0ef          	jal	80002974 <iunlockput>
    end_op();
    80004170:	efbfe0ef          	jal	8000306a <end_op>
    return -1;
    80004174:	57fd                	li	a5,-1
    80004176:	64f2                	ld	s1,280(sp)
    80004178:	a03d                	j	800041a6 <sys_link+0xf4>
    iunlockput(dp);
    8000417a:	854a                	mv	a0,s2
    8000417c:	ff8fe0ef          	jal	80002974 <iunlockput>
  ilock(ip);
    80004180:	8526                	mv	a0,s1
    80004182:	de8fe0ef          	jal	8000276a <ilock>
  ip->nlink--;
    80004186:	04a4d783          	lhu	a5,74(s1)
    8000418a:	37fd                	addiw	a5,a5,-1
    8000418c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004190:	8526                	mv	a0,s1
    80004192:	d24fe0ef          	jal	800026b6 <iupdate>
  iunlockput(ip);
    80004196:	8526                	mv	a0,s1
    80004198:	fdcfe0ef          	jal	80002974 <iunlockput>
  end_op();
    8000419c:	ecffe0ef          	jal	8000306a <end_op>
  return -1;
    800041a0:	57fd                	li	a5,-1
    800041a2:	64f2                	ld	s1,280(sp)
    800041a4:	6952                	ld	s2,272(sp)
}
    800041a6:	853e                	mv	a0,a5
    800041a8:	70b2                	ld	ra,296(sp)
    800041aa:	7412                	ld	s0,288(sp)
    800041ac:	6155                	addi	sp,sp,304
    800041ae:	8082                	ret

00000000800041b0 <sys_unlink>:
{
    800041b0:	7151                	addi	sp,sp,-240
    800041b2:	f586                	sd	ra,232(sp)
    800041b4:	f1a2                	sd	s0,224(sp)
    800041b6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800041b8:	08000613          	li	a2,128
    800041bc:	f3040593          	addi	a1,s0,-208
    800041c0:	4501                	li	a0,0
    800041c2:	b27fd0ef          	jal	80001ce8 <argstr>
    800041c6:	16054063          	bltz	a0,80004326 <sys_unlink+0x176>
    800041ca:	eda6                	sd	s1,216(sp)
  begin_op();
    800041cc:	e35fe0ef          	jal	80003000 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800041d0:	fb040593          	addi	a1,s0,-80
    800041d4:	f3040513          	addi	a0,s0,-208
    800041d8:	c87fe0ef          	jal	80002e5e <nameiparent>
    800041dc:	84aa                	mv	s1,a0
    800041de:	c945                	beqz	a0,8000428e <sys_unlink+0xde>
  ilock(dp);
    800041e0:	d8afe0ef          	jal	8000276a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800041e4:	00003597          	auipc	a1,0x3
    800041e8:	49c58593          	addi	a1,a1,1180 # 80007680 <etext+0x680>
    800041ec:	fb040513          	addi	a0,s0,-80
    800041f0:	9d9fe0ef          	jal	80002bc8 <namecmp>
    800041f4:	10050e63          	beqz	a0,80004310 <sys_unlink+0x160>
    800041f8:	00003597          	auipc	a1,0x3
    800041fc:	49058593          	addi	a1,a1,1168 # 80007688 <etext+0x688>
    80004200:	fb040513          	addi	a0,s0,-80
    80004204:	9c5fe0ef          	jal	80002bc8 <namecmp>
    80004208:	10050463          	beqz	a0,80004310 <sys_unlink+0x160>
    8000420c:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000420e:	f2c40613          	addi	a2,s0,-212
    80004212:	fb040593          	addi	a1,s0,-80
    80004216:	8526                	mv	a0,s1
    80004218:	9c7fe0ef          	jal	80002bde <dirlookup>
    8000421c:	892a                	mv	s2,a0
    8000421e:	0e050863          	beqz	a0,8000430e <sys_unlink+0x15e>
  ilock(ip);
    80004222:	d48fe0ef          	jal	8000276a <ilock>
  if(ip->nlink < 1)
    80004226:	04a91783          	lh	a5,74(s2)
    8000422a:	06f05763          	blez	a5,80004298 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000422e:	04491703          	lh	a4,68(s2)
    80004232:	4785                	li	a5,1
    80004234:	06f70963          	beq	a4,a5,800042a6 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004238:	4641                	li	a2,16
    8000423a:	4581                	li	a1,0
    8000423c:	fc040513          	addi	a0,s0,-64
    80004240:	f51fb0ef          	jal	80000190 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004244:	4741                	li	a4,16
    80004246:	f2c42683          	lw	a3,-212(s0)
    8000424a:	fc040613          	addi	a2,s0,-64
    8000424e:	4581                	li	a1,0
    80004250:	8526                	mv	a0,s1
    80004252:	869fe0ef          	jal	80002aba <writei>
    80004256:	47c1                	li	a5,16
    80004258:	08f51b63          	bne	a0,a5,800042ee <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000425c:	04491703          	lh	a4,68(s2)
    80004260:	4785                	li	a5,1
    80004262:	08f70d63          	beq	a4,a5,800042fc <sys_unlink+0x14c>
  iunlockput(dp);
    80004266:	8526                	mv	a0,s1
    80004268:	f0cfe0ef          	jal	80002974 <iunlockput>
  ip->nlink--;
    8000426c:	04a95783          	lhu	a5,74(s2)
    80004270:	37fd                	addiw	a5,a5,-1
    80004272:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004276:	854a                	mv	a0,s2
    80004278:	c3efe0ef          	jal	800026b6 <iupdate>
  iunlockput(ip);
    8000427c:	854a                	mv	a0,s2
    8000427e:	ef6fe0ef          	jal	80002974 <iunlockput>
  end_op();
    80004282:	de9fe0ef          	jal	8000306a <end_op>
  return 0;
    80004286:	4501                	li	a0,0
    80004288:	64ee                	ld	s1,216(sp)
    8000428a:	694e                	ld	s2,208(sp)
    8000428c:	a849                	j	8000431e <sys_unlink+0x16e>
    end_op();
    8000428e:	dddfe0ef          	jal	8000306a <end_op>
    return -1;
    80004292:	557d                	li	a0,-1
    80004294:	64ee                	ld	s1,216(sp)
    80004296:	a061                	j	8000431e <sys_unlink+0x16e>
    80004298:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000429a:	00003517          	auipc	a0,0x3
    8000429e:	3f650513          	addi	a0,a0,1014 # 80007690 <etext+0x690>
    800042a2:	280010ef          	jal	80005522 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042a6:	04c92703          	lw	a4,76(s2)
    800042aa:	02000793          	li	a5,32
    800042ae:	f8e7f5e3          	bgeu	a5,a4,80004238 <sys_unlink+0x88>
    800042b2:	e5ce                	sd	s3,200(sp)
    800042b4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042b8:	4741                	li	a4,16
    800042ba:	86ce                	mv	a3,s3
    800042bc:	f1840613          	addi	a2,s0,-232
    800042c0:	4581                	li	a1,0
    800042c2:	854a                	mv	a0,s2
    800042c4:	efafe0ef          	jal	800029be <readi>
    800042c8:	47c1                	li	a5,16
    800042ca:	00f51c63          	bne	a0,a5,800042e2 <sys_unlink+0x132>
    if(de.inum != 0)
    800042ce:	f1845783          	lhu	a5,-232(s0)
    800042d2:	efa1                	bnez	a5,8000432a <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042d4:	29c1                	addiw	s3,s3,16
    800042d6:	04c92783          	lw	a5,76(s2)
    800042da:	fcf9efe3          	bltu	s3,a5,800042b8 <sys_unlink+0x108>
    800042de:	69ae                	ld	s3,200(sp)
    800042e0:	bfa1                	j	80004238 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800042e2:	00003517          	auipc	a0,0x3
    800042e6:	3c650513          	addi	a0,a0,966 # 800076a8 <etext+0x6a8>
    800042ea:	238010ef          	jal	80005522 <panic>
    800042ee:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800042f0:	00003517          	auipc	a0,0x3
    800042f4:	3d050513          	addi	a0,a0,976 # 800076c0 <etext+0x6c0>
    800042f8:	22a010ef          	jal	80005522 <panic>
    dp->nlink--;
    800042fc:	04a4d783          	lhu	a5,74(s1)
    80004300:	37fd                	addiw	a5,a5,-1
    80004302:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004306:	8526                	mv	a0,s1
    80004308:	baefe0ef          	jal	800026b6 <iupdate>
    8000430c:	bfa9                	j	80004266 <sys_unlink+0xb6>
    8000430e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004310:	8526                	mv	a0,s1
    80004312:	e62fe0ef          	jal	80002974 <iunlockput>
  end_op();
    80004316:	d55fe0ef          	jal	8000306a <end_op>
  return -1;
    8000431a:	557d                	li	a0,-1
    8000431c:	64ee                	ld	s1,216(sp)
}
    8000431e:	70ae                	ld	ra,232(sp)
    80004320:	740e                	ld	s0,224(sp)
    80004322:	616d                	addi	sp,sp,240
    80004324:	8082                	ret
    return -1;
    80004326:	557d                	li	a0,-1
    80004328:	bfdd                	j	8000431e <sys_unlink+0x16e>
    iunlockput(ip);
    8000432a:	854a                	mv	a0,s2
    8000432c:	e48fe0ef          	jal	80002974 <iunlockput>
    goto bad;
    80004330:	694e                	ld	s2,208(sp)
    80004332:	69ae                	ld	s3,200(sp)
    80004334:	bff1                	j	80004310 <sys_unlink+0x160>

0000000080004336 <sys_open>:

uint64
sys_open(void)
{
    80004336:	7131                	addi	sp,sp,-192
    80004338:	fd06                	sd	ra,184(sp)
    8000433a:	f922                	sd	s0,176(sp)
    8000433c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000433e:	f4c40593          	addi	a1,s0,-180
    80004342:	4505                	li	a0,1
    80004344:	96dfd0ef          	jal	80001cb0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004348:	08000613          	li	a2,128
    8000434c:	f5040593          	addi	a1,s0,-176
    80004350:	4501                	li	a0,0
    80004352:	997fd0ef          	jal	80001ce8 <argstr>
    80004356:	87aa                	mv	a5,a0
    return -1;
    80004358:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000435a:	0a07c263          	bltz	a5,800043fe <sys_open+0xc8>
    8000435e:	f526                	sd	s1,168(sp)

  begin_op();
    80004360:	ca1fe0ef          	jal	80003000 <begin_op>

  if(omode & O_CREATE){
    80004364:	f4c42783          	lw	a5,-180(s0)
    80004368:	2007f793          	andi	a5,a5,512
    8000436c:	c3d5                	beqz	a5,80004410 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000436e:	4681                	li	a3,0
    80004370:	4601                	li	a2,0
    80004372:	4589                	li	a1,2
    80004374:	f5040513          	addi	a0,s0,-176
    80004378:	aa9ff0ef          	jal	80003e20 <create>
    8000437c:	84aa                	mv	s1,a0
    if(ip == 0){
    8000437e:	c541                	beqz	a0,80004406 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004380:	04449703          	lh	a4,68(s1)
    80004384:	478d                	li	a5,3
    80004386:	00f71763          	bne	a4,a5,80004394 <sys_open+0x5e>
    8000438a:	0464d703          	lhu	a4,70(s1)
    8000438e:	47a5                	li	a5,9
    80004390:	0ae7ed63          	bltu	a5,a4,8000444a <sys_open+0x114>
    80004394:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004396:	fe1fe0ef          	jal	80003376 <filealloc>
    8000439a:	892a                	mv	s2,a0
    8000439c:	c179                	beqz	a0,80004462 <sys_open+0x12c>
    8000439e:	ed4e                	sd	s3,152(sp)
    800043a0:	a43ff0ef          	jal	80003de2 <fdalloc>
    800043a4:	89aa                	mv	s3,a0
    800043a6:	0a054a63          	bltz	a0,8000445a <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800043aa:	04449703          	lh	a4,68(s1)
    800043ae:	478d                	li	a5,3
    800043b0:	0cf70263          	beq	a4,a5,80004474 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800043b4:	4789                	li	a5,2
    800043b6:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800043ba:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800043be:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800043c2:	f4c42783          	lw	a5,-180(s0)
    800043c6:	0017c713          	xori	a4,a5,1
    800043ca:	8b05                	andi	a4,a4,1
    800043cc:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800043d0:	0037f713          	andi	a4,a5,3
    800043d4:	00e03733          	snez	a4,a4
    800043d8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800043dc:	4007f793          	andi	a5,a5,1024
    800043e0:	c791                	beqz	a5,800043ec <sys_open+0xb6>
    800043e2:	04449703          	lh	a4,68(s1)
    800043e6:	4789                	li	a5,2
    800043e8:	08f70d63          	beq	a4,a5,80004482 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800043ec:	8526                	mv	a0,s1
    800043ee:	c2afe0ef          	jal	80002818 <iunlock>
  end_op();
    800043f2:	c79fe0ef          	jal	8000306a <end_op>

  return fd;
    800043f6:	854e                	mv	a0,s3
    800043f8:	74aa                	ld	s1,168(sp)
    800043fa:	790a                	ld	s2,160(sp)
    800043fc:	69ea                	ld	s3,152(sp)
}
    800043fe:	70ea                	ld	ra,184(sp)
    80004400:	744a                	ld	s0,176(sp)
    80004402:	6129                	addi	sp,sp,192
    80004404:	8082                	ret
      end_op();
    80004406:	c65fe0ef          	jal	8000306a <end_op>
      return -1;
    8000440a:	557d                	li	a0,-1
    8000440c:	74aa                	ld	s1,168(sp)
    8000440e:	bfc5                	j	800043fe <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004410:	f5040513          	addi	a0,s0,-176
    80004414:	a31fe0ef          	jal	80002e44 <namei>
    80004418:	84aa                	mv	s1,a0
    8000441a:	c11d                	beqz	a0,80004440 <sys_open+0x10a>
    ilock(ip);
    8000441c:	b4efe0ef          	jal	8000276a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004420:	04449703          	lh	a4,68(s1)
    80004424:	4785                	li	a5,1
    80004426:	f4f71de3          	bne	a4,a5,80004380 <sys_open+0x4a>
    8000442a:	f4c42783          	lw	a5,-180(s0)
    8000442e:	d3bd                	beqz	a5,80004394 <sys_open+0x5e>
      iunlockput(ip);
    80004430:	8526                	mv	a0,s1
    80004432:	d42fe0ef          	jal	80002974 <iunlockput>
      end_op();
    80004436:	c35fe0ef          	jal	8000306a <end_op>
      return -1;
    8000443a:	557d                	li	a0,-1
    8000443c:	74aa                	ld	s1,168(sp)
    8000443e:	b7c1                	j	800043fe <sys_open+0xc8>
      end_op();
    80004440:	c2bfe0ef          	jal	8000306a <end_op>
      return -1;
    80004444:	557d                	li	a0,-1
    80004446:	74aa                	ld	s1,168(sp)
    80004448:	bf5d                	j	800043fe <sys_open+0xc8>
    iunlockput(ip);
    8000444a:	8526                	mv	a0,s1
    8000444c:	d28fe0ef          	jal	80002974 <iunlockput>
    end_op();
    80004450:	c1bfe0ef          	jal	8000306a <end_op>
    return -1;
    80004454:	557d                	li	a0,-1
    80004456:	74aa                	ld	s1,168(sp)
    80004458:	b75d                	j	800043fe <sys_open+0xc8>
      fileclose(f);
    8000445a:	854a                	mv	a0,s2
    8000445c:	fbffe0ef          	jal	8000341a <fileclose>
    80004460:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004462:	8526                	mv	a0,s1
    80004464:	d10fe0ef          	jal	80002974 <iunlockput>
    end_op();
    80004468:	c03fe0ef          	jal	8000306a <end_op>
    return -1;
    8000446c:	557d                	li	a0,-1
    8000446e:	74aa                	ld	s1,168(sp)
    80004470:	790a                	ld	s2,160(sp)
    80004472:	b771                	j	800043fe <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004474:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004478:	04649783          	lh	a5,70(s1)
    8000447c:	02f91223          	sh	a5,36(s2)
    80004480:	bf3d                	j	800043be <sys_open+0x88>
    itrunc(ip);
    80004482:	8526                	mv	a0,s1
    80004484:	bd4fe0ef          	jal	80002858 <itrunc>
    80004488:	b795                	j	800043ec <sys_open+0xb6>

000000008000448a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000448a:	7175                	addi	sp,sp,-144
    8000448c:	e506                	sd	ra,136(sp)
    8000448e:	e122                	sd	s0,128(sp)
    80004490:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004492:	b6ffe0ef          	jal	80003000 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004496:	08000613          	li	a2,128
    8000449a:	f7040593          	addi	a1,s0,-144
    8000449e:	4501                	li	a0,0
    800044a0:	849fd0ef          	jal	80001ce8 <argstr>
    800044a4:	02054363          	bltz	a0,800044ca <sys_mkdir+0x40>
    800044a8:	4681                	li	a3,0
    800044aa:	4601                	li	a2,0
    800044ac:	4585                	li	a1,1
    800044ae:	f7040513          	addi	a0,s0,-144
    800044b2:	96fff0ef          	jal	80003e20 <create>
    800044b6:	c911                	beqz	a0,800044ca <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800044b8:	cbcfe0ef          	jal	80002974 <iunlockput>
  end_op();
    800044bc:	baffe0ef          	jal	8000306a <end_op>
  return 0;
    800044c0:	4501                	li	a0,0
}
    800044c2:	60aa                	ld	ra,136(sp)
    800044c4:	640a                	ld	s0,128(sp)
    800044c6:	6149                	addi	sp,sp,144
    800044c8:	8082                	ret
    end_op();
    800044ca:	ba1fe0ef          	jal	8000306a <end_op>
    return -1;
    800044ce:	557d                	li	a0,-1
    800044d0:	bfcd                	j	800044c2 <sys_mkdir+0x38>

00000000800044d2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800044d2:	7135                	addi	sp,sp,-160
    800044d4:	ed06                	sd	ra,152(sp)
    800044d6:	e922                	sd	s0,144(sp)
    800044d8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800044da:	b27fe0ef          	jal	80003000 <begin_op>
  argint(1, &major);
    800044de:	f6c40593          	addi	a1,s0,-148
    800044e2:	4505                	li	a0,1
    800044e4:	fccfd0ef          	jal	80001cb0 <argint>
  argint(2, &minor);
    800044e8:	f6840593          	addi	a1,s0,-152
    800044ec:	4509                	li	a0,2
    800044ee:	fc2fd0ef          	jal	80001cb0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800044f2:	08000613          	li	a2,128
    800044f6:	f7040593          	addi	a1,s0,-144
    800044fa:	4501                	li	a0,0
    800044fc:	fecfd0ef          	jal	80001ce8 <argstr>
    80004500:	02054563          	bltz	a0,8000452a <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004504:	f6841683          	lh	a3,-152(s0)
    80004508:	f6c41603          	lh	a2,-148(s0)
    8000450c:	458d                	li	a1,3
    8000450e:	f7040513          	addi	a0,s0,-144
    80004512:	90fff0ef          	jal	80003e20 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004516:	c911                	beqz	a0,8000452a <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004518:	c5cfe0ef          	jal	80002974 <iunlockput>
  end_op();
    8000451c:	b4ffe0ef          	jal	8000306a <end_op>
  return 0;
    80004520:	4501                	li	a0,0
}
    80004522:	60ea                	ld	ra,152(sp)
    80004524:	644a                	ld	s0,144(sp)
    80004526:	610d                	addi	sp,sp,160
    80004528:	8082                	ret
    end_op();
    8000452a:	b41fe0ef          	jal	8000306a <end_op>
    return -1;
    8000452e:	557d                	li	a0,-1
    80004530:	bfcd                	j	80004522 <sys_mknod+0x50>

0000000080004532 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004532:	7135                	addi	sp,sp,-160
    80004534:	ed06                	sd	ra,152(sp)
    80004536:	e922                	sd	s0,144(sp)
    80004538:	e14a                	sd	s2,128(sp)
    8000453a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000453c:	86dfc0ef          	jal	80000da8 <myproc>
    80004540:	892a                	mv	s2,a0
  
  begin_op();
    80004542:	abffe0ef          	jal	80003000 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004546:	08000613          	li	a2,128
    8000454a:	f6040593          	addi	a1,s0,-160
    8000454e:	4501                	li	a0,0
    80004550:	f98fd0ef          	jal	80001ce8 <argstr>
    80004554:	04054363          	bltz	a0,8000459a <sys_chdir+0x68>
    80004558:	e526                	sd	s1,136(sp)
    8000455a:	f6040513          	addi	a0,s0,-160
    8000455e:	8e7fe0ef          	jal	80002e44 <namei>
    80004562:	84aa                	mv	s1,a0
    80004564:	c915                	beqz	a0,80004598 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004566:	a04fe0ef          	jal	8000276a <ilock>
  if(ip->type != T_DIR){
    8000456a:	04449703          	lh	a4,68(s1)
    8000456e:	4785                	li	a5,1
    80004570:	02f71963          	bne	a4,a5,800045a2 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004574:	8526                	mv	a0,s1
    80004576:	aa2fe0ef          	jal	80002818 <iunlock>
  iput(p->cwd);
    8000457a:	15093503          	ld	a0,336(s2)
    8000457e:	b6efe0ef          	jal	800028ec <iput>
  end_op();
    80004582:	ae9fe0ef          	jal	8000306a <end_op>
  p->cwd = ip;
    80004586:	14993823          	sd	s1,336(s2)
  return 0;
    8000458a:	4501                	li	a0,0
    8000458c:	64aa                	ld	s1,136(sp)
}
    8000458e:	60ea                	ld	ra,152(sp)
    80004590:	644a                	ld	s0,144(sp)
    80004592:	690a                	ld	s2,128(sp)
    80004594:	610d                	addi	sp,sp,160
    80004596:	8082                	ret
    80004598:	64aa                	ld	s1,136(sp)
    end_op();
    8000459a:	ad1fe0ef          	jal	8000306a <end_op>
    return -1;
    8000459e:	557d                	li	a0,-1
    800045a0:	b7fd                	j	8000458e <sys_chdir+0x5c>
    iunlockput(ip);
    800045a2:	8526                	mv	a0,s1
    800045a4:	bd0fe0ef          	jal	80002974 <iunlockput>
    end_op();
    800045a8:	ac3fe0ef          	jal	8000306a <end_op>
    return -1;
    800045ac:	557d                	li	a0,-1
    800045ae:	64aa                	ld	s1,136(sp)
    800045b0:	bff9                	j	8000458e <sys_chdir+0x5c>

00000000800045b2 <sys_exec>:

uint64
sys_exec(void)
{
    800045b2:	7121                	addi	sp,sp,-448
    800045b4:	ff06                	sd	ra,440(sp)
    800045b6:	fb22                	sd	s0,432(sp)
    800045b8:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800045ba:	e4840593          	addi	a1,s0,-440
    800045be:	4505                	li	a0,1
    800045c0:	f0cfd0ef          	jal	80001ccc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800045c4:	08000613          	li	a2,128
    800045c8:	f5040593          	addi	a1,s0,-176
    800045cc:	4501                	li	a0,0
    800045ce:	f1afd0ef          	jal	80001ce8 <argstr>
    800045d2:	87aa                	mv	a5,a0
    return -1;
    800045d4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800045d6:	0c07c463          	bltz	a5,8000469e <sys_exec+0xec>
    800045da:	f726                	sd	s1,424(sp)
    800045dc:	f34a                	sd	s2,416(sp)
    800045de:	ef4e                	sd	s3,408(sp)
    800045e0:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800045e2:	10000613          	li	a2,256
    800045e6:	4581                	li	a1,0
    800045e8:	e5040513          	addi	a0,s0,-432
    800045ec:	ba5fb0ef          	jal	80000190 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800045f0:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800045f4:	89a6                	mv	s3,s1
    800045f6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800045f8:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800045fc:	00391513          	slli	a0,s2,0x3
    80004600:	e4040593          	addi	a1,s0,-448
    80004604:	e4843783          	ld	a5,-440(s0)
    80004608:	953e                	add	a0,a0,a5
    8000460a:	e1cfd0ef          	jal	80001c26 <fetchaddr>
    8000460e:	02054663          	bltz	a0,8000463a <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004612:	e4043783          	ld	a5,-448(s0)
    80004616:	c3a9                	beqz	a5,80004658 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004618:	ae7fb0ef          	jal	800000fe <kalloc>
    8000461c:	85aa                	mv	a1,a0
    8000461e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004622:	cd01                	beqz	a0,8000463a <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004624:	6605                	lui	a2,0x1
    80004626:	e4043503          	ld	a0,-448(s0)
    8000462a:	e46fd0ef          	jal	80001c70 <fetchstr>
    8000462e:	00054663          	bltz	a0,8000463a <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004632:	0905                	addi	s2,s2,1
    80004634:	09a1                	addi	s3,s3,8
    80004636:	fd4913e3          	bne	s2,s4,800045fc <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000463a:	f5040913          	addi	s2,s0,-176
    8000463e:	6088                	ld	a0,0(s1)
    80004640:	c931                	beqz	a0,80004694 <sys_exec+0xe2>
    kfree(argv[i]);
    80004642:	9dbfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004646:	04a1                	addi	s1,s1,8
    80004648:	ff249be3          	bne	s1,s2,8000463e <sys_exec+0x8c>
  return -1;
    8000464c:	557d                	li	a0,-1
    8000464e:	74ba                	ld	s1,424(sp)
    80004650:	791a                	ld	s2,416(sp)
    80004652:	69fa                	ld	s3,408(sp)
    80004654:	6a5a                	ld	s4,400(sp)
    80004656:	a0a1                	j	8000469e <sys_exec+0xec>
      argv[i] = 0;
    80004658:	0009079b          	sext.w	a5,s2
    8000465c:	078e                	slli	a5,a5,0x3
    8000465e:	fd078793          	addi	a5,a5,-48
    80004662:	97a2                	add	a5,a5,s0
    80004664:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004668:	e5040593          	addi	a1,s0,-432
    8000466c:	f5040513          	addi	a0,s0,-176
    80004670:	ba8ff0ef          	jal	80003a18 <exec>
    80004674:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004676:	f5040993          	addi	s3,s0,-176
    8000467a:	6088                	ld	a0,0(s1)
    8000467c:	c511                	beqz	a0,80004688 <sys_exec+0xd6>
    kfree(argv[i]);
    8000467e:	99ffb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004682:	04a1                	addi	s1,s1,8
    80004684:	ff349be3          	bne	s1,s3,8000467a <sys_exec+0xc8>
  return ret;
    80004688:	854a                	mv	a0,s2
    8000468a:	74ba                	ld	s1,424(sp)
    8000468c:	791a                	ld	s2,416(sp)
    8000468e:	69fa                	ld	s3,408(sp)
    80004690:	6a5a                	ld	s4,400(sp)
    80004692:	a031                	j	8000469e <sys_exec+0xec>
  return -1;
    80004694:	557d                	li	a0,-1
    80004696:	74ba                	ld	s1,424(sp)
    80004698:	791a                	ld	s2,416(sp)
    8000469a:	69fa                	ld	s3,408(sp)
    8000469c:	6a5a                	ld	s4,400(sp)
}
    8000469e:	70fa                	ld	ra,440(sp)
    800046a0:	745a                	ld	s0,432(sp)
    800046a2:	6139                	addi	sp,sp,448
    800046a4:	8082                	ret

00000000800046a6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800046a6:	7139                	addi	sp,sp,-64
    800046a8:	fc06                	sd	ra,56(sp)
    800046aa:	f822                	sd	s0,48(sp)
    800046ac:	f426                	sd	s1,40(sp)
    800046ae:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800046b0:	ef8fc0ef          	jal	80000da8 <myproc>
    800046b4:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800046b6:	fd840593          	addi	a1,s0,-40
    800046ba:	4501                	li	a0,0
    800046bc:	e10fd0ef          	jal	80001ccc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800046c0:	fc840593          	addi	a1,s0,-56
    800046c4:	fd040513          	addi	a0,s0,-48
    800046c8:	85cff0ef          	jal	80003724 <pipealloc>
    return -1;
    800046cc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800046ce:	0a054463          	bltz	a0,80004776 <sys_pipe+0xd0>
  fd0 = -1;
    800046d2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800046d6:	fd043503          	ld	a0,-48(s0)
    800046da:	f08ff0ef          	jal	80003de2 <fdalloc>
    800046de:	fca42223          	sw	a0,-60(s0)
    800046e2:	08054163          	bltz	a0,80004764 <sys_pipe+0xbe>
    800046e6:	fc843503          	ld	a0,-56(s0)
    800046ea:	ef8ff0ef          	jal	80003de2 <fdalloc>
    800046ee:	fca42023          	sw	a0,-64(s0)
    800046f2:	06054063          	bltz	a0,80004752 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800046f6:	4691                	li	a3,4
    800046f8:	fc440613          	addi	a2,s0,-60
    800046fc:	fd843583          	ld	a1,-40(s0)
    80004700:	68a8                	ld	a0,80(s1)
    80004702:	b18fc0ef          	jal	80000a1a <copyout>
    80004706:	00054e63          	bltz	a0,80004722 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000470a:	4691                	li	a3,4
    8000470c:	fc040613          	addi	a2,s0,-64
    80004710:	fd843583          	ld	a1,-40(s0)
    80004714:	0591                	addi	a1,a1,4
    80004716:	68a8                	ld	a0,80(s1)
    80004718:	b02fc0ef          	jal	80000a1a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000471c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000471e:	04055c63          	bgez	a0,80004776 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004722:	fc442783          	lw	a5,-60(s0)
    80004726:	07e9                	addi	a5,a5,26
    80004728:	078e                	slli	a5,a5,0x3
    8000472a:	97a6                	add	a5,a5,s1
    8000472c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004730:	fc042783          	lw	a5,-64(s0)
    80004734:	07e9                	addi	a5,a5,26
    80004736:	078e                	slli	a5,a5,0x3
    80004738:	94be                	add	s1,s1,a5
    8000473a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000473e:	fd043503          	ld	a0,-48(s0)
    80004742:	cd9fe0ef          	jal	8000341a <fileclose>
    fileclose(wf);
    80004746:	fc843503          	ld	a0,-56(s0)
    8000474a:	cd1fe0ef          	jal	8000341a <fileclose>
    return -1;
    8000474e:	57fd                	li	a5,-1
    80004750:	a01d                	j	80004776 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004752:	fc442783          	lw	a5,-60(s0)
    80004756:	0007c763          	bltz	a5,80004764 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000475a:	07e9                	addi	a5,a5,26
    8000475c:	078e                	slli	a5,a5,0x3
    8000475e:	97a6                	add	a5,a5,s1
    80004760:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004764:	fd043503          	ld	a0,-48(s0)
    80004768:	cb3fe0ef          	jal	8000341a <fileclose>
    fileclose(wf);
    8000476c:	fc843503          	ld	a0,-56(s0)
    80004770:	cabfe0ef          	jal	8000341a <fileclose>
    return -1;
    80004774:	57fd                	li	a5,-1
}
    80004776:	853e                	mv	a0,a5
    80004778:	70e2                	ld	ra,56(sp)
    8000477a:	7442                	ld	s0,48(sp)
    8000477c:	74a2                	ld	s1,40(sp)
    8000477e:	6121                	addi	sp,sp,64
    80004780:	8082                	ret
	...

0000000080004790 <kernelvec>:
    80004790:	7111                	addi	sp,sp,-256
    80004792:	e006                	sd	ra,0(sp)
    80004794:	e40a                	sd	sp,8(sp)
    80004796:	e80e                	sd	gp,16(sp)
    80004798:	ec12                	sd	tp,24(sp)
    8000479a:	f016                	sd	t0,32(sp)
    8000479c:	f41a                	sd	t1,40(sp)
    8000479e:	f81e                	sd	t2,48(sp)
    800047a0:	e4aa                	sd	a0,72(sp)
    800047a2:	e8ae                	sd	a1,80(sp)
    800047a4:	ecb2                	sd	a2,88(sp)
    800047a6:	f0b6                	sd	a3,96(sp)
    800047a8:	f4ba                	sd	a4,104(sp)
    800047aa:	f8be                	sd	a5,112(sp)
    800047ac:	fcc2                	sd	a6,120(sp)
    800047ae:	e146                	sd	a7,128(sp)
    800047b0:	edf2                	sd	t3,216(sp)
    800047b2:	f1f6                	sd	t4,224(sp)
    800047b4:	f5fa                	sd	t5,232(sp)
    800047b6:	f9fe                	sd	t6,240(sp)
    800047b8:	b7efd0ef          	jal	80001b36 <kerneltrap>
    800047bc:	6082                	ld	ra,0(sp)
    800047be:	6122                	ld	sp,8(sp)
    800047c0:	61c2                	ld	gp,16(sp)
    800047c2:	7282                	ld	t0,32(sp)
    800047c4:	7322                	ld	t1,40(sp)
    800047c6:	73c2                	ld	t2,48(sp)
    800047c8:	6526                	ld	a0,72(sp)
    800047ca:	65c6                	ld	a1,80(sp)
    800047cc:	6666                	ld	a2,88(sp)
    800047ce:	7686                	ld	a3,96(sp)
    800047d0:	7726                	ld	a4,104(sp)
    800047d2:	77c6                	ld	a5,112(sp)
    800047d4:	7866                	ld	a6,120(sp)
    800047d6:	688a                	ld	a7,128(sp)
    800047d8:	6e6e                	ld	t3,216(sp)
    800047da:	7e8e                	ld	t4,224(sp)
    800047dc:	7f2e                	ld	t5,232(sp)
    800047de:	7fce                	ld	t6,240(sp)
    800047e0:	6111                	addi	sp,sp,256
    800047e2:	10200073          	sret
	...

00000000800047ee <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800047ee:	1141                	addi	sp,sp,-16
    800047f0:	e422                	sd	s0,8(sp)
    800047f2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800047f4:	0c0007b7          	lui	a5,0xc000
    800047f8:	4705                	li	a4,1
    800047fa:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800047fc:	0c0007b7          	lui	a5,0xc000
    80004800:	c3d8                	sw	a4,4(a5)
}
    80004802:	6422                	ld	s0,8(sp)
    80004804:	0141                	addi	sp,sp,16
    80004806:	8082                	ret

0000000080004808 <plicinithart>:

void
plicinithart(void)
{
    80004808:	1141                	addi	sp,sp,-16
    8000480a:	e406                	sd	ra,8(sp)
    8000480c:	e022                	sd	s0,0(sp)
    8000480e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004810:	d6cfc0ef          	jal	80000d7c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004814:	0085171b          	slliw	a4,a0,0x8
    80004818:	0c0027b7          	lui	a5,0xc002
    8000481c:	97ba                	add	a5,a5,a4
    8000481e:	40200713          	li	a4,1026
    80004822:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004826:	00d5151b          	slliw	a0,a0,0xd
    8000482a:	0c2017b7          	lui	a5,0xc201
    8000482e:	97aa                	add	a5,a5,a0
    80004830:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004834:	60a2                	ld	ra,8(sp)
    80004836:	6402                	ld	s0,0(sp)
    80004838:	0141                	addi	sp,sp,16
    8000483a:	8082                	ret

000000008000483c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000483c:	1141                	addi	sp,sp,-16
    8000483e:	e406                	sd	ra,8(sp)
    80004840:	e022                	sd	s0,0(sp)
    80004842:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004844:	d38fc0ef          	jal	80000d7c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004848:	00d5151b          	slliw	a0,a0,0xd
    8000484c:	0c2017b7          	lui	a5,0xc201
    80004850:	97aa                	add	a5,a5,a0
  return irq;
}
    80004852:	43c8                	lw	a0,4(a5)
    80004854:	60a2                	ld	ra,8(sp)
    80004856:	6402                	ld	s0,0(sp)
    80004858:	0141                	addi	sp,sp,16
    8000485a:	8082                	ret

000000008000485c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000485c:	1101                	addi	sp,sp,-32
    8000485e:	ec06                	sd	ra,24(sp)
    80004860:	e822                	sd	s0,16(sp)
    80004862:	e426                	sd	s1,8(sp)
    80004864:	1000                	addi	s0,sp,32
    80004866:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004868:	d14fc0ef          	jal	80000d7c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000486c:	00d5151b          	slliw	a0,a0,0xd
    80004870:	0c2017b7          	lui	a5,0xc201
    80004874:	97aa                	add	a5,a5,a0
    80004876:	c3c4                	sw	s1,4(a5)
}
    80004878:	60e2                	ld	ra,24(sp)
    8000487a:	6442                	ld	s0,16(sp)
    8000487c:	64a2                	ld	s1,8(sp)
    8000487e:	6105                	addi	sp,sp,32
    80004880:	8082                	ret

0000000080004882 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004882:	1141                	addi	sp,sp,-16
    80004884:	e406                	sd	ra,8(sp)
    80004886:	e022                	sd	s0,0(sp)
    80004888:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000488a:	479d                	li	a5,7
    8000488c:	04a7ca63          	blt	a5,a0,800048e0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004890:	00017797          	auipc	a5,0x17
    80004894:	cc078793          	addi	a5,a5,-832 # 8001b550 <disk>
    80004898:	97aa                	add	a5,a5,a0
    8000489a:	0187c783          	lbu	a5,24(a5)
    8000489e:	e7b9                	bnez	a5,800048ec <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800048a0:	00451693          	slli	a3,a0,0x4
    800048a4:	00017797          	auipc	a5,0x17
    800048a8:	cac78793          	addi	a5,a5,-852 # 8001b550 <disk>
    800048ac:	6398                	ld	a4,0(a5)
    800048ae:	9736                	add	a4,a4,a3
    800048b0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800048b4:	6398                	ld	a4,0(a5)
    800048b6:	9736                	add	a4,a4,a3
    800048b8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800048bc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800048c0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800048c4:	97aa                	add	a5,a5,a0
    800048c6:	4705                	li	a4,1
    800048c8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800048cc:	00017517          	auipc	a0,0x17
    800048d0:	c9c50513          	addi	a0,a0,-868 # 8001b568 <disk+0x18>
    800048d4:	af7fc0ef          	jal	800013ca <wakeup>
}
    800048d8:	60a2                	ld	ra,8(sp)
    800048da:	6402                	ld	s0,0(sp)
    800048dc:	0141                	addi	sp,sp,16
    800048de:	8082                	ret
    panic("free_desc 1");
    800048e0:	00003517          	auipc	a0,0x3
    800048e4:	df050513          	addi	a0,a0,-528 # 800076d0 <etext+0x6d0>
    800048e8:	43b000ef          	jal	80005522 <panic>
    panic("free_desc 2");
    800048ec:	00003517          	auipc	a0,0x3
    800048f0:	df450513          	addi	a0,a0,-524 # 800076e0 <etext+0x6e0>
    800048f4:	42f000ef          	jal	80005522 <panic>

00000000800048f8 <virtio_disk_init>:
{
    800048f8:	1101                	addi	sp,sp,-32
    800048fa:	ec06                	sd	ra,24(sp)
    800048fc:	e822                	sd	s0,16(sp)
    800048fe:	e426                	sd	s1,8(sp)
    80004900:	e04a                	sd	s2,0(sp)
    80004902:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004904:	00003597          	auipc	a1,0x3
    80004908:	dec58593          	addi	a1,a1,-532 # 800076f0 <etext+0x6f0>
    8000490c:	00017517          	auipc	a0,0x17
    80004910:	d6c50513          	addi	a0,a0,-660 # 8001b678 <disk+0x128>
    80004914:	6bd000ef          	jal	800057d0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004918:	100017b7          	lui	a5,0x10001
    8000491c:	4398                	lw	a4,0(a5)
    8000491e:	2701                	sext.w	a4,a4
    80004920:	747277b7          	lui	a5,0x74727
    80004924:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004928:	18f71063          	bne	a4,a5,80004aa8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000492c:	100017b7          	lui	a5,0x10001
    80004930:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004932:	439c                	lw	a5,0(a5)
    80004934:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004936:	4709                	li	a4,2
    80004938:	16e79863          	bne	a5,a4,80004aa8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000493c:	100017b7          	lui	a5,0x10001
    80004940:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004942:	439c                	lw	a5,0(a5)
    80004944:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004946:	16e79163          	bne	a5,a4,80004aa8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000494a:	100017b7          	lui	a5,0x10001
    8000494e:	47d8                	lw	a4,12(a5)
    80004950:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004952:	554d47b7          	lui	a5,0x554d4
    80004956:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000495a:	14f71763          	bne	a4,a5,80004aa8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000495e:	100017b7          	lui	a5,0x10001
    80004962:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004966:	4705                	li	a4,1
    80004968:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000496a:	470d                	li	a4,3
    8000496c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000496e:	10001737          	lui	a4,0x10001
    80004972:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004974:	c7ffe737          	lui	a4,0xc7ffe
    80004978:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdafcf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000497c:	8ef9                	and	a3,a3,a4
    8000497e:	10001737          	lui	a4,0x10001
    80004982:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004984:	472d                	li	a4,11
    80004986:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004988:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000498c:	439c                	lw	a5,0(a5)
    8000498e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004992:	8ba1                	andi	a5,a5,8
    80004994:	12078063          	beqz	a5,80004ab4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004998:	100017b7          	lui	a5,0x10001
    8000499c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800049a0:	100017b7          	lui	a5,0x10001
    800049a4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800049a8:	439c                	lw	a5,0(a5)
    800049aa:	2781                	sext.w	a5,a5
    800049ac:	10079a63          	bnez	a5,80004ac0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800049b0:	100017b7          	lui	a5,0x10001
    800049b4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800049b8:	439c                	lw	a5,0(a5)
    800049ba:	2781                	sext.w	a5,a5
  if(max == 0)
    800049bc:	10078863          	beqz	a5,80004acc <virtio_disk_init+0x1d4>
  if(max < NUM)
    800049c0:	471d                	li	a4,7
    800049c2:	10f77b63          	bgeu	a4,a5,80004ad8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800049c6:	f38fb0ef          	jal	800000fe <kalloc>
    800049ca:	00017497          	auipc	s1,0x17
    800049ce:	b8648493          	addi	s1,s1,-1146 # 8001b550 <disk>
    800049d2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800049d4:	f2afb0ef          	jal	800000fe <kalloc>
    800049d8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800049da:	f24fb0ef          	jal	800000fe <kalloc>
    800049de:	87aa                	mv	a5,a0
    800049e0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800049e2:	6088                	ld	a0,0(s1)
    800049e4:	10050063          	beqz	a0,80004ae4 <virtio_disk_init+0x1ec>
    800049e8:	00017717          	auipc	a4,0x17
    800049ec:	b7073703          	ld	a4,-1168(a4) # 8001b558 <disk+0x8>
    800049f0:	0e070a63          	beqz	a4,80004ae4 <virtio_disk_init+0x1ec>
    800049f4:	0e078863          	beqz	a5,80004ae4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800049f8:	6605                	lui	a2,0x1
    800049fa:	4581                	li	a1,0
    800049fc:	f94fb0ef          	jal	80000190 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004a00:	00017497          	auipc	s1,0x17
    80004a04:	b5048493          	addi	s1,s1,-1200 # 8001b550 <disk>
    80004a08:	6605                	lui	a2,0x1
    80004a0a:	4581                	li	a1,0
    80004a0c:	6488                	ld	a0,8(s1)
    80004a0e:	f82fb0ef          	jal	80000190 <memset>
  memset(disk.used, 0, PGSIZE);
    80004a12:	6605                	lui	a2,0x1
    80004a14:	4581                	li	a1,0
    80004a16:	6888                	ld	a0,16(s1)
    80004a18:	f78fb0ef          	jal	80000190 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004a1c:	100017b7          	lui	a5,0x10001
    80004a20:	4721                	li	a4,8
    80004a22:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004a24:	4098                	lw	a4,0(s1)
    80004a26:	100017b7          	lui	a5,0x10001
    80004a2a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004a2e:	40d8                	lw	a4,4(s1)
    80004a30:	100017b7          	lui	a5,0x10001
    80004a34:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004a38:	649c                	ld	a5,8(s1)
    80004a3a:	0007869b          	sext.w	a3,a5
    80004a3e:	10001737          	lui	a4,0x10001
    80004a42:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004a46:	9781                	srai	a5,a5,0x20
    80004a48:	10001737          	lui	a4,0x10001
    80004a4c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004a50:	689c                	ld	a5,16(s1)
    80004a52:	0007869b          	sext.w	a3,a5
    80004a56:	10001737          	lui	a4,0x10001
    80004a5a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004a5e:	9781                	srai	a5,a5,0x20
    80004a60:	10001737          	lui	a4,0x10001
    80004a64:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004a68:	10001737          	lui	a4,0x10001
    80004a6c:	4785                	li	a5,1
    80004a6e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004a70:	00f48c23          	sb	a5,24(s1)
    80004a74:	00f48ca3          	sb	a5,25(s1)
    80004a78:	00f48d23          	sb	a5,26(s1)
    80004a7c:	00f48da3          	sb	a5,27(s1)
    80004a80:	00f48e23          	sb	a5,28(s1)
    80004a84:	00f48ea3          	sb	a5,29(s1)
    80004a88:	00f48f23          	sb	a5,30(s1)
    80004a8c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004a90:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a94:	100017b7          	lui	a5,0x10001
    80004a98:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004a9c:	60e2                	ld	ra,24(sp)
    80004a9e:	6442                	ld	s0,16(sp)
    80004aa0:	64a2                	ld	s1,8(sp)
    80004aa2:	6902                	ld	s2,0(sp)
    80004aa4:	6105                	addi	sp,sp,32
    80004aa6:	8082                	ret
    panic("could not find virtio disk");
    80004aa8:	00003517          	auipc	a0,0x3
    80004aac:	c5850513          	addi	a0,a0,-936 # 80007700 <etext+0x700>
    80004ab0:	273000ef          	jal	80005522 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004ab4:	00003517          	auipc	a0,0x3
    80004ab8:	c6c50513          	addi	a0,a0,-916 # 80007720 <etext+0x720>
    80004abc:	267000ef          	jal	80005522 <panic>
    panic("virtio disk should not be ready");
    80004ac0:	00003517          	auipc	a0,0x3
    80004ac4:	c8050513          	addi	a0,a0,-896 # 80007740 <etext+0x740>
    80004ac8:	25b000ef          	jal	80005522 <panic>
    panic("virtio disk has no queue 0");
    80004acc:	00003517          	auipc	a0,0x3
    80004ad0:	c9450513          	addi	a0,a0,-876 # 80007760 <etext+0x760>
    80004ad4:	24f000ef          	jal	80005522 <panic>
    panic("virtio disk max queue too short");
    80004ad8:	00003517          	auipc	a0,0x3
    80004adc:	ca850513          	addi	a0,a0,-856 # 80007780 <etext+0x780>
    80004ae0:	243000ef          	jal	80005522 <panic>
    panic("virtio disk kalloc");
    80004ae4:	00003517          	auipc	a0,0x3
    80004ae8:	cbc50513          	addi	a0,a0,-836 # 800077a0 <etext+0x7a0>
    80004aec:	237000ef          	jal	80005522 <panic>

0000000080004af0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004af0:	7159                	addi	sp,sp,-112
    80004af2:	f486                	sd	ra,104(sp)
    80004af4:	f0a2                	sd	s0,96(sp)
    80004af6:	eca6                	sd	s1,88(sp)
    80004af8:	e8ca                	sd	s2,80(sp)
    80004afa:	e4ce                	sd	s3,72(sp)
    80004afc:	e0d2                	sd	s4,64(sp)
    80004afe:	fc56                	sd	s5,56(sp)
    80004b00:	f85a                	sd	s6,48(sp)
    80004b02:	f45e                	sd	s7,40(sp)
    80004b04:	f062                	sd	s8,32(sp)
    80004b06:	ec66                	sd	s9,24(sp)
    80004b08:	1880                	addi	s0,sp,112
    80004b0a:	8a2a                	mv	s4,a0
    80004b0c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004b0e:	00c52c83          	lw	s9,12(a0)
    80004b12:	001c9c9b          	slliw	s9,s9,0x1
    80004b16:	1c82                	slli	s9,s9,0x20
    80004b18:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004b1c:	00017517          	auipc	a0,0x17
    80004b20:	b5c50513          	addi	a0,a0,-1188 # 8001b678 <disk+0x128>
    80004b24:	52d000ef          	jal	80005850 <acquire>
  for(int i = 0; i < 3; i++){
    80004b28:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004b2a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004b2c:	00017b17          	auipc	s6,0x17
    80004b30:	a24b0b13          	addi	s6,s6,-1500 # 8001b550 <disk>
  for(int i = 0; i < 3; i++){
    80004b34:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b36:	00017c17          	auipc	s8,0x17
    80004b3a:	b42c0c13          	addi	s8,s8,-1214 # 8001b678 <disk+0x128>
    80004b3e:	a8b9                	j	80004b9c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004b40:	00fb0733          	add	a4,s6,a5
    80004b44:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004b48:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004b4a:	0207c563          	bltz	a5,80004b74 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004b4e:	2905                	addiw	s2,s2,1
    80004b50:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004b52:	05590963          	beq	s2,s5,80004ba4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004b56:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004b58:	00017717          	auipc	a4,0x17
    80004b5c:	9f870713          	addi	a4,a4,-1544 # 8001b550 <disk>
    80004b60:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004b62:	01874683          	lbu	a3,24(a4)
    80004b66:	fee9                	bnez	a3,80004b40 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004b68:	2785                	addiw	a5,a5,1
    80004b6a:	0705                	addi	a4,a4,1
    80004b6c:	fe979be3          	bne	a5,s1,80004b62 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004b70:	57fd                	li	a5,-1
    80004b72:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004b74:	01205d63          	blez	s2,80004b8e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004b78:	f9042503          	lw	a0,-112(s0)
    80004b7c:	d07ff0ef          	jal	80004882 <free_desc>
      for(int j = 0; j < i; j++)
    80004b80:	4785                	li	a5,1
    80004b82:	0127d663          	bge	a5,s2,80004b8e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004b86:	f9442503          	lw	a0,-108(s0)
    80004b8a:	cf9ff0ef          	jal	80004882 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b8e:	85e2                	mv	a1,s8
    80004b90:	00017517          	auipc	a0,0x17
    80004b94:	9d850513          	addi	a0,a0,-1576 # 8001b568 <disk+0x18>
    80004b98:	fe6fc0ef          	jal	8000137e <sleep>
  for(int i = 0; i < 3; i++){
    80004b9c:	f9040613          	addi	a2,s0,-112
    80004ba0:	894e                	mv	s2,s3
    80004ba2:	bf55                	j	80004b56 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004ba4:	f9042503          	lw	a0,-112(s0)
    80004ba8:	00451693          	slli	a3,a0,0x4

  if(write)
    80004bac:	00017797          	auipc	a5,0x17
    80004bb0:	9a478793          	addi	a5,a5,-1628 # 8001b550 <disk>
    80004bb4:	00a50713          	addi	a4,a0,10
    80004bb8:	0712                	slli	a4,a4,0x4
    80004bba:	973e                	add	a4,a4,a5
    80004bbc:	01703633          	snez	a2,s7
    80004bc0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004bc2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004bc6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004bca:	6398                	ld	a4,0(a5)
    80004bcc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004bce:	0a868613          	addi	a2,a3,168
    80004bd2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004bd4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004bd6:	6390                	ld	a2,0(a5)
    80004bd8:	00d605b3          	add	a1,a2,a3
    80004bdc:	4741                	li	a4,16
    80004bde:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004be0:	4805                	li	a6,1
    80004be2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004be6:	f9442703          	lw	a4,-108(s0)
    80004bea:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004bee:	0712                	slli	a4,a4,0x4
    80004bf0:	963a                	add	a2,a2,a4
    80004bf2:	058a0593          	addi	a1,s4,88
    80004bf6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004bf8:	0007b883          	ld	a7,0(a5)
    80004bfc:	9746                	add	a4,a4,a7
    80004bfe:	40000613          	li	a2,1024
    80004c02:	c710                	sw	a2,8(a4)
  if(write)
    80004c04:	001bb613          	seqz	a2,s7
    80004c08:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004c0c:	00166613          	ori	a2,a2,1
    80004c10:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004c14:	f9842583          	lw	a1,-104(s0)
    80004c18:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004c1c:	00250613          	addi	a2,a0,2
    80004c20:	0612                	slli	a2,a2,0x4
    80004c22:	963e                	add	a2,a2,a5
    80004c24:	577d                	li	a4,-1
    80004c26:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004c2a:	0592                	slli	a1,a1,0x4
    80004c2c:	98ae                	add	a7,a7,a1
    80004c2e:	03068713          	addi	a4,a3,48
    80004c32:	973e                	add	a4,a4,a5
    80004c34:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004c38:	6398                	ld	a4,0(a5)
    80004c3a:	972e                	add	a4,a4,a1
    80004c3c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004c40:	4689                	li	a3,2
    80004c42:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004c46:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004c4a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004c4e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004c52:	6794                	ld	a3,8(a5)
    80004c54:	0026d703          	lhu	a4,2(a3)
    80004c58:	8b1d                	andi	a4,a4,7
    80004c5a:	0706                	slli	a4,a4,0x1
    80004c5c:	96ba                	add	a3,a3,a4
    80004c5e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004c62:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004c66:	6798                	ld	a4,8(a5)
    80004c68:	00275783          	lhu	a5,2(a4)
    80004c6c:	2785                	addiw	a5,a5,1
    80004c6e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004c72:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004c76:	100017b7          	lui	a5,0x10001
    80004c7a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004c7e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004c82:	00017917          	auipc	s2,0x17
    80004c86:	9f690913          	addi	s2,s2,-1546 # 8001b678 <disk+0x128>
  while(b->disk == 1) {
    80004c8a:	4485                	li	s1,1
    80004c8c:	01079a63          	bne	a5,a6,80004ca0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004c90:	85ca                	mv	a1,s2
    80004c92:	8552                	mv	a0,s4
    80004c94:	eeafc0ef          	jal	8000137e <sleep>
  while(b->disk == 1) {
    80004c98:	004a2783          	lw	a5,4(s4)
    80004c9c:	fe978ae3          	beq	a5,s1,80004c90 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004ca0:	f9042903          	lw	s2,-112(s0)
    80004ca4:	00290713          	addi	a4,s2,2
    80004ca8:	0712                	slli	a4,a4,0x4
    80004caa:	00017797          	auipc	a5,0x17
    80004cae:	8a678793          	addi	a5,a5,-1882 # 8001b550 <disk>
    80004cb2:	97ba                	add	a5,a5,a4
    80004cb4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004cb8:	00017997          	auipc	s3,0x17
    80004cbc:	89898993          	addi	s3,s3,-1896 # 8001b550 <disk>
    80004cc0:	00491713          	slli	a4,s2,0x4
    80004cc4:	0009b783          	ld	a5,0(s3)
    80004cc8:	97ba                	add	a5,a5,a4
    80004cca:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004cce:	854a                	mv	a0,s2
    80004cd0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004cd4:	bafff0ef          	jal	80004882 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004cd8:	8885                	andi	s1,s1,1
    80004cda:	f0fd                	bnez	s1,80004cc0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004cdc:	00017517          	auipc	a0,0x17
    80004ce0:	99c50513          	addi	a0,a0,-1636 # 8001b678 <disk+0x128>
    80004ce4:	405000ef          	jal	800058e8 <release>
}
    80004ce8:	70a6                	ld	ra,104(sp)
    80004cea:	7406                	ld	s0,96(sp)
    80004cec:	64e6                	ld	s1,88(sp)
    80004cee:	6946                	ld	s2,80(sp)
    80004cf0:	69a6                	ld	s3,72(sp)
    80004cf2:	6a06                	ld	s4,64(sp)
    80004cf4:	7ae2                	ld	s5,56(sp)
    80004cf6:	7b42                	ld	s6,48(sp)
    80004cf8:	7ba2                	ld	s7,40(sp)
    80004cfa:	7c02                	ld	s8,32(sp)
    80004cfc:	6ce2                	ld	s9,24(sp)
    80004cfe:	6165                	addi	sp,sp,112
    80004d00:	8082                	ret

0000000080004d02 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004d02:	1101                	addi	sp,sp,-32
    80004d04:	ec06                	sd	ra,24(sp)
    80004d06:	e822                	sd	s0,16(sp)
    80004d08:	e426                	sd	s1,8(sp)
    80004d0a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004d0c:	00017497          	auipc	s1,0x17
    80004d10:	84448493          	addi	s1,s1,-1980 # 8001b550 <disk>
    80004d14:	00017517          	auipc	a0,0x17
    80004d18:	96450513          	addi	a0,a0,-1692 # 8001b678 <disk+0x128>
    80004d1c:	335000ef          	jal	80005850 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004d20:	100017b7          	lui	a5,0x10001
    80004d24:	53b8                	lw	a4,96(a5)
    80004d26:	8b0d                	andi	a4,a4,3
    80004d28:	100017b7          	lui	a5,0x10001
    80004d2c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004d2e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004d32:	689c                	ld	a5,16(s1)
    80004d34:	0204d703          	lhu	a4,32(s1)
    80004d38:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004d3c:	04f70663          	beq	a4,a5,80004d88 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004d40:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004d44:	6898                	ld	a4,16(s1)
    80004d46:	0204d783          	lhu	a5,32(s1)
    80004d4a:	8b9d                	andi	a5,a5,7
    80004d4c:	078e                	slli	a5,a5,0x3
    80004d4e:	97ba                	add	a5,a5,a4
    80004d50:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004d52:	00278713          	addi	a4,a5,2
    80004d56:	0712                	slli	a4,a4,0x4
    80004d58:	9726                	add	a4,a4,s1
    80004d5a:	01074703          	lbu	a4,16(a4)
    80004d5e:	e321                	bnez	a4,80004d9e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004d60:	0789                	addi	a5,a5,2
    80004d62:	0792                	slli	a5,a5,0x4
    80004d64:	97a6                	add	a5,a5,s1
    80004d66:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004d68:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004d6c:	e5efc0ef          	jal	800013ca <wakeup>

    disk.used_idx += 1;
    80004d70:	0204d783          	lhu	a5,32(s1)
    80004d74:	2785                	addiw	a5,a5,1
    80004d76:	17c2                	slli	a5,a5,0x30
    80004d78:	93c1                	srli	a5,a5,0x30
    80004d7a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004d7e:	6898                	ld	a4,16(s1)
    80004d80:	00275703          	lhu	a4,2(a4)
    80004d84:	faf71ee3          	bne	a4,a5,80004d40 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004d88:	00017517          	auipc	a0,0x17
    80004d8c:	8f050513          	addi	a0,a0,-1808 # 8001b678 <disk+0x128>
    80004d90:	359000ef          	jal	800058e8 <release>
}
    80004d94:	60e2                	ld	ra,24(sp)
    80004d96:	6442                	ld	s0,16(sp)
    80004d98:	64a2                	ld	s1,8(sp)
    80004d9a:	6105                	addi	sp,sp,32
    80004d9c:	8082                	ret
      panic("virtio_disk_intr status");
    80004d9e:	00003517          	auipc	a0,0x3
    80004da2:	a1a50513          	addi	a0,a0,-1510 # 800077b8 <etext+0x7b8>
    80004da6:	77c000ef          	jal	80005522 <panic>

0000000080004daa <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004daa:	1141                	addi	sp,sp,-16
    80004dac:	e422                	sd	s0,8(sp)
    80004dae:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004db0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004db4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004db8:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004dbc:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004dc0:	577d                	li	a4,-1
    80004dc2:	177e                	slli	a4,a4,0x3f
    80004dc4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004dc6:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004dca:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004dce:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004dd2:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004dd6:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004dda:	000f4737          	lui	a4,0xf4
    80004dde:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004de2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004de4:	14d79073          	csrw	stimecmp,a5
}
    80004de8:	6422                	ld	s0,8(sp)
    80004dea:	0141                	addi	sp,sp,16
    80004dec:	8082                	ret

0000000080004dee <start>:
{
    80004dee:	1141                	addi	sp,sp,-16
    80004df0:	e406                	sd	ra,8(sp)
    80004df2:	e022                	sd	s0,0(sp)
    80004df4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004df6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004dfa:	7779                	lui	a4,0xffffe
    80004dfc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb06f>
    80004e00:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004e02:	6705                	lui	a4,0x1
    80004e04:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004e08:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004e0a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004e0e:	ffffb797          	auipc	a5,0xffffb
    80004e12:	51c78793          	addi	a5,a5,1308 # 8000032a <main>
    80004e16:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004e1a:	4781                	li	a5,0
    80004e1c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004e20:	67c1                	lui	a5,0x10
    80004e22:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004e24:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004e28:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004e2c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004e30:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004e34:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004e38:	57fd                	li	a5,-1
    80004e3a:	83a9                	srli	a5,a5,0xa
    80004e3c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004e40:	47bd                	li	a5,15
    80004e42:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004e46:	f65ff0ef          	jal	80004daa <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004e4a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004e4e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004e50:	823e                	mv	tp,a5
  asm volatile("mret");
    80004e52:	30200073          	mret
}
    80004e56:	60a2                	ld	ra,8(sp)
    80004e58:	6402                	ld	s0,0(sp)
    80004e5a:	0141                	addi	sp,sp,16
    80004e5c:	8082                	ret

0000000080004e5e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004e5e:	715d                	addi	sp,sp,-80
    80004e60:	e486                	sd	ra,72(sp)
    80004e62:	e0a2                	sd	s0,64(sp)
    80004e64:	f84a                	sd	s2,48(sp)
    80004e66:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004e68:	04c05263          	blez	a2,80004eac <consolewrite+0x4e>
    80004e6c:	fc26                	sd	s1,56(sp)
    80004e6e:	f44e                	sd	s3,40(sp)
    80004e70:	f052                	sd	s4,32(sp)
    80004e72:	ec56                	sd	s5,24(sp)
    80004e74:	8a2a                	mv	s4,a0
    80004e76:	84ae                	mv	s1,a1
    80004e78:	89b2                	mv	s3,a2
    80004e7a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004e7c:	5afd                	li	s5,-1
    80004e7e:	4685                	li	a3,1
    80004e80:	8626                	mv	a2,s1
    80004e82:	85d2                	mv	a1,s4
    80004e84:	fbf40513          	addi	a0,s0,-65
    80004e88:	89dfc0ef          	jal	80001724 <either_copyin>
    80004e8c:	03550263          	beq	a0,s5,80004eb0 <consolewrite+0x52>
      break;
    uartputc(c);
    80004e90:	fbf44503          	lbu	a0,-65(s0)
    80004e94:	035000ef          	jal	800056c8 <uartputc>
  for(i = 0; i < n; i++){
    80004e98:	2905                	addiw	s2,s2,1
    80004e9a:	0485                	addi	s1,s1,1
    80004e9c:	ff2991e3          	bne	s3,s2,80004e7e <consolewrite+0x20>
    80004ea0:	894e                	mv	s2,s3
    80004ea2:	74e2                	ld	s1,56(sp)
    80004ea4:	79a2                	ld	s3,40(sp)
    80004ea6:	7a02                	ld	s4,32(sp)
    80004ea8:	6ae2                	ld	s5,24(sp)
    80004eaa:	a039                	j	80004eb8 <consolewrite+0x5a>
    80004eac:	4901                	li	s2,0
    80004eae:	a029                	j	80004eb8 <consolewrite+0x5a>
    80004eb0:	74e2                	ld	s1,56(sp)
    80004eb2:	79a2                	ld	s3,40(sp)
    80004eb4:	7a02                	ld	s4,32(sp)
    80004eb6:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004eb8:	854a                	mv	a0,s2
    80004eba:	60a6                	ld	ra,72(sp)
    80004ebc:	6406                	ld	s0,64(sp)
    80004ebe:	7942                	ld	s2,48(sp)
    80004ec0:	6161                	addi	sp,sp,80
    80004ec2:	8082                	ret

0000000080004ec4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004ec4:	711d                	addi	sp,sp,-96
    80004ec6:	ec86                	sd	ra,88(sp)
    80004ec8:	e8a2                	sd	s0,80(sp)
    80004eca:	e4a6                	sd	s1,72(sp)
    80004ecc:	e0ca                	sd	s2,64(sp)
    80004ece:	fc4e                	sd	s3,56(sp)
    80004ed0:	f852                	sd	s4,48(sp)
    80004ed2:	f456                	sd	s5,40(sp)
    80004ed4:	f05a                	sd	s6,32(sp)
    80004ed6:	1080                	addi	s0,sp,96
    80004ed8:	8aaa                	mv	s5,a0
    80004eda:	8a2e                	mv	s4,a1
    80004edc:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004ede:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004ee2:	0001e517          	auipc	a0,0x1e
    80004ee6:	7ae50513          	addi	a0,a0,1966 # 80023690 <cons>
    80004eea:	167000ef          	jal	80005850 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004eee:	0001e497          	auipc	s1,0x1e
    80004ef2:	7a248493          	addi	s1,s1,1954 # 80023690 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004ef6:	0001f917          	auipc	s2,0x1f
    80004efa:	83290913          	addi	s2,s2,-1998 # 80023728 <cons+0x98>
  while(n > 0){
    80004efe:	0b305d63          	blez	s3,80004fb8 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004f02:	0984a783          	lw	a5,152(s1)
    80004f06:	09c4a703          	lw	a4,156(s1)
    80004f0a:	0af71263          	bne	a4,a5,80004fae <consoleread+0xea>
      if(killed(myproc())){
    80004f0e:	e9bfb0ef          	jal	80000da8 <myproc>
    80004f12:	ea4fc0ef          	jal	800015b6 <killed>
    80004f16:	e12d                	bnez	a0,80004f78 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004f18:	85a6                	mv	a1,s1
    80004f1a:	854a                	mv	a0,s2
    80004f1c:	c62fc0ef          	jal	8000137e <sleep>
    while(cons.r == cons.w){
    80004f20:	0984a783          	lw	a5,152(s1)
    80004f24:	09c4a703          	lw	a4,156(s1)
    80004f28:	fef703e3          	beq	a4,a5,80004f0e <consoleread+0x4a>
    80004f2c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004f2e:	0001e717          	auipc	a4,0x1e
    80004f32:	76270713          	addi	a4,a4,1890 # 80023690 <cons>
    80004f36:	0017869b          	addiw	a3,a5,1
    80004f3a:	08d72c23          	sw	a3,152(a4)
    80004f3e:	07f7f693          	andi	a3,a5,127
    80004f42:	9736                	add	a4,a4,a3
    80004f44:	01874703          	lbu	a4,24(a4)
    80004f48:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004f4c:	4691                	li	a3,4
    80004f4e:	04db8663          	beq	s7,a3,80004f9a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004f52:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004f56:	4685                	li	a3,1
    80004f58:	faf40613          	addi	a2,s0,-81
    80004f5c:	85d2                	mv	a1,s4
    80004f5e:	8556                	mv	a0,s5
    80004f60:	f7afc0ef          	jal	800016da <either_copyout>
    80004f64:	57fd                	li	a5,-1
    80004f66:	04f50863          	beq	a0,a5,80004fb6 <consoleread+0xf2>
      break;

    dst++;
    80004f6a:	0a05                	addi	s4,s4,1
    --n;
    80004f6c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004f6e:	47a9                	li	a5,10
    80004f70:	04fb8d63          	beq	s7,a5,80004fca <consoleread+0x106>
    80004f74:	6be2                	ld	s7,24(sp)
    80004f76:	b761                	j	80004efe <consoleread+0x3a>
        release(&cons.lock);
    80004f78:	0001e517          	auipc	a0,0x1e
    80004f7c:	71850513          	addi	a0,a0,1816 # 80023690 <cons>
    80004f80:	169000ef          	jal	800058e8 <release>
        return -1;
    80004f84:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004f86:	60e6                	ld	ra,88(sp)
    80004f88:	6446                	ld	s0,80(sp)
    80004f8a:	64a6                	ld	s1,72(sp)
    80004f8c:	6906                	ld	s2,64(sp)
    80004f8e:	79e2                	ld	s3,56(sp)
    80004f90:	7a42                	ld	s4,48(sp)
    80004f92:	7aa2                	ld	s5,40(sp)
    80004f94:	7b02                	ld	s6,32(sp)
    80004f96:	6125                	addi	sp,sp,96
    80004f98:	8082                	ret
      if(n < target){
    80004f9a:	0009871b          	sext.w	a4,s3
    80004f9e:	01677a63          	bgeu	a4,s6,80004fb2 <consoleread+0xee>
        cons.r--;
    80004fa2:	0001e717          	auipc	a4,0x1e
    80004fa6:	78f72323          	sw	a5,1926(a4) # 80023728 <cons+0x98>
    80004faa:	6be2                	ld	s7,24(sp)
    80004fac:	a031                	j	80004fb8 <consoleread+0xf4>
    80004fae:	ec5e                	sd	s7,24(sp)
    80004fb0:	bfbd                	j	80004f2e <consoleread+0x6a>
    80004fb2:	6be2                	ld	s7,24(sp)
    80004fb4:	a011                	j	80004fb8 <consoleread+0xf4>
    80004fb6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004fb8:	0001e517          	auipc	a0,0x1e
    80004fbc:	6d850513          	addi	a0,a0,1752 # 80023690 <cons>
    80004fc0:	129000ef          	jal	800058e8 <release>
  return target - n;
    80004fc4:	413b053b          	subw	a0,s6,s3
    80004fc8:	bf7d                	j	80004f86 <consoleread+0xc2>
    80004fca:	6be2                	ld	s7,24(sp)
    80004fcc:	b7f5                	j	80004fb8 <consoleread+0xf4>

0000000080004fce <consputc>:
{
    80004fce:	1141                	addi	sp,sp,-16
    80004fd0:	e406                	sd	ra,8(sp)
    80004fd2:	e022                	sd	s0,0(sp)
    80004fd4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004fd6:	10000793          	li	a5,256
    80004fda:	00f50863          	beq	a0,a5,80004fea <consputc+0x1c>
    uartputc_sync(c);
    80004fde:	604000ef          	jal	800055e2 <uartputc_sync>
}
    80004fe2:	60a2                	ld	ra,8(sp)
    80004fe4:	6402                	ld	s0,0(sp)
    80004fe6:	0141                	addi	sp,sp,16
    80004fe8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004fea:	4521                	li	a0,8
    80004fec:	5f6000ef          	jal	800055e2 <uartputc_sync>
    80004ff0:	02000513          	li	a0,32
    80004ff4:	5ee000ef          	jal	800055e2 <uartputc_sync>
    80004ff8:	4521                	li	a0,8
    80004ffa:	5e8000ef          	jal	800055e2 <uartputc_sync>
    80004ffe:	b7d5                	j	80004fe2 <consputc+0x14>

0000000080005000 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005000:	1101                	addi	sp,sp,-32
    80005002:	ec06                	sd	ra,24(sp)
    80005004:	e822                	sd	s0,16(sp)
    80005006:	e426                	sd	s1,8(sp)
    80005008:	1000                	addi	s0,sp,32
    8000500a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000500c:	0001e517          	auipc	a0,0x1e
    80005010:	68450513          	addi	a0,a0,1668 # 80023690 <cons>
    80005014:	03d000ef          	jal	80005850 <acquire>

  switch(c){
    80005018:	47d5                	li	a5,21
    8000501a:	08f48f63          	beq	s1,a5,800050b8 <consoleintr+0xb8>
    8000501e:	0297c563          	blt	a5,s1,80005048 <consoleintr+0x48>
    80005022:	47a1                	li	a5,8
    80005024:	0ef48463          	beq	s1,a5,8000510c <consoleintr+0x10c>
    80005028:	47c1                	li	a5,16
    8000502a:	10f49563          	bne	s1,a5,80005134 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000502e:	f40fc0ef          	jal	8000176e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005032:	0001e517          	auipc	a0,0x1e
    80005036:	65e50513          	addi	a0,a0,1630 # 80023690 <cons>
    8000503a:	0af000ef          	jal	800058e8 <release>
}
    8000503e:	60e2                	ld	ra,24(sp)
    80005040:	6442                	ld	s0,16(sp)
    80005042:	64a2                	ld	s1,8(sp)
    80005044:	6105                	addi	sp,sp,32
    80005046:	8082                	ret
  switch(c){
    80005048:	07f00793          	li	a5,127
    8000504c:	0cf48063          	beq	s1,a5,8000510c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005050:	0001e717          	auipc	a4,0x1e
    80005054:	64070713          	addi	a4,a4,1600 # 80023690 <cons>
    80005058:	0a072783          	lw	a5,160(a4)
    8000505c:	09872703          	lw	a4,152(a4)
    80005060:	9f99                	subw	a5,a5,a4
    80005062:	07f00713          	li	a4,127
    80005066:	fcf766e3          	bltu	a4,a5,80005032 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000506a:	47b5                	li	a5,13
    8000506c:	0cf48763          	beq	s1,a5,8000513a <consoleintr+0x13a>
      consputc(c);
    80005070:	8526                	mv	a0,s1
    80005072:	f5dff0ef          	jal	80004fce <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005076:	0001e797          	auipc	a5,0x1e
    8000507a:	61a78793          	addi	a5,a5,1562 # 80023690 <cons>
    8000507e:	0a07a683          	lw	a3,160(a5)
    80005082:	0016871b          	addiw	a4,a3,1
    80005086:	0007061b          	sext.w	a2,a4
    8000508a:	0ae7a023          	sw	a4,160(a5)
    8000508e:	07f6f693          	andi	a3,a3,127
    80005092:	97b6                	add	a5,a5,a3
    80005094:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005098:	47a9                	li	a5,10
    8000509a:	0cf48563          	beq	s1,a5,80005164 <consoleintr+0x164>
    8000509e:	4791                	li	a5,4
    800050a0:	0cf48263          	beq	s1,a5,80005164 <consoleintr+0x164>
    800050a4:	0001e797          	auipc	a5,0x1e
    800050a8:	6847a783          	lw	a5,1668(a5) # 80023728 <cons+0x98>
    800050ac:	9f1d                	subw	a4,a4,a5
    800050ae:	08000793          	li	a5,128
    800050b2:	f8f710e3          	bne	a4,a5,80005032 <consoleintr+0x32>
    800050b6:	a07d                	j	80005164 <consoleintr+0x164>
    800050b8:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800050ba:	0001e717          	auipc	a4,0x1e
    800050be:	5d670713          	addi	a4,a4,1494 # 80023690 <cons>
    800050c2:	0a072783          	lw	a5,160(a4)
    800050c6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050ca:	0001e497          	auipc	s1,0x1e
    800050ce:	5c648493          	addi	s1,s1,1478 # 80023690 <cons>
    while(cons.e != cons.w &&
    800050d2:	4929                	li	s2,10
    800050d4:	02f70863          	beq	a4,a5,80005104 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050d8:	37fd                	addiw	a5,a5,-1
    800050da:	07f7f713          	andi	a4,a5,127
    800050de:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800050e0:	01874703          	lbu	a4,24(a4)
    800050e4:	03270263          	beq	a4,s2,80005108 <consoleintr+0x108>
      cons.e--;
    800050e8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800050ec:	10000513          	li	a0,256
    800050f0:	edfff0ef          	jal	80004fce <consputc>
    while(cons.e != cons.w &&
    800050f4:	0a04a783          	lw	a5,160(s1)
    800050f8:	09c4a703          	lw	a4,156(s1)
    800050fc:	fcf71ee3          	bne	a4,a5,800050d8 <consoleintr+0xd8>
    80005100:	6902                	ld	s2,0(sp)
    80005102:	bf05                	j	80005032 <consoleintr+0x32>
    80005104:	6902                	ld	s2,0(sp)
    80005106:	b735                	j	80005032 <consoleintr+0x32>
    80005108:	6902                	ld	s2,0(sp)
    8000510a:	b725                	j	80005032 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000510c:	0001e717          	auipc	a4,0x1e
    80005110:	58470713          	addi	a4,a4,1412 # 80023690 <cons>
    80005114:	0a072783          	lw	a5,160(a4)
    80005118:	09c72703          	lw	a4,156(a4)
    8000511c:	f0f70be3          	beq	a4,a5,80005032 <consoleintr+0x32>
      cons.e--;
    80005120:	37fd                	addiw	a5,a5,-1
    80005122:	0001e717          	auipc	a4,0x1e
    80005126:	60f72723          	sw	a5,1550(a4) # 80023730 <cons+0xa0>
      consputc(BACKSPACE);
    8000512a:	10000513          	li	a0,256
    8000512e:	ea1ff0ef          	jal	80004fce <consputc>
    80005132:	b701                	j	80005032 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005134:	ee048fe3          	beqz	s1,80005032 <consoleintr+0x32>
    80005138:	bf21                	j	80005050 <consoleintr+0x50>
      consputc(c);
    8000513a:	4529                	li	a0,10
    8000513c:	e93ff0ef          	jal	80004fce <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005140:	0001e797          	auipc	a5,0x1e
    80005144:	55078793          	addi	a5,a5,1360 # 80023690 <cons>
    80005148:	0a07a703          	lw	a4,160(a5)
    8000514c:	0017069b          	addiw	a3,a4,1
    80005150:	0006861b          	sext.w	a2,a3
    80005154:	0ad7a023          	sw	a3,160(a5)
    80005158:	07f77713          	andi	a4,a4,127
    8000515c:	97ba                	add	a5,a5,a4
    8000515e:	4729                	li	a4,10
    80005160:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005164:	0001e797          	auipc	a5,0x1e
    80005168:	5cc7a423          	sw	a2,1480(a5) # 8002372c <cons+0x9c>
        wakeup(&cons.r);
    8000516c:	0001e517          	auipc	a0,0x1e
    80005170:	5bc50513          	addi	a0,a0,1468 # 80023728 <cons+0x98>
    80005174:	a56fc0ef          	jal	800013ca <wakeup>
    80005178:	bd6d                	j	80005032 <consoleintr+0x32>

000000008000517a <consoleinit>:

void
consoleinit(void)
{
    8000517a:	1141                	addi	sp,sp,-16
    8000517c:	e406                	sd	ra,8(sp)
    8000517e:	e022                	sd	s0,0(sp)
    80005180:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005182:	00002597          	auipc	a1,0x2
    80005186:	64e58593          	addi	a1,a1,1614 # 800077d0 <etext+0x7d0>
    8000518a:	0001e517          	auipc	a0,0x1e
    8000518e:	50650513          	addi	a0,a0,1286 # 80023690 <cons>
    80005192:	63e000ef          	jal	800057d0 <initlock>

  uartinit();
    80005196:	3f4000ef          	jal	8000558a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000519a:	00015797          	auipc	a5,0x15
    8000519e:	35e78793          	addi	a5,a5,862 # 8001a4f8 <devsw>
    800051a2:	00000717          	auipc	a4,0x0
    800051a6:	d2270713          	addi	a4,a4,-734 # 80004ec4 <consoleread>
    800051aa:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800051ac:	00000717          	auipc	a4,0x0
    800051b0:	cb270713          	addi	a4,a4,-846 # 80004e5e <consolewrite>
    800051b4:	ef98                	sd	a4,24(a5)
}
    800051b6:	60a2                	ld	ra,8(sp)
    800051b8:	6402                	ld	s0,0(sp)
    800051ba:	0141                	addi	sp,sp,16
    800051bc:	8082                	ret

00000000800051be <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800051be:	7179                	addi	sp,sp,-48
    800051c0:	f406                	sd	ra,40(sp)
    800051c2:	f022                	sd	s0,32(sp)
    800051c4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800051c6:	c219                	beqz	a2,800051cc <printint+0xe>
    800051c8:	08054063          	bltz	a0,80005248 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800051cc:	4881                	li	a7,0
    800051ce:	fd040693          	addi	a3,s0,-48

  i = 0;
    800051d2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800051d4:	00003617          	auipc	a2,0x3
    800051d8:	82460613          	addi	a2,a2,-2012 # 800079f8 <digits>
    800051dc:	883e                	mv	a6,a5
    800051de:	2785                	addiw	a5,a5,1
    800051e0:	02b57733          	remu	a4,a0,a1
    800051e4:	9732                	add	a4,a4,a2
    800051e6:	00074703          	lbu	a4,0(a4)
    800051ea:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800051ee:	872a                	mv	a4,a0
    800051f0:	02b55533          	divu	a0,a0,a1
    800051f4:	0685                	addi	a3,a3,1
    800051f6:	feb773e3          	bgeu	a4,a1,800051dc <printint+0x1e>

  if(sign)
    800051fa:	00088a63          	beqz	a7,8000520e <printint+0x50>
    buf[i++] = '-';
    800051fe:	1781                	addi	a5,a5,-32
    80005200:	97a2                	add	a5,a5,s0
    80005202:	02d00713          	li	a4,45
    80005206:	fee78823          	sb	a4,-16(a5)
    8000520a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000520e:	02f05963          	blez	a5,80005240 <printint+0x82>
    80005212:	ec26                	sd	s1,24(sp)
    80005214:	e84a                	sd	s2,16(sp)
    80005216:	fd040713          	addi	a4,s0,-48
    8000521a:	00f704b3          	add	s1,a4,a5
    8000521e:	fff70913          	addi	s2,a4,-1
    80005222:	993e                	add	s2,s2,a5
    80005224:	37fd                	addiw	a5,a5,-1
    80005226:	1782                	slli	a5,a5,0x20
    80005228:	9381                	srli	a5,a5,0x20
    8000522a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000522e:	fff4c503          	lbu	a0,-1(s1)
    80005232:	d9dff0ef          	jal	80004fce <consputc>
  while(--i >= 0)
    80005236:	14fd                	addi	s1,s1,-1
    80005238:	ff249be3          	bne	s1,s2,8000522e <printint+0x70>
    8000523c:	64e2                	ld	s1,24(sp)
    8000523e:	6942                	ld	s2,16(sp)
}
    80005240:	70a2                	ld	ra,40(sp)
    80005242:	7402                	ld	s0,32(sp)
    80005244:	6145                	addi	sp,sp,48
    80005246:	8082                	ret
    x = -xx;
    80005248:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000524c:	4885                	li	a7,1
    x = -xx;
    8000524e:	b741                	j	800051ce <printint+0x10>

0000000080005250 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005250:	7155                	addi	sp,sp,-208
    80005252:	e506                	sd	ra,136(sp)
    80005254:	e122                	sd	s0,128(sp)
    80005256:	f0d2                	sd	s4,96(sp)
    80005258:	0900                	addi	s0,sp,144
    8000525a:	8a2a                	mv	s4,a0
    8000525c:	e40c                	sd	a1,8(s0)
    8000525e:	e810                	sd	a2,16(s0)
    80005260:	ec14                	sd	a3,24(s0)
    80005262:	f018                	sd	a4,32(s0)
    80005264:	f41c                	sd	a5,40(s0)
    80005266:	03043823          	sd	a6,48(s0)
    8000526a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000526e:	0001e797          	auipc	a5,0x1e
    80005272:	4e27a783          	lw	a5,1250(a5) # 80023750 <pr+0x18>
    80005276:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000527a:	e3a1                	bnez	a5,800052ba <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000527c:	00840793          	addi	a5,s0,8
    80005280:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005284:	00054503          	lbu	a0,0(a0)
    80005288:	26050763          	beqz	a0,800054f6 <printf+0x2a6>
    8000528c:	fca6                	sd	s1,120(sp)
    8000528e:	f8ca                	sd	s2,112(sp)
    80005290:	f4ce                	sd	s3,104(sp)
    80005292:	ecd6                	sd	s5,88(sp)
    80005294:	e8da                	sd	s6,80(sp)
    80005296:	e0e2                	sd	s8,64(sp)
    80005298:	fc66                	sd	s9,56(sp)
    8000529a:	f86a                	sd	s10,48(sp)
    8000529c:	f46e                	sd	s11,40(sp)
    8000529e:	4981                	li	s3,0
    if(cx != '%'){
    800052a0:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800052a4:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800052a8:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800052ac:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800052b0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800052b4:	07000d93          	li	s11,112
    800052b8:	a815                	j	800052ec <printf+0x9c>
    acquire(&pr.lock);
    800052ba:	0001e517          	auipc	a0,0x1e
    800052be:	47e50513          	addi	a0,a0,1150 # 80023738 <pr>
    800052c2:	58e000ef          	jal	80005850 <acquire>
  va_start(ap, fmt);
    800052c6:	00840793          	addi	a5,s0,8
    800052ca:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052ce:	000a4503          	lbu	a0,0(s4)
    800052d2:	fd4d                	bnez	a0,8000528c <printf+0x3c>
    800052d4:	a481                	j	80005514 <printf+0x2c4>
      consputc(cx);
    800052d6:	cf9ff0ef          	jal	80004fce <consputc>
      continue;
    800052da:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052dc:	0014899b          	addiw	s3,s1,1
    800052e0:	013a07b3          	add	a5,s4,s3
    800052e4:	0007c503          	lbu	a0,0(a5)
    800052e8:	1e050b63          	beqz	a0,800054de <printf+0x28e>
    if(cx != '%'){
    800052ec:	ff5515e3          	bne	a0,s5,800052d6 <printf+0x86>
    i++;
    800052f0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800052f4:	009a07b3          	add	a5,s4,s1
    800052f8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800052fc:	1e090163          	beqz	s2,800054de <printf+0x28e>
    80005300:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005304:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005306:	c789                	beqz	a5,80005310 <printf+0xc0>
    80005308:	009a0733          	add	a4,s4,s1
    8000530c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005310:	03690763          	beq	s2,s6,8000533e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005314:	05890163          	beq	s2,s8,80005356 <printf+0x106>
    } else if(c0 == 'u'){
    80005318:	0d990b63          	beq	s2,s9,800053ee <printf+0x19e>
    } else if(c0 == 'x'){
    8000531c:	13a90163          	beq	s2,s10,8000543e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005320:	13b90b63          	beq	s2,s11,80005456 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005324:	07300793          	li	a5,115
    80005328:	16f90a63          	beq	s2,a5,8000549c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000532c:	1b590463          	beq	s2,s5,800054d4 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005330:	8556                	mv	a0,s5
    80005332:	c9dff0ef          	jal	80004fce <consputc>
      consputc(c0);
    80005336:	854a                	mv	a0,s2
    80005338:	c97ff0ef          	jal	80004fce <consputc>
    8000533c:	b745                	j	800052dc <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000533e:	f8843783          	ld	a5,-120(s0)
    80005342:	00878713          	addi	a4,a5,8
    80005346:	f8e43423          	sd	a4,-120(s0)
    8000534a:	4605                	li	a2,1
    8000534c:	45a9                	li	a1,10
    8000534e:	4388                	lw	a0,0(a5)
    80005350:	e6fff0ef          	jal	800051be <printint>
    80005354:	b761                	j	800052dc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005356:	03678663          	beq	a5,s6,80005382 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000535a:	05878263          	beq	a5,s8,8000539e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000535e:	0b978463          	beq	a5,s9,80005406 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005362:	fda797e3          	bne	a5,s10,80005330 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005366:	f8843783          	ld	a5,-120(s0)
    8000536a:	00878713          	addi	a4,a5,8
    8000536e:	f8e43423          	sd	a4,-120(s0)
    80005372:	4601                	li	a2,0
    80005374:	45c1                	li	a1,16
    80005376:	6388                	ld	a0,0(a5)
    80005378:	e47ff0ef          	jal	800051be <printint>
      i += 1;
    8000537c:	0029849b          	addiw	s1,s3,2
    80005380:	bfb1                	j	800052dc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005382:	f8843783          	ld	a5,-120(s0)
    80005386:	00878713          	addi	a4,a5,8
    8000538a:	f8e43423          	sd	a4,-120(s0)
    8000538e:	4605                	li	a2,1
    80005390:	45a9                	li	a1,10
    80005392:	6388                	ld	a0,0(a5)
    80005394:	e2bff0ef          	jal	800051be <printint>
      i += 1;
    80005398:	0029849b          	addiw	s1,s3,2
    8000539c:	b781                	j	800052dc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000539e:	06400793          	li	a5,100
    800053a2:	02f68863          	beq	a3,a5,800053d2 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800053a6:	07500793          	li	a5,117
    800053aa:	06f68c63          	beq	a3,a5,80005422 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800053ae:	07800793          	li	a5,120
    800053b2:	f6f69fe3          	bne	a3,a5,80005330 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800053b6:	f8843783          	ld	a5,-120(s0)
    800053ba:	00878713          	addi	a4,a5,8
    800053be:	f8e43423          	sd	a4,-120(s0)
    800053c2:	4601                	li	a2,0
    800053c4:	45c1                	li	a1,16
    800053c6:	6388                	ld	a0,0(a5)
    800053c8:	df7ff0ef          	jal	800051be <printint>
      i += 2;
    800053cc:	0039849b          	addiw	s1,s3,3
    800053d0:	b731                	j	800052dc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800053d2:	f8843783          	ld	a5,-120(s0)
    800053d6:	00878713          	addi	a4,a5,8
    800053da:	f8e43423          	sd	a4,-120(s0)
    800053de:	4605                	li	a2,1
    800053e0:	45a9                	li	a1,10
    800053e2:	6388                	ld	a0,0(a5)
    800053e4:	ddbff0ef          	jal	800051be <printint>
      i += 2;
    800053e8:	0039849b          	addiw	s1,s3,3
    800053ec:	bdc5                	j	800052dc <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800053ee:	f8843783          	ld	a5,-120(s0)
    800053f2:	00878713          	addi	a4,a5,8
    800053f6:	f8e43423          	sd	a4,-120(s0)
    800053fa:	4601                	li	a2,0
    800053fc:	45a9                	li	a1,10
    800053fe:	4388                	lw	a0,0(a5)
    80005400:	dbfff0ef          	jal	800051be <printint>
    80005404:	bde1                	j	800052dc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005406:	f8843783          	ld	a5,-120(s0)
    8000540a:	00878713          	addi	a4,a5,8
    8000540e:	f8e43423          	sd	a4,-120(s0)
    80005412:	4601                	li	a2,0
    80005414:	45a9                	li	a1,10
    80005416:	6388                	ld	a0,0(a5)
    80005418:	da7ff0ef          	jal	800051be <printint>
      i += 1;
    8000541c:	0029849b          	addiw	s1,s3,2
    80005420:	bd75                	j	800052dc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005422:	f8843783          	ld	a5,-120(s0)
    80005426:	00878713          	addi	a4,a5,8
    8000542a:	f8e43423          	sd	a4,-120(s0)
    8000542e:	4601                	li	a2,0
    80005430:	45a9                	li	a1,10
    80005432:	6388                	ld	a0,0(a5)
    80005434:	d8bff0ef          	jal	800051be <printint>
      i += 2;
    80005438:	0039849b          	addiw	s1,s3,3
    8000543c:	b545                	j	800052dc <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000543e:	f8843783          	ld	a5,-120(s0)
    80005442:	00878713          	addi	a4,a5,8
    80005446:	f8e43423          	sd	a4,-120(s0)
    8000544a:	4601                	li	a2,0
    8000544c:	45c1                	li	a1,16
    8000544e:	4388                	lw	a0,0(a5)
    80005450:	d6fff0ef          	jal	800051be <printint>
    80005454:	b561                	j	800052dc <printf+0x8c>
    80005456:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005458:	f8843783          	ld	a5,-120(s0)
    8000545c:	00878713          	addi	a4,a5,8
    80005460:	f8e43423          	sd	a4,-120(s0)
    80005464:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005468:	03000513          	li	a0,48
    8000546c:	b63ff0ef          	jal	80004fce <consputc>
  consputc('x');
    80005470:	07800513          	li	a0,120
    80005474:	b5bff0ef          	jal	80004fce <consputc>
    80005478:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000547a:	00002b97          	auipc	s7,0x2
    8000547e:	57eb8b93          	addi	s7,s7,1406 # 800079f8 <digits>
    80005482:	03c9d793          	srli	a5,s3,0x3c
    80005486:	97de                	add	a5,a5,s7
    80005488:	0007c503          	lbu	a0,0(a5)
    8000548c:	b43ff0ef          	jal	80004fce <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005490:	0992                	slli	s3,s3,0x4
    80005492:	397d                	addiw	s2,s2,-1
    80005494:	fe0917e3          	bnez	s2,80005482 <printf+0x232>
    80005498:	6ba6                	ld	s7,72(sp)
    8000549a:	b589                	j	800052dc <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000549c:	f8843783          	ld	a5,-120(s0)
    800054a0:	00878713          	addi	a4,a5,8
    800054a4:	f8e43423          	sd	a4,-120(s0)
    800054a8:	0007b903          	ld	s2,0(a5)
    800054ac:	00090d63          	beqz	s2,800054c6 <printf+0x276>
      for(; *s; s++)
    800054b0:	00094503          	lbu	a0,0(s2)
    800054b4:	e20504e3          	beqz	a0,800052dc <printf+0x8c>
        consputc(*s);
    800054b8:	b17ff0ef          	jal	80004fce <consputc>
      for(; *s; s++)
    800054bc:	0905                	addi	s2,s2,1
    800054be:	00094503          	lbu	a0,0(s2)
    800054c2:	f97d                	bnez	a0,800054b8 <printf+0x268>
    800054c4:	bd21                	j	800052dc <printf+0x8c>
        s = "(null)";
    800054c6:	00002917          	auipc	s2,0x2
    800054ca:	31290913          	addi	s2,s2,786 # 800077d8 <etext+0x7d8>
      for(; *s; s++)
    800054ce:	02800513          	li	a0,40
    800054d2:	b7dd                	j	800054b8 <printf+0x268>
      consputc('%');
    800054d4:	02500513          	li	a0,37
    800054d8:	af7ff0ef          	jal	80004fce <consputc>
    800054dc:	b501                	j	800052dc <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800054de:	f7843783          	ld	a5,-136(s0)
    800054e2:	e385                	bnez	a5,80005502 <printf+0x2b2>
    800054e4:	74e6                	ld	s1,120(sp)
    800054e6:	7946                	ld	s2,112(sp)
    800054e8:	79a6                	ld	s3,104(sp)
    800054ea:	6ae6                	ld	s5,88(sp)
    800054ec:	6b46                	ld	s6,80(sp)
    800054ee:	6c06                	ld	s8,64(sp)
    800054f0:	7ce2                	ld	s9,56(sp)
    800054f2:	7d42                	ld	s10,48(sp)
    800054f4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800054f6:	4501                	li	a0,0
    800054f8:	60aa                	ld	ra,136(sp)
    800054fa:	640a                	ld	s0,128(sp)
    800054fc:	7a06                	ld	s4,96(sp)
    800054fe:	6169                	addi	sp,sp,208
    80005500:	8082                	ret
    80005502:	74e6                	ld	s1,120(sp)
    80005504:	7946                	ld	s2,112(sp)
    80005506:	79a6                	ld	s3,104(sp)
    80005508:	6ae6                	ld	s5,88(sp)
    8000550a:	6b46                	ld	s6,80(sp)
    8000550c:	6c06                	ld	s8,64(sp)
    8000550e:	7ce2                	ld	s9,56(sp)
    80005510:	7d42                	ld	s10,48(sp)
    80005512:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005514:	0001e517          	auipc	a0,0x1e
    80005518:	22450513          	addi	a0,a0,548 # 80023738 <pr>
    8000551c:	3cc000ef          	jal	800058e8 <release>
    80005520:	bfd9                	j	800054f6 <printf+0x2a6>

0000000080005522 <panic>:

void
panic(char *s)
{
    80005522:	1101                	addi	sp,sp,-32
    80005524:	ec06                	sd	ra,24(sp)
    80005526:	e822                	sd	s0,16(sp)
    80005528:	e426                	sd	s1,8(sp)
    8000552a:	1000                	addi	s0,sp,32
    8000552c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000552e:	0001e797          	auipc	a5,0x1e
    80005532:	2207a123          	sw	zero,546(a5) # 80023750 <pr+0x18>
  printf("panic: ");
    80005536:	00002517          	auipc	a0,0x2
    8000553a:	2aa50513          	addi	a0,a0,682 # 800077e0 <etext+0x7e0>
    8000553e:	d13ff0ef          	jal	80005250 <printf>
  printf("%s\n", s);
    80005542:	85a6                	mv	a1,s1
    80005544:	00002517          	auipc	a0,0x2
    80005548:	2a450513          	addi	a0,a0,676 # 800077e8 <etext+0x7e8>
    8000554c:	d05ff0ef          	jal	80005250 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005550:	4785                	li	a5,1
    80005552:	00005717          	auipc	a4,0x5
    80005556:	eef72d23          	sw	a5,-262(a4) # 8000a44c <panicked>
  for(;;)
    8000555a:	a001                	j	8000555a <panic+0x38>

000000008000555c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000555c:	1101                	addi	sp,sp,-32
    8000555e:	ec06                	sd	ra,24(sp)
    80005560:	e822                	sd	s0,16(sp)
    80005562:	e426                	sd	s1,8(sp)
    80005564:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005566:	0001e497          	auipc	s1,0x1e
    8000556a:	1d248493          	addi	s1,s1,466 # 80023738 <pr>
    8000556e:	00002597          	auipc	a1,0x2
    80005572:	28258593          	addi	a1,a1,642 # 800077f0 <etext+0x7f0>
    80005576:	8526                	mv	a0,s1
    80005578:	258000ef          	jal	800057d0 <initlock>
  pr.locking = 1;
    8000557c:	4785                	li	a5,1
    8000557e:	cc9c                	sw	a5,24(s1)
}
    80005580:	60e2                	ld	ra,24(sp)
    80005582:	6442                	ld	s0,16(sp)
    80005584:	64a2                	ld	s1,8(sp)
    80005586:	6105                	addi	sp,sp,32
    80005588:	8082                	ret

000000008000558a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000558a:	1141                	addi	sp,sp,-16
    8000558c:	e406                	sd	ra,8(sp)
    8000558e:	e022                	sd	s0,0(sp)
    80005590:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005592:	100007b7          	lui	a5,0x10000
    80005596:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000559a:	10000737          	lui	a4,0x10000
    8000559e:	f8000693          	li	a3,-128
    800055a2:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800055a6:	468d                	li	a3,3
    800055a8:	10000637          	lui	a2,0x10000
    800055ac:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800055b0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800055b4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800055b8:	10000737          	lui	a4,0x10000
    800055bc:	461d                	li	a2,7
    800055be:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800055c2:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800055c6:	00002597          	auipc	a1,0x2
    800055ca:	23258593          	addi	a1,a1,562 # 800077f8 <etext+0x7f8>
    800055ce:	0001e517          	auipc	a0,0x1e
    800055d2:	18a50513          	addi	a0,a0,394 # 80023758 <uart_tx_lock>
    800055d6:	1fa000ef          	jal	800057d0 <initlock>
}
    800055da:	60a2                	ld	ra,8(sp)
    800055dc:	6402                	ld	s0,0(sp)
    800055de:	0141                	addi	sp,sp,16
    800055e0:	8082                	ret

00000000800055e2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800055e2:	1101                	addi	sp,sp,-32
    800055e4:	ec06                	sd	ra,24(sp)
    800055e6:	e822                	sd	s0,16(sp)
    800055e8:	e426                	sd	s1,8(sp)
    800055ea:	1000                	addi	s0,sp,32
    800055ec:	84aa                	mv	s1,a0
  push_off();
    800055ee:	222000ef          	jal	80005810 <push_off>

  if(panicked){
    800055f2:	00005797          	auipc	a5,0x5
    800055f6:	e5a7a783          	lw	a5,-422(a5) # 8000a44c <panicked>
    800055fa:	e795                	bnez	a5,80005626 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800055fc:	10000737          	lui	a4,0x10000
    80005600:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005602:	00074783          	lbu	a5,0(a4)
    80005606:	0207f793          	andi	a5,a5,32
    8000560a:	dfe5                	beqz	a5,80005602 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000560c:	0ff4f513          	zext.b	a0,s1
    80005610:	100007b7          	lui	a5,0x10000
    80005614:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005618:	27c000ef          	jal	80005894 <pop_off>
}
    8000561c:	60e2                	ld	ra,24(sp)
    8000561e:	6442                	ld	s0,16(sp)
    80005620:	64a2                	ld	s1,8(sp)
    80005622:	6105                	addi	sp,sp,32
    80005624:	8082                	ret
    for(;;)
    80005626:	a001                	j	80005626 <uartputc_sync+0x44>

0000000080005628 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005628:	00005797          	auipc	a5,0x5
    8000562c:	e287b783          	ld	a5,-472(a5) # 8000a450 <uart_tx_r>
    80005630:	00005717          	auipc	a4,0x5
    80005634:	e2873703          	ld	a4,-472(a4) # 8000a458 <uart_tx_w>
    80005638:	08f70263          	beq	a4,a5,800056bc <uartstart+0x94>
{
    8000563c:	7139                	addi	sp,sp,-64
    8000563e:	fc06                	sd	ra,56(sp)
    80005640:	f822                	sd	s0,48(sp)
    80005642:	f426                	sd	s1,40(sp)
    80005644:	f04a                	sd	s2,32(sp)
    80005646:	ec4e                	sd	s3,24(sp)
    80005648:	e852                	sd	s4,16(sp)
    8000564a:	e456                	sd	s5,8(sp)
    8000564c:	e05a                	sd	s6,0(sp)
    8000564e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005650:	10000937          	lui	s2,0x10000
    80005654:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005656:	0001ea97          	auipc	s5,0x1e
    8000565a:	102a8a93          	addi	s5,s5,258 # 80023758 <uart_tx_lock>
    uart_tx_r += 1;
    8000565e:	00005497          	auipc	s1,0x5
    80005662:	df248493          	addi	s1,s1,-526 # 8000a450 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005666:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000566a:	00005997          	auipc	s3,0x5
    8000566e:	dee98993          	addi	s3,s3,-530 # 8000a458 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005672:	00094703          	lbu	a4,0(s2)
    80005676:	02077713          	andi	a4,a4,32
    8000567a:	c71d                	beqz	a4,800056a8 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000567c:	01f7f713          	andi	a4,a5,31
    80005680:	9756                	add	a4,a4,s5
    80005682:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005686:	0785                	addi	a5,a5,1
    80005688:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000568a:	8526                	mv	a0,s1
    8000568c:	d3ffb0ef          	jal	800013ca <wakeup>
    WriteReg(THR, c);
    80005690:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005694:	609c                	ld	a5,0(s1)
    80005696:	0009b703          	ld	a4,0(s3)
    8000569a:	fcf71ce3          	bne	a4,a5,80005672 <uartstart+0x4a>
      ReadReg(ISR);
    8000569e:	100007b7          	lui	a5,0x10000
    800056a2:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800056a4:	0007c783          	lbu	a5,0(a5)
  }
}
    800056a8:	70e2                	ld	ra,56(sp)
    800056aa:	7442                	ld	s0,48(sp)
    800056ac:	74a2                	ld	s1,40(sp)
    800056ae:	7902                	ld	s2,32(sp)
    800056b0:	69e2                	ld	s3,24(sp)
    800056b2:	6a42                	ld	s4,16(sp)
    800056b4:	6aa2                	ld	s5,8(sp)
    800056b6:	6b02                	ld	s6,0(sp)
    800056b8:	6121                	addi	sp,sp,64
    800056ba:	8082                	ret
      ReadReg(ISR);
    800056bc:	100007b7          	lui	a5,0x10000
    800056c0:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800056c2:	0007c783          	lbu	a5,0(a5)
      return;
    800056c6:	8082                	ret

00000000800056c8 <uartputc>:
{
    800056c8:	7179                	addi	sp,sp,-48
    800056ca:	f406                	sd	ra,40(sp)
    800056cc:	f022                	sd	s0,32(sp)
    800056ce:	ec26                	sd	s1,24(sp)
    800056d0:	e84a                	sd	s2,16(sp)
    800056d2:	e44e                	sd	s3,8(sp)
    800056d4:	e052                	sd	s4,0(sp)
    800056d6:	1800                	addi	s0,sp,48
    800056d8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800056da:	0001e517          	auipc	a0,0x1e
    800056de:	07e50513          	addi	a0,a0,126 # 80023758 <uart_tx_lock>
    800056e2:	16e000ef          	jal	80005850 <acquire>
  if(panicked){
    800056e6:	00005797          	auipc	a5,0x5
    800056ea:	d667a783          	lw	a5,-666(a5) # 8000a44c <panicked>
    800056ee:	efbd                	bnez	a5,8000576c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056f0:	00005717          	auipc	a4,0x5
    800056f4:	d6873703          	ld	a4,-664(a4) # 8000a458 <uart_tx_w>
    800056f8:	00005797          	auipc	a5,0x5
    800056fc:	d587b783          	ld	a5,-680(a5) # 8000a450 <uart_tx_r>
    80005700:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005704:	0001e997          	auipc	s3,0x1e
    80005708:	05498993          	addi	s3,s3,84 # 80023758 <uart_tx_lock>
    8000570c:	00005497          	auipc	s1,0x5
    80005710:	d4448493          	addi	s1,s1,-700 # 8000a450 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005714:	00005917          	auipc	s2,0x5
    80005718:	d4490913          	addi	s2,s2,-700 # 8000a458 <uart_tx_w>
    8000571c:	00e79d63          	bne	a5,a4,80005736 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005720:	85ce                	mv	a1,s3
    80005722:	8526                	mv	a0,s1
    80005724:	c5bfb0ef          	jal	8000137e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005728:	00093703          	ld	a4,0(s2)
    8000572c:	609c                	ld	a5,0(s1)
    8000572e:	02078793          	addi	a5,a5,32
    80005732:	fee787e3          	beq	a5,a4,80005720 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005736:	0001e497          	auipc	s1,0x1e
    8000573a:	02248493          	addi	s1,s1,34 # 80023758 <uart_tx_lock>
    8000573e:	01f77793          	andi	a5,a4,31
    80005742:	97a6                	add	a5,a5,s1
    80005744:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005748:	0705                	addi	a4,a4,1
    8000574a:	00005797          	auipc	a5,0x5
    8000574e:	d0e7b723          	sd	a4,-754(a5) # 8000a458 <uart_tx_w>
  uartstart();
    80005752:	ed7ff0ef          	jal	80005628 <uartstart>
  release(&uart_tx_lock);
    80005756:	8526                	mv	a0,s1
    80005758:	190000ef          	jal	800058e8 <release>
}
    8000575c:	70a2                	ld	ra,40(sp)
    8000575e:	7402                	ld	s0,32(sp)
    80005760:	64e2                	ld	s1,24(sp)
    80005762:	6942                	ld	s2,16(sp)
    80005764:	69a2                	ld	s3,8(sp)
    80005766:	6a02                	ld	s4,0(sp)
    80005768:	6145                	addi	sp,sp,48
    8000576a:	8082                	ret
    for(;;)
    8000576c:	a001                	j	8000576c <uartputc+0xa4>

000000008000576e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000576e:	1141                	addi	sp,sp,-16
    80005770:	e422                	sd	s0,8(sp)
    80005772:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005774:	100007b7          	lui	a5,0x10000
    80005778:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000577a:	0007c783          	lbu	a5,0(a5)
    8000577e:	8b85                	andi	a5,a5,1
    80005780:	cb81                	beqz	a5,80005790 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005782:	100007b7          	lui	a5,0x10000
    80005786:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000578a:	6422                	ld	s0,8(sp)
    8000578c:	0141                	addi	sp,sp,16
    8000578e:	8082                	ret
    return -1;
    80005790:	557d                	li	a0,-1
    80005792:	bfe5                	j	8000578a <uartgetc+0x1c>

0000000080005794 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005794:	1101                	addi	sp,sp,-32
    80005796:	ec06                	sd	ra,24(sp)
    80005798:	e822                	sd	s0,16(sp)
    8000579a:	e426                	sd	s1,8(sp)
    8000579c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000579e:	54fd                	li	s1,-1
    800057a0:	a019                	j	800057a6 <uartintr+0x12>
      break;
    consoleintr(c);
    800057a2:	85fff0ef          	jal	80005000 <consoleintr>
    int c = uartgetc();
    800057a6:	fc9ff0ef          	jal	8000576e <uartgetc>
    if(c == -1)
    800057aa:	fe951ce3          	bne	a0,s1,800057a2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800057ae:	0001e497          	auipc	s1,0x1e
    800057b2:	faa48493          	addi	s1,s1,-86 # 80023758 <uart_tx_lock>
    800057b6:	8526                	mv	a0,s1
    800057b8:	098000ef          	jal	80005850 <acquire>
  uartstart();
    800057bc:	e6dff0ef          	jal	80005628 <uartstart>
  release(&uart_tx_lock);
    800057c0:	8526                	mv	a0,s1
    800057c2:	126000ef          	jal	800058e8 <release>
}
    800057c6:	60e2                	ld	ra,24(sp)
    800057c8:	6442                	ld	s0,16(sp)
    800057ca:	64a2                	ld	s1,8(sp)
    800057cc:	6105                	addi	sp,sp,32
    800057ce:	8082                	ret

00000000800057d0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800057d0:	1141                	addi	sp,sp,-16
    800057d2:	e422                	sd	s0,8(sp)
    800057d4:	0800                	addi	s0,sp,16
  lk->name = name;
    800057d6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800057d8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800057dc:	00053823          	sd	zero,16(a0)
}
    800057e0:	6422                	ld	s0,8(sp)
    800057e2:	0141                	addi	sp,sp,16
    800057e4:	8082                	ret

00000000800057e6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800057e6:	411c                	lw	a5,0(a0)
    800057e8:	e399                	bnez	a5,800057ee <holding+0x8>
    800057ea:	4501                	li	a0,0
  return r;
}
    800057ec:	8082                	ret
{
    800057ee:	1101                	addi	sp,sp,-32
    800057f0:	ec06                	sd	ra,24(sp)
    800057f2:	e822                	sd	s0,16(sp)
    800057f4:	e426                	sd	s1,8(sp)
    800057f6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800057f8:	6904                	ld	s1,16(a0)
    800057fa:	d92fb0ef          	jal	80000d8c <mycpu>
    800057fe:	40a48533          	sub	a0,s1,a0
    80005802:	00153513          	seqz	a0,a0
}
    80005806:	60e2                	ld	ra,24(sp)
    80005808:	6442                	ld	s0,16(sp)
    8000580a:	64a2                	ld	s1,8(sp)
    8000580c:	6105                	addi	sp,sp,32
    8000580e:	8082                	ret

0000000080005810 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005810:	1101                	addi	sp,sp,-32
    80005812:	ec06                	sd	ra,24(sp)
    80005814:	e822                	sd	s0,16(sp)
    80005816:	e426                	sd	s1,8(sp)
    80005818:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000581a:	100024f3          	csrr	s1,sstatus
    8000581e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005822:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005824:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005828:	d64fb0ef          	jal	80000d8c <mycpu>
    8000582c:	5d3c                	lw	a5,120(a0)
    8000582e:	cb99                	beqz	a5,80005844 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005830:	d5cfb0ef          	jal	80000d8c <mycpu>
    80005834:	5d3c                	lw	a5,120(a0)
    80005836:	2785                	addiw	a5,a5,1
    80005838:	dd3c                	sw	a5,120(a0)
}
    8000583a:	60e2                	ld	ra,24(sp)
    8000583c:	6442                	ld	s0,16(sp)
    8000583e:	64a2                	ld	s1,8(sp)
    80005840:	6105                	addi	sp,sp,32
    80005842:	8082                	ret
    mycpu()->intena = old;
    80005844:	d48fb0ef          	jal	80000d8c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005848:	8085                	srli	s1,s1,0x1
    8000584a:	8885                	andi	s1,s1,1
    8000584c:	dd64                	sw	s1,124(a0)
    8000584e:	b7cd                	j	80005830 <push_off+0x20>

0000000080005850 <acquire>:
{
    80005850:	1101                	addi	sp,sp,-32
    80005852:	ec06                	sd	ra,24(sp)
    80005854:	e822                	sd	s0,16(sp)
    80005856:	e426                	sd	s1,8(sp)
    80005858:	1000                	addi	s0,sp,32
    8000585a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000585c:	fb5ff0ef          	jal	80005810 <push_off>
  if(holding(lk))
    80005860:	8526                	mv	a0,s1
    80005862:	f85ff0ef          	jal	800057e6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005866:	4705                	li	a4,1
  if(holding(lk))
    80005868:	e105                	bnez	a0,80005888 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000586a:	87ba                	mv	a5,a4
    8000586c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005870:	2781                	sext.w	a5,a5
    80005872:	ffe5                	bnez	a5,8000586a <acquire+0x1a>
  __sync_synchronize();
    80005874:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005878:	d14fb0ef          	jal	80000d8c <mycpu>
    8000587c:	e888                	sd	a0,16(s1)
}
    8000587e:	60e2                	ld	ra,24(sp)
    80005880:	6442                	ld	s0,16(sp)
    80005882:	64a2                	ld	s1,8(sp)
    80005884:	6105                	addi	sp,sp,32
    80005886:	8082                	ret
    panic("acquire");
    80005888:	00002517          	auipc	a0,0x2
    8000588c:	f7850513          	addi	a0,a0,-136 # 80007800 <etext+0x800>
    80005890:	c93ff0ef          	jal	80005522 <panic>

0000000080005894 <pop_off>:

void
pop_off(void)
{
    80005894:	1141                	addi	sp,sp,-16
    80005896:	e406                	sd	ra,8(sp)
    80005898:	e022                	sd	s0,0(sp)
    8000589a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000589c:	cf0fb0ef          	jal	80000d8c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058a0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800058a4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800058a6:	e78d                	bnez	a5,800058d0 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800058a8:	5d3c                	lw	a5,120(a0)
    800058aa:	02f05963          	blez	a5,800058dc <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    800058ae:	37fd                	addiw	a5,a5,-1
    800058b0:	0007871b          	sext.w	a4,a5
    800058b4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800058b6:	eb09                	bnez	a4,800058c8 <pop_off+0x34>
    800058b8:	5d7c                	lw	a5,124(a0)
    800058ba:	c799                	beqz	a5,800058c8 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058bc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800058c0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800058c4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800058c8:	60a2                	ld	ra,8(sp)
    800058ca:	6402                	ld	s0,0(sp)
    800058cc:	0141                	addi	sp,sp,16
    800058ce:	8082                	ret
    panic("pop_off - interruptible");
    800058d0:	00002517          	auipc	a0,0x2
    800058d4:	f3850513          	addi	a0,a0,-200 # 80007808 <etext+0x808>
    800058d8:	c4bff0ef          	jal	80005522 <panic>
    panic("pop_off");
    800058dc:	00002517          	auipc	a0,0x2
    800058e0:	f4450513          	addi	a0,a0,-188 # 80007820 <etext+0x820>
    800058e4:	c3fff0ef          	jal	80005522 <panic>

00000000800058e8 <release>:
{
    800058e8:	1101                	addi	sp,sp,-32
    800058ea:	ec06                	sd	ra,24(sp)
    800058ec:	e822                	sd	s0,16(sp)
    800058ee:	e426                	sd	s1,8(sp)
    800058f0:	1000                	addi	s0,sp,32
    800058f2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800058f4:	ef3ff0ef          	jal	800057e6 <holding>
    800058f8:	c105                	beqz	a0,80005918 <release+0x30>
  lk->cpu = 0;
    800058fa:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800058fe:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005902:	0310000f          	fence	rw,w
    80005906:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000590a:	f8bff0ef          	jal	80005894 <pop_off>
}
    8000590e:	60e2                	ld	ra,24(sp)
    80005910:	6442                	ld	s0,16(sp)
    80005912:	64a2                	ld	s1,8(sp)
    80005914:	6105                	addi	sp,sp,32
    80005916:	8082                	ret
    panic("release");
    80005918:	00002517          	auipc	a0,0x2
    8000591c:	f1050513          	addi	a0,a0,-240 # 80007828 <etext+0x828>
    80005920:	c03ff0ef          	jal	80005522 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
