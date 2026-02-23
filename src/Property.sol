// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {ERC20Token} from "./ERC20Token.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Property is Ownable{
ERC20Token public erc20Token;
address public contractOwner;
uint private id_;

// * create a property.
// * add intuitive property details during creation.
// * remove a property.
// * get all properties.
// * properties are for sale and have their prices.
// * buy / purchase property.
// * use the openzeppellin library for payments with your own token.
// * Introduce the use of role based access with modifiers.

struct PropertyDetails{
    uint id;
    string name;
    address owner;
    uint price;
}

PropertyDetails[] public properties;
error YouDontOwnThisProperty();

constructor(address _tokenAddress) Ownable(contractOwner) {
    erc20Token = ERC20Token(_tokenAddress);
}

function createProperty(string memory _name, uint _price) external {
PropertyDetails memory newProperty = PropertyDetails({
id: ++id_,
name: _name,
owner: msg.sender,
price:_price
});

properties.push(newProperty);
}

function removePropertyByPropOwner(uint _id) external {
address propOwner;
for(uint i = 0; i < properties.length; i++){
    propOwner = properties[i].owner;
    if(propOwner != msg.sender){
    revert YouDontOwnThisProperty();
}
    if(properties[i].id == _id){
        properties[i] = properties[properties.length-1];
        properties.pop();
    }
}
}

function removePropertyByAdmin(uint _id) external onlyOwner{
for(uint i = 0; i < properties.length; i++){
    if(properties[i].id == _id){
        properties[i] = properties[properties.length-1];
        properties.pop();
    }
}
}

function purchaseProperty(uint _id) external {
    uint propPrice;
    address propOwner;
    for(uint i = 0; i < properties.length; i++){
    if(properties[i].id == _id){
    propPrice = properties[i].price;
    propOwner = properties[i].owner;
    properties[i].owner = msg.sender;
    }
    }
    erc20Token.transferFrom(msg.sender, propOwner, propPrice);
}

function getAllProperties() external view returns(PropertyDetails[] memory){
    return properties;
}
}
