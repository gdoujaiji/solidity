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

     // events in solidity is like notifications in web and mobile applications
    event personCreated(string name, bool senior);
    
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

    function createPerson(string memory name, uint age, uint height) public {
        // most clear way to create the person //
        //people.push(Person(people.length, name, age, height)); // people.length will be the id which is the index of the array
        
        require(age <= 130, "Age needs to be below 130"); // to control valid inputs
        
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
        //require(msg.sender == owner); // to make sure that only the owner can make delete operation
        delete people[creator]; // that will delete the key from the mapping
        // another example for using assert function after deleting the struct from the mapping
        // no need to hash because we are comparing integers
        //assert(people[creator].age == 10); // assert will fire an error
       assert(people[creator].age == 0); // assert will not fire an error
    }
    
    // function to get the addresses
    function getCreatorAddress(uint index) public view onlyOwner returns(address){
        //require(msg.sender == owner, "Caller needs to be owner"); // restrist access only to owner
        return creators[index];
    }

}