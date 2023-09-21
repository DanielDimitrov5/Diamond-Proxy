// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {AppStorage} from "./AppStorage.sol";
import {console} from "forge-std/console.sol";

contract Diamond {
    AppStorage internal s;

    constructor() {
        s.owner = msg.sender;
    }

    modifier onlyOwner() {
        require(s.owner == msg.sender, "Must be owner");
        _;
    }

    function addFacet(address _facet, bytes4[] memory _functionSigs) external onlyOwner {
        require(_functionSigs.length != 0, "Functions are required");

        for (uint256 i; i < _functionSigs.length; i++) {
            require(s.facets[_functionSigs[i]] == address(0), "Function already exists");

            s.facets[_functionSigs[i]] = _facet;
        }
    }

    function getFacet(bytes4 _functionSig) external view returns (address) {
        return s.facets[_functionSig];
    }

    fallback() external payable {
        address facet = s.facets[msg.sig];
        require(facet != address(0), "Facet not found");

        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
            // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {
        revert("Contract does not accept Ether directly");
    }

    function owner() external view returns (address) {
        return s.owner;
    }
}
