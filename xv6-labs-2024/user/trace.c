// user/trace.c
// Chạy một chương trình khác với tracing được bật.
// Cách dùng: _trace <mask> <chương_trình> [đối số...]

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"        // chứa printf, fprintf, exit, exec, atoi,...
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
    if (argc < 3) {
        fprintf(2, "Cách dùng: %s <mask> <chương_trình> [đối số...]\n", argv[0]);
        exit(1);
    }

    int mask = atoi(argv[1]);
    if (trace(mask) < 0) {
        fprintf(2, "%s: trace(%d) thất bại\n", argv[0], mask);
        exit(1);
    }

    // Thực thi chương trình đích với các tham số (ghi chú: exec không trả về nếu thành công)
    exec(argv[2], &argv[2]);

    // Nếu exec trả về, có nghĩa là thất bại
    fprintf(2, "%s: exec %s thất bại\n", argv[0], argv[2]);
    exit(1);
}
