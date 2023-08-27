// SPDX-License-Identifier: MIT
pragma solidity 0.8.19; // This indicates the version of solidity compiler to use

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // Price of ETH in USD
        // 2000.00000000
        return uint256(price * 1e10);
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // 1ETH
        // 2000_000000000000000000
        uint256 ethPrice = getPrice(priceFeed);
        // 2000_000000000000000000 * 1_000000000000000000 / 1e18
        // $2000 = 1ETH
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}