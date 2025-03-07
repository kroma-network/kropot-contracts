// SPDX-License-Identifier: MIT

import {EcoERC20Upgradeable} from "../eco-libs/contracts/token/ERC20/EcoERC20Upgradeable.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

pragma solidity ^0.8.0;

struct Sig {
    uint8 v;
    bytes32 r;
    bytes32 s;
}

contract ERC20Test is EcoERC20Upgradeable {
    constructor() {
        initEcoERC20(_msgSender(), "ERC20Test", "E2T", 18);
    }
}

contract KRO is EcoERC20Upgradeable {
    constructor() {
        initEcoERC20(_msgSender(), "KROMA", "KRO", 18);
    }
}

contract OP is EcoERC20Upgradeable {
    constructor() {
        initEcoERC20(_msgSender(), "Optimism", "OP", 18);
    }
}
