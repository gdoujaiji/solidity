pragma solidity 0.5.12;


contract People{
    // state variables

    struct Person {
        //uint id;
        string name;
        uint age;
        uint height;
        bool senior;
    }
    
    uint public balance; // to store and track the balance that is received
    
    // events in solidity is like notifications in web and mobile applications
    event personCreated(string name, bool senior);
    event personDeleted(string name, bool senior, address deletedBy);
    
    // "data locations" is where we tell solidity to save the data
    // there are three different "data locations"
    // 1. storage: everything that is saved permanently; it is available as long as the contract lives
    // 2. memory: only saved during function execution
    // 3. stack: holds local variables of value types. e.g. uint bool. also gets deleted when function is done executions
    
    // following is an example of storage data locations
    address public owner; // put public only to retreive address for testing otherwise remove it 
    
    // modifier function is used instead of a repeatitive code in some other functions
    modifier onlyOwner(){
        require(msg.sender == owner);
        _; // this will tell solidity that the modifier is done and to continue the execution
    }
    
    modifier costs(uint cost){
        require(msg.value >= cost);
        _;
    }
    
    // constructor is a function run whenever the contract is created one time only
    // it needs to be public
    // can not be called manually
    // you should set the owner only at the time of creation
    constructor() public {
        owner = msg.sender; // msg.sender in the constructor will be the person that initiated the contract creation
    }

     // following is an example of storage data locations
    mapping(address => Person) private people; // mapping is a key value system that can not be looped
    
     // following is an example of storage data locations
    address[] private creators; // this array to save the addresses; so that the owner can know the address he wants to delete
    
    // how to let a function send or receive money
    // by adding "payable" keyword to the header of the function
    function createPerson(string memory name, uint age, uint height) public payable costs(1 ether) {
        // most clear way to create the person //
        //people.push(Person(people.length, name, age, height)); // people.length will be the id which is the index of the array
        
        require(age <= 130, "Age needs to be below 130"); // to control valid inputs
        // we used modifier "costs" instead // require(msg.value >= 1 ether); // this is how to track and receive the money
        balance += msg.value; // to store the value received in the balance
        
        // This creates a person
        Person memory newPerson;
        //newPerson.id = people.length; // not needed in mapping
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        // control flow using if else statement
        if(age >= 65){
            newPerson.senior = true;
        } else {
            newPerson.senior = false;
        }

        insertPerson(newPerson); 
        creators.push(msg.sender); // to save the creator address in the array
        
        // using assert() function
        // create the following issue
        // check if people[msg.sender] == newPerson
        // you need to hash then compare 
        // assert function will fire only if there is error in our code
        assert(keccak256(abi.encodePacked(people[msg.sender].name, people[msg.sender].age, people[msg.sender].height, people[msg.sender].senior)) == keccak256(abi.encodePacked(newPerson.name, newPerson.age, newPerson.height, newPerson.senior)));
        
        // we use the event defined in order to notify that new senior person is created
        emit personCreated(newPerson.name, newPerson.senior);
    }
    
    // internal function used by createPerson() function
    function insertPerson(Person memory newPerson) private {
        address creator = msg.sender;
        people[creator] = newPerson;
    }
    
    
    // function getPersonn() public returns(Person memory) this is for newer versions of pragma
    function getPersonn() public view returns(string memory name, uint age, uint height, bool senior){
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior);
    }
    
    // function delete Person
    function deletePerson(address creator) public onlyOwner {
        string memory name = people[creator].name;
        bool senior = people[creator].senior;
        //require(msg.sender == owner); // to make sure that only the owner can make delete operation
        delete people[creator]; // that will delete the key from the mapping
        // another example for using assert function after deleting the struct from the mapping
        // no need to hash because we are comparing integers
        //assert(people[creator].age == 10); // assert will fire an error
       assert(people[creator].age == 0); // assert will not fire an error
       emit personDeleted(name, senior, msg.sender);
    }
    
    // function to get the addresses
    function getCreatorAddress(uint index) public view onlyOwner returns(address){
        // we used modifier "onlyOwner" instead //require(msg.sender == owner, "Caller needs to be owner"); // restrist access only to owner
        return creators[index];
    }
    
    // function to send the balance of the contract to the owner
    function withdrawAllBalance() public onlyOwner returns(uint){
        uint toTransfer = balance; // save the balance to a local variable
        balance = 0; // for security reason, reset the balance before sending the amount
        msg.sender.transfer(toTransfer); // "transfer()" function is for sending money in solidity smart contract most used option
        // if transfer failed then the function will throw an error and revert automatically and amount will go back to balance
        // another options to send money:
        //msg.sender.send(toTransfer); // if sending failed, it just return false. This make big difference between send() and transfer()
        // send() will not revert automatically we have to handle this issue manually otherwise the balance will be lost
        // how to handle manually: by using if statement
        //if(msg.sender.send(toTransfer)){
            // success code
        //    return toTransfer; // to get the amount transfered
        //} else{
            // failure code
        //    balance = toTransfer; // get back the balance from toTransfer
        //    return 0;
        //}
        
        return toTransfer; // to get the amount transfered
    }
    
    // Payable Addresses vs Normal Addresses
    // msg.sender is a payable address by default
    // address creator this is a norma address
    // address payable creator use "payable" keyword to declare a paying address
    // address creator = msg.sender; 
    // address payable test = address(uint160(creator)); // how to go from normal address to payable address

}