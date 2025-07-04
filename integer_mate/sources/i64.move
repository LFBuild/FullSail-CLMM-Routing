module integer_mate::i64 {
    const EOverflow: u64 = 0;

    const MIN_AS_U64: u64 = 1 << 63;
    const MAX_AS_U64: u64 = 0x7fffffffffffffff;

    const LT: u8 = 0;
    const EQ: u8 = 1;
    const GT: u8 = 2;

    public struct I64 has copy, drop, store {
        bits: u64
    }

    public fun zero(): I64 {
        abort 0
    }

    public fun from_u64(v: u64): I64 {
        abort 0
    }

    public fun from(v: u64): I64 {
        abort 0
    }

    public fun neg_from(v: u64): I64 {
        abort 0
    }

    public fun wrapping_add(num1: I64, num2: I64): I64 {
        abort 0
    }

    public fun add(num1: I64, num2: I64): I64 {
        abort 0
    }

    public fun wrapping_sub(num1: I64, num2: I64): I64 {
        abort 0
    }

    public fun sub(num1: I64, num2: I64): I64 {
        abort 0
    }

    public fun mul(num1: I64, num2: I64): I64 {
        abort 0
    }

    public fun div(num1: I64, num2: I64): I64 {
        abort 0
    }

    public fun abs(v: I64): I64 {
        abort 0
    }

    public fun abs_u64(v: I64): u64 {
        abort 0
    }

    public fun shl(v: I64, shift: u8): I64 {
        abort 0
    }

    public fun shr(v: I64, shift: u8): I64 {
        abort 0
    }

    public fun mod(v: I64, n: I64): I64 {
        abort 0
    }

    public fun as_u64(v: I64): u64 {
        abort 0
    }

    public fun sign(v: I64): u8 {
        abort 0
    }

    public fun is_neg(v: I64): bool {
        abort 0
    }

    public fun cmp(num1: I64, num2: I64): u8 {
        abort 0
    }

    public fun eq(num1: I64, num2: I64): bool {
        abort 0
    }

    public fun gt(num1: I64, num2: I64): bool {
        abort 0
    }

    public fun gte(num1: I64, num2: I64): bool {
        abort 0
    }

    public fun lt(num1: I64, num2: I64): bool {
        abort 0
    }

    public fun lte(num1: I64, num2: I64): bool {
        abort 0
    }

    public fun or(num1: I64, num2: I64): I64 {
        abort 0
    }

    public fun and(num1: I64, num2: I64): I64 {
        abort 0
    }
}

