#include    "zks.h"

.text

.global test_sm4ed1
.func   test_sm4ed1
test_sm4ed1:
    sm4ed  a0, a0, a1, 1
    ret
.endfunc
	
.global test_sm4ks1
.func   test_sm4ks1
test_sm4ks1:
    sm4ks  a0, a0, a1, 1
    ret
.endfunc

.global test_sm3p0
.func   test_sm3p0
test_sm3p0:
    sm3p0 a0, a0
    ret
.endfunc

.global test_sm3p1
.func   test_sm3p1
test_sm3p1:
    sm3p1 a0, a0
    ret
.endfunc


