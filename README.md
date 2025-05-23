# FullSail-CLMM-Routing

This repository contains interfaces for Concentrated Liquidity Market Maker (CLMM) pool methods to implement routing functionality. It provides the necessary abstractions and type definitions for working with concentrated liquidity pools in a routing context.

## CLMM Addresses (Mainnet)

- Integrate Package: `0x33099e34713487116f34c2beb736517e23f568101386f5dc82f7400eead2b442`
- GlobalConfig: `0x5771eae1894344bc43d9cf44f0855051b83137199205c6e4d43d914b8b7b9f9f`
- RewarderGlobalVault: `0x87be56e85d020cc1a3e9507cbfc3087c9b19e08d9ce9c39ac22f70c2206d2026`
- Stats: `0xde78eef470e06033becc250c3083529ffd775e750d0b2f3078763757dcff97d2`
- PriceProvider: `0x24137497ad14221f8e3ca0e0a6308f4b8937bfd308582dcb106900fe7f9acdf2`
- Pools: `0x7e2c747393daa61ce150f47ad67ef2a1c3fc87addb093e525c636123934acd44`

- USDC/SUI Pool `0x209636634973adbc87326370d197529cd7960e8ca8d2a01a600b375269c93bd6`

## Getting Pool Information

To get information about liquidity pools, you can use the `fetch_pools` method from the `factory` module. This method returns a vector of `PoolSimpleInfo` structures containing basic pool information.

The `tick_spacing` field from `PoolSimpleInfo` can be used to determine the swap fee rate by calling `fee_tiers` from the `config` module, where each `tick_spacing` corresponds to a specific `fee_rate`.