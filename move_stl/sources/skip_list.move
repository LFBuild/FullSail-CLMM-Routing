module move_stl::skip_list {
    use std::vector::{push_back};
    use move_stl::option_u64::{Self, OptionU64, none, some, is_none, is_some, swap_or_fill, is_some_and_lte};
    use move_stl::random::{Self, Random};
    use sui::dynamic_field as field;

    const ENodeAlreadyExist: u64 = 0;
    const ENodeDoesNotExist: u64 = 1;
    const ESkipListNotEmpty: u64 = 3;

    #[allow(unused_const)]
    const ESkipListIsEmpty: u64 = 4;

    /// The skip list.
    public struct SkipList<phantom V: store> has key, store {
        /// The id of this skip list.
        id: UID,
        /// The skip list header of each level. i.e. the score of node.
        head: vector<OptionU64>,
        /// The level0's tail of skip list. i.e. the score of node.
        tail: OptionU64,
        /// The current level of this skip list.
        level: u64,
        /// The max level of this skip list.
        max_level: u64,
        /// Basic probability of random of node indexer's level i.e. (list_p = 2, level2 = 1/2, level3 = 1/4).
        list_p: u64,

        /// The size of skip list
        size: u64,

        /// The random for generate ndoe's level
        random: Random,
    }

    /// The node of skip list.
    public struct Node<V: store> has store {
        /// The score of node.
        score: u64,
        /// The next node score of node's each level.
        nexts: vector<OptionU64>,
        /// The prev node score of node.
        prev: OptionU64,
        /// The data being stored
        value: V,
    }

    /// Create a new empty skip list.
    public fun new<V: store>(max_level: u64, list_p: u64, seed: u64, ctx: &mut TxContext): SkipList<V> {
        abort 0
    }

    /// Return the length of the skip list.
    public fun length<V: store>(list: &SkipList<V>): u64 {
        abort 0
    }

    /// Returns true if the skip list is empty (if `length` returns `0`)
    public fun is_empty<V: store>(list: &SkipList<V>): bool {
        abort 0
    }

    /// Return the head of the skip list.
    public fun head<V: store>(list: &SkipList<V>): OptionU64 {
        abort 0
    }

    /// Return the tail of the skip list.
    public fun tail<V: store>(list: &SkipList<V>): OptionU64 {
        abort 0
    }

    /// Destroys an empty skip list
    /// Aborts with `ETableNotEmpty` if the list still contains values
    public fun destroy_empty<V: store + drop>(list: SkipList<V>) {
        abort 0
    }

    /// Returns true if there is a value associated with the score `score` in skip list
    public fun contains<V: store>(list: &SkipList<V>, score: u64): bool {
        abort 0
    }

    /// Acquire an immutable reference to the `score` element of the skip list `list`.
    /// Aborts if element not exist.
    public fun borrow<V: store>(list: &SkipList<V>, score: u64): &V {
        abort 0
    }

    /// Return a mutable reference to the `score` element in the skip list `list`.
    /// Aborts if element is not exist.
    public fun borrow_mut<V: store>(list: &mut SkipList<V>, score: u64): &mut V {
        abort 0
    }

    /// Acquire an immutable reference to the `score` node of the skip list `list`.
    /// Aborts if node not exist.
    public fun borrow_node<V: store>(list: &SkipList<V>, score: u64): &Node<V> {
        abort 0
    }

    /// Return a mutable reference to the `score` node in the skip list `list`.
    /// Aborts if node is not exist.
    public fun borrow_mut_node<V: store>(list: &mut SkipList<V>, score: u64): &mut Node<V> {
        abort 0
    }

    /// Return the metadata info of skip list.
    public fun metadata<V: store>(list: &SkipList<V>): (vector<OptionU64>, OptionU64, u64, u64, u64, u64) {
        abort 0
    }

    /// Return the next score of the node.
    public fun next_score<V: store>(node: &Node<V>): OptionU64 {
        abort 0
    }

    /// Return the prev score of the node.
    public fun prev_score<V: store>(node: &Node<V>): OptionU64 {
        abort 0
    }

    /// Return the immutable reference to the ndoe's value.
    public fun borrow_value<V: store>(node: &Node<V>): &V {
        abort 0
    }

    /// Return the mutable reference to the ndoe's value.
    public fun borrow_mut_value<V: store>(node: &mut Node<V>): &mut V {
        abort 0
    }

    /// Insert a score-value into skip list, abort if the score alread exist.
    public fun insert<V: store>(list: &mut SkipList<V>, score: u64, v: V) {
        abort 0
    }

    /// Remove the score-value from skip list, abort if the score not exist in list.
    public fun remove<V: store>(list: &mut SkipList<V>, score: u64): V {
        abort 0
    }

    /// Return the next score.
    public fun find_next<V: store>(list: &SkipList<V>, score: u64, include: bool): OptionU64 {
        abort 0
    }

    /// Return the prev socre.
    public fun find_prev<V: store>(list: &SkipList<V>, score: u64, include: bool): OptionU64 {
        abort 0
    }

    /// Find the nearest score. 1. score, 2. prev, 3. next
    fun find<V: store>(list: &SkipList<V>, score: u64): OptionU64 {
        abort 0
    }

    fun rand_level<V: store>(seed: u64, list: &SkipList<V>): u64 {
        abort 0
    }

    /// Create a new skip list node
    fun create_node<V: store>(list: &mut SkipList<V>, score: u64, value: V): (u64, Node<V>) {
        abort 0
    }

    fun drop_node<V: store>(node: Node<V>): V {
        abort 0
    }
}