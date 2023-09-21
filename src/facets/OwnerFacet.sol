// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {AppStorage} from "../AppStorage.sol";

contract OwnerFacet {
    AppStorage internal s;

    modifier onlyOwner() {
        require(s.owner == msg.sender, "Must be owner");
        _;
    }

    function changeOwner(address _newOwner) external onlyOwner {
        s.owner = _newOwner;
    }
}