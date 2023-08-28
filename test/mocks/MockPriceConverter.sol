// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";

contract MockPriceConverter {
    // Function to expose getPrice for testing purposes
    function mockGetPrice(
        AggregatorV3Interface priceFeed
    ) external view returns (uint256) {
        return PriceConverter.getPrice(priceFeed);
    }

    // Function to expose getConversionRate for testing purposes
    function mockGetConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) external view returns (uint256) {
        return PriceConverter.getConversionRate(ethAmount, priceFeed);
    }
}
