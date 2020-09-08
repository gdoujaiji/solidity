pragma solidity 0.5.12;

contract People{
    
    struct Person {
        uint id;
        string name;
        uint age;
        uint height;
        address creator;
    }
    
    Person[] private people;

    function createPerson(string memory name, uint age, uint height) public {
        address creator = msg.sender;
        people.push(Person(people.length, name, age, height, creator));
    }
    
    function getPerson(uint index) public view returns(string memory name, uint age, uint height, address creator){
      
        return (people[index].name, people[index].age, people[index].height, people[index].creator);
    }
}