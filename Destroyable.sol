import "./Ownable.sol";
pragma solidity 0.5.12;

// Destroyable contract
contract Destroyable is Ownable{
    function destroy() public onlyOwner{
        address payable receiver = msd.sender;
        selfdestruct(receiver);
    }
}