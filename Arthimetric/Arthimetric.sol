//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Arthimetric {
    //Store the deployer address in owner variable
    address public owner;

    constructor () {
        owner = msg.sender;
    }

    function addition(uint numX, uint numY) external pure returns (uint) {
        return (numX + numY);
    }

    function subtraction(uint numX, uint numY) external pure returns (uint) {
        return (numX - numY);
    }

    function quotient(uint numX, uint numY) external pure returns (uint) {
        require(numY != 0, "The denominator must not be equal to zero");
        return (numX / numY);
    }

    function multiplication(uint numX, uint numY) external pure returns (uint) {
        return (numX * numY);
    }

    function modulos(uint numX, uint numY) external pure returns (uint) {
        return (numX % numY);
    }

}