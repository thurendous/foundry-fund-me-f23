// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/deployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    // first thing we need is the setup function
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();

        console.log("chain id is: ", block.chainid);
    }

    function testDemo() public {}

    function testConstantValue() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log("address this:", address(this));
        console.log("msgsender: ", msg.sender);
        console.log("i_owner: ", fundMe.i_owner());
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund{value: 1e15}();
    }
}
