// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract DeployFundMeTest is Test {
    FundMe fundMe;

    function testDeployFundMe() public {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        console.log("FundMe deployed at %s", address(fundMe));
        assertEq(
            address(fundMe),
            address(0xA8452Ec99ce0C64f20701dB7dD3abDb607c00496)
        );
    }
}
