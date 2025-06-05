module integer_mate::math_u128 {

    const MAX_U128: u128 = 0xffffffffffffffffffffffffffffffff;

    const HI_64_MASK: u128 = 0xffffffffffffffff0000000000000000;
    const LO_64_MASK: u128 = 0x0000000000000000ffffffffffffffff;
    const LO_128_MASK: u256 = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;

    const DIV_BY_ZERO: u64 = 1;

    public fun wrapping_add(n1: u128, n2: u128): u128 {
        abort 0
    }

    public fun overflowing_add(n1: u128, n2: u128): (u128, bool) {
        abort 0
    }
    
    public fun wrapping_sub(n1: u128, n2: u128): u128 {
        abort 0
    }
    
    public fun overflowing_sub(n1: u128, n2: u128): (u128, bool) {
        abort 0
    }
    
    public fun wrapping_mul(n1: u128, n2: u128): u128 {
        abort 0
    }
    
    public fun overflowing_mul(n1: u128, n2: u128): (u128, bool) {
        abort 0
    }

    public fun full_mul(n1: u128, n2: u128): (u128, u128) {
        abort 0
    }

    public fun hi(n: u128): u64 {
        abort 0
    }

    public fun lo(n: u128): u64 {
        abort 0
    }

    public fun hi_u128(n: u128): u128 {
        abort 0
    }

    public fun lo_u128(n: u128): u128 {
        abort 0
    }

    public fun from_lo_hi(lo: u64, hi: u64): u128 {
        abort 0
    }

    public fun checked_div_round(num: u128, denom: u128, round_up: bool): u128 {
        abort 0
    }

    public fun max(num1: u128, num2: u128): u128 {
        abort
    }

    public fun min(num1: u128, num2: u128): u128 {
        abort 0
    }

    public fun add_check(num1: u128, num2: u128): bool {
        abort 0
    }

   public fun is_neg(n: u128): bool {
        abort 0
    }

    public fun greater_or_equal_overflowing(n1: u128, n2: u128): bool {
        abort 0
    }
}
