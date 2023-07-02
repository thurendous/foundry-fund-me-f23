// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/deployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    address USER = makeAddr("alice"); // cheat code
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() public {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        console.log("chain id is: ", block.chainid);
        vm.deal(USER, 10 ether);
    }

    function testUseerCanFundInteractions() external {
        FundFundMe fundFundMe = new FundFundMe();
        vm.startPrank(USER);
        console.log("USER balance: ", address(USER).balance);
        // vm.deal(USER, 10 ether);
        fundFundMe.fundFundMe(address(fundMe));
        assertEq(fundMe.getAddressToAmountFunded(USER), 0.01 ether);
        vm.stopPrank();
    }
}
