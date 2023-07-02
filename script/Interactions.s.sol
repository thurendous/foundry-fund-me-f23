// SPDX-License-Identifier: MIT

// Fund

// Withdraw

pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

// script for funding
contract FundFundMe is Script {
    uint256 constant AMOUNT = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        FundMe(payable(mostRecentlyDeployed)).fund{value: AMOUNT}();
        console.log("Funded contract:", mostRecentlyDeployed);
        console.log("Funded amount:", AMOUNT);
    }

    function run() external {
        vm.startBroadcast();

        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("Fundme", block.chainid);
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

// script for withdrawing
contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        FundMe(payable(mostRecentlyDeployed)).withdraw();
    }

    function run() external {
        vm.startBroadcast();

        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("Fundme", block.chainid);
        withdrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}
