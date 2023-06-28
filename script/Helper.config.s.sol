// SPDX-License-Identifier: MIT

// 1. deploys mocks when we are on a local anvil chain
// 2. Keep track of contract address across different chains
// Sepolia ETH/USD
// Mainnet ETH/USD

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // if we are on a local anvila chain, deploy the mocks
    // Otherwise, grab the existing address from the live network

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed
    }

    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant ETH_PRICE = 2000e8;
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            console.log("using existing contract on Sepolia");
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 42161) {
            console.log("using existing contract on Arbitrum");
            activeNetworkConfig = getArbitrumEthConfig();
        } else {
            console.log("deploying mocks to test");
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        // vrf address, gas price, chainlink token address etc
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getArbitrumEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        // vrf address, gas price, chainlink token address etc
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612
        });
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // price feed address exists then do not deploy a new one
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        // 1. deploy the mpcks
        vm.startBroadcast();
        MockV3Aggregator mockEthUsdPriceFeed = new MockV3Aggregator(
            DECIMALS,
            ETH_PRICE
        );
        vm.stopBroadcast();

        // 2. return the mock addresses
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockEthUsdPriceFeed)
        });
        return anvilConfig;
    }
}
