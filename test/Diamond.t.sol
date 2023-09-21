// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {Diamond} from "../src/Diamond.sol";
import {DataFacet} from "../src/facets/DataFacet.sol";
import {Deploy} from "../script/Deploy.s.sol";
import {AppStorage} from "../src/AppStorage.sol";
import {OwnerFacet} from "../src/facets/OwnerFacet.sol";

contract DiamondTest is Test {
    Deploy deploy;
    Diamond diamond;
    DataFacet dataFacet;
    OwnerFacet ownerFacet;

    bytes4 setDataSig = getFunctionSig("setData(uint256)");
    bytes4 getDataSig = getFunctionSig("getData()");

    uint256 constant DATA = 1337;

    function setUp() external {
        deploy = new Deploy();
        (diamond, dataFacet, ownerFacet) = deploy.run();

        // Add facet
        bytes4[] memory functionSigs = new bytes4[](2);
        functionSigs[0] = setDataSig;
        functionSigs[1] = getDataSig;

        vm.prank(address(deploy));
        diamond.addFacet(address(dataFacet), functionSigs);

        // Call facet
        vm.startPrank(address(deploy));
        bytes memory data = abi.encodeWithSelector(setDataSig, uint256(DATA));
        (bool result,) = address(diamond).call(data);
        vm.stopPrank();
        assertTrue(result, "Call should succeed");

        // Call facet
        data = abi.encodeWithSelector(getDataSig);
        (result, data) = address(diamond).staticcall(data);
        assertTrue(result, "Call should succeed5");
        assertEq(abi.decode(data, (uint256)), uint256(DATA), "Data should be 1337");
    }

    function testChangeOwnerFacet() external {
        // Add facet
        bytes4[] memory functionSigs = new bytes4[](1);
        functionSigs[0] = getFunctionSig("changeOwner(address)");

        vm.prank(address(deploy));
        diamond.addFacet(address(ownerFacet), functionSigs);

        // Call facet
        vm.startPrank(address(deploy));
        bytes memory data = abi.encodeWithSelector(getFunctionSig("changeOwner(address)"), address(this));
        (bool result,) = address(diamond).call(data);

        vm.stopPrank();
        assertTrue(result, "Call should succeed");

        // Call facet
        data = abi.encodeWithSelector(getFunctionSig("owner()"));
        (result, data) = address(diamond).staticcall(data);
        assertTrue(result, "Call should succeed");
        assertEq(abi.decode(data, (address)), address(this), "Owner should be this");
    }

    function getFunctionSig(string memory _function) internal pure returns (bytes4) {
        return bytes4(keccak256(bytes(_function)));
    }
}
