/// Position module for the CLMM (Concentrated Liquidity Market Maker) pool system.
/// This module provides functionality for:
/// * Managing liquidity positions in the pool
/// * Handling position creation and modification
/// * Managing position fees and rewards
/// * Controlling position staking and unstaking
/// 
/// The module implements:
/// * Position creation and management
/// * Liquidity provision and removal
/// * Fee collection and distribution
/// * Position staking mechanics
/// 
/// # Key Concepts
/// * Position - Represents a liquidity position in the pool
/// * Liquidity - The amount of tokens provided to the pool
/// * Fees - Trading fees earned by the position
/// * Staking - Mechanism for earning additional rewards
/// 
/// # Events
/// * Position creation events
/// * Position modification events
/// * Fee collection events
/// * Staking status change events
module clmm_pool::position {

    const ENotOwner: u64 = 985489328434574338;
    const EOverflow: u64 = 923065912304623497;
    const ERewardIndexOutOfBounds: u64 = 932047692306234633;
    const EFullsailDistributionOverflow: u64 = 932069234723906182;
    const EPositionNotFound: u64 = 923070870234869348;
    const EInvalidTickRange: u64 = 923846923867923746;
    const EInsufficientLiquidity: u64 = 923879283460923860;
    const ELiquidityOverflow: u64 = 923876923470938023;
    const EStakingStatusUnchanged: u64 = 92372398045693466;
    const EPositionNotEmpty: u64 = 93468306382406723;

    /// Event emitted when a position's staking status is changed.
    /// 
    /// # Fields
    /// * `position_id` - ID of the position
    /// * `staked` - New staking status (true if staked, false if unstaked)
    public struct StakePositionEvent has copy, drop {
        position_id: sui::object::ID,
        staked: bool,
    }

    /// Event emitted when the fullsail distribution is updated.
    /// 
    /// # Fields
    /// * `position_id` - ID of the position
    /// * `fullsail_distribution_owned` - New owned fullsail distribution
    /// * `fullsail_distribution_growth_inside` - New growth inside fullsail distribution
    public struct UpdateFullsailDistributionEvent has copy, drop {
        position_id: sui::object::ID,
        fullsail_distribution_owned: u64,
        fullsail_distribution_growth_inside: u128,
    }

    /// Event emitted when the points are updated.
    /// 
    /// # Fields
    /// * `position_id` - ID of the position
    /// * `points_owned` - New owned points
    /// * `points_growth_inside` - New growth inside points
    public struct UpdatePointsEvent has copy, drop {
        position_id: sui::object::ID,
        points_owned: u128,
        points_growth_inside: u128,
    }

    /// Event emitted when a reward is created.
    /// 
    /// # Fields
    /// * `position_id` - ID of the position
    /// * `reward_index` - Index of the reward
    /// * `reward_growth_inside` - New growth inside reward
    /// * `reward_amount_owned` - New amount owned reward
    public struct CreateRewardEvent has copy, drop {
        position_id: sui::object::ID,
        reward_index: u64,
        reward_growth_inside: u128,
        reward_amount_owned: u64,
    }

    /// Event emitted when the reward is updated.
    /// 
    /// # Fields
    /// * `position_id` - ID of the position
    /// * `reward_index` - Index of the reward
    /// * `reward_growth_inside` - New growth inside reward
    /// * `reward_amount_owned` - New amount owned reward
    public struct UpdateRewardEvent has copy, drop {
        position_id: sui::object::ID,
        reward_index: u64,
        reward_growth_inside: u128,
        reward_amount_owned: u64,
    }

    /// Event emitted when the fee is updated.
    /// 
    /// # Fields
    /// * `position_id` - ID of the position
    /// * `fee_owned_a` - New fee owned for token A
    /// * `fee_owned_b` - New fee owned for token B
    /// * `fee_growth_inside_a` - New growth inside fee for token A
    /// * `fee_growth_inside_b` - New growth inside fee for token B
    public struct UpdateFeeEvent has copy, drop {
        position_id: sui::object::ID,
        fee_owned_a: u64,
        fee_owned_b: u64,
        fee_growth_inside_a: u128,
        fee_growth_inside_b: u128,
    }

    /// Manages all positions in the pool system.
    /// This structure maintains a collection of positions and their associated information.
    /// 
    /// # Fields
    /// * `tick_spacing` - Minimum distance between initialized ticks
    /// * `position_index` - Counter for generating unique position indices
    /// * `positions` - Linked table containing all position information
    public struct PositionManager has store {
        tick_spacing: u32,
        position_index: u64,
        positions: move_stl::linked_table::LinkedTable<sui::object::ID, PositionInfo>,
    }

