pragma solidity 0.5.12;

// interface is the definition of a contract and it's functions
// it does not contain the full implementation
contract People {
    // put the definitions of the function you want to CALL
    function createPerson(string memory name, uint age, uint height) public payable;
}

contract ExternalContract{
    
    //define an instance for the contract you want to interact with
    // put the address of that contract
    People instance = People(0xC541BE9E8252E839DAF0B31c51421a6bc9b33113); 
    
    function externalCreatePerson(string memory name, uint age, uint height) public payable {
        // CALL createPerson in People contract
        // Forward any ether to People contract
        instance.createPerson.value(msg.value)(name, age, height);
    }
}