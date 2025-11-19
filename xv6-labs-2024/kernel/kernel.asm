
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
    800003b8:	3fd010ef          	jal	80001fb4 <binit>
    iinit();         // inode table
    800003bc:	1ee020ef          	jal	800025aa <iinit>
    fileinit();      // file table
    800003c0:	79b020ef          	jal	8000335a <fileinit>
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
    80000e00:	73e010ef          	jal	8000253e <fsinit>
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
    80001062:	5eb010ef          	jal	80002e4c <namei>
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
    800010fa:	04054e63          	bltz	a0,80001156 <fork+0x88>
    800010fe:	f426                	sd	s1,40(sp)
    80001100:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001102:	048ab783          	ld	a5,72(s5)
    80001106:	04f9b423          	sd	a5,72(s3)
  np->tracemask = p->tracemask; // inherit tracemask from parent
    8000110a:	034aa783          	lw	a5,52(s5)
    8000110e:	02f9aa23          	sw	a5,52(s3)
  *(np->trapframe) = *(p->trapframe);
    80001112:	058ab683          	ld	a3,88(s5)
    80001116:	87b6                	mv	a5,a3
    80001118:	0589b703          	ld	a4,88(s3)
    8000111c:	12068693          	addi	a3,a3,288
    80001120:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001124:	6788                	ld	a0,8(a5)
    80001126:	6b8c                	ld	a1,16(a5)
    80001128:	6f90                	ld	a2,24(a5)
    8000112a:	01073023          	sd	a6,0(a4)
    8000112e:	e708                	sd	a0,8(a4)
    80001130:	eb0c                	sd	a1,16(a4)
    80001132:	ef10                	sd	a2,24(a4)
    80001134:	02078793          	addi	a5,a5,32
    80001138:	02070713          	addi	a4,a4,32
    8000113c:	fed792e3          	bne	a5,a3,80001120 <fork+0x52>
  np->trapframe->a0 = 0;
    80001140:	0589b783          	ld	a5,88(s3)
    80001144:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001148:	0d0a8493          	addi	s1,s5,208
    8000114c:	0d098913          	addi	s2,s3,208
    80001150:	150a8a13          	addi	s4,s5,336
    80001154:	a831                	j	80001170 <fork+0xa2>
    freeproc(np);
    80001156:	854e                	mv	a0,s3
    80001158:	dc3ff0ef          	jal	80000f1a <freeproc>
    release(&np->lock);
    8000115c:	854e                	mv	a0,s3
    8000115e:	78a040ef          	jal	800058e8 <release>
    return -1;
    80001162:	597d                	li	s2,-1
    80001164:	69e2                	ld	s3,24(sp)
    80001166:	a0b5                	j	800011d2 <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    80001168:	04a1                	addi	s1,s1,8
    8000116a:	0921                	addi	s2,s2,8
    8000116c:	01448963          	beq	s1,s4,8000117e <fork+0xb0>
    if(p->ofile[i])
    80001170:	6088                	ld	a0,0(s1)
    80001172:	d97d                	beqz	a0,80001168 <fork+0x9a>
      np->ofile[i] = filedup(p->ofile[i]);
    80001174:	268020ef          	jal	800033dc <filedup>
    80001178:	00a93023          	sd	a0,0(s2)
    8000117c:	b7f5                	j	80001168 <fork+0x9a>
  np->cwd = idup(p->cwd);
    8000117e:	150ab503          	ld	a0,336(s5)
    80001182:	5ba010ef          	jal	8000273c <idup>
    80001186:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000118a:	4641                	li	a2,16
    8000118c:	158a8593          	addi	a1,s5,344
    80001190:	15898513          	addi	a0,s3,344
    80001194:	93aff0ef          	jal	800002ce <safestrcpy>
  pid = np->pid;
    80001198:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000119c:	854e                	mv	a0,s3
    8000119e:	74a040ef          	jal	800058e8 <release>
  acquire(&wait_lock);
    800011a2:	00009497          	auipc	s1,0x9
    800011a6:	2f648493          	addi	s1,s1,758 # 8000a498 <wait_lock>
    800011aa:	8526                	mv	a0,s1
    800011ac:	6a4040ef          	jal	80005850 <acquire>
  np->parent = p;
    800011b0:	0359bc23          	sd	s5,56(s3)
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
    800014c2:	761010ef          	jal	80003422 <fileclose>
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
    800014d6:	333010ef          	jal	80003008 <begin_op>
  iput(p->cwd);
    800014da:	1509b503          	ld	a0,336(s3)
    800014de:	416010ef          	jal	800028f4 <iput>
  end_op();
    800014e2:	391010ef          	jal	80003072 <end_op>
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
    80001d18:	7179                	addi	sp,sp,-48
    80001d1a:	f406                	sd	ra,40(sp)
    80001d1c:	f022                	sd	s0,32(sp)
    80001d1e:	ec26                	sd	s1,24(sp)
    80001d20:	e84a                	sd	s2,16(sp)
    80001d22:	e44e                	sd	s3,8(sp)
    80001d24:	1800                	addi	s0,sp,48
  	int num;
  	struct proc* p = myproc();
    80001d26:	882ff0ef          	jal	80000da8 <myproc>
    80001d2a:	84aa                	mv	s1,a0

  	num = p->trapframe->a7;
    80001d2c:	05853903          	ld	s2,88(a0)
    80001d30:	0a893783          	ld	a5,168(s2)
    80001d34:	0007899b          	sext.w	s3,a5

  	if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d38:	37fd                	addiw	a5,a5,-1
    80001d3a:	4759                	li	a4,22
    80001d3c:	04f76463          	bltu	a4,a5,80001d84 <syscall+0x6c>
    80001d40:	00399713          	slli	a4,s3,0x3
    80001d44:	00006797          	auipc	a5,0x6
    80001d48:	b3478793          	addi	a5,a5,-1228 # 80007878 <syscalls>
    80001d4c:	97ba                	add	a5,a5,a4
    80001d4e:	639c                	ld	a5,0(a5)
    80001d50:	cb95                	beqz	a5,80001d84 <syscall+0x6c>
	  // Use num to lookup the system call function for num, call it,
	  // and store its return value in p->trapframe->a0

		p->trapframe->a0 = syscalls[num]();
    80001d52:	9782                	jalr	a5
    80001d54:	06a93823          	sd	a0,112(s2)

		if (p->tracemask & (1 << num)) {
    80001d58:	58dc                	lw	a5,52(s1)
    80001d5a:	4137d7bb          	sraw	a5,a5,s3
    80001d5e:	8b85                	andi	a5,a5,1
    80001d60:	cf9d                	beqz	a5,80001d9e <syscall+0x86>
			printf("%d: syscall %s -> %ld\n",
    80001d62:	6cb8                	ld	a4,88(s1)
    80001d64:	098e                	slli	s3,s3,0x3
    80001d66:	00006797          	auipc	a5,0x6
    80001d6a:	b1278793          	addi	a5,a5,-1262 # 80007878 <syscalls>
    80001d6e:	97ce                	add	a5,a5,s3
    80001d70:	7b34                	ld	a3,112(a4)
    80001d72:	63f0                	ld	a2,192(a5)
    80001d74:	588c                	lw	a1,48(s1)
    80001d76:	00005517          	auipc	a0,0x5
    80001d7a:	63a50513          	addi	a0,a0,1594 # 800073b0 <etext+0x3b0>
    80001d7e:	4d2030ef          	jal	80005250 <printf>
    80001d82:	a831                	j	80001d9e <syscall+0x86>
				p->pid, syscall_names[num], p->trapframe->a0);
		}
		}
	else {
	printf("%d %s: unknown sys call %d\n",
    80001d84:	86ce                	mv	a3,s3
    80001d86:	15848613          	addi	a2,s1,344
    80001d8a:	588c                	lw	a1,48(s1)
    80001d8c:	00005517          	auipc	a0,0x5
    80001d90:	63c50513          	addi	a0,a0,1596 # 800073c8 <etext+0x3c8>
    80001d94:	4bc030ef          	jal	80005250 <printf>
			p->pid, p->name, num);
	p->trapframe->a0 = -1;
    80001d98:	6cbc                	ld	a5,88(s1)
    80001d9a:	577d                	li	a4,-1
    80001d9c:	fbb8                	sd	a4,112(a5)
	}
}
    80001d9e:	70a2                	ld	ra,40(sp)
    80001da0:	7402                	ld	s0,32(sp)
    80001da2:	64e2                	ld	s1,24(sp)
    80001da4:	6942                	ld	s2,16(sp)
    80001da6:	69a2                	ld	s3,8(sp)
    80001da8:	6145                	addi	sp,sp,48
    80001daa:	8082                	ret

0000000080001dac <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80001dac:	1101                	addi	sp,sp,-32
    80001dae:	ec06                	sd	ra,24(sp)
    80001db0:	e822                	sd	s0,16(sp)
    80001db2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001db4:	fec40593          	addi	a1,s0,-20
    80001db8:	4501                	li	a0,0
    80001dba:	ef7ff0ef          	jal	80001cb0 <argint>
  exit(n);
    80001dbe:	fec42503          	lw	a0,-20(s0)
    80001dc2:	ec8ff0ef          	jal	8000148a <exit>
  return 0;  // not reached
}
    80001dc6:	4501                	li	a0,0
    80001dc8:	60e2                	ld	ra,24(sp)
    80001dca:	6442                	ld	s0,16(sp)
    80001dcc:	6105                	addi	sp,sp,32
    80001dce:	8082                	ret

0000000080001dd0 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001dd0:	1141                	addi	sp,sp,-16
    80001dd2:	e406                	sd	ra,8(sp)
    80001dd4:	e022                	sd	s0,0(sp)
    80001dd6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001dd8:	fd1fe0ef          	jal	80000da8 <myproc>
}
    80001ddc:	5908                	lw	a0,48(a0)
    80001dde:	60a2                	ld	ra,8(sp)
    80001de0:	6402                	ld	s0,0(sp)
    80001de2:	0141                	addi	sp,sp,16
    80001de4:	8082                	ret

0000000080001de6 <sys_fork>:

uint64
sys_fork(void)
{
    80001de6:	1141                	addi	sp,sp,-16
    80001de8:	e406                	sd	ra,8(sp)
    80001dea:	e022                	sd	s0,0(sp)
    80001dec:	0800                	addi	s0,sp,16
  return fork();
    80001dee:	ae0ff0ef          	jal	800010ce <fork>
}
    80001df2:	60a2                	ld	ra,8(sp)
    80001df4:	6402                	ld	s0,0(sp)
    80001df6:	0141                	addi	sp,sp,16
    80001df8:	8082                	ret

0000000080001dfa <sys_wait>:

uint64
sys_wait(void)
{
    80001dfa:	1101                	addi	sp,sp,-32
    80001dfc:	ec06                	sd	ra,24(sp)
    80001dfe:	e822                	sd	s0,16(sp)
    80001e00:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e02:	fe840593          	addi	a1,s0,-24
    80001e06:	4501                	li	a0,0
    80001e08:	ec5ff0ef          	jal	80001ccc <argaddr>
  return wait(p);
    80001e0c:	fe843503          	ld	a0,-24(s0)
    80001e10:	fd0ff0ef          	jal	800015e0 <wait>
}
    80001e14:	60e2                	ld	ra,24(sp)
    80001e16:	6442                	ld	s0,16(sp)
    80001e18:	6105                	addi	sp,sp,32
    80001e1a:	8082                	ret

0000000080001e1c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e1c:	7179                	addi	sp,sp,-48
    80001e1e:	f406                	sd	ra,40(sp)
    80001e20:	f022                	sd	s0,32(sp)
    80001e22:	ec26                	sd	s1,24(sp)
    80001e24:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e26:	fdc40593          	addi	a1,s0,-36
    80001e2a:	4501                	li	a0,0
    80001e2c:	e85ff0ef          	jal	80001cb0 <argint>
  addr = myproc()->sz;
    80001e30:	f79fe0ef          	jal	80000da8 <myproc>
    80001e34:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e36:	fdc42503          	lw	a0,-36(s0)
    80001e3a:	a44ff0ef          	jal	8000107e <growproc>
    80001e3e:	00054863          	bltz	a0,80001e4e <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e42:	8526                	mv	a0,s1
    80001e44:	70a2                	ld	ra,40(sp)
    80001e46:	7402                	ld	s0,32(sp)
    80001e48:	64e2                	ld	s1,24(sp)
    80001e4a:	6145                	addi	sp,sp,48
    80001e4c:	8082                	ret
    return -1;
    80001e4e:	54fd                	li	s1,-1
    80001e50:	bfcd                	j	80001e42 <sys_sbrk+0x26>

0000000080001e52 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e52:	7139                	addi	sp,sp,-64
    80001e54:	fc06                	sd	ra,56(sp)
    80001e56:	f822                	sd	s0,48(sp)
    80001e58:	f04a                	sd	s2,32(sp)
    80001e5a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e5c:	fcc40593          	addi	a1,s0,-52
    80001e60:	4501                	li	a0,0
    80001e62:	e4fff0ef          	jal	80001cb0 <argint>
  if(n < 0)
    80001e66:	fcc42783          	lw	a5,-52(s0)
    80001e6a:	0607c763          	bltz	a5,80001ed8 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e6e:	0000e517          	auipc	a0,0xe
    80001e72:	44250513          	addi	a0,a0,1090 # 800102b0 <tickslock>
    80001e76:	1db030ef          	jal	80005850 <acquire>
  ticks0 = ticks;
    80001e7a:	00008917          	auipc	s2,0x8
    80001e7e:	5ce92903          	lw	s2,1486(s2) # 8000a448 <ticks>
  while(ticks - ticks0 < n){
    80001e82:	fcc42783          	lw	a5,-52(s0)
    80001e86:	cf8d                	beqz	a5,80001ec0 <sys_sleep+0x6e>
    80001e88:	f426                	sd	s1,40(sp)
    80001e8a:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e8c:	0000e997          	auipc	s3,0xe
    80001e90:	42498993          	addi	s3,s3,1060 # 800102b0 <tickslock>
    80001e94:	00008497          	auipc	s1,0x8
    80001e98:	5b448493          	addi	s1,s1,1460 # 8000a448 <ticks>
    if(killed(myproc())){
    80001e9c:	f0dfe0ef          	jal	80000da8 <myproc>
    80001ea0:	f16ff0ef          	jal	800015b6 <killed>
    80001ea4:	ed0d                	bnez	a0,80001ede <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001ea6:	85ce                	mv	a1,s3
    80001ea8:	8526                	mv	a0,s1
    80001eaa:	cd4ff0ef          	jal	8000137e <sleep>
  while(ticks - ticks0 < n){
    80001eae:	409c                	lw	a5,0(s1)
    80001eb0:	412787bb          	subw	a5,a5,s2
    80001eb4:	fcc42703          	lw	a4,-52(s0)
    80001eb8:	fee7e2e3          	bltu	a5,a4,80001e9c <sys_sleep+0x4a>
    80001ebc:	74a2                	ld	s1,40(sp)
    80001ebe:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ec0:	0000e517          	auipc	a0,0xe
    80001ec4:	3f050513          	addi	a0,a0,1008 # 800102b0 <tickslock>
    80001ec8:	221030ef          	jal	800058e8 <release>
  return 0;
    80001ecc:	4501                	li	a0,0
}
    80001ece:	70e2                	ld	ra,56(sp)
    80001ed0:	7442                	ld	s0,48(sp)
    80001ed2:	7902                	ld	s2,32(sp)
    80001ed4:	6121                	addi	sp,sp,64
    80001ed6:	8082                	ret
    n = 0;
    80001ed8:	fc042623          	sw	zero,-52(s0)
    80001edc:	bf49                	j	80001e6e <sys_sleep+0x1c>
      release(&tickslock);
    80001ede:	0000e517          	auipc	a0,0xe
    80001ee2:	3d250513          	addi	a0,a0,978 # 800102b0 <tickslock>
    80001ee6:	203030ef          	jal	800058e8 <release>
      return -1;
    80001eea:	557d                	li	a0,-1
    80001eec:	74a2                	ld	s1,40(sp)
    80001eee:	69e2                	ld	s3,24(sp)
    80001ef0:	bff9                	j	80001ece <sys_sleep+0x7c>

0000000080001ef2 <sys_kill>:

uint64
sys_kill(void)
{
    80001ef2:	1101                	addi	sp,sp,-32
    80001ef4:	ec06                	sd	ra,24(sp)
    80001ef6:	e822                	sd	s0,16(sp)
    80001ef8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001efa:	fec40593          	addi	a1,s0,-20
    80001efe:	4501                	li	a0,0
    80001f00:	db1ff0ef          	jal	80001cb0 <argint>
  return kill(pid);
    80001f04:	fec42503          	lw	a0,-20(s0)
    80001f08:	e24ff0ef          	jal	8000152c <kill>
}
    80001f0c:	60e2                	ld	ra,24(sp)
    80001f0e:	6442                	ld	s0,16(sp)
    80001f10:	6105                	addi	sp,sp,32
    80001f12:	8082                	ret

0000000080001f14 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f14:	1101                	addi	sp,sp,-32
    80001f16:	ec06                	sd	ra,24(sp)
    80001f18:	e822                	sd	s0,16(sp)
    80001f1a:	e426                	sd	s1,8(sp)
    80001f1c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f1e:	0000e517          	auipc	a0,0xe
    80001f22:	39250513          	addi	a0,a0,914 # 800102b0 <tickslock>
    80001f26:	12b030ef          	jal	80005850 <acquire>
  xticks = ticks;
    80001f2a:	00008497          	auipc	s1,0x8
    80001f2e:	51e4a483          	lw	s1,1310(s1) # 8000a448 <ticks>
  release(&tickslock);
    80001f32:	0000e517          	auipc	a0,0xe
    80001f36:	37e50513          	addi	a0,a0,894 # 800102b0 <tickslock>
    80001f3a:	1af030ef          	jal	800058e8 <release>
  return xticks;
}
    80001f3e:	02049513          	slli	a0,s1,0x20
    80001f42:	9101                	srli	a0,a0,0x20
    80001f44:	60e2                	ld	ra,24(sp)
    80001f46:	6442                	ld	s0,16(sp)
    80001f48:	64a2                	ld	s1,8(sp)
    80001f4a:	6105                	addi	sp,sp,32
    80001f4c:	8082                	ret

0000000080001f4e <sys_trace>:

uint64
sys_trace(void)
{
    80001f4e:	1101                	addi	sp,sp,-32
    80001f50:	ec06                	sd	ra,24(sp)
    80001f52:	e822                	sd	s0,16(sp)
    80001f54:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    80001f56:	fec40593          	addi	a1,s0,-20
    80001f5a:	4501                	li	a0,0
    80001f5c:	d55ff0ef          	jal	80001cb0 <argint>
  myproc()->tracemask = mask;
    80001f60:	e49fe0ef          	jal	80000da8 <myproc>
    80001f64:	fec42783          	lw	a5,-20(s0)
    80001f68:	d95c                	sw	a5,52(a0)
  return 0;
}
    80001f6a:	4501                	li	a0,0
    80001f6c:	60e2                	ld	ra,24(sp)
    80001f6e:	6442                	ld	s0,16(sp)
    80001f70:	6105                	addi	sp,sp,32
    80001f72:	8082                	ret

0000000080001f74 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80001f74:	7179                	addi	sp,sp,-48
    80001f76:	f406                	sd	ra,40(sp)
    80001f78:	f022                	sd	s0,32(sp)
    80001f7a:	1800                	addi	s0,sp,48
  struct sysinfo info;
  uint64 addr;

  argaddr(0, &addr);
    80001f7c:	fd840593          	addi	a1,s0,-40
    80001f80:	4501                	li	a0,0
    80001f82:	d4bff0ef          	jal	80001ccc <argaddr>

  info.freemem = getfreemem();
    80001f86:	9c8fe0ef          	jal	8000014e <getfreemem>
    80001f8a:	fea43023          	sd	a0,-32(s0)
  info.nproc = getnproc();
    80001f8e:	885ff0ef          	jal	80001812 <getnproc>
    80001f92:	fea43423          	sd	a0,-24(s0)

  if(copyout(myproc()->pagetable, addr, (char*)&info, sizeof(info)) < 0){
    80001f96:	e13fe0ef          	jal	80000da8 <myproc>
    80001f9a:	46c1                	li	a3,16
    80001f9c:	fe040613          	addi	a2,s0,-32
    80001fa0:	fd843583          	ld	a1,-40(s0)
    80001fa4:	6928                	ld	a0,80(a0)
    80001fa6:	a75fe0ef          	jal	80000a1a <copyout>
    return -1;
  }

  return 0;
}
    80001faa:	957d                	srai	a0,a0,0x3f
    80001fac:	70a2                	ld	ra,40(sp)
    80001fae:	7402                	ld	s0,32(sp)
    80001fb0:	6145                	addi	sp,sp,48
    80001fb2:	8082                	ret

0000000080001fb4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001fb4:	7179                	addi	sp,sp,-48
    80001fb6:	f406                	sd	ra,40(sp)
    80001fb8:	f022                	sd	s0,32(sp)
    80001fba:	ec26                	sd	s1,24(sp)
    80001fbc:	e84a                	sd	s2,16(sp)
    80001fbe:	e44e                	sd	s3,8(sp)
    80001fc0:	e052                	sd	s4,0(sp)
    80001fc2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001fc4:	00005597          	auipc	a1,0x5
    80001fc8:	4d458593          	addi	a1,a1,1236 # 80007498 <etext+0x498>
    80001fcc:	0000e517          	auipc	a0,0xe
    80001fd0:	2fc50513          	addi	a0,a0,764 # 800102c8 <bcache>
    80001fd4:	7fc030ef          	jal	800057d0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001fd8:	00016797          	auipc	a5,0x16
    80001fdc:	2f078793          	addi	a5,a5,752 # 800182c8 <bcache+0x8000>
    80001fe0:	00016717          	auipc	a4,0x16
    80001fe4:	55070713          	addi	a4,a4,1360 # 80018530 <bcache+0x8268>
    80001fe8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fec:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ff0:	0000e497          	auipc	s1,0xe
    80001ff4:	2f048493          	addi	s1,s1,752 # 800102e0 <bcache+0x18>
    b->next = bcache.head.next;
    80001ff8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001ffa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001ffc:	00005a17          	auipc	s4,0x5
    80002000:	4a4a0a13          	addi	s4,s4,1188 # 800074a0 <etext+0x4a0>
    b->next = bcache.head.next;
    80002004:	2b893783          	ld	a5,696(s2)
    80002008:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000200a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000200e:	85d2                	mv	a1,s4
    80002010:	01048513          	addi	a0,s1,16
    80002014:	248010ef          	jal	8000325c <initsleeplock>
    bcache.head.next->prev = b;
    80002018:	2b893783          	ld	a5,696(s2)
    8000201c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000201e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002022:	45848493          	addi	s1,s1,1112
    80002026:	fd349fe3          	bne	s1,s3,80002004 <binit+0x50>
  }
}
    8000202a:	70a2                	ld	ra,40(sp)
    8000202c:	7402                	ld	s0,32(sp)
    8000202e:	64e2                	ld	s1,24(sp)
    80002030:	6942                	ld	s2,16(sp)
    80002032:	69a2                	ld	s3,8(sp)
    80002034:	6a02                	ld	s4,0(sp)
    80002036:	6145                	addi	sp,sp,48
    80002038:	8082                	ret

000000008000203a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000203a:	7179                	addi	sp,sp,-48
    8000203c:	f406                	sd	ra,40(sp)
    8000203e:	f022                	sd	s0,32(sp)
    80002040:	ec26                	sd	s1,24(sp)
    80002042:	e84a                	sd	s2,16(sp)
    80002044:	e44e                	sd	s3,8(sp)
    80002046:	1800                	addi	s0,sp,48
    80002048:	892a                	mv	s2,a0
    8000204a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000204c:	0000e517          	auipc	a0,0xe
    80002050:	27c50513          	addi	a0,a0,636 # 800102c8 <bcache>
    80002054:	7fc030ef          	jal	80005850 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002058:	00016497          	auipc	s1,0x16
    8000205c:	5284b483          	ld	s1,1320(s1) # 80018580 <bcache+0x82b8>
    80002060:	00016797          	auipc	a5,0x16
    80002064:	4d078793          	addi	a5,a5,1232 # 80018530 <bcache+0x8268>
    80002068:	02f48b63          	beq	s1,a5,8000209e <bread+0x64>
    8000206c:	873e                	mv	a4,a5
    8000206e:	a021                	j	80002076 <bread+0x3c>
    80002070:	68a4                	ld	s1,80(s1)
    80002072:	02e48663          	beq	s1,a4,8000209e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002076:	449c                	lw	a5,8(s1)
    80002078:	ff279ce3          	bne	a5,s2,80002070 <bread+0x36>
    8000207c:	44dc                	lw	a5,12(s1)
    8000207e:	ff3799e3          	bne	a5,s3,80002070 <bread+0x36>
      b->refcnt++;
    80002082:	40bc                	lw	a5,64(s1)
    80002084:	2785                	addiw	a5,a5,1
    80002086:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002088:	0000e517          	auipc	a0,0xe
    8000208c:	24050513          	addi	a0,a0,576 # 800102c8 <bcache>
    80002090:	059030ef          	jal	800058e8 <release>
      acquiresleep(&b->lock);
    80002094:	01048513          	addi	a0,s1,16
    80002098:	1fa010ef          	jal	80003292 <acquiresleep>
      return b;
    8000209c:	a889                	j	800020ee <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000209e:	00016497          	auipc	s1,0x16
    800020a2:	4da4b483          	ld	s1,1242(s1) # 80018578 <bcache+0x82b0>
    800020a6:	00016797          	auipc	a5,0x16
    800020aa:	48a78793          	addi	a5,a5,1162 # 80018530 <bcache+0x8268>
    800020ae:	00f48863          	beq	s1,a5,800020be <bread+0x84>
    800020b2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800020b4:	40bc                	lw	a5,64(s1)
    800020b6:	cb91                	beqz	a5,800020ca <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020b8:	64a4                	ld	s1,72(s1)
    800020ba:	fee49de3          	bne	s1,a4,800020b4 <bread+0x7a>
  panic("bget: no buffers");
    800020be:	00005517          	auipc	a0,0x5
    800020c2:	3ea50513          	addi	a0,a0,1002 # 800074a8 <etext+0x4a8>
    800020c6:	45c030ef          	jal	80005522 <panic>
      b->dev = dev;
    800020ca:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020ce:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020d2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020d6:	4785                	li	a5,1
    800020d8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020da:	0000e517          	auipc	a0,0xe
    800020de:	1ee50513          	addi	a0,a0,494 # 800102c8 <bcache>
    800020e2:	007030ef          	jal	800058e8 <release>
      acquiresleep(&b->lock);
    800020e6:	01048513          	addi	a0,s1,16
    800020ea:	1a8010ef          	jal	80003292 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020ee:	409c                	lw	a5,0(s1)
    800020f0:	cb89                	beqz	a5,80002102 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020f2:	8526                	mv	a0,s1
    800020f4:	70a2                	ld	ra,40(sp)
    800020f6:	7402                	ld	s0,32(sp)
    800020f8:	64e2                	ld	s1,24(sp)
    800020fa:	6942                	ld	s2,16(sp)
    800020fc:	69a2                	ld	s3,8(sp)
    800020fe:	6145                	addi	sp,sp,48
    80002100:	8082                	ret
    virtio_disk_rw(b, 0);
    80002102:	4581                	li	a1,0
    80002104:	8526                	mv	a0,s1
    80002106:	1eb020ef          	jal	80004af0 <virtio_disk_rw>
    b->valid = 1;
    8000210a:	4785                	li	a5,1
    8000210c:	c09c                	sw	a5,0(s1)
  return b;
    8000210e:	b7d5                	j	800020f2 <bread+0xb8>

0000000080002110 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002110:	1101                	addi	sp,sp,-32
    80002112:	ec06                	sd	ra,24(sp)
    80002114:	e822                	sd	s0,16(sp)
    80002116:	e426                	sd	s1,8(sp)
    80002118:	1000                	addi	s0,sp,32
    8000211a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000211c:	0541                	addi	a0,a0,16
    8000211e:	1f2010ef          	jal	80003310 <holdingsleep>
    80002122:	c911                	beqz	a0,80002136 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002124:	4585                	li	a1,1
    80002126:	8526                	mv	a0,s1
    80002128:	1c9020ef          	jal	80004af0 <virtio_disk_rw>
}
    8000212c:	60e2                	ld	ra,24(sp)
    8000212e:	6442                	ld	s0,16(sp)
    80002130:	64a2                	ld	s1,8(sp)
    80002132:	6105                	addi	sp,sp,32
    80002134:	8082                	ret
    panic("bwrite");
    80002136:	00005517          	auipc	a0,0x5
    8000213a:	38a50513          	addi	a0,a0,906 # 800074c0 <etext+0x4c0>
    8000213e:	3e4030ef          	jal	80005522 <panic>

