// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    error InvalidAmount();

    constructor() ERC20("MyToken", "MTK") {}

    function mint(
        uint256 amount
    ) external {
    if(amount == 0){
        revert InvalidAmount();
    }
        _mint(msg.sender, amount);
    }
}