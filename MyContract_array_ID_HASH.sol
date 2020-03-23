/*
	Mezzanotti Luca
	Semplice contract con array mappato con un ID, come se fosse un DB.
*/

pragma solidity >=0.4.0 <0.7.0;

contract MyContract {
    uint256 public peopleCount;
    //Array di Person - con mappatura ID [UINT è la key]
    mapping(uint => Person) public people;
    
    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }
    
    //La prima persona ha indice 1.
    function addPerson(string memory _firstName, string memory _lastName) public {
        contaPeople();
        people[peopleCount] = Person(peopleCount ,_firstName, _lastName);
    }
    
    function contaPeople() internal {
        peopleCount += 1;
    }
    
}
