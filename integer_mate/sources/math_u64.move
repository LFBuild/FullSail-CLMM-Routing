module integer_mate::math_u64 {
    const MAX_U64: u64 = 0xffffffffffffffff;

    const HI_64_MASK: u128 = 0xffffffffffffffff0000000000000000;
    const LO_64_MASK: u128 = 0x0000000000000000ffffffffffffffff;

    public fun wrapping_add(n1: u64, n2: u64): u64 {
        abort 0
    }

    public fun overflowing_add(n1: u64, n2: u64): (u64, bool) {
        abort 0
    }

    public fun wrapping_sub(n1: u64, n2: u64): u64 {
        abort 0
    }

    public fun overflowing_sub(n1: u64, n2: u64): (u64, bool) {
        abort 0
    }

    public fun wrapping_mul(n1: u64, n2: u64): u64 {
        abort 0
    }

    public fun overflowing_mul(n1: u64, n2: u64): (u64, bool) {
        abort 0
    }

    public fun carry_add(n1: u64, n2: u64, carry: u64): (u64, u64) {
        abort 0
    }

    public fun add_check(n1: u64, n2: u64): bool {
        abort 0
    }
}
