pragma solidity 0.5.12;

contract Ownable{
    address public owner; // address internal owner;
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _; 
    }
    
    constructor() public {
        owner = msg.sender; 
    }
}