    /// Witness type for position module initialization.
    /// Used to ensure proper module initialization and access control.
    public struct POSITION has drop {}

    /// Represents a liquidity position in the pool.
    /// This structure contains the core position data and metadata.
    /// 
    /// # Fields
    /// * `id` - Unique identifier for the position
    /// * `pool` - ID of the pool this position belongs to
    /// * `index` - Unique index of the position
    /// * `coin_type_a` - Type of the first token in the pair
    /// * `coin_type_b` - Type of the second token in the pair
    /// * `name` - Name of the position
    /// * `description` - Description of the position
    /// * `url` - URL for position metadata
    /// * `tick_lower_index` - Lower tick boundary of the position
    /// * `tick_upper_index` - Upper tick boundary of the position
    /// * `liquidity` - Amount of liquidity in the position
    public struct Position has store, key {
        id: sui::object::UID,
        pool: sui::object::ID,
        index: u64,
        coin_type_a: std::type_name::TypeName,
        coin_type_b: std::type_name::TypeName,
        name: std::string::String,
        description: std::string::String,
        url: std::string::String,
        tick_lower_index: integer_mate::i32::I32,
        tick_upper_index: integer_mate::i32::I32,
        liquidity: u128,
    }

    /// Contains detailed information about a position's state and accumulated fees.
    /// This structure tracks all position-specific metrics and rewards.
    /// 
    /// # Fields
    /// * `position_id` - ID of the associated position
    /// * `liquidity` - Current liquidity in the position
    /// * `tick_lower_index` - Lower tick boundary
    /// * `tick_upper_index` - Upper tick boundary
    /// * `fee_growth_inside_a` - Accumulated fees for token A within the position's range
    /// * `fee_growth_inside_b` - Accumulated fees for token B within the position's range
    /// * `fee_owned_a` - Unclaimed fees for token A
    /// * `fee_owned_b` - Unclaimed fees for token B
    /// * `points_owned` - Unclaimed points rewards
    /// * `points_growth_inside` - Accumulated points within the position's range
    /// * `rewards` - Vector of additional rewards for the position
    /// * `fullsail_distribution_staked` - Whether the position is staked for FULLSAIL rewards
    /// * `fullsail_distribution_growth_inside` - Accumulated FULLSAIL rewards within the position's range
    /// * `fullsail_distribution_owned` - Unclaimed FULLSAIL rewards
    public struct PositionInfo has copy, drop, store {
        position_id: sui::object::ID,
        liquidity: u128,
        tick_lower_index: integer_mate::i32::I32,
        tick_upper_index: integer_mate::i32::I32,
        fee_growth_inside_a: u128,
        fee_growth_inside_b: u128,
        fee_owned_a: u64,
        fee_owned_b: u64,
        points_owned: u128,
        points_growth_inside: u128,
        rewards: vector<PositionReward>,
        fullsail_distribution_staked: bool,
        fullsail_distribution_growth_inside: u128,
        fullsail_distribution_owned: u64,
    }

    /// Represents a reward for a position.
    /// This structure tracks both accumulated and unclaimed rewards.
    /// 
    /// # Fields
    /// * `growth_inside` - Accumulated rewards within the position's range
    /// * `amount_owned` - Unclaimed reward amount
    public struct PositionReward has copy, drop, store {
        growth_inside: u128,
        amount_owned: u64,
    }
    
    /// Checks if a position is empty (has no liquidity, fees, or rewards).
    /// A position is considered empty if:
    /// * It has no liquidity
    /// * It has no unclaimed fees for either token
    /// * It has no unclaimed rewards
    /// 
    /// # Arguments
    /// * `position_info` - Reference to the position information structure
    /// 
    /// # Returns
    /// * `true` if the position has no liquidity, fees, or rewards
    /// * `false` otherwise
    public fun is_empty(position_info: &PositionInfo): bool {
        abort 0
    }

    /// Returns an immutable reference to the position information for a given position ID.
    /// This function performs validation to ensure the position exists and the ID matches.
    /// 
    /// # Arguments
    /// * `position_manager` - Reference to the position manager
    /// * `position_id` - ID of the position to borrow
    /// 
    /// # Returns
    /// Immutable reference to the position information
    /// 
    /// # Abort Conditions
    /// * If the position does not exist (error code: EPositionNotFound)
    /// * If the position ID does not match the stored ID (error code: EPositionNotFound)
    public fun borrow_position_info(position_manager: &PositionManager, position_id: sui::object::ID): &PositionInfo {
        abort 0 
    }

