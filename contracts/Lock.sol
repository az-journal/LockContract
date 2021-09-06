pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT
import "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract ERC20Lock {
    
    using SafeERC20 for IERC20;
    
    address public owner;

    
    event TokenReceived(address indexed token, address indexed from, uint amount);// Log the event about a deposit being made by an address and its amount
    event TokenSent(address indexed token, address indexed to, uint amount); // Log the even about withdrawal being made
    
    constructor (address owner_) { 
        owner = owner_;
    }

    function deposit(address token, uint amount) external {
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        emit TokenReceived(token, msg.sender, amount);
    }

    function withdraw(address token, address recipient, uint256 amount) external {
        require(msg.sender == owner);
        if (token == address(0)){
            recipient.transfer(amount);
        } else {
            IERC20(token).safeTransfer(recipient, amount);
        }
        emit TokenSent(token, recipient, amount);
    }
}
