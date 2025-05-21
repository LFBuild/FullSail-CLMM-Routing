
module clmm_pool::config {
  
    /// Represents a fee tier configuration for the pool.
    /// Defines the tick spacing and fee rate for a specific tier.
    /// 
    /// # Fields
    /// * `tick_spacing` - The minimum distance between initialized ticks
    /// * `fee_rate` - The fee rate for this tier (in basis points)
    public struct FeeTier has copy, drop, store {
        tick_spacing: u32,
        fee_rate: u64,
    }

    /// Global configuration for the CLMM protocol.
    /// Contains all protocol-wide settings and parameters.
    /// 
    /// # Fields
    /// * `id` - Unique identifier for the configuration
    /// * `fee_tiers` - Map of fee tiers indexed by tick spacing
    public struct GlobalConfig has store, key {
        id: sui::object::UID,
        fee_tiers: sui::vec_map::VecMap<u32, FeeTier>,
    }

    /// Returns a reference to the fee tiers map.
    /// 
    /// # Arguments
    /// * `config` - Reference to the global configuration
    /// 
    /// # Returns
    /// Reference to the fee tiers map
    public fun fee_tiers(config: &GlobalConfig): &sui::vec_map::VecMap<u32, FeeTier> {
        &config.fee_tiers
    }

    /// Returns the denominator used for fee rate calculations.
    /// 
    /// # Returns
    /// The fee rate denominator (1000000)
    public fun fee_rate_denom(): u64 {
        1000000
    }

}