    /// Validates that a position exists in the position manager and its ID matches.
    /// This function performs two checks:
    /// * Verifies that the position exists in the position manager's linked table
    /// * Confirms that the stored position ID matches the provided position ID
    /// 
    /// # Arguments
    /// * `position_manager` - Reference to the position manager
    /// * `position_id` - ID of the position to validate
    /// 
    /// # Abort Conditions
    /// * If the position does not exist in the position manager (error code: EPositionNotFound)
    /// * If the position ID does not match the stored ID (error code: EPositionNotFound)
    public fun validate_position_exists(position_manager: &PositionManager, position_id: sui::object::ID) {
        abort 0
    }
    
    /// Validates the tick range for a position.
    /// Checks that:
    /// * Lower tick is less than upper tick
    /// * Lower tick is greater than or equal to minimum allowed tick
    /// * Upper tick is less than or equal to maximum allowed tick
    /// * Both ticks are aligned with the tick spacing
    /// 
    /// # Arguments
    /// * `tick_lower` - Lower tick boundary
    /// * `tick_upper` - Upper tick boundary
    /// * `tick_spacing` - Minimum distance between initialized ticks
    /// 
    /// # Abort Conditions
    /// * If any of the tick range validation conditions are not met (error code: EInvalidTickRange)
    public fun check_position_tick_range(tick_lower: integer_mate::i32::I32, tick_upper: integer_mate::i32::I32, tick_spacing: u32) {
        abort 0
    }

    
    /// Returns the description of a position.
    /// 
    /// # Arguments
    /// * `position` - Reference to the position
    /// 
    /// # Returns
    /// The position's description as a string
    public fun description(position: &Position): std::string::String {
        abort 0
    }

    /// Fetches a list of position information up to the specified limit.
    /// If pre_start_position_id is None, starts from the first position in the linked table.
    /// Otherwise, starts from the position after the ID specified in pre_start_position_id.
    /// 
    /// # Arguments
    /// * `position_manager` - Reference to the position manager
    /// * `pre_start_position_id` - Optional position ID to start fetching after. If None, starts from the beginning of the table.
    /// * `limit` - Maximum number of positions to return
    /// 
    /// # Returns
    /// Vector of PositionInfo structures containing information about the fetched positions
    /// 
    /// # Details
    /// * Iterates through the linked table of positions
    /// * Returns up to 'limit' number of positions
    /// * If pre_start_position_id is Some, starts from the position after that ID
    /// * If pre_start_position_id is None, starts from the first position in the linked table
    public fun fetch_positions(
        position_manager: &PositionManager,
        pre_start_position_id: Option<sui::object::ID>,
        limit: u64
    ): vector<PositionInfo> {
        abort 0
    }
    
    /// Returns the unique index of a position.
    /// 
    /// # Arguments
    /// * `position` - Reference to the position
    /// 
    /// # Returns
    /// The position's unique index
    public fun index(position: &Position): u64 {
        abort 0
    }

    /// Returns the accumulated fee growth inside the position's range for both tokens.
    /// 
    /// # Arguments
    /// * `position_info` - Reference to the position information
    /// 
    /// # Returns
    /// Tuple containing fee growth for token A and token B
    public fun info_fee_growth_inside(position_info: &PositionInfo): (u128, u128) {
        abort 0
    }

    /// Returns the unclaimed fees for both tokens.
    /// 
    /// # Arguments
    /// * `position_info` - Reference to the position information
    /// 
    /// # Returns
    /// Tuple containing unclaimed fees for token A and token B
    public fun info_fee_owned(position_info: &PositionInfo): (u64, u64) {
        abort 0
    }

    /// Returns the current liquidity in the position.
    /// 
    /// # Arguments
    /// * `position_info` - Reference to the position information
    /// 
    /// # Returns
    /// The current liquidity amount
    public fun info_liquidity(position_info: &PositionInfo): u128 {
        abort 0
    }

    /// Returns the unclaimed FULLSAIL distribution rewards.
    /// 
    /// # Arguments
    /// * `position_info` - Reference to the position information
    /// 
    /// # Returns
    /// The amount of unclaimed FULLSAIL rewards
    public fun info_fullsail_distribution_owned(position_info: &PositionInfo): u64 {
        abort 0
    }

    /// Returns the accumulated points growth inside the position's range.
    /// 
    /// # Arguments
    /// * `position_info` - Reference to the position information
    /// 
    /// # Returns
    /// The accumulated points growth
    public fun info_points_growth_inside(position_info: &PositionInfo): u128 {
        abort 0
    }

