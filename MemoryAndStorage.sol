pragma solidity 0.5.12;


// The new working solution
contract MemoryAndStorage {

    uint[] users;
    
    
    function addUser(uint balance) public {
        users.push(balance);
    }

    function updateBalance(uint id, uint balance) public {
         users[id] = balance;
    }

    function getBalance(uint index) public view returns (uint balance) {
        return users[index];
    }

}


///////////////////////////////////////////////////
//    Filip solution working
/*
pragma solidity 0.5.1;
contract MemoryAndStorage {

    mapping(uint => User) users;

    struct User{
        uint id;
        uint balance;
    }

    function addUser(uint id, uint balance) public {
        users[id] = User(id, balance);
    }

        function updateBalance(uint id, uint balance) public {
         users[id].balance = balance;
    }

    function getBalance(uint id) view public returns (uint) {
        return users[id].balance;
    }

}
*/


///////////////////////////////////////////////////
//    The old solution not working
/*
pragma solidity 0.5.1;
contract MemoryAndStorage {

    mapping(uint => User) users;

    struct User{
        uint id;
        uint balance;
    }

    function addUser(uint id, uint balance) public {
        users[id] = User(id, balance);
    }

        function updateBalance(uint id, uint balance) public {
         User memory user = users[id];
         user.balance = balance;
    }

    function getBalance(uint id) view public returns (uint) {
        return users[id].balance;
    }

}
*/