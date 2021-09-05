pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT
import "node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20Lock{
    
    using SafeERC20 for IERC20;
    
    address public owner;
   
    
    event TokenReceived(address indexed to, uint amount);// Log the event about a deposit being made by an address and its amount
    event TokenSent(address indexed to,uint amount); // Log the even about withdrawal being made
    
    
    constructor (){ 
        owner = msg.sender;
    }
    
   modifier onlyOwner() {
    require(msg.sender == owner);
    _;
}

function deposit(address token, uint amount)external {
    IERC20(token).transferFrom(msg.sender, address(this), amount);
    emit TokenReceived(to,amount);
}
  receive() external payable{}
    

function withdraw(IERC20 token, address recipient, uint256 amount) external onlyOwner{
       if (token == address(0)){
           recipient.transfer(amount);
       }else{
        token.transfer(recipient, amount);
    }
  
}