#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/sysinfo.h"

void
testcall()
{
    struct sysinfo info;
    
    printf("sysinfotest: test sysinfo\n");
    
    if (sysinfo(&info) < 0) {
        printf("sysinfo failed\n");
        exit(1);
    }
    
    printf("sysinfo success\n");
}

void
testmem()
{
    struct sysinfo info;
    
    printf("sysinfotest: test memory\n");
    
    if (sysinfo(&info) < 0) {
        printf("sysinfo failed\n");
        exit(1);
    }
    
    printf("free memory: %d bytes\n", (int)info.freemem);
    
    if (info.freemem <= 0) {
        printf("invalid free memory: %d\n", (int)info.freemem);
        exit(1);
    }
    
    printf("memory test success\n");
}

void
testproc()
{
    struct sysinfo info;
    
    printf("sysinfotest: test processes\n");
    
    if (sysinfo(&info) < 0) {
        printf("sysinfo failed\n");
        exit(1);
    }
    
    printf("number of processes: %d\n", (int)info.nproc);
    
    if (info.nproc <= 0) {
        printf("invalid process count: %d\n", (int)info.nproc);
        exit(1);
    }
    
    printf("process test success\n");
}

int
main(int argc, char *argv[])
{
    printf("sysinfotest: starting\n");
    
    testcall();
    testmem();
    testproc();
    
    printf("sysinfotest: OK\n");
    exit(0);
}