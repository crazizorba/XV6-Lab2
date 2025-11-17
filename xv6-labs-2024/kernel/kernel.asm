
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	26013103          	ld	sp,608(sp) # 8000a260 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	579040ef          	jal	80004d8e <start>

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
    80000034:	5b078793          	addi	a5,a5,1456 # 800235e0 <end>
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
    80000050:	26490913          	addi	s2,s2,612 # 8000a2b0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	79a050ef          	jal	800057f0 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	023050ef          	jal	80005888 <release>
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
    8000007e:	444050ef          	jal	800054c2 <panic>

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
    800000de:	1d650513          	addi	a0,a0,470 # 8000a2b0 <kmem>
    800000e2:	68e050ef          	jal	80005770 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	4f650513          	addi	a0,a0,1270 # 800235e0 <end>
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
    8000010c:	1a848493          	addi	s1,s1,424 # 8000a2b0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	6de050ef          	jal	800057f0 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	19450513          	addi	a0,a0,404 # 8000a2b0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	762050ef          	jal	80005888 <release>

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
    80000144:	17050513          	addi	a0,a0,368 # 8000a2b0 <kmem>
    80000148:	740050ef          	jal	80005888 <release>
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
    8000015c:	15848493          	addi	s1,s1,344 # 8000a2b0 <kmem>
    80000160:	8526                	mv	a0,s1
    80000162:	68e050ef          	jal	800057f0 <acquire>
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
    80000178:	13c50513          	addi	a0,a0,316 # 8000a2b0 <kmem>
    8000017c:	70c050ef          	jal	80005888 <release>
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
    8000033a:	f4a70713          	addi	a4,a4,-182 # 8000a280 <started>
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
    80000358:	699040ef          	jal	800051f0 <printf>
    kvminithart();    // turn on paging
    8000035c:	080000ef          	jal	800003dc <kvminithart>
    trapinithart();   // install kernel trap vector
    80000360:	584010ef          	jal	800018e4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000364:	444040ef          	jal	800047a8 <plicinithart>
  }

  scheduler();        
    80000368:	675000ef          	jal	800011dc <scheduler>
    consoleinit();
    8000036c:	5af040ef          	jal	8000511a <consoleinit>
    printfinit();
    80000370:	18c050ef          	jal	800054fc <printfinit>
    printf("\n");
    80000374:	00007517          	auipc	a0,0x7
    80000378:	ca450513          	addi	a0,a0,-860 # 80007018 <etext+0x18>
    8000037c:	675040ef          	jal	800051f0 <printf>
    printf("xv6 kernel is booting\n");
    80000380:	00007517          	auipc	a0,0x7
    80000384:	ca050513          	addi	a0,a0,-864 # 80007020 <etext+0x20>
    80000388:	669040ef          	jal	800051f0 <printf>
    printf("\n");
    8000038c:	00007517          	auipc	a0,0x7
    80000390:	c8c50513          	addi	a0,a0,-884 # 80007018 <etext+0x18>
    80000394:	65d040ef          	jal	800051f0 <printf>
    kinit();         // physical page allocator
    80000398:	d33ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000039c:	2ca000ef          	jal	80000666 <kvminit>
    kvminithart();   // turn on paging
    800003a0:	03c000ef          	jal	800003dc <kvminithart>
    procinit();      // process table
    800003a4:	123000ef          	jal	80000cc6 <procinit>
    trapinit();      // trap vectors
    800003a8:	518010ef          	jal	800018c0 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ac:	538010ef          	jal	800018e4 <trapinithart>
    plicinit();      // set up interrupt controller
    800003b0:	3de040ef          	jal	8000478e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003b4:	3f4040ef          	jal	800047a8 <plicinithart>
    binit();         // buffer cache
    800003b8:	39f010ef          	jal	80001f56 <binit>
    iinit();         // inode table
    800003bc:	190020ef          	jal	8000254c <iinit>
    fileinit();      // file table
    800003c0:	73d020ef          	jal	800032fc <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003c4:	4d4040ef          	jal	80004898 <virtio_disk_init>
    userinit();      // first user process
    800003c8:	449000ef          	jal	80001010 <userinit>
    __sync_synchronize();
    800003cc:	0330000f          	fence	rw,rw
    started = 1;
    800003d0:	4785                	li	a5,1
    800003d2:	0000a717          	auipc	a4,0xa
    800003d6:	eaf72723          	sw	a5,-338(a4) # 8000a280 <started>
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
    800003ea:	ea27b783          	ld	a5,-350(a5) # 8000a288 <kernel_pagetable>
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
    80000432:	090050ef          	jal	800054c2 <panic>
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
    80000458:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdba17>
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
    80000548:	77b040ef          	jal	800054c2 <panic>
    panic("mappages: size not aligned");
    8000054c:	00007517          	auipc	a0,0x7
    80000550:	b2c50513          	addi	a0,a0,-1236 # 80007078 <etext+0x78>
    80000554:	76f040ef          	jal	800054c2 <panic>
    panic("mappages: size");
    80000558:	00007517          	auipc	a0,0x7
    8000055c:	b4050513          	addi	a0,a0,-1216 # 80007098 <etext+0x98>
    80000560:	763040ef          	jal	800054c2 <panic>
      panic("mappages: remap");
    80000564:	00007517          	auipc	a0,0x7
    80000568:	b4450513          	addi	a0,a0,-1212 # 800070a8 <etext+0xa8>
    8000056c:	757040ef          	jal	800054c2 <panic>
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
    800005b0:	713040ef          	jal	800054c2 <panic>

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
    80000676:	c0a7bb23          	sd	a0,-1002(a5) # 8000a288 <kernel_pagetable>
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
    800006ca:	5f9040ef          	jal	800054c2 <panic>
      panic("uvmunmap: walk");
    800006ce:	00007517          	auipc	a0,0x7
    800006d2:	a0a50513          	addi	a0,a0,-1526 # 800070d8 <etext+0xd8>
    800006d6:	5ed040ef          	jal	800054c2 <panic>
      panic("uvmunmap: not mapped");
    800006da:	00007517          	auipc	a0,0x7
    800006de:	a0e50513          	addi	a0,a0,-1522 # 800070e8 <etext+0xe8>
    800006e2:	5e1040ef          	jal	800054c2 <panic>
      panic("uvmunmap: not a leaf");
    800006e6:	00007517          	auipc	a0,0x7
    800006ea:	a1a50513          	addi	a0,a0,-1510 # 80007100 <etext+0x100>
    800006ee:	5d5040ef          	jal	800054c2 <panic>
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
    800007be:	505040ef          	jal	800054c2 <panic>

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
    800008f2:	3d1040ef          	jal	800054c2 <panic>
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
    800009b0:	313040ef          	jal	800054c2 <panic>
      panic("uvmcopy: page not present");
    800009b4:	00006517          	auipc	a0,0x6
    800009b8:	7b450513          	addi	a0,a0,1972 # 80007168 <etext+0x168>
    800009bc:	307040ef          	jal	800054c2 <panic>
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
    80000a16:	2ad040ef          	jal	800054c2 <panic>

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
    80000c48:	abc48493          	addi	s1,s1,-1348 # 8000a700 <proc>
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
    80000c74:	490a8a93          	addi	s5,s5,1168 # 80010100 <tickslock>
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
    80000cc2:	001040ef          	jal	800054c2 <panic>

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
    80000ce6:	5ee50513          	addi	a0,a0,1518 # 8000a2d0 <pid_lock>
    80000cea:	287040ef          	jal	80005770 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cee:	00006597          	auipc	a1,0x6
    80000cf2:	4ba58593          	addi	a1,a1,1210 # 800071a8 <etext+0x1a8>
    80000cf6:	00009517          	auipc	a0,0x9
    80000cfa:	5f250513          	addi	a0,a0,1522 # 8000a2e8 <wait_lock>
    80000cfe:	273040ef          	jal	80005770 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d02:	0000a497          	auipc	s1,0xa
    80000d06:	9fe48493          	addi	s1,s1,-1538 # 8000a700 <proc>
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
    80000d3a:	3caa0a13          	addi	s4,s4,970 # 80010100 <tickslock>
      initlock(&p->lock, "proc");
    80000d3e:	85da                	mv	a1,s6
    80000d40:	8526                	mv	a0,s1
    80000d42:	22f040ef          	jal	80005770 <initlock>
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
    80000d9c:	56850513          	addi	a0,a0,1384 # 8000a300 <cpus>
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
    80000db2:	1ff040ef          	jal	800057b0 <push_off>
    80000db6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000db8:	2781                	sext.w	a5,a5
    80000dba:	079e                	slli	a5,a5,0x7
    80000dbc:	00009717          	auipc	a4,0x9
    80000dc0:	51470713          	addi	a4,a4,1300 # 8000a2d0 <pid_lock>
    80000dc4:	97ba                	add	a5,a5,a4
    80000dc6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000dc8:	26d040ef          	jal	80005834 <pop_off>
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
    80000de4:	2a5040ef          	jal	80005888 <release>

  if (first) {
    80000de8:	00009797          	auipc	a5,0x9
    80000dec:	4287a783          	lw	a5,1064(a5) # 8000a210 <first.1>
    80000df0:	e799                	bnez	a5,80000dfe <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000df2:	30b000ef          	jal	800018fc <usertrapret>
}
    80000df6:	60a2                	ld	ra,8(sp)
    80000df8:	6402                	ld	s0,0(sp)
    80000dfa:	0141                	addi	sp,sp,16
    80000dfc:	8082                	ret
    fsinit(ROOTDEV);
    80000dfe:	4505                	li	a0,1
    80000e00:	6e0010ef          	jal	800024e0 <fsinit>
    first = 0;
    80000e04:	00009797          	auipc	a5,0x9
    80000e08:	4007a623          	sw	zero,1036(a5) # 8000a210 <first.1>
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
    80000e22:	4b290913          	addi	s2,s2,1202 # 8000a2d0 <pid_lock>
    80000e26:	854a                	mv	a0,s2
    80000e28:	1c9040ef          	jal	800057f0 <acquire>
  pid = nextpid;
    80000e2c:	00009797          	auipc	a5,0x9
    80000e30:	3e878793          	addi	a5,a5,1000 # 8000a214 <nextpid>
    80000e34:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e36:	0014871b          	addiw	a4,s1,1
    80000e3a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e3c:	854a                	mv	a0,s2
    80000e3e:	24b040ef          	jal	80005888 <release>
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
    80000f76:	00009497          	auipc	s1,0x9
    80000f7a:	78a48493          	addi	s1,s1,1930 # 8000a700 <proc>
    80000f7e:	0000f917          	auipc	s2,0xf
    80000f82:	18290913          	addi	s2,s2,386 # 80010100 <tickslock>
    acquire(&p->lock);
    80000f86:	8526                	mv	a0,s1
    80000f88:	069040ef          	jal	800057f0 <acquire>
    if(p->state == UNUSED) {
    80000f8c:	4c9c                	lw	a5,24(s1)
    80000f8e:	cb91                	beqz	a5,80000fa2 <allocproc+0x38>
      release(&p->lock);
    80000f90:	8526                	mv	a0,s1
    80000f92:	0f7040ef          	jal	80005888 <release>
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
    80000ff8:	091040ef          	jal	80005888 <release>
    return 0;
    80000ffc:	84ca                	mv	s1,s2
    80000ffe:	b7d5                	j	80000fe2 <allocproc+0x78>
    freeproc(p);
    80001000:	8526                	mv	a0,s1
    80001002:	f19ff0ef          	jal	80000f1a <freeproc>
    release(&p->lock);
    80001006:	8526                	mv	a0,s1
    80001008:	081040ef          	jal	80005888 <release>
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
    80001024:	26a7b823          	sd	a0,624(a5) # 8000a290 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001028:	03400613          	li	a2,52
    8000102c:	00009597          	auipc	a1,0x9
    80001030:	1f458593          	addi	a1,a1,500 # 8000a220 <initcode>
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
    80001062:	58d010ef          	jal	80002dee <namei>
    80001066:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000106a:	478d                	li	a5,3
    8000106c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	019040ef          	jal	80005888 <release>
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
    800010e4:	0e050a63          	beqz	a0,800011d8 <fork+0x10a>
    800010e8:	e852                	sd	s4,16(sp)
    800010ea:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010ec:	048ab603          	ld	a2,72(s5)
    800010f0:	692c                	ld	a1,80(a0)
    800010f2:	050ab503          	ld	a0,80(s5)
    800010f6:	849ff0ef          	jal	8000093e <uvmcopy>
    800010fa:	04054a63          	bltz	a0,8000114e <fork+0x80>
    800010fe:	f426                	sd	s1,40(sp)
    80001100:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001102:	048ab783          	ld	a5,72(s5)
    80001106:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000110a:	058ab683          	ld	a3,88(s5)
    8000110e:	87b6                	mv	a5,a3
    80001110:	058a3703          	ld	a4,88(s4)
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
    80001138:	058a3783          	ld	a5,88(s4)
    8000113c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001140:	0d0a8493          	addi	s1,s5,208
    80001144:	0d0a0913          	addi	s2,s4,208
    80001148:	150a8993          	addi	s3,s5,336
    8000114c:	a831                	j	80001168 <fork+0x9a>
    freeproc(np);
    8000114e:	8552                	mv	a0,s4
    80001150:	dcbff0ef          	jal	80000f1a <freeproc>
    release(&np->lock);
    80001154:	8552                	mv	a0,s4
    80001156:	732040ef          	jal	80005888 <release>
    return -1;
    8000115a:	597d                	li	s2,-1
    8000115c:	6a42                	ld	s4,16(sp)
    8000115e:	a0b5                	j	800011ca <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001160:	04a1                	addi	s1,s1,8
    80001162:	0921                	addi	s2,s2,8
    80001164:	01348963          	beq	s1,s3,80001176 <fork+0xa8>
    if(p->ofile[i])
    80001168:	6088                	ld	a0,0(s1)
    8000116a:	d97d                	beqz	a0,80001160 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000116c:	212020ef          	jal	8000337e <filedup>
    80001170:	00a93023          	sd	a0,0(s2)
    80001174:	b7f5                	j	80001160 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001176:	150ab503          	ld	a0,336(s5)
    8000117a:	564010ef          	jal	800026de <idup>
    8000117e:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001182:	4641                	li	a2,16
    80001184:	158a8593          	addi	a1,s5,344
    80001188:	158a0513          	addi	a0,s4,344
    8000118c:	942ff0ef          	jal	800002ce <safestrcpy>
  pid = np->pid;
    80001190:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001194:	8552                	mv	a0,s4
    80001196:	6f2040ef          	jal	80005888 <release>
  acquire(&wait_lock);
    8000119a:	00009497          	auipc	s1,0x9
    8000119e:	14e48493          	addi	s1,s1,334 # 8000a2e8 <wait_lock>
    800011a2:	8526                	mv	a0,s1
    800011a4:	64c040ef          	jal	800057f0 <acquire>
  np->parent = p;
    800011a8:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800011ac:	8526                	mv	a0,s1
    800011ae:	6da040ef          	jal	80005888 <release>
  acquire(&np->lock);
    800011b2:	8552                	mv	a0,s4
    800011b4:	63c040ef          	jal	800057f0 <acquire>
  np->state = RUNNABLE;
    800011b8:	478d                	li	a5,3
    800011ba:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800011be:	8552                	mv	a0,s4
    800011c0:	6c8040ef          	jal	80005888 <release>
  return pid;
    800011c4:	74a2                	ld	s1,40(sp)
    800011c6:	69e2                	ld	s3,24(sp)
    800011c8:	6a42                	ld	s4,16(sp)
}
    800011ca:	854a                	mv	a0,s2
    800011cc:	70e2                	ld	ra,56(sp)
    800011ce:	7442                	ld	s0,48(sp)
    800011d0:	7902                	ld	s2,32(sp)
    800011d2:	6aa2                	ld	s5,8(sp)
    800011d4:	6121                	addi	sp,sp,64
    800011d6:	8082                	ret
    return -1;
    800011d8:	597d                	li	s2,-1
    800011da:	bfc5                	j	800011ca <fork+0xfc>

00000000800011dc <scheduler>:
{
    800011dc:	715d                	addi	sp,sp,-80
    800011de:	e486                	sd	ra,72(sp)
    800011e0:	e0a2                	sd	s0,64(sp)
    800011e2:	fc26                	sd	s1,56(sp)
    800011e4:	f84a                	sd	s2,48(sp)
    800011e6:	f44e                	sd	s3,40(sp)
    800011e8:	f052                	sd	s4,32(sp)
    800011ea:	ec56                	sd	s5,24(sp)
    800011ec:	e85a                	sd	s6,16(sp)
    800011ee:	e45e                	sd	s7,8(sp)
    800011f0:	e062                	sd	s8,0(sp)
    800011f2:	0880                	addi	s0,sp,80
    800011f4:	8792                	mv	a5,tp
  int id = r_tp();
    800011f6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011f8:	00779b13          	slli	s6,a5,0x7
    800011fc:	00009717          	auipc	a4,0x9
    80001200:	0d470713          	addi	a4,a4,212 # 8000a2d0 <pid_lock>
    80001204:	975a                	add	a4,a4,s6
    80001206:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000120a:	00009717          	auipc	a4,0x9
    8000120e:	0fe70713          	addi	a4,a4,254 # 8000a308 <cpus+0x8>
    80001212:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001214:	4c11                	li	s8,4
        c->proc = p;
    80001216:	079e                	slli	a5,a5,0x7
    80001218:	00009a17          	auipc	s4,0x9
    8000121c:	0b8a0a13          	addi	s4,s4,184 # 8000a2d0 <pid_lock>
    80001220:	9a3e                	add	s4,s4,a5
        found = 1;
    80001222:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001224:	0000f997          	auipc	s3,0xf
    80001228:	edc98993          	addi	s3,s3,-292 # 80010100 <tickslock>
    8000122c:	a0a9                	j	80001276 <scheduler+0x9a>
      release(&p->lock);
    8000122e:	8526                	mv	a0,s1
    80001230:	658040ef          	jal	80005888 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001234:	16848493          	addi	s1,s1,360
    80001238:	03348563          	beq	s1,s3,80001262 <scheduler+0x86>
      acquire(&p->lock);
    8000123c:	8526                	mv	a0,s1
    8000123e:	5b2040ef          	jal	800057f0 <acquire>
      if(p->state == RUNNABLE) {
    80001242:	4c9c                	lw	a5,24(s1)
    80001244:	ff2795e3          	bne	a5,s2,8000122e <scheduler+0x52>
        p->state = RUNNING;
    80001248:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    8000124c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001250:	06048593          	addi	a1,s1,96
    80001254:	855a                	mv	a0,s6
    80001256:	600000ef          	jal	80001856 <swtch>
        c->proc = 0;
    8000125a:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000125e:	8ade                	mv	s5,s7
    80001260:	b7f9                	j	8000122e <scheduler+0x52>
    if(found == 0) {
    80001262:	000a9a63          	bnez	s5,80001276 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001266:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000126a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000126e:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001272:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001276:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000127a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000127e:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001282:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001284:	00009497          	auipc	s1,0x9
    80001288:	47c48493          	addi	s1,s1,1148 # 8000a700 <proc>
      if(p->state == RUNNABLE) {
    8000128c:	490d                	li	s2,3
    8000128e:	b77d                	j	8000123c <scheduler+0x60>

0000000080001290 <sched>:
{
    80001290:	7179                	addi	sp,sp,-48
    80001292:	f406                	sd	ra,40(sp)
    80001294:	f022                	sd	s0,32(sp)
    80001296:	ec26                	sd	s1,24(sp)
    80001298:	e84a                	sd	s2,16(sp)
    8000129a:	e44e                	sd	s3,8(sp)
    8000129c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000129e:	b0bff0ef          	jal	80000da8 <myproc>
    800012a2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012a4:	4e2040ef          	jal	80005786 <holding>
    800012a8:	c92d                	beqz	a0,8000131a <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012aa:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012ac:	2781                	sext.w	a5,a5
    800012ae:	079e                	slli	a5,a5,0x7
    800012b0:	00009717          	auipc	a4,0x9
    800012b4:	02070713          	addi	a4,a4,32 # 8000a2d0 <pid_lock>
    800012b8:	97ba                	add	a5,a5,a4
    800012ba:	0a87a703          	lw	a4,168(a5)
    800012be:	4785                	li	a5,1
    800012c0:	06f71363          	bne	a4,a5,80001326 <sched+0x96>
  if(p->state == RUNNING)
    800012c4:	4c98                	lw	a4,24(s1)
    800012c6:	4791                	li	a5,4
    800012c8:	06f70563          	beq	a4,a5,80001332 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012cc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012d0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012d2:	e7b5                	bnez	a5,8000133e <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012d4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012d6:	00009917          	auipc	s2,0x9
    800012da:	ffa90913          	addi	s2,s2,-6 # 8000a2d0 <pid_lock>
    800012de:	2781                	sext.w	a5,a5
    800012e0:	079e                	slli	a5,a5,0x7
    800012e2:	97ca                	add	a5,a5,s2
    800012e4:	0ac7a983          	lw	s3,172(a5)
    800012e8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012ea:	2781                	sext.w	a5,a5
    800012ec:	079e                	slli	a5,a5,0x7
    800012ee:	00009597          	auipc	a1,0x9
    800012f2:	01a58593          	addi	a1,a1,26 # 8000a308 <cpus+0x8>
    800012f6:	95be                	add	a1,a1,a5
    800012f8:	06048513          	addi	a0,s1,96
    800012fc:	55a000ef          	jal	80001856 <swtch>
    80001300:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001302:	2781                	sext.w	a5,a5
    80001304:	079e                	slli	a5,a5,0x7
    80001306:	993e                	add	s2,s2,a5
    80001308:	0b392623          	sw	s3,172(s2)
}
    8000130c:	70a2                	ld	ra,40(sp)
    8000130e:	7402                	ld	s0,32(sp)
    80001310:	64e2                	ld	s1,24(sp)
    80001312:	6942                	ld	s2,16(sp)
    80001314:	69a2                	ld	s3,8(sp)
    80001316:	6145                	addi	sp,sp,48
    80001318:	8082                	ret
    panic("sched p->lock");
    8000131a:	00006517          	auipc	a0,0x6
    8000131e:	ebe50513          	addi	a0,a0,-322 # 800071d8 <etext+0x1d8>
    80001322:	1a0040ef          	jal	800054c2 <panic>
    panic("sched locks");
    80001326:	00006517          	auipc	a0,0x6
    8000132a:	ec250513          	addi	a0,a0,-318 # 800071e8 <etext+0x1e8>
    8000132e:	194040ef          	jal	800054c2 <panic>
    panic("sched running");
    80001332:	00006517          	auipc	a0,0x6
    80001336:	ec650513          	addi	a0,a0,-314 # 800071f8 <etext+0x1f8>
    8000133a:	188040ef          	jal	800054c2 <panic>
    panic("sched interruptible");
    8000133e:	00006517          	auipc	a0,0x6
    80001342:	eca50513          	addi	a0,a0,-310 # 80007208 <etext+0x208>
    80001346:	17c040ef          	jal	800054c2 <panic>

000000008000134a <yield>:
{
    8000134a:	1101                	addi	sp,sp,-32
    8000134c:	ec06                	sd	ra,24(sp)
    8000134e:	e822                	sd	s0,16(sp)
    80001350:	e426                	sd	s1,8(sp)
    80001352:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001354:	a55ff0ef          	jal	80000da8 <myproc>
    80001358:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000135a:	496040ef          	jal	800057f0 <acquire>
  p->state = RUNNABLE;
    8000135e:	478d                	li	a5,3
    80001360:	cc9c                	sw	a5,24(s1)
  sched();
    80001362:	f2fff0ef          	jal	80001290 <sched>
  release(&p->lock);
    80001366:	8526                	mv	a0,s1
    80001368:	520040ef          	jal	80005888 <release>
}
    8000136c:	60e2                	ld	ra,24(sp)
    8000136e:	6442                	ld	s0,16(sp)
    80001370:	64a2                	ld	s1,8(sp)
    80001372:	6105                	addi	sp,sp,32
    80001374:	8082                	ret

0000000080001376 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001376:	7179                	addi	sp,sp,-48
    80001378:	f406                	sd	ra,40(sp)
    8000137a:	f022                	sd	s0,32(sp)
    8000137c:	ec26                	sd	s1,24(sp)
    8000137e:	e84a                	sd	s2,16(sp)
    80001380:	e44e                	sd	s3,8(sp)
    80001382:	1800                	addi	s0,sp,48
    80001384:	89aa                	mv	s3,a0
    80001386:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001388:	a21ff0ef          	jal	80000da8 <myproc>
    8000138c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000138e:	462040ef          	jal	800057f0 <acquire>
  release(lk);
    80001392:	854a                	mv	a0,s2
    80001394:	4f4040ef          	jal	80005888 <release>

  // Go to sleep.
  p->chan = chan;
    80001398:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000139c:	4789                	li	a5,2
    8000139e:	cc9c                	sw	a5,24(s1)

  sched();
    800013a0:	ef1ff0ef          	jal	80001290 <sched>

  // Tidy up.
  p->chan = 0;
    800013a4:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013a8:	8526                	mv	a0,s1
    800013aa:	4de040ef          	jal	80005888 <release>
  acquire(lk);
    800013ae:	854a                	mv	a0,s2
    800013b0:	440040ef          	jal	800057f0 <acquire>
}
    800013b4:	70a2                	ld	ra,40(sp)
    800013b6:	7402                	ld	s0,32(sp)
    800013b8:	64e2                	ld	s1,24(sp)
    800013ba:	6942                	ld	s2,16(sp)
    800013bc:	69a2                	ld	s3,8(sp)
    800013be:	6145                	addi	sp,sp,48
    800013c0:	8082                	ret

00000000800013c2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800013c2:	7139                	addi	sp,sp,-64
    800013c4:	fc06                	sd	ra,56(sp)
    800013c6:	f822                	sd	s0,48(sp)
    800013c8:	f426                	sd	s1,40(sp)
    800013ca:	f04a                	sd	s2,32(sp)
    800013cc:	ec4e                	sd	s3,24(sp)
    800013ce:	e852                	sd	s4,16(sp)
    800013d0:	e456                	sd	s5,8(sp)
    800013d2:	0080                	addi	s0,sp,64
    800013d4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013d6:	00009497          	auipc	s1,0x9
    800013da:	32a48493          	addi	s1,s1,810 # 8000a700 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013de:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013e0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013e2:	0000f917          	auipc	s2,0xf
    800013e6:	d1e90913          	addi	s2,s2,-738 # 80010100 <tickslock>
    800013ea:	a801                	j	800013fa <wakeup+0x38>
      }
      release(&p->lock);
    800013ec:	8526                	mv	a0,s1
    800013ee:	49a040ef          	jal	80005888 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013f2:	16848493          	addi	s1,s1,360
    800013f6:	03248263          	beq	s1,s2,8000141a <wakeup+0x58>
    if(p != myproc()){
    800013fa:	9afff0ef          	jal	80000da8 <myproc>
    800013fe:	fea48ae3          	beq	s1,a0,800013f2 <wakeup+0x30>
      acquire(&p->lock);
    80001402:	8526                	mv	a0,s1
    80001404:	3ec040ef          	jal	800057f0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001408:	4c9c                	lw	a5,24(s1)
    8000140a:	ff3791e3          	bne	a5,s3,800013ec <wakeup+0x2a>
    8000140e:	709c                	ld	a5,32(s1)
    80001410:	fd479ee3          	bne	a5,s4,800013ec <wakeup+0x2a>
        p->state = RUNNABLE;
    80001414:	0154ac23          	sw	s5,24(s1)
    80001418:	bfd1                	j	800013ec <wakeup+0x2a>
    }
  }
}
    8000141a:	70e2                	ld	ra,56(sp)
    8000141c:	7442                	ld	s0,48(sp)
    8000141e:	74a2                	ld	s1,40(sp)
    80001420:	7902                	ld	s2,32(sp)
    80001422:	69e2                	ld	s3,24(sp)
    80001424:	6a42                	ld	s4,16(sp)
    80001426:	6aa2                	ld	s5,8(sp)
    80001428:	6121                	addi	sp,sp,64
    8000142a:	8082                	ret

000000008000142c <reparent>:
{
    8000142c:	7179                	addi	sp,sp,-48
    8000142e:	f406                	sd	ra,40(sp)
    80001430:	f022                	sd	s0,32(sp)
    80001432:	ec26                	sd	s1,24(sp)
    80001434:	e84a                	sd	s2,16(sp)
    80001436:	e44e                	sd	s3,8(sp)
    80001438:	e052                	sd	s4,0(sp)
    8000143a:	1800                	addi	s0,sp,48
    8000143c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000143e:	00009497          	auipc	s1,0x9
    80001442:	2c248493          	addi	s1,s1,706 # 8000a700 <proc>
      pp->parent = initproc;
    80001446:	00009a17          	auipc	s4,0x9
    8000144a:	e4aa0a13          	addi	s4,s4,-438 # 8000a290 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000144e:	0000f997          	auipc	s3,0xf
    80001452:	cb298993          	addi	s3,s3,-846 # 80010100 <tickslock>
    80001456:	a029                	j	80001460 <reparent+0x34>
    80001458:	16848493          	addi	s1,s1,360
    8000145c:	01348b63          	beq	s1,s3,80001472 <reparent+0x46>
    if(pp->parent == p){
    80001460:	7c9c                	ld	a5,56(s1)
    80001462:	ff279be3          	bne	a5,s2,80001458 <reparent+0x2c>
      pp->parent = initproc;
    80001466:	000a3503          	ld	a0,0(s4)
    8000146a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000146c:	f57ff0ef          	jal	800013c2 <wakeup>
    80001470:	b7e5                	j	80001458 <reparent+0x2c>
}
    80001472:	70a2                	ld	ra,40(sp)
    80001474:	7402                	ld	s0,32(sp)
    80001476:	64e2                	ld	s1,24(sp)
    80001478:	6942                	ld	s2,16(sp)
    8000147a:	69a2                	ld	s3,8(sp)
    8000147c:	6a02                	ld	s4,0(sp)
    8000147e:	6145                	addi	sp,sp,48
    80001480:	8082                	ret

0000000080001482 <exit>:
{
    80001482:	7179                	addi	sp,sp,-48
    80001484:	f406                	sd	ra,40(sp)
    80001486:	f022                	sd	s0,32(sp)
    80001488:	ec26                	sd	s1,24(sp)
    8000148a:	e84a                	sd	s2,16(sp)
    8000148c:	e44e                	sd	s3,8(sp)
    8000148e:	e052                	sd	s4,0(sp)
    80001490:	1800                	addi	s0,sp,48
    80001492:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001494:	915ff0ef          	jal	80000da8 <myproc>
    80001498:	89aa                	mv	s3,a0
  if(p == initproc)
    8000149a:	00009797          	auipc	a5,0x9
    8000149e:	df67b783          	ld	a5,-522(a5) # 8000a290 <initproc>
    800014a2:	0d050493          	addi	s1,a0,208
    800014a6:	15050913          	addi	s2,a0,336
    800014aa:	00a79f63          	bne	a5,a0,800014c8 <exit+0x46>
    panic("init exiting");
    800014ae:	00006517          	auipc	a0,0x6
    800014b2:	d7250513          	addi	a0,a0,-654 # 80007220 <etext+0x220>
    800014b6:	00c040ef          	jal	800054c2 <panic>
      fileclose(f);
    800014ba:	70b010ef          	jal	800033c4 <fileclose>
      p->ofile[fd] = 0;
    800014be:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014c2:	04a1                	addi	s1,s1,8
    800014c4:	01248563          	beq	s1,s2,800014ce <exit+0x4c>
    if(p->ofile[fd]){
    800014c8:	6088                	ld	a0,0(s1)
    800014ca:	f965                	bnez	a0,800014ba <exit+0x38>
    800014cc:	bfdd                	j	800014c2 <exit+0x40>
  begin_op();
    800014ce:	2dd010ef          	jal	80002faa <begin_op>
  iput(p->cwd);
    800014d2:	1509b503          	ld	a0,336(s3)
    800014d6:	3c0010ef          	jal	80002896 <iput>
  end_op();
    800014da:	33b010ef          	jal	80003014 <end_op>
  p->cwd = 0;
    800014de:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014e2:	00009497          	auipc	s1,0x9
    800014e6:	e0648493          	addi	s1,s1,-506 # 8000a2e8 <wait_lock>
    800014ea:	8526                	mv	a0,s1
    800014ec:	304040ef          	jal	800057f0 <acquire>
  reparent(p);
    800014f0:	854e                	mv	a0,s3
    800014f2:	f3bff0ef          	jal	8000142c <reparent>
  wakeup(p->parent);
    800014f6:	0389b503          	ld	a0,56(s3)
    800014fa:	ec9ff0ef          	jal	800013c2 <wakeup>
  acquire(&p->lock);
    800014fe:	854e                	mv	a0,s3
    80001500:	2f0040ef          	jal	800057f0 <acquire>
  p->xstate = status;
    80001504:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001508:	4795                	li	a5,5
    8000150a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000150e:	8526                	mv	a0,s1
    80001510:	378040ef          	jal	80005888 <release>
  sched();
    80001514:	d7dff0ef          	jal	80001290 <sched>
  panic("zombie exit");
    80001518:	00006517          	auipc	a0,0x6
    8000151c:	d1850513          	addi	a0,a0,-744 # 80007230 <etext+0x230>
    80001520:	7a3030ef          	jal	800054c2 <panic>

0000000080001524 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001524:	7179                	addi	sp,sp,-48
    80001526:	f406                	sd	ra,40(sp)
    80001528:	f022                	sd	s0,32(sp)
    8000152a:	ec26                	sd	s1,24(sp)
    8000152c:	e84a                	sd	s2,16(sp)
    8000152e:	e44e                	sd	s3,8(sp)
    80001530:	1800                	addi	s0,sp,48
    80001532:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001534:	00009497          	auipc	s1,0x9
    80001538:	1cc48493          	addi	s1,s1,460 # 8000a700 <proc>
    8000153c:	0000f997          	auipc	s3,0xf
    80001540:	bc498993          	addi	s3,s3,-1084 # 80010100 <tickslock>
    acquire(&p->lock);
    80001544:	8526                	mv	a0,s1
    80001546:	2aa040ef          	jal	800057f0 <acquire>
    if(p->pid == pid){
    8000154a:	589c                	lw	a5,48(s1)
    8000154c:	01278b63          	beq	a5,s2,80001562 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001550:	8526                	mv	a0,s1
    80001552:	336040ef          	jal	80005888 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001556:	16848493          	addi	s1,s1,360
    8000155a:	ff3495e3          	bne	s1,s3,80001544 <kill+0x20>
  }
  return -1;
    8000155e:	557d                	li	a0,-1
    80001560:	a819                	j	80001576 <kill+0x52>
      p->killed = 1;
    80001562:	4785                	li	a5,1
    80001564:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001566:	4c98                	lw	a4,24(s1)
    80001568:	4789                	li	a5,2
    8000156a:	00f70d63          	beq	a4,a5,80001584 <kill+0x60>
      release(&p->lock);
    8000156e:	8526                	mv	a0,s1
    80001570:	318040ef          	jal	80005888 <release>
      return 0;
    80001574:	4501                	li	a0,0
}
    80001576:	70a2                	ld	ra,40(sp)
    80001578:	7402                	ld	s0,32(sp)
    8000157a:	64e2                	ld	s1,24(sp)
    8000157c:	6942                	ld	s2,16(sp)
    8000157e:	69a2                	ld	s3,8(sp)
    80001580:	6145                	addi	sp,sp,48
    80001582:	8082                	ret
        p->state = RUNNABLE;
    80001584:	478d                	li	a5,3
    80001586:	cc9c                	sw	a5,24(s1)
    80001588:	b7dd                	j	8000156e <kill+0x4a>

000000008000158a <setkilled>:

void
setkilled(struct proc *p)
{
    8000158a:	1101                	addi	sp,sp,-32
    8000158c:	ec06                	sd	ra,24(sp)
    8000158e:	e822                	sd	s0,16(sp)
    80001590:	e426                	sd	s1,8(sp)
    80001592:	1000                	addi	s0,sp,32
    80001594:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001596:	25a040ef          	jal	800057f0 <acquire>
  p->killed = 1;
    8000159a:	4785                	li	a5,1
    8000159c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000159e:	8526                	mv	a0,s1
    800015a0:	2e8040ef          	jal	80005888 <release>
}
    800015a4:	60e2                	ld	ra,24(sp)
    800015a6:	6442                	ld	s0,16(sp)
    800015a8:	64a2                	ld	s1,8(sp)
    800015aa:	6105                	addi	sp,sp,32
    800015ac:	8082                	ret

00000000800015ae <killed>:

int
killed(struct proc *p)
{
    800015ae:	1101                	addi	sp,sp,-32
    800015b0:	ec06                	sd	ra,24(sp)
    800015b2:	e822                	sd	s0,16(sp)
    800015b4:	e426                	sd	s1,8(sp)
    800015b6:	e04a                	sd	s2,0(sp)
    800015b8:	1000                	addi	s0,sp,32
    800015ba:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015bc:	234040ef          	jal	800057f0 <acquire>
  k = p->killed;
    800015c0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015c4:	8526                	mv	a0,s1
    800015c6:	2c2040ef          	jal	80005888 <release>
  return k;
}
    800015ca:	854a                	mv	a0,s2
    800015cc:	60e2                	ld	ra,24(sp)
    800015ce:	6442                	ld	s0,16(sp)
    800015d0:	64a2                	ld	s1,8(sp)
    800015d2:	6902                	ld	s2,0(sp)
    800015d4:	6105                	addi	sp,sp,32
    800015d6:	8082                	ret

00000000800015d8 <wait>:
{
    800015d8:	715d                	addi	sp,sp,-80
    800015da:	e486                	sd	ra,72(sp)
    800015dc:	e0a2                	sd	s0,64(sp)
    800015de:	fc26                	sd	s1,56(sp)
    800015e0:	f84a                	sd	s2,48(sp)
    800015e2:	f44e                	sd	s3,40(sp)
    800015e4:	f052                	sd	s4,32(sp)
    800015e6:	ec56                	sd	s5,24(sp)
    800015e8:	e85a                	sd	s6,16(sp)
    800015ea:	e45e                	sd	s7,8(sp)
    800015ec:	e062                	sd	s8,0(sp)
    800015ee:	0880                	addi	s0,sp,80
    800015f0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015f2:	fb6ff0ef          	jal	80000da8 <myproc>
    800015f6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015f8:	00009517          	auipc	a0,0x9
    800015fc:	cf050513          	addi	a0,a0,-784 # 8000a2e8 <wait_lock>
    80001600:	1f0040ef          	jal	800057f0 <acquire>
    havekids = 0;
    80001604:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001606:	4a15                	li	s4,5
        havekids = 1;
    80001608:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000160a:	0000f997          	auipc	s3,0xf
    8000160e:	af698993          	addi	s3,s3,-1290 # 80010100 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001612:	00009c17          	auipc	s8,0x9
    80001616:	cd6c0c13          	addi	s8,s8,-810 # 8000a2e8 <wait_lock>
    8000161a:	a871                	j	800016b6 <wait+0xde>
          pid = pp->pid;
    8000161c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001620:	000b0c63          	beqz	s6,80001638 <wait+0x60>
    80001624:	4691                	li	a3,4
    80001626:	02c48613          	addi	a2,s1,44
    8000162a:	85da                	mv	a1,s6
    8000162c:	05093503          	ld	a0,80(s2)
    80001630:	beaff0ef          	jal	80000a1a <copyout>
    80001634:	02054b63          	bltz	a0,8000166a <wait+0x92>
          freeproc(pp);
    80001638:	8526                	mv	a0,s1
    8000163a:	8e1ff0ef          	jal	80000f1a <freeproc>
          release(&pp->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	248040ef          	jal	80005888 <release>
          release(&wait_lock);
    80001644:	00009517          	auipc	a0,0x9
    80001648:	ca450513          	addi	a0,a0,-860 # 8000a2e8 <wait_lock>
    8000164c:	23c040ef          	jal	80005888 <release>
}
    80001650:	854e                	mv	a0,s3
    80001652:	60a6                	ld	ra,72(sp)
    80001654:	6406                	ld	s0,64(sp)
    80001656:	74e2                	ld	s1,56(sp)
    80001658:	7942                	ld	s2,48(sp)
    8000165a:	79a2                	ld	s3,40(sp)
    8000165c:	7a02                	ld	s4,32(sp)
    8000165e:	6ae2                	ld	s5,24(sp)
    80001660:	6b42                	ld	s6,16(sp)
    80001662:	6ba2                	ld	s7,8(sp)
    80001664:	6c02                	ld	s8,0(sp)
    80001666:	6161                	addi	sp,sp,80
    80001668:	8082                	ret
            release(&pp->lock);
    8000166a:	8526                	mv	a0,s1
    8000166c:	21c040ef          	jal	80005888 <release>
            release(&wait_lock);
    80001670:	00009517          	auipc	a0,0x9
    80001674:	c7850513          	addi	a0,a0,-904 # 8000a2e8 <wait_lock>
    80001678:	210040ef          	jal	80005888 <release>
            return -1;
    8000167c:	59fd                	li	s3,-1
    8000167e:	bfc9                	j	80001650 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001680:	16848493          	addi	s1,s1,360
    80001684:	03348063          	beq	s1,s3,800016a4 <wait+0xcc>
      if(pp->parent == p){
    80001688:	7c9c                	ld	a5,56(s1)
    8000168a:	ff279be3          	bne	a5,s2,80001680 <wait+0xa8>
        acquire(&pp->lock);
    8000168e:	8526                	mv	a0,s1
    80001690:	160040ef          	jal	800057f0 <acquire>
        if(pp->state == ZOMBIE){
    80001694:	4c9c                	lw	a5,24(s1)
    80001696:	f94783e3          	beq	a5,s4,8000161c <wait+0x44>
        release(&pp->lock);
    8000169a:	8526                	mv	a0,s1
    8000169c:	1ec040ef          	jal	80005888 <release>
        havekids = 1;
    800016a0:	8756                	mv	a4,s5
    800016a2:	bff9                	j	80001680 <wait+0xa8>
    if(!havekids || killed(p)){
    800016a4:	cf19                	beqz	a4,800016c2 <wait+0xea>
    800016a6:	854a                	mv	a0,s2
    800016a8:	f07ff0ef          	jal	800015ae <killed>
    800016ac:	e919                	bnez	a0,800016c2 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016ae:	85e2                	mv	a1,s8
    800016b0:	854a                	mv	a0,s2
    800016b2:	cc5ff0ef          	jal	80001376 <sleep>
    havekids = 0;
    800016b6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016b8:	00009497          	auipc	s1,0x9
    800016bc:	04848493          	addi	s1,s1,72 # 8000a700 <proc>
    800016c0:	b7e1                	j	80001688 <wait+0xb0>
      release(&wait_lock);
    800016c2:	00009517          	auipc	a0,0x9
    800016c6:	c2650513          	addi	a0,a0,-986 # 8000a2e8 <wait_lock>
    800016ca:	1be040ef          	jal	80005888 <release>
      return -1;
    800016ce:	59fd                	li	s3,-1
    800016d0:	b741                	j	80001650 <wait+0x78>

00000000800016d2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016d2:	7179                	addi	sp,sp,-48
    800016d4:	f406                	sd	ra,40(sp)
    800016d6:	f022                	sd	s0,32(sp)
    800016d8:	ec26                	sd	s1,24(sp)
    800016da:	e84a                	sd	s2,16(sp)
    800016dc:	e44e                	sd	s3,8(sp)
    800016de:	e052                	sd	s4,0(sp)
    800016e0:	1800                	addi	s0,sp,48
    800016e2:	84aa                	mv	s1,a0
    800016e4:	892e                	mv	s2,a1
    800016e6:	89b2                	mv	s3,a2
    800016e8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016ea:	ebeff0ef          	jal	80000da8 <myproc>
  if(user_dst){
    800016ee:	cc99                	beqz	s1,8000170c <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016f0:	86d2                	mv	a3,s4
    800016f2:	864e                	mv	a2,s3
    800016f4:	85ca                	mv	a1,s2
    800016f6:	6928                	ld	a0,80(a0)
    800016f8:	b22ff0ef          	jal	80000a1a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016fc:	70a2                	ld	ra,40(sp)
    800016fe:	7402                	ld	s0,32(sp)
    80001700:	64e2                	ld	s1,24(sp)
    80001702:	6942                	ld	s2,16(sp)
    80001704:	69a2                	ld	s3,8(sp)
    80001706:	6a02                	ld	s4,0(sp)
    80001708:	6145                	addi	sp,sp,48
    8000170a:	8082                	ret
    memmove((char *)dst, src, len);
    8000170c:	000a061b          	sext.w	a2,s4
    80001710:	85ce                	mv	a1,s3
    80001712:	854a                	mv	a0,s2
    80001714:	ad9fe0ef          	jal	800001ec <memmove>
    return 0;
    80001718:	8526                	mv	a0,s1
    8000171a:	b7cd                	j	800016fc <either_copyout+0x2a>

000000008000171c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000171c:	7179                	addi	sp,sp,-48
    8000171e:	f406                	sd	ra,40(sp)
    80001720:	f022                	sd	s0,32(sp)
    80001722:	ec26                	sd	s1,24(sp)
    80001724:	e84a                	sd	s2,16(sp)
    80001726:	e44e                	sd	s3,8(sp)
    80001728:	e052                	sd	s4,0(sp)
    8000172a:	1800                	addi	s0,sp,48
    8000172c:	892a                	mv	s2,a0
    8000172e:	84ae                	mv	s1,a1
    80001730:	89b2                	mv	s3,a2
    80001732:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001734:	e74ff0ef          	jal	80000da8 <myproc>
  if(user_src){
    80001738:	cc99                	beqz	s1,80001756 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000173a:	86d2                	mv	a3,s4
    8000173c:	864e                	mv	a2,s3
    8000173e:	85ca                	mv	a1,s2
    80001740:	6928                	ld	a0,80(a0)
    80001742:	baeff0ef          	jal	80000af0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001746:	70a2                	ld	ra,40(sp)
    80001748:	7402                	ld	s0,32(sp)
    8000174a:	64e2                	ld	s1,24(sp)
    8000174c:	6942                	ld	s2,16(sp)
    8000174e:	69a2                	ld	s3,8(sp)
    80001750:	6a02                	ld	s4,0(sp)
    80001752:	6145                	addi	sp,sp,48
    80001754:	8082                	ret
    memmove(dst, (char*)src, len);
    80001756:	000a061b          	sext.w	a2,s4
    8000175a:	85ce                	mv	a1,s3
    8000175c:	854a                	mv	a0,s2
    8000175e:	a8ffe0ef          	jal	800001ec <memmove>
    return 0;
    80001762:	8526                	mv	a0,s1
    80001764:	b7cd                	j	80001746 <either_copyin+0x2a>

0000000080001766 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001766:	715d                	addi	sp,sp,-80
    80001768:	e486                	sd	ra,72(sp)
    8000176a:	e0a2                	sd	s0,64(sp)
    8000176c:	fc26                	sd	s1,56(sp)
    8000176e:	f84a                	sd	s2,48(sp)
    80001770:	f44e                	sd	s3,40(sp)
    80001772:	f052                	sd	s4,32(sp)
    80001774:	ec56                	sd	s5,24(sp)
    80001776:	e85a                	sd	s6,16(sp)
    80001778:	e45e                	sd	s7,8(sp)
    8000177a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000177c:	00006517          	auipc	a0,0x6
    80001780:	89c50513          	addi	a0,a0,-1892 # 80007018 <etext+0x18>
    80001784:	26d030ef          	jal	800051f0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001788:	00009497          	auipc	s1,0x9
    8000178c:	0d048493          	addi	s1,s1,208 # 8000a858 <proc+0x158>
    80001790:	0000f917          	auipc	s2,0xf
    80001794:	ac890913          	addi	s2,s2,-1336 # 80010258 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001798:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000179a:	00006997          	auipc	s3,0x6
    8000179e:	aa698993          	addi	s3,s3,-1370 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    800017a2:	00006a97          	auipc	s5,0x6
    800017a6:	aa6a8a93          	addi	s5,s5,-1370 # 80007248 <etext+0x248>
    printf("\n");
    800017aa:	00006a17          	auipc	s4,0x6
    800017ae:	86ea0a13          	addi	s4,s4,-1938 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017b2:	00006b97          	auipc	s7,0x6
    800017b6:	fbeb8b93          	addi	s7,s7,-66 # 80007770 <states.0>
    800017ba:	a829                	j	800017d4 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017bc:	ed86a583          	lw	a1,-296(a3)
    800017c0:	8556                	mv	a0,s5
    800017c2:	22f030ef          	jal	800051f0 <printf>
    printf("\n");
    800017c6:	8552                	mv	a0,s4
    800017c8:	229030ef          	jal	800051f0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017cc:	16848493          	addi	s1,s1,360
    800017d0:	03248263          	beq	s1,s2,800017f4 <procdump+0x8e>
    if(p->state == UNUSED)
    800017d4:	86a6                	mv	a3,s1
    800017d6:	ec04a783          	lw	a5,-320(s1)
    800017da:	dbed                	beqz	a5,800017cc <procdump+0x66>
      state = "???";
    800017dc:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017de:	fcfb6fe3          	bltu	s6,a5,800017bc <procdump+0x56>
    800017e2:	02079713          	slli	a4,a5,0x20
    800017e6:	01d75793          	srli	a5,a4,0x1d
    800017ea:	97de                	add	a5,a5,s7
    800017ec:	6390                	ld	a2,0(a5)
    800017ee:	f679                	bnez	a2,800017bc <procdump+0x56>
      state = "???";
    800017f0:	864e                	mv	a2,s3
    800017f2:	b7e9                	j	800017bc <procdump+0x56>
  }
}
    800017f4:	60a6                	ld	ra,72(sp)
    800017f6:	6406                	ld	s0,64(sp)
    800017f8:	74e2                	ld	s1,56(sp)
    800017fa:	7942                	ld	s2,48(sp)
    800017fc:	79a2                	ld	s3,40(sp)
    800017fe:	7a02                	ld	s4,32(sp)
    80001800:	6ae2                	ld	s5,24(sp)
    80001802:	6b42                	ld	s6,16(sp)
    80001804:	6ba2                	ld	s7,8(sp)
    80001806:	6161                	addi	sp,sp,80
    80001808:	8082                	ret

000000008000180a <getnproc>:

uint64
getnproc(void)
{
    8000180a:	7179                	addi	sp,sp,-48
    8000180c:	f406                	sd	ra,40(sp)
    8000180e:	f022                	sd	s0,32(sp)
    80001810:	ec26                	sd	s1,24(sp)
    80001812:	e84a                	sd	s2,16(sp)
    80001814:	e44e                	sd	s3,8(sp)
    80001816:	1800                	addi	s0,sp,48
  struct proc* p;
  uint64 nproc = 0;
    80001818:	4901                	li	s2,0

  for(p = proc; p < &proc[NPROC]; p++){
    8000181a:	00009497          	auipc	s1,0x9
    8000181e:	ee648493          	addi	s1,s1,-282 # 8000a700 <proc>
    80001822:	0000f997          	auipc	s3,0xf
    80001826:	8de98993          	addi	s3,s3,-1826 # 80010100 <tickslock>
    acquire(&p->lock);
    8000182a:	8526                	mv	a0,s1
    8000182c:	7c5030ef          	jal	800057f0 <acquire>
    if(p->state != UNUSED){
    80001830:	4c9c                	lw	a5,24(s1)
      nproc++;
    80001832:	00f037b3          	snez	a5,a5
    80001836:	993e                	add	s2,s2,a5
    }
    release(&p->lock);
    80001838:	8526                	mv	a0,s1
    8000183a:	04e040ef          	jal	80005888 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000183e:	16848493          	addi	s1,s1,360
    80001842:	ff3494e3          	bne	s1,s3,8000182a <getnproc+0x20>
  }

  return nproc;
}
    80001846:	854a                	mv	a0,s2
    80001848:	70a2                	ld	ra,40(sp)
    8000184a:	7402                	ld	s0,32(sp)
    8000184c:	64e2                	ld	s1,24(sp)
    8000184e:	6942                	ld	s2,16(sp)
    80001850:	69a2                	ld	s3,8(sp)
    80001852:	6145                	addi	sp,sp,48
    80001854:	8082                	ret

0000000080001856 <swtch>:
    80001856:	00153023          	sd	ra,0(a0)
    8000185a:	00253423          	sd	sp,8(a0)
    8000185e:	e900                	sd	s0,16(a0)
    80001860:	ed04                	sd	s1,24(a0)
    80001862:	03253023          	sd	s2,32(a0)
    80001866:	03353423          	sd	s3,40(a0)
    8000186a:	03453823          	sd	s4,48(a0)
    8000186e:	03553c23          	sd	s5,56(a0)
    80001872:	05653023          	sd	s6,64(a0)
    80001876:	05753423          	sd	s7,72(a0)
    8000187a:	05853823          	sd	s8,80(a0)
    8000187e:	05953c23          	sd	s9,88(a0)
    80001882:	07a53023          	sd	s10,96(a0)
    80001886:	07b53423          	sd	s11,104(a0)
    8000188a:	0005b083          	ld	ra,0(a1)
    8000188e:	0085b103          	ld	sp,8(a1)
    80001892:	6980                	ld	s0,16(a1)
    80001894:	6d84                	ld	s1,24(a1)
    80001896:	0205b903          	ld	s2,32(a1)
    8000189a:	0285b983          	ld	s3,40(a1)
    8000189e:	0305ba03          	ld	s4,48(a1)
    800018a2:	0385ba83          	ld	s5,56(a1)
    800018a6:	0405bb03          	ld	s6,64(a1)
    800018aa:	0485bb83          	ld	s7,72(a1)
    800018ae:	0505bc03          	ld	s8,80(a1)
    800018b2:	0585bc83          	ld	s9,88(a1)
    800018b6:	0605bd03          	ld	s10,96(a1)
    800018ba:	0685bd83          	ld	s11,104(a1)
    800018be:	8082                	ret

00000000800018c0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018c0:	1141                	addi	sp,sp,-16
    800018c2:	e406                	sd	ra,8(sp)
    800018c4:	e022                	sd	s0,0(sp)
    800018c6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018c8:	00006597          	auipc	a1,0x6
    800018cc:	9c058593          	addi	a1,a1,-1600 # 80007288 <etext+0x288>
    800018d0:	0000f517          	auipc	a0,0xf
    800018d4:	83050513          	addi	a0,a0,-2000 # 80010100 <tickslock>
    800018d8:	699030ef          	jal	80005770 <initlock>
}
    800018dc:	60a2                	ld	ra,8(sp)
    800018de:	6402                	ld	s0,0(sp)
    800018e0:	0141                	addi	sp,sp,16
    800018e2:	8082                	ret

00000000800018e4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018e4:	1141                	addi	sp,sp,-16
    800018e6:	e422                	sd	s0,8(sp)
    800018e8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018ea:	00003797          	auipc	a5,0x3
    800018ee:	e4678793          	addi	a5,a5,-442 # 80004730 <kernelvec>
    800018f2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018f6:	6422                	ld	s0,8(sp)
    800018f8:	0141                	addi	sp,sp,16
    800018fa:	8082                	ret

00000000800018fc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800018fc:	1141                	addi	sp,sp,-16
    800018fe:	e406                	sd	ra,8(sp)
    80001900:	e022                	sd	s0,0(sp)
    80001902:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001904:	ca4ff0ef          	jal	80000da8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001908:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000190c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000190e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001912:	00004697          	auipc	a3,0x4
    80001916:	6ee68693          	addi	a3,a3,1774 # 80006000 <_trampoline>
    8000191a:	00004717          	auipc	a4,0x4
    8000191e:	6e670713          	addi	a4,a4,1766 # 80006000 <_trampoline>
    80001922:	8f15                	sub	a4,a4,a3
    80001924:	040007b7          	lui	a5,0x4000
    80001928:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000192a:	07b2                	slli	a5,a5,0xc
    8000192c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000192e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001932:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001934:	18002673          	csrr	a2,satp
    80001938:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000193a:	6d30                	ld	a2,88(a0)
    8000193c:	6138                	ld	a4,64(a0)
    8000193e:	6585                	lui	a1,0x1
    80001940:	972e                	add	a4,a4,a1
    80001942:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001944:	6d38                	ld	a4,88(a0)
    80001946:	00000617          	auipc	a2,0x0
    8000194a:	11060613          	addi	a2,a2,272 # 80001a56 <usertrap>
    8000194e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001950:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001952:	8612                	mv	a2,tp
    80001954:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001956:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000195a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000195e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001962:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001966:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001968:	6f18                	ld	a4,24(a4)
    8000196a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000196e:	6928                	ld	a0,80(a0)
    80001970:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001972:	00004717          	auipc	a4,0x4
    80001976:	72a70713          	addi	a4,a4,1834 # 8000609c <userret>
    8000197a:	8f15                	sub	a4,a4,a3
    8000197c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000197e:	577d                	li	a4,-1
    80001980:	177e                	slli	a4,a4,0x3f
    80001982:	8d59                	or	a0,a0,a4
    80001984:	9782                	jalr	a5
}
    80001986:	60a2                	ld	ra,8(sp)
    80001988:	6402                	ld	s0,0(sp)
    8000198a:	0141                	addi	sp,sp,16
    8000198c:	8082                	ret

000000008000198e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000198e:	1101                	addi	sp,sp,-32
    80001990:	ec06                	sd	ra,24(sp)
    80001992:	e822                	sd	s0,16(sp)
    80001994:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001996:	be6ff0ef          	jal	80000d7c <cpuid>
    8000199a:	cd11                	beqz	a0,800019b6 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000199c:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800019a0:	000f4737          	lui	a4,0xf4
    800019a4:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800019a8:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800019aa:	14d79073          	csrw	stimecmp,a5
}
    800019ae:	60e2                	ld	ra,24(sp)
    800019b0:	6442                	ld	s0,16(sp)
    800019b2:	6105                	addi	sp,sp,32
    800019b4:	8082                	ret
    800019b6:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800019b8:	0000e497          	auipc	s1,0xe
    800019bc:	74848493          	addi	s1,s1,1864 # 80010100 <tickslock>
    800019c0:	8526                	mv	a0,s1
    800019c2:	62f030ef          	jal	800057f0 <acquire>
    ticks++;
    800019c6:	00009517          	auipc	a0,0x9
    800019ca:	8d250513          	addi	a0,a0,-1838 # 8000a298 <ticks>
    800019ce:	411c                	lw	a5,0(a0)
    800019d0:	2785                	addiw	a5,a5,1
    800019d2:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019d4:	9efff0ef          	jal	800013c2 <wakeup>
    release(&tickslock);
    800019d8:	8526                	mv	a0,s1
    800019da:	6af030ef          	jal	80005888 <release>
    800019de:	64a2                	ld	s1,8(sp)
    800019e0:	bf75                	j	8000199c <clockintr+0xe>

00000000800019e2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019e2:	1101                	addi	sp,sp,-32
    800019e4:	ec06                	sd	ra,24(sp)
    800019e6:	e822                	sd	s0,16(sp)
    800019e8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019ea:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019ee:	57fd                	li	a5,-1
    800019f0:	17fe                	slli	a5,a5,0x3f
    800019f2:	07a5                	addi	a5,a5,9
    800019f4:	00f70c63          	beq	a4,a5,80001a0c <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019f8:	57fd                	li	a5,-1
    800019fa:	17fe                	slli	a5,a5,0x3f
    800019fc:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019fe:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a00:	04f70763          	beq	a4,a5,80001a4e <devintr+0x6c>
  }
}
    80001a04:	60e2                	ld	ra,24(sp)
    80001a06:	6442                	ld	s0,16(sp)
    80001a08:	6105                	addi	sp,sp,32
    80001a0a:	8082                	ret
    80001a0c:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a0e:	5cf020ef          	jal	800047dc <plic_claim>
    80001a12:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a14:	47a9                	li	a5,10
    80001a16:	00f50963          	beq	a0,a5,80001a28 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001a1a:	4785                	li	a5,1
    80001a1c:	00f50963          	beq	a0,a5,80001a2e <devintr+0x4c>
    return 1;
    80001a20:	4505                	li	a0,1
    } else if(irq){
    80001a22:	e889                	bnez	s1,80001a34 <devintr+0x52>
    80001a24:	64a2                	ld	s1,8(sp)
    80001a26:	bff9                	j	80001a04 <devintr+0x22>
      uartintr();
    80001a28:	50d030ef          	jal	80005734 <uartintr>
    if(irq)
    80001a2c:	a819                	j	80001a42 <devintr+0x60>
      virtio_disk_intr();
    80001a2e:	274030ef          	jal	80004ca2 <virtio_disk_intr>
    if(irq)
    80001a32:	a801                	j	80001a42 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a34:	85a6                	mv	a1,s1
    80001a36:	00006517          	auipc	a0,0x6
    80001a3a:	85a50513          	addi	a0,a0,-1958 # 80007290 <etext+0x290>
    80001a3e:	7b2030ef          	jal	800051f0 <printf>
      plic_complete(irq);
    80001a42:	8526                	mv	a0,s1
    80001a44:	5b9020ef          	jal	800047fc <plic_complete>
    return 1;
    80001a48:	4505                	li	a0,1
    80001a4a:	64a2                	ld	s1,8(sp)
    80001a4c:	bf65                	j	80001a04 <devintr+0x22>
    clockintr();
    80001a4e:	f41ff0ef          	jal	8000198e <clockintr>
    return 2;
    80001a52:	4509                	li	a0,2
    80001a54:	bf45                	j	80001a04 <devintr+0x22>

0000000080001a56 <usertrap>:
{
    80001a56:	1101                	addi	sp,sp,-32
    80001a58:	ec06                	sd	ra,24(sp)
    80001a5a:	e822                	sd	s0,16(sp)
    80001a5c:	e426                	sd	s1,8(sp)
    80001a5e:	e04a                	sd	s2,0(sp)
    80001a60:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a62:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a66:	1007f793          	andi	a5,a5,256
    80001a6a:	ef85                	bnez	a5,80001aa2 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a6c:	00003797          	auipc	a5,0x3
    80001a70:	cc478793          	addi	a5,a5,-828 # 80004730 <kernelvec>
    80001a74:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a78:	b30ff0ef          	jal	80000da8 <myproc>
    80001a7c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a7e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a80:	14102773          	csrr	a4,sepc
    80001a84:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a86:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a8a:	47a1                	li	a5,8
    80001a8c:	02f70163          	beq	a4,a5,80001aae <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a90:	f53ff0ef          	jal	800019e2 <devintr>
    80001a94:	892a                	mv	s2,a0
    80001a96:	c135                	beqz	a0,80001afa <usertrap+0xa4>
  if(killed(p))
    80001a98:	8526                	mv	a0,s1
    80001a9a:	b15ff0ef          	jal	800015ae <killed>
    80001a9e:	cd1d                	beqz	a0,80001adc <usertrap+0x86>
    80001aa0:	a81d                	j	80001ad6 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001aa2:	00006517          	auipc	a0,0x6
    80001aa6:	80e50513          	addi	a0,a0,-2034 # 800072b0 <etext+0x2b0>
    80001aaa:	219030ef          	jal	800054c2 <panic>
    if(killed(p))
    80001aae:	b01ff0ef          	jal	800015ae <killed>
    80001ab2:	e121                	bnez	a0,80001af2 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001ab4:	6cb8                	ld	a4,88(s1)
    80001ab6:	6f1c                	ld	a5,24(a4)
    80001ab8:	0791                	addi	a5,a5,4
    80001aba:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001abc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ac0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac4:	10079073          	csrw	sstatus,a5
    syscall();
    80001ac8:	248000ef          	jal	80001d10 <syscall>
  if(killed(p))
    80001acc:	8526                	mv	a0,s1
    80001ace:	ae1ff0ef          	jal	800015ae <killed>
    80001ad2:	c901                	beqz	a0,80001ae2 <usertrap+0x8c>
    80001ad4:	4901                	li	s2,0
    exit(-1);
    80001ad6:	557d                	li	a0,-1
    80001ad8:	9abff0ef          	jal	80001482 <exit>
  if(which_dev == 2)
    80001adc:	4789                	li	a5,2
    80001ade:	04f90563          	beq	s2,a5,80001b28 <usertrap+0xd2>
  usertrapret();
    80001ae2:	e1bff0ef          	jal	800018fc <usertrapret>
}
    80001ae6:	60e2                	ld	ra,24(sp)
    80001ae8:	6442                	ld	s0,16(sp)
    80001aea:	64a2                	ld	s1,8(sp)
    80001aec:	6902                	ld	s2,0(sp)
    80001aee:	6105                	addi	sp,sp,32
    80001af0:	8082                	ret
      exit(-1);
    80001af2:	557d                	li	a0,-1
    80001af4:	98fff0ef          	jal	80001482 <exit>
    80001af8:	bf75                	j	80001ab4 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001afa:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001afe:	5890                	lw	a2,48(s1)
    80001b00:	00005517          	auipc	a0,0x5
    80001b04:	7d050513          	addi	a0,a0,2000 # 800072d0 <etext+0x2d0>
    80001b08:	6e8030ef          	jal	800051f0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b0c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b10:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b14:	00005517          	auipc	a0,0x5
    80001b18:	7ec50513          	addi	a0,a0,2028 # 80007300 <etext+0x300>
    80001b1c:	6d4030ef          	jal	800051f0 <printf>
    setkilled(p);
    80001b20:	8526                	mv	a0,s1
    80001b22:	a69ff0ef          	jal	8000158a <setkilled>
    80001b26:	b75d                	j	80001acc <usertrap+0x76>
    yield();
    80001b28:	823ff0ef          	jal	8000134a <yield>
    80001b2c:	bf5d                	j	80001ae2 <usertrap+0x8c>

0000000080001b2e <kerneltrap>:
{
    80001b2e:	7179                	addi	sp,sp,-48
    80001b30:	f406                	sd	ra,40(sp)
    80001b32:	f022                	sd	s0,32(sp)
    80001b34:	ec26                	sd	s1,24(sp)
    80001b36:	e84a                	sd	s2,16(sp)
    80001b38:	e44e                	sd	s3,8(sp)
    80001b3a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b3c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b40:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b44:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b48:	1004f793          	andi	a5,s1,256
    80001b4c:	c795                	beqz	a5,80001b78 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b52:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b54:	eb85                	bnez	a5,80001b84 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b56:	e8dff0ef          	jal	800019e2 <devintr>
    80001b5a:	c91d                	beqz	a0,80001b90 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b5c:	4789                	li	a5,2
    80001b5e:	04f50a63          	beq	a0,a5,80001bb2 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b62:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b66:	10049073          	csrw	sstatus,s1
}
    80001b6a:	70a2                	ld	ra,40(sp)
    80001b6c:	7402                	ld	s0,32(sp)
    80001b6e:	64e2                	ld	s1,24(sp)
    80001b70:	6942                	ld	s2,16(sp)
    80001b72:	69a2                	ld	s3,8(sp)
    80001b74:	6145                	addi	sp,sp,48
    80001b76:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b78:	00005517          	auipc	a0,0x5
    80001b7c:	7b050513          	addi	a0,a0,1968 # 80007328 <etext+0x328>
    80001b80:	143030ef          	jal	800054c2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b84:	00005517          	auipc	a0,0x5
    80001b88:	7cc50513          	addi	a0,a0,1996 # 80007350 <etext+0x350>
    80001b8c:	137030ef          	jal	800054c2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b90:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b94:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b98:	85ce                	mv	a1,s3
    80001b9a:	00005517          	auipc	a0,0x5
    80001b9e:	7d650513          	addi	a0,a0,2006 # 80007370 <etext+0x370>
    80001ba2:	64e030ef          	jal	800051f0 <printf>
    panic("kerneltrap");
    80001ba6:	00005517          	auipc	a0,0x5
    80001baa:	7f250513          	addi	a0,a0,2034 # 80007398 <etext+0x398>
    80001bae:	115030ef          	jal	800054c2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001bb2:	9f6ff0ef          	jal	80000da8 <myproc>
    80001bb6:	d555                	beqz	a0,80001b62 <kerneltrap+0x34>
    yield();
    80001bb8:	f92ff0ef          	jal	8000134a <yield>
    80001bbc:	b75d                	j	80001b62 <kerneltrap+0x34>

0000000080001bbe <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bbe:	1101                	addi	sp,sp,-32
    80001bc0:	ec06                	sd	ra,24(sp)
    80001bc2:	e822                	sd	s0,16(sp)
    80001bc4:	e426                	sd	s1,8(sp)
    80001bc6:	1000                	addi	s0,sp,32
    80001bc8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bca:	9deff0ef          	jal	80000da8 <myproc>
  switch (n) {
    80001bce:	4795                	li	a5,5
    80001bd0:	0497e163          	bltu	a5,s1,80001c12 <argraw+0x54>
    80001bd4:	048a                	slli	s1,s1,0x2
    80001bd6:	00006717          	auipc	a4,0x6
    80001bda:	bca70713          	addi	a4,a4,-1078 # 800077a0 <states.0+0x30>
    80001bde:	94ba                	add	s1,s1,a4
    80001be0:	409c                	lw	a5,0(s1)
    80001be2:	97ba                	add	a5,a5,a4
    80001be4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001be6:	6d3c                	ld	a5,88(a0)
    80001be8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bea:	60e2                	ld	ra,24(sp)
    80001bec:	6442                	ld	s0,16(sp)
    80001bee:	64a2                	ld	s1,8(sp)
    80001bf0:	6105                	addi	sp,sp,32
    80001bf2:	8082                	ret
    return p->trapframe->a1;
    80001bf4:	6d3c                	ld	a5,88(a0)
    80001bf6:	7fa8                	ld	a0,120(a5)
    80001bf8:	bfcd                	j	80001bea <argraw+0x2c>
    return p->trapframe->a2;
    80001bfa:	6d3c                	ld	a5,88(a0)
    80001bfc:	63c8                	ld	a0,128(a5)
    80001bfe:	b7f5                	j	80001bea <argraw+0x2c>
    return p->trapframe->a3;
    80001c00:	6d3c                	ld	a5,88(a0)
    80001c02:	67c8                	ld	a0,136(a5)
    80001c04:	b7dd                	j	80001bea <argraw+0x2c>
    return p->trapframe->a4;
    80001c06:	6d3c                	ld	a5,88(a0)
    80001c08:	6bc8                	ld	a0,144(a5)
    80001c0a:	b7c5                	j	80001bea <argraw+0x2c>
    return p->trapframe->a5;
    80001c0c:	6d3c                	ld	a5,88(a0)
    80001c0e:	6fc8                	ld	a0,152(a5)
    80001c10:	bfe9                	j	80001bea <argraw+0x2c>
  panic("argraw");
    80001c12:	00005517          	auipc	a0,0x5
    80001c16:	79650513          	addi	a0,a0,1942 # 800073a8 <etext+0x3a8>
    80001c1a:	0a9030ef          	jal	800054c2 <panic>

0000000080001c1e <fetchaddr>:
{
    80001c1e:	1101                	addi	sp,sp,-32
    80001c20:	ec06                	sd	ra,24(sp)
    80001c22:	e822                	sd	s0,16(sp)
    80001c24:	e426                	sd	s1,8(sp)
    80001c26:	e04a                	sd	s2,0(sp)
    80001c28:	1000                	addi	s0,sp,32
    80001c2a:	84aa                	mv	s1,a0
    80001c2c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c2e:	97aff0ef          	jal	80000da8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c32:	653c                	ld	a5,72(a0)
    80001c34:	02f4f663          	bgeu	s1,a5,80001c60 <fetchaddr+0x42>
    80001c38:	00848713          	addi	a4,s1,8
    80001c3c:	02e7e463          	bltu	a5,a4,80001c64 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c40:	46a1                	li	a3,8
    80001c42:	8626                	mv	a2,s1
    80001c44:	85ca                	mv	a1,s2
    80001c46:	6928                	ld	a0,80(a0)
    80001c48:	ea9fe0ef          	jal	80000af0 <copyin>
    80001c4c:	00a03533          	snez	a0,a0
    80001c50:	40a00533          	neg	a0,a0
}
    80001c54:	60e2                	ld	ra,24(sp)
    80001c56:	6442                	ld	s0,16(sp)
    80001c58:	64a2                	ld	s1,8(sp)
    80001c5a:	6902                	ld	s2,0(sp)
    80001c5c:	6105                	addi	sp,sp,32
    80001c5e:	8082                	ret
    return -1;
    80001c60:	557d                	li	a0,-1
    80001c62:	bfcd                	j	80001c54 <fetchaddr+0x36>
    80001c64:	557d                	li	a0,-1
    80001c66:	b7fd                	j	80001c54 <fetchaddr+0x36>

0000000080001c68 <fetchstr>:
{
    80001c68:	7179                	addi	sp,sp,-48
    80001c6a:	f406                	sd	ra,40(sp)
    80001c6c:	f022                	sd	s0,32(sp)
    80001c6e:	ec26                	sd	s1,24(sp)
    80001c70:	e84a                	sd	s2,16(sp)
    80001c72:	e44e                	sd	s3,8(sp)
    80001c74:	1800                	addi	s0,sp,48
    80001c76:	892a                	mv	s2,a0
    80001c78:	84ae                	mv	s1,a1
    80001c7a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c7c:	92cff0ef          	jal	80000da8 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c80:	86ce                	mv	a3,s3
    80001c82:	864a                	mv	a2,s2
    80001c84:	85a6                	mv	a1,s1
    80001c86:	6928                	ld	a0,80(a0)
    80001c88:	eeffe0ef          	jal	80000b76 <copyinstr>
    80001c8c:	00054c63          	bltz	a0,80001ca4 <fetchstr+0x3c>
  return strlen(buf);
    80001c90:	8526                	mv	a0,s1
    80001c92:	e6efe0ef          	jal	80000300 <strlen>
}
    80001c96:	70a2                	ld	ra,40(sp)
    80001c98:	7402                	ld	s0,32(sp)
    80001c9a:	64e2                	ld	s1,24(sp)
    80001c9c:	6942                	ld	s2,16(sp)
    80001c9e:	69a2                	ld	s3,8(sp)
    80001ca0:	6145                	addi	sp,sp,48
    80001ca2:	8082                	ret
    return -1;
    80001ca4:	557d                	li	a0,-1
    80001ca6:	bfc5                	j	80001c96 <fetchstr+0x2e>

0000000080001ca8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001ca8:	1101                	addi	sp,sp,-32
    80001caa:	ec06                	sd	ra,24(sp)
    80001cac:	e822                	sd	s0,16(sp)
    80001cae:	e426                	sd	s1,8(sp)
    80001cb0:	1000                	addi	s0,sp,32
    80001cb2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cb4:	f0bff0ef          	jal	80001bbe <argraw>
    80001cb8:	c088                	sw	a0,0(s1)
}
    80001cba:	60e2                	ld	ra,24(sp)
    80001cbc:	6442                	ld	s0,16(sp)
    80001cbe:	64a2                	ld	s1,8(sp)
    80001cc0:	6105                	addi	sp,sp,32
    80001cc2:	8082                	ret

0000000080001cc4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cc4:	1101                	addi	sp,sp,-32
    80001cc6:	ec06                	sd	ra,24(sp)
    80001cc8:	e822                	sd	s0,16(sp)
    80001cca:	e426                	sd	s1,8(sp)
    80001ccc:	1000                	addi	s0,sp,32
    80001cce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cd0:	eefff0ef          	jal	80001bbe <argraw>
    80001cd4:	e088                	sd	a0,0(s1)
}
    80001cd6:	60e2                	ld	ra,24(sp)
    80001cd8:	6442                	ld	s0,16(sp)
    80001cda:	64a2                	ld	s1,8(sp)
    80001cdc:	6105                	addi	sp,sp,32
    80001cde:	8082                	ret

0000000080001ce0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001ce0:	7179                	addi	sp,sp,-48
    80001ce2:	f406                	sd	ra,40(sp)
    80001ce4:	f022                	sd	s0,32(sp)
    80001ce6:	ec26                	sd	s1,24(sp)
    80001ce8:	e84a                	sd	s2,16(sp)
    80001cea:	1800                	addi	s0,sp,48
    80001cec:	84ae                	mv	s1,a1
    80001cee:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cf0:	fd840593          	addi	a1,s0,-40
    80001cf4:	fd1ff0ef          	jal	80001cc4 <argaddr>
  return fetchstr(addr, buf, max);
    80001cf8:	864a                	mv	a2,s2
    80001cfa:	85a6                	mv	a1,s1
    80001cfc:	fd843503          	ld	a0,-40(s0)
    80001d00:	f69ff0ef          	jal	80001c68 <fetchstr>
}
    80001d04:	70a2                	ld	ra,40(sp)
    80001d06:	7402                	ld	s0,32(sp)
    80001d08:	64e2                	ld	s1,24(sp)
    80001d0a:	6942                	ld	s2,16(sp)
    80001d0c:	6145                	addi	sp,sp,48
    80001d0e:	8082                	ret

0000000080001d10 <syscall>:
[SYS_sysinfo] sys_sysinfo,
};

void
syscall(void)
{
    80001d10:	1101                	addi	sp,sp,-32
    80001d12:	ec06                	sd	ra,24(sp)
    80001d14:	e822                	sd	s0,16(sp)
    80001d16:	e426                	sd	s1,8(sp)
    80001d18:	e04a                	sd	s2,0(sp)
    80001d1a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001d1c:	88cff0ef          	jal	80000da8 <myproc>
    80001d20:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d22:	05853903          	ld	s2,88(a0)
    80001d26:	0a893783          	ld	a5,168(s2)
    80001d2a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d2e:	37fd                	addiw	a5,a5,-1
    80001d30:	4755                	li	a4,21
    80001d32:	00f76f63          	bltu	a4,a5,80001d50 <syscall+0x40>
    80001d36:	00369713          	slli	a4,a3,0x3
    80001d3a:	00006797          	auipc	a5,0x6
    80001d3e:	a7e78793          	addi	a5,a5,-1410 # 800077b8 <syscalls>
    80001d42:	97ba                	add	a5,a5,a4
    80001d44:	639c                	ld	a5,0(a5)
    80001d46:	c789                	beqz	a5,80001d50 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d48:	9782                	jalr	a5
    80001d4a:	06a93823          	sd	a0,112(s2)
    80001d4e:	a829                	j	80001d68 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d50:	15848613          	addi	a2,s1,344
    80001d54:	588c                	lw	a1,48(s1)
    80001d56:	00005517          	auipc	a0,0x5
    80001d5a:	65a50513          	addi	a0,a0,1626 # 800073b0 <etext+0x3b0>
    80001d5e:	492030ef          	jal	800051f0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d62:	6cbc                	ld	a5,88(s1)
    80001d64:	577d                	li	a4,-1
    80001d66:	fbb8                	sd	a4,112(a5)
  }
}
    80001d68:	60e2                	ld	ra,24(sp)
    80001d6a:	6442                	ld	s0,16(sp)
    80001d6c:	64a2                	ld	s1,8(sp)
    80001d6e:	6902                	ld	s2,0(sp)
    80001d70:	6105                	addi	sp,sp,32
    80001d72:	8082                	ret

0000000080001d74 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80001d74:	1101                	addi	sp,sp,-32
    80001d76:	ec06                	sd	ra,24(sp)
    80001d78:	e822                	sd	s0,16(sp)
    80001d7a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d7c:	fec40593          	addi	a1,s0,-20
    80001d80:	4501                	li	a0,0
    80001d82:	f27ff0ef          	jal	80001ca8 <argint>
  exit(n);
    80001d86:	fec42503          	lw	a0,-20(s0)
    80001d8a:	ef8ff0ef          	jal	80001482 <exit>
  return 0;  // not reached
}
    80001d8e:	4501                	li	a0,0
    80001d90:	60e2                	ld	ra,24(sp)
    80001d92:	6442                	ld	s0,16(sp)
    80001d94:	6105                	addi	sp,sp,32
    80001d96:	8082                	ret

0000000080001d98 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d98:	1141                	addi	sp,sp,-16
    80001d9a:	e406                	sd	ra,8(sp)
    80001d9c:	e022                	sd	s0,0(sp)
    80001d9e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001da0:	808ff0ef          	jal	80000da8 <myproc>
}
    80001da4:	5908                	lw	a0,48(a0)
    80001da6:	60a2                	ld	ra,8(sp)
    80001da8:	6402                	ld	s0,0(sp)
    80001daa:	0141                	addi	sp,sp,16
    80001dac:	8082                	ret

0000000080001dae <sys_fork>:

uint64
sys_fork(void)
{
    80001dae:	1141                	addi	sp,sp,-16
    80001db0:	e406                	sd	ra,8(sp)
    80001db2:	e022                	sd	s0,0(sp)
    80001db4:	0800                	addi	s0,sp,16
  return fork();
    80001db6:	b18ff0ef          	jal	800010ce <fork>
}
    80001dba:	60a2                	ld	ra,8(sp)
    80001dbc:	6402                	ld	s0,0(sp)
    80001dbe:	0141                	addi	sp,sp,16
    80001dc0:	8082                	ret

0000000080001dc2 <sys_wait>:

uint64
sys_wait(void)
{
    80001dc2:	1101                	addi	sp,sp,-32
    80001dc4:	ec06                	sd	ra,24(sp)
    80001dc6:	e822                	sd	s0,16(sp)
    80001dc8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001dca:	fe840593          	addi	a1,s0,-24
    80001dce:	4501                	li	a0,0
    80001dd0:	ef5ff0ef          	jal	80001cc4 <argaddr>
  return wait(p);
    80001dd4:	fe843503          	ld	a0,-24(s0)
    80001dd8:	801ff0ef          	jal	800015d8 <wait>
}
    80001ddc:	60e2                	ld	ra,24(sp)
    80001dde:	6442                	ld	s0,16(sp)
    80001de0:	6105                	addi	sp,sp,32
    80001de2:	8082                	ret

0000000080001de4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001de4:	7179                	addi	sp,sp,-48
    80001de6:	f406                	sd	ra,40(sp)
    80001de8:	f022                	sd	s0,32(sp)
    80001dea:	ec26                	sd	s1,24(sp)
    80001dec:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001dee:	fdc40593          	addi	a1,s0,-36
    80001df2:	4501                	li	a0,0
    80001df4:	eb5ff0ef          	jal	80001ca8 <argint>
  addr = myproc()->sz;
    80001df8:	fb1fe0ef          	jal	80000da8 <myproc>
    80001dfc:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001dfe:	fdc42503          	lw	a0,-36(s0)
    80001e02:	a7cff0ef          	jal	8000107e <growproc>
    80001e06:	00054863          	bltz	a0,80001e16 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e0a:	8526                	mv	a0,s1
    80001e0c:	70a2                	ld	ra,40(sp)
    80001e0e:	7402                	ld	s0,32(sp)
    80001e10:	64e2                	ld	s1,24(sp)
    80001e12:	6145                	addi	sp,sp,48
    80001e14:	8082                	ret
    return -1;
    80001e16:	54fd                	li	s1,-1
    80001e18:	bfcd                	j	80001e0a <sys_sbrk+0x26>

0000000080001e1a <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e1a:	7139                	addi	sp,sp,-64
    80001e1c:	fc06                	sd	ra,56(sp)
    80001e1e:	f822                	sd	s0,48(sp)
    80001e20:	f04a                	sd	s2,32(sp)
    80001e22:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e24:	fcc40593          	addi	a1,s0,-52
    80001e28:	4501                	li	a0,0
    80001e2a:	e7fff0ef          	jal	80001ca8 <argint>
  if(n < 0)
    80001e2e:	fcc42783          	lw	a5,-52(s0)
    80001e32:	0607c763          	bltz	a5,80001ea0 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e36:	0000e517          	auipc	a0,0xe
    80001e3a:	2ca50513          	addi	a0,a0,714 # 80010100 <tickslock>
    80001e3e:	1b3030ef          	jal	800057f0 <acquire>
  ticks0 = ticks;
    80001e42:	00008917          	auipc	s2,0x8
    80001e46:	45692903          	lw	s2,1110(s2) # 8000a298 <ticks>
  while(ticks - ticks0 < n){
    80001e4a:	fcc42783          	lw	a5,-52(s0)
    80001e4e:	cf8d                	beqz	a5,80001e88 <sys_sleep+0x6e>
    80001e50:	f426                	sd	s1,40(sp)
    80001e52:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e54:	0000e997          	auipc	s3,0xe
    80001e58:	2ac98993          	addi	s3,s3,684 # 80010100 <tickslock>
    80001e5c:	00008497          	auipc	s1,0x8
    80001e60:	43c48493          	addi	s1,s1,1084 # 8000a298 <ticks>
    if(killed(myproc())){
    80001e64:	f45fe0ef          	jal	80000da8 <myproc>
    80001e68:	f46ff0ef          	jal	800015ae <killed>
    80001e6c:	ed0d                	bnez	a0,80001ea6 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001e6e:	85ce                	mv	a1,s3
    80001e70:	8526                	mv	a0,s1
    80001e72:	d04ff0ef          	jal	80001376 <sleep>
  while(ticks - ticks0 < n){
    80001e76:	409c                	lw	a5,0(s1)
    80001e78:	412787bb          	subw	a5,a5,s2
    80001e7c:	fcc42703          	lw	a4,-52(s0)
    80001e80:	fee7e2e3          	bltu	a5,a4,80001e64 <sys_sleep+0x4a>
    80001e84:	74a2                	ld	s1,40(sp)
    80001e86:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001e88:	0000e517          	auipc	a0,0xe
    80001e8c:	27850513          	addi	a0,a0,632 # 80010100 <tickslock>
    80001e90:	1f9030ef          	jal	80005888 <release>
  return 0;
    80001e94:	4501                	li	a0,0
}
    80001e96:	70e2                	ld	ra,56(sp)
    80001e98:	7442                	ld	s0,48(sp)
    80001e9a:	7902                	ld	s2,32(sp)
    80001e9c:	6121                	addi	sp,sp,64
    80001e9e:	8082                	ret
    n = 0;
    80001ea0:	fc042623          	sw	zero,-52(s0)
    80001ea4:	bf49                	j	80001e36 <sys_sleep+0x1c>
      release(&tickslock);
    80001ea6:	0000e517          	auipc	a0,0xe
    80001eaa:	25a50513          	addi	a0,a0,602 # 80010100 <tickslock>
    80001eae:	1db030ef          	jal	80005888 <release>
      return -1;
    80001eb2:	557d                	li	a0,-1
    80001eb4:	74a2                	ld	s1,40(sp)
    80001eb6:	69e2                	ld	s3,24(sp)
    80001eb8:	bff9                	j	80001e96 <sys_sleep+0x7c>

0000000080001eba <sys_kill>:

uint64
sys_kill(void)
{
    80001eba:	1101                	addi	sp,sp,-32
    80001ebc:	ec06                	sd	ra,24(sp)
    80001ebe:	e822                	sd	s0,16(sp)
    80001ec0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ec2:	fec40593          	addi	a1,s0,-20
    80001ec6:	4501                	li	a0,0
    80001ec8:	de1ff0ef          	jal	80001ca8 <argint>
  return kill(pid);
    80001ecc:	fec42503          	lw	a0,-20(s0)
    80001ed0:	e54ff0ef          	jal	80001524 <kill>
}
    80001ed4:	60e2                	ld	ra,24(sp)
    80001ed6:	6442                	ld	s0,16(sp)
    80001ed8:	6105                	addi	sp,sp,32
    80001eda:	8082                	ret

0000000080001edc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001edc:	1101                	addi	sp,sp,-32
    80001ede:	ec06                	sd	ra,24(sp)
    80001ee0:	e822                	sd	s0,16(sp)
    80001ee2:	e426                	sd	s1,8(sp)
    80001ee4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001ee6:	0000e517          	auipc	a0,0xe
    80001eea:	21a50513          	addi	a0,a0,538 # 80010100 <tickslock>
    80001eee:	103030ef          	jal	800057f0 <acquire>
  xticks = ticks;
    80001ef2:	00008497          	auipc	s1,0x8
    80001ef6:	3a64a483          	lw	s1,934(s1) # 8000a298 <ticks>
  release(&tickslock);
    80001efa:	0000e517          	auipc	a0,0xe
    80001efe:	20650513          	addi	a0,a0,518 # 80010100 <tickslock>
    80001f02:	187030ef          	jal	80005888 <release>
  return xticks;
}
    80001f06:	02049513          	slli	a0,s1,0x20
    80001f0a:	9101                	srli	a0,a0,0x20
    80001f0c:	60e2                	ld	ra,24(sp)
    80001f0e:	6442                	ld	s0,16(sp)
    80001f10:	64a2                	ld	s1,8(sp)
    80001f12:	6105                	addi	sp,sp,32
    80001f14:	8082                	ret

0000000080001f16 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80001f16:	7179                	addi	sp,sp,-48
    80001f18:	f406                	sd	ra,40(sp)
    80001f1a:	f022                	sd	s0,32(sp)
    80001f1c:	1800                	addi	s0,sp,48
  struct sysinfo info;
  uint64 addr;

  argaddr(0, &addr);
    80001f1e:	fd840593          	addi	a1,s0,-40
    80001f22:	4501                	li	a0,0
    80001f24:	da1ff0ef          	jal	80001cc4 <argaddr>

  info.freemem = getfreemem();
    80001f28:	a26fe0ef          	jal	8000014e <getfreemem>
    80001f2c:	fea43023          	sd	a0,-32(s0)
  info.nproc = getnproc();
    80001f30:	8dbff0ef          	jal	8000180a <getnproc>
    80001f34:	fea43423          	sd	a0,-24(s0)

  if(copyout(myproc()->pagetable, addr, (char*)&info, sizeof(info)) < 0){
    80001f38:	e71fe0ef          	jal	80000da8 <myproc>
    80001f3c:	46c1                	li	a3,16
    80001f3e:	fe040613          	addi	a2,s0,-32
    80001f42:	fd843583          	ld	a1,-40(s0)
    80001f46:	6928                	ld	a0,80(a0)
    80001f48:	ad3fe0ef          	jal	80000a1a <copyout>
    return -1;
  }

  return 0;
    80001f4c:	957d                	srai	a0,a0,0x3f
    80001f4e:	70a2                	ld	ra,40(sp)
    80001f50:	7402                	ld	s0,32(sp)
    80001f52:	6145                	addi	sp,sp,48
    80001f54:	8082                	ret

0000000080001f56 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f56:	7179                	addi	sp,sp,-48
    80001f58:	f406                	sd	ra,40(sp)
    80001f5a:	f022                	sd	s0,32(sp)
    80001f5c:	ec26                	sd	s1,24(sp)
    80001f5e:	e84a                	sd	s2,16(sp)
    80001f60:	e44e                	sd	s3,8(sp)
    80001f62:	e052                	sd	s4,0(sp)
    80001f64:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f66:	00005597          	auipc	a1,0x5
    80001f6a:	46a58593          	addi	a1,a1,1130 # 800073d0 <etext+0x3d0>
    80001f6e:	0000e517          	auipc	a0,0xe
    80001f72:	1aa50513          	addi	a0,a0,426 # 80010118 <bcache>
    80001f76:	7fa030ef          	jal	80005770 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001f7a:	00016797          	auipc	a5,0x16
    80001f7e:	19e78793          	addi	a5,a5,414 # 80018118 <bcache+0x8000>
    80001f82:	00016717          	auipc	a4,0x16
    80001f86:	3fe70713          	addi	a4,a4,1022 # 80018380 <bcache+0x8268>
    80001f8a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001f8e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f92:	0000e497          	auipc	s1,0xe
    80001f96:	19e48493          	addi	s1,s1,414 # 80010130 <bcache+0x18>
    b->next = bcache.head.next;
    80001f9a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001f9c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001f9e:	00005a17          	auipc	s4,0x5
    80001fa2:	43aa0a13          	addi	s4,s4,1082 # 800073d8 <etext+0x3d8>
    b->next = bcache.head.next;
    80001fa6:	2b893783          	ld	a5,696(s2)
    80001faa:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001fac:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001fb0:	85d2                	mv	a1,s4
    80001fb2:	01048513          	addi	a0,s1,16
    80001fb6:	248010ef          	jal	800031fe <initsleeplock>
    bcache.head.next->prev = b;
    80001fba:	2b893783          	ld	a5,696(s2)
    80001fbe:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001fc0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fc4:	45848493          	addi	s1,s1,1112
    80001fc8:	fd349fe3          	bne	s1,s3,80001fa6 <binit+0x50>
  }
}
    80001fcc:	70a2                	ld	ra,40(sp)
    80001fce:	7402                	ld	s0,32(sp)
    80001fd0:	64e2                	ld	s1,24(sp)
    80001fd2:	6942                	ld	s2,16(sp)
    80001fd4:	69a2                	ld	s3,8(sp)
    80001fd6:	6a02                	ld	s4,0(sp)
    80001fd8:	6145                	addi	sp,sp,48
    80001fda:	8082                	ret

0000000080001fdc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001fdc:	7179                	addi	sp,sp,-48
    80001fde:	f406                	sd	ra,40(sp)
    80001fe0:	f022                	sd	s0,32(sp)
    80001fe2:	ec26                	sd	s1,24(sp)
    80001fe4:	e84a                	sd	s2,16(sp)
    80001fe6:	e44e                	sd	s3,8(sp)
    80001fe8:	1800                	addi	s0,sp,48
    80001fea:	892a                	mv	s2,a0
    80001fec:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001fee:	0000e517          	auipc	a0,0xe
    80001ff2:	12a50513          	addi	a0,a0,298 # 80010118 <bcache>
    80001ff6:	7fa030ef          	jal	800057f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001ffa:	00016497          	auipc	s1,0x16
    80001ffe:	3d64b483          	ld	s1,982(s1) # 800183d0 <bcache+0x82b8>
    80002002:	00016797          	auipc	a5,0x16
    80002006:	37e78793          	addi	a5,a5,894 # 80018380 <bcache+0x8268>
    8000200a:	02f48b63          	beq	s1,a5,80002040 <bread+0x64>
    8000200e:	873e                	mv	a4,a5
    80002010:	a021                	j	80002018 <bread+0x3c>
    80002012:	68a4                	ld	s1,80(s1)
    80002014:	02e48663          	beq	s1,a4,80002040 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002018:	449c                	lw	a5,8(s1)
    8000201a:	ff279ce3          	bne	a5,s2,80002012 <bread+0x36>
    8000201e:	44dc                	lw	a5,12(s1)
    80002020:	ff3799e3          	bne	a5,s3,80002012 <bread+0x36>
      b->refcnt++;
    80002024:	40bc                	lw	a5,64(s1)
    80002026:	2785                	addiw	a5,a5,1
    80002028:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000202a:	0000e517          	auipc	a0,0xe
    8000202e:	0ee50513          	addi	a0,a0,238 # 80010118 <bcache>
    80002032:	057030ef          	jal	80005888 <release>
      acquiresleep(&b->lock);
    80002036:	01048513          	addi	a0,s1,16
    8000203a:	1fa010ef          	jal	80003234 <acquiresleep>
      return b;
    8000203e:	a889                	j	80002090 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002040:	00016497          	auipc	s1,0x16
    80002044:	3884b483          	ld	s1,904(s1) # 800183c8 <bcache+0x82b0>
    80002048:	00016797          	auipc	a5,0x16
    8000204c:	33878793          	addi	a5,a5,824 # 80018380 <bcache+0x8268>
    80002050:	00f48863          	beq	s1,a5,80002060 <bread+0x84>
    80002054:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002056:	40bc                	lw	a5,64(s1)
    80002058:	cb91                	beqz	a5,8000206c <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000205a:	64a4                	ld	s1,72(s1)
    8000205c:	fee49de3          	bne	s1,a4,80002056 <bread+0x7a>
  panic("bget: no buffers");
    80002060:	00005517          	auipc	a0,0x5
    80002064:	38050513          	addi	a0,a0,896 # 800073e0 <etext+0x3e0>
    80002068:	45a030ef          	jal	800054c2 <panic>
      b->dev = dev;
    8000206c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002070:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002074:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002078:	4785                	li	a5,1
    8000207a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000207c:	0000e517          	auipc	a0,0xe
    80002080:	09c50513          	addi	a0,a0,156 # 80010118 <bcache>
    80002084:	005030ef          	jal	80005888 <release>
      acquiresleep(&b->lock);
    80002088:	01048513          	addi	a0,s1,16
    8000208c:	1a8010ef          	jal	80003234 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002090:	409c                	lw	a5,0(s1)
    80002092:	cb89                	beqz	a5,800020a4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002094:	8526                	mv	a0,s1
    80002096:	70a2                	ld	ra,40(sp)
    80002098:	7402                	ld	s0,32(sp)
    8000209a:	64e2                	ld	s1,24(sp)
    8000209c:	6942                	ld	s2,16(sp)
    8000209e:	69a2                	ld	s3,8(sp)
    800020a0:	6145                	addi	sp,sp,48
    800020a2:	8082                	ret
    virtio_disk_rw(b, 0);
    800020a4:	4581                	li	a1,0
    800020a6:	8526                	mv	a0,s1
    800020a8:	1e9020ef          	jal	80004a90 <virtio_disk_rw>
    b->valid = 1;
    800020ac:	4785                	li	a5,1
    800020ae:	c09c                	sw	a5,0(s1)
  return b;
    800020b0:	b7d5                	j	80002094 <bread+0xb8>

00000000800020b2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800020b2:	1101                	addi	sp,sp,-32
    800020b4:	ec06                	sd	ra,24(sp)
    800020b6:	e822                	sd	s0,16(sp)
    800020b8:	e426                	sd	s1,8(sp)
    800020ba:	1000                	addi	s0,sp,32
    800020bc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020be:	0541                	addi	a0,a0,16
    800020c0:	1f2010ef          	jal	800032b2 <holdingsleep>
    800020c4:	c911                	beqz	a0,800020d8 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800020c6:	4585                	li	a1,1
    800020c8:	8526                	mv	a0,s1
    800020ca:	1c7020ef          	jal	80004a90 <virtio_disk_rw>
}
    800020ce:	60e2                	ld	ra,24(sp)
    800020d0:	6442                	ld	s0,16(sp)
    800020d2:	64a2                	ld	s1,8(sp)
    800020d4:	6105                	addi	sp,sp,32
    800020d6:	8082                	ret
    panic("bwrite");
    800020d8:	00005517          	auipc	a0,0x5
    800020dc:	32050513          	addi	a0,a0,800 # 800073f8 <etext+0x3f8>
    800020e0:	3e2030ef          	jal	800054c2 <panic>

00000000800020e4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800020e4:	1101                	addi	sp,sp,-32
    800020e6:	ec06                	sd	ra,24(sp)
    800020e8:	e822                	sd	s0,16(sp)
    800020ea:	e426                	sd	s1,8(sp)
    800020ec:	e04a                	sd	s2,0(sp)
    800020ee:	1000                	addi	s0,sp,32
    800020f0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020f2:	01050913          	addi	s2,a0,16
    800020f6:	854a                	mv	a0,s2
    800020f8:	1ba010ef          	jal	800032b2 <holdingsleep>
    800020fc:	c135                	beqz	a0,80002160 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800020fe:	854a                	mv	a0,s2
    80002100:	17a010ef          	jal	8000327a <releasesleep>

  acquire(&bcache.lock);
    80002104:	0000e517          	auipc	a0,0xe
    80002108:	01450513          	addi	a0,a0,20 # 80010118 <bcache>
    8000210c:	6e4030ef          	jal	800057f0 <acquire>
  b->refcnt--;
    80002110:	40bc                	lw	a5,64(s1)
    80002112:	37fd                	addiw	a5,a5,-1
    80002114:	0007871b          	sext.w	a4,a5
    80002118:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000211a:	e71d                	bnez	a4,80002148 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000211c:	68b8                	ld	a4,80(s1)
    8000211e:	64bc                	ld	a5,72(s1)
    80002120:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002122:	68b8                	ld	a4,80(s1)
    80002124:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002126:	00016797          	auipc	a5,0x16
    8000212a:	ff278793          	addi	a5,a5,-14 # 80018118 <bcache+0x8000>
    8000212e:	2b87b703          	ld	a4,696(a5)
    80002132:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002134:	00016717          	auipc	a4,0x16
    80002138:	24c70713          	addi	a4,a4,588 # 80018380 <bcache+0x8268>
    8000213c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000213e:	2b87b703          	ld	a4,696(a5)
    80002142:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002144:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002148:	0000e517          	auipc	a0,0xe
    8000214c:	fd050513          	addi	a0,a0,-48 # 80010118 <bcache>
    80002150:	738030ef          	jal	80005888 <release>
}
    80002154:	60e2                	ld	ra,24(sp)
    80002156:	6442                	ld	s0,16(sp)
    80002158:	64a2                	ld	s1,8(sp)
    8000215a:	6902                	ld	s2,0(sp)
    8000215c:	6105                	addi	sp,sp,32
    8000215e:	8082                	ret
    panic("brelse");
    80002160:	00005517          	auipc	a0,0x5
    80002164:	2a050513          	addi	a0,a0,672 # 80007400 <etext+0x400>
    80002168:	35a030ef          	jal	800054c2 <panic>

000000008000216c <bpin>:

void
bpin(struct buf *b) {
    8000216c:	1101                	addi	sp,sp,-32
    8000216e:	ec06                	sd	ra,24(sp)
    80002170:	e822                	sd	s0,16(sp)
    80002172:	e426                	sd	s1,8(sp)
    80002174:	1000                	addi	s0,sp,32
    80002176:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002178:	0000e517          	auipc	a0,0xe
    8000217c:	fa050513          	addi	a0,a0,-96 # 80010118 <bcache>
    80002180:	670030ef          	jal	800057f0 <acquire>
  b->refcnt++;
    80002184:	40bc                	lw	a5,64(s1)
    80002186:	2785                	addiw	a5,a5,1
    80002188:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000218a:	0000e517          	auipc	a0,0xe
    8000218e:	f8e50513          	addi	a0,a0,-114 # 80010118 <bcache>
    80002192:	6f6030ef          	jal	80005888 <release>
}
    80002196:	60e2                	ld	ra,24(sp)
    80002198:	6442                	ld	s0,16(sp)
    8000219a:	64a2                	ld	s1,8(sp)
    8000219c:	6105                	addi	sp,sp,32
    8000219e:	8082                	ret

00000000800021a0 <bunpin>:

void
bunpin(struct buf *b) {
    800021a0:	1101                	addi	sp,sp,-32
    800021a2:	ec06                	sd	ra,24(sp)
    800021a4:	e822                	sd	s0,16(sp)
    800021a6:	e426                	sd	s1,8(sp)
    800021a8:	1000                	addi	s0,sp,32
    800021aa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021ac:	0000e517          	auipc	a0,0xe
    800021b0:	f6c50513          	addi	a0,a0,-148 # 80010118 <bcache>
    800021b4:	63c030ef          	jal	800057f0 <acquire>
  b->refcnt--;
    800021b8:	40bc                	lw	a5,64(s1)
    800021ba:	37fd                	addiw	a5,a5,-1
    800021bc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021be:	0000e517          	auipc	a0,0xe
    800021c2:	f5a50513          	addi	a0,a0,-166 # 80010118 <bcache>
    800021c6:	6c2030ef          	jal	80005888 <release>
}
    800021ca:	60e2                	ld	ra,24(sp)
    800021cc:	6442                	ld	s0,16(sp)
    800021ce:	64a2                	ld	s1,8(sp)
    800021d0:	6105                	addi	sp,sp,32
    800021d2:	8082                	ret

00000000800021d4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800021d4:	1101                	addi	sp,sp,-32
    800021d6:	ec06                	sd	ra,24(sp)
    800021d8:	e822                	sd	s0,16(sp)
    800021da:	e426                	sd	s1,8(sp)
    800021dc:	e04a                	sd	s2,0(sp)
    800021de:	1000                	addi	s0,sp,32
    800021e0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800021e2:	00d5d59b          	srliw	a1,a1,0xd
    800021e6:	00016797          	auipc	a5,0x16
    800021ea:	60e7a783          	lw	a5,1550(a5) # 800187f4 <sb+0x1c>
    800021ee:	9dbd                	addw	a1,a1,a5
    800021f0:	dedff0ef          	jal	80001fdc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800021f4:	0074f713          	andi	a4,s1,7
    800021f8:	4785                	li	a5,1
    800021fa:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800021fe:	14ce                	slli	s1,s1,0x33
    80002200:	90d9                	srli	s1,s1,0x36
    80002202:	00950733          	add	a4,a0,s1
    80002206:	05874703          	lbu	a4,88(a4)
    8000220a:	00e7f6b3          	and	a3,a5,a4
    8000220e:	c29d                	beqz	a3,80002234 <bfree+0x60>
    80002210:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002212:	94aa                	add	s1,s1,a0
    80002214:	fff7c793          	not	a5,a5
    80002218:	8f7d                	and	a4,a4,a5
    8000221a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000221e:	711000ef          	jal	8000312e <log_write>
  brelse(bp);
    80002222:	854a                	mv	a0,s2
    80002224:	ec1ff0ef          	jal	800020e4 <brelse>
}
    80002228:	60e2                	ld	ra,24(sp)
    8000222a:	6442                	ld	s0,16(sp)
    8000222c:	64a2                	ld	s1,8(sp)
    8000222e:	6902                	ld	s2,0(sp)
    80002230:	6105                	addi	sp,sp,32
    80002232:	8082                	ret
    panic("freeing free block");
    80002234:	00005517          	auipc	a0,0x5
    80002238:	1d450513          	addi	a0,a0,468 # 80007408 <etext+0x408>
    8000223c:	286030ef          	jal	800054c2 <panic>

0000000080002240 <balloc>:
{
    80002240:	711d                	addi	sp,sp,-96
    80002242:	ec86                	sd	ra,88(sp)
    80002244:	e8a2                	sd	s0,80(sp)
    80002246:	e4a6                	sd	s1,72(sp)
    80002248:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000224a:	00016797          	auipc	a5,0x16
    8000224e:	5927a783          	lw	a5,1426(a5) # 800187dc <sb+0x4>
    80002252:	0e078f63          	beqz	a5,80002350 <balloc+0x110>
    80002256:	e0ca                	sd	s2,64(sp)
    80002258:	fc4e                	sd	s3,56(sp)
    8000225a:	f852                	sd	s4,48(sp)
    8000225c:	f456                	sd	s5,40(sp)
    8000225e:	f05a                	sd	s6,32(sp)
    80002260:	ec5e                	sd	s7,24(sp)
    80002262:	e862                	sd	s8,16(sp)
    80002264:	e466                	sd	s9,8(sp)
    80002266:	8baa                	mv	s7,a0
    80002268:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000226a:	00016b17          	auipc	s6,0x16
    8000226e:	56eb0b13          	addi	s6,s6,1390 # 800187d8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002272:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002274:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002276:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002278:	6c89                	lui	s9,0x2
    8000227a:	a0b5                	j	800022e6 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000227c:	97ca                	add	a5,a5,s2
    8000227e:	8e55                	or	a2,a2,a3
    80002280:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002284:	854a                	mv	a0,s2
    80002286:	6a9000ef          	jal	8000312e <log_write>
        brelse(bp);
    8000228a:	854a                	mv	a0,s2
    8000228c:	e59ff0ef          	jal	800020e4 <brelse>
  bp = bread(dev, bno);
    80002290:	85a6                	mv	a1,s1
    80002292:	855e                	mv	a0,s7
    80002294:	d49ff0ef          	jal	80001fdc <bread>
    80002298:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000229a:	40000613          	li	a2,1024
    8000229e:	4581                	li	a1,0
    800022a0:	05850513          	addi	a0,a0,88
    800022a4:	eedfd0ef          	jal	80000190 <memset>
  log_write(bp);
    800022a8:	854a                	mv	a0,s2
    800022aa:	685000ef          	jal	8000312e <log_write>
  brelse(bp);
    800022ae:	854a                	mv	a0,s2
    800022b0:	e35ff0ef          	jal	800020e4 <brelse>
}
    800022b4:	6906                	ld	s2,64(sp)
    800022b6:	79e2                	ld	s3,56(sp)
    800022b8:	7a42                	ld	s4,48(sp)
    800022ba:	7aa2                	ld	s5,40(sp)
    800022bc:	7b02                	ld	s6,32(sp)
    800022be:	6be2                	ld	s7,24(sp)
    800022c0:	6c42                	ld	s8,16(sp)
    800022c2:	6ca2                	ld	s9,8(sp)
}
    800022c4:	8526                	mv	a0,s1
    800022c6:	60e6                	ld	ra,88(sp)
    800022c8:	6446                	ld	s0,80(sp)
    800022ca:	64a6                	ld	s1,72(sp)
    800022cc:	6125                	addi	sp,sp,96
    800022ce:	8082                	ret
    brelse(bp);
    800022d0:	854a                	mv	a0,s2
    800022d2:	e13ff0ef          	jal	800020e4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800022d6:	015c87bb          	addw	a5,s9,s5
    800022da:	00078a9b          	sext.w	s5,a5
    800022de:	004b2703          	lw	a4,4(s6)
    800022e2:	04eaff63          	bgeu	s5,a4,80002340 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800022e6:	41fad79b          	sraiw	a5,s5,0x1f
    800022ea:	0137d79b          	srliw	a5,a5,0x13
    800022ee:	015787bb          	addw	a5,a5,s5
    800022f2:	40d7d79b          	sraiw	a5,a5,0xd
    800022f6:	01cb2583          	lw	a1,28(s6)
    800022fa:	9dbd                	addw	a1,a1,a5
    800022fc:	855e                	mv	a0,s7
    800022fe:	cdfff0ef          	jal	80001fdc <bread>
    80002302:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002304:	004b2503          	lw	a0,4(s6)
    80002308:	000a849b          	sext.w	s1,s5
    8000230c:	8762                	mv	a4,s8
    8000230e:	fca4f1e3          	bgeu	s1,a0,800022d0 <balloc+0x90>
      m = 1 << (bi % 8);
    80002312:	00777693          	andi	a3,a4,7
    80002316:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000231a:	41f7579b          	sraiw	a5,a4,0x1f
    8000231e:	01d7d79b          	srliw	a5,a5,0x1d
    80002322:	9fb9                	addw	a5,a5,a4
    80002324:	4037d79b          	sraiw	a5,a5,0x3
    80002328:	00f90633          	add	a2,s2,a5
    8000232c:	05864603          	lbu	a2,88(a2)
    80002330:	00c6f5b3          	and	a1,a3,a2
    80002334:	d5a1                	beqz	a1,8000227c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002336:	2705                	addiw	a4,a4,1
    80002338:	2485                	addiw	s1,s1,1
    8000233a:	fd471ae3          	bne	a4,s4,8000230e <balloc+0xce>
    8000233e:	bf49                	j	800022d0 <balloc+0x90>
    80002340:	6906                	ld	s2,64(sp)
    80002342:	79e2                	ld	s3,56(sp)
    80002344:	7a42                	ld	s4,48(sp)
    80002346:	7aa2                	ld	s5,40(sp)
    80002348:	7b02                	ld	s6,32(sp)
    8000234a:	6be2                	ld	s7,24(sp)
    8000234c:	6c42                	ld	s8,16(sp)
    8000234e:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002350:	00005517          	auipc	a0,0x5
    80002354:	0d050513          	addi	a0,a0,208 # 80007420 <etext+0x420>
    80002358:	699020ef          	jal	800051f0 <printf>
  return 0;
    8000235c:	4481                	li	s1,0
    8000235e:	b79d                	j	800022c4 <balloc+0x84>

0000000080002360 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002360:	7179                	addi	sp,sp,-48
    80002362:	f406                	sd	ra,40(sp)
    80002364:	f022                	sd	s0,32(sp)
    80002366:	ec26                	sd	s1,24(sp)
    80002368:	e84a                	sd	s2,16(sp)
    8000236a:	e44e                	sd	s3,8(sp)
    8000236c:	1800                	addi	s0,sp,48
    8000236e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002370:	47ad                	li	a5,11
    80002372:	02b7e663          	bltu	a5,a1,8000239e <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002376:	02059793          	slli	a5,a1,0x20
    8000237a:	01e7d593          	srli	a1,a5,0x1e
    8000237e:	00b504b3          	add	s1,a0,a1
    80002382:	0504a903          	lw	s2,80(s1)
    80002386:	06091a63          	bnez	s2,800023fa <bmap+0x9a>
      addr = balloc(ip->dev);
    8000238a:	4108                	lw	a0,0(a0)
    8000238c:	eb5ff0ef          	jal	80002240 <balloc>
    80002390:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002394:	06090363          	beqz	s2,800023fa <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002398:	0524a823          	sw	s2,80(s1)
    8000239c:	a8b9                	j	800023fa <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000239e:	ff45849b          	addiw	s1,a1,-12
    800023a2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800023a6:	0ff00793          	li	a5,255
    800023aa:	06e7ee63          	bltu	a5,a4,80002426 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800023ae:	08052903          	lw	s2,128(a0)
    800023b2:	00091d63          	bnez	s2,800023cc <bmap+0x6c>
      addr = balloc(ip->dev);
    800023b6:	4108                	lw	a0,0(a0)
    800023b8:	e89ff0ef          	jal	80002240 <balloc>
    800023bc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023c0:	02090d63          	beqz	s2,800023fa <bmap+0x9a>
    800023c4:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023c6:	0929a023          	sw	s2,128(s3)
    800023ca:	a011                	j	800023ce <bmap+0x6e>
    800023cc:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800023ce:	85ca                	mv	a1,s2
    800023d0:	0009a503          	lw	a0,0(s3)
    800023d4:	c09ff0ef          	jal	80001fdc <bread>
    800023d8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800023da:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800023de:	02049713          	slli	a4,s1,0x20
    800023e2:	01e75593          	srli	a1,a4,0x1e
    800023e6:	00b784b3          	add	s1,a5,a1
    800023ea:	0004a903          	lw	s2,0(s1)
    800023ee:	00090e63          	beqz	s2,8000240a <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800023f2:	8552                	mv	a0,s4
    800023f4:	cf1ff0ef          	jal	800020e4 <brelse>
    return addr;
    800023f8:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800023fa:	854a                	mv	a0,s2
    800023fc:	70a2                	ld	ra,40(sp)
    800023fe:	7402                	ld	s0,32(sp)
    80002400:	64e2                	ld	s1,24(sp)
    80002402:	6942                	ld	s2,16(sp)
    80002404:	69a2                	ld	s3,8(sp)
    80002406:	6145                	addi	sp,sp,48
    80002408:	8082                	ret
      addr = balloc(ip->dev);
    8000240a:	0009a503          	lw	a0,0(s3)
    8000240e:	e33ff0ef          	jal	80002240 <balloc>
    80002412:	0005091b          	sext.w	s2,a0
      if(addr){
    80002416:	fc090ee3          	beqz	s2,800023f2 <bmap+0x92>
        a[bn] = addr;
    8000241a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000241e:	8552                	mv	a0,s4
    80002420:	50f000ef          	jal	8000312e <log_write>
    80002424:	b7f9                	j	800023f2 <bmap+0x92>
    80002426:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002428:	00005517          	auipc	a0,0x5
    8000242c:	01050513          	addi	a0,a0,16 # 80007438 <etext+0x438>
    80002430:	092030ef          	jal	800054c2 <panic>

0000000080002434 <iget>:
{
    80002434:	7179                	addi	sp,sp,-48
    80002436:	f406                	sd	ra,40(sp)
    80002438:	f022                	sd	s0,32(sp)
    8000243a:	ec26                	sd	s1,24(sp)
    8000243c:	e84a                	sd	s2,16(sp)
    8000243e:	e44e                	sd	s3,8(sp)
    80002440:	e052                	sd	s4,0(sp)
    80002442:	1800                	addi	s0,sp,48
    80002444:	89aa                	mv	s3,a0
    80002446:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002448:	00016517          	auipc	a0,0x16
    8000244c:	3b050513          	addi	a0,a0,944 # 800187f8 <itable>
    80002450:	3a0030ef          	jal	800057f0 <acquire>
  empty = 0;
    80002454:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002456:	00016497          	auipc	s1,0x16
    8000245a:	3ba48493          	addi	s1,s1,954 # 80018810 <itable+0x18>
    8000245e:	00018697          	auipc	a3,0x18
    80002462:	e4268693          	addi	a3,a3,-446 # 8001a2a0 <log>
    80002466:	a039                	j	80002474 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002468:	02090963          	beqz	s2,8000249a <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000246c:	08848493          	addi	s1,s1,136
    80002470:	02d48863          	beq	s1,a3,800024a0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002474:	449c                	lw	a5,8(s1)
    80002476:	fef059e3          	blez	a5,80002468 <iget+0x34>
    8000247a:	4098                	lw	a4,0(s1)
    8000247c:	ff3716e3          	bne	a4,s3,80002468 <iget+0x34>
    80002480:	40d8                	lw	a4,4(s1)
    80002482:	ff4713e3          	bne	a4,s4,80002468 <iget+0x34>
      ip->ref++;
    80002486:	2785                	addiw	a5,a5,1
    80002488:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000248a:	00016517          	auipc	a0,0x16
    8000248e:	36e50513          	addi	a0,a0,878 # 800187f8 <itable>
    80002492:	3f6030ef          	jal	80005888 <release>
      return ip;
    80002496:	8926                	mv	s2,s1
    80002498:	a02d                	j	800024c2 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000249a:	fbe9                	bnez	a5,8000246c <iget+0x38>
      empty = ip;
    8000249c:	8926                	mv	s2,s1
    8000249e:	b7f9                	j	8000246c <iget+0x38>
  if(empty == 0)
    800024a0:	02090a63          	beqz	s2,800024d4 <iget+0xa0>
  ip->dev = dev;
    800024a4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024a8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800024ac:	4785                	li	a5,1
    800024ae:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800024b2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800024b6:	00016517          	auipc	a0,0x16
    800024ba:	34250513          	addi	a0,a0,834 # 800187f8 <itable>
    800024be:	3ca030ef          	jal	80005888 <release>
}
    800024c2:	854a                	mv	a0,s2
    800024c4:	70a2                	ld	ra,40(sp)
    800024c6:	7402                	ld	s0,32(sp)
    800024c8:	64e2                	ld	s1,24(sp)
    800024ca:	6942                	ld	s2,16(sp)
    800024cc:	69a2                	ld	s3,8(sp)
    800024ce:	6a02                	ld	s4,0(sp)
    800024d0:	6145                	addi	sp,sp,48
    800024d2:	8082                	ret
    panic("iget: no inodes");
    800024d4:	00005517          	auipc	a0,0x5
    800024d8:	f7c50513          	addi	a0,a0,-132 # 80007450 <etext+0x450>
    800024dc:	7e7020ef          	jal	800054c2 <panic>

00000000800024e0 <fsinit>:
fsinit(int dev) {
    800024e0:	7179                	addi	sp,sp,-48
    800024e2:	f406                	sd	ra,40(sp)
    800024e4:	f022                	sd	s0,32(sp)
    800024e6:	ec26                	sd	s1,24(sp)
    800024e8:	e84a                	sd	s2,16(sp)
    800024ea:	e44e                	sd	s3,8(sp)
    800024ec:	1800                	addi	s0,sp,48
    800024ee:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800024f0:	4585                	li	a1,1
    800024f2:	aebff0ef          	jal	80001fdc <bread>
    800024f6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800024f8:	00016997          	auipc	s3,0x16
    800024fc:	2e098993          	addi	s3,s3,736 # 800187d8 <sb>
    80002500:	02000613          	li	a2,32
    80002504:	05850593          	addi	a1,a0,88
    80002508:	854e                	mv	a0,s3
    8000250a:	ce3fd0ef          	jal	800001ec <memmove>
  brelse(bp);
    8000250e:	8526                	mv	a0,s1
    80002510:	bd5ff0ef          	jal	800020e4 <brelse>
  if(sb.magic != FSMAGIC)
    80002514:	0009a703          	lw	a4,0(s3)
    80002518:	102037b7          	lui	a5,0x10203
    8000251c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002520:	02f71063          	bne	a4,a5,80002540 <fsinit+0x60>
  initlog(dev, &sb);
    80002524:	00016597          	auipc	a1,0x16
    80002528:	2b458593          	addi	a1,a1,692 # 800187d8 <sb>
    8000252c:	854a                	mv	a0,s2
    8000252e:	1f9000ef          	jal	80002f26 <initlog>
}
    80002532:	70a2                	ld	ra,40(sp)
    80002534:	7402                	ld	s0,32(sp)
    80002536:	64e2                	ld	s1,24(sp)
    80002538:	6942                	ld	s2,16(sp)
    8000253a:	69a2                	ld	s3,8(sp)
    8000253c:	6145                	addi	sp,sp,48
    8000253e:	8082                	ret
    panic("invalid file system");
    80002540:	00005517          	auipc	a0,0x5
    80002544:	f2050513          	addi	a0,a0,-224 # 80007460 <etext+0x460>
    80002548:	77b020ef          	jal	800054c2 <panic>

000000008000254c <iinit>:
{
    8000254c:	7179                	addi	sp,sp,-48
    8000254e:	f406                	sd	ra,40(sp)
    80002550:	f022                	sd	s0,32(sp)
    80002552:	ec26                	sd	s1,24(sp)
    80002554:	e84a                	sd	s2,16(sp)
    80002556:	e44e                	sd	s3,8(sp)
    80002558:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000255a:	00005597          	auipc	a1,0x5
    8000255e:	f1e58593          	addi	a1,a1,-226 # 80007478 <etext+0x478>
    80002562:	00016517          	auipc	a0,0x16
    80002566:	29650513          	addi	a0,a0,662 # 800187f8 <itable>
    8000256a:	206030ef          	jal	80005770 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000256e:	00016497          	auipc	s1,0x16
    80002572:	2b248493          	addi	s1,s1,690 # 80018820 <itable+0x28>
    80002576:	00018997          	auipc	s3,0x18
    8000257a:	d3a98993          	addi	s3,s3,-710 # 8001a2b0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000257e:	00005917          	auipc	s2,0x5
    80002582:	f0290913          	addi	s2,s2,-254 # 80007480 <etext+0x480>
    80002586:	85ca                	mv	a1,s2
    80002588:	8526                	mv	a0,s1
    8000258a:	475000ef          	jal	800031fe <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000258e:	08848493          	addi	s1,s1,136
    80002592:	ff349ae3          	bne	s1,s3,80002586 <iinit+0x3a>
}
    80002596:	70a2                	ld	ra,40(sp)
    80002598:	7402                	ld	s0,32(sp)
    8000259a:	64e2                	ld	s1,24(sp)
    8000259c:	6942                	ld	s2,16(sp)
    8000259e:	69a2                	ld	s3,8(sp)
    800025a0:	6145                	addi	sp,sp,48
    800025a2:	8082                	ret

00000000800025a4 <ialloc>:
{
    800025a4:	7139                	addi	sp,sp,-64
    800025a6:	fc06                	sd	ra,56(sp)
    800025a8:	f822                	sd	s0,48(sp)
    800025aa:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800025ac:	00016717          	auipc	a4,0x16
    800025b0:	23872703          	lw	a4,568(a4) # 800187e4 <sb+0xc>
    800025b4:	4785                	li	a5,1
    800025b6:	06e7f063          	bgeu	a5,a4,80002616 <ialloc+0x72>
    800025ba:	f426                	sd	s1,40(sp)
    800025bc:	f04a                	sd	s2,32(sp)
    800025be:	ec4e                	sd	s3,24(sp)
    800025c0:	e852                	sd	s4,16(sp)
    800025c2:	e456                	sd	s5,8(sp)
    800025c4:	e05a                	sd	s6,0(sp)
    800025c6:	8aaa                	mv	s5,a0
    800025c8:	8b2e                	mv	s6,a1
    800025ca:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800025cc:	00016a17          	auipc	s4,0x16
    800025d0:	20ca0a13          	addi	s4,s4,524 # 800187d8 <sb>
    800025d4:	00495593          	srli	a1,s2,0x4
    800025d8:	018a2783          	lw	a5,24(s4)
    800025dc:	9dbd                	addw	a1,a1,a5
    800025de:	8556                	mv	a0,s5
    800025e0:	9fdff0ef          	jal	80001fdc <bread>
    800025e4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025e6:	05850993          	addi	s3,a0,88
    800025ea:	00f97793          	andi	a5,s2,15
    800025ee:	079a                	slli	a5,a5,0x6
    800025f0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025f2:	00099783          	lh	a5,0(s3)
    800025f6:	cb9d                	beqz	a5,8000262c <ialloc+0x88>
    brelse(bp);
    800025f8:	aedff0ef          	jal	800020e4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025fc:	0905                	addi	s2,s2,1
    800025fe:	00ca2703          	lw	a4,12(s4)
    80002602:	0009079b          	sext.w	a5,s2
    80002606:	fce7e7e3          	bltu	a5,a4,800025d4 <ialloc+0x30>
    8000260a:	74a2                	ld	s1,40(sp)
    8000260c:	7902                	ld	s2,32(sp)
    8000260e:	69e2                	ld	s3,24(sp)
    80002610:	6a42                	ld	s4,16(sp)
    80002612:	6aa2                	ld	s5,8(sp)
    80002614:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002616:	00005517          	auipc	a0,0x5
    8000261a:	e7250513          	addi	a0,a0,-398 # 80007488 <etext+0x488>
    8000261e:	3d3020ef          	jal	800051f0 <printf>
  return 0;
    80002622:	4501                	li	a0,0
}
    80002624:	70e2                	ld	ra,56(sp)
    80002626:	7442                	ld	s0,48(sp)
    80002628:	6121                	addi	sp,sp,64
    8000262a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000262c:	04000613          	li	a2,64
    80002630:	4581                	li	a1,0
    80002632:	854e                	mv	a0,s3
    80002634:	b5dfd0ef          	jal	80000190 <memset>
      dip->type = type;
    80002638:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000263c:	8526                	mv	a0,s1
    8000263e:	2f1000ef          	jal	8000312e <log_write>
      brelse(bp);
    80002642:	8526                	mv	a0,s1
    80002644:	aa1ff0ef          	jal	800020e4 <brelse>
      return iget(dev, inum);
    80002648:	0009059b          	sext.w	a1,s2
    8000264c:	8556                	mv	a0,s5
    8000264e:	de7ff0ef          	jal	80002434 <iget>
    80002652:	74a2                	ld	s1,40(sp)
    80002654:	7902                	ld	s2,32(sp)
    80002656:	69e2                	ld	s3,24(sp)
    80002658:	6a42                	ld	s4,16(sp)
    8000265a:	6aa2                	ld	s5,8(sp)
    8000265c:	6b02                	ld	s6,0(sp)
    8000265e:	b7d9                	j	80002624 <ialloc+0x80>

0000000080002660 <iupdate>:
{
    80002660:	1101                	addi	sp,sp,-32
    80002662:	ec06                	sd	ra,24(sp)
    80002664:	e822                	sd	s0,16(sp)
    80002666:	e426                	sd	s1,8(sp)
    80002668:	e04a                	sd	s2,0(sp)
    8000266a:	1000                	addi	s0,sp,32
    8000266c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000266e:	415c                	lw	a5,4(a0)
    80002670:	0047d79b          	srliw	a5,a5,0x4
    80002674:	00016597          	auipc	a1,0x16
    80002678:	17c5a583          	lw	a1,380(a1) # 800187f0 <sb+0x18>
    8000267c:	9dbd                	addw	a1,a1,a5
    8000267e:	4108                	lw	a0,0(a0)
    80002680:	95dff0ef          	jal	80001fdc <bread>
    80002684:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002686:	05850793          	addi	a5,a0,88
    8000268a:	40d8                	lw	a4,4(s1)
    8000268c:	8b3d                	andi	a4,a4,15
    8000268e:	071a                	slli	a4,a4,0x6
    80002690:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002692:	04449703          	lh	a4,68(s1)
    80002696:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000269a:	04649703          	lh	a4,70(s1)
    8000269e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800026a2:	04849703          	lh	a4,72(s1)
    800026a6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800026aa:	04a49703          	lh	a4,74(s1)
    800026ae:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800026b2:	44f8                	lw	a4,76(s1)
    800026b4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800026b6:	03400613          	li	a2,52
    800026ba:	05048593          	addi	a1,s1,80
    800026be:	00c78513          	addi	a0,a5,12
    800026c2:	b2bfd0ef          	jal	800001ec <memmove>
  log_write(bp);
    800026c6:	854a                	mv	a0,s2
    800026c8:	267000ef          	jal	8000312e <log_write>
  brelse(bp);
    800026cc:	854a                	mv	a0,s2
    800026ce:	a17ff0ef          	jal	800020e4 <brelse>
}
    800026d2:	60e2                	ld	ra,24(sp)
    800026d4:	6442                	ld	s0,16(sp)
    800026d6:	64a2                	ld	s1,8(sp)
    800026d8:	6902                	ld	s2,0(sp)
    800026da:	6105                	addi	sp,sp,32
    800026dc:	8082                	ret

00000000800026de <idup>:
{
    800026de:	1101                	addi	sp,sp,-32
    800026e0:	ec06                	sd	ra,24(sp)
    800026e2:	e822                	sd	s0,16(sp)
    800026e4:	e426                	sd	s1,8(sp)
    800026e6:	1000                	addi	s0,sp,32
    800026e8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026ea:	00016517          	auipc	a0,0x16
    800026ee:	10e50513          	addi	a0,a0,270 # 800187f8 <itable>
    800026f2:	0fe030ef          	jal	800057f0 <acquire>
  ip->ref++;
    800026f6:	449c                	lw	a5,8(s1)
    800026f8:	2785                	addiw	a5,a5,1
    800026fa:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026fc:	00016517          	auipc	a0,0x16
    80002700:	0fc50513          	addi	a0,a0,252 # 800187f8 <itable>
    80002704:	184030ef          	jal	80005888 <release>
}
    80002708:	8526                	mv	a0,s1
    8000270a:	60e2                	ld	ra,24(sp)
    8000270c:	6442                	ld	s0,16(sp)
    8000270e:	64a2                	ld	s1,8(sp)
    80002710:	6105                	addi	sp,sp,32
    80002712:	8082                	ret

0000000080002714 <ilock>:
{
    80002714:	1101                	addi	sp,sp,-32
    80002716:	ec06                	sd	ra,24(sp)
    80002718:	e822                	sd	s0,16(sp)
    8000271a:	e426                	sd	s1,8(sp)
    8000271c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000271e:	cd19                	beqz	a0,8000273c <ilock+0x28>
    80002720:	84aa                	mv	s1,a0
    80002722:	451c                	lw	a5,8(a0)
    80002724:	00f05c63          	blez	a5,8000273c <ilock+0x28>
  acquiresleep(&ip->lock);
    80002728:	0541                	addi	a0,a0,16
    8000272a:	30b000ef          	jal	80003234 <acquiresleep>
  if(ip->valid == 0){
    8000272e:	40bc                	lw	a5,64(s1)
    80002730:	cf89                	beqz	a5,8000274a <ilock+0x36>
}
    80002732:	60e2                	ld	ra,24(sp)
    80002734:	6442                	ld	s0,16(sp)
    80002736:	64a2                	ld	s1,8(sp)
    80002738:	6105                	addi	sp,sp,32
    8000273a:	8082                	ret
    8000273c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000273e:	00005517          	auipc	a0,0x5
    80002742:	d6250513          	addi	a0,a0,-670 # 800074a0 <etext+0x4a0>
    80002746:	57d020ef          	jal	800054c2 <panic>
    8000274a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000274c:	40dc                	lw	a5,4(s1)
    8000274e:	0047d79b          	srliw	a5,a5,0x4
    80002752:	00016597          	auipc	a1,0x16
    80002756:	09e5a583          	lw	a1,158(a1) # 800187f0 <sb+0x18>
    8000275a:	9dbd                	addw	a1,a1,a5
    8000275c:	4088                	lw	a0,0(s1)
    8000275e:	87fff0ef          	jal	80001fdc <bread>
    80002762:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002764:	05850593          	addi	a1,a0,88
    80002768:	40dc                	lw	a5,4(s1)
    8000276a:	8bbd                	andi	a5,a5,15
    8000276c:	079a                	slli	a5,a5,0x6
    8000276e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002770:	00059783          	lh	a5,0(a1)
    80002774:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002778:	00259783          	lh	a5,2(a1)
    8000277c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002780:	00459783          	lh	a5,4(a1)
    80002784:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002788:	00659783          	lh	a5,6(a1)
    8000278c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002790:	459c                	lw	a5,8(a1)
    80002792:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002794:	03400613          	li	a2,52
    80002798:	05b1                	addi	a1,a1,12
    8000279a:	05048513          	addi	a0,s1,80
    8000279e:	a4ffd0ef          	jal	800001ec <memmove>
    brelse(bp);
    800027a2:	854a                	mv	a0,s2
    800027a4:	941ff0ef          	jal	800020e4 <brelse>
    ip->valid = 1;
    800027a8:	4785                	li	a5,1
    800027aa:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800027ac:	04449783          	lh	a5,68(s1)
    800027b0:	c399                	beqz	a5,800027b6 <ilock+0xa2>
    800027b2:	6902                	ld	s2,0(sp)
    800027b4:	bfbd                	j	80002732 <ilock+0x1e>
      panic("ilock: no type");
    800027b6:	00005517          	auipc	a0,0x5
    800027ba:	cf250513          	addi	a0,a0,-782 # 800074a8 <etext+0x4a8>
    800027be:	505020ef          	jal	800054c2 <panic>

00000000800027c2 <iunlock>:
{
    800027c2:	1101                	addi	sp,sp,-32
    800027c4:	ec06                	sd	ra,24(sp)
    800027c6:	e822                	sd	s0,16(sp)
    800027c8:	e426                	sd	s1,8(sp)
    800027ca:	e04a                	sd	s2,0(sp)
    800027cc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800027ce:	c505                	beqz	a0,800027f6 <iunlock+0x34>
    800027d0:	84aa                	mv	s1,a0
    800027d2:	01050913          	addi	s2,a0,16
    800027d6:	854a                	mv	a0,s2
    800027d8:	2db000ef          	jal	800032b2 <holdingsleep>
    800027dc:	cd09                	beqz	a0,800027f6 <iunlock+0x34>
    800027de:	449c                	lw	a5,8(s1)
    800027e0:	00f05b63          	blez	a5,800027f6 <iunlock+0x34>
  releasesleep(&ip->lock);
    800027e4:	854a                	mv	a0,s2
    800027e6:	295000ef          	jal	8000327a <releasesleep>
}
    800027ea:	60e2                	ld	ra,24(sp)
    800027ec:	6442                	ld	s0,16(sp)
    800027ee:	64a2                	ld	s1,8(sp)
    800027f0:	6902                	ld	s2,0(sp)
    800027f2:	6105                	addi	sp,sp,32
    800027f4:	8082                	ret
    panic("iunlock");
    800027f6:	00005517          	auipc	a0,0x5
    800027fa:	cc250513          	addi	a0,a0,-830 # 800074b8 <etext+0x4b8>
    800027fe:	4c5020ef          	jal	800054c2 <panic>

0000000080002802 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002802:	7179                	addi	sp,sp,-48
    80002804:	f406                	sd	ra,40(sp)
    80002806:	f022                	sd	s0,32(sp)
    80002808:	ec26                	sd	s1,24(sp)
    8000280a:	e84a                	sd	s2,16(sp)
    8000280c:	e44e                	sd	s3,8(sp)
    8000280e:	1800                	addi	s0,sp,48
    80002810:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002812:	05050493          	addi	s1,a0,80
    80002816:	08050913          	addi	s2,a0,128
    8000281a:	a021                	j	80002822 <itrunc+0x20>
    8000281c:	0491                	addi	s1,s1,4
    8000281e:	01248b63          	beq	s1,s2,80002834 <itrunc+0x32>
    if(ip->addrs[i]){
    80002822:	408c                	lw	a1,0(s1)
    80002824:	dde5                	beqz	a1,8000281c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002826:	0009a503          	lw	a0,0(s3)
    8000282a:	9abff0ef          	jal	800021d4 <bfree>
      ip->addrs[i] = 0;
    8000282e:	0004a023          	sw	zero,0(s1)
    80002832:	b7ed                	j	8000281c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002834:	0809a583          	lw	a1,128(s3)
    80002838:	ed89                	bnez	a1,80002852 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000283a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000283e:	854e                	mv	a0,s3
    80002840:	e21ff0ef          	jal	80002660 <iupdate>
}
    80002844:	70a2                	ld	ra,40(sp)
    80002846:	7402                	ld	s0,32(sp)
    80002848:	64e2                	ld	s1,24(sp)
    8000284a:	6942                	ld	s2,16(sp)
    8000284c:	69a2                	ld	s3,8(sp)
    8000284e:	6145                	addi	sp,sp,48
    80002850:	8082                	ret
    80002852:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002854:	0009a503          	lw	a0,0(s3)
    80002858:	f84ff0ef          	jal	80001fdc <bread>
    8000285c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000285e:	05850493          	addi	s1,a0,88
    80002862:	45850913          	addi	s2,a0,1112
    80002866:	a021                	j	8000286e <itrunc+0x6c>
    80002868:	0491                	addi	s1,s1,4
    8000286a:	01248963          	beq	s1,s2,8000287c <itrunc+0x7a>
      if(a[j])
    8000286e:	408c                	lw	a1,0(s1)
    80002870:	dde5                	beqz	a1,80002868 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002872:	0009a503          	lw	a0,0(s3)
    80002876:	95fff0ef          	jal	800021d4 <bfree>
    8000287a:	b7fd                	j	80002868 <itrunc+0x66>
    brelse(bp);
    8000287c:	8552                	mv	a0,s4
    8000287e:	867ff0ef          	jal	800020e4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002882:	0809a583          	lw	a1,128(s3)
    80002886:	0009a503          	lw	a0,0(s3)
    8000288a:	94bff0ef          	jal	800021d4 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000288e:	0809a023          	sw	zero,128(s3)
    80002892:	6a02                	ld	s4,0(sp)
    80002894:	b75d                	j	8000283a <itrunc+0x38>

0000000080002896 <iput>:
{
    80002896:	1101                	addi	sp,sp,-32
    80002898:	ec06                	sd	ra,24(sp)
    8000289a:	e822                	sd	s0,16(sp)
    8000289c:	e426                	sd	s1,8(sp)
    8000289e:	1000                	addi	s0,sp,32
    800028a0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028a2:	00016517          	auipc	a0,0x16
    800028a6:	f5650513          	addi	a0,a0,-170 # 800187f8 <itable>
    800028aa:	747020ef          	jal	800057f0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028ae:	4498                	lw	a4,8(s1)
    800028b0:	4785                	li	a5,1
    800028b2:	02f70063          	beq	a4,a5,800028d2 <iput+0x3c>
  ip->ref--;
    800028b6:	449c                	lw	a5,8(s1)
    800028b8:	37fd                	addiw	a5,a5,-1
    800028ba:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800028bc:	00016517          	auipc	a0,0x16
    800028c0:	f3c50513          	addi	a0,a0,-196 # 800187f8 <itable>
    800028c4:	7c5020ef          	jal	80005888 <release>
}
    800028c8:	60e2                	ld	ra,24(sp)
    800028ca:	6442                	ld	s0,16(sp)
    800028cc:	64a2                	ld	s1,8(sp)
    800028ce:	6105                	addi	sp,sp,32
    800028d0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028d2:	40bc                	lw	a5,64(s1)
    800028d4:	d3ed                	beqz	a5,800028b6 <iput+0x20>
    800028d6:	04a49783          	lh	a5,74(s1)
    800028da:	fff1                	bnez	a5,800028b6 <iput+0x20>
    800028dc:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800028de:	01048913          	addi	s2,s1,16
    800028e2:	854a                	mv	a0,s2
    800028e4:	151000ef          	jal	80003234 <acquiresleep>
    release(&itable.lock);
    800028e8:	00016517          	auipc	a0,0x16
    800028ec:	f1050513          	addi	a0,a0,-240 # 800187f8 <itable>
    800028f0:	799020ef          	jal	80005888 <release>
    itrunc(ip);
    800028f4:	8526                	mv	a0,s1
    800028f6:	f0dff0ef          	jal	80002802 <itrunc>
    ip->type = 0;
    800028fa:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028fe:	8526                	mv	a0,s1
    80002900:	d61ff0ef          	jal	80002660 <iupdate>
    ip->valid = 0;
    80002904:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002908:	854a                	mv	a0,s2
    8000290a:	171000ef          	jal	8000327a <releasesleep>
    acquire(&itable.lock);
    8000290e:	00016517          	auipc	a0,0x16
    80002912:	eea50513          	addi	a0,a0,-278 # 800187f8 <itable>
    80002916:	6db020ef          	jal	800057f0 <acquire>
    8000291a:	6902                	ld	s2,0(sp)
    8000291c:	bf69                	j	800028b6 <iput+0x20>

000000008000291e <iunlockput>:
{
    8000291e:	1101                	addi	sp,sp,-32
    80002920:	ec06                	sd	ra,24(sp)
    80002922:	e822                	sd	s0,16(sp)
    80002924:	e426                	sd	s1,8(sp)
    80002926:	1000                	addi	s0,sp,32
    80002928:	84aa                	mv	s1,a0
  iunlock(ip);
    8000292a:	e99ff0ef          	jal	800027c2 <iunlock>
  iput(ip);
    8000292e:	8526                	mv	a0,s1
    80002930:	f67ff0ef          	jal	80002896 <iput>
}
    80002934:	60e2                	ld	ra,24(sp)
    80002936:	6442                	ld	s0,16(sp)
    80002938:	64a2                	ld	s1,8(sp)
    8000293a:	6105                	addi	sp,sp,32
    8000293c:	8082                	ret

000000008000293e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000293e:	1141                	addi	sp,sp,-16
    80002940:	e422                	sd	s0,8(sp)
    80002942:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002944:	411c                	lw	a5,0(a0)
    80002946:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002948:	415c                	lw	a5,4(a0)
    8000294a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000294c:	04451783          	lh	a5,68(a0)
    80002950:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002954:	04a51783          	lh	a5,74(a0)
    80002958:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000295c:	04c56783          	lwu	a5,76(a0)
    80002960:	e99c                	sd	a5,16(a1)
}
    80002962:	6422                	ld	s0,8(sp)
    80002964:	0141                	addi	sp,sp,16
    80002966:	8082                	ret

0000000080002968 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002968:	457c                	lw	a5,76(a0)
    8000296a:	0ed7eb63          	bltu	a5,a3,80002a60 <readi+0xf8>
{
    8000296e:	7159                	addi	sp,sp,-112
    80002970:	f486                	sd	ra,104(sp)
    80002972:	f0a2                	sd	s0,96(sp)
    80002974:	eca6                	sd	s1,88(sp)
    80002976:	e0d2                	sd	s4,64(sp)
    80002978:	fc56                	sd	s5,56(sp)
    8000297a:	f85a                	sd	s6,48(sp)
    8000297c:	f45e                	sd	s7,40(sp)
    8000297e:	1880                	addi	s0,sp,112
    80002980:	8b2a                	mv	s6,a0
    80002982:	8bae                	mv	s7,a1
    80002984:	8a32                	mv	s4,a2
    80002986:	84b6                	mv	s1,a3
    80002988:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000298a:	9f35                	addw	a4,a4,a3
    return 0;
    8000298c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000298e:	0cd76063          	bltu	a4,a3,80002a4e <readi+0xe6>
    80002992:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002994:	00e7f463          	bgeu	a5,a4,8000299c <readi+0x34>
    n = ip->size - off;
    80002998:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000299c:	080a8f63          	beqz	s5,80002a3a <readi+0xd2>
    800029a0:	e8ca                	sd	s2,80(sp)
    800029a2:	f062                	sd	s8,32(sp)
    800029a4:	ec66                	sd	s9,24(sp)
    800029a6:	e86a                	sd	s10,16(sp)
    800029a8:	e46e                	sd	s11,8(sp)
    800029aa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029ac:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800029b0:	5c7d                	li	s8,-1
    800029b2:	a80d                	j	800029e4 <readi+0x7c>
    800029b4:	020d1d93          	slli	s11,s10,0x20
    800029b8:	020ddd93          	srli	s11,s11,0x20
    800029bc:	05890613          	addi	a2,s2,88
    800029c0:	86ee                	mv	a3,s11
    800029c2:	963a                	add	a2,a2,a4
    800029c4:	85d2                	mv	a1,s4
    800029c6:	855e                	mv	a0,s7
    800029c8:	d0bfe0ef          	jal	800016d2 <either_copyout>
    800029cc:	05850763          	beq	a0,s8,80002a1a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800029d0:	854a                	mv	a0,s2
    800029d2:	f12ff0ef          	jal	800020e4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029d6:	013d09bb          	addw	s3,s10,s3
    800029da:	009d04bb          	addw	s1,s10,s1
    800029de:	9a6e                	add	s4,s4,s11
    800029e0:	0559f763          	bgeu	s3,s5,80002a2e <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800029e4:	00a4d59b          	srliw	a1,s1,0xa
    800029e8:	855a                	mv	a0,s6
    800029ea:	977ff0ef          	jal	80002360 <bmap>
    800029ee:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800029f2:	c5b1                	beqz	a1,80002a3e <readi+0xd6>
    bp = bread(ip->dev, addr);
    800029f4:	000b2503          	lw	a0,0(s6)
    800029f8:	de4ff0ef          	jal	80001fdc <bread>
    800029fc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800029fe:	3ff4f713          	andi	a4,s1,1023
    80002a02:	40ec87bb          	subw	a5,s9,a4
    80002a06:	413a86bb          	subw	a3,s5,s3
    80002a0a:	8d3e                	mv	s10,a5
    80002a0c:	2781                	sext.w	a5,a5
    80002a0e:	0006861b          	sext.w	a2,a3
    80002a12:	faf671e3          	bgeu	a2,a5,800029b4 <readi+0x4c>
    80002a16:	8d36                	mv	s10,a3
    80002a18:	bf71                	j	800029b4 <readi+0x4c>
      brelse(bp);
    80002a1a:	854a                	mv	a0,s2
    80002a1c:	ec8ff0ef          	jal	800020e4 <brelse>
      tot = -1;
    80002a20:	59fd                	li	s3,-1
      break;
    80002a22:	6946                	ld	s2,80(sp)
    80002a24:	7c02                	ld	s8,32(sp)
    80002a26:	6ce2                	ld	s9,24(sp)
    80002a28:	6d42                	ld	s10,16(sp)
    80002a2a:	6da2                	ld	s11,8(sp)
    80002a2c:	a831                	j	80002a48 <readi+0xe0>
    80002a2e:	6946                	ld	s2,80(sp)
    80002a30:	7c02                	ld	s8,32(sp)
    80002a32:	6ce2                	ld	s9,24(sp)
    80002a34:	6d42                	ld	s10,16(sp)
    80002a36:	6da2                	ld	s11,8(sp)
    80002a38:	a801                	j	80002a48 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a3a:	89d6                	mv	s3,s5
    80002a3c:	a031                	j	80002a48 <readi+0xe0>
    80002a3e:	6946                	ld	s2,80(sp)
    80002a40:	7c02                	ld	s8,32(sp)
    80002a42:	6ce2                	ld	s9,24(sp)
    80002a44:	6d42                	ld	s10,16(sp)
    80002a46:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a48:	0009851b          	sext.w	a0,s3
    80002a4c:	69a6                	ld	s3,72(sp)
}
    80002a4e:	70a6                	ld	ra,104(sp)
    80002a50:	7406                	ld	s0,96(sp)
    80002a52:	64e6                	ld	s1,88(sp)
    80002a54:	6a06                	ld	s4,64(sp)
    80002a56:	7ae2                	ld	s5,56(sp)
    80002a58:	7b42                	ld	s6,48(sp)
    80002a5a:	7ba2                	ld	s7,40(sp)
    80002a5c:	6165                	addi	sp,sp,112
    80002a5e:	8082                	ret
    return 0;
    80002a60:	4501                	li	a0,0
}
    80002a62:	8082                	ret

0000000080002a64 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a64:	457c                	lw	a5,76(a0)
    80002a66:	10d7e063          	bltu	a5,a3,80002b66 <writei+0x102>
{
    80002a6a:	7159                	addi	sp,sp,-112
    80002a6c:	f486                	sd	ra,104(sp)
    80002a6e:	f0a2                	sd	s0,96(sp)
    80002a70:	e8ca                	sd	s2,80(sp)
    80002a72:	e0d2                	sd	s4,64(sp)
    80002a74:	fc56                	sd	s5,56(sp)
    80002a76:	f85a                	sd	s6,48(sp)
    80002a78:	f45e                	sd	s7,40(sp)
    80002a7a:	1880                	addi	s0,sp,112
    80002a7c:	8aaa                	mv	s5,a0
    80002a7e:	8bae                	mv	s7,a1
    80002a80:	8a32                	mv	s4,a2
    80002a82:	8936                	mv	s2,a3
    80002a84:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002a86:	00e687bb          	addw	a5,a3,a4
    80002a8a:	0ed7e063          	bltu	a5,a3,80002b6a <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002a8e:	00043737          	lui	a4,0x43
    80002a92:	0cf76e63          	bltu	a4,a5,80002b6e <writei+0x10a>
    80002a96:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a98:	0a0b0f63          	beqz	s6,80002b56 <writei+0xf2>
    80002a9c:	eca6                	sd	s1,88(sp)
    80002a9e:	f062                	sd	s8,32(sp)
    80002aa0:	ec66                	sd	s9,24(sp)
    80002aa2:	e86a                	sd	s10,16(sp)
    80002aa4:	e46e                	sd	s11,8(sp)
    80002aa6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002aa8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002aac:	5c7d                	li	s8,-1
    80002aae:	a825                	j	80002ae6 <writei+0x82>
    80002ab0:	020d1d93          	slli	s11,s10,0x20
    80002ab4:	020ddd93          	srli	s11,s11,0x20
    80002ab8:	05848513          	addi	a0,s1,88
    80002abc:	86ee                	mv	a3,s11
    80002abe:	8652                	mv	a2,s4
    80002ac0:	85de                	mv	a1,s7
    80002ac2:	953a                	add	a0,a0,a4
    80002ac4:	c59fe0ef          	jal	8000171c <either_copyin>
    80002ac8:	05850a63          	beq	a0,s8,80002b1c <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002acc:	8526                	mv	a0,s1
    80002ace:	660000ef          	jal	8000312e <log_write>
    brelse(bp);
    80002ad2:	8526                	mv	a0,s1
    80002ad4:	e10ff0ef          	jal	800020e4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ad8:	013d09bb          	addw	s3,s10,s3
    80002adc:	012d093b          	addw	s2,s10,s2
    80002ae0:	9a6e                	add	s4,s4,s11
    80002ae2:	0569f063          	bgeu	s3,s6,80002b22 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002ae6:	00a9559b          	srliw	a1,s2,0xa
    80002aea:	8556                	mv	a0,s5
    80002aec:	875ff0ef          	jal	80002360 <bmap>
    80002af0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002af4:	c59d                	beqz	a1,80002b22 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002af6:	000aa503          	lw	a0,0(s5)
    80002afa:	ce2ff0ef          	jal	80001fdc <bread>
    80002afe:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b00:	3ff97713          	andi	a4,s2,1023
    80002b04:	40ec87bb          	subw	a5,s9,a4
    80002b08:	413b06bb          	subw	a3,s6,s3
    80002b0c:	8d3e                	mv	s10,a5
    80002b0e:	2781                	sext.w	a5,a5
    80002b10:	0006861b          	sext.w	a2,a3
    80002b14:	f8f67ee3          	bgeu	a2,a5,80002ab0 <writei+0x4c>
    80002b18:	8d36                	mv	s10,a3
    80002b1a:	bf59                	j	80002ab0 <writei+0x4c>
      brelse(bp);
    80002b1c:	8526                	mv	a0,s1
    80002b1e:	dc6ff0ef          	jal	800020e4 <brelse>
  }

  if(off > ip->size)
    80002b22:	04caa783          	lw	a5,76(s5)
    80002b26:	0327fa63          	bgeu	a5,s2,80002b5a <writei+0xf6>
    ip->size = off;
    80002b2a:	052aa623          	sw	s2,76(s5)
    80002b2e:	64e6                	ld	s1,88(sp)
    80002b30:	7c02                	ld	s8,32(sp)
    80002b32:	6ce2                	ld	s9,24(sp)
    80002b34:	6d42                	ld	s10,16(sp)
    80002b36:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b38:	8556                	mv	a0,s5
    80002b3a:	b27ff0ef          	jal	80002660 <iupdate>

  return tot;
    80002b3e:	0009851b          	sext.w	a0,s3
    80002b42:	69a6                	ld	s3,72(sp)
}
    80002b44:	70a6                	ld	ra,104(sp)
    80002b46:	7406                	ld	s0,96(sp)
    80002b48:	6946                	ld	s2,80(sp)
    80002b4a:	6a06                	ld	s4,64(sp)
    80002b4c:	7ae2                	ld	s5,56(sp)
    80002b4e:	7b42                	ld	s6,48(sp)
    80002b50:	7ba2                	ld	s7,40(sp)
    80002b52:	6165                	addi	sp,sp,112
    80002b54:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b56:	89da                	mv	s3,s6
    80002b58:	b7c5                	j	80002b38 <writei+0xd4>
    80002b5a:	64e6                	ld	s1,88(sp)
    80002b5c:	7c02                	ld	s8,32(sp)
    80002b5e:	6ce2                	ld	s9,24(sp)
    80002b60:	6d42                	ld	s10,16(sp)
    80002b62:	6da2                	ld	s11,8(sp)
    80002b64:	bfd1                	j	80002b38 <writei+0xd4>
    return -1;
    80002b66:	557d                	li	a0,-1
}
    80002b68:	8082                	ret
    return -1;
    80002b6a:	557d                	li	a0,-1
    80002b6c:	bfe1                	j	80002b44 <writei+0xe0>
    return -1;
    80002b6e:	557d                	li	a0,-1
    80002b70:	bfd1                	j	80002b44 <writei+0xe0>

0000000080002b72 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002b72:	1141                	addi	sp,sp,-16
    80002b74:	e406                	sd	ra,8(sp)
    80002b76:	e022                	sd	s0,0(sp)
    80002b78:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002b7a:	4639                	li	a2,14
    80002b7c:	ee0fd0ef          	jal	8000025c <strncmp>
}
    80002b80:	60a2                	ld	ra,8(sp)
    80002b82:	6402                	ld	s0,0(sp)
    80002b84:	0141                	addi	sp,sp,16
    80002b86:	8082                	ret

0000000080002b88 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002b88:	7139                	addi	sp,sp,-64
    80002b8a:	fc06                	sd	ra,56(sp)
    80002b8c:	f822                	sd	s0,48(sp)
    80002b8e:	f426                	sd	s1,40(sp)
    80002b90:	f04a                	sd	s2,32(sp)
    80002b92:	ec4e                	sd	s3,24(sp)
    80002b94:	e852                	sd	s4,16(sp)
    80002b96:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002b98:	04451703          	lh	a4,68(a0)
    80002b9c:	4785                	li	a5,1
    80002b9e:	00f71a63          	bne	a4,a5,80002bb2 <dirlookup+0x2a>
    80002ba2:	892a                	mv	s2,a0
    80002ba4:	89ae                	mv	s3,a1
    80002ba6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ba8:	457c                	lw	a5,76(a0)
    80002baa:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002bac:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bae:	e39d                	bnez	a5,80002bd4 <dirlookup+0x4c>
    80002bb0:	a095                	j	80002c14 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002bb2:	00005517          	auipc	a0,0x5
    80002bb6:	90e50513          	addi	a0,a0,-1778 # 800074c0 <etext+0x4c0>
    80002bba:	109020ef          	jal	800054c2 <panic>
      panic("dirlookup read");
    80002bbe:	00005517          	auipc	a0,0x5
    80002bc2:	91a50513          	addi	a0,a0,-1766 # 800074d8 <etext+0x4d8>
    80002bc6:	0fd020ef          	jal	800054c2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bca:	24c1                	addiw	s1,s1,16
    80002bcc:	04c92783          	lw	a5,76(s2)
    80002bd0:	04f4f163          	bgeu	s1,a5,80002c12 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002bd4:	4741                	li	a4,16
    80002bd6:	86a6                	mv	a3,s1
    80002bd8:	fc040613          	addi	a2,s0,-64
    80002bdc:	4581                	li	a1,0
    80002bde:	854a                	mv	a0,s2
    80002be0:	d89ff0ef          	jal	80002968 <readi>
    80002be4:	47c1                	li	a5,16
    80002be6:	fcf51ce3          	bne	a0,a5,80002bbe <dirlookup+0x36>
    if(de.inum == 0)
    80002bea:	fc045783          	lhu	a5,-64(s0)
    80002bee:	dff1                	beqz	a5,80002bca <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002bf0:	fc240593          	addi	a1,s0,-62
    80002bf4:	854e                	mv	a0,s3
    80002bf6:	f7dff0ef          	jal	80002b72 <namecmp>
    80002bfa:	f961                	bnez	a0,80002bca <dirlookup+0x42>
      if(poff)
    80002bfc:	000a0463          	beqz	s4,80002c04 <dirlookup+0x7c>
        *poff = off;
    80002c00:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002c04:	fc045583          	lhu	a1,-64(s0)
    80002c08:	00092503          	lw	a0,0(s2)
    80002c0c:	829ff0ef          	jal	80002434 <iget>
    80002c10:	a011                	j	80002c14 <dirlookup+0x8c>
  return 0;
    80002c12:	4501                	li	a0,0
}
    80002c14:	70e2                	ld	ra,56(sp)
    80002c16:	7442                	ld	s0,48(sp)
    80002c18:	74a2                	ld	s1,40(sp)
    80002c1a:	7902                	ld	s2,32(sp)
    80002c1c:	69e2                	ld	s3,24(sp)
    80002c1e:	6a42                	ld	s4,16(sp)
    80002c20:	6121                	addi	sp,sp,64
    80002c22:	8082                	ret

0000000080002c24 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c24:	711d                	addi	sp,sp,-96
    80002c26:	ec86                	sd	ra,88(sp)
    80002c28:	e8a2                	sd	s0,80(sp)
    80002c2a:	e4a6                	sd	s1,72(sp)
    80002c2c:	e0ca                	sd	s2,64(sp)
    80002c2e:	fc4e                	sd	s3,56(sp)
    80002c30:	f852                	sd	s4,48(sp)
    80002c32:	f456                	sd	s5,40(sp)
    80002c34:	f05a                	sd	s6,32(sp)
    80002c36:	ec5e                	sd	s7,24(sp)
    80002c38:	e862                	sd	s8,16(sp)
    80002c3a:	e466                	sd	s9,8(sp)
    80002c3c:	1080                	addi	s0,sp,96
    80002c3e:	84aa                	mv	s1,a0
    80002c40:	8b2e                	mv	s6,a1
    80002c42:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c44:	00054703          	lbu	a4,0(a0)
    80002c48:	02f00793          	li	a5,47
    80002c4c:	00f70e63          	beq	a4,a5,80002c68 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c50:	958fe0ef          	jal	80000da8 <myproc>
    80002c54:	15053503          	ld	a0,336(a0)
    80002c58:	a87ff0ef          	jal	800026de <idup>
    80002c5c:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002c5e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002c62:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002c64:	4b85                	li	s7,1
    80002c66:	a871                	j	80002d02 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002c68:	4585                	li	a1,1
    80002c6a:	4505                	li	a0,1
    80002c6c:	fc8ff0ef          	jal	80002434 <iget>
    80002c70:	8a2a                	mv	s4,a0
    80002c72:	b7f5                	j	80002c5e <namex+0x3a>
      iunlockput(ip);
    80002c74:	8552                	mv	a0,s4
    80002c76:	ca9ff0ef          	jal	8000291e <iunlockput>
      return 0;
    80002c7a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002c7c:	8552                	mv	a0,s4
    80002c7e:	60e6                	ld	ra,88(sp)
    80002c80:	6446                	ld	s0,80(sp)
    80002c82:	64a6                	ld	s1,72(sp)
    80002c84:	6906                	ld	s2,64(sp)
    80002c86:	79e2                	ld	s3,56(sp)
    80002c88:	7a42                	ld	s4,48(sp)
    80002c8a:	7aa2                	ld	s5,40(sp)
    80002c8c:	7b02                	ld	s6,32(sp)
    80002c8e:	6be2                	ld	s7,24(sp)
    80002c90:	6c42                	ld	s8,16(sp)
    80002c92:	6ca2                	ld	s9,8(sp)
    80002c94:	6125                	addi	sp,sp,96
    80002c96:	8082                	ret
      iunlock(ip);
    80002c98:	8552                	mv	a0,s4
    80002c9a:	b29ff0ef          	jal	800027c2 <iunlock>
      return ip;
    80002c9e:	bff9                	j	80002c7c <namex+0x58>
      iunlockput(ip);
    80002ca0:	8552                	mv	a0,s4
    80002ca2:	c7dff0ef          	jal	8000291e <iunlockput>
      return 0;
    80002ca6:	8a4e                	mv	s4,s3
    80002ca8:	bfd1                	j	80002c7c <namex+0x58>
  len = path - s;
    80002caa:	40998633          	sub	a2,s3,s1
    80002cae:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002cb2:	099c5063          	bge	s8,s9,80002d32 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002cb6:	4639                	li	a2,14
    80002cb8:	85a6                	mv	a1,s1
    80002cba:	8556                	mv	a0,s5
    80002cbc:	d30fd0ef          	jal	800001ec <memmove>
    80002cc0:	84ce                	mv	s1,s3
  while(*path == '/')
    80002cc2:	0004c783          	lbu	a5,0(s1)
    80002cc6:	01279763          	bne	a5,s2,80002cd4 <namex+0xb0>
    path++;
    80002cca:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ccc:	0004c783          	lbu	a5,0(s1)
    80002cd0:	ff278de3          	beq	a5,s2,80002cca <namex+0xa6>
    ilock(ip);
    80002cd4:	8552                	mv	a0,s4
    80002cd6:	a3fff0ef          	jal	80002714 <ilock>
    if(ip->type != T_DIR){
    80002cda:	044a1783          	lh	a5,68(s4)
    80002cde:	f9779be3          	bne	a5,s7,80002c74 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002ce2:	000b0563          	beqz	s6,80002cec <namex+0xc8>
    80002ce6:	0004c783          	lbu	a5,0(s1)
    80002cea:	d7dd                	beqz	a5,80002c98 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002cec:	4601                	li	a2,0
    80002cee:	85d6                	mv	a1,s5
    80002cf0:	8552                	mv	a0,s4
    80002cf2:	e97ff0ef          	jal	80002b88 <dirlookup>
    80002cf6:	89aa                	mv	s3,a0
    80002cf8:	d545                	beqz	a0,80002ca0 <namex+0x7c>
    iunlockput(ip);
    80002cfa:	8552                	mv	a0,s4
    80002cfc:	c23ff0ef          	jal	8000291e <iunlockput>
    ip = next;
    80002d00:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d02:	0004c783          	lbu	a5,0(s1)
    80002d06:	01279763          	bne	a5,s2,80002d14 <namex+0xf0>
    path++;
    80002d0a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d0c:	0004c783          	lbu	a5,0(s1)
    80002d10:	ff278de3          	beq	a5,s2,80002d0a <namex+0xe6>
  if(*path == 0)
    80002d14:	cb8d                	beqz	a5,80002d46 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002d16:	0004c783          	lbu	a5,0(s1)
    80002d1a:	89a6                	mv	s3,s1
  len = path - s;
    80002d1c:	4c81                	li	s9,0
    80002d1e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002d20:	01278963          	beq	a5,s2,80002d32 <namex+0x10e>
    80002d24:	d3d9                	beqz	a5,80002caa <namex+0x86>
    path++;
    80002d26:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d28:	0009c783          	lbu	a5,0(s3)
    80002d2c:	ff279ce3          	bne	a5,s2,80002d24 <namex+0x100>
    80002d30:	bfad                	j	80002caa <namex+0x86>
    memmove(name, s, len);
    80002d32:	2601                	sext.w	a2,a2
    80002d34:	85a6                	mv	a1,s1
    80002d36:	8556                	mv	a0,s5
    80002d38:	cb4fd0ef          	jal	800001ec <memmove>
    name[len] = 0;
    80002d3c:	9cd6                	add	s9,s9,s5
    80002d3e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002d42:	84ce                	mv	s1,s3
    80002d44:	bfbd                	j	80002cc2 <namex+0x9e>
  if(nameiparent){
    80002d46:	f20b0be3          	beqz	s6,80002c7c <namex+0x58>
    iput(ip);
    80002d4a:	8552                	mv	a0,s4
    80002d4c:	b4bff0ef          	jal	80002896 <iput>
    return 0;
    80002d50:	4a01                	li	s4,0
    80002d52:	b72d                	j	80002c7c <namex+0x58>

0000000080002d54 <dirlink>:
{
    80002d54:	7139                	addi	sp,sp,-64
    80002d56:	fc06                	sd	ra,56(sp)
    80002d58:	f822                	sd	s0,48(sp)
    80002d5a:	f04a                	sd	s2,32(sp)
    80002d5c:	ec4e                	sd	s3,24(sp)
    80002d5e:	e852                	sd	s4,16(sp)
    80002d60:	0080                	addi	s0,sp,64
    80002d62:	892a                	mv	s2,a0
    80002d64:	8a2e                	mv	s4,a1
    80002d66:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002d68:	4601                	li	a2,0
    80002d6a:	e1fff0ef          	jal	80002b88 <dirlookup>
    80002d6e:	e535                	bnez	a0,80002dda <dirlink+0x86>
    80002d70:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d72:	04c92483          	lw	s1,76(s2)
    80002d76:	c48d                	beqz	s1,80002da0 <dirlink+0x4c>
    80002d78:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d7a:	4741                	li	a4,16
    80002d7c:	86a6                	mv	a3,s1
    80002d7e:	fc040613          	addi	a2,s0,-64
    80002d82:	4581                	li	a1,0
    80002d84:	854a                	mv	a0,s2
    80002d86:	be3ff0ef          	jal	80002968 <readi>
    80002d8a:	47c1                	li	a5,16
    80002d8c:	04f51b63          	bne	a0,a5,80002de2 <dirlink+0x8e>
    if(de.inum == 0)
    80002d90:	fc045783          	lhu	a5,-64(s0)
    80002d94:	c791                	beqz	a5,80002da0 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d96:	24c1                	addiw	s1,s1,16
    80002d98:	04c92783          	lw	a5,76(s2)
    80002d9c:	fcf4efe3          	bltu	s1,a5,80002d7a <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002da0:	4639                	li	a2,14
    80002da2:	85d2                	mv	a1,s4
    80002da4:	fc240513          	addi	a0,s0,-62
    80002da8:	ceafd0ef          	jal	80000292 <strncpy>
  de.inum = inum;
    80002dac:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002db0:	4741                	li	a4,16
    80002db2:	86a6                	mv	a3,s1
    80002db4:	fc040613          	addi	a2,s0,-64
    80002db8:	4581                	li	a1,0
    80002dba:	854a                	mv	a0,s2
    80002dbc:	ca9ff0ef          	jal	80002a64 <writei>
    80002dc0:	1541                	addi	a0,a0,-16
    80002dc2:	00a03533          	snez	a0,a0
    80002dc6:	40a00533          	neg	a0,a0
    80002dca:	74a2                	ld	s1,40(sp)
}
    80002dcc:	70e2                	ld	ra,56(sp)
    80002dce:	7442                	ld	s0,48(sp)
    80002dd0:	7902                	ld	s2,32(sp)
    80002dd2:	69e2                	ld	s3,24(sp)
    80002dd4:	6a42                	ld	s4,16(sp)
    80002dd6:	6121                	addi	sp,sp,64
    80002dd8:	8082                	ret
    iput(ip);
    80002dda:	abdff0ef          	jal	80002896 <iput>
    return -1;
    80002dde:	557d                	li	a0,-1
    80002de0:	b7f5                	j	80002dcc <dirlink+0x78>
      panic("dirlink read");
    80002de2:	00004517          	auipc	a0,0x4
    80002de6:	70650513          	addi	a0,a0,1798 # 800074e8 <etext+0x4e8>
    80002dea:	6d8020ef          	jal	800054c2 <panic>

0000000080002dee <namei>:

struct inode*
namei(char *path)
{
    80002dee:	1101                	addi	sp,sp,-32
    80002df0:	ec06                	sd	ra,24(sp)
    80002df2:	e822                	sd	s0,16(sp)
    80002df4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002df6:	fe040613          	addi	a2,s0,-32
    80002dfa:	4581                	li	a1,0
    80002dfc:	e29ff0ef          	jal	80002c24 <namex>
}
    80002e00:	60e2                	ld	ra,24(sp)
    80002e02:	6442                	ld	s0,16(sp)
    80002e04:	6105                	addi	sp,sp,32
    80002e06:	8082                	ret

0000000080002e08 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e08:	1141                	addi	sp,sp,-16
    80002e0a:	e406                	sd	ra,8(sp)
    80002e0c:	e022                	sd	s0,0(sp)
    80002e0e:	0800                	addi	s0,sp,16
    80002e10:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e12:	4585                	li	a1,1
    80002e14:	e11ff0ef          	jal	80002c24 <namex>
}
    80002e18:	60a2                	ld	ra,8(sp)
    80002e1a:	6402                	ld	s0,0(sp)
    80002e1c:	0141                	addi	sp,sp,16
    80002e1e:	8082                	ret

0000000080002e20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e20:	1101                	addi	sp,sp,-32
    80002e22:	ec06                	sd	ra,24(sp)
    80002e24:	e822                	sd	s0,16(sp)
    80002e26:	e426                	sd	s1,8(sp)
    80002e28:	e04a                	sd	s2,0(sp)
    80002e2a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e2c:	00017917          	auipc	s2,0x17
    80002e30:	47490913          	addi	s2,s2,1140 # 8001a2a0 <log>
    80002e34:	01892583          	lw	a1,24(s2)
    80002e38:	02892503          	lw	a0,40(s2)
    80002e3c:	9a0ff0ef          	jal	80001fdc <bread>
    80002e40:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e42:	02c92603          	lw	a2,44(s2)
    80002e46:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e48:	00c05f63          	blez	a2,80002e66 <write_head+0x46>
    80002e4c:	00017717          	auipc	a4,0x17
    80002e50:	48470713          	addi	a4,a4,1156 # 8001a2d0 <log+0x30>
    80002e54:	87aa                	mv	a5,a0
    80002e56:	060a                	slli	a2,a2,0x2
    80002e58:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002e5a:	4314                	lw	a3,0(a4)
    80002e5c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002e5e:	0711                	addi	a4,a4,4
    80002e60:	0791                	addi	a5,a5,4
    80002e62:	fec79ce3          	bne	a5,a2,80002e5a <write_head+0x3a>
  }
  bwrite(buf);
    80002e66:	8526                	mv	a0,s1
    80002e68:	a4aff0ef          	jal	800020b2 <bwrite>
  brelse(buf);
    80002e6c:	8526                	mv	a0,s1
    80002e6e:	a76ff0ef          	jal	800020e4 <brelse>
}
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	64a2                	ld	s1,8(sp)
    80002e78:	6902                	ld	s2,0(sp)
    80002e7a:	6105                	addi	sp,sp,32
    80002e7c:	8082                	ret

0000000080002e7e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e7e:	00017797          	auipc	a5,0x17
    80002e82:	44e7a783          	lw	a5,1102(a5) # 8001a2cc <log+0x2c>
    80002e86:	08f05f63          	blez	a5,80002f24 <install_trans+0xa6>
{
    80002e8a:	7139                	addi	sp,sp,-64
    80002e8c:	fc06                	sd	ra,56(sp)
    80002e8e:	f822                	sd	s0,48(sp)
    80002e90:	f426                	sd	s1,40(sp)
    80002e92:	f04a                	sd	s2,32(sp)
    80002e94:	ec4e                	sd	s3,24(sp)
    80002e96:	e852                	sd	s4,16(sp)
    80002e98:	e456                	sd	s5,8(sp)
    80002e9a:	e05a                	sd	s6,0(sp)
    80002e9c:	0080                	addi	s0,sp,64
    80002e9e:	8b2a                	mv	s6,a0
    80002ea0:	00017a97          	auipc	s5,0x17
    80002ea4:	430a8a93          	addi	s5,s5,1072 # 8001a2d0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ea8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002eaa:	00017997          	auipc	s3,0x17
    80002eae:	3f698993          	addi	s3,s3,1014 # 8001a2a0 <log>
    80002eb2:	a829                	j	80002ecc <install_trans+0x4e>
    brelse(lbuf);
    80002eb4:	854a                	mv	a0,s2
    80002eb6:	a2eff0ef          	jal	800020e4 <brelse>
    brelse(dbuf);
    80002eba:	8526                	mv	a0,s1
    80002ebc:	a28ff0ef          	jal	800020e4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ec0:	2a05                	addiw	s4,s4,1
    80002ec2:	0a91                	addi	s5,s5,4
    80002ec4:	02c9a783          	lw	a5,44(s3)
    80002ec8:	04fa5463          	bge	s4,a5,80002f10 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ecc:	0189a583          	lw	a1,24(s3)
    80002ed0:	014585bb          	addw	a1,a1,s4
    80002ed4:	2585                	addiw	a1,a1,1
    80002ed6:	0289a503          	lw	a0,40(s3)
    80002eda:	902ff0ef          	jal	80001fdc <bread>
    80002ede:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002ee0:	000aa583          	lw	a1,0(s5)
    80002ee4:	0289a503          	lw	a0,40(s3)
    80002ee8:	8f4ff0ef          	jal	80001fdc <bread>
    80002eec:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002eee:	40000613          	li	a2,1024
    80002ef2:	05890593          	addi	a1,s2,88
    80002ef6:	05850513          	addi	a0,a0,88
    80002efa:	af2fd0ef          	jal	800001ec <memmove>
    bwrite(dbuf);  // write dst to disk
    80002efe:	8526                	mv	a0,s1
    80002f00:	9b2ff0ef          	jal	800020b2 <bwrite>
    if(recovering == 0)
    80002f04:	fa0b18e3          	bnez	s6,80002eb4 <install_trans+0x36>
      bunpin(dbuf);
    80002f08:	8526                	mv	a0,s1
    80002f0a:	a96ff0ef          	jal	800021a0 <bunpin>
    80002f0e:	b75d                	j	80002eb4 <install_trans+0x36>
}
    80002f10:	70e2                	ld	ra,56(sp)
    80002f12:	7442                	ld	s0,48(sp)
    80002f14:	74a2                	ld	s1,40(sp)
    80002f16:	7902                	ld	s2,32(sp)
    80002f18:	69e2                	ld	s3,24(sp)
    80002f1a:	6a42                	ld	s4,16(sp)
    80002f1c:	6aa2                	ld	s5,8(sp)
    80002f1e:	6b02                	ld	s6,0(sp)
    80002f20:	6121                	addi	sp,sp,64
    80002f22:	8082                	ret
    80002f24:	8082                	ret

0000000080002f26 <initlog>:
{
    80002f26:	7179                	addi	sp,sp,-48
    80002f28:	f406                	sd	ra,40(sp)
    80002f2a:	f022                	sd	s0,32(sp)
    80002f2c:	ec26                	sd	s1,24(sp)
    80002f2e:	e84a                	sd	s2,16(sp)
    80002f30:	e44e                	sd	s3,8(sp)
    80002f32:	1800                	addi	s0,sp,48
    80002f34:	892a                	mv	s2,a0
    80002f36:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f38:	00017497          	auipc	s1,0x17
    80002f3c:	36848493          	addi	s1,s1,872 # 8001a2a0 <log>
    80002f40:	00004597          	auipc	a1,0x4
    80002f44:	5b858593          	addi	a1,a1,1464 # 800074f8 <etext+0x4f8>
    80002f48:	8526                	mv	a0,s1
    80002f4a:	027020ef          	jal	80005770 <initlock>
  log.start = sb->logstart;
    80002f4e:	0149a583          	lw	a1,20(s3)
    80002f52:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002f54:	0109a783          	lw	a5,16(s3)
    80002f58:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002f5a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002f5e:	854a                	mv	a0,s2
    80002f60:	87cff0ef          	jal	80001fdc <bread>
  log.lh.n = lh->n;
    80002f64:	4d30                	lw	a2,88(a0)
    80002f66:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002f68:	00c05f63          	blez	a2,80002f86 <initlog+0x60>
    80002f6c:	87aa                	mv	a5,a0
    80002f6e:	00017717          	auipc	a4,0x17
    80002f72:	36270713          	addi	a4,a4,866 # 8001a2d0 <log+0x30>
    80002f76:	060a                	slli	a2,a2,0x2
    80002f78:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002f7a:	4ff4                	lw	a3,92(a5)
    80002f7c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002f7e:	0791                	addi	a5,a5,4
    80002f80:	0711                	addi	a4,a4,4
    80002f82:	fec79ce3          	bne	a5,a2,80002f7a <initlog+0x54>
  brelse(buf);
    80002f86:	95eff0ef          	jal	800020e4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002f8a:	4505                	li	a0,1
    80002f8c:	ef3ff0ef          	jal	80002e7e <install_trans>
  log.lh.n = 0;
    80002f90:	00017797          	auipc	a5,0x17
    80002f94:	3207ae23          	sw	zero,828(a5) # 8001a2cc <log+0x2c>
  write_head(); // clear the log
    80002f98:	e89ff0ef          	jal	80002e20 <write_head>
}
    80002f9c:	70a2                	ld	ra,40(sp)
    80002f9e:	7402                	ld	s0,32(sp)
    80002fa0:	64e2                	ld	s1,24(sp)
    80002fa2:	6942                	ld	s2,16(sp)
    80002fa4:	69a2                	ld	s3,8(sp)
    80002fa6:	6145                	addi	sp,sp,48
    80002fa8:	8082                	ret

0000000080002faa <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002faa:	1101                	addi	sp,sp,-32
    80002fac:	ec06                	sd	ra,24(sp)
    80002fae:	e822                	sd	s0,16(sp)
    80002fb0:	e426                	sd	s1,8(sp)
    80002fb2:	e04a                	sd	s2,0(sp)
    80002fb4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002fb6:	00017517          	auipc	a0,0x17
    80002fba:	2ea50513          	addi	a0,a0,746 # 8001a2a0 <log>
    80002fbe:	033020ef          	jal	800057f0 <acquire>
  while(1){
    if(log.committing){
    80002fc2:	00017497          	auipc	s1,0x17
    80002fc6:	2de48493          	addi	s1,s1,734 # 8001a2a0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002fca:	4979                	li	s2,30
    80002fcc:	a029                	j	80002fd6 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002fce:	85a6                	mv	a1,s1
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	ba4fe0ef          	jal	80001376 <sleep>
    if(log.committing){
    80002fd6:	50dc                	lw	a5,36(s1)
    80002fd8:	fbfd                	bnez	a5,80002fce <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002fda:	5098                	lw	a4,32(s1)
    80002fdc:	2705                	addiw	a4,a4,1
    80002fde:	0027179b          	slliw	a5,a4,0x2
    80002fe2:	9fb9                	addw	a5,a5,a4
    80002fe4:	0017979b          	slliw	a5,a5,0x1
    80002fe8:	54d4                	lw	a3,44(s1)
    80002fea:	9fb5                	addw	a5,a5,a3
    80002fec:	00f95763          	bge	s2,a5,80002ffa <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002ff0:	85a6                	mv	a1,s1
    80002ff2:	8526                	mv	a0,s1
    80002ff4:	b82fe0ef          	jal	80001376 <sleep>
    80002ff8:	bff9                	j	80002fd6 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002ffa:	00017517          	auipc	a0,0x17
    80002ffe:	2a650513          	addi	a0,a0,678 # 8001a2a0 <log>
    80003002:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003004:	085020ef          	jal	80005888 <release>
      break;
    }
  }
}
    80003008:	60e2                	ld	ra,24(sp)
    8000300a:	6442                	ld	s0,16(sp)
    8000300c:	64a2                	ld	s1,8(sp)
    8000300e:	6902                	ld	s2,0(sp)
    80003010:	6105                	addi	sp,sp,32
    80003012:	8082                	ret

0000000080003014 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003014:	7139                	addi	sp,sp,-64
    80003016:	fc06                	sd	ra,56(sp)
    80003018:	f822                	sd	s0,48(sp)
    8000301a:	f426                	sd	s1,40(sp)
    8000301c:	f04a                	sd	s2,32(sp)
    8000301e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003020:	00017497          	auipc	s1,0x17
    80003024:	28048493          	addi	s1,s1,640 # 8001a2a0 <log>
    80003028:	8526                	mv	a0,s1
    8000302a:	7c6020ef          	jal	800057f0 <acquire>
  log.outstanding -= 1;
    8000302e:	509c                	lw	a5,32(s1)
    80003030:	37fd                	addiw	a5,a5,-1
    80003032:	0007891b          	sext.w	s2,a5
    80003036:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003038:	50dc                	lw	a5,36(s1)
    8000303a:	ef9d                	bnez	a5,80003078 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000303c:	04091763          	bnez	s2,8000308a <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003040:	00017497          	auipc	s1,0x17
    80003044:	26048493          	addi	s1,s1,608 # 8001a2a0 <log>
    80003048:	4785                	li	a5,1
    8000304a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000304c:	8526                	mv	a0,s1
    8000304e:	03b020ef          	jal	80005888 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003052:	54dc                	lw	a5,44(s1)
    80003054:	04f04b63          	bgtz	a5,800030aa <end_op+0x96>
    acquire(&log.lock);
    80003058:	00017497          	auipc	s1,0x17
    8000305c:	24848493          	addi	s1,s1,584 # 8001a2a0 <log>
    80003060:	8526                	mv	a0,s1
    80003062:	78e020ef          	jal	800057f0 <acquire>
    log.committing = 0;
    80003066:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000306a:	8526                	mv	a0,s1
    8000306c:	b56fe0ef          	jal	800013c2 <wakeup>
    release(&log.lock);
    80003070:	8526                	mv	a0,s1
    80003072:	017020ef          	jal	80005888 <release>
}
    80003076:	a025                	j	8000309e <end_op+0x8a>
    80003078:	ec4e                	sd	s3,24(sp)
    8000307a:	e852                	sd	s4,16(sp)
    8000307c:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000307e:	00004517          	auipc	a0,0x4
    80003082:	48250513          	addi	a0,a0,1154 # 80007500 <etext+0x500>
    80003086:	43c020ef          	jal	800054c2 <panic>
    wakeup(&log);
    8000308a:	00017497          	auipc	s1,0x17
    8000308e:	21648493          	addi	s1,s1,534 # 8001a2a0 <log>
    80003092:	8526                	mv	a0,s1
    80003094:	b2efe0ef          	jal	800013c2 <wakeup>
  release(&log.lock);
    80003098:	8526                	mv	a0,s1
    8000309a:	7ee020ef          	jal	80005888 <release>
}
    8000309e:	70e2                	ld	ra,56(sp)
    800030a0:	7442                	ld	s0,48(sp)
    800030a2:	74a2                	ld	s1,40(sp)
    800030a4:	7902                	ld	s2,32(sp)
    800030a6:	6121                	addi	sp,sp,64
    800030a8:	8082                	ret
    800030aa:	ec4e                	sd	s3,24(sp)
    800030ac:	e852                	sd	s4,16(sp)
    800030ae:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800030b0:	00017a97          	auipc	s5,0x17
    800030b4:	220a8a93          	addi	s5,s5,544 # 8001a2d0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800030b8:	00017a17          	auipc	s4,0x17
    800030bc:	1e8a0a13          	addi	s4,s4,488 # 8001a2a0 <log>
    800030c0:	018a2583          	lw	a1,24(s4)
    800030c4:	012585bb          	addw	a1,a1,s2
    800030c8:	2585                	addiw	a1,a1,1
    800030ca:	028a2503          	lw	a0,40(s4)
    800030ce:	f0ffe0ef          	jal	80001fdc <bread>
    800030d2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800030d4:	000aa583          	lw	a1,0(s5)
    800030d8:	028a2503          	lw	a0,40(s4)
    800030dc:	f01fe0ef          	jal	80001fdc <bread>
    800030e0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800030e2:	40000613          	li	a2,1024
    800030e6:	05850593          	addi	a1,a0,88
    800030ea:	05848513          	addi	a0,s1,88
    800030ee:	8fefd0ef          	jal	800001ec <memmove>
    bwrite(to);  // write the log
    800030f2:	8526                	mv	a0,s1
    800030f4:	fbffe0ef          	jal	800020b2 <bwrite>
    brelse(from);
    800030f8:	854e                	mv	a0,s3
    800030fa:	febfe0ef          	jal	800020e4 <brelse>
    brelse(to);
    800030fe:	8526                	mv	a0,s1
    80003100:	fe5fe0ef          	jal	800020e4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003104:	2905                	addiw	s2,s2,1
    80003106:	0a91                	addi	s5,s5,4
    80003108:	02ca2783          	lw	a5,44(s4)
    8000310c:	faf94ae3          	blt	s2,a5,800030c0 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003110:	d11ff0ef          	jal	80002e20 <write_head>
    install_trans(0); // Now install writes to home locations
    80003114:	4501                	li	a0,0
    80003116:	d69ff0ef          	jal	80002e7e <install_trans>
    log.lh.n = 0;
    8000311a:	00017797          	auipc	a5,0x17
    8000311e:	1a07a923          	sw	zero,434(a5) # 8001a2cc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003122:	cffff0ef          	jal	80002e20 <write_head>
    80003126:	69e2                	ld	s3,24(sp)
    80003128:	6a42                	ld	s4,16(sp)
    8000312a:	6aa2                	ld	s5,8(sp)
    8000312c:	b735                	j	80003058 <end_op+0x44>

000000008000312e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000312e:	1101                	addi	sp,sp,-32
    80003130:	ec06                	sd	ra,24(sp)
    80003132:	e822                	sd	s0,16(sp)
    80003134:	e426                	sd	s1,8(sp)
    80003136:	e04a                	sd	s2,0(sp)
    80003138:	1000                	addi	s0,sp,32
    8000313a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000313c:	00017917          	auipc	s2,0x17
    80003140:	16490913          	addi	s2,s2,356 # 8001a2a0 <log>
    80003144:	854a                	mv	a0,s2
    80003146:	6aa020ef          	jal	800057f0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000314a:	02c92603          	lw	a2,44(s2)
    8000314e:	47f5                	li	a5,29
    80003150:	06c7c363          	blt	a5,a2,800031b6 <log_write+0x88>
    80003154:	00017797          	auipc	a5,0x17
    80003158:	1687a783          	lw	a5,360(a5) # 8001a2bc <log+0x1c>
    8000315c:	37fd                	addiw	a5,a5,-1
    8000315e:	04f65c63          	bge	a2,a5,800031b6 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003162:	00017797          	auipc	a5,0x17
    80003166:	15e7a783          	lw	a5,350(a5) # 8001a2c0 <log+0x20>
    8000316a:	04f05c63          	blez	a5,800031c2 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000316e:	4781                	li	a5,0
    80003170:	04c05f63          	blez	a2,800031ce <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003174:	44cc                	lw	a1,12(s1)
    80003176:	00017717          	auipc	a4,0x17
    8000317a:	15a70713          	addi	a4,a4,346 # 8001a2d0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000317e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003180:	4314                	lw	a3,0(a4)
    80003182:	04b68663          	beq	a3,a1,800031ce <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003186:	2785                	addiw	a5,a5,1
    80003188:	0711                	addi	a4,a4,4
    8000318a:	fef61be3          	bne	a2,a5,80003180 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000318e:	0621                	addi	a2,a2,8
    80003190:	060a                	slli	a2,a2,0x2
    80003192:	00017797          	auipc	a5,0x17
    80003196:	10e78793          	addi	a5,a5,270 # 8001a2a0 <log>
    8000319a:	97b2                	add	a5,a5,a2
    8000319c:	44d8                	lw	a4,12(s1)
    8000319e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800031a0:	8526                	mv	a0,s1
    800031a2:	fcbfe0ef          	jal	8000216c <bpin>
    log.lh.n++;
    800031a6:	00017717          	auipc	a4,0x17
    800031aa:	0fa70713          	addi	a4,a4,250 # 8001a2a0 <log>
    800031ae:	575c                	lw	a5,44(a4)
    800031b0:	2785                	addiw	a5,a5,1
    800031b2:	d75c                	sw	a5,44(a4)
    800031b4:	a80d                	j	800031e6 <log_write+0xb8>
    panic("too big a transaction");
    800031b6:	00004517          	auipc	a0,0x4
    800031ba:	35a50513          	addi	a0,a0,858 # 80007510 <etext+0x510>
    800031be:	304020ef          	jal	800054c2 <panic>
    panic("log_write outside of trans");
    800031c2:	00004517          	auipc	a0,0x4
    800031c6:	36650513          	addi	a0,a0,870 # 80007528 <etext+0x528>
    800031ca:	2f8020ef          	jal	800054c2 <panic>
  log.lh.block[i] = b->blockno;
    800031ce:	00878693          	addi	a3,a5,8
    800031d2:	068a                	slli	a3,a3,0x2
    800031d4:	00017717          	auipc	a4,0x17
    800031d8:	0cc70713          	addi	a4,a4,204 # 8001a2a0 <log>
    800031dc:	9736                	add	a4,a4,a3
    800031de:	44d4                	lw	a3,12(s1)
    800031e0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800031e2:	faf60fe3          	beq	a2,a5,800031a0 <log_write+0x72>
  }
  release(&log.lock);
    800031e6:	00017517          	auipc	a0,0x17
    800031ea:	0ba50513          	addi	a0,a0,186 # 8001a2a0 <log>
    800031ee:	69a020ef          	jal	80005888 <release>
}
    800031f2:	60e2                	ld	ra,24(sp)
    800031f4:	6442                	ld	s0,16(sp)
    800031f6:	64a2                	ld	s1,8(sp)
    800031f8:	6902                	ld	s2,0(sp)
    800031fa:	6105                	addi	sp,sp,32
    800031fc:	8082                	ret

00000000800031fe <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800031fe:	1101                	addi	sp,sp,-32
    80003200:	ec06                	sd	ra,24(sp)
    80003202:	e822                	sd	s0,16(sp)
    80003204:	e426                	sd	s1,8(sp)
    80003206:	e04a                	sd	s2,0(sp)
    80003208:	1000                	addi	s0,sp,32
    8000320a:	84aa                	mv	s1,a0
    8000320c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000320e:	00004597          	auipc	a1,0x4
    80003212:	33a58593          	addi	a1,a1,826 # 80007548 <etext+0x548>
    80003216:	0521                	addi	a0,a0,8
    80003218:	558020ef          	jal	80005770 <initlock>
  lk->name = name;
    8000321c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003220:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003224:	0204a423          	sw	zero,40(s1)
}
    80003228:	60e2                	ld	ra,24(sp)
    8000322a:	6442                	ld	s0,16(sp)
    8000322c:	64a2                	ld	s1,8(sp)
    8000322e:	6902                	ld	s2,0(sp)
    80003230:	6105                	addi	sp,sp,32
    80003232:	8082                	ret

0000000080003234 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003234:	1101                	addi	sp,sp,-32
    80003236:	ec06                	sd	ra,24(sp)
    80003238:	e822                	sd	s0,16(sp)
    8000323a:	e426                	sd	s1,8(sp)
    8000323c:	e04a                	sd	s2,0(sp)
    8000323e:	1000                	addi	s0,sp,32
    80003240:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003242:	00850913          	addi	s2,a0,8
    80003246:	854a                	mv	a0,s2
    80003248:	5a8020ef          	jal	800057f0 <acquire>
  while (lk->locked) {
    8000324c:	409c                	lw	a5,0(s1)
    8000324e:	c799                	beqz	a5,8000325c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003250:	85ca                	mv	a1,s2
    80003252:	8526                	mv	a0,s1
    80003254:	922fe0ef          	jal	80001376 <sleep>
  while (lk->locked) {
    80003258:	409c                	lw	a5,0(s1)
    8000325a:	fbfd                	bnez	a5,80003250 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000325c:	4785                	li	a5,1
    8000325e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003260:	b49fd0ef          	jal	80000da8 <myproc>
    80003264:	591c                	lw	a5,48(a0)
    80003266:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003268:	854a                	mv	a0,s2
    8000326a:	61e020ef          	jal	80005888 <release>
}
    8000326e:	60e2                	ld	ra,24(sp)
    80003270:	6442                	ld	s0,16(sp)
    80003272:	64a2                	ld	s1,8(sp)
    80003274:	6902                	ld	s2,0(sp)
    80003276:	6105                	addi	sp,sp,32
    80003278:	8082                	ret

000000008000327a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000327a:	1101                	addi	sp,sp,-32
    8000327c:	ec06                	sd	ra,24(sp)
    8000327e:	e822                	sd	s0,16(sp)
    80003280:	e426                	sd	s1,8(sp)
    80003282:	e04a                	sd	s2,0(sp)
    80003284:	1000                	addi	s0,sp,32
    80003286:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003288:	00850913          	addi	s2,a0,8
    8000328c:	854a                	mv	a0,s2
    8000328e:	562020ef          	jal	800057f0 <acquire>
  lk->locked = 0;
    80003292:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003296:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000329a:	8526                	mv	a0,s1
    8000329c:	926fe0ef          	jal	800013c2 <wakeup>
  release(&lk->lk);
    800032a0:	854a                	mv	a0,s2
    800032a2:	5e6020ef          	jal	80005888 <release>
}
    800032a6:	60e2                	ld	ra,24(sp)
    800032a8:	6442                	ld	s0,16(sp)
    800032aa:	64a2                	ld	s1,8(sp)
    800032ac:	6902                	ld	s2,0(sp)
    800032ae:	6105                	addi	sp,sp,32
    800032b0:	8082                	ret

00000000800032b2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800032b2:	7179                	addi	sp,sp,-48
    800032b4:	f406                	sd	ra,40(sp)
    800032b6:	f022                	sd	s0,32(sp)
    800032b8:	ec26                	sd	s1,24(sp)
    800032ba:	e84a                	sd	s2,16(sp)
    800032bc:	1800                	addi	s0,sp,48
    800032be:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800032c0:	00850913          	addi	s2,a0,8
    800032c4:	854a                	mv	a0,s2
    800032c6:	52a020ef          	jal	800057f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800032ca:	409c                	lw	a5,0(s1)
    800032cc:	ef81                	bnez	a5,800032e4 <holdingsleep+0x32>
    800032ce:	4481                	li	s1,0
  release(&lk->lk);
    800032d0:	854a                	mv	a0,s2
    800032d2:	5b6020ef          	jal	80005888 <release>
  return r;
}
    800032d6:	8526                	mv	a0,s1
    800032d8:	70a2                	ld	ra,40(sp)
    800032da:	7402                	ld	s0,32(sp)
    800032dc:	64e2                	ld	s1,24(sp)
    800032de:	6942                	ld	s2,16(sp)
    800032e0:	6145                	addi	sp,sp,48
    800032e2:	8082                	ret
    800032e4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800032e6:	0284a983          	lw	s3,40(s1)
    800032ea:	abffd0ef          	jal	80000da8 <myproc>
    800032ee:	5904                	lw	s1,48(a0)
    800032f0:	413484b3          	sub	s1,s1,s3
    800032f4:	0014b493          	seqz	s1,s1
    800032f8:	69a2                	ld	s3,8(sp)
    800032fa:	bfd9                	j	800032d0 <holdingsleep+0x1e>

00000000800032fc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800032fc:	1141                	addi	sp,sp,-16
    800032fe:	e406                	sd	ra,8(sp)
    80003300:	e022                	sd	s0,0(sp)
    80003302:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003304:	00004597          	auipc	a1,0x4
    80003308:	25458593          	addi	a1,a1,596 # 80007558 <etext+0x558>
    8000330c:	00017517          	auipc	a0,0x17
    80003310:	0dc50513          	addi	a0,a0,220 # 8001a3e8 <ftable>
    80003314:	45c020ef          	jal	80005770 <initlock>
}
    80003318:	60a2                	ld	ra,8(sp)
    8000331a:	6402                	ld	s0,0(sp)
    8000331c:	0141                	addi	sp,sp,16
    8000331e:	8082                	ret

0000000080003320 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003320:	1101                	addi	sp,sp,-32
    80003322:	ec06                	sd	ra,24(sp)
    80003324:	e822                	sd	s0,16(sp)
    80003326:	e426                	sd	s1,8(sp)
    80003328:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000332a:	00017517          	auipc	a0,0x17
    8000332e:	0be50513          	addi	a0,a0,190 # 8001a3e8 <ftable>
    80003332:	4be020ef          	jal	800057f0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003336:	00017497          	auipc	s1,0x17
    8000333a:	0ca48493          	addi	s1,s1,202 # 8001a400 <ftable+0x18>
    8000333e:	00018717          	auipc	a4,0x18
    80003342:	06270713          	addi	a4,a4,98 # 8001b3a0 <disk>
    if(f->ref == 0){
    80003346:	40dc                	lw	a5,4(s1)
    80003348:	cf89                	beqz	a5,80003362 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000334a:	02848493          	addi	s1,s1,40
    8000334e:	fee49ce3          	bne	s1,a4,80003346 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003352:	00017517          	auipc	a0,0x17
    80003356:	09650513          	addi	a0,a0,150 # 8001a3e8 <ftable>
    8000335a:	52e020ef          	jal	80005888 <release>
  return 0;
    8000335e:	4481                	li	s1,0
    80003360:	a809                	j	80003372 <filealloc+0x52>
      f->ref = 1;
    80003362:	4785                	li	a5,1
    80003364:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003366:	00017517          	auipc	a0,0x17
    8000336a:	08250513          	addi	a0,a0,130 # 8001a3e8 <ftable>
    8000336e:	51a020ef          	jal	80005888 <release>
}
    80003372:	8526                	mv	a0,s1
    80003374:	60e2                	ld	ra,24(sp)
    80003376:	6442                	ld	s0,16(sp)
    80003378:	64a2                	ld	s1,8(sp)
    8000337a:	6105                	addi	sp,sp,32
    8000337c:	8082                	ret

000000008000337e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000337e:	1101                	addi	sp,sp,-32
    80003380:	ec06                	sd	ra,24(sp)
    80003382:	e822                	sd	s0,16(sp)
    80003384:	e426                	sd	s1,8(sp)
    80003386:	1000                	addi	s0,sp,32
    80003388:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000338a:	00017517          	auipc	a0,0x17
    8000338e:	05e50513          	addi	a0,a0,94 # 8001a3e8 <ftable>
    80003392:	45e020ef          	jal	800057f0 <acquire>
  if(f->ref < 1)
    80003396:	40dc                	lw	a5,4(s1)
    80003398:	02f05063          	blez	a5,800033b8 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000339c:	2785                	addiw	a5,a5,1
    8000339e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800033a0:	00017517          	auipc	a0,0x17
    800033a4:	04850513          	addi	a0,a0,72 # 8001a3e8 <ftable>
    800033a8:	4e0020ef          	jal	80005888 <release>
  return f;
}
    800033ac:	8526                	mv	a0,s1
    800033ae:	60e2                	ld	ra,24(sp)
    800033b0:	6442                	ld	s0,16(sp)
    800033b2:	64a2                	ld	s1,8(sp)
    800033b4:	6105                	addi	sp,sp,32
    800033b6:	8082                	ret
    panic("filedup");
    800033b8:	00004517          	auipc	a0,0x4
    800033bc:	1a850513          	addi	a0,a0,424 # 80007560 <etext+0x560>
    800033c0:	102020ef          	jal	800054c2 <panic>

00000000800033c4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800033c4:	7139                	addi	sp,sp,-64
    800033c6:	fc06                	sd	ra,56(sp)
    800033c8:	f822                	sd	s0,48(sp)
    800033ca:	f426                	sd	s1,40(sp)
    800033cc:	0080                	addi	s0,sp,64
    800033ce:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800033d0:	00017517          	auipc	a0,0x17
    800033d4:	01850513          	addi	a0,a0,24 # 8001a3e8 <ftable>
    800033d8:	418020ef          	jal	800057f0 <acquire>
  if(f->ref < 1)
    800033dc:	40dc                	lw	a5,4(s1)
    800033de:	04f05a63          	blez	a5,80003432 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800033e2:	37fd                	addiw	a5,a5,-1
    800033e4:	0007871b          	sext.w	a4,a5
    800033e8:	c0dc                	sw	a5,4(s1)
    800033ea:	04e04e63          	bgtz	a4,80003446 <fileclose+0x82>
    800033ee:	f04a                	sd	s2,32(sp)
    800033f0:	ec4e                	sd	s3,24(sp)
    800033f2:	e852                	sd	s4,16(sp)
    800033f4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800033f6:	0004a903          	lw	s2,0(s1)
    800033fa:	0094ca83          	lbu	s5,9(s1)
    800033fe:	0104ba03          	ld	s4,16(s1)
    80003402:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003406:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000340a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000340e:	00017517          	auipc	a0,0x17
    80003412:	fda50513          	addi	a0,a0,-38 # 8001a3e8 <ftable>
    80003416:	472020ef          	jal	80005888 <release>

  if(ff.type == FD_PIPE){
    8000341a:	4785                	li	a5,1
    8000341c:	04f90063          	beq	s2,a5,8000345c <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003420:	3979                	addiw	s2,s2,-2
    80003422:	4785                	li	a5,1
    80003424:	0527f563          	bgeu	a5,s2,8000346e <fileclose+0xaa>
    80003428:	7902                	ld	s2,32(sp)
    8000342a:	69e2                	ld	s3,24(sp)
    8000342c:	6a42                	ld	s4,16(sp)
    8000342e:	6aa2                	ld	s5,8(sp)
    80003430:	a00d                	j	80003452 <fileclose+0x8e>
    80003432:	f04a                	sd	s2,32(sp)
    80003434:	ec4e                	sd	s3,24(sp)
    80003436:	e852                	sd	s4,16(sp)
    80003438:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000343a:	00004517          	auipc	a0,0x4
    8000343e:	12e50513          	addi	a0,a0,302 # 80007568 <etext+0x568>
    80003442:	080020ef          	jal	800054c2 <panic>
    release(&ftable.lock);
    80003446:	00017517          	auipc	a0,0x17
    8000344a:	fa250513          	addi	a0,a0,-94 # 8001a3e8 <ftable>
    8000344e:	43a020ef          	jal	80005888 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003452:	70e2                	ld	ra,56(sp)
    80003454:	7442                	ld	s0,48(sp)
    80003456:	74a2                	ld	s1,40(sp)
    80003458:	6121                	addi	sp,sp,64
    8000345a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000345c:	85d6                	mv	a1,s5
    8000345e:	8552                	mv	a0,s4
    80003460:	336000ef          	jal	80003796 <pipeclose>
    80003464:	7902                	ld	s2,32(sp)
    80003466:	69e2                	ld	s3,24(sp)
    80003468:	6a42                	ld	s4,16(sp)
    8000346a:	6aa2                	ld	s5,8(sp)
    8000346c:	b7dd                	j	80003452 <fileclose+0x8e>
    begin_op();
    8000346e:	b3dff0ef          	jal	80002faa <begin_op>
    iput(ff.ip);
    80003472:	854e                	mv	a0,s3
    80003474:	c22ff0ef          	jal	80002896 <iput>
    end_op();
    80003478:	b9dff0ef          	jal	80003014 <end_op>
    8000347c:	7902                	ld	s2,32(sp)
    8000347e:	69e2                	ld	s3,24(sp)
    80003480:	6a42                	ld	s4,16(sp)
    80003482:	6aa2                	ld	s5,8(sp)
    80003484:	b7f9                	j	80003452 <fileclose+0x8e>

0000000080003486 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003486:	715d                	addi	sp,sp,-80
    80003488:	e486                	sd	ra,72(sp)
    8000348a:	e0a2                	sd	s0,64(sp)
    8000348c:	fc26                	sd	s1,56(sp)
    8000348e:	f44e                	sd	s3,40(sp)
    80003490:	0880                	addi	s0,sp,80
    80003492:	84aa                	mv	s1,a0
    80003494:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003496:	913fd0ef          	jal	80000da8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000349a:	409c                	lw	a5,0(s1)
    8000349c:	37f9                	addiw	a5,a5,-2
    8000349e:	4705                	li	a4,1
    800034a0:	04f76063          	bltu	a4,a5,800034e0 <filestat+0x5a>
    800034a4:	f84a                	sd	s2,48(sp)
    800034a6:	892a                	mv	s2,a0
    ilock(f->ip);
    800034a8:	6c88                	ld	a0,24(s1)
    800034aa:	a6aff0ef          	jal	80002714 <ilock>
    stati(f->ip, &st);
    800034ae:	fb840593          	addi	a1,s0,-72
    800034b2:	6c88                	ld	a0,24(s1)
    800034b4:	c8aff0ef          	jal	8000293e <stati>
    iunlock(f->ip);
    800034b8:	6c88                	ld	a0,24(s1)
    800034ba:	b08ff0ef          	jal	800027c2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800034be:	46e1                	li	a3,24
    800034c0:	fb840613          	addi	a2,s0,-72
    800034c4:	85ce                	mv	a1,s3
    800034c6:	05093503          	ld	a0,80(s2)
    800034ca:	d50fd0ef          	jal	80000a1a <copyout>
    800034ce:	41f5551b          	sraiw	a0,a0,0x1f
    800034d2:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800034d4:	60a6                	ld	ra,72(sp)
    800034d6:	6406                	ld	s0,64(sp)
    800034d8:	74e2                	ld	s1,56(sp)
    800034da:	79a2                	ld	s3,40(sp)
    800034dc:	6161                	addi	sp,sp,80
    800034de:	8082                	ret
  return -1;
    800034e0:	557d                	li	a0,-1
    800034e2:	bfcd                	j	800034d4 <filestat+0x4e>

00000000800034e4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800034e4:	7179                	addi	sp,sp,-48
    800034e6:	f406                	sd	ra,40(sp)
    800034e8:	f022                	sd	s0,32(sp)
    800034ea:	e84a                	sd	s2,16(sp)
    800034ec:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800034ee:	00854783          	lbu	a5,8(a0)
    800034f2:	cfd1                	beqz	a5,8000358e <fileread+0xaa>
    800034f4:	ec26                	sd	s1,24(sp)
    800034f6:	e44e                	sd	s3,8(sp)
    800034f8:	84aa                	mv	s1,a0
    800034fa:	89ae                	mv	s3,a1
    800034fc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800034fe:	411c                	lw	a5,0(a0)
    80003500:	4705                	li	a4,1
    80003502:	04e78363          	beq	a5,a4,80003548 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003506:	470d                	li	a4,3
    80003508:	04e78763          	beq	a5,a4,80003556 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000350c:	4709                	li	a4,2
    8000350e:	06e79a63          	bne	a5,a4,80003582 <fileread+0x9e>
    ilock(f->ip);
    80003512:	6d08                	ld	a0,24(a0)
    80003514:	a00ff0ef          	jal	80002714 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003518:	874a                	mv	a4,s2
    8000351a:	5094                	lw	a3,32(s1)
    8000351c:	864e                	mv	a2,s3
    8000351e:	4585                	li	a1,1
    80003520:	6c88                	ld	a0,24(s1)
    80003522:	c46ff0ef          	jal	80002968 <readi>
    80003526:	892a                	mv	s2,a0
    80003528:	00a05563          	blez	a0,80003532 <fileread+0x4e>
      f->off += r;
    8000352c:	509c                	lw	a5,32(s1)
    8000352e:	9fa9                	addw	a5,a5,a0
    80003530:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003532:	6c88                	ld	a0,24(s1)
    80003534:	a8eff0ef          	jal	800027c2 <iunlock>
    80003538:	64e2                	ld	s1,24(sp)
    8000353a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000353c:	854a                	mv	a0,s2
    8000353e:	70a2                	ld	ra,40(sp)
    80003540:	7402                	ld	s0,32(sp)
    80003542:	6942                	ld	s2,16(sp)
    80003544:	6145                	addi	sp,sp,48
    80003546:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003548:	6908                	ld	a0,16(a0)
    8000354a:	388000ef          	jal	800038d2 <piperead>
    8000354e:	892a                	mv	s2,a0
    80003550:	64e2                	ld	s1,24(sp)
    80003552:	69a2                	ld	s3,8(sp)
    80003554:	b7e5                	j	8000353c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003556:	02451783          	lh	a5,36(a0)
    8000355a:	03079693          	slli	a3,a5,0x30
    8000355e:	92c1                	srli	a3,a3,0x30
    80003560:	4725                	li	a4,9
    80003562:	02d76863          	bltu	a4,a3,80003592 <fileread+0xae>
    80003566:	0792                	slli	a5,a5,0x4
    80003568:	00017717          	auipc	a4,0x17
    8000356c:	de070713          	addi	a4,a4,-544 # 8001a348 <devsw>
    80003570:	97ba                	add	a5,a5,a4
    80003572:	639c                	ld	a5,0(a5)
    80003574:	c39d                	beqz	a5,8000359a <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003576:	4505                	li	a0,1
    80003578:	9782                	jalr	a5
    8000357a:	892a                	mv	s2,a0
    8000357c:	64e2                	ld	s1,24(sp)
    8000357e:	69a2                	ld	s3,8(sp)
    80003580:	bf75                	j	8000353c <fileread+0x58>
    panic("fileread");
    80003582:	00004517          	auipc	a0,0x4
    80003586:	ff650513          	addi	a0,a0,-10 # 80007578 <etext+0x578>
    8000358a:	739010ef          	jal	800054c2 <panic>
    return -1;
    8000358e:	597d                	li	s2,-1
    80003590:	b775                	j	8000353c <fileread+0x58>
      return -1;
    80003592:	597d                	li	s2,-1
    80003594:	64e2                	ld	s1,24(sp)
    80003596:	69a2                	ld	s3,8(sp)
    80003598:	b755                	j	8000353c <fileread+0x58>
    8000359a:	597d                	li	s2,-1
    8000359c:	64e2                	ld	s1,24(sp)
    8000359e:	69a2                	ld	s3,8(sp)
    800035a0:	bf71                	j	8000353c <fileread+0x58>

00000000800035a2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800035a2:	00954783          	lbu	a5,9(a0)
    800035a6:	10078b63          	beqz	a5,800036bc <filewrite+0x11a>
{
    800035aa:	715d                	addi	sp,sp,-80
    800035ac:	e486                	sd	ra,72(sp)
    800035ae:	e0a2                	sd	s0,64(sp)
    800035b0:	f84a                	sd	s2,48(sp)
    800035b2:	f052                	sd	s4,32(sp)
    800035b4:	e85a                	sd	s6,16(sp)
    800035b6:	0880                	addi	s0,sp,80
    800035b8:	892a                	mv	s2,a0
    800035ba:	8b2e                	mv	s6,a1
    800035bc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800035be:	411c                	lw	a5,0(a0)
    800035c0:	4705                	li	a4,1
    800035c2:	02e78763          	beq	a5,a4,800035f0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035c6:	470d                	li	a4,3
    800035c8:	02e78863          	beq	a5,a4,800035f8 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800035cc:	4709                	li	a4,2
    800035ce:	0ce79c63          	bne	a5,a4,800036a6 <filewrite+0x104>
    800035d2:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800035d4:	0ac05863          	blez	a2,80003684 <filewrite+0xe2>
    800035d8:	fc26                	sd	s1,56(sp)
    800035da:	ec56                	sd	s5,24(sp)
    800035dc:	e45e                	sd	s7,8(sp)
    800035de:	e062                	sd	s8,0(sp)
    int i = 0;
    800035e0:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800035e2:	6b85                	lui	s7,0x1
    800035e4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800035e8:	6c05                	lui	s8,0x1
    800035ea:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800035ee:	a8b5                	j	8000366a <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800035f0:	6908                	ld	a0,16(a0)
    800035f2:	1fc000ef          	jal	800037ee <pipewrite>
    800035f6:	a04d                	j	80003698 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800035f8:	02451783          	lh	a5,36(a0)
    800035fc:	03079693          	slli	a3,a5,0x30
    80003600:	92c1                	srli	a3,a3,0x30
    80003602:	4725                	li	a4,9
    80003604:	0ad76e63          	bltu	a4,a3,800036c0 <filewrite+0x11e>
    80003608:	0792                	slli	a5,a5,0x4
    8000360a:	00017717          	auipc	a4,0x17
    8000360e:	d3e70713          	addi	a4,a4,-706 # 8001a348 <devsw>
    80003612:	97ba                	add	a5,a5,a4
    80003614:	679c                	ld	a5,8(a5)
    80003616:	c7dd                	beqz	a5,800036c4 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003618:	4505                	li	a0,1
    8000361a:	9782                	jalr	a5
    8000361c:	a8b5                	j	80003698 <filewrite+0xf6>
      if(n1 > max)
    8000361e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003622:	989ff0ef          	jal	80002faa <begin_op>
      ilock(f->ip);
    80003626:	01893503          	ld	a0,24(s2)
    8000362a:	8eaff0ef          	jal	80002714 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000362e:	8756                	mv	a4,s5
    80003630:	02092683          	lw	a3,32(s2)
    80003634:	01698633          	add	a2,s3,s6
    80003638:	4585                	li	a1,1
    8000363a:	01893503          	ld	a0,24(s2)
    8000363e:	c26ff0ef          	jal	80002a64 <writei>
    80003642:	84aa                	mv	s1,a0
    80003644:	00a05763          	blez	a0,80003652 <filewrite+0xb0>
        f->off += r;
    80003648:	02092783          	lw	a5,32(s2)
    8000364c:	9fa9                	addw	a5,a5,a0
    8000364e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003652:	01893503          	ld	a0,24(s2)
    80003656:	96cff0ef          	jal	800027c2 <iunlock>
      end_op();
    8000365a:	9bbff0ef          	jal	80003014 <end_op>

      if(r != n1){
    8000365e:	029a9563          	bne	s5,s1,80003688 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003662:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003666:	0149da63          	bge	s3,s4,8000367a <filewrite+0xd8>
      int n1 = n - i;
    8000366a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000366e:	0004879b          	sext.w	a5,s1
    80003672:	fafbd6e3          	bge	s7,a5,8000361e <filewrite+0x7c>
    80003676:	84e2                	mv	s1,s8
    80003678:	b75d                	j	8000361e <filewrite+0x7c>
    8000367a:	74e2                	ld	s1,56(sp)
    8000367c:	6ae2                	ld	s5,24(sp)
    8000367e:	6ba2                	ld	s7,8(sp)
    80003680:	6c02                	ld	s8,0(sp)
    80003682:	a039                	j	80003690 <filewrite+0xee>
    int i = 0;
    80003684:	4981                	li	s3,0
    80003686:	a029                	j	80003690 <filewrite+0xee>
    80003688:	74e2                	ld	s1,56(sp)
    8000368a:	6ae2                	ld	s5,24(sp)
    8000368c:	6ba2                	ld	s7,8(sp)
    8000368e:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003690:	033a1c63          	bne	s4,s3,800036c8 <filewrite+0x126>
    80003694:	8552                	mv	a0,s4
    80003696:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003698:	60a6                	ld	ra,72(sp)
    8000369a:	6406                	ld	s0,64(sp)
    8000369c:	7942                	ld	s2,48(sp)
    8000369e:	7a02                	ld	s4,32(sp)
    800036a0:	6b42                	ld	s6,16(sp)
    800036a2:	6161                	addi	sp,sp,80
    800036a4:	8082                	ret
    800036a6:	fc26                	sd	s1,56(sp)
    800036a8:	f44e                	sd	s3,40(sp)
    800036aa:	ec56                	sd	s5,24(sp)
    800036ac:	e45e                	sd	s7,8(sp)
    800036ae:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800036b0:	00004517          	auipc	a0,0x4
    800036b4:	ed850513          	addi	a0,a0,-296 # 80007588 <etext+0x588>
    800036b8:	60b010ef          	jal	800054c2 <panic>
    return -1;
    800036bc:	557d                	li	a0,-1
}
    800036be:	8082                	ret
      return -1;
    800036c0:	557d                	li	a0,-1
    800036c2:	bfd9                	j	80003698 <filewrite+0xf6>
    800036c4:	557d                	li	a0,-1
    800036c6:	bfc9                	j	80003698 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800036c8:	557d                	li	a0,-1
    800036ca:	79a2                	ld	s3,40(sp)
    800036cc:	b7f1                	j	80003698 <filewrite+0xf6>

00000000800036ce <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800036ce:	7179                	addi	sp,sp,-48
    800036d0:	f406                	sd	ra,40(sp)
    800036d2:	f022                	sd	s0,32(sp)
    800036d4:	ec26                	sd	s1,24(sp)
    800036d6:	e052                	sd	s4,0(sp)
    800036d8:	1800                	addi	s0,sp,48
    800036da:	84aa                	mv	s1,a0
    800036dc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800036de:	0005b023          	sd	zero,0(a1)
    800036e2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800036e6:	c3bff0ef          	jal	80003320 <filealloc>
    800036ea:	e088                	sd	a0,0(s1)
    800036ec:	c549                	beqz	a0,80003776 <pipealloc+0xa8>
    800036ee:	c33ff0ef          	jal	80003320 <filealloc>
    800036f2:	00aa3023          	sd	a0,0(s4)
    800036f6:	cd25                	beqz	a0,8000376e <pipealloc+0xa0>
    800036f8:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800036fa:	a05fc0ef          	jal	800000fe <kalloc>
    800036fe:	892a                	mv	s2,a0
    80003700:	c12d                	beqz	a0,80003762 <pipealloc+0x94>
    80003702:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003704:	4985                	li	s3,1
    80003706:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000370a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000370e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003712:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003716:	00004597          	auipc	a1,0x4
    8000371a:	e8258593          	addi	a1,a1,-382 # 80007598 <etext+0x598>
    8000371e:	052020ef          	jal	80005770 <initlock>
  (*f0)->type = FD_PIPE;
    80003722:	609c                	ld	a5,0(s1)
    80003724:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003728:	609c                	ld	a5,0(s1)
    8000372a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000372e:	609c                	ld	a5,0(s1)
    80003730:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003734:	609c                	ld	a5,0(s1)
    80003736:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000373a:	000a3783          	ld	a5,0(s4)
    8000373e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003742:	000a3783          	ld	a5,0(s4)
    80003746:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000374a:	000a3783          	ld	a5,0(s4)
    8000374e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003752:	000a3783          	ld	a5,0(s4)
    80003756:	0127b823          	sd	s2,16(a5)
  return 0;
    8000375a:	4501                	li	a0,0
    8000375c:	6942                	ld	s2,16(sp)
    8000375e:	69a2                	ld	s3,8(sp)
    80003760:	a01d                	j	80003786 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003762:	6088                	ld	a0,0(s1)
    80003764:	c119                	beqz	a0,8000376a <pipealloc+0x9c>
    80003766:	6942                	ld	s2,16(sp)
    80003768:	a029                	j	80003772 <pipealloc+0xa4>
    8000376a:	6942                	ld	s2,16(sp)
    8000376c:	a029                	j	80003776 <pipealloc+0xa8>
    8000376e:	6088                	ld	a0,0(s1)
    80003770:	c10d                	beqz	a0,80003792 <pipealloc+0xc4>
    fileclose(*f0);
    80003772:	c53ff0ef          	jal	800033c4 <fileclose>
  if(*f1)
    80003776:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000377a:	557d                	li	a0,-1
  if(*f1)
    8000377c:	c789                	beqz	a5,80003786 <pipealloc+0xb8>
    fileclose(*f1);
    8000377e:	853e                	mv	a0,a5
    80003780:	c45ff0ef          	jal	800033c4 <fileclose>
  return -1;
    80003784:	557d                	li	a0,-1
}
    80003786:	70a2                	ld	ra,40(sp)
    80003788:	7402                	ld	s0,32(sp)
    8000378a:	64e2                	ld	s1,24(sp)
    8000378c:	6a02                	ld	s4,0(sp)
    8000378e:	6145                	addi	sp,sp,48
    80003790:	8082                	ret
  return -1;
    80003792:	557d                	li	a0,-1
    80003794:	bfcd                	j	80003786 <pipealloc+0xb8>

0000000080003796 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003796:	1101                	addi	sp,sp,-32
    80003798:	ec06                	sd	ra,24(sp)
    8000379a:	e822                	sd	s0,16(sp)
    8000379c:	e426                	sd	s1,8(sp)
    8000379e:	e04a                	sd	s2,0(sp)
    800037a0:	1000                	addi	s0,sp,32
    800037a2:	84aa                	mv	s1,a0
    800037a4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800037a6:	04a020ef          	jal	800057f0 <acquire>
  if(writable){
    800037aa:	02090763          	beqz	s2,800037d8 <pipeclose+0x42>
    pi->writeopen = 0;
    800037ae:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800037b2:	21848513          	addi	a0,s1,536
    800037b6:	c0dfd0ef          	jal	800013c2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800037ba:	2204b783          	ld	a5,544(s1)
    800037be:	e785                	bnez	a5,800037e6 <pipeclose+0x50>
    release(&pi->lock);
    800037c0:	8526                	mv	a0,s1
    800037c2:	0c6020ef          	jal	80005888 <release>
    kfree((char*)pi);
    800037c6:	8526                	mv	a0,s1
    800037c8:	855fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800037cc:	60e2                	ld	ra,24(sp)
    800037ce:	6442                	ld	s0,16(sp)
    800037d0:	64a2                	ld	s1,8(sp)
    800037d2:	6902                	ld	s2,0(sp)
    800037d4:	6105                	addi	sp,sp,32
    800037d6:	8082                	ret
    pi->readopen = 0;
    800037d8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800037dc:	21c48513          	addi	a0,s1,540
    800037e0:	be3fd0ef          	jal	800013c2 <wakeup>
    800037e4:	bfd9                	j	800037ba <pipeclose+0x24>
    release(&pi->lock);
    800037e6:	8526                	mv	a0,s1
    800037e8:	0a0020ef          	jal	80005888 <release>
}
    800037ec:	b7c5                	j	800037cc <pipeclose+0x36>

00000000800037ee <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800037ee:	711d                	addi	sp,sp,-96
    800037f0:	ec86                	sd	ra,88(sp)
    800037f2:	e8a2                	sd	s0,80(sp)
    800037f4:	e4a6                	sd	s1,72(sp)
    800037f6:	e0ca                	sd	s2,64(sp)
    800037f8:	fc4e                	sd	s3,56(sp)
    800037fa:	f852                	sd	s4,48(sp)
    800037fc:	f456                	sd	s5,40(sp)
    800037fe:	1080                	addi	s0,sp,96
    80003800:	84aa                	mv	s1,a0
    80003802:	8aae                	mv	s5,a1
    80003804:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003806:	da2fd0ef          	jal	80000da8 <myproc>
    8000380a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000380c:	8526                	mv	a0,s1
    8000380e:	7e3010ef          	jal	800057f0 <acquire>
  while(i < n){
    80003812:	0b405a63          	blez	s4,800038c6 <pipewrite+0xd8>
    80003816:	f05a                	sd	s6,32(sp)
    80003818:	ec5e                	sd	s7,24(sp)
    8000381a:	e862                	sd	s8,16(sp)
  int i = 0;
    8000381c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000381e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003820:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003824:	21c48b93          	addi	s7,s1,540
    80003828:	a81d                	j	8000385e <pipewrite+0x70>
      release(&pi->lock);
    8000382a:	8526                	mv	a0,s1
    8000382c:	05c020ef          	jal	80005888 <release>
      return -1;
    80003830:	597d                	li	s2,-1
    80003832:	7b02                	ld	s6,32(sp)
    80003834:	6be2                	ld	s7,24(sp)
    80003836:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003838:	854a                	mv	a0,s2
    8000383a:	60e6                	ld	ra,88(sp)
    8000383c:	6446                	ld	s0,80(sp)
    8000383e:	64a6                	ld	s1,72(sp)
    80003840:	6906                	ld	s2,64(sp)
    80003842:	79e2                	ld	s3,56(sp)
    80003844:	7a42                	ld	s4,48(sp)
    80003846:	7aa2                	ld	s5,40(sp)
    80003848:	6125                	addi	sp,sp,96
    8000384a:	8082                	ret
      wakeup(&pi->nread);
    8000384c:	8562                	mv	a0,s8
    8000384e:	b75fd0ef          	jal	800013c2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003852:	85a6                	mv	a1,s1
    80003854:	855e                	mv	a0,s7
    80003856:	b21fd0ef          	jal	80001376 <sleep>
  while(i < n){
    8000385a:	05495b63          	bge	s2,s4,800038b0 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000385e:	2204a783          	lw	a5,544(s1)
    80003862:	d7e1                	beqz	a5,8000382a <pipewrite+0x3c>
    80003864:	854e                	mv	a0,s3
    80003866:	d49fd0ef          	jal	800015ae <killed>
    8000386a:	f161                	bnez	a0,8000382a <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000386c:	2184a783          	lw	a5,536(s1)
    80003870:	21c4a703          	lw	a4,540(s1)
    80003874:	2007879b          	addiw	a5,a5,512
    80003878:	fcf70ae3          	beq	a4,a5,8000384c <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000387c:	4685                	li	a3,1
    8000387e:	01590633          	add	a2,s2,s5
    80003882:	faf40593          	addi	a1,s0,-81
    80003886:	0509b503          	ld	a0,80(s3)
    8000388a:	a66fd0ef          	jal	80000af0 <copyin>
    8000388e:	03650e63          	beq	a0,s6,800038ca <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003892:	21c4a783          	lw	a5,540(s1)
    80003896:	0017871b          	addiw	a4,a5,1
    8000389a:	20e4ae23          	sw	a4,540(s1)
    8000389e:	1ff7f793          	andi	a5,a5,511
    800038a2:	97a6                	add	a5,a5,s1
    800038a4:	faf44703          	lbu	a4,-81(s0)
    800038a8:	00e78c23          	sb	a4,24(a5)
      i++;
    800038ac:	2905                	addiw	s2,s2,1
    800038ae:	b775                	j	8000385a <pipewrite+0x6c>
    800038b0:	7b02                	ld	s6,32(sp)
    800038b2:	6be2                	ld	s7,24(sp)
    800038b4:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800038b6:	21848513          	addi	a0,s1,536
    800038ba:	b09fd0ef          	jal	800013c2 <wakeup>
  release(&pi->lock);
    800038be:	8526                	mv	a0,s1
    800038c0:	7c9010ef          	jal	80005888 <release>
  return i;
    800038c4:	bf95                	j	80003838 <pipewrite+0x4a>
  int i = 0;
    800038c6:	4901                	li	s2,0
    800038c8:	b7fd                	j	800038b6 <pipewrite+0xc8>
    800038ca:	7b02                	ld	s6,32(sp)
    800038cc:	6be2                	ld	s7,24(sp)
    800038ce:	6c42                	ld	s8,16(sp)
    800038d0:	b7dd                	j	800038b6 <pipewrite+0xc8>

00000000800038d2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800038d2:	715d                	addi	sp,sp,-80
    800038d4:	e486                	sd	ra,72(sp)
    800038d6:	e0a2                	sd	s0,64(sp)
    800038d8:	fc26                	sd	s1,56(sp)
    800038da:	f84a                	sd	s2,48(sp)
    800038dc:	f44e                	sd	s3,40(sp)
    800038de:	f052                	sd	s4,32(sp)
    800038e0:	ec56                	sd	s5,24(sp)
    800038e2:	0880                	addi	s0,sp,80
    800038e4:	84aa                	mv	s1,a0
    800038e6:	892e                	mv	s2,a1
    800038e8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800038ea:	cbefd0ef          	jal	80000da8 <myproc>
    800038ee:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800038f0:	8526                	mv	a0,s1
    800038f2:	6ff010ef          	jal	800057f0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038f6:	2184a703          	lw	a4,536(s1)
    800038fa:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800038fe:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003902:	02f71563          	bne	a4,a5,8000392c <piperead+0x5a>
    80003906:	2244a783          	lw	a5,548(s1)
    8000390a:	cb85                	beqz	a5,8000393a <piperead+0x68>
    if(killed(pr)){
    8000390c:	8552                	mv	a0,s4
    8000390e:	ca1fd0ef          	jal	800015ae <killed>
    80003912:	ed19                	bnez	a0,80003930 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003914:	85a6                	mv	a1,s1
    80003916:	854e                	mv	a0,s3
    80003918:	a5ffd0ef          	jal	80001376 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000391c:	2184a703          	lw	a4,536(s1)
    80003920:	21c4a783          	lw	a5,540(s1)
    80003924:	fef701e3          	beq	a4,a5,80003906 <piperead+0x34>
    80003928:	e85a                	sd	s6,16(sp)
    8000392a:	a809                	j	8000393c <piperead+0x6a>
    8000392c:	e85a                	sd	s6,16(sp)
    8000392e:	a039                	j	8000393c <piperead+0x6a>
      release(&pi->lock);
    80003930:	8526                	mv	a0,s1
    80003932:	757010ef          	jal	80005888 <release>
      return -1;
    80003936:	59fd                	li	s3,-1
    80003938:	a8b1                	j	80003994 <piperead+0xc2>
    8000393a:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000393c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000393e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003940:	05505263          	blez	s5,80003984 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003944:	2184a783          	lw	a5,536(s1)
    80003948:	21c4a703          	lw	a4,540(s1)
    8000394c:	02f70c63          	beq	a4,a5,80003984 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003950:	0017871b          	addiw	a4,a5,1
    80003954:	20e4ac23          	sw	a4,536(s1)
    80003958:	1ff7f793          	andi	a5,a5,511
    8000395c:	97a6                	add	a5,a5,s1
    8000395e:	0187c783          	lbu	a5,24(a5)
    80003962:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003966:	4685                	li	a3,1
    80003968:	fbf40613          	addi	a2,s0,-65
    8000396c:	85ca                	mv	a1,s2
    8000396e:	050a3503          	ld	a0,80(s4)
    80003972:	8a8fd0ef          	jal	80000a1a <copyout>
    80003976:	01650763          	beq	a0,s6,80003984 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000397a:	2985                	addiw	s3,s3,1
    8000397c:	0905                	addi	s2,s2,1
    8000397e:	fd3a93e3          	bne	s5,s3,80003944 <piperead+0x72>
    80003982:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003984:	21c48513          	addi	a0,s1,540
    80003988:	a3bfd0ef          	jal	800013c2 <wakeup>
  release(&pi->lock);
    8000398c:	8526                	mv	a0,s1
    8000398e:	6fb010ef          	jal	80005888 <release>
    80003992:	6b42                	ld	s6,16(sp)
  return i;
}
    80003994:	854e                	mv	a0,s3
    80003996:	60a6                	ld	ra,72(sp)
    80003998:	6406                	ld	s0,64(sp)
    8000399a:	74e2                	ld	s1,56(sp)
    8000399c:	7942                	ld	s2,48(sp)
    8000399e:	79a2                	ld	s3,40(sp)
    800039a0:	7a02                	ld	s4,32(sp)
    800039a2:	6ae2                	ld	s5,24(sp)
    800039a4:	6161                	addi	sp,sp,80
    800039a6:	8082                	ret

00000000800039a8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800039a8:	1141                	addi	sp,sp,-16
    800039aa:	e422                	sd	s0,8(sp)
    800039ac:	0800                	addi	s0,sp,16
    800039ae:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800039b0:	8905                	andi	a0,a0,1
    800039b2:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800039b4:	8b89                	andi	a5,a5,2
    800039b6:	c399                	beqz	a5,800039bc <flags2perm+0x14>
      perm |= PTE_W;
    800039b8:	00456513          	ori	a0,a0,4
    return perm;
}
    800039bc:	6422                	ld	s0,8(sp)
    800039be:	0141                	addi	sp,sp,16
    800039c0:	8082                	ret

00000000800039c2 <exec>:

int
exec(char *path, char **argv)
{
    800039c2:	df010113          	addi	sp,sp,-528
    800039c6:	20113423          	sd	ra,520(sp)
    800039ca:	20813023          	sd	s0,512(sp)
    800039ce:	ffa6                	sd	s1,504(sp)
    800039d0:	fbca                	sd	s2,496(sp)
    800039d2:	0c00                	addi	s0,sp,528
    800039d4:	892a                	mv	s2,a0
    800039d6:	dea43c23          	sd	a0,-520(s0)
    800039da:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800039de:	bcafd0ef          	jal	80000da8 <myproc>
    800039e2:	84aa                	mv	s1,a0

  begin_op();
    800039e4:	dc6ff0ef          	jal	80002faa <begin_op>

  if((ip = namei(path)) == 0){
    800039e8:	854a                	mv	a0,s2
    800039ea:	c04ff0ef          	jal	80002dee <namei>
    800039ee:	c931                	beqz	a0,80003a42 <exec+0x80>
    800039f0:	f3d2                	sd	s4,480(sp)
    800039f2:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800039f4:	d21fe0ef          	jal	80002714 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800039f8:	04000713          	li	a4,64
    800039fc:	4681                	li	a3,0
    800039fe:	e5040613          	addi	a2,s0,-432
    80003a02:	4581                	li	a1,0
    80003a04:	8552                	mv	a0,s4
    80003a06:	f63fe0ef          	jal	80002968 <readi>
    80003a0a:	04000793          	li	a5,64
    80003a0e:	00f51a63          	bne	a0,a5,80003a22 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003a12:	e5042703          	lw	a4,-432(s0)
    80003a16:	464c47b7          	lui	a5,0x464c4
    80003a1a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003a1e:	02f70663          	beq	a4,a5,80003a4a <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003a22:	8552                	mv	a0,s4
    80003a24:	efbfe0ef          	jal	8000291e <iunlockput>
    end_op();
    80003a28:	decff0ef          	jal	80003014 <end_op>
  }
  return -1;
    80003a2c:	557d                	li	a0,-1
    80003a2e:	7a1e                	ld	s4,480(sp)
}
    80003a30:	20813083          	ld	ra,520(sp)
    80003a34:	20013403          	ld	s0,512(sp)
    80003a38:	74fe                	ld	s1,504(sp)
    80003a3a:	795e                	ld	s2,496(sp)
    80003a3c:	21010113          	addi	sp,sp,528
    80003a40:	8082                	ret
    end_op();
    80003a42:	dd2ff0ef          	jal	80003014 <end_op>
    return -1;
    80003a46:	557d                	li	a0,-1
    80003a48:	b7e5                	j	80003a30 <exec+0x6e>
    80003a4a:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	c02fd0ef          	jal	80000e50 <proc_pagetable>
    80003a52:	8b2a                	mv	s6,a0
    80003a54:	2c050b63          	beqz	a0,80003d2a <exec+0x368>
    80003a58:	f7ce                	sd	s3,488(sp)
    80003a5a:	efd6                	sd	s5,472(sp)
    80003a5c:	e7de                	sd	s7,456(sp)
    80003a5e:	e3e2                	sd	s8,448(sp)
    80003a60:	ff66                	sd	s9,440(sp)
    80003a62:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a64:	e7042d03          	lw	s10,-400(s0)
    80003a68:	e8845783          	lhu	a5,-376(s0)
    80003a6c:	12078963          	beqz	a5,80003b9e <exec+0x1dc>
    80003a70:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003a72:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a74:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003a76:	6c85                	lui	s9,0x1
    80003a78:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003a7c:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003a80:	6a85                	lui	s5,0x1
    80003a82:	a085                	j	80003ae2 <exec+0x120>
      panic("loadseg: address should exist");
    80003a84:	00004517          	auipc	a0,0x4
    80003a88:	b1c50513          	addi	a0,a0,-1252 # 800075a0 <etext+0x5a0>
    80003a8c:	237010ef          	jal	800054c2 <panic>
    if(sz - i < PGSIZE)
    80003a90:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003a92:	8726                	mv	a4,s1
    80003a94:	012c06bb          	addw	a3,s8,s2
    80003a98:	4581                	li	a1,0
    80003a9a:	8552                	mv	a0,s4
    80003a9c:	ecdfe0ef          	jal	80002968 <readi>
    80003aa0:	2501                	sext.w	a0,a0
    80003aa2:	24a49a63          	bne	s1,a0,80003cf6 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003aa6:	012a893b          	addw	s2,s5,s2
    80003aaa:	03397363          	bgeu	s2,s3,80003ad0 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003aae:	02091593          	slli	a1,s2,0x20
    80003ab2:	9181                	srli	a1,a1,0x20
    80003ab4:	95de                	add	a1,a1,s7
    80003ab6:	855a                	mv	a0,s6
    80003ab8:	9e7fc0ef          	jal	8000049e <walkaddr>
    80003abc:	862a                	mv	a2,a0
    if(pa == 0)
    80003abe:	d179                	beqz	a0,80003a84 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003ac0:	412984bb          	subw	s1,s3,s2
    80003ac4:	0004879b          	sext.w	a5,s1
    80003ac8:	fcfcf4e3          	bgeu	s9,a5,80003a90 <exec+0xce>
    80003acc:	84d6                	mv	s1,s5
    80003ace:	b7c9                	j	80003a90 <exec+0xce>
    sz = sz1;
    80003ad0:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ad4:	2d85                	addiw	s11,s11,1
    80003ad6:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003ada:	e8845783          	lhu	a5,-376(s0)
    80003ade:	08fdd063          	bge	s11,a5,80003b5e <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003ae2:	2d01                	sext.w	s10,s10
    80003ae4:	03800713          	li	a4,56
    80003ae8:	86ea                	mv	a3,s10
    80003aea:	e1840613          	addi	a2,s0,-488
    80003aee:	4581                	li	a1,0
    80003af0:	8552                	mv	a0,s4
    80003af2:	e77fe0ef          	jal	80002968 <readi>
    80003af6:	03800793          	li	a5,56
    80003afa:	1cf51663          	bne	a0,a5,80003cc6 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003afe:	e1842783          	lw	a5,-488(s0)
    80003b02:	4705                	li	a4,1
    80003b04:	fce798e3          	bne	a5,a4,80003ad4 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003b08:	e4043483          	ld	s1,-448(s0)
    80003b0c:	e3843783          	ld	a5,-456(s0)
    80003b10:	1af4ef63          	bltu	s1,a5,80003cce <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003b14:	e2843783          	ld	a5,-472(s0)
    80003b18:	94be                	add	s1,s1,a5
    80003b1a:	1af4ee63          	bltu	s1,a5,80003cd6 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003b1e:	df043703          	ld	a4,-528(s0)
    80003b22:	8ff9                	and	a5,a5,a4
    80003b24:	1a079d63          	bnez	a5,80003cde <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b28:	e1c42503          	lw	a0,-484(s0)
    80003b2c:	e7dff0ef          	jal	800039a8 <flags2perm>
    80003b30:	86aa                	mv	a3,a0
    80003b32:	8626                	mv	a2,s1
    80003b34:	85ca                	mv	a1,s2
    80003b36:	855a                	mv	a0,s6
    80003b38:	ccffc0ef          	jal	80000806 <uvmalloc>
    80003b3c:	e0a43423          	sd	a0,-504(s0)
    80003b40:	1a050363          	beqz	a0,80003ce6 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003b44:	e2843b83          	ld	s7,-472(s0)
    80003b48:	e2042c03          	lw	s8,-480(s0)
    80003b4c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003b50:	00098463          	beqz	s3,80003b58 <exec+0x196>
    80003b54:	4901                	li	s2,0
    80003b56:	bfa1                	j	80003aae <exec+0xec>
    sz = sz1;
    80003b58:	e0843903          	ld	s2,-504(s0)
    80003b5c:	bfa5                	j	80003ad4 <exec+0x112>
    80003b5e:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003b60:	8552                	mv	a0,s4
    80003b62:	dbdfe0ef          	jal	8000291e <iunlockput>
  end_op();
    80003b66:	caeff0ef          	jal	80003014 <end_op>
  p = myproc();
    80003b6a:	a3efd0ef          	jal	80000da8 <myproc>
    80003b6e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003b70:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003b74:	6985                	lui	s3,0x1
    80003b76:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003b78:	99ca                	add	s3,s3,s2
    80003b7a:	77fd                	lui	a5,0xfffff
    80003b7c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003b80:	4691                	li	a3,4
    80003b82:	660d                	lui	a2,0x3
    80003b84:	964e                	add	a2,a2,s3
    80003b86:	85ce                	mv	a1,s3
    80003b88:	855a                	mv	a0,s6
    80003b8a:	c7dfc0ef          	jal	80000806 <uvmalloc>
    80003b8e:	892a                	mv	s2,a0
    80003b90:	e0a43423          	sd	a0,-504(s0)
    80003b94:	e519                	bnez	a0,80003ba2 <exec+0x1e0>
  if(pagetable)
    80003b96:	e1343423          	sd	s3,-504(s0)
    80003b9a:	4a01                	li	s4,0
    80003b9c:	aab1                	j	80003cf8 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b9e:	4901                	li	s2,0
    80003ba0:	b7c1                	j	80003b60 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003ba2:	75f5                	lui	a1,0xffffd
    80003ba4:	95aa                	add	a1,a1,a0
    80003ba6:	855a                	mv	a0,s6
    80003ba8:	e49fc0ef          	jal	800009f0 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003bac:	7bf9                	lui	s7,0xffffe
    80003bae:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003bb0:	e0043783          	ld	a5,-512(s0)
    80003bb4:	6388                	ld	a0,0(a5)
    80003bb6:	cd39                	beqz	a0,80003c14 <exec+0x252>
    80003bb8:	e9040993          	addi	s3,s0,-368
    80003bbc:	f9040c13          	addi	s8,s0,-112
    80003bc0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003bc2:	f3efc0ef          	jal	80000300 <strlen>
    80003bc6:	0015079b          	addiw	a5,a0,1
    80003bca:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003bce:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003bd2:	11796e63          	bltu	s2,s7,80003cee <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003bd6:	e0043d03          	ld	s10,-512(s0)
    80003bda:	000d3a03          	ld	s4,0(s10)
    80003bde:	8552                	mv	a0,s4
    80003be0:	f20fc0ef          	jal	80000300 <strlen>
    80003be4:	0015069b          	addiw	a3,a0,1
    80003be8:	8652                	mv	a2,s4
    80003bea:	85ca                	mv	a1,s2
    80003bec:	855a                	mv	a0,s6
    80003bee:	e2dfc0ef          	jal	80000a1a <copyout>
    80003bf2:	10054063          	bltz	a0,80003cf2 <exec+0x330>
    ustack[argc] = sp;
    80003bf6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003bfa:	0485                	addi	s1,s1,1
    80003bfc:	008d0793          	addi	a5,s10,8
    80003c00:	e0f43023          	sd	a5,-512(s0)
    80003c04:	008d3503          	ld	a0,8(s10)
    80003c08:	c909                	beqz	a0,80003c1a <exec+0x258>
    if(argc >= MAXARG)
    80003c0a:	09a1                	addi	s3,s3,8
    80003c0c:	fb899be3          	bne	s3,s8,80003bc2 <exec+0x200>
  ip = 0;
    80003c10:	4a01                	li	s4,0
    80003c12:	a0dd                	j	80003cf8 <exec+0x336>
  sp = sz;
    80003c14:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003c18:	4481                	li	s1,0
  ustack[argc] = 0;
    80003c1a:	00349793          	slli	a5,s1,0x3
    80003c1e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb9b0>
    80003c22:	97a2                	add	a5,a5,s0
    80003c24:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003c28:	00148693          	addi	a3,s1,1
    80003c2c:	068e                	slli	a3,a3,0x3
    80003c2e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003c32:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003c36:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003c3a:	f5796ee3          	bltu	s2,s7,80003b96 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003c3e:	e9040613          	addi	a2,s0,-368
    80003c42:	85ca                	mv	a1,s2
    80003c44:	855a                	mv	a0,s6
    80003c46:	dd5fc0ef          	jal	80000a1a <copyout>
    80003c4a:	0e054263          	bltz	a0,80003d2e <exec+0x36c>
  p->trapframe->a1 = sp;
    80003c4e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003c52:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003c56:	df843783          	ld	a5,-520(s0)
    80003c5a:	0007c703          	lbu	a4,0(a5)
    80003c5e:	cf11                	beqz	a4,80003c7a <exec+0x2b8>
    80003c60:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003c62:	02f00693          	li	a3,47
    80003c66:	a039                	j	80003c74 <exec+0x2b2>
      last = s+1;
    80003c68:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003c6c:	0785                	addi	a5,a5,1
    80003c6e:	fff7c703          	lbu	a4,-1(a5)
    80003c72:	c701                	beqz	a4,80003c7a <exec+0x2b8>
    if(*s == '/')
    80003c74:	fed71ce3          	bne	a4,a3,80003c6c <exec+0x2aa>
    80003c78:	bfc5                	j	80003c68 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003c7a:	4641                	li	a2,16
    80003c7c:	df843583          	ld	a1,-520(s0)
    80003c80:	158a8513          	addi	a0,s5,344
    80003c84:	e4afc0ef          	jal	800002ce <safestrcpy>
  oldpagetable = p->pagetable;
    80003c88:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003c8c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003c90:	e0843783          	ld	a5,-504(s0)
    80003c94:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003c98:	058ab783          	ld	a5,88(s5)
    80003c9c:	e6843703          	ld	a4,-408(s0)
    80003ca0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003ca2:	058ab783          	ld	a5,88(s5)
    80003ca6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003caa:	85e6                	mv	a1,s9
    80003cac:	a28fd0ef          	jal	80000ed4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003cb0:	0004851b          	sext.w	a0,s1
    80003cb4:	79be                	ld	s3,488(sp)
    80003cb6:	7a1e                	ld	s4,480(sp)
    80003cb8:	6afe                	ld	s5,472(sp)
    80003cba:	6b5e                	ld	s6,464(sp)
    80003cbc:	6bbe                	ld	s7,456(sp)
    80003cbe:	6c1e                	ld	s8,448(sp)
    80003cc0:	7cfa                	ld	s9,440(sp)
    80003cc2:	7d5a                	ld	s10,432(sp)
    80003cc4:	b3b5                	j	80003a30 <exec+0x6e>
    80003cc6:	e1243423          	sd	s2,-504(s0)
    80003cca:	7dba                	ld	s11,424(sp)
    80003ccc:	a035                	j	80003cf8 <exec+0x336>
    80003cce:	e1243423          	sd	s2,-504(s0)
    80003cd2:	7dba                	ld	s11,424(sp)
    80003cd4:	a015                	j	80003cf8 <exec+0x336>
    80003cd6:	e1243423          	sd	s2,-504(s0)
    80003cda:	7dba                	ld	s11,424(sp)
    80003cdc:	a831                	j	80003cf8 <exec+0x336>
    80003cde:	e1243423          	sd	s2,-504(s0)
    80003ce2:	7dba                	ld	s11,424(sp)
    80003ce4:	a811                	j	80003cf8 <exec+0x336>
    80003ce6:	e1243423          	sd	s2,-504(s0)
    80003cea:	7dba                	ld	s11,424(sp)
    80003cec:	a031                	j	80003cf8 <exec+0x336>
  ip = 0;
    80003cee:	4a01                	li	s4,0
    80003cf0:	a021                	j	80003cf8 <exec+0x336>
    80003cf2:	4a01                	li	s4,0
  if(pagetable)
    80003cf4:	a011                	j	80003cf8 <exec+0x336>
    80003cf6:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003cf8:	e0843583          	ld	a1,-504(s0)
    80003cfc:	855a                	mv	a0,s6
    80003cfe:	9d6fd0ef          	jal	80000ed4 <proc_freepagetable>
  return -1;
    80003d02:	557d                	li	a0,-1
  if(ip){
    80003d04:	000a1b63          	bnez	s4,80003d1a <exec+0x358>
    80003d08:	79be                	ld	s3,488(sp)
    80003d0a:	7a1e                	ld	s4,480(sp)
    80003d0c:	6afe                	ld	s5,472(sp)
    80003d0e:	6b5e                	ld	s6,464(sp)
    80003d10:	6bbe                	ld	s7,456(sp)
    80003d12:	6c1e                	ld	s8,448(sp)
    80003d14:	7cfa                	ld	s9,440(sp)
    80003d16:	7d5a                	ld	s10,432(sp)
    80003d18:	bb21                	j	80003a30 <exec+0x6e>
    80003d1a:	79be                	ld	s3,488(sp)
    80003d1c:	6afe                	ld	s5,472(sp)
    80003d1e:	6b5e                	ld	s6,464(sp)
    80003d20:	6bbe                	ld	s7,456(sp)
    80003d22:	6c1e                	ld	s8,448(sp)
    80003d24:	7cfa                	ld	s9,440(sp)
    80003d26:	7d5a                	ld	s10,432(sp)
    80003d28:	b9ed                	j	80003a22 <exec+0x60>
    80003d2a:	6b5e                	ld	s6,464(sp)
    80003d2c:	b9dd                	j	80003a22 <exec+0x60>
  sz = sz1;
    80003d2e:	e0843983          	ld	s3,-504(s0)
    80003d32:	b595                	j	80003b96 <exec+0x1d4>

0000000080003d34 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003d34:	7179                	addi	sp,sp,-48
    80003d36:	f406                	sd	ra,40(sp)
    80003d38:	f022                	sd	s0,32(sp)
    80003d3a:	ec26                	sd	s1,24(sp)
    80003d3c:	e84a                	sd	s2,16(sp)
    80003d3e:	1800                	addi	s0,sp,48
    80003d40:	892e                	mv	s2,a1
    80003d42:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003d44:	fdc40593          	addi	a1,s0,-36
    80003d48:	f61fd0ef          	jal	80001ca8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003d4c:	fdc42703          	lw	a4,-36(s0)
    80003d50:	47bd                	li	a5,15
    80003d52:	02e7e963          	bltu	a5,a4,80003d84 <argfd+0x50>
    80003d56:	852fd0ef          	jal	80000da8 <myproc>
    80003d5a:	fdc42703          	lw	a4,-36(s0)
    80003d5e:	01a70793          	addi	a5,a4,26
    80003d62:	078e                	slli	a5,a5,0x3
    80003d64:	953e                	add	a0,a0,a5
    80003d66:	611c                	ld	a5,0(a0)
    80003d68:	c385                	beqz	a5,80003d88 <argfd+0x54>
    return -1;
  if(pfd)
    80003d6a:	00090463          	beqz	s2,80003d72 <argfd+0x3e>
    *pfd = fd;
    80003d6e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003d72:	4501                	li	a0,0
  if(pf)
    80003d74:	c091                	beqz	s1,80003d78 <argfd+0x44>
    *pf = f;
    80003d76:	e09c                	sd	a5,0(s1)
}
    80003d78:	70a2                	ld	ra,40(sp)
    80003d7a:	7402                	ld	s0,32(sp)
    80003d7c:	64e2                	ld	s1,24(sp)
    80003d7e:	6942                	ld	s2,16(sp)
    80003d80:	6145                	addi	sp,sp,48
    80003d82:	8082                	ret
    return -1;
    80003d84:	557d                	li	a0,-1
    80003d86:	bfcd                	j	80003d78 <argfd+0x44>
    80003d88:	557d                	li	a0,-1
    80003d8a:	b7fd                	j	80003d78 <argfd+0x44>

0000000080003d8c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003d8c:	1101                	addi	sp,sp,-32
    80003d8e:	ec06                	sd	ra,24(sp)
    80003d90:	e822                	sd	s0,16(sp)
    80003d92:	e426                	sd	s1,8(sp)
    80003d94:	1000                	addi	s0,sp,32
    80003d96:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003d98:	810fd0ef          	jal	80000da8 <myproc>
    80003d9c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003d9e:	0d050793          	addi	a5,a0,208
    80003da2:	4501                	li	a0,0
    80003da4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003da6:	6398                	ld	a4,0(a5)
    80003da8:	cb19                	beqz	a4,80003dbe <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003daa:	2505                	addiw	a0,a0,1
    80003dac:	07a1                	addi	a5,a5,8
    80003dae:	fed51ce3          	bne	a0,a3,80003da6 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003db2:	557d                	li	a0,-1
}
    80003db4:	60e2                	ld	ra,24(sp)
    80003db6:	6442                	ld	s0,16(sp)
    80003db8:	64a2                	ld	s1,8(sp)
    80003dba:	6105                	addi	sp,sp,32
    80003dbc:	8082                	ret
      p->ofile[fd] = f;
    80003dbe:	01a50793          	addi	a5,a0,26
    80003dc2:	078e                	slli	a5,a5,0x3
    80003dc4:	963e                	add	a2,a2,a5
    80003dc6:	e204                	sd	s1,0(a2)
      return fd;
    80003dc8:	b7f5                	j	80003db4 <fdalloc+0x28>

0000000080003dca <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003dca:	715d                	addi	sp,sp,-80
    80003dcc:	e486                	sd	ra,72(sp)
    80003dce:	e0a2                	sd	s0,64(sp)
    80003dd0:	fc26                	sd	s1,56(sp)
    80003dd2:	f84a                	sd	s2,48(sp)
    80003dd4:	f44e                	sd	s3,40(sp)
    80003dd6:	ec56                	sd	s5,24(sp)
    80003dd8:	e85a                	sd	s6,16(sp)
    80003dda:	0880                	addi	s0,sp,80
    80003ddc:	8b2e                	mv	s6,a1
    80003dde:	89b2                	mv	s3,a2
    80003de0:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003de2:	fb040593          	addi	a1,s0,-80
    80003de6:	822ff0ef          	jal	80002e08 <nameiparent>
    80003dea:	84aa                	mv	s1,a0
    80003dec:	10050a63          	beqz	a0,80003f00 <create+0x136>
    return 0;

  ilock(dp);
    80003df0:	925fe0ef          	jal	80002714 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003df4:	4601                	li	a2,0
    80003df6:	fb040593          	addi	a1,s0,-80
    80003dfa:	8526                	mv	a0,s1
    80003dfc:	d8dfe0ef          	jal	80002b88 <dirlookup>
    80003e00:	8aaa                	mv	s5,a0
    80003e02:	c129                	beqz	a0,80003e44 <create+0x7a>
    iunlockput(dp);
    80003e04:	8526                	mv	a0,s1
    80003e06:	b19fe0ef          	jal	8000291e <iunlockput>
    ilock(ip);
    80003e0a:	8556                	mv	a0,s5
    80003e0c:	909fe0ef          	jal	80002714 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003e10:	4789                	li	a5,2
    80003e12:	02fb1463          	bne	s6,a5,80003e3a <create+0x70>
    80003e16:	044ad783          	lhu	a5,68(s5)
    80003e1a:	37f9                	addiw	a5,a5,-2
    80003e1c:	17c2                	slli	a5,a5,0x30
    80003e1e:	93c1                	srli	a5,a5,0x30
    80003e20:	4705                	li	a4,1
    80003e22:	00f76c63          	bltu	a4,a5,80003e3a <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003e26:	8556                	mv	a0,s5
    80003e28:	60a6                	ld	ra,72(sp)
    80003e2a:	6406                	ld	s0,64(sp)
    80003e2c:	74e2                	ld	s1,56(sp)
    80003e2e:	7942                	ld	s2,48(sp)
    80003e30:	79a2                	ld	s3,40(sp)
    80003e32:	6ae2                	ld	s5,24(sp)
    80003e34:	6b42                	ld	s6,16(sp)
    80003e36:	6161                	addi	sp,sp,80
    80003e38:	8082                	ret
    iunlockput(ip);
    80003e3a:	8556                	mv	a0,s5
    80003e3c:	ae3fe0ef          	jal	8000291e <iunlockput>
    return 0;
    80003e40:	4a81                	li	s5,0
    80003e42:	b7d5                	j	80003e26 <create+0x5c>
    80003e44:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003e46:	85da                	mv	a1,s6
    80003e48:	4088                	lw	a0,0(s1)
    80003e4a:	f5afe0ef          	jal	800025a4 <ialloc>
    80003e4e:	8a2a                	mv	s4,a0
    80003e50:	cd15                	beqz	a0,80003e8c <create+0xc2>
  ilock(ip);
    80003e52:	8c3fe0ef          	jal	80002714 <ilock>
  ip->major = major;
    80003e56:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003e5a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003e5e:	4905                	li	s2,1
    80003e60:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003e64:	8552                	mv	a0,s4
    80003e66:	ffafe0ef          	jal	80002660 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003e6a:	032b0763          	beq	s6,s2,80003e98 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e6e:	004a2603          	lw	a2,4(s4)
    80003e72:	fb040593          	addi	a1,s0,-80
    80003e76:	8526                	mv	a0,s1
    80003e78:	eddfe0ef          	jal	80002d54 <dirlink>
    80003e7c:	06054563          	bltz	a0,80003ee6 <create+0x11c>
  iunlockput(dp);
    80003e80:	8526                	mv	a0,s1
    80003e82:	a9dfe0ef          	jal	8000291e <iunlockput>
  return ip;
    80003e86:	8ad2                	mv	s5,s4
    80003e88:	7a02                	ld	s4,32(sp)
    80003e8a:	bf71                	j	80003e26 <create+0x5c>
    iunlockput(dp);
    80003e8c:	8526                	mv	a0,s1
    80003e8e:	a91fe0ef          	jal	8000291e <iunlockput>
    return 0;
    80003e92:	8ad2                	mv	s5,s4
    80003e94:	7a02                	ld	s4,32(sp)
    80003e96:	bf41                	j	80003e26 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003e98:	004a2603          	lw	a2,4(s4)
    80003e9c:	00003597          	auipc	a1,0x3
    80003ea0:	72458593          	addi	a1,a1,1828 # 800075c0 <etext+0x5c0>
    80003ea4:	8552                	mv	a0,s4
    80003ea6:	eaffe0ef          	jal	80002d54 <dirlink>
    80003eaa:	02054e63          	bltz	a0,80003ee6 <create+0x11c>
    80003eae:	40d0                	lw	a2,4(s1)
    80003eb0:	00003597          	auipc	a1,0x3
    80003eb4:	71858593          	addi	a1,a1,1816 # 800075c8 <etext+0x5c8>
    80003eb8:	8552                	mv	a0,s4
    80003eba:	e9bfe0ef          	jal	80002d54 <dirlink>
    80003ebe:	02054463          	bltz	a0,80003ee6 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003ec2:	004a2603          	lw	a2,4(s4)
    80003ec6:	fb040593          	addi	a1,s0,-80
    80003eca:	8526                	mv	a0,s1
    80003ecc:	e89fe0ef          	jal	80002d54 <dirlink>
    80003ed0:	00054b63          	bltz	a0,80003ee6 <create+0x11c>
    dp->nlink++;  // for ".."
    80003ed4:	04a4d783          	lhu	a5,74(s1)
    80003ed8:	2785                	addiw	a5,a5,1
    80003eda:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003ede:	8526                	mv	a0,s1
    80003ee0:	f80fe0ef          	jal	80002660 <iupdate>
    80003ee4:	bf71                	j	80003e80 <create+0xb6>
  ip->nlink = 0;
    80003ee6:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003eea:	8552                	mv	a0,s4
    80003eec:	f74fe0ef          	jal	80002660 <iupdate>
  iunlockput(ip);
    80003ef0:	8552                	mv	a0,s4
    80003ef2:	a2dfe0ef          	jal	8000291e <iunlockput>
  iunlockput(dp);
    80003ef6:	8526                	mv	a0,s1
    80003ef8:	a27fe0ef          	jal	8000291e <iunlockput>
  return 0;
    80003efc:	7a02                	ld	s4,32(sp)
    80003efe:	b725                	j	80003e26 <create+0x5c>
    return 0;
    80003f00:	8aaa                	mv	s5,a0
    80003f02:	b715                	j	80003e26 <create+0x5c>

0000000080003f04 <sys_dup>:
{
    80003f04:	7179                	addi	sp,sp,-48
    80003f06:	f406                	sd	ra,40(sp)
    80003f08:	f022                	sd	s0,32(sp)
    80003f0a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003f0c:	fd840613          	addi	a2,s0,-40
    80003f10:	4581                	li	a1,0
    80003f12:	4501                	li	a0,0
    80003f14:	e21ff0ef          	jal	80003d34 <argfd>
    return -1;
    80003f18:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003f1a:	02054363          	bltz	a0,80003f40 <sys_dup+0x3c>
    80003f1e:	ec26                	sd	s1,24(sp)
    80003f20:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003f22:	fd843903          	ld	s2,-40(s0)
    80003f26:	854a                	mv	a0,s2
    80003f28:	e65ff0ef          	jal	80003d8c <fdalloc>
    80003f2c:	84aa                	mv	s1,a0
    return -1;
    80003f2e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003f30:	00054d63          	bltz	a0,80003f4a <sys_dup+0x46>
  filedup(f);
    80003f34:	854a                	mv	a0,s2
    80003f36:	c48ff0ef          	jal	8000337e <filedup>
  return fd;
    80003f3a:	87a6                	mv	a5,s1
    80003f3c:	64e2                	ld	s1,24(sp)
    80003f3e:	6942                	ld	s2,16(sp)
}
    80003f40:	853e                	mv	a0,a5
    80003f42:	70a2                	ld	ra,40(sp)
    80003f44:	7402                	ld	s0,32(sp)
    80003f46:	6145                	addi	sp,sp,48
    80003f48:	8082                	ret
    80003f4a:	64e2                	ld	s1,24(sp)
    80003f4c:	6942                	ld	s2,16(sp)
    80003f4e:	bfcd                	j	80003f40 <sys_dup+0x3c>

0000000080003f50 <sys_read>:
{
    80003f50:	7179                	addi	sp,sp,-48
    80003f52:	f406                	sd	ra,40(sp)
    80003f54:	f022                	sd	s0,32(sp)
    80003f56:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f58:	fd840593          	addi	a1,s0,-40
    80003f5c:	4505                	li	a0,1
    80003f5e:	d67fd0ef          	jal	80001cc4 <argaddr>
  argint(2, &n);
    80003f62:	fe440593          	addi	a1,s0,-28
    80003f66:	4509                	li	a0,2
    80003f68:	d41fd0ef          	jal	80001ca8 <argint>
  if(argfd(0, 0, &f) < 0)
    80003f6c:	fe840613          	addi	a2,s0,-24
    80003f70:	4581                	li	a1,0
    80003f72:	4501                	li	a0,0
    80003f74:	dc1ff0ef          	jal	80003d34 <argfd>
    80003f78:	87aa                	mv	a5,a0
    return -1;
    80003f7a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f7c:	0007ca63          	bltz	a5,80003f90 <sys_read+0x40>
  return fileread(f, p, n);
    80003f80:	fe442603          	lw	a2,-28(s0)
    80003f84:	fd843583          	ld	a1,-40(s0)
    80003f88:	fe843503          	ld	a0,-24(s0)
    80003f8c:	d58ff0ef          	jal	800034e4 <fileread>
}
    80003f90:	70a2                	ld	ra,40(sp)
    80003f92:	7402                	ld	s0,32(sp)
    80003f94:	6145                	addi	sp,sp,48
    80003f96:	8082                	ret

0000000080003f98 <sys_write>:
{
    80003f98:	7179                	addi	sp,sp,-48
    80003f9a:	f406                	sd	ra,40(sp)
    80003f9c:	f022                	sd	s0,32(sp)
    80003f9e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003fa0:	fd840593          	addi	a1,s0,-40
    80003fa4:	4505                	li	a0,1
    80003fa6:	d1ffd0ef          	jal	80001cc4 <argaddr>
  argint(2, &n);
    80003faa:	fe440593          	addi	a1,s0,-28
    80003fae:	4509                	li	a0,2
    80003fb0:	cf9fd0ef          	jal	80001ca8 <argint>
  if(argfd(0, 0, &f) < 0)
    80003fb4:	fe840613          	addi	a2,s0,-24
    80003fb8:	4581                	li	a1,0
    80003fba:	4501                	li	a0,0
    80003fbc:	d79ff0ef          	jal	80003d34 <argfd>
    80003fc0:	87aa                	mv	a5,a0
    return -1;
    80003fc2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fc4:	0007ca63          	bltz	a5,80003fd8 <sys_write+0x40>
  return filewrite(f, p, n);
    80003fc8:	fe442603          	lw	a2,-28(s0)
    80003fcc:	fd843583          	ld	a1,-40(s0)
    80003fd0:	fe843503          	ld	a0,-24(s0)
    80003fd4:	dceff0ef          	jal	800035a2 <filewrite>
}
    80003fd8:	70a2                	ld	ra,40(sp)
    80003fda:	7402                	ld	s0,32(sp)
    80003fdc:	6145                	addi	sp,sp,48
    80003fde:	8082                	ret

0000000080003fe0 <sys_close>:
{
    80003fe0:	1101                	addi	sp,sp,-32
    80003fe2:	ec06                	sd	ra,24(sp)
    80003fe4:	e822                	sd	s0,16(sp)
    80003fe6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003fe8:	fe040613          	addi	a2,s0,-32
    80003fec:	fec40593          	addi	a1,s0,-20
    80003ff0:	4501                	li	a0,0
    80003ff2:	d43ff0ef          	jal	80003d34 <argfd>
    return -1;
    80003ff6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003ff8:	02054063          	bltz	a0,80004018 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003ffc:	dadfc0ef          	jal	80000da8 <myproc>
    80004000:	fec42783          	lw	a5,-20(s0)
    80004004:	07e9                	addi	a5,a5,26
    80004006:	078e                	slli	a5,a5,0x3
    80004008:	953e                	add	a0,a0,a5
    8000400a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000400e:	fe043503          	ld	a0,-32(s0)
    80004012:	bb2ff0ef          	jal	800033c4 <fileclose>
  return 0;
    80004016:	4781                	li	a5,0
}
    80004018:	853e                	mv	a0,a5
    8000401a:	60e2                	ld	ra,24(sp)
    8000401c:	6442                	ld	s0,16(sp)
    8000401e:	6105                	addi	sp,sp,32
    80004020:	8082                	ret

0000000080004022 <sys_fstat>:
{
    80004022:	1101                	addi	sp,sp,-32
    80004024:	ec06                	sd	ra,24(sp)
    80004026:	e822                	sd	s0,16(sp)
    80004028:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000402a:	fe040593          	addi	a1,s0,-32
    8000402e:	4505                	li	a0,1
    80004030:	c95fd0ef          	jal	80001cc4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004034:	fe840613          	addi	a2,s0,-24
    80004038:	4581                	li	a1,0
    8000403a:	4501                	li	a0,0
    8000403c:	cf9ff0ef          	jal	80003d34 <argfd>
    80004040:	87aa                	mv	a5,a0
    return -1;
    80004042:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004044:	0007c863          	bltz	a5,80004054 <sys_fstat+0x32>
  return filestat(f, st);
    80004048:	fe043583          	ld	a1,-32(s0)
    8000404c:	fe843503          	ld	a0,-24(s0)
    80004050:	c36ff0ef          	jal	80003486 <filestat>
}
    80004054:	60e2                	ld	ra,24(sp)
    80004056:	6442                	ld	s0,16(sp)
    80004058:	6105                	addi	sp,sp,32
    8000405a:	8082                	ret

000000008000405c <sys_link>:
{
    8000405c:	7169                	addi	sp,sp,-304
    8000405e:	f606                	sd	ra,296(sp)
    80004060:	f222                	sd	s0,288(sp)
    80004062:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004064:	08000613          	li	a2,128
    80004068:	ed040593          	addi	a1,s0,-304
    8000406c:	4501                	li	a0,0
    8000406e:	c73fd0ef          	jal	80001ce0 <argstr>
    return -1;
    80004072:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004074:	0c054e63          	bltz	a0,80004150 <sys_link+0xf4>
    80004078:	08000613          	li	a2,128
    8000407c:	f5040593          	addi	a1,s0,-176
    80004080:	4505                	li	a0,1
    80004082:	c5ffd0ef          	jal	80001ce0 <argstr>
    return -1;
    80004086:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004088:	0c054463          	bltz	a0,80004150 <sys_link+0xf4>
    8000408c:	ee26                	sd	s1,280(sp)
  begin_op();
    8000408e:	f1dfe0ef          	jal	80002faa <begin_op>
  if((ip = namei(old)) == 0){
    80004092:	ed040513          	addi	a0,s0,-304
    80004096:	d59fe0ef          	jal	80002dee <namei>
    8000409a:	84aa                	mv	s1,a0
    8000409c:	c53d                	beqz	a0,8000410a <sys_link+0xae>
  ilock(ip);
    8000409e:	e76fe0ef          	jal	80002714 <ilock>
  if(ip->type == T_DIR){
    800040a2:	04449703          	lh	a4,68(s1)
    800040a6:	4785                	li	a5,1
    800040a8:	06f70663          	beq	a4,a5,80004114 <sys_link+0xb8>
    800040ac:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800040ae:	04a4d783          	lhu	a5,74(s1)
    800040b2:	2785                	addiw	a5,a5,1
    800040b4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800040b8:	8526                	mv	a0,s1
    800040ba:	da6fe0ef          	jal	80002660 <iupdate>
  iunlock(ip);
    800040be:	8526                	mv	a0,s1
    800040c0:	f02fe0ef          	jal	800027c2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800040c4:	fd040593          	addi	a1,s0,-48
    800040c8:	f5040513          	addi	a0,s0,-176
    800040cc:	d3dfe0ef          	jal	80002e08 <nameiparent>
    800040d0:	892a                	mv	s2,a0
    800040d2:	cd21                	beqz	a0,8000412a <sys_link+0xce>
  ilock(dp);
    800040d4:	e40fe0ef          	jal	80002714 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800040d8:	00092703          	lw	a4,0(s2)
    800040dc:	409c                	lw	a5,0(s1)
    800040de:	04f71363          	bne	a4,a5,80004124 <sys_link+0xc8>
    800040e2:	40d0                	lw	a2,4(s1)
    800040e4:	fd040593          	addi	a1,s0,-48
    800040e8:	854a                	mv	a0,s2
    800040ea:	c6bfe0ef          	jal	80002d54 <dirlink>
    800040ee:	02054b63          	bltz	a0,80004124 <sys_link+0xc8>
  iunlockput(dp);
    800040f2:	854a                	mv	a0,s2
    800040f4:	82bfe0ef          	jal	8000291e <iunlockput>
  iput(ip);
    800040f8:	8526                	mv	a0,s1
    800040fa:	f9cfe0ef          	jal	80002896 <iput>
  end_op();
    800040fe:	f17fe0ef          	jal	80003014 <end_op>
  return 0;
    80004102:	4781                	li	a5,0
    80004104:	64f2                	ld	s1,280(sp)
    80004106:	6952                	ld	s2,272(sp)
    80004108:	a0a1                	j	80004150 <sys_link+0xf4>
    end_op();
    8000410a:	f0bfe0ef          	jal	80003014 <end_op>
    return -1;
    8000410e:	57fd                	li	a5,-1
    80004110:	64f2                	ld	s1,280(sp)
    80004112:	a83d                	j	80004150 <sys_link+0xf4>
    iunlockput(ip);
    80004114:	8526                	mv	a0,s1
    80004116:	809fe0ef          	jal	8000291e <iunlockput>
    end_op();
    8000411a:	efbfe0ef          	jal	80003014 <end_op>
    return -1;
    8000411e:	57fd                	li	a5,-1
    80004120:	64f2                	ld	s1,280(sp)
    80004122:	a03d                	j	80004150 <sys_link+0xf4>
    iunlockput(dp);
    80004124:	854a                	mv	a0,s2
    80004126:	ff8fe0ef          	jal	8000291e <iunlockput>
  ilock(ip);
    8000412a:	8526                	mv	a0,s1
    8000412c:	de8fe0ef          	jal	80002714 <ilock>
  ip->nlink--;
    80004130:	04a4d783          	lhu	a5,74(s1)
    80004134:	37fd                	addiw	a5,a5,-1
    80004136:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000413a:	8526                	mv	a0,s1
    8000413c:	d24fe0ef          	jal	80002660 <iupdate>
  iunlockput(ip);
    80004140:	8526                	mv	a0,s1
    80004142:	fdcfe0ef          	jal	8000291e <iunlockput>
  end_op();
    80004146:	ecffe0ef          	jal	80003014 <end_op>
  return -1;
    8000414a:	57fd                	li	a5,-1
    8000414c:	64f2                	ld	s1,280(sp)
    8000414e:	6952                	ld	s2,272(sp)
}
    80004150:	853e                	mv	a0,a5
    80004152:	70b2                	ld	ra,296(sp)
    80004154:	7412                	ld	s0,288(sp)
    80004156:	6155                	addi	sp,sp,304
    80004158:	8082                	ret

000000008000415a <sys_unlink>:
{
    8000415a:	7151                	addi	sp,sp,-240
    8000415c:	f586                	sd	ra,232(sp)
    8000415e:	f1a2                	sd	s0,224(sp)
    80004160:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004162:	08000613          	li	a2,128
    80004166:	f3040593          	addi	a1,s0,-208
    8000416a:	4501                	li	a0,0
    8000416c:	b75fd0ef          	jal	80001ce0 <argstr>
    80004170:	16054063          	bltz	a0,800042d0 <sys_unlink+0x176>
    80004174:	eda6                	sd	s1,216(sp)
  begin_op();
    80004176:	e35fe0ef          	jal	80002faa <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000417a:	fb040593          	addi	a1,s0,-80
    8000417e:	f3040513          	addi	a0,s0,-208
    80004182:	c87fe0ef          	jal	80002e08 <nameiparent>
    80004186:	84aa                	mv	s1,a0
    80004188:	c945                	beqz	a0,80004238 <sys_unlink+0xde>
  ilock(dp);
    8000418a:	d8afe0ef          	jal	80002714 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000418e:	00003597          	auipc	a1,0x3
    80004192:	43258593          	addi	a1,a1,1074 # 800075c0 <etext+0x5c0>
    80004196:	fb040513          	addi	a0,s0,-80
    8000419a:	9d9fe0ef          	jal	80002b72 <namecmp>
    8000419e:	10050e63          	beqz	a0,800042ba <sys_unlink+0x160>
    800041a2:	00003597          	auipc	a1,0x3
    800041a6:	42658593          	addi	a1,a1,1062 # 800075c8 <etext+0x5c8>
    800041aa:	fb040513          	addi	a0,s0,-80
    800041ae:	9c5fe0ef          	jal	80002b72 <namecmp>
    800041b2:	10050463          	beqz	a0,800042ba <sys_unlink+0x160>
    800041b6:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800041b8:	f2c40613          	addi	a2,s0,-212
    800041bc:	fb040593          	addi	a1,s0,-80
    800041c0:	8526                	mv	a0,s1
    800041c2:	9c7fe0ef          	jal	80002b88 <dirlookup>
    800041c6:	892a                	mv	s2,a0
    800041c8:	0e050863          	beqz	a0,800042b8 <sys_unlink+0x15e>
  ilock(ip);
    800041cc:	d48fe0ef          	jal	80002714 <ilock>
  if(ip->nlink < 1)
    800041d0:	04a91783          	lh	a5,74(s2)
    800041d4:	06f05763          	blez	a5,80004242 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800041d8:	04491703          	lh	a4,68(s2)
    800041dc:	4785                	li	a5,1
    800041de:	06f70963          	beq	a4,a5,80004250 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800041e2:	4641                	li	a2,16
    800041e4:	4581                	li	a1,0
    800041e6:	fc040513          	addi	a0,s0,-64
    800041ea:	fa7fb0ef          	jal	80000190 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041ee:	4741                	li	a4,16
    800041f0:	f2c42683          	lw	a3,-212(s0)
    800041f4:	fc040613          	addi	a2,s0,-64
    800041f8:	4581                	li	a1,0
    800041fa:	8526                	mv	a0,s1
    800041fc:	869fe0ef          	jal	80002a64 <writei>
    80004200:	47c1                	li	a5,16
    80004202:	08f51b63          	bne	a0,a5,80004298 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004206:	04491703          	lh	a4,68(s2)
    8000420a:	4785                	li	a5,1
    8000420c:	08f70d63          	beq	a4,a5,800042a6 <sys_unlink+0x14c>
  iunlockput(dp);
    80004210:	8526                	mv	a0,s1
    80004212:	f0cfe0ef          	jal	8000291e <iunlockput>
  ip->nlink--;
    80004216:	04a95783          	lhu	a5,74(s2)
    8000421a:	37fd                	addiw	a5,a5,-1
    8000421c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004220:	854a                	mv	a0,s2
    80004222:	c3efe0ef          	jal	80002660 <iupdate>
  iunlockput(ip);
    80004226:	854a                	mv	a0,s2
    80004228:	ef6fe0ef          	jal	8000291e <iunlockput>
  end_op();
    8000422c:	de9fe0ef          	jal	80003014 <end_op>
  return 0;
    80004230:	4501                	li	a0,0
    80004232:	64ee                	ld	s1,216(sp)
    80004234:	694e                	ld	s2,208(sp)
    80004236:	a849                	j	800042c8 <sys_unlink+0x16e>
    end_op();
    80004238:	dddfe0ef          	jal	80003014 <end_op>
    return -1;
    8000423c:	557d                	li	a0,-1
    8000423e:	64ee                	ld	s1,216(sp)
    80004240:	a061                	j	800042c8 <sys_unlink+0x16e>
    80004242:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004244:	00003517          	auipc	a0,0x3
    80004248:	38c50513          	addi	a0,a0,908 # 800075d0 <etext+0x5d0>
    8000424c:	276010ef          	jal	800054c2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004250:	04c92703          	lw	a4,76(s2)
    80004254:	02000793          	li	a5,32
    80004258:	f8e7f5e3          	bgeu	a5,a4,800041e2 <sys_unlink+0x88>
    8000425c:	e5ce                	sd	s3,200(sp)
    8000425e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004262:	4741                	li	a4,16
    80004264:	86ce                	mv	a3,s3
    80004266:	f1840613          	addi	a2,s0,-232
    8000426a:	4581                	li	a1,0
    8000426c:	854a                	mv	a0,s2
    8000426e:	efafe0ef          	jal	80002968 <readi>
    80004272:	47c1                	li	a5,16
    80004274:	00f51c63          	bne	a0,a5,8000428c <sys_unlink+0x132>
    if(de.inum != 0)
    80004278:	f1845783          	lhu	a5,-232(s0)
    8000427c:	efa1                	bnez	a5,800042d4 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000427e:	29c1                	addiw	s3,s3,16
    80004280:	04c92783          	lw	a5,76(s2)
    80004284:	fcf9efe3          	bltu	s3,a5,80004262 <sys_unlink+0x108>
    80004288:	69ae                	ld	s3,200(sp)
    8000428a:	bfa1                	j	800041e2 <sys_unlink+0x88>
      panic("isdirempty: readi");
    8000428c:	00003517          	auipc	a0,0x3
    80004290:	35c50513          	addi	a0,a0,860 # 800075e8 <etext+0x5e8>
    80004294:	22e010ef          	jal	800054c2 <panic>
    80004298:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    8000429a:	00003517          	auipc	a0,0x3
    8000429e:	36650513          	addi	a0,a0,870 # 80007600 <etext+0x600>
    800042a2:	220010ef          	jal	800054c2 <panic>
    dp->nlink--;
    800042a6:	04a4d783          	lhu	a5,74(s1)
    800042aa:	37fd                	addiw	a5,a5,-1
    800042ac:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800042b0:	8526                	mv	a0,s1
    800042b2:	baefe0ef          	jal	80002660 <iupdate>
    800042b6:	bfa9                	j	80004210 <sys_unlink+0xb6>
    800042b8:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800042ba:	8526                	mv	a0,s1
    800042bc:	e62fe0ef          	jal	8000291e <iunlockput>
  end_op();
    800042c0:	d55fe0ef          	jal	80003014 <end_op>
  return -1;
    800042c4:	557d                	li	a0,-1
    800042c6:	64ee                	ld	s1,216(sp)
}
    800042c8:	70ae                	ld	ra,232(sp)
    800042ca:	740e                	ld	s0,224(sp)
    800042cc:	616d                	addi	sp,sp,240
    800042ce:	8082                	ret
    return -1;
    800042d0:	557d                	li	a0,-1
    800042d2:	bfdd                	j	800042c8 <sys_unlink+0x16e>
    iunlockput(ip);
    800042d4:	854a                	mv	a0,s2
    800042d6:	e48fe0ef          	jal	8000291e <iunlockput>
    goto bad;
    800042da:	694e                	ld	s2,208(sp)
    800042dc:	69ae                	ld	s3,200(sp)
    800042de:	bff1                	j	800042ba <sys_unlink+0x160>

00000000800042e0 <sys_open>:

uint64
sys_open(void)
{
    800042e0:	7131                	addi	sp,sp,-192
    800042e2:	fd06                	sd	ra,184(sp)
    800042e4:	f922                	sd	s0,176(sp)
    800042e6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800042e8:	f4c40593          	addi	a1,s0,-180
    800042ec:	4505                	li	a0,1
    800042ee:	9bbfd0ef          	jal	80001ca8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800042f2:	08000613          	li	a2,128
    800042f6:	f5040593          	addi	a1,s0,-176
    800042fa:	4501                	li	a0,0
    800042fc:	9e5fd0ef          	jal	80001ce0 <argstr>
    80004300:	87aa                	mv	a5,a0
    return -1;
    80004302:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004304:	0a07c263          	bltz	a5,800043a8 <sys_open+0xc8>
    80004308:	f526                	sd	s1,168(sp)

  begin_op();
    8000430a:	ca1fe0ef          	jal	80002faa <begin_op>

  if(omode & O_CREATE){
    8000430e:	f4c42783          	lw	a5,-180(s0)
    80004312:	2007f793          	andi	a5,a5,512
    80004316:	c3d5                	beqz	a5,800043ba <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004318:	4681                	li	a3,0
    8000431a:	4601                	li	a2,0
    8000431c:	4589                	li	a1,2
    8000431e:	f5040513          	addi	a0,s0,-176
    80004322:	aa9ff0ef          	jal	80003dca <create>
    80004326:	84aa                	mv	s1,a0
    if(ip == 0){
    80004328:	c541                	beqz	a0,800043b0 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000432a:	04449703          	lh	a4,68(s1)
    8000432e:	478d                	li	a5,3
    80004330:	00f71763          	bne	a4,a5,8000433e <sys_open+0x5e>
    80004334:	0464d703          	lhu	a4,70(s1)
    80004338:	47a5                	li	a5,9
    8000433a:	0ae7ed63          	bltu	a5,a4,800043f4 <sys_open+0x114>
    8000433e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004340:	fe1fe0ef          	jal	80003320 <filealloc>
    80004344:	892a                	mv	s2,a0
    80004346:	c179                	beqz	a0,8000440c <sys_open+0x12c>
    80004348:	ed4e                	sd	s3,152(sp)
    8000434a:	a43ff0ef          	jal	80003d8c <fdalloc>
    8000434e:	89aa                	mv	s3,a0
    80004350:	0a054a63          	bltz	a0,80004404 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004354:	04449703          	lh	a4,68(s1)
    80004358:	478d                	li	a5,3
    8000435a:	0cf70263          	beq	a4,a5,8000441e <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000435e:	4789                	li	a5,2
    80004360:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004364:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004368:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000436c:	f4c42783          	lw	a5,-180(s0)
    80004370:	0017c713          	xori	a4,a5,1
    80004374:	8b05                	andi	a4,a4,1
    80004376:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000437a:	0037f713          	andi	a4,a5,3
    8000437e:	00e03733          	snez	a4,a4
    80004382:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004386:	4007f793          	andi	a5,a5,1024
    8000438a:	c791                	beqz	a5,80004396 <sys_open+0xb6>
    8000438c:	04449703          	lh	a4,68(s1)
    80004390:	4789                	li	a5,2
    80004392:	08f70d63          	beq	a4,a5,8000442c <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004396:	8526                	mv	a0,s1
    80004398:	c2afe0ef          	jal	800027c2 <iunlock>
  end_op();
    8000439c:	c79fe0ef          	jal	80003014 <end_op>

  return fd;
    800043a0:	854e                	mv	a0,s3
    800043a2:	74aa                	ld	s1,168(sp)
    800043a4:	790a                	ld	s2,160(sp)
    800043a6:	69ea                	ld	s3,152(sp)
}
    800043a8:	70ea                	ld	ra,184(sp)
    800043aa:	744a                	ld	s0,176(sp)
    800043ac:	6129                	addi	sp,sp,192
    800043ae:	8082                	ret
      end_op();
    800043b0:	c65fe0ef          	jal	80003014 <end_op>
      return -1;
    800043b4:	557d                	li	a0,-1
    800043b6:	74aa                	ld	s1,168(sp)
    800043b8:	bfc5                	j	800043a8 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800043ba:	f5040513          	addi	a0,s0,-176
    800043be:	a31fe0ef          	jal	80002dee <namei>
    800043c2:	84aa                	mv	s1,a0
    800043c4:	c11d                	beqz	a0,800043ea <sys_open+0x10a>
    ilock(ip);
    800043c6:	b4efe0ef          	jal	80002714 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800043ca:	04449703          	lh	a4,68(s1)
    800043ce:	4785                	li	a5,1
    800043d0:	f4f71de3          	bne	a4,a5,8000432a <sys_open+0x4a>
    800043d4:	f4c42783          	lw	a5,-180(s0)
    800043d8:	d3bd                	beqz	a5,8000433e <sys_open+0x5e>
      iunlockput(ip);
    800043da:	8526                	mv	a0,s1
    800043dc:	d42fe0ef          	jal	8000291e <iunlockput>
      end_op();
    800043e0:	c35fe0ef          	jal	80003014 <end_op>
      return -1;
    800043e4:	557d                	li	a0,-1
    800043e6:	74aa                	ld	s1,168(sp)
    800043e8:	b7c1                	j	800043a8 <sys_open+0xc8>
      end_op();
    800043ea:	c2bfe0ef          	jal	80003014 <end_op>
      return -1;
    800043ee:	557d                	li	a0,-1
    800043f0:	74aa                	ld	s1,168(sp)
    800043f2:	bf5d                	j	800043a8 <sys_open+0xc8>
    iunlockput(ip);
    800043f4:	8526                	mv	a0,s1
    800043f6:	d28fe0ef          	jal	8000291e <iunlockput>
    end_op();
    800043fa:	c1bfe0ef          	jal	80003014 <end_op>
    return -1;
    800043fe:	557d                	li	a0,-1
    80004400:	74aa                	ld	s1,168(sp)
    80004402:	b75d                	j	800043a8 <sys_open+0xc8>
      fileclose(f);
    80004404:	854a                	mv	a0,s2
    80004406:	fbffe0ef          	jal	800033c4 <fileclose>
    8000440a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000440c:	8526                	mv	a0,s1
    8000440e:	d10fe0ef          	jal	8000291e <iunlockput>
    end_op();
    80004412:	c03fe0ef          	jal	80003014 <end_op>
    return -1;
    80004416:	557d                	li	a0,-1
    80004418:	74aa                	ld	s1,168(sp)
    8000441a:	790a                	ld	s2,160(sp)
    8000441c:	b771                	j	800043a8 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000441e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004422:	04649783          	lh	a5,70(s1)
    80004426:	02f91223          	sh	a5,36(s2)
    8000442a:	bf3d                	j	80004368 <sys_open+0x88>
    itrunc(ip);
    8000442c:	8526                	mv	a0,s1
    8000442e:	bd4fe0ef          	jal	80002802 <itrunc>
    80004432:	b795                	j	80004396 <sys_open+0xb6>

0000000080004434 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004434:	7175                	addi	sp,sp,-144
    80004436:	e506                	sd	ra,136(sp)
    80004438:	e122                	sd	s0,128(sp)
    8000443a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000443c:	b6ffe0ef          	jal	80002faa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004440:	08000613          	li	a2,128
    80004444:	f7040593          	addi	a1,s0,-144
    80004448:	4501                	li	a0,0
    8000444a:	897fd0ef          	jal	80001ce0 <argstr>
    8000444e:	02054363          	bltz	a0,80004474 <sys_mkdir+0x40>
    80004452:	4681                	li	a3,0
    80004454:	4601                	li	a2,0
    80004456:	4585                	li	a1,1
    80004458:	f7040513          	addi	a0,s0,-144
    8000445c:	96fff0ef          	jal	80003dca <create>
    80004460:	c911                	beqz	a0,80004474 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004462:	cbcfe0ef          	jal	8000291e <iunlockput>
  end_op();
    80004466:	baffe0ef          	jal	80003014 <end_op>
  return 0;
    8000446a:	4501                	li	a0,0
}
    8000446c:	60aa                	ld	ra,136(sp)
    8000446e:	640a                	ld	s0,128(sp)
    80004470:	6149                	addi	sp,sp,144
    80004472:	8082                	ret
    end_op();
    80004474:	ba1fe0ef          	jal	80003014 <end_op>
    return -1;
    80004478:	557d                	li	a0,-1
    8000447a:	bfcd                	j	8000446c <sys_mkdir+0x38>

000000008000447c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000447c:	7135                	addi	sp,sp,-160
    8000447e:	ed06                	sd	ra,152(sp)
    80004480:	e922                	sd	s0,144(sp)
    80004482:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004484:	b27fe0ef          	jal	80002faa <begin_op>
  argint(1, &major);
    80004488:	f6c40593          	addi	a1,s0,-148
    8000448c:	4505                	li	a0,1
    8000448e:	81bfd0ef          	jal	80001ca8 <argint>
  argint(2, &minor);
    80004492:	f6840593          	addi	a1,s0,-152
    80004496:	4509                	li	a0,2
    80004498:	811fd0ef          	jal	80001ca8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000449c:	08000613          	li	a2,128
    800044a0:	f7040593          	addi	a1,s0,-144
    800044a4:	4501                	li	a0,0
    800044a6:	83bfd0ef          	jal	80001ce0 <argstr>
    800044aa:	02054563          	bltz	a0,800044d4 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800044ae:	f6841683          	lh	a3,-152(s0)
    800044b2:	f6c41603          	lh	a2,-148(s0)
    800044b6:	458d                	li	a1,3
    800044b8:	f7040513          	addi	a0,s0,-144
    800044bc:	90fff0ef          	jal	80003dca <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800044c0:	c911                	beqz	a0,800044d4 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800044c2:	c5cfe0ef          	jal	8000291e <iunlockput>
  end_op();
    800044c6:	b4ffe0ef          	jal	80003014 <end_op>
  return 0;
    800044ca:	4501                	li	a0,0
}
    800044cc:	60ea                	ld	ra,152(sp)
    800044ce:	644a                	ld	s0,144(sp)
    800044d0:	610d                	addi	sp,sp,160
    800044d2:	8082                	ret
    end_op();
    800044d4:	b41fe0ef          	jal	80003014 <end_op>
    return -1;
    800044d8:	557d                	li	a0,-1
    800044da:	bfcd                	j	800044cc <sys_mknod+0x50>

00000000800044dc <sys_chdir>:

uint64
sys_chdir(void)
{
    800044dc:	7135                	addi	sp,sp,-160
    800044de:	ed06                	sd	ra,152(sp)
    800044e0:	e922                	sd	s0,144(sp)
    800044e2:	e14a                	sd	s2,128(sp)
    800044e4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800044e6:	8c3fc0ef          	jal	80000da8 <myproc>
    800044ea:	892a                	mv	s2,a0
  
  begin_op();
    800044ec:	abffe0ef          	jal	80002faa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800044f0:	08000613          	li	a2,128
    800044f4:	f6040593          	addi	a1,s0,-160
    800044f8:	4501                	li	a0,0
    800044fa:	fe6fd0ef          	jal	80001ce0 <argstr>
    800044fe:	04054363          	bltz	a0,80004544 <sys_chdir+0x68>
    80004502:	e526                	sd	s1,136(sp)
    80004504:	f6040513          	addi	a0,s0,-160
    80004508:	8e7fe0ef          	jal	80002dee <namei>
    8000450c:	84aa                	mv	s1,a0
    8000450e:	c915                	beqz	a0,80004542 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004510:	a04fe0ef          	jal	80002714 <ilock>
  if(ip->type != T_DIR){
    80004514:	04449703          	lh	a4,68(s1)
    80004518:	4785                	li	a5,1
    8000451a:	02f71963          	bne	a4,a5,8000454c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000451e:	8526                	mv	a0,s1
    80004520:	aa2fe0ef          	jal	800027c2 <iunlock>
  iput(p->cwd);
    80004524:	15093503          	ld	a0,336(s2)
    80004528:	b6efe0ef          	jal	80002896 <iput>
  end_op();
    8000452c:	ae9fe0ef          	jal	80003014 <end_op>
  p->cwd = ip;
    80004530:	14993823          	sd	s1,336(s2)
  return 0;
    80004534:	4501                	li	a0,0
    80004536:	64aa                	ld	s1,136(sp)
}
    80004538:	60ea                	ld	ra,152(sp)
    8000453a:	644a                	ld	s0,144(sp)
    8000453c:	690a                	ld	s2,128(sp)
    8000453e:	610d                	addi	sp,sp,160
    80004540:	8082                	ret
    80004542:	64aa                	ld	s1,136(sp)
    end_op();
    80004544:	ad1fe0ef          	jal	80003014 <end_op>
    return -1;
    80004548:	557d                	li	a0,-1
    8000454a:	b7fd                	j	80004538 <sys_chdir+0x5c>
    iunlockput(ip);
    8000454c:	8526                	mv	a0,s1
    8000454e:	bd0fe0ef          	jal	8000291e <iunlockput>
    end_op();
    80004552:	ac3fe0ef          	jal	80003014 <end_op>
    return -1;
    80004556:	557d                	li	a0,-1
    80004558:	64aa                	ld	s1,136(sp)
    8000455a:	bff9                	j	80004538 <sys_chdir+0x5c>

000000008000455c <sys_exec>:

uint64
sys_exec(void)
{
    8000455c:	7121                	addi	sp,sp,-448
    8000455e:	ff06                	sd	ra,440(sp)
    80004560:	fb22                	sd	s0,432(sp)
    80004562:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004564:	e4840593          	addi	a1,s0,-440
    80004568:	4505                	li	a0,1
    8000456a:	f5afd0ef          	jal	80001cc4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000456e:	08000613          	li	a2,128
    80004572:	f5040593          	addi	a1,s0,-176
    80004576:	4501                	li	a0,0
    80004578:	f68fd0ef          	jal	80001ce0 <argstr>
    8000457c:	87aa                	mv	a5,a0
    return -1;
    8000457e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004580:	0c07c463          	bltz	a5,80004648 <sys_exec+0xec>
    80004584:	f726                	sd	s1,424(sp)
    80004586:	f34a                	sd	s2,416(sp)
    80004588:	ef4e                	sd	s3,408(sp)
    8000458a:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000458c:	10000613          	li	a2,256
    80004590:	4581                	li	a1,0
    80004592:	e5040513          	addi	a0,s0,-432
    80004596:	bfbfb0ef          	jal	80000190 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000459a:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000459e:	89a6                	mv	s3,s1
    800045a0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800045a2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800045a6:	00391513          	slli	a0,s2,0x3
    800045aa:	e4040593          	addi	a1,s0,-448
    800045ae:	e4843783          	ld	a5,-440(s0)
    800045b2:	953e                	add	a0,a0,a5
    800045b4:	e6afd0ef          	jal	80001c1e <fetchaddr>
    800045b8:	02054663          	bltz	a0,800045e4 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800045bc:	e4043783          	ld	a5,-448(s0)
    800045c0:	c3a9                	beqz	a5,80004602 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800045c2:	b3dfb0ef          	jal	800000fe <kalloc>
    800045c6:	85aa                	mv	a1,a0
    800045c8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800045cc:	cd01                	beqz	a0,800045e4 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800045ce:	6605                	lui	a2,0x1
    800045d0:	e4043503          	ld	a0,-448(s0)
    800045d4:	e94fd0ef          	jal	80001c68 <fetchstr>
    800045d8:	00054663          	bltz	a0,800045e4 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800045dc:	0905                	addi	s2,s2,1
    800045de:	09a1                	addi	s3,s3,8
    800045e0:	fd4913e3          	bne	s2,s4,800045a6 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045e4:	f5040913          	addi	s2,s0,-176
    800045e8:	6088                	ld	a0,0(s1)
    800045ea:	c931                	beqz	a0,8000463e <sys_exec+0xe2>
    kfree(argv[i]);
    800045ec:	a31fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045f0:	04a1                	addi	s1,s1,8
    800045f2:	ff249be3          	bne	s1,s2,800045e8 <sys_exec+0x8c>
  return -1;
    800045f6:	557d                	li	a0,-1
    800045f8:	74ba                	ld	s1,424(sp)
    800045fa:	791a                	ld	s2,416(sp)
    800045fc:	69fa                	ld	s3,408(sp)
    800045fe:	6a5a                	ld	s4,400(sp)
    80004600:	a0a1                	j	80004648 <sys_exec+0xec>
      argv[i] = 0;
    80004602:	0009079b          	sext.w	a5,s2
    80004606:	078e                	slli	a5,a5,0x3
    80004608:	fd078793          	addi	a5,a5,-48
    8000460c:	97a2                	add	a5,a5,s0
    8000460e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004612:	e5040593          	addi	a1,s0,-432
    80004616:	f5040513          	addi	a0,s0,-176
    8000461a:	ba8ff0ef          	jal	800039c2 <exec>
    8000461e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004620:	f5040993          	addi	s3,s0,-176
    80004624:	6088                	ld	a0,0(s1)
    80004626:	c511                	beqz	a0,80004632 <sys_exec+0xd6>
    kfree(argv[i]);
    80004628:	9f5fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000462c:	04a1                	addi	s1,s1,8
    8000462e:	ff349be3          	bne	s1,s3,80004624 <sys_exec+0xc8>
  return ret;
    80004632:	854a                	mv	a0,s2
    80004634:	74ba                	ld	s1,424(sp)
    80004636:	791a                	ld	s2,416(sp)
    80004638:	69fa                	ld	s3,408(sp)
    8000463a:	6a5a                	ld	s4,400(sp)
    8000463c:	a031                	j	80004648 <sys_exec+0xec>
  return -1;
    8000463e:	557d                	li	a0,-1
    80004640:	74ba                	ld	s1,424(sp)
    80004642:	791a                	ld	s2,416(sp)
    80004644:	69fa                	ld	s3,408(sp)
    80004646:	6a5a                	ld	s4,400(sp)
}
    80004648:	70fa                	ld	ra,440(sp)
    8000464a:	745a                	ld	s0,432(sp)
    8000464c:	6139                	addi	sp,sp,448
    8000464e:	8082                	ret

0000000080004650 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004650:	7139                	addi	sp,sp,-64
    80004652:	fc06                	sd	ra,56(sp)
    80004654:	f822                	sd	s0,48(sp)
    80004656:	f426                	sd	s1,40(sp)
    80004658:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000465a:	f4efc0ef          	jal	80000da8 <myproc>
    8000465e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004660:	fd840593          	addi	a1,s0,-40
    80004664:	4501                	li	a0,0
    80004666:	e5efd0ef          	jal	80001cc4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000466a:	fc840593          	addi	a1,s0,-56
    8000466e:	fd040513          	addi	a0,s0,-48
    80004672:	85cff0ef          	jal	800036ce <pipealloc>
    return -1;
    80004676:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004678:	0a054463          	bltz	a0,80004720 <sys_pipe+0xd0>
  fd0 = -1;
    8000467c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004680:	fd043503          	ld	a0,-48(s0)
    80004684:	f08ff0ef          	jal	80003d8c <fdalloc>
    80004688:	fca42223          	sw	a0,-60(s0)
    8000468c:	08054163          	bltz	a0,8000470e <sys_pipe+0xbe>
    80004690:	fc843503          	ld	a0,-56(s0)
    80004694:	ef8ff0ef          	jal	80003d8c <fdalloc>
    80004698:	fca42023          	sw	a0,-64(s0)
    8000469c:	06054063          	bltz	a0,800046fc <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800046a0:	4691                	li	a3,4
    800046a2:	fc440613          	addi	a2,s0,-60
    800046a6:	fd843583          	ld	a1,-40(s0)
    800046aa:	68a8                	ld	a0,80(s1)
    800046ac:	b6efc0ef          	jal	80000a1a <copyout>
    800046b0:	00054e63          	bltz	a0,800046cc <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800046b4:	4691                	li	a3,4
    800046b6:	fc040613          	addi	a2,s0,-64
    800046ba:	fd843583          	ld	a1,-40(s0)
    800046be:	0591                	addi	a1,a1,4
    800046c0:	68a8                	ld	a0,80(s1)
    800046c2:	b58fc0ef          	jal	80000a1a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800046c6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800046c8:	04055c63          	bgez	a0,80004720 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800046cc:	fc442783          	lw	a5,-60(s0)
    800046d0:	07e9                	addi	a5,a5,26
    800046d2:	078e                	slli	a5,a5,0x3
    800046d4:	97a6                	add	a5,a5,s1
    800046d6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800046da:	fc042783          	lw	a5,-64(s0)
    800046de:	07e9                	addi	a5,a5,26
    800046e0:	078e                	slli	a5,a5,0x3
    800046e2:	94be                	add	s1,s1,a5
    800046e4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800046e8:	fd043503          	ld	a0,-48(s0)
    800046ec:	cd9fe0ef          	jal	800033c4 <fileclose>
    fileclose(wf);
    800046f0:	fc843503          	ld	a0,-56(s0)
    800046f4:	cd1fe0ef          	jal	800033c4 <fileclose>
    return -1;
    800046f8:	57fd                	li	a5,-1
    800046fa:	a01d                	j	80004720 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800046fc:	fc442783          	lw	a5,-60(s0)
    80004700:	0007c763          	bltz	a5,8000470e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004704:	07e9                	addi	a5,a5,26
    80004706:	078e                	slli	a5,a5,0x3
    80004708:	97a6                	add	a5,a5,s1
    8000470a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000470e:	fd043503          	ld	a0,-48(s0)
    80004712:	cb3fe0ef          	jal	800033c4 <fileclose>
    fileclose(wf);
    80004716:	fc843503          	ld	a0,-56(s0)
    8000471a:	cabfe0ef          	jal	800033c4 <fileclose>
    return -1;
    8000471e:	57fd                	li	a5,-1
}
    80004720:	853e                	mv	a0,a5
    80004722:	70e2                	ld	ra,56(sp)
    80004724:	7442                	ld	s0,48(sp)
    80004726:	74a2                	ld	s1,40(sp)
    80004728:	6121                	addi	sp,sp,64
    8000472a:	8082                	ret
    8000472c:	0000                	unimp
	...

0000000080004730 <kernelvec>:
    80004730:	7111                	addi	sp,sp,-256
    80004732:	e006                	sd	ra,0(sp)
    80004734:	e40a                	sd	sp,8(sp)
    80004736:	e80e                	sd	gp,16(sp)
    80004738:	ec12                	sd	tp,24(sp)
    8000473a:	f016                	sd	t0,32(sp)
    8000473c:	f41a                	sd	t1,40(sp)
    8000473e:	f81e                	sd	t2,48(sp)
    80004740:	e4aa                	sd	a0,72(sp)
    80004742:	e8ae                	sd	a1,80(sp)
    80004744:	ecb2                	sd	a2,88(sp)
    80004746:	f0b6                	sd	a3,96(sp)
    80004748:	f4ba                	sd	a4,104(sp)
    8000474a:	f8be                	sd	a5,112(sp)
    8000474c:	fcc2                	sd	a6,120(sp)
    8000474e:	e146                	sd	a7,128(sp)
    80004750:	edf2                	sd	t3,216(sp)
    80004752:	f1f6                	sd	t4,224(sp)
    80004754:	f5fa                	sd	t5,232(sp)
    80004756:	f9fe                	sd	t6,240(sp)
    80004758:	bd6fd0ef          	jal	80001b2e <kerneltrap>
    8000475c:	6082                	ld	ra,0(sp)
    8000475e:	6122                	ld	sp,8(sp)
    80004760:	61c2                	ld	gp,16(sp)
    80004762:	7282                	ld	t0,32(sp)
    80004764:	7322                	ld	t1,40(sp)
    80004766:	73c2                	ld	t2,48(sp)
    80004768:	6526                	ld	a0,72(sp)
    8000476a:	65c6                	ld	a1,80(sp)
    8000476c:	6666                	ld	a2,88(sp)
    8000476e:	7686                	ld	a3,96(sp)
    80004770:	7726                	ld	a4,104(sp)
    80004772:	77c6                	ld	a5,112(sp)
    80004774:	7866                	ld	a6,120(sp)
    80004776:	688a                	ld	a7,128(sp)
    80004778:	6e6e                	ld	t3,216(sp)
    8000477a:	7e8e                	ld	t4,224(sp)
    8000477c:	7f2e                	ld	t5,232(sp)
    8000477e:	7fce                	ld	t6,240(sp)
    80004780:	6111                	addi	sp,sp,256
    80004782:	10200073          	sret
	...

000000008000478e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000478e:	1141                	addi	sp,sp,-16
    80004790:	e422                	sd	s0,8(sp)
    80004792:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004794:	0c0007b7          	lui	a5,0xc000
    80004798:	4705                	li	a4,1
    8000479a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000479c:	0c0007b7          	lui	a5,0xc000
    800047a0:	c3d8                	sw	a4,4(a5)
}
    800047a2:	6422                	ld	s0,8(sp)
    800047a4:	0141                	addi	sp,sp,16
    800047a6:	8082                	ret

00000000800047a8 <plicinithart>:

void
plicinithart(void)
{
    800047a8:	1141                	addi	sp,sp,-16
    800047aa:	e406                	sd	ra,8(sp)
    800047ac:	e022                	sd	s0,0(sp)
    800047ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800047b0:	dccfc0ef          	jal	80000d7c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800047b4:	0085171b          	slliw	a4,a0,0x8
    800047b8:	0c0027b7          	lui	a5,0xc002
    800047bc:	97ba                	add	a5,a5,a4
    800047be:	40200713          	li	a4,1026
    800047c2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800047c6:	00d5151b          	slliw	a0,a0,0xd
    800047ca:	0c2017b7          	lui	a5,0xc201
    800047ce:	97aa                	add	a5,a5,a0
    800047d0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800047d4:	60a2                	ld	ra,8(sp)
    800047d6:	6402                	ld	s0,0(sp)
    800047d8:	0141                	addi	sp,sp,16
    800047da:	8082                	ret

00000000800047dc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800047dc:	1141                	addi	sp,sp,-16
    800047de:	e406                	sd	ra,8(sp)
    800047e0:	e022                	sd	s0,0(sp)
    800047e2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800047e4:	d98fc0ef          	jal	80000d7c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800047e8:	00d5151b          	slliw	a0,a0,0xd
    800047ec:	0c2017b7          	lui	a5,0xc201
    800047f0:	97aa                	add	a5,a5,a0
  return irq;
}
    800047f2:	43c8                	lw	a0,4(a5)
    800047f4:	60a2                	ld	ra,8(sp)
    800047f6:	6402                	ld	s0,0(sp)
    800047f8:	0141                	addi	sp,sp,16
    800047fa:	8082                	ret

00000000800047fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800047fc:	1101                	addi	sp,sp,-32
    800047fe:	ec06                	sd	ra,24(sp)
    80004800:	e822                	sd	s0,16(sp)
    80004802:	e426                	sd	s1,8(sp)
    80004804:	1000                	addi	s0,sp,32
    80004806:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004808:	d74fc0ef          	jal	80000d7c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000480c:	00d5151b          	slliw	a0,a0,0xd
    80004810:	0c2017b7          	lui	a5,0xc201
    80004814:	97aa                	add	a5,a5,a0
    80004816:	c3c4                	sw	s1,4(a5)
}
    80004818:	60e2                	ld	ra,24(sp)
    8000481a:	6442                	ld	s0,16(sp)
    8000481c:	64a2                	ld	s1,8(sp)
    8000481e:	6105                	addi	sp,sp,32
    80004820:	8082                	ret

0000000080004822 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004822:	1141                	addi	sp,sp,-16
    80004824:	e406                	sd	ra,8(sp)
    80004826:	e022                	sd	s0,0(sp)
    80004828:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000482a:	479d                	li	a5,7
    8000482c:	04a7ca63          	blt	a5,a0,80004880 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004830:	00017797          	auipc	a5,0x17
    80004834:	b7078793          	addi	a5,a5,-1168 # 8001b3a0 <disk>
    80004838:	97aa                	add	a5,a5,a0
    8000483a:	0187c783          	lbu	a5,24(a5)
    8000483e:	e7b9                	bnez	a5,8000488c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004840:	00451693          	slli	a3,a0,0x4
    80004844:	00017797          	auipc	a5,0x17
    80004848:	b5c78793          	addi	a5,a5,-1188 # 8001b3a0 <disk>
    8000484c:	6398                	ld	a4,0(a5)
    8000484e:	9736                	add	a4,a4,a3
    80004850:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004854:	6398                	ld	a4,0(a5)
    80004856:	9736                	add	a4,a4,a3
    80004858:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000485c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004860:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004864:	97aa                	add	a5,a5,a0
    80004866:	4705                	li	a4,1
    80004868:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000486c:	00017517          	auipc	a0,0x17
    80004870:	b4c50513          	addi	a0,a0,-1204 # 8001b3b8 <disk+0x18>
    80004874:	b4ffc0ef          	jal	800013c2 <wakeup>
}
    80004878:	60a2                	ld	ra,8(sp)
    8000487a:	6402                	ld	s0,0(sp)
    8000487c:	0141                	addi	sp,sp,16
    8000487e:	8082                	ret
    panic("free_desc 1");
    80004880:	00003517          	auipc	a0,0x3
    80004884:	d9050513          	addi	a0,a0,-624 # 80007610 <etext+0x610>
    80004888:	43b000ef          	jal	800054c2 <panic>
    panic("free_desc 2");
    8000488c:	00003517          	auipc	a0,0x3
    80004890:	d9450513          	addi	a0,a0,-620 # 80007620 <etext+0x620>
    80004894:	42f000ef          	jal	800054c2 <panic>

0000000080004898 <virtio_disk_init>:
{
    80004898:	1101                	addi	sp,sp,-32
    8000489a:	ec06                	sd	ra,24(sp)
    8000489c:	e822                	sd	s0,16(sp)
    8000489e:	e426                	sd	s1,8(sp)
    800048a0:	e04a                	sd	s2,0(sp)
    800048a2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800048a4:	00003597          	auipc	a1,0x3
    800048a8:	d8c58593          	addi	a1,a1,-628 # 80007630 <etext+0x630>
    800048ac:	00017517          	auipc	a0,0x17
    800048b0:	c1c50513          	addi	a0,a0,-996 # 8001b4c8 <disk+0x128>
    800048b4:	6bd000ef          	jal	80005770 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800048b8:	100017b7          	lui	a5,0x10001
    800048bc:	4398                	lw	a4,0(a5)
    800048be:	2701                	sext.w	a4,a4
    800048c0:	747277b7          	lui	a5,0x74727
    800048c4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800048c8:	18f71063          	bne	a4,a5,80004a48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800048cc:	100017b7          	lui	a5,0x10001
    800048d0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800048d2:	439c                	lw	a5,0(a5)
    800048d4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800048d6:	4709                	li	a4,2
    800048d8:	16e79863          	bne	a5,a4,80004a48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800048dc:	100017b7          	lui	a5,0x10001
    800048e0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800048e2:	439c                	lw	a5,0(a5)
    800048e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800048e6:	16e79163          	bne	a5,a4,80004a48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800048ea:	100017b7          	lui	a5,0x10001
    800048ee:	47d8                	lw	a4,12(a5)
    800048f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800048f2:	554d47b7          	lui	a5,0x554d4
    800048f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800048fa:	14f71763          	bne	a4,a5,80004a48 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800048fe:	100017b7          	lui	a5,0x10001
    80004902:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004906:	4705                	li	a4,1
    80004908:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000490a:	470d                	li	a4,3
    8000490c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000490e:	10001737          	lui	a4,0x10001
    80004912:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004914:	c7ffe737          	lui	a4,0xc7ffe
    80004918:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb17f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000491c:	8ef9                	and	a3,a3,a4
    8000491e:	10001737          	lui	a4,0x10001
    80004922:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004924:	472d                	li	a4,11
    80004926:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004928:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000492c:	439c                	lw	a5,0(a5)
    8000492e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004932:	8ba1                	andi	a5,a5,8
    80004934:	12078063          	beqz	a5,80004a54 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004938:	100017b7          	lui	a5,0x10001
    8000493c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004940:	100017b7          	lui	a5,0x10001
    80004944:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004948:	439c                	lw	a5,0(a5)
    8000494a:	2781                	sext.w	a5,a5
    8000494c:	10079a63          	bnez	a5,80004a60 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004950:	100017b7          	lui	a5,0x10001
    80004954:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004958:	439c                	lw	a5,0(a5)
    8000495a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000495c:	10078863          	beqz	a5,80004a6c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004960:	471d                	li	a4,7
    80004962:	10f77b63          	bgeu	a4,a5,80004a78 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004966:	f98fb0ef          	jal	800000fe <kalloc>
    8000496a:	00017497          	auipc	s1,0x17
    8000496e:	a3648493          	addi	s1,s1,-1482 # 8001b3a0 <disk>
    80004972:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004974:	f8afb0ef          	jal	800000fe <kalloc>
    80004978:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000497a:	f84fb0ef          	jal	800000fe <kalloc>
    8000497e:	87aa                	mv	a5,a0
    80004980:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004982:	6088                	ld	a0,0(s1)
    80004984:	10050063          	beqz	a0,80004a84 <virtio_disk_init+0x1ec>
    80004988:	00017717          	auipc	a4,0x17
    8000498c:	a2073703          	ld	a4,-1504(a4) # 8001b3a8 <disk+0x8>
    80004990:	0e070a63          	beqz	a4,80004a84 <virtio_disk_init+0x1ec>
    80004994:	0e078863          	beqz	a5,80004a84 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004998:	6605                	lui	a2,0x1
    8000499a:	4581                	li	a1,0
    8000499c:	ff4fb0ef          	jal	80000190 <memset>
  memset(disk.avail, 0, PGSIZE);
    800049a0:	00017497          	auipc	s1,0x17
    800049a4:	a0048493          	addi	s1,s1,-1536 # 8001b3a0 <disk>
    800049a8:	6605                	lui	a2,0x1
    800049aa:	4581                	li	a1,0
    800049ac:	6488                	ld	a0,8(s1)
    800049ae:	fe2fb0ef          	jal	80000190 <memset>
  memset(disk.used, 0, PGSIZE);
    800049b2:	6605                	lui	a2,0x1
    800049b4:	4581                	li	a1,0
    800049b6:	6888                	ld	a0,16(s1)
    800049b8:	fd8fb0ef          	jal	80000190 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800049bc:	100017b7          	lui	a5,0x10001
    800049c0:	4721                	li	a4,8
    800049c2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800049c4:	4098                	lw	a4,0(s1)
    800049c6:	100017b7          	lui	a5,0x10001
    800049ca:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800049ce:	40d8                	lw	a4,4(s1)
    800049d0:	100017b7          	lui	a5,0x10001
    800049d4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800049d8:	649c                	ld	a5,8(s1)
    800049da:	0007869b          	sext.w	a3,a5
    800049de:	10001737          	lui	a4,0x10001
    800049e2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800049e6:	9781                	srai	a5,a5,0x20
    800049e8:	10001737          	lui	a4,0x10001
    800049ec:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800049f0:	689c                	ld	a5,16(s1)
    800049f2:	0007869b          	sext.w	a3,a5
    800049f6:	10001737          	lui	a4,0x10001
    800049fa:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800049fe:	9781                	srai	a5,a5,0x20
    80004a00:	10001737          	lui	a4,0x10001
    80004a04:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004a08:	10001737          	lui	a4,0x10001
    80004a0c:	4785                	li	a5,1
    80004a0e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004a10:	00f48c23          	sb	a5,24(s1)
    80004a14:	00f48ca3          	sb	a5,25(s1)
    80004a18:	00f48d23          	sb	a5,26(s1)
    80004a1c:	00f48da3          	sb	a5,27(s1)
    80004a20:	00f48e23          	sb	a5,28(s1)
    80004a24:	00f48ea3          	sb	a5,29(s1)
    80004a28:	00f48f23          	sb	a5,30(s1)
    80004a2c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004a30:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a34:	100017b7          	lui	a5,0x10001
    80004a38:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004a3c:	60e2                	ld	ra,24(sp)
    80004a3e:	6442                	ld	s0,16(sp)
    80004a40:	64a2                	ld	s1,8(sp)
    80004a42:	6902                	ld	s2,0(sp)
    80004a44:	6105                	addi	sp,sp,32
    80004a46:	8082                	ret
    panic("could not find virtio disk");
    80004a48:	00003517          	auipc	a0,0x3
    80004a4c:	bf850513          	addi	a0,a0,-1032 # 80007640 <etext+0x640>
    80004a50:	273000ef          	jal	800054c2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004a54:	00003517          	auipc	a0,0x3
    80004a58:	c0c50513          	addi	a0,a0,-1012 # 80007660 <etext+0x660>
    80004a5c:	267000ef          	jal	800054c2 <panic>
    panic("virtio disk should not be ready");
    80004a60:	00003517          	auipc	a0,0x3
    80004a64:	c2050513          	addi	a0,a0,-992 # 80007680 <etext+0x680>
    80004a68:	25b000ef          	jal	800054c2 <panic>
    panic("virtio disk has no queue 0");
    80004a6c:	00003517          	auipc	a0,0x3
    80004a70:	c3450513          	addi	a0,a0,-972 # 800076a0 <etext+0x6a0>
    80004a74:	24f000ef          	jal	800054c2 <panic>
    panic("virtio disk max queue too short");
    80004a78:	00003517          	auipc	a0,0x3
    80004a7c:	c4850513          	addi	a0,a0,-952 # 800076c0 <etext+0x6c0>
    80004a80:	243000ef          	jal	800054c2 <panic>
    panic("virtio disk kalloc");
    80004a84:	00003517          	auipc	a0,0x3
    80004a88:	c5c50513          	addi	a0,a0,-932 # 800076e0 <etext+0x6e0>
    80004a8c:	237000ef          	jal	800054c2 <panic>

0000000080004a90 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004a90:	7159                	addi	sp,sp,-112
    80004a92:	f486                	sd	ra,104(sp)
    80004a94:	f0a2                	sd	s0,96(sp)
    80004a96:	eca6                	sd	s1,88(sp)
    80004a98:	e8ca                	sd	s2,80(sp)
    80004a9a:	e4ce                	sd	s3,72(sp)
    80004a9c:	e0d2                	sd	s4,64(sp)
    80004a9e:	fc56                	sd	s5,56(sp)
    80004aa0:	f85a                	sd	s6,48(sp)
    80004aa2:	f45e                	sd	s7,40(sp)
    80004aa4:	f062                	sd	s8,32(sp)
    80004aa6:	ec66                	sd	s9,24(sp)
    80004aa8:	1880                	addi	s0,sp,112
    80004aaa:	8a2a                	mv	s4,a0
    80004aac:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004aae:	00c52c83          	lw	s9,12(a0)
    80004ab2:	001c9c9b          	slliw	s9,s9,0x1
    80004ab6:	1c82                	slli	s9,s9,0x20
    80004ab8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004abc:	00017517          	auipc	a0,0x17
    80004ac0:	a0c50513          	addi	a0,a0,-1524 # 8001b4c8 <disk+0x128>
    80004ac4:	52d000ef          	jal	800057f0 <acquire>
  for(int i = 0; i < 3; i++){
    80004ac8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004aca:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004acc:	00017b17          	auipc	s6,0x17
    80004ad0:	8d4b0b13          	addi	s6,s6,-1836 # 8001b3a0 <disk>
  for(int i = 0; i < 3; i++){
    80004ad4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004ad6:	00017c17          	auipc	s8,0x17
    80004ada:	9f2c0c13          	addi	s8,s8,-1550 # 8001b4c8 <disk+0x128>
    80004ade:	a8b9                	j	80004b3c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004ae0:	00fb0733          	add	a4,s6,a5
    80004ae4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004ae8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004aea:	0207c563          	bltz	a5,80004b14 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004aee:	2905                	addiw	s2,s2,1
    80004af0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004af2:	05590963          	beq	s2,s5,80004b44 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004af6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004af8:	00017717          	auipc	a4,0x17
    80004afc:	8a870713          	addi	a4,a4,-1880 # 8001b3a0 <disk>
    80004b00:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004b02:	01874683          	lbu	a3,24(a4)
    80004b06:	fee9                	bnez	a3,80004ae0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004b08:	2785                	addiw	a5,a5,1
    80004b0a:	0705                	addi	a4,a4,1
    80004b0c:	fe979be3          	bne	a5,s1,80004b02 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004b10:	57fd                	li	a5,-1
    80004b12:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004b14:	01205d63          	blez	s2,80004b2e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004b18:	f9042503          	lw	a0,-112(s0)
    80004b1c:	d07ff0ef          	jal	80004822 <free_desc>
      for(int j = 0; j < i; j++)
    80004b20:	4785                	li	a5,1
    80004b22:	0127d663          	bge	a5,s2,80004b2e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004b26:	f9442503          	lw	a0,-108(s0)
    80004b2a:	cf9ff0ef          	jal	80004822 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b2e:	85e2                	mv	a1,s8
    80004b30:	00017517          	auipc	a0,0x17
    80004b34:	88850513          	addi	a0,a0,-1912 # 8001b3b8 <disk+0x18>
    80004b38:	83ffc0ef          	jal	80001376 <sleep>
  for(int i = 0; i < 3; i++){
    80004b3c:	f9040613          	addi	a2,s0,-112
    80004b40:	894e                	mv	s2,s3
    80004b42:	bf55                	j	80004af6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b44:	f9042503          	lw	a0,-112(s0)
    80004b48:	00451693          	slli	a3,a0,0x4

  if(write)
    80004b4c:	00017797          	auipc	a5,0x17
    80004b50:	85478793          	addi	a5,a5,-1964 # 8001b3a0 <disk>
    80004b54:	00a50713          	addi	a4,a0,10
    80004b58:	0712                	slli	a4,a4,0x4
    80004b5a:	973e                	add	a4,a4,a5
    80004b5c:	01703633          	snez	a2,s7
    80004b60:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004b62:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004b66:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b6a:	6398                	ld	a4,0(a5)
    80004b6c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b6e:	0a868613          	addi	a2,a3,168
    80004b72:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b74:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004b76:	6390                	ld	a2,0(a5)
    80004b78:	00d605b3          	add	a1,a2,a3
    80004b7c:	4741                	li	a4,16
    80004b7e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004b80:	4805                	li	a6,1
    80004b82:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004b86:	f9442703          	lw	a4,-108(s0)
    80004b8a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004b8e:	0712                	slli	a4,a4,0x4
    80004b90:	963a                	add	a2,a2,a4
    80004b92:	058a0593          	addi	a1,s4,88
    80004b96:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004b98:	0007b883          	ld	a7,0(a5)
    80004b9c:	9746                	add	a4,a4,a7
    80004b9e:	40000613          	li	a2,1024
    80004ba2:	c710                	sw	a2,8(a4)
  if(write)
    80004ba4:	001bb613          	seqz	a2,s7
    80004ba8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004bac:	00166613          	ori	a2,a2,1
    80004bb0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004bb4:	f9842583          	lw	a1,-104(s0)
    80004bb8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004bbc:	00250613          	addi	a2,a0,2
    80004bc0:	0612                	slli	a2,a2,0x4
    80004bc2:	963e                	add	a2,a2,a5
    80004bc4:	577d                	li	a4,-1
    80004bc6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004bca:	0592                	slli	a1,a1,0x4
    80004bcc:	98ae                	add	a7,a7,a1
    80004bce:	03068713          	addi	a4,a3,48
    80004bd2:	973e                	add	a4,a4,a5
    80004bd4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004bd8:	6398                	ld	a4,0(a5)
    80004bda:	972e                	add	a4,a4,a1
    80004bdc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004be0:	4689                	li	a3,2
    80004be2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004be6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004bea:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004bee:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004bf2:	6794                	ld	a3,8(a5)
    80004bf4:	0026d703          	lhu	a4,2(a3)
    80004bf8:	8b1d                	andi	a4,a4,7
    80004bfa:	0706                	slli	a4,a4,0x1
    80004bfc:	96ba                	add	a3,a3,a4
    80004bfe:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004c02:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004c06:	6798                	ld	a4,8(a5)
    80004c08:	00275783          	lhu	a5,2(a4)
    80004c0c:	2785                	addiw	a5,a5,1
    80004c0e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004c12:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004c16:	100017b7          	lui	a5,0x10001
    80004c1a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004c1e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004c22:	00017917          	auipc	s2,0x17
    80004c26:	8a690913          	addi	s2,s2,-1882 # 8001b4c8 <disk+0x128>
  while(b->disk == 1) {
    80004c2a:	4485                	li	s1,1
    80004c2c:	01079a63          	bne	a5,a6,80004c40 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004c30:	85ca                	mv	a1,s2
    80004c32:	8552                	mv	a0,s4
    80004c34:	f42fc0ef          	jal	80001376 <sleep>
  while(b->disk == 1) {
    80004c38:	004a2783          	lw	a5,4(s4)
    80004c3c:	fe978ae3          	beq	a5,s1,80004c30 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004c40:	f9042903          	lw	s2,-112(s0)
    80004c44:	00290713          	addi	a4,s2,2
    80004c48:	0712                	slli	a4,a4,0x4
    80004c4a:	00016797          	auipc	a5,0x16
    80004c4e:	75678793          	addi	a5,a5,1878 # 8001b3a0 <disk>
    80004c52:	97ba                	add	a5,a5,a4
    80004c54:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004c58:	00016997          	auipc	s3,0x16
    80004c5c:	74898993          	addi	s3,s3,1864 # 8001b3a0 <disk>
    80004c60:	00491713          	slli	a4,s2,0x4
    80004c64:	0009b783          	ld	a5,0(s3)
    80004c68:	97ba                	add	a5,a5,a4
    80004c6a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004c6e:	854a                	mv	a0,s2
    80004c70:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004c74:	bafff0ef          	jal	80004822 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004c78:	8885                	andi	s1,s1,1
    80004c7a:	f0fd                	bnez	s1,80004c60 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004c7c:	00017517          	auipc	a0,0x17
    80004c80:	84c50513          	addi	a0,a0,-1972 # 8001b4c8 <disk+0x128>
    80004c84:	405000ef          	jal	80005888 <release>
}
    80004c88:	70a6                	ld	ra,104(sp)
    80004c8a:	7406                	ld	s0,96(sp)
    80004c8c:	64e6                	ld	s1,88(sp)
    80004c8e:	6946                	ld	s2,80(sp)
    80004c90:	69a6                	ld	s3,72(sp)
    80004c92:	6a06                	ld	s4,64(sp)
    80004c94:	7ae2                	ld	s5,56(sp)
    80004c96:	7b42                	ld	s6,48(sp)
    80004c98:	7ba2                	ld	s7,40(sp)
    80004c9a:	7c02                	ld	s8,32(sp)
    80004c9c:	6ce2                	ld	s9,24(sp)
    80004c9e:	6165                	addi	sp,sp,112
    80004ca0:	8082                	ret

0000000080004ca2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004ca2:	1101                	addi	sp,sp,-32
    80004ca4:	ec06                	sd	ra,24(sp)
    80004ca6:	e822                	sd	s0,16(sp)
    80004ca8:	e426                	sd	s1,8(sp)
    80004caa:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004cac:	00016497          	auipc	s1,0x16
    80004cb0:	6f448493          	addi	s1,s1,1780 # 8001b3a0 <disk>
    80004cb4:	00017517          	auipc	a0,0x17
    80004cb8:	81450513          	addi	a0,a0,-2028 # 8001b4c8 <disk+0x128>
    80004cbc:	335000ef          	jal	800057f0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004cc0:	100017b7          	lui	a5,0x10001
    80004cc4:	53b8                	lw	a4,96(a5)
    80004cc6:	8b0d                	andi	a4,a4,3
    80004cc8:	100017b7          	lui	a5,0x10001
    80004ccc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004cce:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004cd2:	689c                	ld	a5,16(s1)
    80004cd4:	0204d703          	lhu	a4,32(s1)
    80004cd8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004cdc:	04f70663          	beq	a4,a5,80004d28 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004ce0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004ce4:	6898                	ld	a4,16(s1)
    80004ce6:	0204d783          	lhu	a5,32(s1)
    80004cea:	8b9d                	andi	a5,a5,7
    80004cec:	078e                	slli	a5,a5,0x3
    80004cee:	97ba                	add	a5,a5,a4
    80004cf0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004cf2:	00278713          	addi	a4,a5,2
    80004cf6:	0712                	slli	a4,a4,0x4
    80004cf8:	9726                	add	a4,a4,s1
    80004cfa:	01074703          	lbu	a4,16(a4)
    80004cfe:	e321                	bnez	a4,80004d3e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004d00:	0789                	addi	a5,a5,2
    80004d02:	0792                	slli	a5,a5,0x4
    80004d04:	97a6                	add	a5,a5,s1
    80004d06:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004d08:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004d0c:	eb6fc0ef          	jal	800013c2 <wakeup>

    disk.used_idx += 1;
    80004d10:	0204d783          	lhu	a5,32(s1)
    80004d14:	2785                	addiw	a5,a5,1
    80004d16:	17c2                	slli	a5,a5,0x30
    80004d18:	93c1                	srli	a5,a5,0x30
    80004d1a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004d1e:	6898                	ld	a4,16(s1)
    80004d20:	00275703          	lhu	a4,2(a4)
    80004d24:	faf71ee3          	bne	a4,a5,80004ce0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004d28:	00016517          	auipc	a0,0x16
    80004d2c:	7a050513          	addi	a0,a0,1952 # 8001b4c8 <disk+0x128>
    80004d30:	359000ef          	jal	80005888 <release>
}
    80004d34:	60e2                	ld	ra,24(sp)
    80004d36:	6442                	ld	s0,16(sp)
    80004d38:	64a2                	ld	s1,8(sp)
    80004d3a:	6105                	addi	sp,sp,32
    80004d3c:	8082                	ret
      panic("virtio_disk_intr status");
    80004d3e:	00003517          	auipc	a0,0x3
    80004d42:	9ba50513          	addi	a0,a0,-1606 # 800076f8 <etext+0x6f8>
    80004d46:	77c000ef          	jal	800054c2 <panic>

0000000080004d4a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004d4a:	1141                	addi	sp,sp,-16
    80004d4c:	e422                	sd	s0,8(sp)
    80004d4e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004d50:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004d54:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004d58:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004d5c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004d60:	577d                	li	a4,-1
    80004d62:	177e                	slli	a4,a4,0x3f
    80004d64:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004d66:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004d6a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004d6e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004d72:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004d76:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004d7a:	000f4737          	lui	a4,0xf4
    80004d7e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004d82:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004d84:	14d79073          	csrw	stimecmp,a5
}
    80004d88:	6422                	ld	s0,8(sp)
    80004d8a:	0141                	addi	sp,sp,16
    80004d8c:	8082                	ret

0000000080004d8e <start>:
{
    80004d8e:	1141                	addi	sp,sp,-16
    80004d90:	e406                	sd	ra,8(sp)
    80004d92:	e022                	sd	s0,0(sp)
    80004d94:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004d96:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004d9a:	7779                	lui	a4,0xffffe
    80004d9c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb21f>
    80004da0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004da2:	6705                	lui	a4,0x1
    80004da4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004da8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004daa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004dae:	ffffb797          	auipc	a5,0xffffb
    80004db2:	57c78793          	addi	a5,a5,1404 # 8000032a <main>
    80004db6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004dba:	4781                	li	a5,0
    80004dbc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004dc0:	67c1                	lui	a5,0x10
    80004dc2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004dc4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004dc8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004dcc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004dd0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004dd4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004dd8:	57fd                	li	a5,-1
    80004dda:	83a9                	srli	a5,a5,0xa
    80004ddc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004de0:	47bd                	li	a5,15
    80004de2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004de6:	f65ff0ef          	jal	80004d4a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004dea:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004dee:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004df0:	823e                	mv	tp,a5
  asm volatile("mret");
    80004df2:	30200073          	mret
}
    80004df6:	60a2                	ld	ra,8(sp)
    80004df8:	6402                	ld	s0,0(sp)
    80004dfa:	0141                	addi	sp,sp,16
    80004dfc:	8082                	ret

0000000080004dfe <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004dfe:	715d                	addi	sp,sp,-80
    80004e00:	e486                	sd	ra,72(sp)
    80004e02:	e0a2                	sd	s0,64(sp)
    80004e04:	f84a                	sd	s2,48(sp)
    80004e06:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004e08:	04c05263          	blez	a2,80004e4c <consolewrite+0x4e>
    80004e0c:	fc26                	sd	s1,56(sp)
    80004e0e:	f44e                	sd	s3,40(sp)
    80004e10:	f052                	sd	s4,32(sp)
    80004e12:	ec56                	sd	s5,24(sp)
    80004e14:	8a2a                	mv	s4,a0
    80004e16:	84ae                	mv	s1,a1
    80004e18:	89b2                	mv	s3,a2
    80004e1a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004e1c:	5afd                	li	s5,-1
    80004e1e:	4685                	li	a3,1
    80004e20:	8626                	mv	a2,s1
    80004e22:	85d2                	mv	a1,s4
    80004e24:	fbf40513          	addi	a0,s0,-65
    80004e28:	8f5fc0ef          	jal	8000171c <either_copyin>
    80004e2c:	03550263          	beq	a0,s5,80004e50 <consolewrite+0x52>
      break;
    uartputc(c);
    80004e30:	fbf44503          	lbu	a0,-65(s0)
    80004e34:	035000ef          	jal	80005668 <uartputc>
  for(i = 0; i < n; i++){
    80004e38:	2905                	addiw	s2,s2,1
    80004e3a:	0485                	addi	s1,s1,1
    80004e3c:	ff2991e3          	bne	s3,s2,80004e1e <consolewrite+0x20>
    80004e40:	894e                	mv	s2,s3
    80004e42:	74e2                	ld	s1,56(sp)
    80004e44:	79a2                	ld	s3,40(sp)
    80004e46:	7a02                	ld	s4,32(sp)
    80004e48:	6ae2                	ld	s5,24(sp)
    80004e4a:	a039                	j	80004e58 <consolewrite+0x5a>
    80004e4c:	4901                	li	s2,0
    80004e4e:	a029                	j	80004e58 <consolewrite+0x5a>
    80004e50:	74e2                	ld	s1,56(sp)
    80004e52:	79a2                	ld	s3,40(sp)
    80004e54:	7a02                	ld	s4,32(sp)
    80004e56:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004e58:	854a                	mv	a0,s2
    80004e5a:	60a6                	ld	ra,72(sp)
    80004e5c:	6406                	ld	s0,64(sp)
    80004e5e:	7942                	ld	s2,48(sp)
    80004e60:	6161                	addi	sp,sp,80
    80004e62:	8082                	ret

0000000080004e64 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004e64:	711d                	addi	sp,sp,-96
    80004e66:	ec86                	sd	ra,88(sp)
    80004e68:	e8a2                	sd	s0,80(sp)
    80004e6a:	e4a6                	sd	s1,72(sp)
    80004e6c:	e0ca                	sd	s2,64(sp)
    80004e6e:	fc4e                	sd	s3,56(sp)
    80004e70:	f852                	sd	s4,48(sp)
    80004e72:	f456                	sd	s5,40(sp)
    80004e74:	f05a                	sd	s6,32(sp)
    80004e76:	1080                	addi	s0,sp,96
    80004e78:	8aaa                	mv	s5,a0
    80004e7a:	8a2e                	mv	s4,a1
    80004e7c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004e7e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004e82:	0001e517          	auipc	a0,0x1e
    80004e86:	65e50513          	addi	a0,a0,1630 # 800234e0 <cons>
    80004e8a:	167000ef          	jal	800057f0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004e8e:	0001e497          	auipc	s1,0x1e
    80004e92:	65248493          	addi	s1,s1,1618 # 800234e0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004e96:	0001e917          	auipc	s2,0x1e
    80004e9a:	6e290913          	addi	s2,s2,1762 # 80023578 <cons+0x98>
  while(n > 0){
    80004e9e:	0b305d63          	blez	s3,80004f58 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004ea2:	0984a783          	lw	a5,152(s1)
    80004ea6:	09c4a703          	lw	a4,156(s1)
    80004eaa:	0af71263          	bne	a4,a5,80004f4e <consoleread+0xea>
      if(killed(myproc())){
    80004eae:	efbfb0ef          	jal	80000da8 <myproc>
    80004eb2:	efcfc0ef          	jal	800015ae <killed>
    80004eb6:	e12d                	bnez	a0,80004f18 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004eb8:	85a6                	mv	a1,s1
    80004eba:	854a                	mv	a0,s2
    80004ebc:	cbafc0ef          	jal	80001376 <sleep>
    while(cons.r == cons.w){
    80004ec0:	0984a783          	lw	a5,152(s1)
    80004ec4:	09c4a703          	lw	a4,156(s1)
    80004ec8:	fef703e3          	beq	a4,a5,80004eae <consoleread+0x4a>
    80004ecc:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004ece:	0001e717          	auipc	a4,0x1e
    80004ed2:	61270713          	addi	a4,a4,1554 # 800234e0 <cons>
    80004ed6:	0017869b          	addiw	a3,a5,1
    80004eda:	08d72c23          	sw	a3,152(a4)
    80004ede:	07f7f693          	andi	a3,a5,127
    80004ee2:	9736                	add	a4,a4,a3
    80004ee4:	01874703          	lbu	a4,24(a4)
    80004ee8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004eec:	4691                	li	a3,4
    80004eee:	04db8663          	beq	s7,a3,80004f3a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004ef2:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004ef6:	4685                	li	a3,1
    80004ef8:	faf40613          	addi	a2,s0,-81
    80004efc:	85d2                	mv	a1,s4
    80004efe:	8556                	mv	a0,s5
    80004f00:	fd2fc0ef          	jal	800016d2 <either_copyout>
    80004f04:	57fd                	li	a5,-1
    80004f06:	04f50863          	beq	a0,a5,80004f56 <consoleread+0xf2>
      break;

    dst++;
    80004f0a:	0a05                	addi	s4,s4,1
    --n;
    80004f0c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004f0e:	47a9                	li	a5,10
    80004f10:	04fb8d63          	beq	s7,a5,80004f6a <consoleread+0x106>
    80004f14:	6be2                	ld	s7,24(sp)
    80004f16:	b761                	j	80004e9e <consoleread+0x3a>
        release(&cons.lock);
    80004f18:	0001e517          	auipc	a0,0x1e
    80004f1c:	5c850513          	addi	a0,a0,1480 # 800234e0 <cons>
    80004f20:	169000ef          	jal	80005888 <release>
        return -1;
    80004f24:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004f26:	60e6                	ld	ra,88(sp)
    80004f28:	6446                	ld	s0,80(sp)
    80004f2a:	64a6                	ld	s1,72(sp)
    80004f2c:	6906                	ld	s2,64(sp)
    80004f2e:	79e2                	ld	s3,56(sp)
    80004f30:	7a42                	ld	s4,48(sp)
    80004f32:	7aa2                	ld	s5,40(sp)
    80004f34:	7b02                	ld	s6,32(sp)
    80004f36:	6125                	addi	sp,sp,96
    80004f38:	8082                	ret
      if(n < target){
    80004f3a:	0009871b          	sext.w	a4,s3
    80004f3e:	01677a63          	bgeu	a4,s6,80004f52 <consoleread+0xee>
        cons.r--;
    80004f42:	0001e717          	auipc	a4,0x1e
    80004f46:	62f72b23          	sw	a5,1590(a4) # 80023578 <cons+0x98>
    80004f4a:	6be2                	ld	s7,24(sp)
    80004f4c:	a031                	j	80004f58 <consoleread+0xf4>
    80004f4e:	ec5e                	sd	s7,24(sp)
    80004f50:	bfbd                	j	80004ece <consoleread+0x6a>
    80004f52:	6be2                	ld	s7,24(sp)
    80004f54:	a011                	j	80004f58 <consoleread+0xf4>
    80004f56:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004f58:	0001e517          	auipc	a0,0x1e
    80004f5c:	58850513          	addi	a0,a0,1416 # 800234e0 <cons>
    80004f60:	129000ef          	jal	80005888 <release>
  return target - n;
    80004f64:	413b053b          	subw	a0,s6,s3
    80004f68:	bf7d                	j	80004f26 <consoleread+0xc2>
    80004f6a:	6be2                	ld	s7,24(sp)
    80004f6c:	b7f5                	j	80004f58 <consoleread+0xf4>

0000000080004f6e <consputc>:
{
    80004f6e:	1141                	addi	sp,sp,-16
    80004f70:	e406                	sd	ra,8(sp)
    80004f72:	e022                	sd	s0,0(sp)
    80004f74:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004f76:	10000793          	li	a5,256
    80004f7a:	00f50863          	beq	a0,a5,80004f8a <consputc+0x1c>
    uartputc_sync(c);
    80004f7e:	604000ef          	jal	80005582 <uartputc_sync>
}
    80004f82:	60a2                	ld	ra,8(sp)
    80004f84:	6402                	ld	s0,0(sp)
    80004f86:	0141                	addi	sp,sp,16
    80004f88:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004f8a:	4521                	li	a0,8
    80004f8c:	5f6000ef          	jal	80005582 <uartputc_sync>
    80004f90:	02000513          	li	a0,32
    80004f94:	5ee000ef          	jal	80005582 <uartputc_sync>
    80004f98:	4521                	li	a0,8
    80004f9a:	5e8000ef          	jal	80005582 <uartputc_sync>
    80004f9e:	b7d5                	j	80004f82 <consputc+0x14>

0000000080004fa0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004fa0:	1101                	addi	sp,sp,-32
    80004fa2:	ec06                	sd	ra,24(sp)
    80004fa4:	e822                	sd	s0,16(sp)
    80004fa6:	e426                	sd	s1,8(sp)
    80004fa8:	1000                	addi	s0,sp,32
    80004faa:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004fac:	0001e517          	auipc	a0,0x1e
    80004fb0:	53450513          	addi	a0,a0,1332 # 800234e0 <cons>
    80004fb4:	03d000ef          	jal	800057f0 <acquire>

  switch(c){
    80004fb8:	47d5                	li	a5,21
    80004fba:	08f48f63          	beq	s1,a5,80005058 <consoleintr+0xb8>
    80004fbe:	0297c563          	blt	a5,s1,80004fe8 <consoleintr+0x48>
    80004fc2:	47a1                	li	a5,8
    80004fc4:	0ef48463          	beq	s1,a5,800050ac <consoleintr+0x10c>
    80004fc8:	47c1                	li	a5,16
    80004fca:	10f49563          	bne	s1,a5,800050d4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80004fce:	f98fc0ef          	jal	80001766 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004fd2:	0001e517          	auipc	a0,0x1e
    80004fd6:	50e50513          	addi	a0,a0,1294 # 800234e0 <cons>
    80004fda:	0af000ef          	jal	80005888 <release>
}
    80004fde:	60e2                	ld	ra,24(sp)
    80004fe0:	6442                	ld	s0,16(sp)
    80004fe2:	64a2                	ld	s1,8(sp)
    80004fe4:	6105                	addi	sp,sp,32
    80004fe6:	8082                	ret
  switch(c){
    80004fe8:	07f00793          	li	a5,127
    80004fec:	0cf48063          	beq	s1,a5,800050ac <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004ff0:	0001e717          	auipc	a4,0x1e
    80004ff4:	4f070713          	addi	a4,a4,1264 # 800234e0 <cons>
    80004ff8:	0a072783          	lw	a5,160(a4)
    80004ffc:	09872703          	lw	a4,152(a4)
    80005000:	9f99                	subw	a5,a5,a4
    80005002:	07f00713          	li	a4,127
    80005006:	fcf766e3          	bltu	a4,a5,80004fd2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000500a:	47b5                	li	a5,13
    8000500c:	0cf48763          	beq	s1,a5,800050da <consoleintr+0x13a>
      consputc(c);
    80005010:	8526                	mv	a0,s1
    80005012:	f5dff0ef          	jal	80004f6e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005016:	0001e797          	auipc	a5,0x1e
    8000501a:	4ca78793          	addi	a5,a5,1226 # 800234e0 <cons>
    8000501e:	0a07a683          	lw	a3,160(a5)
    80005022:	0016871b          	addiw	a4,a3,1
    80005026:	0007061b          	sext.w	a2,a4
    8000502a:	0ae7a023          	sw	a4,160(a5)
    8000502e:	07f6f693          	andi	a3,a3,127
    80005032:	97b6                	add	a5,a5,a3
    80005034:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005038:	47a9                	li	a5,10
    8000503a:	0cf48563          	beq	s1,a5,80005104 <consoleintr+0x164>
    8000503e:	4791                	li	a5,4
    80005040:	0cf48263          	beq	s1,a5,80005104 <consoleintr+0x164>
    80005044:	0001e797          	auipc	a5,0x1e
    80005048:	5347a783          	lw	a5,1332(a5) # 80023578 <cons+0x98>
    8000504c:	9f1d                	subw	a4,a4,a5
    8000504e:	08000793          	li	a5,128
    80005052:	f8f710e3          	bne	a4,a5,80004fd2 <consoleintr+0x32>
    80005056:	a07d                	j	80005104 <consoleintr+0x164>
    80005058:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000505a:	0001e717          	auipc	a4,0x1e
    8000505e:	48670713          	addi	a4,a4,1158 # 800234e0 <cons>
    80005062:	0a072783          	lw	a5,160(a4)
    80005066:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000506a:	0001e497          	auipc	s1,0x1e
    8000506e:	47648493          	addi	s1,s1,1142 # 800234e0 <cons>
    while(cons.e != cons.w &&
    80005072:	4929                	li	s2,10
    80005074:	02f70863          	beq	a4,a5,800050a4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005078:	37fd                	addiw	a5,a5,-1
    8000507a:	07f7f713          	andi	a4,a5,127
    8000507e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005080:	01874703          	lbu	a4,24(a4)
    80005084:	03270263          	beq	a4,s2,800050a8 <consoleintr+0x108>
      cons.e--;
    80005088:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000508c:	10000513          	li	a0,256
    80005090:	edfff0ef          	jal	80004f6e <consputc>
    while(cons.e != cons.w &&
    80005094:	0a04a783          	lw	a5,160(s1)
    80005098:	09c4a703          	lw	a4,156(s1)
    8000509c:	fcf71ee3          	bne	a4,a5,80005078 <consoleintr+0xd8>
    800050a0:	6902                	ld	s2,0(sp)
    800050a2:	bf05                	j	80004fd2 <consoleintr+0x32>
    800050a4:	6902                	ld	s2,0(sp)
    800050a6:	b735                	j	80004fd2 <consoleintr+0x32>
    800050a8:	6902                	ld	s2,0(sp)
    800050aa:	b725                	j	80004fd2 <consoleintr+0x32>
    if(cons.e != cons.w){
    800050ac:	0001e717          	auipc	a4,0x1e
    800050b0:	43470713          	addi	a4,a4,1076 # 800234e0 <cons>
    800050b4:	0a072783          	lw	a5,160(a4)
    800050b8:	09c72703          	lw	a4,156(a4)
    800050bc:	f0f70be3          	beq	a4,a5,80004fd2 <consoleintr+0x32>
      cons.e--;
    800050c0:	37fd                	addiw	a5,a5,-1
    800050c2:	0001e717          	auipc	a4,0x1e
    800050c6:	4af72f23          	sw	a5,1214(a4) # 80023580 <cons+0xa0>
      consputc(BACKSPACE);
    800050ca:	10000513          	li	a0,256
    800050ce:	ea1ff0ef          	jal	80004f6e <consputc>
    800050d2:	b701                	j	80004fd2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800050d4:	ee048fe3          	beqz	s1,80004fd2 <consoleintr+0x32>
    800050d8:	bf21                	j	80004ff0 <consoleintr+0x50>
      consputc(c);
    800050da:	4529                	li	a0,10
    800050dc:	e93ff0ef          	jal	80004f6e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800050e0:	0001e797          	auipc	a5,0x1e
    800050e4:	40078793          	addi	a5,a5,1024 # 800234e0 <cons>
    800050e8:	0a07a703          	lw	a4,160(a5)
    800050ec:	0017069b          	addiw	a3,a4,1
    800050f0:	0006861b          	sext.w	a2,a3
    800050f4:	0ad7a023          	sw	a3,160(a5)
    800050f8:	07f77713          	andi	a4,a4,127
    800050fc:	97ba                	add	a5,a5,a4
    800050fe:	4729                	li	a4,10
    80005100:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005104:	0001e797          	auipc	a5,0x1e
    80005108:	46c7ac23          	sw	a2,1144(a5) # 8002357c <cons+0x9c>
        wakeup(&cons.r);
    8000510c:	0001e517          	auipc	a0,0x1e
    80005110:	46c50513          	addi	a0,a0,1132 # 80023578 <cons+0x98>
    80005114:	aaefc0ef          	jal	800013c2 <wakeup>
    80005118:	bd6d                	j	80004fd2 <consoleintr+0x32>

000000008000511a <consoleinit>:

void
consoleinit(void)
{
    8000511a:	1141                	addi	sp,sp,-16
    8000511c:	e406                	sd	ra,8(sp)
    8000511e:	e022                	sd	s0,0(sp)
    80005120:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005122:	00002597          	auipc	a1,0x2
    80005126:	5ee58593          	addi	a1,a1,1518 # 80007710 <etext+0x710>
    8000512a:	0001e517          	auipc	a0,0x1e
    8000512e:	3b650513          	addi	a0,a0,950 # 800234e0 <cons>
    80005132:	63e000ef          	jal	80005770 <initlock>

  uartinit();
    80005136:	3f4000ef          	jal	8000552a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000513a:	00015797          	auipc	a5,0x15
    8000513e:	20e78793          	addi	a5,a5,526 # 8001a348 <devsw>
    80005142:	00000717          	auipc	a4,0x0
    80005146:	d2270713          	addi	a4,a4,-734 # 80004e64 <consoleread>
    8000514a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000514c:	00000717          	auipc	a4,0x0
    80005150:	cb270713          	addi	a4,a4,-846 # 80004dfe <consolewrite>
    80005154:	ef98                	sd	a4,24(a5)
}
    80005156:	60a2                	ld	ra,8(sp)
    80005158:	6402                	ld	s0,0(sp)
    8000515a:	0141                	addi	sp,sp,16
    8000515c:	8082                	ret

000000008000515e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000515e:	7179                	addi	sp,sp,-48
    80005160:	f406                	sd	ra,40(sp)
    80005162:	f022                	sd	s0,32(sp)
    80005164:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005166:	c219                	beqz	a2,8000516c <printint+0xe>
    80005168:	08054063          	bltz	a0,800051e8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000516c:	4881                	li	a7,0
    8000516e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005172:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005174:	00002617          	auipc	a2,0x2
    80005178:	6fc60613          	addi	a2,a2,1788 # 80007870 <digits>
    8000517c:	883e                	mv	a6,a5
    8000517e:	2785                	addiw	a5,a5,1
    80005180:	02b57733          	remu	a4,a0,a1
    80005184:	9732                	add	a4,a4,a2
    80005186:	00074703          	lbu	a4,0(a4)
    8000518a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000518e:	872a                	mv	a4,a0
    80005190:	02b55533          	divu	a0,a0,a1
    80005194:	0685                	addi	a3,a3,1
    80005196:	feb773e3          	bgeu	a4,a1,8000517c <printint+0x1e>

  if(sign)
    8000519a:	00088a63          	beqz	a7,800051ae <printint+0x50>
    buf[i++] = '-';
    8000519e:	1781                	addi	a5,a5,-32
    800051a0:	97a2                	add	a5,a5,s0
    800051a2:	02d00713          	li	a4,45
    800051a6:	fee78823          	sb	a4,-16(a5)
    800051aa:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800051ae:	02f05963          	blez	a5,800051e0 <printint+0x82>
    800051b2:	ec26                	sd	s1,24(sp)
    800051b4:	e84a                	sd	s2,16(sp)
    800051b6:	fd040713          	addi	a4,s0,-48
    800051ba:	00f704b3          	add	s1,a4,a5
    800051be:	fff70913          	addi	s2,a4,-1
    800051c2:	993e                	add	s2,s2,a5
    800051c4:	37fd                	addiw	a5,a5,-1
    800051c6:	1782                	slli	a5,a5,0x20
    800051c8:	9381                	srli	a5,a5,0x20
    800051ca:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800051ce:	fff4c503          	lbu	a0,-1(s1)
    800051d2:	d9dff0ef          	jal	80004f6e <consputc>
  while(--i >= 0)
    800051d6:	14fd                	addi	s1,s1,-1
    800051d8:	ff249be3          	bne	s1,s2,800051ce <printint+0x70>
    800051dc:	64e2                	ld	s1,24(sp)
    800051de:	6942                	ld	s2,16(sp)
}
    800051e0:	70a2                	ld	ra,40(sp)
    800051e2:	7402                	ld	s0,32(sp)
    800051e4:	6145                	addi	sp,sp,48
    800051e6:	8082                	ret
    x = -xx;
    800051e8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800051ec:	4885                	li	a7,1
    x = -xx;
    800051ee:	b741                	j	8000516e <printint+0x10>

00000000800051f0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800051f0:	7155                	addi	sp,sp,-208
    800051f2:	e506                	sd	ra,136(sp)
    800051f4:	e122                	sd	s0,128(sp)
    800051f6:	f0d2                	sd	s4,96(sp)
    800051f8:	0900                	addi	s0,sp,144
    800051fa:	8a2a                	mv	s4,a0
    800051fc:	e40c                	sd	a1,8(s0)
    800051fe:	e810                	sd	a2,16(s0)
    80005200:	ec14                	sd	a3,24(s0)
    80005202:	f018                	sd	a4,32(s0)
    80005204:	f41c                	sd	a5,40(s0)
    80005206:	03043823          	sd	a6,48(s0)
    8000520a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000520e:	0001e797          	auipc	a5,0x1e
    80005212:	3927a783          	lw	a5,914(a5) # 800235a0 <pr+0x18>
    80005216:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000521a:	e3a1                	bnez	a5,8000525a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000521c:	00840793          	addi	a5,s0,8
    80005220:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005224:	00054503          	lbu	a0,0(a0)
    80005228:	26050763          	beqz	a0,80005496 <printf+0x2a6>
    8000522c:	fca6                	sd	s1,120(sp)
    8000522e:	f8ca                	sd	s2,112(sp)
    80005230:	f4ce                	sd	s3,104(sp)
    80005232:	ecd6                	sd	s5,88(sp)
    80005234:	e8da                	sd	s6,80(sp)
    80005236:	e0e2                	sd	s8,64(sp)
    80005238:	fc66                	sd	s9,56(sp)
    8000523a:	f86a                	sd	s10,48(sp)
    8000523c:	f46e                	sd	s11,40(sp)
    8000523e:	4981                	li	s3,0
    if(cx != '%'){
    80005240:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005244:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005248:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000524c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005250:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005254:	07000d93          	li	s11,112
    80005258:	a815                	j	8000528c <printf+0x9c>
    acquire(&pr.lock);
    8000525a:	0001e517          	auipc	a0,0x1e
    8000525e:	32e50513          	addi	a0,a0,814 # 80023588 <pr>
    80005262:	58e000ef          	jal	800057f0 <acquire>
  va_start(ap, fmt);
    80005266:	00840793          	addi	a5,s0,8
    8000526a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000526e:	000a4503          	lbu	a0,0(s4)
    80005272:	fd4d                	bnez	a0,8000522c <printf+0x3c>
    80005274:	a481                	j	800054b4 <printf+0x2c4>
      consputc(cx);
    80005276:	cf9ff0ef          	jal	80004f6e <consputc>
      continue;
    8000527a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000527c:	0014899b          	addiw	s3,s1,1
    80005280:	013a07b3          	add	a5,s4,s3
    80005284:	0007c503          	lbu	a0,0(a5)
    80005288:	1e050b63          	beqz	a0,8000547e <printf+0x28e>
    if(cx != '%'){
    8000528c:	ff5515e3          	bne	a0,s5,80005276 <printf+0x86>
    i++;
    80005290:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005294:	009a07b3          	add	a5,s4,s1
    80005298:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000529c:	1e090163          	beqz	s2,8000547e <printf+0x28e>
    800052a0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800052a4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800052a6:	c789                	beqz	a5,800052b0 <printf+0xc0>
    800052a8:	009a0733          	add	a4,s4,s1
    800052ac:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800052b0:	03690763          	beq	s2,s6,800052de <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    800052b4:	05890163          	beq	s2,s8,800052f6 <printf+0x106>
    } else if(c0 == 'u'){
    800052b8:	0d990b63          	beq	s2,s9,8000538e <printf+0x19e>
    } else if(c0 == 'x'){
    800052bc:	13a90163          	beq	s2,s10,800053de <printf+0x1ee>
    } else if(c0 == 'p'){
    800052c0:	13b90b63          	beq	s2,s11,800053f6 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800052c4:	07300793          	li	a5,115
    800052c8:	16f90a63          	beq	s2,a5,8000543c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800052cc:	1b590463          	beq	s2,s5,80005474 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800052d0:	8556                	mv	a0,s5
    800052d2:	c9dff0ef          	jal	80004f6e <consputc>
      consputc(c0);
    800052d6:	854a                	mv	a0,s2
    800052d8:	c97ff0ef          	jal	80004f6e <consputc>
    800052dc:	b745                	j	8000527c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800052de:	f8843783          	ld	a5,-120(s0)
    800052e2:	00878713          	addi	a4,a5,8
    800052e6:	f8e43423          	sd	a4,-120(s0)
    800052ea:	4605                	li	a2,1
    800052ec:	45a9                	li	a1,10
    800052ee:	4388                	lw	a0,0(a5)
    800052f0:	e6fff0ef          	jal	8000515e <printint>
    800052f4:	b761                	j	8000527c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800052f6:	03678663          	beq	a5,s6,80005322 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800052fa:	05878263          	beq	a5,s8,8000533e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800052fe:	0b978463          	beq	a5,s9,800053a6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005302:	fda797e3          	bne	a5,s10,800052d0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005306:	f8843783          	ld	a5,-120(s0)
    8000530a:	00878713          	addi	a4,a5,8
    8000530e:	f8e43423          	sd	a4,-120(s0)
    80005312:	4601                	li	a2,0
    80005314:	45c1                	li	a1,16
    80005316:	6388                	ld	a0,0(a5)
    80005318:	e47ff0ef          	jal	8000515e <printint>
      i += 1;
    8000531c:	0029849b          	addiw	s1,s3,2
    80005320:	bfb1                	j	8000527c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005322:	f8843783          	ld	a5,-120(s0)
    80005326:	00878713          	addi	a4,a5,8
    8000532a:	f8e43423          	sd	a4,-120(s0)
    8000532e:	4605                	li	a2,1
    80005330:	45a9                	li	a1,10
    80005332:	6388                	ld	a0,0(a5)
    80005334:	e2bff0ef          	jal	8000515e <printint>
      i += 1;
    80005338:	0029849b          	addiw	s1,s3,2
    8000533c:	b781                	j	8000527c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000533e:	06400793          	li	a5,100
    80005342:	02f68863          	beq	a3,a5,80005372 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005346:	07500793          	li	a5,117
    8000534a:	06f68c63          	beq	a3,a5,800053c2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000534e:	07800793          	li	a5,120
    80005352:	f6f69fe3          	bne	a3,a5,800052d0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005356:	f8843783          	ld	a5,-120(s0)
    8000535a:	00878713          	addi	a4,a5,8
    8000535e:	f8e43423          	sd	a4,-120(s0)
    80005362:	4601                	li	a2,0
    80005364:	45c1                	li	a1,16
    80005366:	6388                	ld	a0,0(a5)
    80005368:	df7ff0ef          	jal	8000515e <printint>
      i += 2;
    8000536c:	0039849b          	addiw	s1,s3,3
    80005370:	b731                	j	8000527c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005372:	f8843783          	ld	a5,-120(s0)
    80005376:	00878713          	addi	a4,a5,8
    8000537a:	f8e43423          	sd	a4,-120(s0)
    8000537e:	4605                	li	a2,1
    80005380:	45a9                	li	a1,10
    80005382:	6388                	ld	a0,0(a5)
    80005384:	ddbff0ef          	jal	8000515e <printint>
      i += 2;
    80005388:	0039849b          	addiw	s1,s3,3
    8000538c:	bdc5                	j	8000527c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000538e:	f8843783          	ld	a5,-120(s0)
    80005392:	00878713          	addi	a4,a5,8
    80005396:	f8e43423          	sd	a4,-120(s0)
    8000539a:	4601                	li	a2,0
    8000539c:	45a9                	li	a1,10
    8000539e:	4388                	lw	a0,0(a5)
    800053a0:	dbfff0ef          	jal	8000515e <printint>
    800053a4:	bde1                	j	8000527c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800053a6:	f8843783          	ld	a5,-120(s0)
    800053aa:	00878713          	addi	a4,a5,8
    800053ae:	f8e43423          	sd	a4,-120(s0)
    800053b2:	4601                	li	a2,0
    800053b4:	45a9                	li	a1,10
    800053b6:	6388                	ld	a0,0(a5)
    800053b8:	da7ff0ef          	jal	8000515e <printint>
      i += 1;
    800053bc:	0029849b          	addiw	s1,s3,2
    800053c0:	bd75                	j	8000527c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800053c2:	f8843783          	ld	a5,-120(s0)
    800053c6:	00878713          	addi	a4,a5,8
    800053ca:	f8e43423          	sd	a4,-120(s0)
    800053ce:	4601                	li	a2,0
    800053d0:	45a9                	li	a1,10
    800053d2:	6388                	ld	a0,0(a5)
    800053d4:	d8bff0ef          	jal	8000515e <printint>
      i += 2;
    800053d8:	0039849b          	addiw	s1,s3,3
    800053dc:	b545                	j	8000527c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800053de:	f8843783          	ld	a5,-120(s0)
    800053e2:	00878713          	addi	a4,a5,8
    800053e6:	f8e43423          	sd	a4,-120(s0)
    800053ea:	4601                	li	a2,0
    800053ec:	45c1                	li	a1,16
    800053ee:	4388                	lw	a0,0(a5)
    800053f0:	d6fff0ef          	jal	8000515e <printint>
    800053f4:	b561                	j	8000527c <printf+0x8c>
    800053f6:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800053f8:	f8843783          	ld	a5,-120(s0)
    800053fc:	00878713          	addi	a4,a5,8
    80005400:	f8e43423          	sd	a4,-120(s0)
    80005404:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005408:	03000513          	li	a0,48
    8000540c:	b63ff0ef          	jal	80004f6e <consputc>
  consputc('x');
    80005410:	07800513          	li	a0,120
    80005414:	b5bff0ef          	jal	80004f6e <consputc>
    80005418:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000541a:	00002b97          	auipc	s7,0x2
    8000541e:	456b8b93          	addi	s7,s7,1110 # 80007870 <digits>
    80005422:	03c9d793          	srli	a5,s3,0x3c
    80005426:	97de                	add	a5,a5,s7
    80005428:	0007c503          	lbu	a0,0(a5)
    8000542c:	b43ff0ef          	jal	80004f6e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005430:	0992                	slli	s3,s3,0x4
    80005432:	397d                	addiw	s2,s2,-1
    80005434:	fe0917e3          	bnez	s2,80005422 <printf+0x232>
    80005438:	6ba6                	ld	s7,72(sp)
    8000543a:	b589                	j	8000527c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000543c:	f8843783          	ld	a5,-120(s0)
    80005440:	00878713          	addi	a4,a5,8
    80005444:	f8e43423          	sd	a4,-120(s0)
    80005448:	0007b903          	ld	s2,0(a5)
    8000544c:	00090d63          	beqz	s2,80005466 <printf+0x276>
      for(; *s; s++)
    80005450:	00094503          	lbu	a0,0(s2)
    80005454:	e20504e3          	beqz	a0,8000527c <printf+0x8c>
        consputc(*s);
    80005458:	b17ff0ef          	jal	80004f6e <consputc>
      for(; *s; s++)
    8000545c:	0905                	addi	s2,s2,1
    8000545e:	00094503          	lbu	a0,0(s2)
    80005462:	f97d                	bnez	a0,80005458 <printf+0x268>
    80005464:	bd21                	j	8000527c <printf+0x8c>
        s = "(null)";
    80005466:	00002917          	auipc	s2,0x2
    8000546a:	2b290913          	addi	s2,s2,690 # 80007718 <etext+0x718>
      for(; *s; s++)
    8000546e:	02800513          	li	a0,40
    80005472:	b7dd                	j	80005458 <printf+0x268>
      consputc('%');
    80005474:	02500513          	li	a0,37
    80005478:	af7ff0ef          	jal	80004f6e <consputc>
    8000547c:	b501                	j	8000527c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000547e:	f7843783          	ld	a5,-136(s0)
    80005482:	e385                	bnez	a5,800054a2 <printf+0x2b2>
    80005484:	74e6                	ld	s1,120(sp)
    80005486:	7946                	ld	s2,112(sp)
    80005488:	79a6                	ld	s3,104(sp)
    8000548a:	6ae6                	ld	s5,88(sp)
    8000548c:	6b46                	ld	s6,80(sp)
    8000548e:	6c06                	ld	s8,64(sp)
    80005490:	7ce2                	ld	s9,56(sp)
    80005492:	7d42                	ld	s10,48(sp)
    80005494:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005496:	4501                	li	a0,0
    80005498:	60aa                	ld	ra,136(sp)
    8000549a:	640a                	ld	s0,128(sp)
    8000549c:	7a06                	ld	s4,96(sp)
    8000549e:	6169                	addi	sp,sp,208
    800054a0:	8082                	ret
    800054a2:	74e6                	ld	s1,120(sp)
    800054a4:	7946                	ld	s2,112(sp)
    800054a6:	79a6                	ld	s3,104(sp)
    800054a8:	6ae6                	ld	s5,88(sp)
    800054aa:	6b46                	ld	s6,80(sp)
    800054ac:	6c06                	ld	s8,64(sp)
    800054ae:	7ce2                	ld	s9,56(sp)
    800054b0:	7d42                	ld	s10,48(sp)
    800054b2:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800054b4:	0001e517          	auipc	a0,0x1e
    800054b8:	0d450513          	addi	a0,a0,212 # 80023588 <pr>
    800054bc:	3cc000ef          	jal	80005888 <release>
    800054c0:	bfd9                	j	80005496 <printf+0x2a6>

00000000800054c2 <panic>:

void
panic(char *s)
{
    800054c2:	1101                	addi	sp,sp,-32
    800054c4:	ec06                	sd	ra,24(sp)
    800054c6:	e822                	sd	s0,16(sp)
    800054c8:	e426                	sd	s1,8(sp)
    800054ca:	1000                	addi	s0,sp,32
    800054cc:	84aa                	mv	s1,a0
  pr.locking = 0;
    800054ce:	0001e797          	auipc	a5,0x1e
    800054d2:	0c07a923          	sw	zero,210(a5) # 800235a0 <pr+0x18>
  printf("panic: ");
    800054d6:	00002517          	auipc	a0,0x2
    800054da:	24a50513          	addi	a0,a0,586 # 80007720 <etext+0x720>
    800054de:	d13ff0ef          	jal	800051f0 <printf>
  printf("%s\n", s);
    800054e2:	85a6                	mv	a1,s1
    800054e4:	00002517          	auipc	a0,0x2
    800054e8:	24450513          	addi	a0,a0,580 # 80007728 <etext+0x728>
    800054ec:	d05ff0ef          	jal	800051f0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800054f0:	4785                	li	a5,1
    800054f2:	00005717          	auipc	a4,0x5
    800054f6:	daf72523          	sw	a5,-598(a4) # 8000a29c <panicked>
  for(;;)
    800054fa:	a001                	j	800054fa <panic+0x38>

00000000800054fc <printfinit>:
    ;
}

void
printfinit(void)
{
    800054fc:	1101                	addi	sp,sp,-32
    800054fe:	ec06                	sd	ra,24(sp)
    80005500:	e822                	sd	s0,16(sp)
    80005502:	e426                	sd	s1,8(sp)
    80005504:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005506:	0001e497          	auipc	s1,0x1e
    8000550a:	08248493          	addi	s1,s1,130 # 80023588 <pr>
    8000550e:	00002597          	auipc	a1,0x2
    80005512:	22258593          	addi	a1,a1,546 # 80007730 <etext+0x730>
    80005516:	8526                	mv	a0,s1
    80005518:	258000ef          	jal	80005770 <initlock>
  pr.locking = 1;
    8000551c:	4785                	li	a5,1
    8000551e:	cc9c                	sw	a5,24(s1)
}
    80005520:	60e2                	ld	ra,24(sp)
    80005522:	6442                	ld	s0,16(sp)
    80005524:	64a2                	ld	s1,8(sp)
    80005526:	6105                	addi	sp,sp,32
    80005528:	8082                	ret

000000008000552a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000552a:	1141                	addi	sp,sp,-16
    8000552c:	e406                	sd	ra,8(sp)
    8000552e:	e022                	sd	s0,0(sp)
    80005530:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005532:	100007b7          	lui	a5,0x10000
    80005536:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000553a:	10000737          	lui	a4,0x10000
    8000553e:	f8000693          	li	a3,-128
    80005542:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005546:	468d                	li	a3,3
    80005548:	10000637          	lui	a2,0x10000
    8000554c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005550:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005554:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005558:	10000737          	lui	a4,0x10000
    8000555c:	461d                	li	a2,7
    8000555e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005562:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005566:	00002597          	auipc	a1,0x2
    8000556a:	1d258593          	addi	a1,a1,466 # 80007738 <etext+0x738>
    8000556e:	0001e517          	auipc	a0,0x1e
    80005572:	03a50513          	addi	a0,a0,58 # 800235a8 <uart_tx_lock>
    80005576:	1fa000ef          	jal	80005770 <initlock>
}
    8000557a:	60a2                	ld	ra,8(sp)
    8000557c:	6402                	ld	s0,0(sp)
    8000557e:	0141                	addi	sp,sp,16
    80005580:	8082                	ret

0000000080005582 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005582:	1101                	addi	sp,sp,-32
    80005584:	ec06                	sd	ra,24(sp)
    80005586:	e822                	sd	s0,16(sp)
    80005588:	e426                	sd	s1,8(sp)
    8000558a:	1000                	addi	s0,sp,32
    8000558c:	84aa                	mv	s1,a0
  push_off();
    8000558e:	222000ef          	jal	800057b0 <push_off>

  if(panicked){
    80005592:	00005797          	auipc	a5,0x5
    80005596:	d0a7a783          	lw	a5,-758(a5) # 8000a29c <panicked>
    8000559a:	e795                	bnez	a5,800055c6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000559c:	10000737          	lui	a4,0x10000
    800055a0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800055a2:	00074783          	lbu	a5,0(a4)
    800055a6:	0207f793          	andi	a5,a5,32
    800055aa:	dfe5                	beqz	a5,800055a2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800055ac:	0ff4f513          	zext.b	a0,s1
    800055b0:	100007b7          	lui	a5,0x10000
    800055b4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800055b8:	27c000ef          	jal	80005834 <pop_off>
}
    800055bc:	60e2                	ld	ra,24(sp)
    800055be:	6442                	ld	s0,16(sp)
    800055c0:	64a2                	ld	s1,8(sp)
    800055c2:	6105                	addi	sp,sp,32
    800055c4:	8082                	ret
    for(;;)
    800055c6:	a001                	j	800055c6 <uartputc_sync+0x44>

00000000800055c8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800055c8:	00005797          	auipc	a5,0x5
    800055cc:	cd87b783          	ld	a5,-808(a5) # 8000a2a0 <uart_tx_r>
    800055d0:	00005717          	auipc	a4,0x5
    800055d4:	cd873703          	ld	a4,-808(a4) # 8000a2a8 <uart_tx_w>
    800055d8:	08f70263          	beq	a4,a5,8000565c <uartstart+0x94>
{
    800055dc:	7139                	addi	sp,sp,-64
    800055de:	fc06                	sd	ra,56(sp)
    800055e0:	f822                	sd	s0,48(sp)
    800055e2:	f426                	sd	s1,40(sp)
    800055e4:	f04a                	sd	s2,32(sp)
    800055e6:	ec4e                	sd	s3,24(sp)
    800055e8:	e852                	sd	s4,16(sp)
    800055ea:	e456                	sd	s5,8(sp)
    800055ec:	e05a                	sd	s6,0(sp)
    800055ee:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800055f0:	10000937          	lui	s2,0x10000
    800055f4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800055f6:	0001ea97          	auipc	s5,0x1e
    800055fa:	fb2a8a93          	addi	s5,s5,-78 # 800235a8 <uart_tx_lock>
    uart_tx_r += 1;
    800055fe:	00005497          	auipc	s1,0x5
    80005602:	ca248493          	addi	s1,s1,-862 # 8000a2a0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005606:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000560a:	00005997          	auipc	s3,0x5
    8000560e:	c9e98993          	addi	s3,s3,-866 # 8000a2a8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005612:	00094703          	lbu	a4,0(s2)
    80005616:	02077713          	andi	a4,a4,32
    8000561a:	c71d                	beqz	a4,80005648 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000561c:	01f7f713          	andi	a4,a5,31
    80005620:	9756                	add	a4,a4,s5
    80005622:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005626:	0785                	addi	a5,a5,1
    80005628:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000562a:	8526                	mv	a0,s1
    8000562c:	d97fb0ef          	jal	800013c2 <wakeup>
    WriteReg(THR, c);
    80005630:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005634:	609c                	ld	a5,0(s1)
    80005636:	0009b703          	ld	a4,0(s3)
    8000563a:	fcf71ce3          	bne	a4,a5,80005612 <uartstart+0x4a>
      ReadReg(ISR);
    8000563e:	100007b7          	lui	a5,0x10000
    80005642:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005644:	0007c783          	lbu	a5,0(a5)
  }
}
    80005648:	70e2                	ld	ra,56(sp)
    8000564a:	7442                	ld	s0,48(sp)
    8000564c:	74a2                	ld	s1,40(sp)
    8000564e:	7902                	ld	s2,32(sp)
    80005650:	69e2                	ld	s3,24(sp)
    80005652:	6a42                	ld	s4,16(sp)
    80005654:	6aa2                	ld	s5,8(sp)
    80005656:	6b02                	ld	s6,0(sp)
    80005658:	6121                	addi	sp,sp,64
    8000565a:	8082                	ret
      ReadReg(ISR);
    8000565c:	100007b7          	lui	a5,0x10000
    80005660:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005662:	0007c783          	lbu	a5,0(a5)
      return;
    80005666:	8082                	ret

0000000080005668 <uartputc>:
{
    80005668:	7179                	addi	sp,sp,-48
    8000566a:	f406                	sd	ra,40(sp)
    8000566c:	f022                	sd	s0,32(sp)
    8000566e:	ec26                	sd	s1,24(sp)
    80005670:	e84a                	sd	s2,16(sp)
    80005672:	e44e                	sd	s3,8(sp)
    80005674:	e052                	sd	s4,0(sp)
    80005676:	1800                	addi	s0,sp,48
    80005678:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000567a:	0001e517          	auipc	a0,0x1e
    8000567e:	f2e50513          	addi	a0,a0,-210 # 800235a8 <uart_tx_lock>
    80005682:	16e000ef          	jal	800057f0 <acquire>
  if(panicked){
    80005686:	00005797          	auipc	a5,0x5
    8000568a:	c167a783          	lw	a5,-1002(a5) # 8000a29c <panicked>
    8000568e:	efbd                	bnez	a5,8000570c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005690:	00005717          	auipc	a4,0x5
    80005694:	c1873703          	ld	a4,-1000(a4) # 8000a2a8 <uart_tx_w>
    80005698:	00005797          	auipc	a5,0x5
    8000569c:	c087b783          	ld	a5,-1016(a5) # 8000a2a0 <uart_tx_r>
    800056a0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800056a4:	0001e997          	auipc	s3,0x1e
    800056a8:	f0498993          	addi	s3,s3,-252 # 800235a8 <uart_tx_lock>
    800056ac:	00005497          	auipc	s1,0x5
    800056b0:	bf448493          	addi	s1,s1,-1036 # 8000a2a0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056b4:	00005917          	auipc	s2,0x5
    800056b8:	bf490913          	addi	s2,s2,-1036 # 8000a2a8 <uart_tx_w>
    800056bc:	00e79d63          	bne	a5,a4,800056d6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800056c0:	85ce                	mv	a1,s3
    800056c2:	8526                	mv	a0,s1
    800056c4:	cb3fb0ef          	jal	80001376 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056c8:	00093703          	ld	a4,0(s2)
    800056cc:	609c                	ld	a5,0(s1)
    800056ce:	02078793          	addi	a5,a5,32
    800056d2:	fee787e3          	beq	a5,a4,800056c0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800056d6:	0001e497          	auipc	s1,0x1e
    800056da:	ed248493          	addi	s1,s1,-302 # 800235a8 <uart_tx_lock>
    800056de:	01f77793          	andi	a5,a4,31
    800056e2:	97a6                	add	a5,a5,s1
    800056e4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800056e8:	0705                	addi	a4,a4,1
    800056ea:	00005797          	auipc	a5,0x5
    800056ee:	bae7bf23          	sd	a4,-1090(a5) # 8000a2a8 <uart_tx_w>
  uartstart();
    800056f2:	ed7ff0ef          	jal	800055c8 <uartstart>
  release(&uart_tx_lock);
    800056f6:	8526                	mv	a0,s1
    800056f8:	190000ef          	jal	80005888 <release>
}
    800056fc:	70a2                	ld	ra,40(sp)
    800056fe:	7402                	ld	s0,32(sp)
    80005700:	64e2                	ld	s1,24(sp)
    80005702:	6942                	ld	s2,16(sp)
    80005704:	69a2                	ld	s3,8(sp)
    80005706:	6a02                	ld	s4,0(sp)
    80005708:	6145                	addi	sp,sp,48
    8000570a:	8082                	ret
    for(;;)
    8000570c:	a001                	j	8000570c <uartputc+0xa4>

000000008000570e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000570e:	1141                	addi	sp,sp,-16
    80005710:	e422                	sd	s0,8(sp)
    80005712:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005714:	100007b7          	lui	a5,0x10000
    80005718:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000571a:	0007c783          	lbu	a5,0(a5)
    8000571e:	8b85                	andi	a5,a5,1
    80005720:	cb81                	beqz	a5,80005730 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005722:	100007b7          	lui	a5,0x10000
    80005726:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000572a:	6422                	ld	s0,8(sp)
    8000572c:	0141                	addi	sp,sp,16
    8000572e:	8082                	ret
    return -1;
    80005730:	557d                	li	a0,-1
    80005732:	bfe5                	j	8000572a <uartgetc+0x1c>

0000000080005734 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005734:	1101                	addi	sp,sp,-32
    80005736:	ec06                	sd	ra,24(sp)
    80005738:	e822                	sd	s0,16(sp)
    8000573a:	e426                	sd	s1,8(sp)
    8000573c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000573e:	54fd                	li	s1,-1
    80005740:	a019                	j	80005746 <uartintr+0x12>
      break;
    consoleintr(c);
    80005742:	85fff0ef          	jal	80004fa0 <consoleintr>
    int c = uartgetc();
    80005746:	fc9ff0ef          	jal	8000570e <uartgetc>
    if(c == -1)
    8000574a:	fe951ce3          	bne	a0,s1,80005742 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000574e:	0001e497          	auipc	s1,0x1e
    80005752:	e5a48493          	addi	s1,s1,-422 # 800235a8 <uart_tx_lock>
    80005756:	8526                	mv	a0,s1
    80005758:	098000ef          	jal	800057f0 <acquire>
  uartstart();
    8000575c:	e6dff0ef          	jal	800055c8 <uartstart>
  release(&uart_tx_lock);
    80005760:	8526                	mv	a0,s1
    80005762:	126000ef          	jal	80005888 <release>
}
    80005766:	60e2                	ld	ra,24(sp)
    80005768:	6442                	ld	s0,16(sp)
    8000576a:	64a2                	ld	s1,8(sp)
    8000576c:	6105                	addi	sp,sp,32
    8000576e:	8082                	ret

0000000080005770 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005770:	1141                	addi	sp,sp,-16
    80005772:	e422                	sd	s0,8(sp)
    80005774:	0800                	addi	s0,sp,16
  lk->name = name;
    80005776:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005778:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000577c:	00053823          	sd	zero,16(a0)
}
    80005780:	6422                	ld	s0,8(sp)
    80005782:	0141                	addi	sp,sp,16
    80005784:	8082                	ret

0000000080005786 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005786:	411c                	lw	a5,0(a0)
    80005788:	e399                	bnez	a5,8000578e <holding+0x8>
    8000578a:	4501                	li	a0,0
  return r;
}
    8000578c:	8082                	ret
{
    8000578e:	1101                	addi	sp,sp,-32
    80005790:	ec06                	sd	ra,24(sp)
    80005792:	e822                	sd	s0,16(sp)
    80005794:	e426                	sd	s1,8(sp)
    80005796:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005798:	6904                	ld	s1,16(a0)
    8000579a:	df2fb0ef          	jal	80000d8c <mycpu>
    8000579e:	40a48533          	sub	a0,s1,a0
    800057a2:	00153513          	seqz	a0,a0
}
    800057a6:	60e2                	ld	ra,24(sp)
    800057a8:	6442                	ld	s0,16(sp)
    800057aa:	64a2                	ld	s1,8(sp)
    800057ac:	6105                	addi	sp,sp,32
    800057ae:	8082                	ret

00000000800057b0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800057b0:	1101                	addi	sp,sp,-32
    800057b2:	ec06                	sd	ra,24(sp)
    800057b4:	e822                	sd	s0,16(sp)
    800057b6:	e426                	sd	s1,8(sp)
    800057b8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800057ba:	100024f3          	csrr	s1,sstatus
    800057be:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800057c2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800057c4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800057c8:	dc4fb0ef          	jal	80000d8c <mycpu>
    800057cc:	5d3c                	lw	a5,120(a0)
    800057ce:	cb99                	beqz	a5,800057e4 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800057d0:	dbcfb0ef          	jal	80000d8c <mycpu>
    800057d4:	5d3c                	lw	a5,120(a0)
    800057d6:	2785                	addiw	a5,a5,1
    800057d8:	dd3c                	sw	a5,120(a0)
}
    800057da:	60e2                	ld	ra,24(sp)
    800057dc:	6442                	ld	s0,16(sp)
    800057de:	64a2                	ld	s1,8(sp)
    800057e0:	6105                	addi	sp,sp,32
    800057e2:	8082                	ret
    mycpu()->intena = old;
    800057e4:	da8fb0ef          	jal	80000d8c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800057e8:	8085                	srli	s1,s1,0x1
    800057ea:	8885                	andi	s1,s1,1
    800057ec:	dd64                	sw	s1,124(a0)
    800057ee:	b7cd                	j	800057d0 <push_off+0x20>

00000000800057f0 <acquire>:
{
    800057f0:	1101                	addi	sp,sp,-32
    800057f2:	ec06                	sd	ra,24(sp)
    800057f4:	e822                	sd	s0,16(sp)
    800057f6:	e426                	sd	s1,8(sp)
    800057f8:	1000                	addi	s0,sp,32
    800057fa:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800057fc:	fb5ff0ef          	jal	800057b0 <push_off>
  if(holding(lk))
    80005800:	8526                	mv	a0,s1
    80005802:	f85ff0ef          	jal	80005786 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005806:	4705                	li	a4,1
  if(holding(lk))
    80005808:	e105                	bnez	a0,80005828 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000580a:	87ba                	mv	a5,a4
    8000580c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005810:	2781                	sext.w	a5,a5
    80005812:	ffe5                	bnez	a5,8000580a <acquire+0x1a>
  __sync_synchronize();
    80005814:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005818:	d74fb0ef          	jal	80000d8c <mycpu>
    8000581c:	e888                	sd	a0,16(s1)
}
    8000581e:	60e2                	ld	ra,24(sp)
    80005820:	6442                	ld	s0,16(sp)
    80005822:	64a2                	ld	s1,8(sp)
    80005824:	6105                	addi	sp,sp,32
    80005826:	8082                	ret
    panic("acquire");
    80005828:	00002517          	auipc	a0,0x2
    8000582c:	f1850513          	addi	a0,a0,-232 # 80007740 <etext+0x740>
    80005830:	c93ff0ef          	jal	800054c2 <panic>

0000000080005834 <pop_off>:

void
pop_off(void)
{
    80005834:	1141                	addi	sp,sp,-16
    80005836:	e406                	sd	ra,8(sp)
    80005838:	e022                	sd	s0,0(sp)
    8000583a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000583c:	d50fb0ef          	jal	80000d8c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005840:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005844:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005846:	e78d                	bnez	a5,80005870 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005848:	5d3c                	lw	a5,120(a0)
    8000584a:	02f05963          	blez	a5,8000587c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000584e:	37fd                	addiw	a5,a5,-1
    80005850:	0007871b          	sext.w	a4,a5
    80005854:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005856:	eb09                	bnez	a4,80005868 <pop_off+0x34>
    80005858:	5d7c                	lw	a5,124(a0)
    8000585a:	c799                	beqz	a5,80005868 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000585c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005860:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005864:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005868:	60a2                	ld	ra,8(sp)
    8000586a:	6402                	ld	s0,0(sp)
    8000586c:	0141                	addi	sp,sp,16
    8000586e:	8082                	ret
    panic("pop_off - interruptible");
    80005870:	00002517          	auipc	a0,0x2
    80005874:	ed850513          	addi	a0,a0,-296 # 80007748 <etext+0x748>
    80005878:	c4bff0ef          	jal	800054c2 <panic>
    panic("pop_off");
    8000587c:	00002517          	auipc	a0,0x2
    80005880:	ee450513          	addi	a0,a0,-284 # 80007760 <etext+0x760>
    80005884:	c3fff0ef          	jal	800054c2 <panic>

0000000080005888 <release>:
{
    80005888:	1101                	addi	sp,sp,-32
    8000588a:	ec06                	sd	ra,24(sp)
    8000588c:	e822                	sd	s0,16(sp)
    8000588e:	e426                	sd	s1,8(sp)
    80005890:	1000                	addi	s0,sp,32
    80005892:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005894:	ef3ff0ef          	jal	80005786 <holding>
    80005898:	c105                	beqz	a0,800058b8 <release+0x30>
  lk->cpu = 0;
    8000589a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000589e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800058a2:	0310000f          	fence	rw,w
    800058a6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800058aa:	f8bff0ef          	jal	80005834 <pop_off>
}
    800058ae:	60e2                	ld	ra,24(sp)
    800058b0:	6442                	ld	s0,16(sp)
    800058b2:	64a2                	ld	s1,8(sp)
    800058b4:	6105                	addi	sp,sp,32
    800058b6:	8082                	ret
    panic("release");
    800058b8:	00002517          	auipc	a0,0x2
    800058bc:	eb050513          	addi	a0,a0,-336 # 80007768 <etext+0x768>
    800058c0:	c03ff0ef          	jal	800054c2 <panic>
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
