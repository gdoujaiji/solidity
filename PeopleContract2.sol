pragma solidity 0.5.12;

contract People{
    
    struct Person {
        uint id;
        string name;
        uint age;
        uint height;

    }
    
    Person[] private people;
    
    mapping(address => Person) private store; 
    
    function createPerson(string memory name, uint age, uint height) public {
        address creator = msg.sender;
        Person memory newPerson;
        newPerson.id = people.length; 
        people.push(Person(people.length, name, age, height));

        store[creator] = newPerson;
    }
    
    function getPerson(uint index) public view returns(uint id, string memory name, uint age, uint height){
      
        return (people[index].id, people[index].name, people[index].age, people[index].height);
    }
    
 
}