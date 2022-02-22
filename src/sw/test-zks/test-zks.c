#include "system.h"
#include "sm4_common.h"

#define ROL32(x,n) (((x) << (n)) | ((x) >> (32 - (n))))
#define ROR32(x,n) (((x) >> (n)) | ((x) << (32 - (n))))
#define ROL64(x,n) (((x) << (n)) | ((x) >> (64 - (n))))
#define ROR64(x,n) (((x) >> (n)) | ((x) << (64 - (n))))

static uint32_t lfsr(uint32_t x)
{
  uint32_t bit = (x ^ (x >> 1)) & 1;
  return (x >> 1) | (bit << 30);
}

extern uint32_t test_sm4ed1(uint32_t a, uint32_t b);
extern uint32_t test_sm4ks1(uint32_t a, uint32_t b);

extern uint32_t test_sm3p0(uint32_t a);
extern uint32_t test_sm3p1(uint32_t a);

uint32_t gold_sm4ed(uint32_t a, uint32_t b, uint32_t bs){

    uint32_t sb_in  = (b >> (8*bs)) & 0xFF;
    uint32_t sb_out = SM4_SBOX[sb_in];

    uint32_t linear = sb_out ^  ( sb_out         <<  8) ^ 
                                ( sb_out         <<  2) ^
                                ( sb_out         << 18) ^
                                ((sb_out & 0x3f) << 26) ^
                                ((sb_out & 0xC0) << 10) ;

    uint32_t r      = (linear << (8*bs)) | (linear >> (32-8*bs));

    return (r ^ a);
}

uint32_t gold_sm4ks(uint32_t a, uint32_t b, uint32_t bs){

    uint32_t sb_in  = (b >> (8*bs)) & 0xFF;
    uint32_t sb_out = SM4_SBOX[sb_in];

    uint32_t x      = sb_out ^ ((sb_out & 0x07) << 29) ^ 
                               ((sb_out & 0xFE) <<  7) ^
                               ((sb_out & 0x01) << 23) ^ 
                               ((sb_out & 0xF8) << 13) ;

    uint32_t r      = (x << (8*bs)) | (x >> (32-8*bs));

    return (r ^ a);
}

uint32_t gold_sm3p0(uint32_t a){
    uint32_t     r = a ^ ROL32(a, 9) ^ ROL32(a, 17);
    return r;
}
uint32_t gold_sm3p1(uint32_t a){
    uint32_t     r = a ^ ROL32(a, 15) ^ ROL32(a, 23);
    return r;
}


void error_log(uint32_t expect, uint32_t result){
puts("Expected: "); puthex(expect); puts(", got:"); puthex(result); putchar('\n');
}
int fail;
uint32_t expect, result;

int main() {
    
    fail = 0;

    uint32_t lhs = 0x23456789;
    uint32_t rhs = 0xDEADBEAD;

    puts("# RV32Zks Instruction Test \n");
    rhs = 0x01020304;
    for (int i=0;i<20;i++){
    puts("lhs: "); puthex(lhs); puts(", rhs:"); puthex(rhs); putchar('\n');

    // sm4ed1    
    result = test_sm4ed1(lhs, rhs);
    expect = gold_sm4ed( lhs, rhs, 1);

    if(result != expect) {
        puts("test_sm4ed1 [FAIL]\n");
        error_log(expect,result);
        fail = 1;
    }

    // sm4ks1    
    result = test_sm4ks1(lhs, rhs);
    expect = gold_sm4ks( lhs, rhs, 1);

    if(result != expect) {
        puts("test_sm4ks1 [FAIL]\n");
        error_log(expect,result);
        fail = 1;
    }

    // sm3p0
    result = test_sm3p0(lhs);
    expect = gold_sm3p0(lhs);

    if(result != expect) {
        puts("test_sm3p0 [FAIL]\n");
        error_log(expect,result);
        fail = 1;
    }

    // sm3p1
    result = test_sm3p1(lhs);
    expect = gold_sm3p1(lhs);

    if(result != expect) {
        puts("test_sm3p1 [FAIL]\n");
        error_log(expect,result);
        fail = 1;
    }


    rhs = lfsr(lhs);
    lhs = lfsr(rhs);
    }

    if (fail == 0) puts("\n the RV32Zks test is passed \n");

    return fail;

}

