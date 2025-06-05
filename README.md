# FullSail-CLMM-Routing

This repository contains interfaces for Concentrated Liquidity Market Maker (CLMM) pool methods to implement routing functionality. It provides the necessary abstractions and type definitions for working with concentrated liquidity pools in a routing context.

## CLMM Addresses (Mainnet)

- Integrate Package: `0xe1b7d5fd116fea5a8f8e85c13754248d56626a8d0a614b7d916c2348d8323149`
- clmm_pool package `0xe74104c66dd9f16b3096db2cc00300e556aa92edc871be4bc052b5dfb80db239`
- GlobalConfig: `0xe93baa80cb570b3a494cbf0621b2ba96bc993926d34dc92508c9446f9a05d615`
- RewarderGlobalVault: `0xfb971d3a2fb98bde74e1c30ba15a3d8bef60a02789e59ae0b91660aeed3e64e1`
- Stats: `0x6822a33d1d971e040c32f7cc74507010d1fe786f7d06ab89135083ddb07d2dc2`
- PriceProvider: `0x854b2d2c0381bb656ec962f8b443eb082654384cf97885359d1956c7d76e33c9`
- Pools: `0x0efb954710df6648d090bdfa4a5e274843212d6eb3efe157ee465300086e3650`

You can fetch all the available pools using `Pools` object, but here are examples of our pools:
- USDC-WBTC `0x195fa451874754e5f14f88040756d4897a5fe4b872dffc4e451d80376fa7c858`
- USDC-SUI `0x7fc2f2f3807c6e19f0d418d1aaad89e6f0e866b5e4ea10b295ca0b686b6c4980`
- USDC-USDT `0xb41cf6d7b9dfdf21279571a1128292b56b70ad5e0106243db102a8e4aea842c7`
- USDC-ETH `0x90ad474a2b0e4512e953dbe9805eb233ffe5659b93b4bb71ce56bd4110b38c91`
- WAL-SUI `0x20e2f4d32c633be7eac9cba3b2d18b8ae188c0b639f3028915afe2af7ed7c89f`
- DEEP-SUI `0xd0dd3d7ae05c22c80e1e16639fb0d4334372a8a45a8f01c85dac662cc8850b60`

## Getting Pool Information

To get information about liquidity pools, you can use the `fetch_pools` method from the `factory` module. This method returns a vector of `PoolSimpleInfo` structures containing basic pool information.

The `tick_spacing` field from `PoolSimpleInfo` can be used to determine the swap fee rate by calling `fee_tiers` from the `config` module, where each `tick_spacing` corresponds to a specific `fee_rate`.
