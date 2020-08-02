import "./Ownable.sol";
import "./Destroyable.sol";
pragma solidity 0.5.12;

contract People is Ownable, Destroyable{

    struct Person {
        string name;
        uint age;
        uint height;
        bool senior;
    }

    event personCreated(string name, bool senior);
    event personDeleted(string name, bool senior, address deletedBy);
    
    uint public balance;

    modifier costs(uint cost){
        require(msg.value >= cost);
        _;
    }

    mapping(address => Person) private people;
    address[] private creators;

    function createPerson(string memory name, uint age, uint height) public payable costs(1 ether) {

        require(age < 130, "Age needs to be below 130");
        balance += msg.value;

        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;

        if(age >= 65){
            newPerson.senior = true;
        } else {
            newPerson.senior = false;
        }

        insertPerson(newPerson); 
        creators.push(msg.sender);

        assert(keccak256(abi.encodePacked(people[msg.sender].name, people[msg.sender].age, people[msg.sender].height, people[msg.sender].senior)) == keccak256(abi.encodePacked(newPerson.name, newPerson.age, newPerson.height, newPerson.senior)));

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
    
    // delete person function
    function deletePerson(address creator) public onlyOwner {
        string memory name = people[creator].name;
        bool senior = people[creator].senior;

        delete people[creator];

       assert(people[creator].age == 0);
       emit personDeleted(name, senior, msg.sender);
    }
    
    // function for person to update their information
    function updatePerson(string memory name, uint age, uint height) public {
        people[msg.sender].name = name;
        people[msg.sender].age = age;
        people[msg.sender].height = height;
    }

    // function to get the addresses
    function getCreatorAddress(uint index) public view onlyOwner returns(address){
        return creators[index];
    }
    
    // function to send the balance of the contract to the owner
    function withdrawAllBalance() public onlyOwner returns(uint){
        uint toTransfer = balance; // save the balance to a local variable
        balance = 0; // for security reason, reset the balance before sending the amount
        msg.sender.transfer(toTransfer); // "transfer()" function is for sending money in solidity smart contract most used option

        return toTransfer; // to get the amount transfered
    }
}