0000000080002142 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002142:	1101                	addi	sp,sp,-32
    80002144:	ec06                	sd	ra,24(sp)
    80002146:	e822                	sd	s0,16(sp)
    80002148:	e426                	sd	s1,8(sp)
    8000214a:	e04a                	sd	s2,0(sp)
    8000214c:	1000                	addi	s0,sp,32
    8000214e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002150:	01050913          	addi	s2,a0,16
    80002154:	854a                	mv	a0,s2
    80002156:	1ba010ef          	jal	80003310 <holdingsleep>
    8000215a:	c135                	beqz	a0,800021be <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000215c:	854a                	mv	a0,s2
    8000215e:	17a010ef          	jal	800032d8 <releasesleep>

  acquire(&bcache.lock);
    80002162:	0000e517          	auipc	a0,0xe
    80002166:	16650513          	addi	a0,a0,358 # 800102c8 <bcache>
    8000216a:	6e6030ef          	jal	80005850 <acquire>
  b->refcnt--;
    8000216e:	40bc                	lw	a5,64(s1)
    80002170:	37fd                	addiw	a5,a5,-1
    80002172:	0007871b          	sext.w	a4,a5
    80002176:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002178:	e71d                	bnez	a4,800021a6 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000217a:	68b8                	ld	a4,80(s1)
    8000217c:	64bc                	ld	a5,72(s1)
    8000217e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002180:	68b8                	ld	a4,80(s1)
    80002182:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002184:	00016797          	auipc	a5,0x16
    80002188:	14478793          	addi	a5,a5,324 # 800182c8 <bcache+0x8000>
    8000218c:	2b87b703          	ld	a4,696(a5)
    80002190:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002192:	00016717          	auipc	a4,0x16
    80002196:	39e70713          	addi	a4,a4,926 # 80018530 <bcache+0x8268>
    8000219a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000219c:	2b87b703          	ld	a4,696(a5)
    800021a0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800021a2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800021a6:	0000e517          	auipc	a0,0xe
    800021aa:	12250513          	addi	a0,a0,290 # 800102c8 <bcache>
    800021ae:	73a030ef          	jal	800058e8 <release>
}
    800021b2:	60e2                	ld	ra,24(sp)
    800021b4:	6442                	ld	s0,16(sp)
    800021b6:	64a2                	ld	s1,8(sp)
    800021b8:	6902                	ld	s2,0(sp)
    800021ba:	6105                	addi	sp,sp,32
    800021bc:	8082                	ret
    panic("brelse");
    800021be:	00005517          	auipc	a0,0x5
    800021c2:	30a50513          	addi	a0,a0,778 # 800074c8 <etext+0x4c8>
    800021c6:	35c030ef          	jal	80005522 <panic>

00000000800021ca <bpin>:

void
bpin(struct buf *b) {
    800021ca:	1101                	addi	sp,sp,-32
    800021cc:	ec06                	sd	ra,24(sp)
    800021ce:	e822                	sd	s0,16(sp)
    800021d0:	e426                	sd	s1,8(sp)
    800021d2:	1000                	addi	s0,sp,32
    800021d4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021d6:	0000e517          	auipc	a0,0xe
    800021da:	0f250513          	addi	a0,a0,242 # 800102c8 <bcache>
    800021de:	672030ef          	jal	80005850 <acquire>
  b->refcnt++;
    800021e2:	40bc                	lw	a5,64(s1)
    800021e4:	2785                	addiw	a5,a5,1
    800021e6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021e8:	0000e517          	auipc	a0,0xe
    800021ec:	0e050513          	addi	a0,a0,224 # 800102c8 <bcache>
    800021f0:	6f8030ef          	jal	800058e8 <release>
}
    800021f4:	60e2                	ld	ra,24(sp)
    800021f6:	6442                	ld	s0,16(sp)
    800021f8:	64a2                	ld	s1,8(sp)
    800021fa:	6105                	addi	sp,sp,32
    800021fc:	8082                	ret

00000000800021fe <bunpin>:

void
bunpin(struct buf *b) {
    800021fe:	1101                	addi	sp,sp,-32
    80002200:	ec06                	sd	ra,24(sp)
    80002202:	e822                	sd	s0,16(sp)
    80002204:	e426                	sd	s1,8(sp)
    80002206:	1000                	addi	s0,sp,32
    80002208:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000220a:	0000e517          	auipc	a0,0xe
    8000220e:	0be50513          	addi	a0,a0,190 # 800102c8 <bcache>
    80002212:	63e030ef          	jal	80005850 <acquire>
  b->refcnt--;
    80002216:	40bc                	lw	a5,64(s1)
    80002218:	37fd                	addiw	a5,a5,-1
    8000221a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000221c:	0000e517          	auipc	a0,0xe
    80002220:	0ac50513          	addi	a0,a0,172 # 800102c8 <bcache>
    80002224:	6c4030ef          	jal	800058e8 <release>
}
    80002228:	60e2                	ld	ra,24(sp)
    8000222a:	6442                	ld	s0,16(sp)
    8000222c:	64a2                	ld	s1,8(sp)
    8000222e:	6105                	addi	sp,sp,32
    80002230:	8082                	ret

0000000080002232 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002232:	1101                	addi	sp,sp,-32
    80002234:	ec06                	sd	ra,24(sp)
    80002236:	e822                	sd	s0,16(sp)
    80002238:	e426                	sd	s1,8(sp)
    8000223a:	e04a                	sd	s2,0(sp)
    8000223c:	1000                	addi	s0,sp,32
    8000223e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002240:	00d5d59b          	srliw	a1,a1,0xd
    80002244:	00016797          	auipc	a5,0x16
    80002248:	7607a783          	lw	a5,1888(a5) # 800189a4 <sb+0x1c>
    8000224c:	9dbd                	addw	a1,a1,a5
    8000224e:	dedff0ef          	jal	8000203a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002252:	0074f713          	andi	a4,s1,7
    80002256:	4785                	li	a5,1
    80002258:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000225c:	14ce                	slli	s1,s1,0x33
    8000225e:	90d9                	srli	s1,s1,0x36
    80002260:	00950733          	add	a4,a0,s1
    80002264:	05874703          	lbu	a4,88(a4)
    80002268:	00e7f6b3          	and	a3,a5,a4
    8000226c:	c29d                	beqz	a3,80002292 <bfree+0x60>
    8000226e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002270:	94aa                	add	s1,s1,a0
    80002272:	fff7c793          	not	a5,a5
    80002276:	8f7d                	and	a4,a4,a5
    80002278:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000227c:	711000ef          	jal	8000318c <log_write>
  brelse(bp);
    80002280:	854a                	mv	a0,s2
    80002282:	ec1ff0ef          	jal	80002142 <brelse>
}
    80002286:	60e2                	ld	ra,24(sp)
    80002288:	6442                	ld	s0,16(sp)
    8000228a:	64a2                	ld	s1,8(sp)
    8000228c:	6902                	ld	s2,0(sp)
    8000228e:	6105                	addi	sp,sp,32
    80002290:	8082                	ret
    panic("freeing free block");
    80002292:	00005517          	auipc	a0,0x5
    80002296:	23e50513          	addi	a0,a0,574 # 800074d0 <etext+0x4d0>
    8000229a:	288030ef          	jal	80005522 <panic>

000000008000229e <balloc>:
{
    8000229e:	711d                	addi	sp,sp,-96
    800022a0:	ec86                	sd	ra,88(sp)
    800022a2:	e8a2                	sd	s0,80(sp)
    800022a4:	e4a6                	sd	s1,72(sp)
    800022a6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800022a8:	00016797          	auipc	a5,0x16
    800022ac:	6e47a783          	lw	a5,1764(a5) # 8001898c <sb+0x4>
    800022b0:	0e078f63          	beqz	a5,800023ae <balloc+0x110>
    800022b4:	e0ca                	sd	s2,64(sp)
    800022b6:	fc4e                	sd	s3,56(sp)
    800022b8:	f852                	sd	s4,48(sp)
    800022ba:	f456                	sd	s5,40(sp)
    800022bc:	f05a                	sd	s6,32(sp)
    800022be:	ec5e                	sd	s7,24(sp)
    800022c0:	e862                	sd	s8,16(sp)
    800022c2:	e466                	sd	s9,8(sp)
    800022c4:	8baa                	mv	s7,a0
    800022c6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022c8:	00016b17          	auipc	s6,0x16
    800022cc:	6c0b0b13          	addi	s6,s6,1728 # 80018988 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022d0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800022d2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022d4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022d6:	6c89                	lui	s9,0x2
    800022d8:	a0b5                	j	80002344 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022da:	97ca                	add	a5,a5,s2
    800022dc:	8e55                	or	a2,a2,a3
    800022de:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800022e2:	854a                	mv	a0,s2
    800022e4:	6a9000ef          	jal	8000318c <log_write>
        brelse(bp);
    800022e8:	854a                	mv	a0,s2
    800022ea:	e59ff0ef          	jal	80002142 <brelse>
  bp = bread(dev, bno);
    800022ee:	85a6                	mv	a1,s1
    800022f0:	855e                	mv	a0,s7
    800022f2:	d49ff0ef          	jal	8000203a <bread>
    800022f6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022f8:	40000613          	li	a2,1024
    800022fc:	4581                	li	a1,0
    800022fe:	05850513          	addi	a0,a0,88
    80002302:	e8ffd0ef          	jal	80000190 <memset>
  log_write(bp);
    80002306:	854a                	mv	a0,s2
    80002308:	685000ef          	jal	8000318c <log_write>
  brelse(bp);
    8000230c:	854a                	mv	a0,s2
    8000230e:	e35ff0ef          	jal	80002142 <brelse>
}
    80002312:	6906                	ld	s2,64(sp)
    80002314:	79e2                	ld	s3,56(sp)
    80002316:	7a42                	ld	s4,48(sp)
    80002318:	7aa2                	ld	s5,40(sp)
    8000231a:	7b02                	ld	s6,32(sp)
    8000231c:	6be2                	ld	s7,24(sp)
    8000231e:	6c42                	ld	s8,16(sp)
    80002320:	6ca2                	ld	s9,8(sp)
}
    80002322:	8526                	mv	a0,s1
    80002324:	60e6                	ld	ra,88(sp)
    80002326:	6446                	ld	s0,80(sp)
    80002328:	64a6                	ld	s1,72(sp)
    8000232a:	6125                	addi	sp,sp,96
    8000232c:	8082                	ret
    brelse(bp);
    8000232e:	854a                	mv	a0,s2
    80002330:	e13ff0ef          	jal	80002142 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002334:	015c87bb          	addw	a5,s9,s5
    80002338:	00078a9b          	sext.w	s5,a5
    8000233c:	004b2703          	lw	a4,4(s6)
    80002340:	04eaff63          	bgeu	s5,a4,8000239e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002344:	41fad79b          	sraiw	a5,s5,0x1f
    80002348:	0137d79b          	srliw	a5,a5,0x13
    8000234c:	015787bb          	addw	a5,a5,s5
    80002350:	40d7d79b          	sraiw	a5,a5,0xd
    80002354:	01cb2583          	lw	a1,28(s6)
    80002358:	9dbd                	addw	a1,a1,a5
    8000235a:	855e                	mv	a0,s7
    8000235c:	cdfff0ef          	jal	8000203a <bread>
    80002360:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002362:	004b2503          	lw	a0,4(s6)
    80002366:	000a849b          	sext.w	s1,s5
    8000236a:	8762                	mv	a4,s8
    8000236c:	fca4f1e3          	bgeu	s1,a0,8000232e <balloc+0x90>
      m = 1 << (bi % 8);
    80002370:	00777693          	andi	a3,a4,7
    80002374:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002378:	41f7579b          	sraiw	a5,a4,0x1f
    8000237c:	01d7d79b          	srliw	a5,a5,0x1d
    80002380:	9fb9                	addw	a5,a5,a4
    80002382:	4037d79b          	sraiw	a5,a5,0x3
    80002386:	00f90633          	add	a2,s2,a5
    8000238a:	05864603          	lbu	a2,88(a2)
    8000238e:	00c6f5b3          	and	a1,a3,a2
    80002392:	d5a1                	beqz	a1,800022da <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002394:	2705                	addiw	a4,a4,1
    80002396:	2485                	addiw	s1,s1,1
    80002398:	fd471ae3          	bne	a4,s4,8000236c <balloc+0xce>
    8000239c:	bf49                	j	8000232e <balloc+0x90>
    8000239e:	6906                	ld	s2,64(sp)
    800023a0:	79e2                	ld	s3,56(sp)
    800023a2:	7a42                	ld	s4,48(sp)
    800023a4:	7aa2                	ld	s5,40(sp)
    800023a6:	7b02                	ld	s6,32(sp)
    800023a8:	6be2                	ld	s7,24(sp)
    800023aa:	6c42                	ld	s8,16(sp)
    800023ac:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800023ae:	00005517          	auipc	a0,0x5
    800023b2:	13a50513          	addi	a0,a0,314 # 800074e8 <etext+0x4e8>
    800023b6:	69b020ef          	jal	80005250 <printf>
  return 0;
    800023ba:	4481                	li	s1,0
    800023bc:	b79d                	j	80002322 <balloc+0x84>

