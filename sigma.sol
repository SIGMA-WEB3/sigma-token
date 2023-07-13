// SPDX-License-Identifier: MIT
// SIGMA TOKEN
// FOR TRUE SIGMAS
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SIGMA is ERC20, Ownable {
    address public treasury;
    uint256 public transactionFeePercentage = 5; // 5% transaction fee

    constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) ERC20(name, symbol) {
        _mint(msg.sender, totalSupply);
        treasury = 0x34a9dd93E02eF47A89fBb2c16837337De64D6f30;
    }

    function setTransactionFeePercentage(uint256 percentage) external onlyOwner {
        require(percentage <= 10, "Percentage must be between 0 and 10");
        transactionFeePercentage = percentage;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        uint256 fee = calculateTransactionFee(amount);
        uint256 valueAfterFee = amount - fee;
        _transfer(msg.sender, recipient, valueAfterFee);
        _transfer(msg.sender, treasury, fee);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        uint256 fee = calculateTransactionFee(amount);
        uint256 valueAfterFee = amount - fee;
        _transfer(sender, recipient, valueAfterFee);
        _transfer(sender, treasury, fee);
        _approve(sender, msg.sender, allowance(sender, msg.sender) - amount + valueAfterFee);
        return true;
    }

    function calculateTransactionFee(uint256 amount) internal view returns (uint256) {
        return (amount * transactionFeePercentage) / 100;
    }
}
