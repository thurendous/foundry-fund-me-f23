// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./Helper.config.s.sol";

contract DeployFundMe is Script {
    // this run function will deploy contract on any chain we want. It will automatically change the address of the price feed based on the chain we are on.
    function run() public payable returns (FundMe) {
        FundMe fundMe;
        // anything before startBroadcast -> Not a "real" tx
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        // (address ethUsdPriceFeed) = helperConfig.activeNetworkConfig();
        // anything after stopBroadcast -> Real tx
        vm.startBroadcast();
        fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