00000000800023be <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023be:	7179                	addi	sp,sp,-48
    800023c0:	f406                	sd	ra,40(sp)
    800023c2:	f022                	sd	s0,32(sp)
    800023c4:	ec26                	sd	s1,24(sp)
    800023c6:	e84a                	sd	s2,16(sp)
    800023c8:	e44e                	sd	s3,8(sp)
    800023ca:	1800                	addi	s0,sp,48
    800023cc:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023ce:	47ad                	li	a5,11
    800023d0:	02b7e663          	bltu	a5,a1,800023fc <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800023d4:	02059793          	slli	a5,a1,0x20
    800023d8:	01e7d593          	srli	a1,a5,0x1e
    800023dc:	00b504b3          	add	s1,a0,a1
    800023e0:	0504a903          	lw	s2,80(s1)
    800023e4:	06091a63          	bnez	s2,80002458 <bmap+0x9a>
      addr = balloc(ip->dev);
    800023e8:	4108                	lw	a0,0(a0)
    800023ea:	eb5ff0ef          	jal	8000229e <balloc>
    800023ee:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023f2:	06090363          	beqz	s2,80002458 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800023f6:	0524a823          	sw	s2,80(s1)
    800023fa:	a8b9                	j	80002458 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023fc:	ff45849b          	addiw	s1,a1,-12
    80002400:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002404:	0ff00793          	li	a5,255
    80002408:	06e7ee63          	bltu	a5,a4,80002484 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000240c:	08052903          	lw	s2,128(a0)
    80002410:	00091d63          	bnez	s2,8000242a <bmap+0x6c>
      addr = balloc(ip->dev);
    80002414:	4108                	lw	a0,0(a0)
    80002416:	e89ff0ef          	jal	8000229e <balloc>
    8000241a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000241e:	02090d63          	beqz	s2,80002458 <bmap+0x9a>
    80002422:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002424:	0929a023          	sw	s2,128(s3)
    80002428:	a011                	j	8000242c <bmap+0x6e>
    8000242a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000242c:	85ca                	mv	a1,s2
    8000242e:	0009a503          	lw	a0,0(s3)
    80002432:	c09ff0ef          	jal	8000203a <bread>
    80002436:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002438:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000243c:	02049713          	slli	a4,s1,0x20
    80002440:	01e75593          	srli	a1,a4,0x1e
    80002444:	00b784b3          	add	s1,a5,a1
    80002448:	0004a903          	lw	s2,0(s1)
    8000244c:	00090e63          	beqz	s2,80002468 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002450:	8552                	mv	a0,s4
    80002452:	cf1ff0ef          	jal	80002142 <brelse>
    return addr;
    80002456:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002458:	854a                	mv	a0,s2
    8000245a:	70a2                	ld	ra,40(sp)
    8000245c:	7402                	ld	s0,32(sp)
    8000245e:	64e2                	ld	s1,24(sp)
    80002460:	6942                	ld	s2,16(sp)
    80002462:	69a2                	ld	s3,8(sp)
    80002464:	6145                	addi	sp,sp,48
    80002466:	8082                	ret
      addr = balloc(ip->dev);
    80002468:	0009a503          	lw	a0,0(s3)
    8000246c:	e33ff0ef          	jal	8000229e <balloc>
    80002470:	0005091b          	sext.w	s2,a0
      if(addr){
    80002474:	fc090ee3          	beqz	s2,80002450 <bmap+0x92>
        a[bn] = addr;
    80002478:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000247c:	8552                	mv	a0,s4
    8000247e:	50f000ef          	jal	8000318c <log_write>
    80002482:	b7f9                	j	80002450 <bmap+0x92>
    80002484:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002486:	00005517          	auipc	a0,0x5
    8000248a:	07a50513          	addi	a0,a0,122 # 80007500 <etext+0x500>
    8000248e:	094030ef          	jal	80005522 <panic>

0000000080002492 <iget>:
{
    80002492:	7179                	addi	sp,sp,-48
    80002494:	f406                	sd	ra,40(sp)
    80002496:	f022                	sd	s0,32(sp)
    80002498:	ec26                	sd	s1,24(sp)
    8000249a:	e84a                	sd	s2,16(sp)
    8000249c:	e44e                	sd	s3,8(sp)
    8000249e:	e052                	sd	s4,0(sp)
    800024a0:	1800                	addi	s0,sp,48
    800024a2:	89aa                	mv	s3,a0
    800024a4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800024a6:	00016517          	auipc	a0,0x16
    800024aa:	50250513          	addi	a0,a0,1282 # 800189a8 <itable>
    800024ae:	3a2030ef          	jal	80005850 <acquire>
  empty = 0;
    800024b2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024b4:	00016497          	auipc	s1,0x16
    800024b8:	50c48493          	addi	s1,s1,1292 # 800189c0 <itable+0x18>
    800024bc:	00018697          	auipc	a3,0x18
    800024c0:	f9468693          	addi	a3,a3,-108 # 8001a450 <log>
    800024c4:	a039                	j	800024d2 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024c6:	02090963          	beqz	s2,800024f8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024ca:	08848493          	addi	s1,s1,136
    800024ce:	02d48863          	beq	s1,a3,800024fe <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024d2:	449c                	lw	a5,8(s1)
    800024d4:	fef059e3          	blez	a5,800024c6 <iget+0x34>
    800024d8:	4098                	lw	a4,0(s1)
    800024da:	ff3716e3          	bne	a4,s3,800024c6 <iget+0x34>
    800024de:	40d8                	lw	a4,4(s1)
    800024e0:	ff4713e3          	bne	a4,s4,800024c6 <iget+0x34>
      ip->ref++;
    800024e4:	2785                	addiw	a5,a5,1
    800024e6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024e8:	00016517          	auipc	a0,0x16
    800024ec:	4c050513          	addi	a0,a0,1216 # 800189a8 <itable>
    800024f0:	3f8030ef          	jal	800058e8 <release>
      return ip;
    800024f4:	8926                	mv	s2,s1
    800024f6:	a02d                	j	80002520 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024f8:	fbe9                	bnez	a5,800024ca <iget+0x38>
      empty = ip;
    800024fa:	8926                	mv	s2,s1
    800024fc:	b7f9                	j	800024ca <iget+0x38>
  if(empty == 0)
    800024fe:	02090a63          	beqz	s2,80002532 <iget+0xa0>
  ip->dev = dev;
    80002502:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002506:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000250a:	4785                	li	a5,1
    8000250c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002510:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002514:	00016517          	auipc	a0,0x16
    80002518:	49450513          	addi	a0,a0,1172 # 800189a8 <itable>
    8000251c:	3cc030ef          	jal	800058e8 <release>
}
    80002520:	854a                	mv	a0,s2
    80002522:	70a2                	ld	ra,40(sp)
    80002524:	7402                	ld	s0,32(sp)
    80002526:	64e2                	ld	s1,24(sp)
    80002528:	6942                	ld	s2,16(sp)
    8000252a:	69a2                	ld	s3,8(sp)
    8000252c:	6a02                	ld	s4,0(sp)
    8000252e:	6145                	addi	sp,sp,48
    80002530:	8082                	ret
    panic("iget: no inodes");
    80002532:	00005517          	auipc	a0,0x5
    80002536:	fe650513          	addi	a0,a0,-26 # 80007518 <etext+0x518>
    8000253a:	7e9020ef          	jal	80005522 <panic>

000000008000253e <fsinit>:
fsinit(int dev) {
    8000253e:	7179                	addi	sp,sp,-48
    80002540:	f406                	sd	ra,40(sp)
    80002542:	f022                	sd	s0,32(sp)
    80002544:	ec26                	sd	s1,24(sp)
    80002546:	e84a                	sd	s2,16(sp)
    80002548:	e44e                	sd	s3,8(sp)
    8000254a:	1800                	addi	s0,sp,48
    8000254c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000254e:	4585                	li	a1,1
    80002550:	aebff0ef          	jal	8000203a <bread>
    80002554:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002556:	00016997          	auipc	s3,0x16
    8000255a:	43298993          	addi	s3,s3,1074 # 80018988 <sb>
    8000255e:	02000613          	li	a2,32
    80002562:	05850593          	addi	a1,a0,88
    80002566:	854e                	mv	a0,s3
    80002568:	c85fd0ef          	jal	800001ec <memmove>
  brelse(bp);
    8000256c:	8526                	mv	a0,s1
    8000256e:	bd5ff0ef          	jal	80002142 <brelse>
  if(sb.magic != FSMAGIC)
    80002572:	0009a703          	lw	a4,0(s3)
    80002576:	102037b7          	lui	a5,0x10203
    8000257a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000257e:	02f71063          	bne	a4,a5,8000259e <fsinit+0x60>
  initlog(dev, &sb);
    80002582:	00016597          	auipc	a1,0x16
    80002586:	40658593          	addi	a1,a1,1030 # 80018988 <sb>
    8000258a:	854a                	mv	a0,s2
    8000258c:	1f9000ef          	jal	80002f84 <initlog>
}
    80002590:	70a2                	ld	ra,40(sp)
    80002592:	7402                	ld	s0,32(sp)
    80002594:	64e2                	ld	s1,24(sp)
    80002596:	6942                	ld	s2,16(sp)
    80002598:	69a2                	ld	s3,8(sp)
    8000259a:	6145                	addi	sp,sp,48
    8000259c:	8082                	ret
    panic("invalid file system");
    8000259e:	00005517          	auipc	a0,0x5
    800025a2:	f8a50513          	addi	a0,a0,-118 # 80007528 <etext+0x528>
    800025a6:	77d020ef          	jal	80005522 <panic>

00000000800025aa <iinit>:
{
    800025aa:	7179                	addi	sp,sp,-48
    800025ac:	f406                	sd	ra,40(sp)
    800025ae:	f022                	sd	s0,32(sp)
    800025b0:	ec26                	sd	s1,24(sp)
    800025b2:	e84a                	sd	s2,16(sp)
    800025b4:	e44e                	sd	s3,8(sp)
    800025b6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800025b8:	00005597          	auipc	a1,0x5
    800025bc:	f8858593          	addi	a1,a1,-120 # 80007540 <etext+0x540>
    800025c0:	00016517          	auipc	a0,0x16
    800025c4:	3e850513          	addi	a0,a0,1000 # 800189a8 <itable>
    800025c8:	208030ef          	jal	800057d0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800025cc:	00016497          	auipc	s1,0x16
    800025d0:	40448493          	addi	s1,s1,1028 # 800189d0 <itable+0x28>
    800025d4:	00018997          	auipc	s3,0x18
    800025d8:	e8c98993          	addi	s3,s3,-372 # 8001a460 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800025dc:	00005917          	auipc	s2,0x5
    800025e0:	f6c90913          	addi	s2,s2,-148 # 80007548 <etext+0x548>
    800025e4:	85ca                	mv	a1,s2
    800025e6:	8526                	mv	a0,s1
    800025e8:	475000ef          	jal	8000325c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800025ec:	08848493          	addi	s1,s1,136
    800025f0:	ff349ae3          	bne	s1,s3,800025e4 <iinit+0x3a>
}
    800025f4:	70a2                	ld	ra,40(sp)
    800025f6:	7402                	ld	s0,32(sp)
    800025f8:	64e2                	ld	s1,24(sp)
    800025fa:	6942                	ld	s2,16(sp)
    800025fc:	69a2                	ld	s3,8(sp)
    800025fe:	6145                	addi	sp,sp,48
    80002600:	8082                	ret

0000000080002602 <ialloc>:
{
    80002602:	7139                	addi	sp,sp,-64
    80002604:	fc06                	sd	ra,56(sp)
    80002606:	f822                	sd	s0,48(sp)
    80002608:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000260a:	00016717          	auipc	a4,0x16
    8000260e:	38a72703          	lw	a4,906(a4) # 80018994 <sb+0xc>
    80002612:	4785                	li	a5,1
    80002614:	06e7f063          	bgeu	a5,a4,80002674 <ialloc+0x72>
    80002618:	f426                	sd	s1,40(sp)
    8000261a:	f04a                	sd	s2,32(sp)
    8000261c:	ec4e                	sd	s3,24(sp)
    8000261e:	e852                	sd	s4,16(sp)
    80002620:	e456                	sd	s5,8(sp)
    80002622:	e05a                	sd	s6,0(sp)
    80002624:	8aaa                	mv	s5,a0
    80002626:	8b2e                	mv	s6,a1
    80002628:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000262a:	00016a17          	auipc	s4,0x16
    8000262e:	35ea0a13          	addi	s4,s4,862 # 80018988 <sb>
    80002632:	00495593          	srli	a1,s2,0x4
    80002636:	018a2783          	lw	a5,24(s4)
    8000263a:	9dbd                	addw	a1,a1,a5
    8000263c:	8556                	mv	a0,s5
    8000263e:	9fdff0ef          	jal	8000203a <bread>
    80002642:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002644:	05850993          	addi	s3,a0,88
    80002648:	00f97793          	andi	a5,s2,15
    8000264c:	079a                	slli	a5,a5,0x6
    8000264e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002650:	00099783          	lh	a5,0(s3)
    80002654:	cb9d                	beqz	a5,8000268a <ialloc+0x88>
    brelse(bp);
    80002656:	aedff0ef          	jal	80002142 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000265a:	0905                	addi	s2,s2,1
    8000265c:	00ca2703          	lw	a4,12(s4)
    80002660:	0009079b          	sext.w	a5,s2
    80002664:	fce7e7e3          	bltu	a5,a4,80002632 <ialloc+0x30>
    80002668:	74a2                	ld	s1,40(sp)
    8000266a:	7902                	ld	s2,32(sp)
    8000266c:	69e2                	ld	s3,24(sp)
    8000266e:	6a42                	ld	s4,16(sp)
    80002670:	6aa2                	ld	s5,8(sp)
    80002672:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002674:	00005517          	auipc	a0,0x5
    80002678:	edc50513          	addi	a0,a0,-292 # 80007550 <etext+0x550>
    8000267c:	3d5020ef          	jal	80005250 <printf>
  return 0;
    80002680:	4501                	li	a0,0
}
    80002682:	70e2                	ld	ra,56(sp)
    80002684:	7442                	ld	s0,48(sp)
    80002686:	6121                	addi	sp,sp,64
    80002688:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000268a:	04000613          	li	a2,64
    8000268e:	4581                	li	a1,0
    80002690:	854e                	mv	a0,s3
    80002692:	afffd0ef          	jal	80000190 <memset>
      dip->type = type;
    80002696:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000269a:	8526                	mv	a0,s1
    8000269c:	2f1000ef          	jal	8000318c <log_write>
      brelse(bp);
    800026a0:	8526                	mv	a0,s1
    800026a2:	aa1ff0ef          	jal	80002142 <brelse>
      return iget(dev, inum);
    800026a6:	0009059b          	sext.w	a1,s2
    800026aa:	8556                	mv	a0,s5
    800026ac:	de7ff0ef          	jal	80002492 <iget>
    800026b0:	74a2                	ld	s1,40(sp)
    800026b2:	7902                	ld	s2,32(sp)
    800026b4:	69e2                	ld	s3,24(sp)
    800026b6:	6a42                	ld	s4,16(sp)
    800026b8:	6aa2                	ld	s5,8(sp)
    800026ba:	6b02                	ld	s6,0(sp)
    800026bc:	b7d9                	j	80002682 <ialloc+0x80>

00000000800026be <iupdate>:
{
    800026be:	1101                	addi	sp,sp,-32
    800026c0:	ec06                	sd	ra,24(sp)
    800026c2:	e822                	sd	s0,16(sp)
    800026c4:	e426                	sd	s1,8(sp)
    800026c6:	e04a                	sd	s2,0(sp)
    800026c8:	1000                	addi	s0,sp,32
    800026ca:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026cc:	415c                	lw	a5,4(a0)
    800026ce:	0047d79b          	srliw	a5,a5,0x4
    800026d2:	00016597          	auipc	a1,0x16
    800026d6:	2ce5a583          	lw	a1,718(a1) # 800189a0 <sb+0x18>
    800026da:	9dbd                	addw	a1,a1,a5
    800026dc:	4108                	lw	a0,0(a0)
    800026de:	95dff0ef          	jal	8000203a <bread>
    800026e2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026e4:	05850793          	addi	a5,a0,88
    800026e8:	40d8                	lw	a4,4(s1)
    800026ea:	8b3d                	andi	a4,a4,15
    800026ec:	071a                	slli	a4,a4,0x6
    800026ee:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800026f0:	04449703          	lh	a4,68(s1)
    800026f4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800026f8:	04649703          	lh	a4,70(s1)
    800026fc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002700:	04849703          	lh	a4,72(s1)
    80002704:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002708:	04a49703          	lh	a4,74(s1)
    8000270c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002710:	44f8                	lw	a4,76(s1)
    80002712:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002714:	03400613          	li	a2,52
    80002718:	05048593          	addi	a1,s1,80
    8000271c:	00c78513          	addi	a0,a5,12
    80002720:	acdfd0ef          	jal	800001ec <memmove>
  log_write(bp);
    80002724:	854a                	mv	a0,s2
    80002726:	267000ef          	jal	8000318c <log_write>
  brelse(bp);
    8000272a:	854a                	mv	a0,s2
    8000272c:	a17ff0ef          	jal	80002142 <brelse>
}
    80002730:	60e2                	ld	ra,24(sp)
    80002732:	6442                	ld	s0,16(sp)
    80002734:	64a2                	ld	s1,8(sp)
    80002736:	6902                	ld	s2,0(sp)
    80002738:	6105                	addi	sp,sp,32
    8000273a:	8082                	ret

000000008000273c <idup>:
{
    8000273c:	1101                	addi	sp,sp,-32
    8000273e:	ec06                	sd	ra,24(sp)
    80002740:	e822                	sd	s0,16(sp)
    80002742:	e426                	sd	s1,8(sp)
    80002744:	1000                	addi	s0,sp,32
    80002746:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002748:	00016517          	auipc	a0,0x16
    8000274c:	26050513          	addi	a0,a0,608 # 800189a8 <itable>
    80002750:	100030ef          	jal	80005850 <acquire>
  ip->ref++;
    80002754:	449c                	lw	a5,8(s1)
    80002756:	2785                	addiw	a5,a5,1
    80002758:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000275a:	00016517          	auipc	a0,0x16
    8000275e:	24e50513          	addi	a0,a0,590 # 800189a8 <itable>
    80002762:	186030ef          	jal	800058e8 <release>
}
    80002766:	8526                	mv	a0,s1
    80002768:	60e2                	ld	ra,24(sp)
    8000276a:	6442                	ld	s0,16(sp)
    8000276c:	64a2                	ld	s1,8(sp)
    8000276e:	6105                	addi	sp,sp,32
    80002770:	8082                	ret

0000000080002772 <ilock>:
{
    80002772:	1101                	addi	sp,sp,-32
    80002774:	ec06                	sd	ra,24(sp)
    80002776:	e822                	sd	s0,16(sp)
    80002778:	e426                	sd	s1,8(sp)
    8000277a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000277c:	cd19                	beqz	a0,8000279a <ilock+0x28>
    8000277e:	84aa                	mv	s1,a0
    80002780:	451c                	lw	a5,8(a0)
    80002782:	00f05c63          	blez	a5,8000279a <ilock+0x28>
  acquiresleep(&ip->lock);
    80002786:	0541                	addi	a0,a0,16
    80002788:	30b000ef          	jal	80003292 <acquiresleep>
  if(ip->valid == 0){
    8000278c:	40bc                	lw	a5,64(s1)
    8000278e:	cf89                	beqz	a5,800027a8 <ilock+0x36>
}
    80002790:	60e2                	ld	ra,24(sp)
    80002792:	6442                	ld	s0,16(sp)
    80002794:	64a2                	ld	s1,8(sp)
    80002796:	6105                	addi	sp,sp,32
    80002798:	8082                	ret
    8000279a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000279c:	00005517          	auipc	a0,0x5
    800027a0:	dcc50513          	addi	a0,a0,-564 # 80007568 <etext+0x568>
    800027a4:	57f020ef          	jal	80005522 <panic>
    800027a8:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800027aa:	40dc                	lw	a5,4(s1)
    800027ac:	0047d79b          	srliw	a5,a5,0x4
    800027b0:	00016597          	auipc	a1,0x16
    800027b4:	1f05a583          	lw	a1,496(a1) # 800189a0 <sb+0x18>
    800027b8:	9dbd                	addw	a1,a1,a5
    800027ba:	4088                	lw	a0,0(s1)
    800027bc:	87fff0ef          	jal	8000203a <bread>
    800027c0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027c2:	05850593          	addi	a1,a0,88
    800027c6:	40dc                	lw	a5,4(s1)
    800027c8:	8bbd                	andi	a5,a5,15
    800027ca:	079a                	slli	a5,a5,0x6
    800027cc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027ce:	00059783          	lh	a5,0(a1)
    800027d2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027d6:	00259783          	lh	a5,2(a1)
    800027da:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800027de:	00459783          	lh	a5,4(a1)
    800027e2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800027e6:	00659783          	lh	a5,6(a1)
    800027ea:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027ee:	459c                	lw	a5,8(a1)
    800027f0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800027f2:	03400613          	li	a2,52
    800027f6:	05b1                	addi	a1,a1,12
    800027f8:	05048513          	addi	a0,s1,80
    800027fc:	9f1fd0ef          	jal	800001ec <memmove>
    brelse(bp);
    80002800:	854a                	mv	a0,s2
    80002802:	941ff0ef          	jal	80002142 <brelse>
    ip->valid = 1;
    80002806:	4785                	li	a5,1
    80002808:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000280a:	04449783          	lh	a5,68(s1)
    8000280e:	c399                	beqz	a5,80002814 <ilock+0xa2>
    80002810:	6902                	ld	s2,0(sp)
    80002812:	bfbd                	j	80002790 <ilock+0x1e>
      panic("ilock: no type");
    80002814:	00005517          	auipc	a0,0x5
    80002818:	d5c50513          	addi	a0,a0,-676 # 80007570 <etext+0x570>
    8000281c:	507020ef          	jal	80005522 <panic>

0000000080002820 <iunlock>:
{
    80002820:	1101                	addi	sp,sp,-32
    80002822:	ec06                	sd	ra,24(sp)
    80002824:	e822                	sd	s0,16(sp)
    80002826:	e426                	sd	s1,8(sp)
    80002828:	e04a                	sd	s2,0(sp)
    8000282a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000282c:	c505                	beqz	a0,80002854 <iunlock+0x34>
    8000282e:	84aa                	mv	s1,a0
    80002830:	01050913          	addi	s2,a0,16
    80002834:	854a                	mv	a0,s2
    80002836:	2db000ef          	jal	80003310 <holdingsleep>
    8000283a:	cd09                	beqz	a0,80002854 <iunlock+0x34>
    8000283c:	449c                	lw	a5,8(s1)
    8000283e:	00f05b63          	blez	a5,80002854 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002842:	854a                	mv	a0,s2
    80002844:	295000ef          	jal	800032d8 <releasesleep>
}
    80002848:	60e2                	ld	ra,24(sp)
    8000284a:	6442                	ld	s0,16(sp)
    8000284c:	64a2                	ld	s1,8(sp)
    8000284e:	6902                	ld	s2,0(sp)
    80002850:	6105                	addi	sp,sp,32
    80002852:	8082                	ret
    panic("iunlock");
    80002854:	00005517          	auipc	a0,0x5
    80002858:	d2c50513          	addi	a0,a0,-724 # 80007580 <etext+0x580>
    8000285c:	4c7020ef          	jal	80005522 <panic>

0000000080002860 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002860:	7179                	addi	sp,sp,-48
    80002862:	f406                	sd	ra,40(sp)
    80002864:	f022                	sd	s0,32(sp)
    80002866:	ec26                	sd	s1,24(sp)
    80002868:	e84a                	sd	s2,16(sp)
    8000286a:	e44e                	sd	s3,8(sp)
    8000286c:	1800                	addi	s0,sp,48
    8000286e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002870:	05050493          	addi	s1,a0,80
    80002874:	08050913          	addi	s2,a0,128
    80002878:	a021                	j	80002880 <itrunc+0x20>
    8000287a:	0491                	addi	s1,s1,4
    8000287c:	01248b63          	beq	s1,s2,80002892 <itrunc+0x32>
    if(ip->addrs[i]){
    80002880:	408c                	lw	a1,0(s1)
    80002882:	dde5                	beqz	a1,8000287a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002884:	0009a503          	lw	a0,0(s3)
    80002888:	9abff0ef          	jal	80002232 <bfree>
      ip->addrs[i] = 0;
    8000288c:	0004a023          	sw	zero,0(s1)
    80002890:	b7ed                	j	8000287a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002892:	0809a583          	lw	a1,128(s3)
    80002896:	ed89                	bnez	a1,800028b0 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002898:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000289c:	854e                	mv	a0,s3
    8000289e:	e21ff0ef          	jal	800026be <iupdate>
}
    800028a2:	70a2                	ld	ra,40(sp)
    800028a4:	7402                	ld	s0,32(sp)
    800028a6:	64e2                	ld	s1,24(sp)
    800028a8:	6942                	ld	s2,16(sp)
    800028aa:	69a2                	ld	s3,8(sp)
    800028ac:	6145                	addi	sp,sp,48
    800028ae:	8082                	ret
    800028b0:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800028b2:	0009a503          	lw	a0,0(s3)
    800028b6:	f84ff0ef          	jal	8000203a <bread>
    800028ba:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800028bc:	05850493          	addi	s1,a0,88
    800028c0:	45850913          	addi	s2,a0,1112
    800028c4:	a021                	j	800028cc <itrunc+0x6c>
    800028c6:	0491                	addi	s1,s1,4
    800028c8:	01248963          	beq	s1,s2,800028da <itrunc+0x7a>
      if(a[j])
    800028cc:	408c                	lw	a1,0(s1)
    800028ce:	dde5                	beqz	a1,800028c6 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800028d0:	0009a503          	lw	a0,0(s3)
    800028d4:	95fff0ef          	jal	80002232 <bfree>
    800028d8:	b7fd                	j	800028c6 <itrunc+0x66>
    brelse(bp);
    800028da:	8552                	mv	a0,s4
    800028dc:	867ff0ef          	jal	80002142 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800028e0:	0809a583          	lw	a1,128(s3)
    800028e4:	0009a503          	lw	a0,0(s3)
    800028e8:	94bff0ef          	jal	80002232 <bfree>
    ip->addrs[NDIRECT] = 0;
    800028ec:	0809a023          	sw	zero,128(s3)
    800028f0:	6a02                	ld	s4,0(sp)
    800028f2:	b75d                	j	80002898 <itrunc+0x38>

00000000800028f4 <iput>:
{
    800028f4:	1101                	addi	sp,sp,-32
    800028f6:	ec06                	sd	ra,24(sp)
    800028f8:	e822                	sd	s0,16(sp)
    800028fa:	e426                	sd	s1,8(sp)
    800028fc:	1000                	addi	s0,sp,32
    800028fe:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002900:	00016517          	auipc	a0,0x16
    80002904:	0a850513          	addi	a0,a0,168 # 800189a8 <itable>
    80002908:	749020ef          	jal	80005850 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000290c:	4498                	lw	a4,8(s1)
    8000290e:	4785                	li	a5,1
    80002910:	02f70063          	beq	a4,a5,80002930 <iput+0x3c>
  ip->ref--;
    80002914:	449c                	lw	a5,8(s1)
    80002916:	37fd                	addiw	a5,a5,-1
    80002918:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000291a:	00016517          	auipc	a0,0x16
    8000291e:	08e50513          	addi	a0,a0,142 # 800189a8 <itable>
    80002922:	7c7020ef          	jal	800058e8 <release>
}
    80002926:	60e2                	ld	ra,24(sp)
    80002928:	6442                	ld	s0,16(sp)
    8000292a:	64a2                	ld	s1,8(sp)
    8000292c:	6105                	addi	sp,sp,32
    8000292e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002930:	40bc                	lw	a5,64(s1)
    80002932:	d3ed                	beqz	a5,80002914 <iput+0x20>
    80002934:	04a49783          	lh	a5,74(s1)
    80002938:	fff1                	bnez	a5,80002914 <iput+0x20>
    8000293a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000293c:	01048913          	addi	s2,s1,16
    80002940:	854a                	mv	a0,s2
    80002942:	151000ef          	jal	80003292 <acquiresleep>
    release(&itable.lock);
    80002946:	00016517          	auipc	a0,0x16
    8000294a:	06250513          	addi	a0,a0,98 # 800189a8 <itable>
    8000294e:	79b020ef          	jal	800058e8 <release>
    itrunc(ip);
    80002952:	8526                	mv	a0,s1
    80002954:	f0dff0ef          	jal	80002860 <itrunc>
    ip->type = 0;
    80002958:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000295c:	8526                	mv	a0,s1
    8000295e:	d61ff0ef          	jal	800026be <iupdate>
    ip->valid = 0;
    80002962:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002966:	854a                	mv	a0,s2
    80002968:	171000ef          	jal	800032d8 <releasesleep>
    acquire(&itable.lock);
    8000296c:	00016517          	auipc	a0,0x16
    80002970:	03c50513          	addi	a0,a0,60 # 800189a8 <itable>
    80002974:	6dd020ef          	jal	80005850 <acquire>
    80002978:	6902                	ld	s2,0(sp)
    8000297a:	bf69                	j	80002914 <iput+0x20>

000000008000297c <iunlockput>:
{
    8000297c:	1101                	addi	sp,sp,-32
    8000297e:	ec06                	sd	ra,24(sp)
    80002980:	e822                	sd	s0,16(sp)
    80002982:	e426                	sd	s1,8(sp)
    80002984:	1000                	addi	s0,sp,32
    80002986:	84aa                	mv	s1,a0
  iunlock(ip);
    80002988:	e99ff0ef          	jal	80002820 <iunlock>
  iput(ip);
    8000298c:	8526                	mv	a0,s1
    8000298e:	f67ff0ef          	jal	800028f4 <iput>
}
    80002992:	60e2                	ld	ra,24(sp)
    80002994:	6442                	ld	s0,16(sp)
    80002996:	64a2                	ld	s1,8(sp)
    80002998:	6105                	addi	sp,sp,32
    8000299a:	8082                	ret

000000008000299c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000299c:	1141                	addi	sp,sp,-16
    8000299e:	e422                	sd	s0,8(sp)
    800029a0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800029a2:	411c                	lw	a5,0(a0)
    800029a4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800029a6:	415c                	lw	a5,4(a0)
    800029a8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800029aa:	04451783          	lh	a5,68(a0)
    800029ae:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800029b2:	04a51783          	lh	a5,74(a0)
    800029b6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800029ba:	04c56783          	lwu	a5,76(a0)
    800029be:	e99c                	sd	a5,16(a1)
}
    800029c0:	6422                	ld	s0,8(sp)
    800029c2:	0141                	addi	sp,sp,16
    800029c4:	8082                	ret

00000000800029c6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029c6:	457c                	lw	a5,76(a0)
    800029c8:	0ed7eb63          	bltu	a5,a3,80002abe <readi+0xf8>
{
    800029cc:	7159                	addi	sp,sp,-112
    800029ce:	f486                	sd	ra,104(sp)
    800029d0:	f0a2                	sd	s0,96(sp)
    800029d2:	eca6                	sd	s1,88(sp)
    800029d4:	e0d2                	sd	s4,64(sp)
    800029d6:	fc56                	sd	s5,56(sp)
    800029d8:	f85a                	sd	s6,48(sp)
    800029da:	f45e                	sd	s7,40(sp)
    800029dc:	1880                	addi	s0,sp,112
    800029de:	8b2a                	mv	s6,a0
    800029e0:	8bae                	mv	s7,a1
    800029e2:	8a32                	mv	s4,a2
    800029e4:	84b6                	mv	s1,a3
    800029e6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800029e8:	9f35                	addw	a4,a4,a3
    return 0;
    800029ea:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800029ec:	0cd76063          	bltu	a4,a3,80002aac <readi+0xe6>
    800029f0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800029f2:	00e7f463          	bgeu	a5,a4,800029fa <readi+0x34>
    n = ip->size - off;
    800029f6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029fa:	080a8f63          	beqz	s5,80002a98 <readi+0xd2>
    800029fe:	e8ca                	sd	s2,80(sp)
    80002a00:	f062                	sd	s8,32(sp)
    80002a02:	ec66                	sd	s9,24(sp)
    80002a04:	e86a                	sd	s10,16(sp)
    80002a06:	e46e                	sd	s11,8(sp)
    80002a08:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a0a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a0e:	5c7d                	li	s8,-1
    80002a10:	a80d                	j	80002a42 <readi+0x7c>
    80002a12:	020d1d93          	slli	s11,s10,0x20
    80002a16:	020ddd93          	srli	s11,s11,0x20
    80002a1a:	05890613          	addi	a2,s2,88
    80002a1e:	86ee                	mv	a3,s11
    80002a20:	963a                	add	a2,a2,a4
    80002a22:	85d2                	mv	a1,s4
    80002a24:	855e                	mv	a0,s7
    80002a26:	cb5fe0ef          	jal	800016da <either_copyout>
    80002a2a:	05850763          	beq	a0,s8,80002a78 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a2e:	854a                	mv	a0,s2
    80002a30:	f12ff0ef          	jal	80002142 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a34:	013d09bb          	addw	s3,s10,s3
    80002a38:	009d04bb          	addw	s1,s10,s1
    80002a3c:	9a6e                	add	s4,s4,s11
    80002a3e:	0559f763          	bgeu	s3,s5,80002a8c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002a42:	00a4d59b          	srliw	a1,s1,0xa
    80002a46:	855a                	mv	a0,s6
    80002a48:	977ff0ef          	jal	800023be <bmap>
    80002a4c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a50:	c5b1                	beqz	a1,80002a9c <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002a52:	000b2503          	lw	a0,0(s6)
    80002a56:	de4ff0ef          	jal	8000203a <bread>
    80002a5a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a5c:	3ff4f713          	andi	a4,s1,1023
    80002a60:	40ec87bb          	subw	a5,s9,a4
    80002a64:	413a86bb          	subw	a3,s5,s3
    80002a68:	8d3e                	mv	s10,a5
    80002a6a:	2781                	sext.w	a5,a5
    80002a6c:	0006861b          	sext.w	a2,a3
    80002a70:	faf671e3          	bgeu	a2,a5,80002a12 <readi+0x4c>
    80002a74:	8d36                	mv	s10,a3
    80002a76:	bf71                	j	80002a12 <readi+0x4c>
      brelse(bp);
    80002a78:	854a                	mv	a0,s2
    80002a7a:	ec8ff0ef          	jal	80002142 <brelse>
      tot = -1;
    80002a7e:	59fd                	li	s3,-1
      break;
    80002a80:	6946                	ld	s2,80(sp)
    80002a82:	7c02                	ld	s8,32(sp)
    80002a84:	6ce2                	ld	s9,24(sp)
    80002a86:	6d42                	ld	s10,16(sp)
    80002a88:	6da2                	ld	s11,8(sp)
    80002a8a:	a831                	j	80002aa6 <readi+0xe0>
    80002a8c:	6946                	ld	s2,80(sp)
    80002a8e:	7c02                	ld	s8,32(sp)
    80002a90:	6ce2                	ld	s9,24(sp)
    80002a92:	6d42                	ld	s10,16(sp)
    80002a94:	6da2                	ld	s11,8(sp)
    80002a96:	a801                	j	80002aa6 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a98:	89d6                	mv	s3,s5
    80002a9a:	a031                	j	80002aa6 <readi+0xe0>
    80002a9c:	6946                	ld	s2,80(sp)
    80002a9e:	7c02                	ld	s8,32(sp)
    80002aa0:	6ce2                	ld	s9,24(sp)
    80002aa2:	6d42                	ld	s10,16(sp)
    80002aa4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002aa6:	0009851b          	sext.w	a0,s3
    80002aaa:	69a6                	ld	s3,72(sp)
}
    80002aac:	70a6                	ld	ra,104(sp)
    80002aae:	7406                	ld	s0,96(sp)
    80002ab0:	64e6                	ld	s1,88(sp)
    80002ab2:	6a06                	ld	s4,64(sp)
    80002ab4:	7ae2                	ld	s5,56(sp)
    80002ab6:	7b42                	ld	s6,48(sp)
    80002ab8:	7ba2                	ld	s7,40(sp)
    80002aba:	6165                	addi	sp,sp,112
    80002abc:	8082                	ret
    return 0;
    80002abe:	4501                	li	a0,0
}
    80002ac0:	8082                	ret

0000000080002ac2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ac2:	457c                	lw	a5,76(a0)
    80002ac4:	10d7e063          	bltu	a5,a3,80002bc4 <writei+0x102>
{
    80002ac8:	7159                	addi	sp,sp,-112
    80002aca:	f486                	sd	ra,104(sp)
    80002acc:	f0a2                	sd	s0,96(sp)
    80002ace:	e8ca                	sd	s2,80(sp)
    80002ad0:	e0d2                	sd	s4,64(sp)
    80002ad2:	fc56                	sd	s5,56(sp)
    80002ad4:	f85a                	sd	s6,48(sp)
    80002ad6:	f45e                	sd	s7,40(sp)
    80002ad8:	1880                	addi	s0,sp,112
    80002ada:	8aaa                	mv	s5,a0
    80002adc:	8bae                	mv	s7,a1
    80002ade:	8a32                	mv	s4,a2
    80002ae0:	8936                	mv	s2,a3
    80002ae2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ae4:	00e687bb          	addw	a5,a3,a4
    80002ae8:	0ed7e063          	bltu	a5,a3,80002bc8 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002aec:	00043737          	lui	a4,0x43
    80002af0:	0cf76e63          	bltu	a4,a5,80002bcc <writei+0x10a>
    80002af4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002af6:	0a0b0f63          	beqz	s6,80002bb4 <writei+0xf2>
    80002afa:	eca6                	sd	s1,88(sp)
    80002afc:	f062                	sd	s8,32(sp)
    80002afe:	ec66                	sd	s9,24(sp)
    80002b00:	e86a                	sd	s10,16(sp)
    80002b02:	e46e                	sd	s11,8(sp)
    80002b04:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b06:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b0a:	5c7d                	li	s8,-1
    80002b0c:	a825                	j	80002b44 <writei+0x82>
    80002b0e:	020d1d93          	slli	s11,s10,0x20
    80002b12:	020ddd93          	srli	s11,s11,0x20
    80002b16:	05848513          	addi	a0,s1,88
    80002b1a:	86ee                	mv	a3,s11
    80002b1c:	8652                	mv	a2,s4
    80002b1e:	85de                	mv	a1,s7
    80002b20:	953a                	add	a0,a0,a4
    80002b22:	c03fe0ef          	jal	80001724 <either_copyin>
    80002b26:	05850a63          	beq	a0,s8,80002b7a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b2a:	8526                	mv	a0,s1
    80002b2c:	660000ef          	jal	8000318c <log_write>
    brelse(bp);
    80002b30:	8526                	mv	a0,s1
    80002b32:	e10ff0ef          	jal	80002142 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b36:	013d09bb          	addw	s3,s10,s3
    80002b3a:	012d093b          	addw	s2,s10,s2
    80002b3e:	9a6e                	add	s4,s4,s11
    80002b40:	0569f063          	bgeu	s3,s6,80002b80 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b44:	00a9559b          	srliw	a1,s2,0xa
    80002b48:	8556                	mv	a0,s5
    80002b4a:	875ff0ef          	jal	800023be <bmap>
    80002b4e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b52:	c59d                	beqz	a1,80002b80 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002b54:	000aa503          	lw	a0,0(s5)
    80002b58:	ce2ff0ef          	jal	8000203a <bread>
    80002b5c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b5e:	3ff97713          	andi	a4,s2,1023
    80002b62:	40ec87bb          	subw	a5,s9,a4
    80002b66:	413b06bb          	subw	a3,s6,s3
    80002b6a:	8d3e                	mv	s10,a5
    80002b6c:	2781                	sext.w	a5,a5
    80002b6e:	0006861b          	sext.w	a2,a3
    80002b72:	f8f67ee3          	bgeu	a2,a5,80002b0e <writei+0x4c>
    80002b76:	8d36                	mv	s10,a3
    80002b78:	bf59                	j	80002b0e <writei+0x4c>
      brelse(bp);
    80002b7a:	8526                	mv	a0,s1
    80002b7c:	dc6ff0ef          	jal	80002142 <brelse>
  }

  if(off > ip->size)
    80002b80:	04caa783          	lw	a5,76(s5)
    80002b84:	0327fa63          	bgeu	a5,s2,80002bb8 <writei+0xf6>
    ip->size = off;
    80002b88:	052aa623          	sw	s2,76(s5)
    80002b8c:	64e6                	ld	s1,88(sp)
    80002b8e:	7c02                	ld	s8,32(sp)
    80002b90:	6ce2                	ld	s9,24(sp)
    80002b92:	6d42                	ld	s10,16(sp)
    80002b94:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b96:	8556                	mv	a0,s5
    80002b98:	b27ff0ef          	jal	800026be <iupdate>

  return tot;
    80002b9c:	0009851b          	sext.w	a0,s3
    80002ba0:	69a6                	ld	s3,72(sp)
}
    80002ba2:	70a6                	ld	ra,104(sp)
    80002ba4:	7406                	ld	s0,96(sp)
    80002ba6:	6946                	ld	s2,80(sp)
    80002ba8:	6a06                	ld	s4,64(sp)
    80002baa:	7ae2                	ld	s5,56(sp)
    80002bac:	7b42                	ld	s6,48(sp)
    80002bae:	7ba2                	ld	s7,40(sp)
    80002bb0:	6165                	addi	sp,sp,112
    80002bb2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bb4:	89da                	mv	s3,s6
    80002bb6:	b7c5                	j	80002b96 <writei+0xd4>
    80002bb8:	64e6                	ld	s1,88(sp)
    80002bba:	7c02                	ld	s8,32(sp)
    80002bbc:	6ce2                	ld	s9,24(sp)
    80002bbe:	6d42                	ld	s10,16(sp)
    80002bc0:	6da2                	ld	s11,8(sp)
    80002bc2:	bfd1                	j	80002b96 <writei+0xd4>
    return -1;
    80002bc4:	557d                	li	a0,-1
}
    80002bc6:	8082                	ret
    return -1;
    80002bc8:	557d                	li	a0,-1
    80002bca:	bfe1                	j	80002ba2 <writei+0xe0>
    return -1;
    80002bcc:	557d                	li	a0,-1
    80002bce:	bfd1                	j	80002ba2 <writei+0xe0>

0000000080002bd0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002bd0:	1141                	addi	sp,sp,-16
    80002bd2:	e406                	sd	ra,8(sp)
    80002bd4:	e022                	sd	s0,0(sp)
    80002bd6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002bd8:	4639                	li	a2,14
    80002bda:	e82fd0ef          	jal	8000025c <strncmp>
}
    80002bde:	60a2                	ld	ra,8(sp)
    80002be0:	6402                	ld	s0,0(sp)
    80002be2:	0141                	addi	sp,sp,16
    80002be4:	8082                	ret

0000000080002be6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002be6:	7139                	addi	sp,sp,-64
    80002be8:	fc06                	sd	ra,56(sp)
    80002bea:	f822                	sd	s0,48(sp)
    80002bec:	f426                	sd	s1,40(sp)
    80002bee:	f04a                	sd	s2,32(sp)
    80002bf0:	ec4e                	sd	s3,24(sp)
    80002bf2:	e852                	sd	s4,16(sp)
    80002bf4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002bf6:	04451703          	lh	a4,68(a0)
    80002bfa:	4785                	li	a5,1
    80002bfc:	00f71a63          	bne	a4,a5,80002c10 <dirlookup+0x2a>
    80002c00:	892a                	mv	s2,a0
    80002c02:	89ae                	mv	s3,a1
    80002c04:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c06:	457c                	lw	a5,76(a0)
    80002c08:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c0a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c0c:	e39d                	bnez	a5,80002c32 <dirlookup+0x4c>
    80002c0e:	a095                	j	80002c72 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c10:	00005517          	auipc	a0,0x5
    80002c14:	97850513          	addi	a0,a0,-1672 # 80007588 <etext+0x588>
    80002c18:	10b020ef          	jal	80005522 <panic>
      panic("dirlookup read");
    80002c1c:	00005517          	auipc	a0,0x5
    80002c20:	98450513          	addi	a0,a0,-1660 # 800075a0 <etext+0x5a0>
    80002c24:	0ff020ef          	jal	80005522 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c28:	24c1                	addiw	s1,s1,16
    80002c2a:	04c92783          	lw	a5,76(s2)
    80002c2e:	04f4f163          	bgeu	s1,a5,80002c70 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c32:	4741                	li	a4,16
    80002c34:	86a6                	mv	a3,s1
    80002c36:	fc040613          	addi	a2,s0,-64
    80002c3a:	4581                	li	a1,0
    80002c3c:	854a                	mv	a0,s2
    80002c3e:	d89ff0ef          	jal	800029c6 <readi>
    80002c42:	47c1                	li	a5,16
    80002c44:	fcf51ce3          	bne	a0,a5,80002c1c <dirlookup+0x36>
    if(de.inum == 0)
    80002c48:	fc045783          	lhu	a5,-64(s0)
    80002c4c:	dff1                	beqz	a5,80002c28 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002c4e:	fc240593          	addi	a1,s0,-62
    80002c52:	854e                	mv	a0,s3
    80002c54:	f7dff0ef          	jal	80002bd0 <namecmp>
    80002c58:	f961                	bnez	a0,80002c28 <dirlookup+0x42>
      if(poff)
    80002c5a:	000a0463          	beqz	s4,80002c62 <dirlookup+0x7c>
        *poff = off;
    80002c5e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002c62:	fc045583          	lhu	a1,-64(s0)
    80002c66:	00092503          	lw	a0,0(s2)
    80002c6a:	829ff0ef          	jal	80002492 <iget>
    80002c6e:	a011                	j	80002c72 <dirlookup+0x8c>
  return 0;
    80002c70:	4501                	li	a0,0
}
    80002c72:	70e2                	ld	ra,56(sp)
    80002c74:	7442                	ld	s0,48(sp)
    80002c76:	74a2                	ld	s1,40(sp)
    80002c78:	7902                	ld	s2,32(sp)
    80002c7a:	69e2                	ld	s3,24(sp)
    80002c7c:	6a42                	ld	s4,16(sp)
    80002c7e:	6121                	addi	sp,sp,64
    80002c80:	8082                	ret

