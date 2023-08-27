// Get funds
// Withdraw funds
// Set a min vakue

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19; // This indicates the version of solidity compiler to use

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

// 824,346 without constant / immutable
// 804,388 with constant
// 780,785 with immutable

error FundMe_NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    address[] private s_funders;
    mapping(address funder => uint256 amountFunded)
        private s_addressToAmountFunded;

    uint256 public constant MINIMUM_USD = 5e18; // 5 * 1e18 // 351 with constant, 2451 non constant
    address private immutable i_owner; // 444 with immutable, 2580 non immutable
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        msg.value.getConversionRate(s_priceFeed);
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "didn't send enough ETH"
        ); // 1e18 = 1ETH = 1000000000000000000 Wei
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] =
            s_addressToAmountFunded[msg.sender] +
            msg.value; // +=
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLenght = s_funders.length;
        for (
            uint256 funderIndex = 0;
            funderIndex < fundersLenght;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    function withdraw() public onlyOwner {
        // require(msg.sender == owner, "Must be owner");
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            // funderIndex++ is increment
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        // reset the array
        s_funders = new address[](0);
        // withdraw

        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "transfer has failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner");

        // more gas efficient than require() but less readable
        // could be require(msg.sender == i_owner, NotOwner());
        if (msg.sender != i_owner) {
            revert FundMe_NotOwner();
        }
        _; // whatever else is in the function, here withdraw
    }

    // what happens is eth are sent without calling the fund function
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
