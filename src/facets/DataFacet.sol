// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.21;

import {AppStorage} from "../AppStorage.sol";

contract DataFacet {
    error MustBeOwner();

    AppStorage internal s;

    modifier onlyOwner() {
        if (s.owner != msg.sender) {
            revert MustBeOwner();
        } 
        _;
    }

    function setData(uint256 _data) external onlyOwner {
        s.data = _data;
    }

    function getData() external view returns (uint256) {
        return s.data;
    }
}