0000000080002c82 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c82:	711d                	addi	sp,sp,-96
    80002c84:	ec86                	sd	ra,88(sp)
    80002c86:	e8a2                	sd	s0,80(sp)
    80002c88:	e4a6                	sd	s1,72(sp)
    80002c8a:	e0ca                	sd	s2,64(sp)
    80002c8c:	fc4e                	sd	s3,56(sp)
    80002c8e:	f852                	sd	s4,48(sp)
    80002c90:	f456                	sd	s5,40(sp)
    80002c92:	f05a                	sd	s6,32(sp)
    80002c94:	ec5e                	sd	s7,24(sp)
    80002c96:	e862                	sd	s8,16(sp)
    80002c98:	e466                	sd	s9,8(sp)
    80002c9a:	1080                	addi	s0,sp,96
    80002c9c:	84aa                	mv	s1,a0
    80002c9e:	8b2e                	mv	s6,a1
    80002ca0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002ca2:	00054703          	lbu	a4,0(a0)
    80002ca6:	02f00793          	li	a5,47
    80002caa:	00f70e63          	beq	a4,a5,80002cc6 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002cae:	8fafe0ef          	jal	80000da8 <myproc>
    80002cb2:	15053503          	ld	a0,336(a0)
    80002cb6:	a87ff0ef          	jal	8000273c <idup>
    80002cba:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002cbc:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002cc0:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002cc2:	4b85                	li	s7,1
    80002cc4:	a871                	j	80002d60 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002cc6:	4585                	li	a1,1
    80002cc8:	4505                	li	a0,1
    80002cca:	fc8ff0ef          	jal	80002492 <iget>
    80002cce:	8a2a                	mv	s4,a0
    80002cd0:	b7f5                	j	80002cbc <namex+0x3a>
      iunlockput(ip);
    80002cd2:	8552                	mv	a0,s4
    80002cd4:	ca9ff0ef          	jal	8000297c <iunlockput>
      return 0;
    80002cd8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002cda:	8552                	mv	a0,s4
    80002cdc:	60e6                	ld	ra,88(sp)
    80002cde:	6446                	ld	s0,80(sp)
    80002ce0:	64a6                	ld	s1,72(sp)
    80002ce2:	6906                	ld	s2,64(sp)
    80002ce4:	79e2                	ld	s3,56(sp)
    80002ce6:	7a42                	ld	s4,48(sp)
    80002ce8:	7aa2                	ld	s5,40(sp)
    80002cea:	7b02                	ld	s6,32(sp)
    80002cec:	6be2                	ld	s7,24(sp)
    80002cee:	6c42                	ld	s8,16(sp)
    80002cf0:	6ca2                	ld	s9,8(sp)
    80002cf2:	6125                	addi	sp,sp,96
    80002cf4:	8082                	ret
      iunlock(ip);
    80002cf6:	8552                	mv	a0,s4
    80002cf8:	b29ff0ef          	jal	80002820 <iunlock>
      return ip;
    80002cfc:	bff9                	j	80002cda <namex+0x58>
      iunlockput(ip);
    80002cfe:	8552                	mv	a0,s4
    80002d00:	c7dff0ef          	jal	8000297c <iunlockput>
      return 0;
    80002d04:	8a4e                	mv	s4,s3
    80002d06:	bfd1                	j	80002cda <namex+0x58>
  len = path - s;
    80002d08:	40998633          	sub	a2,s3,s1
    80002d0c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002d10:	099c5063          	bge	s8,s9,80002d90 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002d14:	4639                	li	a2,14
    80002d16:	85a6                	mv	a1,s1
    80002d18:	8556                	mv	a0,s5
    80002d1a:	cd2fd0ef          	jal	800001ec <memmove>
    80002d1e:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d20:	0004c783          	lbu	a5,0(s1)
    80002d24:	01279763          	bne	a5,s2,80002d32 <namex+0xb0>
    path++;
    80002d28:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d2a:	0004c783          	lbu	a5,0(s1)
    80002d2e:	ff278de3          	beq	a5,s2,80002d28 <namex+0xa6>
    ilock(ip);
    80002d32:	8552                	mv	a0,s4
    80002d34:	a3fff0ef          	jal	80002772 <ilock>
    if(ip->type != T_DIR){
    80002d38:	044a1783          	lh	a5,68(s4)
    80002d3c:	f9779be3          	bne	a5,s7,80002cd2 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002d40:	000b0563          	beqz	s6,80002d4a <namex+0xc8>
    80002d44:	0004c783          	lbu	a5,0(s1)
    80002d48:	d7dd                	beqz	a5,80002cf6 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d4a:	4601                	li	a2,0
    80002d4c:	85d6                	mv	a1,s5
    80002d4e:	8552                	mv	a0,s4
    80002d50:	e97ff0ef          	jal	80002be6 <dirlookup>
    80002d54:	89aa                	mv	s3,a0
    80002d56:	d545                	beqz	a0,80002cfe <namex+0x7c>
    iunlockput(ip);
    80002d58:	8552                	mv	a0,s4
    80002d5a:	c23ff0ef          	jal	8000297c <iunlockput>
    ip = next;
    80002d5e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d60:	0004c783          	lbu	a5,0(s1)
    80002d64:	01279763          	bne	a5,s2,80002d72 <namex+0xf0>
    path++;
    80002d68:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d6a:	0004c783          	lbu	a5,0(s1)
    80002d6e:	ff278de3          	beq	a5,s2,80002d68 <namex+0xe6>
  if(*path == 0)
    80002d72:	cb8d                	beqz	a5,80002da4 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002d74:	0004c783          	lbu	a5,0(s1)
    80002d78:	89a6                	mv	s3,s1
  len = path - s;
    80002d7a:	4c81                	li	s9,0
    80002d7c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002d7e:	01278963          	beq	a5,s2,80002d90 <namex+0x10e>
    80002d82:	d3d9                	beqz	a5,80002d08 <namex+0x86>
    path++;
    80002d84:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d86:	0009c783          	lbu	a5,0(s3)
    80002d8a:	ff279ce3          	bne	a5,s2,80002d82 <namex+0x100>
    80002d8e:	bfad                	j	80002d08 <namex+0x86>
    memmove(name, s, len);
    80002d90:	2601                	sext.w	a2,a2
    80002d92:	85a6                	mv	a1,s1
    80002d94:	8556                	mv	a0,s5
    80002d96:	c56fd0ef          	jal	800001ec <memmove>
    name[len] = 0;
    80002d9a:	9cd6                	add	s9,s9,s5
    80002d9c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002da0:	84ce                	mv	s1,s3
    80002da2:	bfbd                	j	80002d20 <namex+0x9e>
  if(nameiparent){
    80002da4:	f20b0be3          	beqz	s6,80002cda <namex+0x58>
    iput(ip);
    80002da8:	8552                	mv	a0,s4
    80002daa:	b4bff0ef          	jal	800028f4 <iput>
    return 0;
    80002dae:	4a01                	li	s4,0
    80002db0:	b72d                	j	80002cda <namex+0x58>

0000000080002db2 <dirlink>:
{
    80002db2:	7139                	addi	sp,sp,-64
    80002db4:	fc06                	sd	ra,56(sp)
    80002db6:	f822                	sd	s0,48(sp)
    80002db8:	f04a                	sd	s2,32(sp)
    80002dba:	ec4e                	sd	s3,24(sp)
    80002dbc:	e852                	sd	s4,16(sp)
    80002dbe:	0080                	addi	s0,sp,64
    80002dc0:	892a                	mv	s2,a0
    80002dc2:	8a2e                	mv	s4,a1
    80002dc4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002dc6:	4601                	li	a2,0
    80002dc8:	e1fff0ef          	jal	80002be6 <dirlookup>
    80002dcc:	e535                	bnez	a0,80002e38 <dirlink+0x86>
    80002dce:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dd0:	04c92483          	lw	s1,76(s2)
    80002dd4:	c48d                	beqz	s1,80002dfe <dirlink+0x4c>
    80002dd6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dd8:	4741                	li	a4,16
    80002dda:	86a6                	mv	a3,s1
    80002ddc:	fc040613          	addi	a2,s0,-64
    80002de0:	4581                	li	a1,0
    80002de2:	854a                	mv	a0,s2
    80002de4:	be3ff0ef          	jal	800029c6 <readi>
    80002de8:	47c1                	li	a5,16
    80002dea:	04f51b63          	bne	a0,a5,80002e40 <dirlink+0x8e>
    if(de.inum == 0)
    80002dee:	fc045783          	lhu	a5,-64(s0)
    80002df2:	c791                	beqz	a5,80002dfe <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002df4:	24c1                	addiw	s1,s1,16
    80002df6:	04c92783          	lw	a5,76(s2)
    80002dfa:	fcf4efe3          	bltu	s1,a5,80002dd8 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002dfe:	4639                	li	a2,14
    80002e00:	85d2                	mv	a1,s4
    80002e02:	fc240513          	addi	a0,s0,-62
    80002e06:	c8cfd0ef          	jal	80000292 <strncpy>
  de.inum = inum;
    80002e0a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e0e:	4741                	li	a4,16
    80002e10:	86a6                	mv	a3,s1
    80002e12:	fc040613          	addi	a2,s0,-64
    80002e16:	4581                	li	a1,0
    80002e18:	854a                	mv	a0,s2
    80002e1a:	ca9ff0ef          	jal	80002ac2 <writei>
    80002e1e:	1541                	addi	a0,a0,-16
    80002e20:	00a03533          	snez	a0,a0
    80002e24:	40a00533          	neg	a0,a0
    80002e28:	74a2                	ld	s1,40(sp)
}
    80002e2a:	70e2                	ld	ra,56(sp)
    80002e2c:	7442                	ld	s0,48(sp)
    80002e2e:	7902                	ld	s2,32(sp)
    80002e30:	69e2                	ld	s3,24(sp)
    80002e32:	6a42                	ld	s4,16(sp)
    80002e34:	6121                	addi	sp,sp,64
    80002e36:	8082                	ret
    iput(ip);
    80002e38:	abdff0ef          	jal	800028f4 <iput>
    return -1;
    80002e3c:	557d                	li	a0,-1
    80002e3e:	b7f5                	j	80002e2a <dirlink+0x78>
      panic("dirlink read");
    80002e40:	00004517          	auipc	a0,0x4
    80002e44:	77050513          	addi	a0,a0,1904 # 800075b0 <etext+0x5b0>
    80002e48:	6da020ef          	jal	80005522 <panic>

0000000080002e4c <namei>:

struct inode*
namei(char *path)
{
    80002e4c:	1101                	addi	sp,sp,-32
    80002e4e:	ec06                	sd	ra,24(sp)
    80002e50:	e822                	sd	s0,16(sp)
    80002e52:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e54:	fe040613          	addi	a2,s0,-32
    80002e58:	4581                	li	a1,0
    80002e5a:	e29ff0ef          	jal	80002c82 <namex>
}
    80002e5e:	60e2                	ld	ra,24(sp)
    80002e60:	6442                	ld	s0,16(sp)
    80002e62:	6105                	addi	sp,sp,32
    80002e64:	8082                	ret

0000000080002e66 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e66:	1141                	addi	sp,sp,-16
    80002e68:	e406                	sd	ra,8(sp)
    80002e6a:	e022                	sd	s0,0(sp)
    80002e6c:	0800                	addi	s0,sp,16
    80002e6e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e70:	4585                	li	a1,1
    80002e72:	e11ff0ef          	jal	80002c82 <namex>
}
    80002e76:	60a2                	ld	ra,8(sp)
    80002e78:	6402                	ld	s0,0(sp)
    80002e7a:	0141                	addi	sp,sp,16
    80002e7c:	8082                	ret

0000000080002e7e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e7e:	1101                	addi	sp,sp,-32
    80002e80:	ec06                	sd	ra,24(sp)
    80002e82:	e822                	sd	s0,16(sp)
    80002e84:	e426                	sd	s1,8(sp)
    80002e86:	e04a                	sd	s2,0(sp)
    80002e88:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e8a:	00017917          	auipc	s2,0x17
    80002e8e:	5c690913          	addi	s2,s2,1478 # 8001a450 <log>
    80002e92:	01892583          	lw	a1,24(s2)
    80002e96:	02892503          	lw	a0,40(s2)
    80002e9a:	9a0ff0ef          	jal	8000203a <bread>
    80002e9e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002ea0:	02c92603          	lw	a2,44(s2)
    80002ea4:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002ea6:	00c05f63          	blez	a2,80002ec4 <write_head+0x46>
    80002eaa:	00017717          	auipc	a4,0x17
    80002eae:	5d670713          	addi	a4,a4,1494 # 8001a480 <log+0x30>
    80002eb2:	87aa                	mv	a5,a0
    80002eb4:	060a                	slli	a2,a2,0x2
    80002eb6:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002eb8:	4314                	lw	a3,0(a4)
    80002eba:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002ebc:	0711                	addi	a4,a4,4
    80002ebe:	0791                	addi	a5,a5,4
    80002ec0:	fec79ce3          	bne	a5,a2,80002eb8 <write_head+0x3a>
  }
  bwrite(buf);
    80002ec4:	8526                	mv	a0,s1
    80002ec6:	a4aff0ef          	jal	80002110 <bwrite>
  brelse(buf);
    80002eca:	8526                	mv	a0,s1
    80002ecc:	a76ff0ef          	jal	80002142 <brelse>
}
    80002ed0:	60e2                	ld	ra,24(sp)
    80002ed2:	6442                	ld	s0,16(sp)
    80002ed4:	64a2                	ld	s1,8(sp)
    80002ed6:	6902                	ld	s2,0(sp)
    80002ed8:	6105                	addi	sp,sp,32
    80002eda:	8082                	ret

0000000080002edc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002edc:	00017797          	auipc	a5,0x17
    80002ee0:	5a07a783          	lw	a5,1440(a5) # 8001a47c <log+0x2c>
    80002ee4:	08f05f63          	blez	a5,80002f82 <install_trans+0xa6>
{
    80002ee8:	7139                	addi	sp,sp,-64
    80002eea:	fc06                	sd	ra,56(sp)
    80002eec:	f822                	sd	s0,48(sp)
    80002eee:	f426                	sd	s1,40(sp)
    80002ef0:	f04a                	sd	s2,32(sp)
    80002ef2:	ec4e                	sd	s3,24(sp)
    80002ef4:	e852                	sd	s4,16(sp)
    80002ef6:	e456                	sd	s5,8(sp)
    80002ef8:	e05a                	sd	s6,0(sp)
    80002efa:	0080                	addi	s0,sp,64
    80002efc:	8b2a                	mv	s6,a0
    80002efe:	00017a97          	auipc	s5,0x17
    80002f02:	582a8a93          	addi	s5,s5,1410 # 8001a480 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f06:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f08:	00017997          	auipc	s3,0x17
    80002f0c:	54898993          	addi	s3,s3,1352 # 8001a450 <log>
    80002f10:	a829                	j	80002f2a <install_trans+0x4e>
    brelse(lbuf);
    80002f12:	854a                	mv	a0,s2
    80002f14:	a2eff0ef          	jal	80002142 <brelse>
    brelse(dbuf);
    80002f18:	8526                	mv	a0,s1
    80002f1a:	a28ff0ef          	jal	80002142 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f1e:	2a05                	addiw	s4,s4,1
    80002f20:	0a91                	addi	s5,s5,4
    80002f22:	02c9a783          	lw	a5,44(s3)
    80002f26:	04fa5463          	bge	s4,a5,80002f6e <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f2a:	0189a583          	lw	a1,24(s3)
    80002f2e:	014585bb          	addw	a1,a1,s4
    80002f32:	2585                	addiw	a1,a1,1
    80002f34:	0289a503          	lw	a0,40(s3)
    80002f38:	902ff0ef          	jal	8000203a <bread>
    80002f3c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f3e:	000aa583          	lw	a1,0(s5)
    80002f42:	0289a503          	lw	a0,40(s3)
    80002f46:	8f4ff0ef          	jal	8000203a <bread>
    80002f4a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f4c:	40000613          	li	a2,1024
    80002f50:	05890593          	addi	a1,s2,88
    80002f54:	05850513          	addi	a0,a0,88
    80002f58:	a94fd0ef          	jal	800001ec <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f5c:	8526                	mv	a0,s1
    80002f5e:	9b2ff0ef          	jal	80002110 <bwrite>
    if(recovering == 0)
    80002f62:	fa0b18e3          	bnez	s6,80002f12 <install_trans+0x36>
      bunpin(dbuf);
    80002f66:	8526                	mv	a0,s1
    80002f68:	a96ff0ef          	jal	800021fe <bunpin>
    80002f6c:	b75d                	j	80002f12 <install_trans+0x36>
}
    80002f6e:	70e2                	ld	ra,56(sp)
    80002f70:	7442                	ld	s0,48(sp)
    80002f72:	74a2                	ld	s1,40(sp)
    80002f74:	7902                	ld	s2,32(sp)
    80002f76:	69e2                	ld	s3,24(sp)
    80002f78:	6a42                	ld	s4,16(sp)
    80002f7a:	6aa2                	ld	s5,8(sp)
    80002f7c:	6b02                	ld	s6,0(sp)
    80002f7e:	6121                	addi	sp,sp,64
    80002f80:	8082                	ret
    80002f82:	8082                	ret

0000000080002f84 <initlog>:
{
    80002f84:	7179                	addi	sp,sp,-48
    80002f86:	f406                	sd	ra,40(sp)
    80002f88:	f022                	sd	s0,32(sp)
    80002f8a:	ec26                	sd	s1,24(sp)
    80002f8c:	e84a                	sd	s2,16(sp)
    80002f8e:	e44e                	sd	s3,8(sp)
    80002f90:	1800                	addi	s0,sp,48
    80002f92:	892a                	mv	s2,a0
    80002f94:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f96:	00017497          	auipc	s1,0x17
    80002f9a:	4ba48493          	addi	s1,s1,1210 # 8001a450 <log>
    80002f9e:	00004597          	auipc	a1,0x4
    80002fa2:	62258593          	addi	a1,a1,1570 # 800075c0 <etext+0x5c0>
    80002fa6:	8526                	mv	a0,s1
    80002fa8:	029020ef          	jal	800057d0 <initlock>
  log.start = sb->logstart;
    80002fac:	0149a583          	lw	a1,20(s3)
    80002fb0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002fb2:	0109a783          	lw	a5,16(s3)
    80002fb6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002fb8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002fbc:	854a                	mv	a0,s2
    80002fbe:	87cff0ef          	jal	8000203a <bread>
  log.lh.n = lh->n;
    80002fc2:	4d30                	lw	a2,88(a0)
    80002fc4:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002fc6:	00c05f63          	blez	a2,80002fe4 <initlog+0x60>
    80002fca:	87aa                	mv	a5,a0
    80002fcc:	00017717          	auipc	a4,0x17
    80002fd0:	4b470713          	addi	a4,a4,1204 # 8001a480 <log+0x30>
    80002fd4:	060a                	slli	a2,a2,0x2
    80002fd6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002fd8:	4ff4                	lw	a3,92(a5)
    80002fda:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002fdc:	0791                	addi	a5,a5,4
    80002fde:	0711                	addi	a4,a4,4
    80002fe0:	fec79ce3          	bne	a5,a2,80002fd8 <initlog+0x54>
  brelse(buf);
    80002fe4:	95eff0ef          	jal	80002142 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002fe8:	4505                	li	a0,1
    80002fea:	ef3ff0ef          	jal	80002edc <install_trans>
  log.lh.n = 0;
    80002fee:	00017797          	auipc	a5,0x17
    80002ff2:	4807a723          	sw	zero,1166(a5) # 8001a47c <log+0x2c>
  write_head(); // clear the log
    80002ff6:	e89ff0ef          	jal	80002e7e <write_head>
}
    80002ffa:	70a2                	ld	ra,40(sp)
    80002ffc:	7402                	ld	s0,32(sp)
    80002ffe:	64e2                	ld	s1,24(sp)
    80003000:	6942                	ld	s2,16(sp)
    80003002:	69a2                	ld	s3,8(sp)
    80003004:	6145                	addi	sp,sp,48
    80003006:	8082                	ret

0000000080003008 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003008:	1101                	addi	sp,sp,-32
    8000300a:	ec06                	sd	ra,24(sp)
    8000300c:	e822                	sd	s0,16(sp)
    8000300e:	e426                	sd	s1,8(sp)
    80003010:	e04a                	sd	s2,0(sp)
    80003012:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003014:	00017517          	auipc	a0,0x17
    80003018:	43c50513          	addi	a0,a0,1084 # 8001a450 <log>
    8000301c:	035020ef          	jal	80005850 <acquire>
  while(1){
    if(log.committing){
    80003020:	00017497          	auipc	s1,0x17
    80003024:	43048493          	addi	s1,s1,1072 # 8001a450 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003028:	4979                	li	s2,30
    8000302a:	a029                	j	80003034 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000302c:	85a6                	mv	a1,s1
    8000302e:	8526                	mv	a0,s1
    80003030:	b4efe0ef          	jal	8000137e <sleep>
    if(log.committing){
    80003034:	50dc                	lw	a5,36(s1)
    80003036:	fbfd                	bnez	a5,8000302c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003038:	5098                	lw	a4,32(s1)
    8000303a:	2705                	addiw	a4,a4,1
    8000303c:	0027179b          	slliw	a5,a4,0x2
    80003040:	9fb9                	addw	a5,a5,a4
    80003042:	0017979b          	slliw	a5,a5,0x1
    80003046:	54d4                	lw	a3,44(s1)
    80003048:	9fb5                	addw	a5,a5,a3
    8000304a:	00f95763          	bge	s2,a5,80003058 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000304e:	85a6                	mv	a1,s1
    80003050:	8526                	mv	a0,s1
    80003052:	b2cfe0ef          	jal	8000137e <sleep>
    80003056:	bff9                	j	80003034 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003058:	00017517          	auipc	a0,0x17
    8000305c:	3f850513          	addi	a0,a0,1016 # 8001a450 <log>
    80003060:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003062:	087020ef          	jal	800058e8 <release>
      break;
    }
  }
}
    80003066:	60e2                	ld	ra,24(sp)
    80003068:	6442                	ld	s0,16(sp)
    8000306a:	64a2                	ld	s1,8(sp)
    8000306c:	6902                	ld	s2,0(sp)
    8000306e:	6105                	addi	sp,sp,32
    80003070:	8082                	ret

0000000080003072 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003072:	7139                	addi	sp,sp,-64
    80003074:	fc06                	sd	ra,56(sp)
    80003076:	f822                	sd	s0,48(sp)
    80003078:	f426                	sd	s1,40(sp)
    8000307a:	f04a                	sd	s2,32(sp)
    8000307c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000307e:	00017497          	auipc	s1,0x17
    80003082:	3d248493          	addi	s1,s1,978 # 8001a450 <log>
    80003086:	8526                	mv	a0,s1
    80003088:	7c8020ef          	jal	80005850 <acquire>
  log.outstanding -= 1;
    8000308c:	509c                	lw	a5,32(s1)
    8000308e:	37fd                	addiw	a5,a5,-1
    80003090:	0007891b          	sext.w	s2,a5
    80003094:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003096:	50dc                	lw	a5,36(s1)
    80003098:	ef9d                	bnez	a5,800030d6 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000309a:	04091763          	bnez	s2,800030e8 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000309e:	00017497          	auipc	s1,0x17
    800030a2:	3b248493          	addi	s1,s1,946 # 8001a450 <log>
    800030a6:	4785                	li	a5,1
    800030a8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800030aa:	8526                	mv	a0,s1
    800030ac:	03d020ef          	jal	800058e8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800030b0:	54dc                	lw	a5,44(s1)
    800030b2:	04f04b63          	bgtz	a5,80003108 <end_op+0x96>
    acquire(&log.lock);
    800030b6:	00017497          	auipc	s1,0x17
    800030ba:	39a48493          	addi	s1,s1,922 # 8001a450 <log>
    800030be:	8526                	mv	a0,s1
    800030c0:	790020ef          	jal	80005850 <acquire>
    log.committing = 0;
    800030c4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800030c8:	8526                	mv	a0,s1
    800030ca:	b00fe0ef          	jal	800013ca <wakeup>
    release(&log.lock);
    800030ce:	8526                	mv	a0,s1
    800030d0:	019020ef          	jal	800058e8 <release>
}
    800030d4:	a025                	j	800030fc <end_op+0x8a>
    800030d6:	ec4e                	sd	s3,24(sp)
    800030d8:	e852                	sd	s4,16(sp)
    800030da:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800030dc:	00004517          	auipc	a0,0x4
    800030e0:	4ec50513          	addi	a0,a0,1260 # 800075c8 <etext+0x5c8>
    800030e4:	43e020ef          	jal	80005522 <panic>
    wakeup(&log);
    800030e8:	00017497          	auipc	s1,0x17
    800030ec:	36848493          	addi	s1,s1,872 # 8001a450 <log>
    800030f0:	8526                	mv	a0,s1
    800030f2:	ad8fe0ef          	jal	800013ca <wakeup>
  release(&log.lock);
    800030f6:	8526                	mv	a0,s1
    800030f8:	7f0020ef          	jal	800058e8 <release>
}
    800030fc:	70e2                	ld	ra,56(sp)
    800030fe:	7442                	ld	s0,48(sp)
    80003100:	74a2                	ld	s1,40(sp)
    80003102:	7902                	ld	s2,32(sp)
    80003104:	6121                	addi	sp,sp,64
    80003106:	8082                	ret
    80003108:	ec4e                	sd	s3,24(sp)
    8000310a:	e852                	sd	s4,16(sp)
    8000310c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000310e:	00017a97          	auipc	s5,0x17
    80003112:	372a8a93          	addi	s5,s5,882 # 8001a480 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003116:	00017a17          	auipc	s4,0x17
    8000311a:	33aa0a13          	addi	s4,s4,826 # 8001a450 <log>
    8000311e:	018a2583          	lw	a1,24(s4)
    80003122:	012585bb          	addw	a1,a1,s2
    80003126:	2585                	addiw	a1,a1,1
    80003128:	028a2503          	lw	a0,40(s4)
    8000312c:	f0ffe0ef          	jal	8000203a <bread>
    80003130:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003132:	000aa583          	lw	a1,0(s5)
    80003136:	028a2503          	lw	a0,40(s4)
    8000313a:	f01fe0ef          	jal	8000203a <bread>
    8000313e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003140:	40000613          	li	a2,1024
    80003144:	05850593          	addi	a1,a0,88
    80003148:	05848513          	addi	a0,s1,88
    8000314c:	8a0fd0ef          	jal	800001ec <memmove>
    bwrite(to);  // write the log
    80003150:	8526                	mv	a0,s1
    80003152:	fbffe0ef          	jal	80002110 <bwrite>
    brelse(from);
    80003156:	854e                	mv	a0,s3
    80003158:	febfe0ef          	jal	80002142 <brelse>
    brelse(to);
    8000315c:	8526                	mv	a0,s1
    8000315e:	fe5fe0ef          	jal	80002142 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003162:	2905                	addiw	s2,s2,1
    80003164:	0a91                	addi	s5,s5,4
    80003166:	02ca2783          	lw	a5,44(s4)
    8000316a:	faf94ae3          	blt	s2,a5,8000311e <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000316e:	d11ff0ef          	jal	80002e7e <write_head>
    install_trans(0); // Now install writes to home locations
    80003172:	4501                	li	a0,0
    80003174:	d69ff0ef          	jal	80002edc <install_trans>
    log.lh.n = 0;
    80003178:	00017797          	auipc	a5,0x17
    8000317c:	3007a223          	sw	zero,772(a5) # 8001a47c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003180:	cffff0ef          	jal	80002e7e <write_head>
    80003184:	69e2                	ld	s3,24(sp)
    80003186:	6a42                	ld	s4,16(sp)
    80003188:	6aa2                	ld	s5,8(sp)
    8000318a:	b735                	j	800030b6 <end_op+0x44>

