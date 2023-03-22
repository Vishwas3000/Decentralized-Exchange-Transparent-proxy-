// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CryptoDevToken is ERC20, Ownable {
    uint256 public constant TOKEN_PRICE = 0.001 ether;
    uint256 public constant TOKEN_PER_NFT = 10 * 10 ** 18;
    uint256 public constant MAX_SUPPLY_LIMIT = 10000 * 10 ** 18;

    mapping(uint256 => bool) public isTokenIdClimed;

    constructor()  ERC20("Crypto Dev Token", "CD") {}

    function mint(uint256 amount) public payable {
        uint256 requiredAmount = TOKEN_PRICE * amount;
        require(msg.value >= requiredAmount, "Ether Send is incorrect");

        uint256 amountWithDecimals = amount * 10 ** 18;
        require((totalSupply() + amountWithDecimals) <= MAX_SUPPLY_LIMIT, "Exceeds the max total supply available.");

        _mint(msg.sender, amountWithDecimals);
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "Nothing to withdraw, contract balance empty");

        address _owner = owner();
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
