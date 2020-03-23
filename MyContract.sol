/*
	Mezzanotti Luca
	Semplice contract con array indicizzato.
*/

pragma solidity >=0.4.0 <0.7.0;

contract MyContract {
    uint256 public peopleCount;
    //Array di Person
    Person[] public people;
       
    struct Person {
        string _firstName;
        string _lastName;
    }
    
    function addPerson(string memory _firstName, string memory _lastName) public {
        //Aggiunge un elemento all'array
        people.push(Person(_firstName, _lastName));
        peopleCount += 1;
    }
    
}