000000008000318c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000318c:	1101                	addi	sp,sp,-32
    8000318e:	ec06                	sd	ra,24(sp)
    80003190:	e822                	sd	s0,16(sp)
    80003192:	e426                	sd	s1,8(sp)
    80003194:	e04a                	sd	s2,0(sp)
    80003196:	1000                	addi	s0,sp,32
    80003198:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000319a:	00017917          	auipc	s2,0x17
    8000319e:	2b690913          	addi	s2,s2,694 # 8001a450 <log>
    800031a2:	854a                	mv	a0,s2
    800031a4:	6ac020ef          	jal	80005850 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800031a8:	02c92603          	lw	a2,44(s2)
    800031ac:	47f5                	li	a5,29
    800031ae:	06c7c363          	blt	a5,a2,80003214 <log_write+0x88>
    800031b2:	00017797          	auipc	a5,0x17
    800031b6:	2ba7a783          	lw	a5,698(a5) # 8001a46c <log+0x1c>
    800031ba:	37fd                	addiw	a5,a5,-1
    800031bc:	04f65c63          	bge	a2,a5,80003214 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800031c0:	00017797          	auipc	a5,0x17
    800031c4:	2b07a783          	lw	a5,688(a5) # 8001a470 <log+0x20>
    800031c8:	04f05c63          	blez	a5,80003220 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031cc:	4781                	li	a5,0
    800031ce:	04c05f63          	blez	a2,8000322c <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031d2:	44cc                	lw	a1,12(s1)
    800031d4:	00017717          	auipc	a4,0x17
    800031d8:	2ac70713          	addi	a4,a4,684 # 8001a480 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800031dc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031de:	4314                	lw	a3,0(a4)
    800031e0:	04b68663          	beq	a3,a1,8000322c <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800031e4:	2785                	addiw	a5,a5,1
    800031e6:	0711                	addi	a4,a4,4
    800031e8:	fef61be3          	bne	a2,a5,800031de <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800031ec:	0621                	addi	a2,a2,8
    800031ee:	060a                	slli	a2,a2,0x2
    800031f0:	00017797          	auipc	a5,0x17
    800031f4:	26078793          	addi	a5,a5,608 # 8001a450 <log>
    800031f8:	97b2                	add	a5,a5,a2
    800031fa:	44d8                	lw	a4,12(s1)
    800031fc:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800031fe:	8526                	mv	a0,s1
    80003200:	fcbfe0ef          	jal	800021ca <bpin>
    log.lh.n++;
    80003204:	00017717          	auipc	a4,0x17
    80003208:	24c70713          	addi	a4,a4,588 # 8001a450 <log>
    8000320c:	575c                	lw	a5,44(a4)
    8000320e:	2785                	addiw	a5,a5,1
    80003210:	d75c                	sw	a5,44(a4)
    80003212:	a80d                	j	80003244 <log_write+0xb8>
    panic("too big a transaction");
    80003214:	00004517          	auipc	a0,0x4
    80003218:	3c450513          	addi	a0,a0,964 # 800075d8 <etext+0x5d8>
    8000321c:	306020ef          	jal	80005522 <panic>
    panic("log_write outside of trans");
    80003220:	00004517          	auipc	a0,0x4
    80003224:	3d050513          	addi	a0,a0,976 # 800075f0 <etext+0x5f0>
    80003228:	2fa020ef          	jal	80005522 <panic>
  log.lh.block[i] = b->blockno;
    8000322c:	00878693          	addi	a3,a5,8
    80003230:	068a                	slli	a3,a3,0x2
    80003232:	00017717          	auipc	a4,0x17
    80003236:	21e70713          	addi	a4,a4,542 # 8001a450 <log>
    8000323a:	9736                	add	a4,a4,a3
    8000323c:	44d4                	lw	a3,12(s1)
    8000323e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003240:	faf60fe3          	beq	a2,a5,800031fe <log_write+0x72>
  }
  release(&log.lock);
    80003244:	00017517          	auipc	a0,0x17
    80003248:	20c50513          	addi	a0,a0,524 # 8001a450 <log>
    8000324c:	69c020ef          	jal	800058e8 <release>
}
    80003250:	60e2                	ld	ra,24(sp)
    80003252:	6442                	ld	s0,16(sp)
    80003254:	64a2                	ld	s1,8(sp)
    80003256:	6902                	ld	s2,0(sp)
    80003258:	6105                	addi	sp,sp,32
    8000325a:	8082                	ret

000000008000325c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000325c:	1101                	addi	sp,sp,-32
    8000325e:	ec06                	sd	ra,24(sp)
    80003260:	e822                	sd	s0,16(sp)
    80003262:	e426                	sd	s1,8(sp)
    80003264:	e04a                	sd	s2,0(sp)
    80003266:	1000                	addi	s0,sp,32
    80003268:	84aa                	mv	s1,a0
    8000326a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000326c:	00004597          	auipc	a1,0x4
    80003270:	3a458593          	addi	a1,a1,932 # 80007610 <etext+0x610>
    80003274:	0521                	addi	a0,a0,8
    80003276:	55a020ef          	jal	800057d0 <initlock>
  lk->name = name;
    8000327a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000327e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003282:	0204a423          	sw	zero,40(s1)
}
    80003286:	60e2                	ld	ra,24(sp)
    80003288:	6442                	ld	s0,16(sp)
    8000328a:	64a2                	ld	s1,8(sp)
    8000328c:	6902                	ld	s2,0(sp)
    8000328e:	6105                	addi	sp,sp,32
    80003290:	8082                	ret

0000000080003292 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003292:	1101                	addi	sp,sp,-32
    80003294:	ec06                	sd	ra,24(sp)
    80003296:	e822                	sd	s0,16(sp)
    80003298:	e426                	sd	s1,8(sp)
    8000329a:	e04a                	sd	s2,0(sp)
    8000329c:	1000                	addi	s0,sp,32
    8000329e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032a0:	00850913          	addi	s2,a0,8
    800032a4:	854a                	mv	a0,s2
    800032a6:	5aa020ef          	jal	80005850 <acquire>
  while (lk->locked) {
    800032aa:	409c                	lw	a5,0(s1)
    800032ac:	c799                	beqz	a5,800032ba <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800032ae:	85ca                	mv	a1,s2
    800032b0:	8526                	mv	a0,s1
    800032b2:	8ccfe0ef          	jal	8000137e <sleep>
  while (lk->locked) {
    800032b6:	409c                	lw	a5,0(s1)
    800032b8:	fbfd                	bnez	a5,800032ae <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800032ba:	4785                	li	a5,1
    800032bc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800032be:	aebfd0ef          	jal	80000da8 <myproc>
    800032c2:	591c                	lw	a5,48(a0)
    800032c4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032c6:	854a                	mv	a0,s2
    800032c8:	620020ef          	jal	800058e8 <release>
}
    800032cc:	60e2                	ld	ra,24(sp)
    800032ce:	6442                	ld	s0,16(sp)
    800032d0:	64a2                	ld	s1,8(sp)
    800032d2:	6902                	ld	s2,0(sp)
    800032d4:	6105                	addi	sp,sp,32
    800032d6:	8082                	ret

00000000800032d8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800032d8:	1101                	addi	sp,sp,-32
    800032da:	ec06                	sd	ra,24(sp)
    800032dc:	e822                	sd	s0,16(sp)
    800032de:	e426                	sd	s1,8(sp)
    800032e0:	e04a                	sd	s2,0(sp)
    800032e2:	1000                	addi	s0,sp,32
    800032e4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032e6:	00850913          	addi	s2,a0,8
    800032ea:	854a                	mv	a0,s2
    800032ec:	564020ef          	jal	80005850 <acquire>
  lk->locked = 0;
    800032f0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032f4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800032f8:	8526                	mv	a0,s1
    800032fa:	8d0fe0ef          	jal	800013ca <wakeup>
  release(&lk->lk);
    800032fe:	854a                	mv	a0,s2
    80003300:	5e8020ef          	jal	800058e8 <release>
}
    80003304:	60e2                	ld	ra,24(sp)
    80003306:	6442                	ld	s0,16(sp)
    80003308:	64a2                	ld	s1,8(sp)
    8000330a:	6902                	ld	s2,0(sp)
    8000330c:	6105                	addi	sp,sp,32
    8000330e:	8082                	ret

0000000080003310 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003310:	7179                	addi	sp,sp,-48
    80003312:	f406                	sd	ra,40(sp)
    80003314:	f022                	sd	s0,32(sp)
    80003316:	ec26                	sd	s1,24(sp)
    80003318:	e84a                	sd	s2,16(sp)
    8000331a:	1800                	addi	s0,sp,48
    8000331c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000331e:	00850913          	addi	s2,a0,8
    80003322:	854a                	mv	a0,s2
    80003324:	52c020ef          	jal	80005850 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003328:	409c                	lw	a5,0(s1)
    8000332a:	ef81                	bnez	a5,80003342 <holdingsleep+0x32>
    8000332c:	4481                	li	s1,0
  release(&lk->lk);
    8000332e:	854a                	mv	a0,s2
    80003330:	5b8020ef          	jal	800058e8 <release>
  return r;
}
    80003334:	8526                	mv	a0,s1
    80003336:	70a2                	ld	ra,40(sp)
    80003338:	7402                	ld	s0,32(sp)
    8000333a:	64e2                	ld	s1,24(sp)
    8000333c:	6942                	ld	s2,16(sp)
    8000333e:	6145                	addi	sp,sp,48
    80003340:	8082                	ret
    80003342:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003344:	0284a983          	lw	s3,40(s1)
    80003348:	a61fd0ef          	jal	80000da8 <myproc>
    8000334c:	5904                	lw	s1,48(a0)
    8000334e:	413484b3          	sub	s1,s1,s3
    80003352:	0014b493          	seqz	s1,s1
    80003356:	69a2                	ld	s3,8(sp)
    80003358:	bfd9                	j	8000332e <holdingsleep+0x1e>

000000008000335a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000335a:	1141                	addi	sp,sp,-16
    8000335c:	e406                	sd	ra,8(sp)
    8000335e:	e022                	sd	s0,0(sp)
    80003360:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003362:	00004597          	auipc	a1,0x4
    80003366:	2be58593          	addi	a1,a1,702 # 80007620 <etext+0x620>
    8000336a:	00017517          	auipc	a0,0x17
    8000336e:	22e50513          	addi	a0,a0,558 # 8001a598 <ftable>
    80003372:	45e020ef          	jal	800057d0 <initlock>
}
    80003376:	60a2                	ld	ra,8(sp)
    80003378:	6402                	ld	s0,0(sp)
    8000337a:	0141                	addi	sp,sp,16
    8000337c:	8082                	ret

000000008000337e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000337e:	1101                	addi	sp,sp,-32
    80003380:	ec06                	sd	ra,24(sp)
    80003382:	e822                	sd	s0,16(sp)
    80003384:	e426                	sd	s1,8(sp)
    80003386:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003388:	00017517          	auipc	a0,0x17
    8000338c:	21050513          	addi	a0,a0,528 # 8001a598 <ftable>
    80003390:	4c0020ef          	jal	80005850 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003394:	00017497          	auipc	s1,0x17
    80003398:	21c48493          	addi	s1,s1,540 # 8001a5b0 <ftable+0x18>
    8000339c:	00018717          	auipc	a4,0x18
    800033a0:	1b470713          	addi	a4,a4,436 # 8001b550 <disk>
    if(f->ref == 0){
    800033a4:	40dc                	lw	a5,4(s1)
    800033a6:	cf89                	beqz	a5,800033c0 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033a8:	02848493          	addi	s1,s1,40
    800033ac:	fee49ce3          	bne	s1,a4,800033a4 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800033b0:	00017517          	auipc	a0,0x17
    800033b4:	1e850513          	addi	a0,a0,488 # 8001a598 <ftable>
    800033b8:	530020ef          	jal	800058e8 <release>
  return 0;
    800033bc:	4481                	li	s1,0
    800033be:	a809                	j	800033d0 <filealloc+0x52>
      f->ref = 1;
    800033c0:	4785                	li	a5,1
    800033c2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033c4:	00017517          	auipc	a0,0x17
    800033c8:	1d450513          	addi	a0,a0,468 # 8001a598 <ftable>
    800033cc:	51c020ef          	jal	800058e8 <release>
}
    800033d0:	8526                	mv	a0,s1
    800033d2:	60e2                	ld	ra,24(sp)
    800033d4:	6442                	ld	s0,16(sp)
    800033d6:	64a2                	ld	s1,8(sp)
    800033d8:	6105                	addi	sp,sp,32
    800033da:	8082                	ret

00000000800033dc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800033dc:	1101                	addi	sp,sp,-32
    800033de:	ec06                	sd	ra,24(sp)
    800033e0:	e822                	sd	s0,16(sp)
    800033e2:	e426                	sd	s1,8(sp)
    800033e4:	1000                	addi	s0,sp,32
    800033e6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800033e8:	00017517          	auipc	a0,0x17
    800033ec:	1b050513          	addi	a0,a0,432 # 8001a598 <ftable>
    800033f0:	460020ef          	jal	80005850 <acquire>
  if(f->ref < 1)
    800033f4:	40dc                	lw	a5,4(s1)
    800033f6:	02f05063          	blez	a5,80003416 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800033fa:	2785                	addiw	a5,a5,1
    800033fc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800033fe:	00017517          	auipc	a0,0x17
    80003402:	19a50513          	addi	a0,a0,410 # 8001a598 <ftable>
    80003406:	4e2020ef          	jal	800058e8 <release>
  return f;
}
    8000340a:	8526                	mv	a0,s1
    8000340c:	60e2                	ld	ra,24(sp)
    8000340e:	6442                	ld	s0,16(sp)
    80003410:	64a2                	ld	s1,8(sp)
    80003412:	6105                	addi	sp,sp,32
    80003414:	8082                	ret
    panic("filedup");
    80003416:	00004517          	auipc	a0,0x4
    8000341a:	21250513          	addi	a0,a0,530 # 80007628 <etext+0x628>
    8000341e:	104020ef          	jal	80005522 <panic>

