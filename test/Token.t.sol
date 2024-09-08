// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TokenTest is Test {
    Token token;

    address deployer = makeAddr("deployer");
    address marketplace = makeAddr("marketplace");
    address miner = makeAddr("miner");

    function setUp() external {
        vm.startPrank(deployer);
        token = new Token(marketplace);
        vm.stopPrank();
    }

    function testNameAndSymbol() external view {
        string memory symbolActual = token.symbol();
        string memory nameActual = token.name();

        string memory symbolExpected = "MV";
        string memory nameExpected = "METAVERSE";
        assertEq(symbolActual, symbolExpected);
        assertEq(nameActual, nameExpected);
    }

    function testCanMintingAndGetApproved() external {
        string memory uriExample = "uriExample";
        uint256 idOfMiner;

        vm.startPrank(miner);
        idOfMiner = token.mint(uriExample);

        assert(miner == token.ownerOf(idOfMiner));
        assertEq(token.tokenURI(idOfMiner), uriExample);
        vm.stopPrank();
    }

    function testMarketplacerIsSame() external view {
        assertEq(token.marketplace(), marketplace);
    }

    function testCantChangeMarketplaceUnlessOwner() external {
        address newMarketplace = makeAddr("newMarketplace");
        vm.prank(miner);
        vm.expectRevert();
        token.setMarketplace(newMarketplace);

        vm.startPrank(deployer);
        token.setMarketplace(newMarketplace);
        vm.stopPrank();

        assertEq(token.marketplace(), newMarketplace);
    }
}
