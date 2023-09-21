// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

struct AppStorage {
    uint256 data;
    mapping (bytes4 functionSelector => address facet) facets;
    address owner;
}