0000000080003422 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003422:	7139                	addi	sp,sp,-64
    80003424:	fc06                	sd	ra,56(sp)
    80003426:	f822                	sd	s0,48(sp)
    80003428:	f426                	sd	s1,40(sp)
    8000342a:	0080                	addi	s0,sp,64
    8000342c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000342e:	00017517          	auipc	a0,0x17
    80003432:	16a50513          	addi	a0,a0,362 # 8001a598 <ftable>
    80003436:	41a020ef          	jal	80005850 <acquire>
  if(f->ref < 1)
    8000343a:	40dc                	lw	a5,4(s1)
    8000343c:	04f05a63          	blez	a5,80003490 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003440:	37fd                	addiw	a5,a5,-1
    80003442:	0007871b          	sext.w	a4,a5
    80003446:	c0dc                	sw	a5,4(s1)
    80003448:	04e04e63          	bgtz	a4,800034a4 <fileclose+0x82>
    8000344c:	f04a                	sd	s2,32(sp)
    8000344e:	ec4e                	sd	s3,24(sp)
    80003450:	e852                	sd	s4,16(sp)
    80003452:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003454:	0004a903          	lw	s2,0(s1)
    80003458:	0094ca83          	lbu	s5,9(s1)
    8000345c:	0104ba03          	ld	s4,16(s1)
    80003460:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003464:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003468:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000346c:	00017517          	auipc	a0,0x17
    80003470:	12c50513          	addi	a0,a0,300 # 8001a598 <ftable>
    80003474:	474020ef          	jal	800058e8 <release>

  if(ff.type == FD_PIPE){
    80003478:	4785                	li	a5,1
    8000347a:	04f90063          	beq	s2,a5,800034ba <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000347e:	3979                	addiw	s2,s2,-2
    80003480:	4785                	li	a5,1
    80003482:	0527f563          	bgeu	a5,s2,800034cc <fileclose+0xaa>
    80003486:	7902                	ld	s2,32(sp)
    80003488:	69e2                	ld	s3,24(sp)
    8000348a:	6a42                	ld	s4,16(sp)
    8000348c:	6aa2                	ld	s5,8(sp)
    8000348e:	a00d                	j	800034b0 <fileclose+0x8e>
    80003490:	f04a                	sd	s2,32(sp)
    80003492:	ec4e                	sd	s3,24(sp)
    80003494:	e852                	sd	s4,16(sp)
    80003496:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003498:	00004517          	auipc	a0,0x4
    8000349c:	19850513          	addi	a0,a0,408 # 80007630 <etext+0x630>
    800034a0:	082020ef          	jal	80005522 <panic>
    release(&ftable.lock);
    800034a4:	00017517          	auipc	a0,0x17
    800034a8:	0f450513          	addi	a0,a0,244 # 8001a598 <ftable>
    800034ac:	43c020ef          	jal	800058e8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800034b0:	70e2                	ld	ra,56(sp)
    800034b2:	7442                	ld	s0,48(sp)
    800034b4:	74a2                	ld	s1,40(sp)
    800034b6:	6121                	addi	sp,sp,64
    800034b8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800034ba:	85d6                	mv	a1,s5
    800034bc:	8552                	mv	a0,s4
    800034be:	336000ef          	jal	800037f4 <pipeclose>
    800034c2:	7902                	ld	s2,32(sp)
    800034c4:	69e2                	ld	s3,24(sp)
    800034c6:	6a42                	ld	s4,16(sp)
    800034c8:	6aa2                	ld	s5,8(sp)
    800034ca:	b7dd                	j	800034b0 <fileclose+0x8e>
    begin_op();
    800034cc:	b3dff0ef          	jal	80003008 <begin_op>
    iput(ff.ip);
    800034d0:	854e                	mv	a0,s3
    800034d2:	c22ff0ef          	jal	800028f4 <iput>
    end_op();
    800034d6:	b9dff0ef          	jal	80003072 <end_op>
    800034da:	7902                	ld	s2,32(sp)
    800034dc:	69e2                	ld	s3,24(sp)
    800034de:	6a42                	ld	s4,16(sp)
    800034e0:	6aa2                	ld	s5,8(sp)
    800034e2:	b7f9                	j	800034b0 <fileclose+0x8e>

00000000800034e4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800034e4:	715d                	addi	sp,sp,-80
    800034e6:	e486                	sd	ra,72(sp)
    800034e8:	e0a2                	sd	s0,64(sp)
    800034ea:	fc26                	sd	s1,56(sp)
    800034ec:	f44e                	sd	s3,40(sp)
    800034ee:	0880                	addi	s0,sp,80
    800034f0:	84aa                	mv	s1,a0
    800034f2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800034f4:	8b5fd0ef          	jal	80000da8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800034f8:	409c                	lw	a5,0(s1)
    800034fa:	37f9                	addiw	a5,a5,-2
    800034fc:	4705                	li	a4,1
    800034fe:	04f76063          	bltu	a4,a5,8000353e <filestat+0x5a>
    80003502:	f84a                	sd	s2,48(sp)
    80003504:	892a                	mv	s2,a0
    ilock(f->ip);
    80003506:	6c88                	ld	a0,24(s1)
    80003508:	a6aff0ef          	jal	80002772 <ilock>
    stati(f->ip, &st);
    8000350c:	fb840593          	addi	a1,s0,-72
    80003510:	6c88                	ld	a0,24(s1)
    80003512:	c8aff0ef          	jal	8000299c <stati>
    iunlock(f->ip);
    80003516:	6c88                	ld	a0,24(s1)
    80003518:	b08ff0ef          	jal	80002820 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000351c:	46e1                	li	a3,24
    8000351e:	fb840613          	addi	a2,s0,-72
    80003522:	85ce                	mv	a1,s3
    80003524:	05093503          	ld	a0,80(s2)
    80003528:	cf2fd0ef          	jal	80000a1a <copyout>
    8000352c:	41f5551b          	sraiw	a0,a0,0x1f
    80003530:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003532:	60a6                	ld	ra,72(sp)
    80003534:	6406                	ld	s0,64(sp)
    80003536:	74e2                	ld	s1,56(sp)
    80003538:	79a2                	ld	s3,40(sp)
    8000353a:	6161                	addi	sp,sp,80
    8000353c:	8082                	ret
  return -1;
    8000353e:	557d                	li	a0,-1
    80003540:	bfcd                	j	80003532 <filestat+0x4e>

0000000080003542 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003542:	7179                	addi	sp,sp,-48
    80003544:	f406                	sd	ra,40(sp)
    80003546:	f022                	sd	s0,32(sp)
    80003548:	e84a                	sd	s2,16(sp)
    8000354a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000354c:	00854783          	lbu	a5,8(a0)
    80003550:	cfd1                	beqz	a5,800035ec <fileread+0xaa>
    80003552:	ec26                	sd	s1,24(sp)
    80003554:	e44e                	sd	s3,8(sp)
    80003556:	84aa                	mv	s1,a0
    80003558:	89ae                	mv	s3,a1
    8000355a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000355c:	411c                	lw	a5,0(a0)
    8000355e:	4705                	li	a4,1
    80003560:	04e78363          	beq	a5,a4,800035a6 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003564:	470d                	li	a4,3
    80003566:	04e78763          	beq	a5,a4,800035b4 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000356a:	4709                	li	a4,2
    8000356c:	06e79a63          	bne	a5,a4,800035e0 <fileread+0x9e>
    ilock(f->ip);
    80003570:	6d08                	ld	a0,24(a0)
    80003572:	a00ff0ef          	jal	80002772 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003576:	874a                	mv	a4,s2
    80003578:	5094                	lw	a3,32(s1)
    8000357a:	864e                	mv	a2,s3
    8000357c:	4585                	li	a1,1
    8000357e:	6c88                	ld	a0,24(s1)
    80003580:	c46ff0ef          	jal	800029c6 <readi>
    80003584:	892a                	mv	s2,a0
    80003586:	00a05563          	blez	a0,80003590 <fileread+0x4e>
      f->off += r;
    8000358a:	509c                	lw	a5,32(s1)
    8000358c:	9fa9                	addw	a5,a5,a0
    8000358e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003590:	6c88                	ld	a0,24(s1)
    80003592:	a8eff0ef          	jal	80002820 <iunlock>
    80003596:	64e2                	ld	s1,24(sp)
    80003598:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000359a:	854a                	mv	a0,s2
    8000359c:	70a2                	ld	ra,40(sp)
    8000359e:	7402                	ld	s0,32(sp)
    800035a0:	6942                	ld	s2,16(sp)
    800035a2:	6145                	addi	sp,sp,48
    800035a4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800035a6:	6908                	ld	a0,16(a0)
    800035a8:	388000ef          	jal	80003930 <piperead>
    800035ac:	892a                	mv	s2,a0
    800035ae:	64e2                	ld	s1,24(sp)
    800035b0:	69a2                	ld	s3,8(sp)
    800035b2:	b7e5                	j	8000359a <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800035b4:	02451783          	lh	a5,36(a0)
    800035b8:	03079693          	slli	a3,a5,0x30
    800035bc:	92c1                	srli	a3,a3,0x30
    800035be:	4725                	li	a4,9
    800035c0:	02d76863          	bltu	a4,a3,800035f0 <fileread+0xae>
    800035c4:	0792                	slli	a5,a5,0x4
    800035c6:	00017717          	auipc	a4,0x17
    800035ca:	f3270713          	addi	a4,a4,-206 # 8001a4f8 <devsw>
    800035ce:	97ba                	add	a5,a5,a4
    800035d0:	639c                	ld	a5,0(a5)
    800035d2:	c39d                	beqz	a5,800035f8 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800035d4:	4505                	li	a0,1
    800035d6:	9782                	jalr	a5
    800035d8:	892a                	mv	s2,a0
    800035da:	64e2                	ld	s1,24(sp)
    800035dc:	69a2                	ld	s3,8(sp)
    800035de:	bf75                	j	8000359a <fileread+0x58>
    panic("fileread");
    800035e0:	00004517          	auipc	a0,0x4
    800035e4:	06050513          	addi	a0,a0,96 # 80007640 <etext+0x640>
    800035e8:	73b010ef          	jal	80005522 <panic>
    return -1;
    800035ec:	597d                	li	s2,-1
    800035ee:	b775                	j	8000359a <fileread+0x58>
      return -1;
    800035f0:	597d                	li	s2,-1
    800035f2:	64e2                	ld	s1,24(sp)
    800035f4:	69a2                	ld	s3,8(sp)
    800035f6:	b755                	j	8000359a <fileread+0x58>
    800035f8:	597d                	li	s2,-1
    800035fa:	64e2                	ld	s1,24(sp)
    800035fc:	69a2                	ld	s3,8(sp)
    800035fe:	bf71                	j	8000359a <fileread+0x58>

0000000080003600 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003600:	00954783          	lbu	a5,9(a0)
    80003604:	10078b63          	beqz	a5,8000371a <filewrite+0x11a>
{
    80003608:	715d                	addi	sp,sp,-80
    8000360a:	e486                	sd	ra,72(sp)
    8000360c:	e0a2                	sd	s0,64(sp)
    8000360e:	f84a                	sd	s2,48(sp)
    80003610:	f052                	sd	s4,32(sp)
    80003612:	e85a                	sd	s6,16(sp)
    80003614:	0880                	addi	s0,sp,80
    80003616:	892a                	mv	s2,a0
    80003618:	8b2e                	mv	s6,a1
    8000361a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000361c:	411c                	lw	a5,0(a0)
    8000361e:	4705                	li	a4,1
    80003620:	02e78763          	beq	a5,a4,8000364e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003624:	470d                	li	a4,3
    80003626:	02e78863          	beq	a5,a4,80003656 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000362a:	4709                	li	a4,2
    8000362c:	0ce79c63          	bne	a5,a4,80003704 <filewrite+0x104>
    80003630:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003632:	0ac05863          	blez	a2,800036e2 <filewrite+0xe2>
    80003636:	fc26                	sd	s1,56(sp)
    80003638:	ec56                	sd	s5,24(sp)
    8000363a:	e45e                	sd	s7,8(sp)
    8000363c:	e062                	sd	s8,0(sp)
    int i = 0;
    8000363e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003640:	6b85                	lui	s7,0x1
    80003642:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003646:	6c05                	lui	s8,0x1
    80003648:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000364c:	a8b5                	j	800036c8 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000364e:	6908                	ld	a0,16(a0)
    80003650:	1fc000ef          	jal	8000384c <pipewrite>
    80003654:	a04d                	j	800036f6 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003656:	02451783          	lh	a5,36(a0)
    8000365a:	03079693          	slli	a3,a5,0x30
    8000365e:	92c1                	srli	a3,a3,0x30
    80003660:	4725                	li	a4,9
    80003662:	0ad76e63          	bltu	a4,a3,8000371e <filewrite+0x11e>
    80003666:	0792                	slli	a5,a5,0x4
    80003668:	00017717          	auipc	a4,0x17
    8000366c:	e9070713          	addi	a4,a4,-368 # 8001a4f8 <devsw>
    80003670:	97ba                	add	a5,a5,a4
    80003672:	679c                	ld	a5,8(a5)
    80003674:	c7dd                	beqz	a5,80003722 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003676:	4505                	li	a0,1
    80003678:	9782                	jalr	a5
    8000367a:	a8b5                	j	800036f6 <filewrite+0xf6>
      if(n1 > max)
    8000367c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003680:	989ff0ef          	jal	80003008 <begin_op>
      ilock(f->ip);
    80003684:	01893503          	ld	a0,24(s2)
    80003688:	8eaff0ef          	jal	80002772 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000368c:	8756                	mv	a4,s5
    8000368e:	02092683          	lw	a3,32(s2)
    80003692:	01698633          	add	a2,s3,s6
    80003696:	4585                	li	a1,1
    80003698:	01893503          	ld	a0,24(s2)
    8000369c:	c26ff0ef          	jal	80002ac2 <writei>
    800036a0:	84aa                	mv	s1,a0
    800036a2:	00a05763          	blez	a0,800036b0 <filewrite+0xb0>
        f->off += r;
    800036a6:	02092783          	lw	a5,32(s2)
    800036aa:	9fa9                	addw	a5,a5,a0
    800036ac:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800036b0:	01893503          	ld	a0,24(s2)
    800036b4:	96cff0ef          	jal	80002820 <iunlock>
      end_op();
    800036b8:	9bbff0ef          	jal	80003072 <end_op>

      if(r != n1){
    800036bc:	029a9563          	bne	s5,s1,800036e6 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800036c0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800036c4:	0149da63          	bge	s3,s4,800036d8 <filewrite+0xd8>
      int n1 = n - i;
    800036c8:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800036cc:	0004879b          	sext.w	a5,s1
    800036d0:	fafbd6e3          	bge	s7,a5,8000367c <filewrite+0x7c>
    800036d4:	84e2                	mv	s1,s8
    800036d6:	b75d                	j	8000367c <filewrite+0x7c>
    800036d8:	74e2                	ld	s1,56(sp)
    800036da:	6ae2                	ld	s5,24(sp)
    800036dc:	6ba2                	ld	s7,8(sp)
    800036de:	6c02                	ld	s8,0(sp)
    800036e0:	a039                	j	800036ee <filewrite+0xee>
    int i = 0;
    800036e2:	4981                	li	s3,0
    800036e4:	a029                	j	800036ee <filewrite+0xee>
    800036e6:	74e2                	ld	s1,56(sp)
    800036e8:	6ae2                	ld	s5,24(sp)
    800036ea:	6ba2                	ld	s7,8(sp)
    800036ec:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800036ee:	033a1c63          	bne	s4,s3,80003726 <filewrite+0x126>
    800036f2:	8552                	mv	a0,s4
    800036f4:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800036f6:	60a6                	ld	ra,72(sp)
    800036f8:	6406                	ld	s0,64(sp)
    800036fa:	7942                	ld	s2,48(sp)
    800036fc:	7a02                	ld	s4,32(sp)
    800036fe:	6b42                	ld	s6,16(sp)
    80003700:	6161                	addi	sp,sp,80
    80003702:	8082                	ret
    80003704:	fc26                	sd	s1,56(sp)
    80003706:	f44e                	sd	s3,40(sp)
    80003708:	ec56                	sd	s5,24(sp)
    8000370a:	e45e                	sd	s7,8(sp)
    8000370c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000370e:	00004517          	auipc	a0,0x4
    80003712:	f4250513          	addi	a0,a0,-190 # 80007650 <etext+0x650>
    80003716:	60d010ef          	jal	80005522 <panic>
    return -1;
    8000371a:	557d                	li	a0,-1
}
    8000371c:	8082                	ret
      return -1;
    8000371e:	557d                	li	a0,-1
    80003720:	bfd9                	j	800036f6 <filewrite+0xf6>
    80003722:	557d                	li	a0,-1
    80003724:	bfc9                	j	800036f6 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003726:	557d                	li	a0,-1
    80003728:	79a2                	ld	s3,40(sp)
    8000372a:	b7f1                	j	800036f6 <filewrite+0xf6>

000000008000372c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000372c:	7179                	addi	sp,sp,-48
    8000372e:	f406                	sd	ra,40(sp)
    80003730:	f022                	sd	s0,32(sp)
    80003732:	ec26                	sd	s1,24(sp)
    80003734:	e052                	sd	s4,0(sp)
    80003736:	1800                	addi	s0,sp,48
    80003738:	84aa                	mv	s1,a0
    8000373a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000373c:	0005b023          	sd	zero,0(a1)
    80003740:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003744:	c3bff0ef          	jal	8000337e <filealloc>
    80003748:	e088                	sd	a0,0(s1)
    8000374a:	c549                	beqz	a0,800037d4 <pipealloc+0xa8>
    8000374c:	c33ff0ef          	jal	8000337e <filealloc>
    80003750:	00aa3023          	sd	a0,0(s4)
    80003754:	cd25                	beqz	a0,800037cc <pipealloc+0xa0>
    80003756:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003758:	9a7fc0ef          	jal	800000fe <kalloc>
    8000375c:	892a                	mv	s2,a0
    8000375e:	c12d                	beqz	a0,800037c0 <pipealloc+0x94>
    80003760:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003762:	4985                	li	s3,1
    80003764:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003768:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000376c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003770:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003774:	00004597          	auipc	a1,0x4
    80003778:	c8c58593          	addi	a1,a1,-884 # 80007400 <etext+0x400>
    8000377c:	054020ef          	jal	800057d0 <initlock>
  (*f0)->type = FD_PIPE;
    80003780:	609c                	ld	a5,0(s1)
    80003782:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003786:	609c                	ld	a5,0(s1)
    80003788:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000378c:	609c                	ld	a5,0(s1)
    8000378e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003792:	609c                	ld	a5,0(s1)
    80003794:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003798:	000a3783          	ld	a5,0(s4)
    8000379c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800037a0:	000a3783          	ld	a5,0(s4)
    800037a4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800037a8:	000a3783          	ld	a5,0(s4)
    800037ac:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800037b0:	000a3783          	ld	a5,0(s4)
    800037b4:	0127b823          	sd	s2,16(a5)
  return 0;
    800037b8:	4501                	li	a0,0
    800037ba:	6942                	ld	s2,16(sp)
    800037bc:	69a2                	ld	s3,8(sp)
    800037be:	a01d                	j	800037e4 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800037c0:	6088                	ld	a0,0(s1)
    800037c2:	c119                	beqz	a0,800037c8 <pipealloc+0x9c>
    800037c4:	6942                	ld	s2,16(sp)
    800037c6:	a029                	j	800037d0 <pipealloc+0xa4>
    800037c8:	6942                	ld	s2,16(sp)
    800037ca:	a029                	j	800037d4 <pipealloc+0xa8>
    800037cc:	6088                	ld	a0,0(s1)
    800037ce:	c10d                	beqz	a0,800037f0 <pipealloc+0xc4>
    fileclose(*f0);
    800037d0:	c53ff0ef          	jal	80003422 <fileclose>
  if(*f1)
    800037d4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800037d8:	557d                	li	a0,-1
  if(*f1)
    800037da:	c789                	beqz	a5,800037e4 <pipealloc+0xb8>
    fileclose(*f1);
    800037dc:	853e                	mv	a0,a5
    800037de:	c45ff0ef          	jal	80003422 <fileclose>
  return -1;
    800037e2:	557d                	li	a0,-1
}
    800037e4:	70a2                	ld	ra,40(sp)
    800037e6:	7402                	ld	s0,32(sp)
    800037e8:	64e2                	ld	s1,24(sp)
    800037ea:	6a02                	ld	s4,0(sp)
    800037ec:	6145                	addi	sp,sp,48
    800037ee:	8082                	ret
  return -1;
    800037f0:	557d                	li	a0,-1
    800037f2:	bfcd                	j	800037e4 <pipealloc+0xb8>

00000000800037f4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800037f4:	1101                	addi	sp,sp,-32
    800037f6:	ec06                	sd	ra,24(sp)
    800037f8:	e822                	sd	s0,16(sp)
    800037fa:	e426                	sd	s1,8(sp)
    800037fc:	e04a                	sd	s2,0(sp)
    800037fe:	1000                	addi	s0,sp,32
    80003800:	84aa                	mv	s1,a0
    80003802:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003804:	04c020ef          	jal	80005850 <acquire>
  if(writable){
    80003808:	02090763          	beqz	s2,80003836 <pipeclose+0x42>
    pi->writeopen = 0;
    8000380c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003810:	21848513          	addi	a0,s1,536
    80003814:	bb7fd0ef          	jal	800013ca <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003818:	2204b783          	ld	a5,544(s1)
    8000381c:	e785                	bnez	a5,80003844 <pipeclose+0x50>
    release(&pi->lock);
    8000381e:	8526                	mv	a0,s1
    80003820:	0c8020ef          	jal	800058e8 <release>
    kfree((char*)pi);
    80003824:	8526                	mv	a0,s1
    80003826:	ff6fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000382a:	60e2                	ld	ra,24(sp)
    8000382c:	6442                	ld	s0,16(sp)
    8000382e:	64a2                	ld	s1,8(sp)
    80003830:	6902                	ld	s2,0(sp)
    80003832:	6105                	addi	sp,sp,32
    80003834:	8082                	ret
    pi->readopen = 0;
    80003836:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000383a:	21c48513          	addi	a0,s1,540
    8000383e:	b8dfd0ef          	jal	800013ca <wakeup>
    80003842:	bfd9                	j	80003818 <pipeclose+0x24>
    release(&pi->lock);
    80003844:	8526                	mv	a0,s1
    80003846:	0a2020ef          	jal	800058e8 <release>
}
    8000384a:	b7c5                	j	8000382a <pipeclose+0x36>

000000008000384c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000384c:	711d                	addi	sp,sp,-96
    8000384e:	ec86                	sd	ra,88(sp)
    80003850:	e8a2                	sd	s0,80(sp)
    80003852:	e4a6                	sd	s1,72(sp)
    80003854:	e0ca                	sd	s2,64(sp)
    80003856:	fc4e                	sd	s3,56(sp)
    80003858:	f852                	sd	s4,48(sp)
    8000385a:	f456                	sd	s5,40(sp)
    8000385c:	1080                	addi	s0,sp,96
    8000385e:	84aa                	mv	s1,a0
    80003860:	8aae                	mv	s5,a1
    80003862:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003864:	d44fd0ef          	jal	80000da8 <myproc>
    80003868:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000386a:	8526                	mv	a0,s1
    8000386c:	7e5010ef          	jal	80005850 <acquire>
  while(i < n){
    80003870:	0b405a63          	blez	s4,80003924 <pipewrite+0xd8>
    80003874:	f05a                	sd	s6,32(sp)
    80003876:	ec5e                	sd	s7,24(sp)
    80003878:	e862                	sd	s8,16(sp)
  int i = 0;
    8000387a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000387c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000387e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003882:	21c48b93          	addi	s7,s1,540
    80003886:	a81d                	j	800038bc <pipewrite+0x70>
      release(&pi->lock);
    80003888:	8526                	mv	a0,s1
    8000388a:	05e020ef          	jal	800058e8 <release>
      return -1;
    8000388e:	597d                	li	s2,-1
    80003890:	7b02                	ld	s6,32(sp)
    80003892:	6be2                	ld	s7,24(sp)
    80003894:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003896:	854a                	mv	a0,s2
    80003898:	60e6                	ld	ra,88(sp)
    8000389a:	6446                	ld	s0,80(sp)
    8000389c:	64a6                	ld	s1,72(sp)
    8000389e:	6906                	ld	s2,64(sp)
    800038a0:	79e2                	ld	s3,56(sp)
    800038a2:	7a42                	ld	s4,48(sp)
    800038a4:	7aa2                	ld	s5,40(sp)
    800038a6:	6125                	addi	sp,sp,96
    800038a8:	8082                	ret
      wakeup(&pi->nread);
    800038aa:	8562                	mv	a0,s8
    800038ac:	b1ffd0ef          	jal	800013ca <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800038b0:	85a6                	mv	a1,s1
    800038b2:	855e                	mv	a0,s7
    800038b4:	acbfd0ef          	jal	8000137e <sleep>
  while(i < n){
    800038b8:	05495b63          	bge	s2,s4,8000390e <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800038bc:	2204a783          	lw	a5,544(s1)
    800038c0:	d7e1                	beqz	a5,80003888 <pipewrite+0x3c>
    800038c2:	854e                	mv	a0,s3
    800038c4:	cf3fd0ef          	jal	800015b6 <killed>
    800038c8:	f161                	bnez	a0,80003888 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800038ca:	2184a783          	lw	a5,536(s1)
    800038ce:	21c4a703          	lw	a4,540(s1)
    800038d2:	2007879b          	addiw	a5,a5,512
    800038d6:	fcf70ae3          	beq	a4,a5,800038aa <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038da:	4685                	li	a3,1
    800038dc:	01590633          	add	a2,s2,s5
    800038e0:	faf40593          	addi	a1,s0,-81
    800038e4:	0509b503          	ld	a0,80(s3)
    800038e8:	a08fd0ef          	jal	80000af0 <copyin>
    800038ec:	03650e63          	beq	a0,s6,80003928 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800038f0:	21c4a783          	lw	a5,540(s1)
    800038f4:	0017871b          	addiw	a4,a5,1
    800038f8:	20e4ae23          	sw	a4,540(s1)
    800038fc:	1ff7f793          	andi	a5,a5,511
    80003900:	97a6                	add	a5,a5,s1
    80003902:	faf44703          	lbu	a4,-81(s0)
    80003906:	00e78c23          	sb	a4,24(a5)
      i++;
    8000390a:	2905                	addiw	s2,s2,1
    8000390c:	b775                	j	800038b8 <pipewrite+0x6c>
    8000390e:	7b02                	ld	s6,32(sp)
    80003910:	6be2                	ld	s7,24(sp)
    80003912:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003914:	21848513          	addi	a0,s1,536
    80003918:	ab3fd0ef          	jal	800013ca <wakeup>
  release(&pi->lock);
    8000391c:	8526                	mv	a0,s1
    8000391e:	7cb010ef          	jal	800058e8 <release>
  return i;
    80003922:	bf95                	j	80003896 <pipewrite+0x4a>
  int i = 0;
    80003924:	4901                	li	s2,0
    80003926:	b7fd                	j	80003914 <pipewrite+0xc8>
    80003928:	7b02                	ld	s6,32(sp)
    8000392a:	6be2                	ld	s7,24(sp)
    8000392c:	6c42                	ld	s8,16(sp)
    8000392e:	b7dd                	j	80003914 <pipewrite+0xc8>

0000000080003930 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003930:	715d                	addi	sp,sp,-80
    80003932:	e486                	sd	ra,72(sp)
    80003934:	e0a2                	sd	s0,64(sp)
    80003936:	fc26                	sd	s1,56(sp)
    80003938:	f84a                	sd	s2,48(sp)
    8000393a:	f44e                	sd	s3,40(sp)
    8000393c:	f052                	sd	s4,32(sp)
    8000393e:	ec56                	sd	s5,24(sp)
    80003940:	0880                	addi	s0,sp,80
    80003942:	84aa                	mv	s1,a0
    80003944:	892e                	mv	s2,a1
    80003946:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003948:	c60fd0ef          	jal	80000da8 <myproc>
    8000394c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000394e:	8526                	mv	a0,s1
    80003950:	701010ef          	jal	80005850 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003954:	2184a703          	lw	a4,536(s1)
    80003958:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000395c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003960:	02f71563          	bne	a4,a5,8000398a <piperead+0x5a>
    80003964:	2244a783          	lw	a5,548(s1)
    80003968:	cb85                	beqz	a5,80003998 <piperead+0x68>
    if(killed(pr)){
    8000396a:	8552                	mv	a0,s4
    8000396c:	c4bfd0ef          	jal	800015b6 <killed>
    80003970:	ed19                	bnez	a0,8000398e <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003972:	85a6                	mv	a1,s1
    80003974:	854e                	mv	a0,s3
    80003976:	a09fd0ef          	jal	8000137e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000397a:	2184a703          	lw	a4,536(s1)
    8000397e:	21c4a783          	lw	a5,540(s1)
    80003982:	fef701e3          	beq	a4,a5,80003964 <piperead+0x34>
    80003986:	e85a                	sd	s6,16(sp)
    80003988:	a809                	j	8000399a <piperead+0x6a>
    8000398a:	e85a                	sd	s6,16(sp)
    8000398c:	a039                	j	8000399a <piperead+0x6a>
      release(&pi->lock);
    8000398e:	8526                	mv	a0,s1
    80003990:	759010ef          	jal	800058e8 <release>
      return -1;
    80003994:	59fd                	li	s3,-1
    80003996:	a8b1                	j	800039f2 <piperead+0xc2>
    80003998:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000399a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000399c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000399e:	05505263          	blez	s5,800039e2 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800039a2:	2184a783          	lw	a5,536(s1)
    800039a6:	21c4a703          	lw	a4,540(s1)
    800039aa:	02f70c63          	beq	a4,a5,800039e2 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800039ae:	0017871b          	addiw	a4,a5,1
    800039b2:	20e4ac23          	sw	a4,536(s1)
    800039b6:	1ff7f793          	andi	a5,a5,511
    800039ba:	97a6                	add	a5,a5,s1
    800039bc:	0187c783          	lbu	a5,24(a5)
    800039c0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039c4:	4685                	li	a3,1
    800039c6:	fbf40613          	addi	a2,s0,-65
    800039ca:	85ca                	mv	a1,s2
    800039cc:	050a3503          	ld	a0,80(s4)
    800039d0:	84afd0ef          	jal	80000a1a <copyout>
    800039d4:	01650763          	beq	a0,s6,800039e2 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039d8:	2985                	addiw	s3,s3,1
    800039da:	0905                	addi	s2,s2,1
    800039dc:	fd3a93e3          	bne	s5,s3,800039a2 <piperead+0x72>
    800039e0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800039e2:	21c48513          	addi	a0,s1,540
    800039e6:	9e5fd0ef          	jal	800013ca <wakeup>
  release(&pi->lock);
    800039ea:	8526                	mv	a0,s1
    800039ec:	6fd010ef          	jal	800058e8 <release>
    800039f0:	6b42                	ld	s6,16(sp)
  return i;
}
    800039f2:	854e                	mv	a0,s3
    800039f4:	60a6                	ld	ra,72(sp)
    800039f6:	6406                	ld	s0,64(sp)
    800039f8:	74e2                	ld	s1,56(sp)
    800039fa:	7942                	ld	s2,48(sp)
    800039fc:	79a2                	ld	s3,40(sp)
    800039fe:	7a02                	ld	s4,32(sp)
    80003a00:	6ae2                	ld	s5,24(sp)
    80003a02:	6161                	addi	sp,sp,80
    80003a04:	8082                	ret

0000000080003a06 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003a06:	1141                	addi	sp,sp,-16
    80003a08:	e422                	sd	s0,8(sp)
    80003a0a:	0800                	addi	s0,sp,16
    80003a0c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a0e:	8905                	andi	a0,a0,1
    80003a10:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003a12:	8b89                	andi	a5,a5,2
    80003a14:	c399                	beqz	a5,80003a1a <flags2perm+0x14>
      perm |= PTE_W;
    80003a16:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a1a:	6422                	ld	s0,8(sp)
    80003a1c:	0141                	addi	sp,sp,16
    80003a1e:	8082                	ret

0000000080003a20 <exec>:

int
exec(char *path, char **argv)
{
    80003a20:	df010113          	addi	sp,sp,-528
    80003a24:	20113423          	sd	ra,520(sp)
    80003a28:	20813023          	sd	s0,512(sp)
    80003a2c:	ffa6                	sd	s1,504(sp)
    80003a2e:	fbca                	sd	s2,496(sp)
    80003a30:	0c00                	addi	s0,sp,528
    80003a32:	892a                	mv	s2,a0
    80003a34:	dea43c23          	sd	a0,-520(s0)
    80003a38:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a3c:	b6cfd0ef          	jal	80000da8 <myproc>
    80003a40:	84aa                	mv	s1,a0

  begin_op();
    80003a42:	dc6ff0ef          	jal	80003008 <begin_op>

  if((ip = namei(path)) == 0){
    80003a46:	854a                	mv	a0,s2
    80003a48:	c04ff0ef          	jal	80002e4c <namei>
    80003a4c:	c931                	beqz	a0,80003aa0 <exec+0x80>
    80003a4e:	f3d2                	sd	s4,480(sp)
    80003a50:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003a52:	d21fe0ef          	jal	80002772 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003a56:	04000713          	li	a4,64
    80003a5a:	4681                	li	a3,0
    80003a5c:	e5040613          	addi	a2,s0,-432
    80003a60:	4581                	li	a1,0
    80003a62:	8552                	mv	a0,s4
    80003a64:	f63fe0ef          	jal	800029c6 <readi>
    80003a68:	04000793          	li	a5,64
    80003a6c:	00f51a63          	bne	a0,a5,80003a80 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003a70:	e5042703          	lw	a4,-432(s0)
    80003a74:	464c47b7          	lui	a5,0x464c4
    80003a78:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003a7c:	02f70663          	beq	a4,a5,80003aa8 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003a80:	8552                	mv	a0,s4
    80003a82:	efbfe0ef          	jal	8000297c <iunlockput>
    end_op();
    80003a86:	decff0ef          	jal	80003072 <end_op>
  }
  return -1;
    80003a8a:	557d                	li	a0,-1
    80003a8c:	7a1e                	ld	s4,480(sp)
}
    80003a8e:	20813083          	ld	ra,520(sp)
    80003a92:	20013403          	ld	s0,512(sp)
    80003a96:	74fe                	ld	s1,504(sp)
    80003a98:	795e                	ld	s2,496(sp)
    80003a9a:	21010113          	addi	sp,sp,528
    80003a9e:	8082                	ret
    end_op();
    80003aa0:	dd2ff0ef          	jal	80003072 <end_op>
    return -1;
    80003aa4:	557d                	li	a0,-1
    80003aa6:	b7e5                	j	80003a8e <exec+0x6e>
    80003aa8:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003aaa:	8526                	mv	a0,s1
    80003aac:	ba4fd0ef          	jal	80000e50 <proc_pagetable>
    80003ab0:	8b2a                	mv	s6,a0
    80003ab2:	2c050b63          	beqz	a0,80003d88 <exec+0x368>
    80003ab6:	f7ce                	sd	s3,488(sp)
    80003ab8:	efd6                	sd	s5,472(sp)
    80003aba:	e7de                	sd	s7,456(sp)
    80003abc:	e3e2                	sd	s8,448(sp)
    80003abe:	ff66                	sd	s9,440(sp)
    80003ac0:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ac2:	e7042d03          	lw	s10,-400(s0)
    80003ac6:	e8845783          	lhu	a5,-376(s0)
    80003aca:	12078963          	beqz	a5,80003bfc <exec+0x1dc>
    80003ace:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ad0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ad2:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003ad4:	6c85                	lui	s9,0x1
    80003ad6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003ada:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003ade:	6a85                	lui	s5,0x1
    80003ae0:	a085                	j	80003b40 <exec+0x120>
      panic("loadseg: address should exist");
    80003ae2:	00004517          	auipc	a0,0x4
    80003ae6:	b7e50513          	addi	a0,a0,-1154 # 80007660 <etext+0x660>
    80003aea:	239010ef          	jal	80005522 <panic>
    if(sz - i < PGSIZE)
    80003aee:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003af0:	8726                	mv	a4,s1
    80003af2:	012c06bb          	addw	a3,s8,s2
    80003af6:	4581                	li	a1,0
    80003af8:	8552                	mv	a0,s4
    80003afa:	ecdfe0ef          	jal	800029c6 <readi>
    80003afe:	2501                	sext.w	a0,a0
    80003b00:	24a49a63          	bne	s1,a0,80003d54 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003b04:	012a893b          	addw	s2,s5,s2
    80003b08:	03397363          	bgeu	s2,s3,80003b2e <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003b0c:	02091593          	slli	a1,s2,0x20
    80003b10:	9181                	srli	a1,a1,0x20
    80003b12:	95de                	add	a1,a1,s7
    80003b14:	855a                	mv	a0,s6
    80003b16:	989fc0ef          	jal	8000049e <walkaddr>
    80003b1a:	862a                	mv	a2,a0
    if(pa == 0)
    80003b1c:	d179                	beqz	a0,80003ae2 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003b1e:	412984bb          	subw	s1,s3,s2
    80003b22:	0004879b          	sext.w	a5,s1
    80003b26:	fcfcf4e3          	bgeu	s9,a5,80003aee <exec+0xce>
    80003b2a:	84d6                	mv	s1,s5
    80003b2c:	b7c9                	j	80003aee <exec+0xce>
    sz = sz1;
    80003b2e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b32:	2d85                	addiw	s11,s11,1
    80003b34:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003b38:	e8845783          	lhu	a5,-376(s0)
    80003b3c:	08fdd063          	bge	s11,a5,80003bbc <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b40:	2d01                	sext.w	s10,s10
    80003b42:	03800713          	li	a4,56
    80003b46:	86ea                	mv	a3,s10
    80003b48:	e1840613          	addi	a2,s0,-488
    80003b4c:	4581                	li	a1,0
    80003b4e:	8552                	mv	a0,s4
    80003b50:	e77fe0ef          	jal	800029c6 <readi>
    80003b54:	03800793          	li	a5,56
    80003b58:	1cf51663          	bne	a0,a5,80003d24 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003b5c:	e1842783          	lw	a5,-488(s0)
    80003b60:	4705                	li	a4,1
    80003b62:	fce798e3          	bne	a5,a4,80003b32 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003b66:	e4043483          	ld	s1,-448(s0)
    80003b6a:	e3843783          	ld	a5,-456(s0)
    80003b6e:	1af4ef63          	bltu	s1,a5,80003d2c <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003b72:	e2843783          	ld	a5,-472(s0)
    80003b76:	94be                	add	s1,s1,a5
    80003b78:	1af4ee63          	bltu	s1,a5,80003d34 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003b7c:	df043703          	ld	a4,-528(s0)
    80003b80:	8ff9                	and	a5,a5,a4
    80003b82:	1a079d63          	bnez	a5,80003d3c <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b86:	e1c42503          	lw	a0,-484(s0)
    80003b8a:	e7dff0ef          	jal	80003a06 <flags2perm>
    80003b8e:	86aa                	mv	a3,a0
    80003b90:	8626                	mv	a2,s1
    80003b92:	85ca                	mv	a1,s2
    80003b94:	855a                	mv	a0,s6
    80003b96:	c71fc0ef          	jal	80000806 <uvmalloc>
    80003b9a:	e0a43423          	sd	a0,-504(s0)
    80003b9e:	1a050363          	beqz	a0,80003d44 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003ba2:	e2843b83          	ld	s7,-472(s0)
    80003ba6:	e2042c03          	lw	s8,-480(s0)
    80003baa:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003bae:	00098463          	beqz	s3,80003bb6 <exec+0x196>
    80003bb2:	4901                	li	s2,0
    80003bb4:	bfa1                	j	80003b0c <exec+0xec>
    sz = sz1;
    80003bb6:	e0843903          	ld	s2,-504(s0)
    80003bba:	bfa5                	j	80003b32 <exec+0x112>
    80003bbc:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003bbe:	8552                	mv	a0,s4
    80003bc0:	dbdfe0ef          	jal	8000297c <iunlockput>
  end_op();
    80003bc4:	caeff0ef          	jal	80003072 <end_op>
  p = myproc();
    80003bc8:	9e0fd0ef          	jal	80000da8 <myproc>
    80003bcc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003bce:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003bd2:	6985                	lui	s3,0x1
    80003bd4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003bd6:	99ca                	add	s3,s3,s2
    80003bd8:	77fd                	lui	a5,0xfffff
    80003bda:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003bde:	4691                	li	a3,4
    80003be0:	660d                	lui	a2,0x3
    80003be2:	964e                	add	a2,a2,s3
    80003be4:	85ce                	mv	a1,s3
    80003be6:	855a                	mv	a0,s6
    80003be8:	c1ffc0ef          	jal	80000806 <uvmalloc>
    80003bec:	892a                	mv	s2,a0
    80003bee:	e0a43423          	sd	a0,-504(s0)
    80003bf2:	e519                	bnez	a0,80003c00 <exec+0x1e0>
  if(pagetable)
    80003bf4:	e1343423          	sd	s3,-504(s0)
    80003bf8:	4a01                	li	s4,0
    80003bfa:	aab1                	j	80003d56 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003bfc:	4901                	li	s2,0
    80003bfe:	b7c1                	j	80003bbe <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c00:	75f5                	lui	a1,0xffffd
    80003c02:	95aa                	add	a1,a1,a0
    80003c04:	855a                	mv	a0,s6
    80003c06:	debfc0ef          	jal	800009f0 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c0a:	7bf9                	lui	s7,0xffffe
    80003c0c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003c0e:	e0043783          	ld	a5,-512(s0)
    80003c12:	6388                	ld	a0,0(a5)
    80003c14:	cd39                	beqz	a0,80003c72 <exec+0x252>
    80003c16:	e9040993          	addi	s3,s0,-368
    80003c1a:	f9040c13          	addi	s8,s0,-112
    80003c1e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003c20:	ee0fc0ef          	jal	80000300 <strlen>
    80003c24:	0015079b          	addiw	a5,a0,1
    80003c28:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c2c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c30:	11796e63          	bltu	s2,s7,80003d4c <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c34:	e0043d03          	ld	s10,-512(s0)
    80003c38:	000d3a03          	ld	s4,0(s10)
    80003c3c:	8552                	mv	a0,s4
    80003c3e:	ec2fc0ef          	jal	80000300 <strlen>
    80003c42:	0015069b          	addiw	a3,a0,1
    80003c46:	8652                	mv	a2,s4
    80003c48:	85ca                	mv	a1,s2
    80003c4a:	855a                	mv	a0,s6
    80003c4c:	dcffc0ef          	jal	80000a1a <copyout>
    80003c50:	10054063          	bltz	a0,80003d50 <exec+0x330>
    ustack[argc] = sp;
    80003c54:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003c58:	0485                	addi	s1,s1,1
    80003c5a:	008d0793          	addi	a5,s10,8
    80003c5e:	e0f43023          	sd	a5,-512(s0)
    80003c62:	008d3503          	ld	a0,8(s10)
    80003c66:	c909                	beqz	a0,80003c78 <exec+0x258>
    if(argc >= MAXARG)
    80003c68:	09a1                	addi	s3,s3,8
    80003c6a:	fb899be3          	bne	s3,s8,80003c20 <exec+0x200>
  ip = 0;
    80003c6e:	4a01                	li	s4,0
    80003c70:	a0dd                	j	80003d56 <exec+0x336>
  sp = sz;
    80003c72:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003c76:	4481                	li	s1,0
  ustack[argc] = 0;
    80003c78:	00349793          	slli	a5,s1,0x3
    80003c7c:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb800>
    80003c80:	97a2                	add	a5,a5,s0
    80003c82:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003c86:	00148693          	addi	a3,s1,1
    80003c8a:	068e                	slli	a3,a3,0x3
    80003c8c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003c90:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003c94:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003c98:	f5796ee3          	bltu	s2,s7,80003bf4 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003c9c:	e9040613          	addi	a2,s0,-368
    80003ca0:	85ca                	mv	a1,s2
    80003ca2:	855a                	mv	a0,s6
    80003ca4:	d77fc0ef          	jal	80000a1a <copyout>
    80003ca8:	0e054263          	bltz	a0,80003d8c <exec+0x36c>
  p->trapframe->a1 = sp;
    80003cac:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003cb0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003cb4:	df843783          	ld	a5,-520(s0)
    80003cb8:	0007c703          	lbu	a4,0(a5)
    80003cbc:	cf11                	beqz	a4,80003cd8 <exec+0x2b8>
    80003cbe:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003cc0:	02f00693          	li	a3,47
    80003cc4:	a039                	j	80003cd2 <exec+0x2b2>
      last = s+1;
    80003cc6:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003cca:	0785                	addi	a5,a5,1
    80003ccc:	fff7c703          	lbu	a4,-1(a5)
    80003cd0:	c701                	beqz	a4,80003cd8 <exec+0x2b8>
    if(*s == '/')
    80003cd2:	fed71ce3          	bne	a4,a3,80003cca <exec+0x2aa>
    80003cd6:	bfc5                	j	80003cc6 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003cd8:	4641                	li	a2,16
    80003cda:	df843583          	ld	a1,-520(s0)
    80003cde:	158a8513          	addi	a0,s5,344
    80003ce2:	decfc0ef          	jal	800002ce <safestrcpy>
  oldpagetable = p->pagetable;
    80003ce6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003cea:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003cee:	e0843783          	ld	a5,-504(s0)
    80003cf2:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003cf6:	058ab783          	ld	a5,88(s5)
    80003cfa:	e6843703          	ld	a4,-408(s0)
    80003cfe:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d00:	058ab783          	ld	a5,88(s5)
    80003d04:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d08:	85e6                	mv	a1,s9
    80003d0a:	9cafd0ef          	jal	80000ed4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d0e:	0004851b          	sext.w	a0,s1
    80003d12:	79be                	ld	s3,488(sp)
    80003d14:	7a1e                	ld	s4,480(sp)
    80003d16:	6afe                	ld	s5,472(sp)
    80003d18:	6b5e                	ld	s6,464(sp)
    80003d1a:	6bbe                	ld	s7,456(sp)
    80003d1c:	6c1e                	ld	s8,448(sp)
    80003d1e:	7cfa                	ld	s9,440(sp)
    80003d20:	7d5a                	ld	s10,432(sp)
    80003d22:	b3b5                	j	80003a8e <exec+0x6e>
    80003d24:	e1243423          	sd	s2,-504(s0)
    80003d28:	7dba                	ld	s11,424(sp)
    80003d2a:	a035                	j	80003d56 <exec+0x336>
    80003d2c:	e1243423          	sd	s2,-504(s0)
    80003d30:	7dba                	ld	s11,424(sp)
    80003d32:	a015                	j	80003d56 <exec+0x336>
    80003d34:	e1243423          	sd	s2,-504(s0)
    80003d38:	7dba                	ld	s11,424(sp)
    80003d3a:	a831                	j	80003d56 <exec+0x336>
    80003d3c:	e1243423          	sd	s2,-504(s0)
    80003d40:	7dba                	ld	s11,424(sp)
    80003d42:	a811                	j	80003d56 <exec+0x336>
    80003d44:	e1243423          	sd	s2,-504(s0)
    80003d48:	7dba                	ld	s11,424(sp)
    80003d4a:	a031                	j	80003d56 <exec+0x336>
  ip = 0;
    80003d4c:	4a01                	li	s4,0
    80003d4e:	a021                	j	80003d56 <exec+0x336>
    80003d50:	4a01                	li	s4,0
  if(pagetable)
    80003d52:	a011                	j	80003d56 <exec+0x336>
    80003d54:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003d56:	e0843583          	ld	a1,-504(s0)
    80003d5a:	855a                	mv	a0,s6
    80003d5c:	978fd0ef          	jal	80000ed4 <proc_freepagetable>
  return -1;
    80003d60:	557d                	li	a0,-1
  if(ip){
    80003d62:	000a1b63          	bnez	s4,80003d78 <exec+0x358>
    80003d66:	79be                	ld	s3,488(sp)
    80003d68:	7a1e                	ld	s4,480(sp)
    80003d6a:	6afe                	ld	s5,472(sp)
    80003d6c:	6b5e                	ld	s6,464(sp)
    80003d6e:	6bbe                	ld	s7,456(sp)
    80003d70:	6c1e                	ld	s8,448(sp)
    80003d72:	7cfa                	ld	s9,440(sp)
    80003d74:	7d5a                	ld	s10,432(sp)
    80003d76:	bb21                	j	80003a8e <exec+0x6e>
    80003d78:	79be                	ld	s3,488(sp)
    80003d7a:	6afe                	ld	s5,472(sp)
    80003d7c:	6b5e                	ld	s6,464(sp)
    80003d7e:	6bbe                	ld	s7,456(sp)
    80003d80:	6c1e                	ld	s8,448(sp)
    80003d82:	7cfa                	ld	s9,440(sp)
    80003d84:	7d5a                	ld	s10,432(sp)
    80003d86:	b9ed                	j	80003a80 <exec+0x60>
    80003d88:	6b5e                	ld	s6,464(sp)
    80003d8a:	b9dd                	j	80003a80 <exec+0x60>
  sz = sz1;
    80003d8c:	e0843983          	ld	s3,-504(s0)
    80003d90:	b595                	j	80003bf4 <exec+0x1d4>

0000000080003d92 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003d92:	7179                	addi	sp,sp,-48
    80003d94:	f406                	sd	ra,40(sp)
    80003d96:	f022                	sd	s0,32(sp)
    80003d98:	ec26                	sd	s1,24(sp)
    80003d9a:	e84a                	sd	s2,16(sp)
    80003d9c:	1800                	addi	s0,sp,48
    80003d9e:	892e                	mv	s2,a1
    80003da0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003da2:	fdc40593          	addi	a1,s0,-36
    80003da6:	f0bfd0ef          	jal	80001cb0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003daa:	fdc42703          	lw	a4,-36(s0)
    80003dae:	47bd                	li	a5,15
    80003db0:	02e7e963          	bltu	a5,a4,80003de2 <argfd+0x50>
    80003db4:	ff5fc0ef          	jal	80000da8 <myproc>
    80003db8:	fdc42703          	lw	a4,-36(s0)
    80003dbc:	01a70793          	addi	a5,a4,26
    80003dc0:	078e                	slli	a5,a5,0x3
    80003dc2:	953e                	add	a0,a0,a5
    80003dc4:	611c                	ld	a5,0(a0)
    80003dc6:	c385                	beqz	a5,80003de6 <argfd+0x54>
    return -1;
  if(pfd)
    80003dc8:	00090463          	beqz	s2,80003dd0 <argfd+0x3e>
    *pfd = fd;
    80003dcc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003dd0:	4501                	li	a0,0
  if(pf)
    80003dd2:	c091                	beqz	s1,80003dd6 <argfd+0x44>
    *pf = f;
    80003dd4:	e09c                	sd	a5,0(s1)
}
    80003dd6:	70a2                	ld	ra,40(sp)
    80003dd8:	7402                	ld	s0,32(sp)
    80003dda:	64e2                	ld	s1,24(sp)
    80003ddc:	6942                	ld	s2,16(sp)
    80003dde:	6145                	addi	sp,sp,48
    80003de0:	8082                	ret
    return -1;
    80003de2:	557d                	li	a0,-1
    80003de4:	bfcd                	j	80003dd6 <argfd+0x44>
    80003de6:	557d                	li	a0,-1
    80003de8:	b7fd                	j	80003dd6 <argfd+0x44>

0000000080003dea <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003dea:	1101                	addi	sp,sp,-32
    80003dec:	ec06                	sd	ra,24(sp)
    80003dee:	e822                	sd	s0,16(sp)
    80003df0:	e426                	sd	s1,8(sp)
    80003df2:	1000                	addi	s0,sp,32
    80003df4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003df6:	fb3fc0ef          	jal	80000da8 <myproc>
    80003dfa:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003dfc:	0d050793          	addi	a5,a0,208
    80003e00:	4501                	li	a0,0
    80003e02:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e04:	6398                	ld	a4,0(a5)
    80003e06:	cb19                	beqz	a4,80003e1c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e08:	2505                	addiw	a0,a0,1
    80003e0a:	07a1                	addi	a5,a5,8
    80003e0c:	fed51ce3          	bne	a0,a3,80003e04 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e10:	557d                	li	a0,-1
}
    80003e12:	60e2                	ld	ra,24(sp)
    80003e14:	6442                	ld	s0,16(sp)
    80003e16:	64a2                	ld	s1,8(sp)
    80003e18:	6105                	addi	sp,sp,32
    80003e1a:	8082                	ret
      p->ofile[fd] = f;
    80003e1c:	01a50793          	addi	a5,a0,26
    80003e20:	078e                	slli	a5,a5,0x3
    80003e22:	963e                	add	a2,a2,a5
    80003e24:	e204                	sd	s1,0(a2)
      return fd;
    80003e26:	b7f5                	j	80003e12 <fdalloc+0x28>

0000000080003e28 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e28:	715d                	addi	sp,sp,-80
    80003e2a:	e486                	sd	ra,72(sp)
    80003e2c:	e0a2                	sd	s0,64(sp)
    80003e2e:	fc26                	sd	s1,56(sp)
    80003e30:	f84a                	sd	s2,48(sp)
    80003e32:	f44e                	sd	s3,40(sp)
    80003e34:	ec56                	sd	s5,24(sp)
    80003e36:	e85a                	sd	s6,16(sp)
    80003e38:	0880                	addi	s0,sp,80
    80003e3a:	8b2e                	mv	s6,a1
    80003e3c:	89b2                	mv	s3,a2
    80003e3e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e40:	fb040593          	addi	a1,s0,-80
    80003e44:	822ff0ef          	jal	80002e66 <nameiparent>
    80003e48:	84aa                	mv	s1,a0
    80003e4a:	10050a63          	beqz	a0,80003f5e <create+0x136>
    return 0;

  ilock(dp);
    80003e4e:	925fe0ef          	jal	80002772 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e52:	4601                	li	a2,0
    80003e54:	fb040593          	addi	a1,s0,-80
    80003e58:	8526                	mv	a0,s1
    80003e5a:	d8dfe0ef          	jal	80002be6 <dirlookup>
    80003e5e:	8aaa                	mv	s5,a0
    80003e60:	c129                	beqz	a0,80003ea2 <create+0x7a>
    iunlockput(dp);
    80003e62:	8526                	mv	a0,s1
    80003e64:	b19fe0ef          	jal	8000297c <iunlockput>
    ilock(ip);
    80003e68:	8556                	mv	a0,s5
    80003e6a:	909fe0ef          	jal	80002772 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003e6e:	4789                	li	a5,2
    80003e70:	02fb1463          	bne	s6,a5,80003e98 <create+0x70>
    80003e74:	044ad783          	lhu	a5,68(s5)
    80003e78:	37f9                	addiw	a5,a5,-2
    80003e7a:	17c2                	slli	a5,a5,0x30
    80003e7c:	93c1                	srli	a5,a5,0x30
    80003e7e:	4705                	li	a4,1
    80003e80:	00f76c63          	bltu	a4,a5,80003e98 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003e84:	8556                	mv	a0,s5
    80003e86:	60a6                	ld	ra,72(sp)
    80003e88:	6406                	ld	s0,64(sp)
    80003e8a:	74e2                	ld	s1,56(sp)
    80003e8c:	7942                	ld	s2,48(sp)
    80003e8e:	79a2                	ld	s3,40(sp)
    80003e90:	6ae2                	ld	s5,24(sp)
    80003e92:	6b42                	ld	s6,16(sp)
    80003e94:	6161                	addi	sp,sp,80
    80003e96:	8082                	ret
    iunlockput(ip);
    80003e98:	8556                	mv	a0,s5
    80003e9a:	ae3fe0ef          	jal	8000297c <iunlockput>
    return 0;
    80003e9e:	4a81                	li	s5,0
    80003ea0:	b7d5                	j	80003e84 <create+0x5c>
    80003ea2:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003ea4:	85da                	mv	a1,s6
    80003ea6:	4088                	lw	a0,0(s1)
    80003ea8:	f5afe0ef          	jal	80002602 <ialloc>
    80003eac:	8a2a                	mv	s4,a0
    80003eae:	cd15                	beqz	a0,80003eea <create+0xc2>
  ilock(ip);
    80003eb0:	8c3fe0ef          	jal	80002772 <ilock>
  ip->major = major;
    80003eb4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003eb8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003ebc:	4905                	li	s2,1
    80003ebe:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003ec2:	8552                	mv	a0,s4
    80003ec4:	ffafe0ef          	jal	800026be <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003ec8:	032b0763          	beq	s6,s2,80003ef6 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003ecc:	004a2603          	lw	a2,4(s4)
    80003ed0:	fb040593          	addi	a1,s0,-80
    80003ed4:	8526                	mv	a0,s1
    80003ed6:	eddfe0ef          	jal	80002db2 <dirlink>
    80003eda:	06054563          	bltz	a0,80003f44 <create+0x11c>
  iunlockput(dp);
    80003ede:	8526                	mv	a0,s1
    80003ee0:	a9dfe0ef          	jal	8000297c <iunlockput>
  return ip;
    80003ee4:	8ad2                	mv	s5,s4
    80003ee6:	7a02                	ld	s4,32(sp)
    80003ee8:	bf71                	j	80003e84 <create+0x5c>
    iunlockput(dp);
    80003eea:	8526                	mv	a0,s1
    80003eec:	a91fe0ef          	jal	8000297c <iunlockput>
    return 0;
    80003ef0:	8ad2                	mv	s5,s4
    80003ef2:	7a02                	ld	s4,32(sp)
    80003ef4:	bf41                	j	80003e84 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003ef6:	004a2603          	lw	a2,4(s4)
    80003efa:	00003597          	auipc	a1,0x3
    80003efe:	78658593          	addi	a1,a1,1926 # 80007680 <etext+0x680>
    80003f02:	8552                	mv	a0,s4
    80003f04:	eaffe0ef          	jal	80002db2 <dirlink>
    80003f08:	02054e63          	bltz	a0,80003f44 <create+0x11c>
    80003f0c:	40d0                	lw	a2,4(s1)
    80003f0e:	00003597          	auipc	a1,0x3
    80003f12:	77a58593          	addi	a1,a1,1914 # 80007688 <etext+0x688>
    80003f16:	8552                	mv	a0,s4
    80003f18:	e9bfe0ef          	jal	80002db2 <dirlink>
    80003f1c:	02054463          	bltz	a0,80003f44 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f20:	004a2603          	lw	a2,4(s4)
    80003f24:	fb040593          	addi	a1,s0,-80
    80003f28:	8526                	mv	a0,s1
    80003f2a:	e89fe0ef          	jal	80002db2 <dirlink>
    80003f2e:	00054b63          	bltz	a0,80003f44 <create+0x11c>
    dp->nlink++;  // for ".."
    80003f32:	04a4d783          	lhu	a5,74(s1)
    80003f36:	2785                	addiw	a5,a5,1
    80003f38:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	f80fe0ef          	jal	800026be <iupdate>
    80003f42:	bf71                	j	80003ede <create+0xb6>
  ip->nlink = 0;
    80003f44:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f48:	8552                	mv	a0,s4
    80003f4a:	f74fe0ef          	jal	800026be <iupdate>
  iunlockput(ip);
    80003f4e:	8552                	mv	a0,s4
    80003f50:	a2dfe0ef          	jal	8000297c <iunlockput>
  iunlockput(dp);
    80003f54:	8526                	mv	a0,s1
    80003f56:	a27fe0ef          	jal	8000297c <iunlockput>
  return 0;
    80003f5a:	7a02                	ld	s4,32(sp)
    80003f5c:	b725                	j	80003e84 <create+0x5c>
    return 0;
    80003f5e:	8aaa                	mv	s5,a0
    80003f60:	b715                	j	80003e84 <create+0x5c>

0000000080003f62 <sys_dup>:
{
    80003f62:	7179                	addi	sp,sp,-48
    80003f64:	f406                	sd	ra,40(sp)
    80003f66:	f022                	sd	s0,32(sp)
    80003f68:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003f6a:	fd840613          	addi	a2,s0,-40
    80003f6e:	4581                	li	a1,0
    80003f70:	4501                	li	a0,0
    80003f72:	e21ff0ef          	jal	80003d92 <argfd>
    return -1;
    80003f76:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003f78:	02054363          	bltz	a0,80003f9e <sys_dup+0x3c>
    80003f7c:	ec26                	sd	s1,24(sp)
    80003f7e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003f80:	fd843903          	ld	s2,-40(s0)
    80003f84:	854a                	mv	a0,s2
    80003f86:	e65ff0ef          	jal	80003dea <fdalloc>
    80003f8a:	84aa                	mv	s1,a0
    return -1;
    80003f8c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003f8e:	00054d63          	bltz	a0,80003fa8 <sys_dup+0x46>
  filedup(f);
    80003f92:	854a                	mv	a0,s2
    80003f94:	c48ff0ef          	jal	800033dc <filedup>
  return fd;
    80003f98:	87a6                	mv	a5,s1
    80003f9a:	64e2                	ld	s1,24(sp)
    80003f9c:	6942                	ld	s2,16(sp)
}
    80003f9e:	853e                	mv	a0,a5
    80003fa0:	70a2                	ld	ra,40(sp)
    80003fa2:	7402                	ld	s0,32(sp)
    80003fa4:	6145                	addi	sp,sp,48
    80003fa6:	8082                	ret
    80003fa8:	64e2                	ld	s1,24(sp)
    80003faa:	6942                	ld	s2,16(sp)
    80003fac:	bfcd                	j	80003f9e <sys_dup+0x3c>

0000000080003fae <sys_read>:
{
    80003fae:	7179                	addi	sp,sp,-48
    80003fb0:	f406                	sd	ra,40(sp)
    80003fb2:	f022                	sd	s0,32(sp)
    80003fb4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003fb6:	fd840593          	addi	a1,s0,-40
    80003fba:	4505                	li	a0,1
    80003fbc:	d11fd0ef          	jal	80001ccc <argaddr>
  argint(2, &n);
    80003fc0:	fe440593          	addi	a1,s0,-28
    80003fc4:	4509                	li	a0,2
    80003fc6:	cebfd0ef          	jal	80001cb0 <argint>
  if(argfd(0, 0, &f) < 0)
    80003fca:	fe840613          	addi	a2,s0,-24
    80003fce:	4581                	li	a1,0
    80003fd0:	4501                	li	a0,0
    80003fd2:	dc1ff0ef          	jal	80003d92 <argfd>
    80003fd6:	87aa                	mv	a5,a0
    return -1;
    80003fd8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fda:	0007ca63          	bltz	a5,80003fee <sys_read+0x40>
  return fileread(f, p, n);
    80003fde:	fe442603          	lw	a2,-28(s0)
    80003fe2:	fd843583          	ld	a1,-40(s0)
    80003fe6:	fe843503          	ld	a0,-24(s0)
    80003fea:	d58ff0ef          	jal	80003542 <fileread>
}
    80003fee:	70a2                	ld	ra,40(sp)
    80003ff0:	7402                	ld	s0,32(sp)
    80003ff2:	6145                	addi	sp,sp,48
    80003ff4:	8082                	ret

0000000080003ff6 <sys_write>:
{
    80003ff6:	7179                	addi	sp,sp,-48
    80003ff8:	f406                	sd	ra,40(sp)
    80003ffa:	f022                	sd	s0,32(sp)
    80003ffc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ffe:	fd840593          	addi	a1,s0,-40
    80004002:	4505                	li	a0,1
    80004004:	cc9fd0ef          	jal	80001ccc <argaddr>
  argint(2, &n);
    80004008:	fe440593          	addi	a1,s0,-28
    8000400c:	4509                	li	a0,2
    8000400e:	ca3fd0ef          	jal	80001cb0 <argint>
  if(argfd(0, 0, &f) < 0)
    80004012:	fe840613          	addi	a2,s0,-24
    80004016:	4581                	li	a1,0
    80004018:	4501                	li	a0,0
    8000401a:	d79ff0ef          	jal	80003d92 <argfd>
    8000401e:	87aa                	mv	a5,a0
    return -1;
    80004020:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004022:	0007ca63          	bltz	a5,80004036 <sys_write+0x40>
  return filewrite(f, p, n);
    80004026:	fe442603          	lw	a2,-28(s0)
    8000402a:	fd843583          	ld	a1,-40(s0)
    8000402e:	fe843503          	ld	a0,-24(s0)
    80004032:	dceff0ef          	jal	80003600 <filewrite>
}
    80004036:	70a2                	ld	ra,40(sp)
    80004038:	7402                	ld	s0,32(sp)
    8000403a:	6145                	addi	sp,sp,48
    8000403c:	8082                	ret

000000008000403e <sys_close>:
{
    8000403e:	1101                	addi	sp,sp,-32
    80004040:	ec06                	sd	ra,24(sp)
    80004042:	e822                	sd	s0,16(sp)
    80004044:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004046:	fe040613          	addi	a2,s0,-32
    8000404a:	fec40593          	addi	a1,s0,-20
    8000404e:	4501                	li	a0,0
    80004050:	d43ff0ef          	jal	80003d92 <argfd>
    return -1;
    80004054:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004056:	02054063          	bltz	a0,80004076 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000405a:	d4ffc0ef          	jal	80000da8 <myproc>
    8000405e:	fec42783          	lw	a5,-20(s0)
    80004062:	07e9                	addi	a5,a5,26
    80004064:	078e                	slli	a5,a5,0x3
    80004066:	953e                	add	a0,a0,a5
    80004068:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000406c:	fe043503          	ld	a0,-32(s0)
    80004070:	bb2ff0ef          	jal	80003422 <fileclose>
  return 0;
    80004074:	4781                	li	a5,0
}
    80004076:	853e                	mv	a0,a5
    80004078:	60e2                	ld	ra,24(sp)
    8000407a:	6442                	ld	s0,16(sp)
    8000407c:	6105                	addi	sp,sp,32
    8000407e:	8082                	ret

0000000080004080 <sys_fstat>:
{
    80004080:	1101                	addi	sp,sp,-32
    80004082:	ec06                	sd	ra,24(sp)
    80004084:	e822                	sd	s0,16(sp)
    80004086:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004088:	fe040593          	addi	a1,s0,-32
    8000408c:	4505                	li	a0,1
    8000408e:	c3ffd0ef          	jal	80001ccc <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004092:	fe840613          	addi	a2,s0,-24
    80004096:	4581                	li	a1,0
    80004098:	4501                	li	a0,0
    8000409a:	cf9ff0ef          	jal	80003d92 <argfd>
    8000409e:	87aa                	mv	a5,a0
    return -1;
    800040a0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040a2:	0007c863          	bltz	a5,800040b2 <sys_fstat+0x32>
  return filestat(f, st);
    800040a6:	fe043583          	ld	a1,-32(s0)
    800040aa:	fe843503          	ld	a0,-24(s0)
    800040ae:	c36ff0ef          	jal	800034e4 <filestat>
}
    800040b2:	60e2                	ld	ra,24(sp)
    800040b4:	6442                	ld	s0,16(sp)
    800040b6:	6105                	addi	sp,sp,32
    800040b8:	8082                	ret

00000000800040ba <sys_link>:
{
    800040ba:	7169                	addi	sp,sp,-304
    800040bc:	f606                	sd	ra,296(sp)
    800040be:	f222                	sd	s0,288(sp)
    800040c0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040c2:	08000613          	li	a2,128
    800040c6:	ed040593          	addi	a1,s0,-304
    800040ca:	4501                	li	a0,0
    800040cc:	c1dfd0ef          	jal	80001ce8 <argstr>
    return -1;
    800040d0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040d2:	0c054e63          	bltz	a0,800041ae <sys_link+0xf4>
    800040d6:	08000613          	li	a2,128
    800040da:	f5040593          	addi	a1,s0,-176
    800040de:	4505                	li	a0,1
    800040e0:	c09fd0ef          	jal	80001ce8 <argstr>
    return -1;
    800040e4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040e6:	0c054463          	bltz	a0,800041ae <sys_link+0xf4>
    800040ea:	ee26                	sd	s1,280(sp)
  begin_op();
    800040ec:	f1dfe0ef          	jal	80003008 <begin_op>
  if((ip = namei(old)) == 0){
    800040f0:	ed040513          	addi	a0,s0,-304
    800040f4:	d59fe0ef          	jal	80002e4c <namei>
    800040f8:	84aa                	mv	s1,a0
    800040fa:	c53d                	beqz	a0,80004168 <sys_link+0xae>
  ilock(ip);
    800040fc:	e76fe0ef          	jal	80002772 <ilock>
  if(ip->type == T_DIR){
    80004100:	04449703          	lh	a4,68(s1)
    80004104:	4785                	li	a5,1
    80004106:	06f70663          	beq	a4,a5,80004172 <sys_link+0xb8>
    8000410a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000410c:	04a4d783          	lhu	a5,74(s1)
    80004110:	2785                	addiw	a5,a5,1
    80004112:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004116:	8526                	mv	a0,s1
    80004118:	da6fe0ef          	jal	800026be <iupdate>
  iunlock(ip);
    8000411c:	8526                	mv	a0,s1
    8000411e:	f02fe0ef          	jal	80002820 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004122:	fd040593          	addi	a1,s0,-48
    80004126:	f5040513          	addi	a0,s0,-176
    8000412a:	d3dfe0ef          	jal	80002e66 <nameiparent>
    8000412e:	892a                	mv	s2,a0
    80004130:	cd21                	beqz	a0,80004188 <sys_link+0xce>
  ilock(dp);
    80004132:	e40fe0ef          	jal	80002772 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004136:	00092703          	lw	a4,0(s2)
    8000413a:	409c                	lw	a5,0(s1)
    8000413c:	04f71363          	bne	a4,a5,80004182 <sys_link+0xc8>
    80004140:	40d0                	lw	a2,4(s1)
    80004142:	fd040593          	addi	a1,s0,-48
    80004146:	854a                	mv	a0,s2
    80004148:	c6bfe0ef          	jal	80002db2 <dirlink>
    8000414c:	02054b63          	bltz	a0,80004182 <sys_link+0xc8>
  iunlockput(dp);
    80004150:	854a                	mv	a0,s2
    80004152:	82bfe0ef          	jal	8000297c <iunlockput>
  iput(ip);
    80004156:	8526                	mv	a0,s1
    80004158:	f9cfe0ef          	jal	800028f4 <iput>
  end_op();
    8000415c:	f17fe0ef          	jal	80003072 <end_op>
  return 0;
    80004160:	4781                	li	a5,0
    80004162:	64f2                	ld	s1,280(sp)
    80004164:	6952                	ld	s2,272(sp)
    80004166:	a0a1                	j	800041ae <sys_link+0xf4>
    end_op();
    80004168:	f0bfe0ef          	jal	80003072 <end_op>
    return -1;
    8000416c:	57fd                	li	a5,-1
    8000416e:	64f2                	ld	s1,280(sp)
    80004170:	a83d                	j	800041ae <sys_link+0xf4>
    iunlockput(ip);
    80004172:	8526                	mv	a0,s1
    80004174:	809fe0ef          	jal	8000297c <iunlockput>
    end_op();
    80004178:	efbfe0ef          	jal	80003072 <end_op>
    return -1;
    8000417c:	57fd                	li	a5,-1
    8000417e:	64f2                	ld	s1,280(sp)
    80004180:	a03d                	j	800041ae <sys_link+0xf4>
    iunlockput(dp);
    80004182:	854a                	mv	a0,s2
    80004184:	ff8fe0ef          	jal	8000297c <iunlockput>
  ilock(ip);
    80004188:	8526                	mv	a0,s1
    8000418a:	de8fe0ef          	jal	80002772 <ilock>
  ip->nlink--;
    8000418e:	04a4d783          	lhu	a5,74(s1)
    80004192:	37fd                	addiw	a5,a5,-1
    80004194:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004198:	8526                	mv	a0,s1
    8000419a:	d24fe0ef          	jal	800026be <iupdate>
  iunlockput(ip);
    8000419e:	8526                	mv	a0,s1
    800041a0:	fdcfe0ef          	jal	8000297c <iunlockput>
  end_op();
    800041a4:	ecffe0ef          	jal	80003072 <end_op>
  return -1;
    800041a8:	57fd                	li	a5,-1
    800041aa:	64f2                	ld	s1,280(sp)
    800041ac:	6952                	ld	s2,272(sp)
}
    800041ae:	853e                	mv	a0,a5
    800041b0:	70b2                	ld	ra,296(sp)
    800041b2:	7412                	ld	s0,288(sp)
    800041b4:	6155                	addi	sp,sp,304
    800041b6:	8082                	ret

00000000800041b8 <sys_unlink>:
{
    800041b8:	7151                	addi	sp,sp,-240
    800041ba:	f586                	sd	ra,232(sp)
    800041bc:	f1a2                	sd	s0,224(sp)
    800041be:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800041c0:	08000613          	li	a2,128
    800041c4:	f3040593          	addi	a1,s0,-208
    800041c8:	4501                	li	a0,0
    800041ca:	b1ffd0ef          	jal	80001ce8 <argstr>
    800041ce:	16054063          	bltz	a0,8000432e <sys_unlink+0x176>
    800041d2:	eda6                	sd	s1,216(sp)
  begin_op();
    800041d4:	e35fe0ef          	jal	80003008 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800041d8:	fb040593          	addi	a1,s0,-80
    800041dc:	f3040513          	addi	a0,s0,-208
    800041e0:	c87fe0ef          	jal	80002e66 <nameiparent>
    800041e4:	84aa                	mv	s1,a0
    800041e6:	c945                	beqz	a0,80004296 <sys_unlink+0xde>
  ilock(dp);
    800041e8:	d8afe0ef          	jal	80002772 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800041ec:	00003597          	auipc	a1,0x3
    800041f0:	49458593          	addi	a1,a1,1172 # 80007680 <etext+0x680>
    800041f4:	fb040513          	addi	a0,s0,-80
    800041f8:	9d9fe0ef          	jal	80002bd0 <namecmp>
    800041fc:	10050e63          	beqz	a0,80004318 <sys_unlink+0x160>
    80004200:	00003597          	auipc	a1,0x3
    80004204:	48858593          	addi	a1,a1,1160 # 80007688 <etext+0x688>
    80004208:	fb040513          	addi	a0,s0,-80
    8000420c:	9c5fe0ef          	jal	80002bd0 <namecmp>
    80004210:	10050463          	beqz	a0,80004318 <sys_unlink+0x160>
    80004214:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004216:	f2c40613          	addi	a2,s0,-212
    8000421a:	fb040593          	addi	a1,s0,-80
    8000421e:	8526                	mv	a0,s1
    80004220:	9c7fe0ef          	jal	80002be6 <dirlookup>
    80004224:	892a                	mv	s2,a0
    80004226:	0e050863          	beqz	a0,80004316 <sys_unlink+0x15e>
  ilock(ip);
    8000422a:	d48fe0ef          	jal	80002772 <ilock>
  if(ip->nlink < 1)
    8000422e:	04a91783          	lh	a5,74(s2)
    80004232:	06f05763          	blez	a5,800042a0 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004236:	04491703          	lh	a4,68(s2)
    8000423a:	4785                	li	a5,1
    8000423c:	06f70963          	beq	a4,a5,800042ae <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004240:	4641                	li	a2,16
    80004242:	4581                	li	a1,0
    80004244:	fc040513          	addi	a0,s0,-64
    80004248:	f49fb0ef          	jal	80000190 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000424c:	4741                	li	a4,16
    8000424e:	f2c42683          	lw	a3,-212(s0)
    80004252:	fc040613          	addi	a2,s0,-64
    80004256:	4581                	li	a1,0
    80004258:	8526                	mv	a0,s1
    8000425a:	869fe0ef          	jal	80002ac2 <writei>
    8000425e:	47c1                	li	a5,16
    80004260:	08f51b63          	bne	a0,a5,800042f6 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004264:	04491703          	lh	a4,68(s2)
    80004268:	4785                	li	a5,1
    8000426a:	08f70d63          	beq	a4,a5,80004304 <sys_unlink+0x14c>
  iunlockput(dp);
    8000426e:	8526                	mv	a0,s1
    80004270:	f0cfe0ef          	jal	8000297c <iunlockput>
  ip->nlink--;
    80004274:	04a95783          	lhu	a5,74(s2)
    80004278:	37fd                	addiw	a5,a5,-1
    8000427a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000427e:	854a                	mv	a0,s2
    80004280:	c3efe0ef          	jal	800026be <iupdate>
  iunlockput(ip);
    80004284:	854a                	mv	a0,s2
    80004286:	ef6fe0ef          	jal	8000297c <iunlockput>
  end_op();
    8000428a:	de9fe0ef          	jal	80003072 <end_op>
  return 0;
    8000428e:	4501                	li	a0,0
    80004290:	64ee                	ld	s1,216(sp)
    80004292:	694e                	ld	s2,208(sp)
    80004294:	a849                	j	80004326 <sys_unlink+0x16e>
    end_op();
    80004296:	dddfe0ef          	jal	80003072 <end_op>
    return -1;
    8000429a:	557d                	li	a0,-1
    8000429c:	64ee                	ld	s1,216(sp)
    8000429e:	a061                	j	80004326 <sys_unlink+0x16e>
    800042a0:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800042a2:	00003517          	auipc	a0,0x3
    800042a6:	3ee50513          	addi	a0,a0,1006 # 80007690 <etext+0x690>
    800042aa:	278010ef          	jal	80005522 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042ae:	04c92703          	lw	a4,76(s2)
    800042b2:	02000793          	li	a5,32
    800042b6:	f8e7f5e3          	bgeu	a5,a4,80004240 <sys_unlink+0x88>
    800042ba:	e5ce                	sd	s3,200(sp)
    800042bc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042c0:	4741                	li	a4,16
    800042c2:	86ce                	mv	a3,s3
    800042c4:	f1840613          	addi	a2,s0,-232
    800042c8:	4581                	li	a1,0
    800042ca:	854a                	mv	a0,s2
    800042cc:	efafe0ef          	jal	800029c6 <readi>
    800042d0:	47c1                	li	a5,16
    800042d2:	00f51c63          	bne	a0,a5,800042ea <sys_unlink+0x132>
    if(de.inum != 0)
    800042d6:	f1845783          	lhu	a5,-232(s0)
    800042da:	efa1                	bnez	a5,80004332 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042dc:	29c1                	addiw	s3,s3,16
    800042de:	04c92783          	lw	a5,76(s2)
    800042e2:	fcf9efe3          	bltu	s3,a5,800042c0 <sys_unlink+0x108>
    800042e6:	69ae                	ld	s3,200(sp)
    800042e8:	bfa1                	j	80004240 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800042ea:	00003517          	auipc	a0,0x3
    800042ee:	3be50513          	addi	a0,a0,958 # 800076a8 <etext+0x6a8>
    800042f2:	230010ef          	jal	80005522 <panic>
    800042f6:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800042f8:	00003517          	auipc	a0,0x3
    800042fc:	3c850513          	addi	a0,a0,968 # 800076c0 <etext+0x6c0>
    80004300:	222010ef          	jal	80005522 <panic>
    dp->nlink--;
    80004304:	04a4d783          	lhu	a5,74(s1)
    80004308:	37fd                	addiw	a5,a5,-1
    8000430a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000430e:	8526                	mv	a0,s1
    80004310:	baefe0ef          	jal	800026be <iupdate>
    80004314:	bfa9                	j	8000426e <sys_unlink+0xb6>
    80004316:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004318:	8526                	mv	a0,s1
    8000431a:	e62fe0ef          	jal	8000297c <iunlockput>
  end_op();
    8000431e:	d55fe0ef          	jal	80003072 <end_op>
  return -1;
    80004322:	557d                	li	a0,-1
    80004324:	64ee                	ld	s1,216(sp)
}
    80004326:	70ae                	ld	ra,232(sp)
    80004328:	740e                	ld	s0,224(sp)
    8000432a:	616d                	addi	sp,sp,240
    8000432c:	8082                	ret
    return -1;
    8000432e:	557d                	li	a0,-1
    80004330:	bfdd                	j	80004326 <sys_unlink+0x16e>
    iunlockput(ip);
    80004332:	854a                	mv	a0,s2
    80004334:	e48fe0ef          	jal	8000297c <iunlockput>
    goto bad;
    80004338:	694e                	ld	s2,208(sp)
    8000433a:	69ae                	ld	s3,200(sp)
    8000433c:	bff1                	j	80004318 <sys_unlink+0x160>

000000008000433e <sys_open>:

uint64
sys_open(void)
{
    8000433e:	7131                	addi	sp,sp,-192
    80004340:	fd06                	sd	ra,184(sp)
    80004342:	f922                	sd	s0,176(sp)
    80004344:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004346:	f4c40593          	addi	a1,s0,-180
    8000434a:	4505                	li	a0,1
    8000434c:	965fd0ef          	jal	80001cb0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004350:	08000613          	li	a2,128
    80004354:	f5040593          	addi	a1,s0,-176
    80004358:	4501                	li	a0,0
    8000435a:	98ffd0ef          	jal	80001ce8 <argstr>
    8000435e:	87aa                	mv	a5,a0
    return -1;
    80004360:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004362:	0a07c263          	bltz	a5,80004406 <sys_open+0xc8>
    80004366:	f526                	sd	s1,168(sp)

  begin_op();
    80004368:	ca1fe0ef          	jal	80003008 <begin_op>

  if(omode & O_CREATE){
    8000436c:	f4c42783          	lw	a5,-180(s0)
    80004370:	2007f793          	andi	a5,a5,512
    80004374:	c3d5                	beqz	a5,80004418 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004376:	4681                	li	a3,0
    80004378:	4601                	li	a2,0
    8000437a:	4589                	li	a1,2
    8000437c:	f5040513          	addi	a0,s0,-176
    80004380:	aa9ff0ef          	jal	80003e28 <create>
    80004384:	84aa                	mv	s1,a0
    if(ip == 0){
    80004386:	c541                	beqz	a0,8000440e <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004388:	04449703          	lh	a4,68(s1)
    8000438c:	478d                	li	a5,3
    8000438e:	00f71763          	bne	a4,a5,8000439c <sys_open+0x5e>
    80004392:	0464d703          	lhu	a4,70(s1)
    80004396:	47a5                	li	a5,9
    80004398:	0ae7ed63          	bltu	a5,a4,80004452 <sys_open+0x114>
    8000439c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000439e:	fe1fe0ef          	jal	8000337e <filealloc>
    800043a2:	892a                	mv	s2,a0
    800043a4:	c179                	beqz	a0,8000446a <sys_open+0x12c>
    800043a6:	ed4e                	sd	s3,152(sp)
    800043a8:	a43ff0ef          	jal	80003dea <fdalloc>
    800043ac:	89aa                	mv	s3,a0
    800043ae:	0a054a63          	bltz	a0,80004462 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800043b2:	04449703          	lh	a4,68(s1)
    800043b6:	478d                	li	a5,3
    800043b8:	0cf70263          	beq	a4,a5,8000447c <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800043bc:	4789                	li	a5,2
    800043be:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800043c2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800043c6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800043ca:	f4c42783          	lw	a5,-180(s0)
    800043ce:	0017c713          	xori	a4,a5,1
    800043d2:	8b05                	andi	a4,a4,1
    800043d4:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800043d8:	0037f713          	andi	a4,a5,3
    800043dc:	00e03733          	snez	a4,a4
    800043e0:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800043e4:	4007f793          	andi	a5,a5,1024
    800043e8:	c791                	beqz	a5,800043f4 <sys_open+0xb6>
    800043ea:	04449703          	lh	a4,68(s1)
    800043ee:	4789                	li	a5,2
    800043f0:	08f70d63          	beq	a4,a5,8000448a <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800043f4:	8526                	mv	a0,s1
    800043f6:	c2afe0ef          	jal	80002820 <iunlock>
  end_op();
    800043fa:	c79fe0ef          	jal	80003072 <end_op>

  return fd;
    800043fe:	854e                	mv	a0,s3
    80004400:	74aa                	ld	s1,168(sp)
    80004402:	790a                	ld	s2,160(sp)
    80004404:	69ea                	ld	s3,152(sp)
}
    80004406:	70ea                	ld	ra,184(sp)
    80004408:	744a                	ld	s0,176(sp)
    8000440a:	6129                	addi	sp,sp,192
    8000440c:	8082                	ret
      end_op();
    8000440e:	c65fe0ef          	jal	80003072 <end_op>
      return -1;
    80004412:	557d                	li	a0,-1
    80004414:	74aa                	ld	s1,168(sp)
    80004416:	bfc5                	j	80004406 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004418:	f5040513          	addi	a0,s0,-176
    8000441c:	a31fe0ef          	jal	80002e4c <namei>
    80004420:	84aa                	mv	s1,a0
    80004422:	c11d                	beqz	a0,80004448 <sys_open+0x10a>
    ilock(ip);
    80004424:	b4efe0ef          	jal	80002772 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004428:	04449703          	lh	a4,68(s1)
    8000442c:	4785                	li	a5,1
    8000442e:	f4f71de3          	bne	a4,a5,80004388 <sys_open+0x4a>
    80004432:	f4c42783          	lw	a5,-180(s0)
    80004436:	d3bd                	beqz	a5,8000439c <sys_open+0x5e>
      iunlockput(ip);
    80004438:	8526                	mv	a0,s1
    8000443a:	d42fe0ef          	jal	8000297c <iunlockput>
      end_op();
    8000443e:	c35fe0ef          	jal	80003072 <end_op>
      return -1;
    80004442:	557d                	li	a0,-1
    80004444:	74aa                	ld	s1,168(sp)
    80004446:	b7c1                	j	80004406 <sys_open+0xc8>
      end_op();
    80004448:	c2bfe0ef          	jal	80003072 <end_op>
      return -1;
    8000444c:	557d                	li	a0,-1
    8000444e:	74aa                	ld	s1,168(sp)
    80004450:	bf5d                	j	80004406 <sys_open+0xc8>
    iunlockput(ip);
    80004452:	8526                	mv	a0,s1
    80004454:	d28fe0ef          	jal	8000297c <iunlockput>
    end_op();
    80004458:	c1bfe0ef          	jal	80003072 <end_op>
    return -1;
    8000445c:	557d                	li	a0,-1
    8000445e:	74aa                	ld	s1,168(sp)
    80004460:	b75d                	j	80004406 <sys_open+0xc8>
      fileclose(f);
    80004462:	854a                	mv	a0,s2
    80004464:	fbffe0ef          	jal	80003422 <fileclose>
    80004468:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000446a:	8526                	mv	a0,s1
    8000446c:	d10fe0ef          	jal	8000297c <iunlockput>
    end_op();
    80004470:	c03fe0ef          	jal	80003072 <end_op>
    return -1;
    80004474:	557d                	li	a0,-1
    80004476:	74aa                	ld	s1,168(sp)
    80004478:	790a                	ld	s2,160(sp)
    8000447a:	b771                	j	80004406 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000447c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004480:	04649783          	lh	a5,70(s1)
    80004484:	02f91223          	sh	a5,36(s2)
    80004488:	bf3d                	j	800043c6 <sys_open+0x88>
    itrunc(ip);
    8000448a:	8526                	mv	a0,s1
    8000448c:	bd4fe0ef          	jal	80002860 <itrunc>
    80004490:	b795                	j	800043f4 <sys_open+0xb6>

0000000080004492 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004492:	7175                	addi	sp,sp,-144
    80004494:	e506                	sd	ra,136(sp)
    80004496:	e122                	sd	s0,128(sp)
    80004498:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000449a:	b6ffe0ef          	jal	80003008 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000449e:	08000613          	li	a2,128
    800044a2:	f7040593          	addi	a1,s0,-144
    800044a6:	4501                	li	a0,0
    800044a8:	841fd0ef          	jal	80001ce8 <argstr>
    800044ac:	02054363          	bltz	a0,800044d2 <sys_mkdir+0x40>
    800044b0:	4681                	li	a3,0
    800044b2:	4601                	li	a2,0
    800044b4:	4585                	li	a1,1
    800044b6:	f7040513          	addi	a0,s0,-144
    800044ba:	96fff0ef          	jal	80003e28 <create>
    800044be:	c911                	beqz	a0,800044d2 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800044c0:	cbcfe0ef          	jal	8000297c <iunlockput>
  end_op();
    800044c4:	baffe0ef          	jal	80003072 <end_op>
  return 0;
    800044c8:	4501                	li	a0,0
}
    800044ca:	60aa                	ld	ra,136(sp)
    800044cc:	640a                	ld	s0,128(sp)
    800044ce:	6149                	addi	sp,sp,144
    800044d0:	8082                	ret
    end_op();
    800044d2:	ba1fe0ef          	jal	80003072 <end_op>
    return -1;
    800044d6:	557d                	li	a0,-1
    800044d8:	bfcd                	j	800044ca <sys_mkdir+0x38>

00000000800044da <sys_mknod>:

uint64
sys_mknod(void)
{
    800044da:	7135                	addi	sp,sp,-160
    800044dc:	ed06                	sd	ra,152(sp)
    800044de:	e922                	sd	s0,144(sp)
    800044e0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800044e2:	b27fe0ef          	jal	80003008 <begin_op>
  argint(1, &major);
    800044e6:	f6c40593          	addi	a1,s0,-148
    800044ea:	4505                	li	a0,1
    800044ec:	fc4fd0ef          	jal	80001cb0 <argint>
  argint(2, &minor);
    800044f0:	f6840593          	addi	a1,s0,-152
    800044f4:	4509                	li	a0,2
    800044f6:	fbafd0ef          	jal	80001cb0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800044fa:	08000613          	li	a2,128
    800044fe:	f7040593          	addi	a1,s0,-144
    80004502:	4501                	li	a0,0
    80004504:	fe4fd0ef          	jal	80001ce8 <argstr>
    80004508:	02054563          	bltz	a0,80004532 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000450c:	f6841683          	lh	a3,-152(s0)
    80004510:	f6c41603          	lh	a2,-148(s0)
    80004514:	458d                	li	a1,3
    80004516:	f7040513          	addi	a0,s0,-144
    8000451a:	90fff0ef          	jal	80003e28 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000451e:	c911                	beqz	a0,80004532 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004520:	c5cfe0ef          	jal	8000297c <iunlockput>
  end_op();
    80004524:	b4ffe0ef          	jal	80003072 <end_op>
  return 0;
    80004528:	4501                	li	a0,0
}
    8000452a:	60ea                	ld	ra,152(sp)
    8000452c:	644a                	ld	s0,144(sp)
    8000452e:	610d                	addi	sp,sp,160
    80004530:	8082                	ret
    end_op();
    80004532:	b41fe0ef          	jal	80003072 <end_op>
    return -1;
    80004536:	557d                	li	a0,-1
    80004538:	bfcd                	j	8000452a <sys_mknod+0x50>

000000008000453a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000453a:	7135                	addi	sp,sp,-160
    8000453c:	ed06                	sd	ra,152(sp)
    8000453e:	e922                	sd	s0,144(sp)
    80004540:	e14a                	sd	s2,128(sp)
    80004542:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004544:	865fc0ef          	jal	80000da8 <myproc>
    80004548:	892a                	mv	s2,a0
  
  begin_op();
    8000454a:	abffe0ef          	jal	80003008 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000454e:	08000613          	li	a2,128
    80004552:	f6040593          	addi	a1,s0,-160
    80004556:	4501                	li	a0,0
    80004558:	f90fd0ef          	jal	80001ce8 <argstr>
    8000455c:	04054363          	bltz	a0,800045a2 <sys_chdir+0x68>
    80004560:	e526                	sd	s1,136(sp)
    80004562:	f6040513          	addi	a0,s0,-160
    80004566:	8e7fe0ef          	jal	80002e4c <namei>
    8000456a:	84aa                	mv	s1,a0
    8000456c:	c915                	beqz	a0,800045a0 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000456e:	a04fe0ef          	jal	80002772 <ilock>
  if(ip->type != T_DIR){
    80004572:	04449703          	lh	a4,68(s1)
    80004576:	4785                	li	a5,1
    80004578:	02f71963          	bne	a4,a5,800045aa <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000457c:	8526                	mv	a0,s1
    8000457e:	aa2fe0ef          	jal	80002820 <iunlock>
  iput(p->cwd);
    80004582:	15093503          	ld	a0,336(s2)
    80004586:	b6efe0ef          	jal	800028f4 <iput>
  end_op();
    8000458a:	ae9fe0ef          	jal	80003072 <end_op>
  p->cwd = ip;
    8000458e:	14993823          	sd	s1,336(s2)
  return 0;
    80004592:	4501                	li	a0,0
    80004594:	64aa                	ld	s1,136(sp)
}
    80004596:	60ea                	ld	ra,152(sp)
    80004598:	644a                	ld	s0,144(sp)
    8000459a:	690a                	ld	s2,128(sp)
    8000459c:	610d                	addi	sp,sp,160
    8000459e:	8082                	ret
    800045a0:	64aa                	ld	s1,136(sp)
    end_op();
    800045a2:	ad1fe0ef          	jal	80003072 <end_op>
    return -1;
    800045a6:	557d                	li	a0,-1
    800045a8:	b7fd                	j	80004596 <sys_chdir+0x5c>
    iunlockput(ip);
    800045aa:	8526                	mv	a0,s1
    800045ac:	bd0fe0ef          	jal	8000297c <iunlockput>
    end_op();
    800045b0:	ac3fe0ef          	jal	80003072 <end_op>
    return -1;
    800045b4:	557d                	li	a0,-1
    800045b6:	64aa                	ld	s1,136(sp)
    800045b8:	bff9                	j	80004596 <sys_chdir+0x5c>

00000000800045ba <sys_exec>:

uint64
sys_exec(void)
{
    800045ba:	7121                	addi	sp,sp,-448
    800045bc:	ff06                	sd	ra,440(sp)
    800045be:	fb22                	sd	s0,432(sp)
    800045c0:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800045c2:	e4840593          	addi	a1,s0,-440
    800045c6:	4505                	li	a0,1
    800045c8:	f04fd0ef          	jal	80001ccc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800045cc:	08000613          	li	a2,128
    800045d0:	f5040593          	addi	a1,s0,-176
    800045d4:	4501                	li	a0,0
    800045d6:	f12fd0ef          	jal	80001ce8 <argstr>
    800045da:	87aa                	mv	a5,a0
    return -1;
    800045dc:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800045de:	0c07c463          	bltz	a5,800046a6 <sys_exec+0xec>
    800045e2:	f726                	sd	s1,424(sp)
    800045e4:	f34a                	sd	s2,416(sp)
    800045e6:	ef4e                	sd	s3,408(sp)
    800045e8:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800045ea:	10000613          	li	a2,256
    800045ee:	4581                	li	a1,0
    800045f0:	e5040513          	addi	a0,s0,-432
    800045f4:	b9dfb0ef          	jal	80000190 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800045f8:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800045fc:	89a6                	mv	s3,s1
    800045fe:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004600:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004604:	00391513          	slli	a0,s2,0x3
    80004608:	e4040593          	addi	a1,s0,-448
    8000460c:	e4843783          	ld	a5,-440(s0)
    80004610:	953e                	add	a0,a0,a5
    80004612:	e14fd0ef          	jal	80001c26 <fetchaddr>
    80004616:	02054663          	bltz	a0,80004642 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000461a:	e4043783          	ld	a5,-448(s0)
    8000461e:	c3a9                	beqz	a5,80004660 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004620:	adffb0ef          	jal	800000fe <kalloc>
    80004624:	85aa                	mv	a1,a0
    80004626:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000462a:	cd01                	beqz	a0,80004642 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000462c:	6605                	lui	a2,0x1
    8000462e:	e4043503          	ld	a0,-448(s0)
    80004632:	e3efd0ef          	jal	80001c70 <fetchstr>
    80004636:	00054663          	bltz	a0,80004642 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000463a:	0905                	addi	s2,s2,1
    8000463c:	09a1                	addi	s3,s3,8
    8000463e:	fd4913e3          	bne	s2,s4,80004604 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004642:	f5040913          	addi	s2,s0,-176
    80004646:	6088                	ld	a0,0(s1)
    80004648:	c931                	beqz	a0,8000469c <sys_exec+0xe2>
    kfree(argv[i]);
    8000464a:	9d3fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000464e:	04a1                	addi	s1,s1,8
    80004650:	ff249be3          	bne	s1,s2,80004646 <sys_exec+0x8c>
  return -1;
    80004654:	557d                	li	a0,-1
    80004656:	74ba                	ld	s1,424(sp)
    80004658:	791a                	ld	s2,416(sp)
    8000465a:	69fa                	ld	s3,408(sp)
    8000465c:	6a5a                	ld	s4,400(sp)
    8000465e:	a0a1                	j	800046a6 <sys_exec+0xec>
      argv[i] = 0;
    80004660:	0009079b          	sext.w	a5,s2
    80004664:	078e                	slli	a5,a5,0x3
    80004666:	fd078793          	addi	a5,a5,-48
    8000466a:	97a2                	add	a5,a5,s0
    8000466c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004670:	e5040593          	addi	a1,s0,-432
    80004674:	f5040513          	addi	a0,s0,-176
    80004678:	ba8ff0ef          	jal	80003a20 <exec>
    8000467c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000467e:	f5040993          	addi	s3,s0,-176
    80004682:	6088                	ld	a0,0(s1)
    80004684:	c511                	beqz	a0,80004690 <sys_exec+0xd6>
    kfree(argv[i]);
    80004686:	997fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000468a:	04a1                	addi	s1,s1,8
    8000468c:	ff349be3          	bne	s1,s3,80004682 <sys_exec+0xc8>
  return ret;
    80004690:	854a                	mv	a0,s2
    80004692:	74ba                	ld	s1,424(sp)
    80004694:	791a                	ld	s2,416(sp)
    80004696:	69fa                	ld	s3,408(sp)
    80004698:	6a5a                	ld	s4,400(sp)
    8000469a:	a031                	j	800046a6 <sys_exec+0xec>
  return -1;
    8000469c:	557d                	li	a0,-1
    8000469e:	74ba                	ld	s1,424(sp)
    800046a0:	791a                	ld	s2,416(sp)
    800046a2:	69fa                	ld	s3,408(sp)
    800046a4:	6a5a                	ld	s4,400(sp)
}
    800046a6:	70fa                	ld	ra,440(sp)
    800046a8:	745a                	ld	s0,432(sp)
    800046aa:	6139                	addi	sp,sp,448
    800046ac:	8082                	ret

00000000800046ae <sys_pipe>:

uint64
sys_pipe(void)
{
    800046ae:	7139                	addi	sp,sp,-64
    800046b0:	fc06                	sd	ra,56(sp)
    800046b2:	f822                	sd	s0,48(sp)
    800046b4:	f426                	sd	s1,40(sp)
    800046b6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800046b8:	ef0fc0ef          	jal	80000da8 <myproc>
    800046bc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800046be:	fd840593          	addi	a1,s0,-40
    800046c2:	4501                	li	a0,0
    800046c4:	e08fd0ef          	jal	80001ccc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800046c8:	fc840593          	addi	a1,s0,-56
    800046cc:	fd040513          	addi	a0,s0,-48
    800046d0:	85cff0ef          	jal	8000372c <pipealloc>
    return -1;
    800046d4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800046d6:	0a054463          	bltz	a0,8000477e <sys_pipe+0xd0>
  fd0 = -1;
    800046da:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800046de:	fd043503          	ld	a0,-48(s0)
    800046e2:	f08ff0ef          	jal	80003dea <fdalloc>
    800046e6:	fca42223          	sw	a0,-60(s0)
    800046ea:	08054163          	bltz	a0,8000476c <sys_pipe+0xbe>
    800046ee:	fc843503          	ld	a0,-56(s0)
    800046f2:	ef8ff0ef          	jal	80003dea <fdalloc>
    800046f6:	fca42023          	sw	a0,-64(s0)
    800046fa:	06054063          	bltz	a0,8000475a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800046fe:	4691                	li	a3,4
    80004700:	fc440613          	addi	a2,s0,-60
    80004704:	fd843583          	ld	a1,-40(s0)
    80004708:	68a8                	ld	a0,80(s1)
    8000470a:	b10fc0ef          	jal	80000a1a <copyout>
    8000470e:	00054e63          	bltz	a0,8000472a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004712:	4691                	li	a3,4
    80004714:	fc040613          	addi	a2,s0,-64
    80004718:	fd843583          	ld	a1,-40(s0)
    8000471c:	0591                	addi	a1,a1,4
    8000471e:	68a8                	ld	a0,80(s1)
    80004720:	afafc0ef          	jal	80000a1a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004724:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004726:	04055c63          	bgez	a0,8000477e <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000472a:	fc442783          	lw	a5,-60(s0)
    8000472e:	07e9                	addi	a5,a5,26
    80004730:	078e                	slli	a5,a5,0x3
    80004732:	97a6                	add	a5,a5,s1
    80004734:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004738:	fc042783          	lw	a5,-64(s0)
    8000473c:	07e9                	addi	a5,a5,26
    8000473e:	078e                	slli	a5,a5,0x3
    80004740:	94be                	add	s1,s1,a5
    80004742:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004746:	fd043503          	ld	a0,-48(s0)
    8000474a:	cd9fe0ef          	jal	80003422 <fileclose>
    fileclose(wf);
    8000474e:	fc843503          	ld	a0,-56(s0)
    80004752:	cd1fe0ef          	jal	80003422 <fileclose>
    return -1;
    80004756:	57fd                	li	a5,-1
    80004758:	a01d                	j	8000477e <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000475a:	fc442783          	lw	a5,-60(s0)
    8000475e:	0007c763          	bltz	a5,8000476c <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004762:	07e9                	addi	a5,a5,26
    80004764:	078e                	slli	a5,a5,0x3
    80004766:	97a6                	add	a5,a5,s1
    80004768:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000476c:	fd043503          	ld	a0,-48(s0)
    80004770:	cb3fe0ef          	jal	80003422 <fileclose>
    fileclose(wf);
    80004774:	fc843503          	ld	a0,-56(s0)
    80004778:	cabfe0ef          	jal	80003422 <fileclose>
    return -1;
    8000477c:	57fd                	li	a5,-1
}
    8000477e:	853e                	mv	a0,a5
    80004780:	70e2                	ld	ra,56(sp)
    80004782:	7442                	ld	s0,48(sp)
    80004784:	74a2                	ld	s1,40(sp)
    80004786:	6121                	addi	sp,sp,64
    80004788:	8082                	ret
    8000478a:	0000                	unimp
    8000478c:	0000                	unimp
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
