// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {AppStorage} from "../src/AppStorage.sol";
import {Diamond} from "../src/Diamond.sol";
import {DataFacet} from "../src/facets/DataFacet.sol";
import {OwnerFacet} from "../src/facets/OwnerFacet.sol";

contract Deploy {
    AppStorage internal s;

    constructor() {
        s.owner = msg.sender;
    }

    function run() external returns (Diamond diamond, DataFacet dataFacet, OwnerFacet ownerFacet) {
        diamond = new Diamond();
        dataFacet = new DataFacet();
        ownerFacet = new OwnerFacet();
    }
}