    /// Returns the unclaimed points rewards.
    /// 
    /// # Arguments
    /// * `position_info` - Reference to the position information
    /// 
    /// # Returns
    /// The amount of unclaimed points
    public fun info_points_owned(position_info: &PositionInfo): u128 {
        abort 0
    }

    /// Returns the unique identifier of the position.
    /// 
    /// # Arguments
    /// * `position_info` - Reference to the position information
    /// 
    /// # Returns
    /// The position's unique ID
    public fun info_position_id(position_info: &PositionInfo): sui::object::ID {
        abort 0
    }

    /// Returns a reference to the vector of rewards for the position.
    /// 
    /// # Arguments
    /// * `position_info` - Reference to the position information
    /// 
    /// # Returns
    /// Reference to the vector of position rewards
    public fun info_rewards(position_info: &PositionInfo): &vector<PositionReward> {
        abort 0
    }

    /// Returns the tick range of the position.
    /// 
    /// # Arguments
    /// * `position_info` - Reference to the position information
    /// 
    /// # Returns
    /// Tuple containing the lower and upper tick boundaries
    public fun info_tick_range(position_info: &PositionInfo): (integer_mate::i32::I32, integer_mate::i32::I32) {
        abort 0
    }
    
    /// Returns the number of initialized rewards for a position.
    /// 
    /// # Arguments
    /// * `position_manager` - Reference to the position manager
    /// * `position_id` - ID of the position to check
    /// 
    /// # Returns
    /// The number of rewards initialized for the position
    /// 
    /// # Abort Conditions
    /// * If the position does not exist (error code: EPositionNotFound)
    public fun inited_rewards_count(position_manager: &PositionManager, position_id: sui::object::ID): u64 {
        abort 0
    }

    /// Checks if a position exists in the position manager.
    /// 
    /// # Arguments
    /// * `position_manager` - Reference to the position manager
    /// * `position_id` - ID of the position to check
    /// 
    /// # Returns
    /// * `true` if the position exists
    /// * `false` otherwise
    public fun is_position_exist(position_manager: &PositionManager, position_id: sui::object::ID): bool {
        abort 0
    }

    /// Checks if a position is currently staked for FULLSAIL rewards.
    /// 
    /// # Arguments
    /// * `position_info` - Reference to the position information
    /// 
    /// # Returns
    /// * `true` if the position is staked
    /// * `false` otherwise
    public fun is_staked(position_info: &PositionInfo): bool {
        abort 0
    }

    /// Returns the current liquidity of a position.
    /// 
    /// # Arguments
    /// * `position` - Reference to the position
    /// 
    /// # Returns
    /// The current liquidity amount
    public fun liquidity(position: &Position): u128 {
        abort 0
    }

    /// Returns the name of a position.
    /// 
    /// # Arguments
    /// * `position` - Reference to the position
    /// 
    /// # Returns
    /// The position's name as a string
    public fun name(position: &Position): std::string::String {
        abort 0
    }


    /// Returns the ID of the pool that this position belongs to.
    /// 
    /// # Arguments
    /// * `position` - Reference to the position
    /// 
    /// # Returns
    /// The pool's unique identifier
    public fun pool_id(position: &Position): sui::object::ID {
        abort 0
    }

    /// Returns the unclaimed amount for a reward.
    /// 
    /// # Arguments
    /// * `reward` - Reference to the reward
    /// 
    /// # Returns
    /// The amount of unclaimed rewards
    public fun reward_amount_owned(reward: &PositionReward): u64 {
        abort 0
    }

    /// Returns the accumulated growth inside the position's range for a reward.
    /// 
    /// # Arguments
    /// * `reward` - Reference to the reward
    /// 
    /// # Returns
    /// The accumulated growth amount
    public fun reward_growth_inside(reward: &PositionReward): u128 {
        abort 0
    }

    /// Updates the description of a position.
    /// This function allows modifying the position's description after creation.
    /// 
    /// # Arguments
    /// * `position` - Mutable reference to the position to update
    /// * `description` - New description string for the position
    public fun set_description(position: &mut Position, description: std::string::String) {
        abort 0
    }

    /// Returns the tick range of a position.
    /// This function provides the lower and upper tick boundaries that define the position's price range.
    /// 
    /// # Arguments
    /// * `position` - Reference to the position
    /// 
    /// # Returns
    /// Tuple containing:
    /// * Lower tick boundary (i32)
    /// * Upper tick boundary (i32)
    public fun tick_range(position: &Position): (integer_mate::i32::I32, integer_mate::i32::I32) {
        abort 0
    }

}

