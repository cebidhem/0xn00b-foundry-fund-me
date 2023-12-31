// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {MockPriceConverter} from "../mocks/MockPriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConverterTest is Test {
    HelperConfig helperConfig = new HelperConfig();
    address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
    uint256 constant ETH_PRICE = 2000e8;
    uint256 constant ETH_AMOUNT = 5;

    MockPriceConverter mockPriceConverter;

    constructor() {
        mockPriceConverter = new MockPriceConverter();
    }

    function testGetPrice() external {
        // Call the external getPrice function
        uint256 price = mockPriceConverter.mockGetPrice(
            AggregatorV3Interface(ethUsdPriceFeed)
        );

        console.log("Price: ", price);
        assertEq(price, ETH_PRICE);
    }

    function testGetConversionRate() external {
        // Call the external getPrice function
        uint256 conversionRate = mockPriceConverter.mockGetConversionRate(
            ETH_AMOUNT,
            AggregatorV3Interface(ethUsdPriceFeed)
        );

        console.log("Conversion rate: ", conversionRate);
        assertEq(conversionRate, (ETH_AMOUNT * ETH_PRICE) / 1e8);
    }
}
