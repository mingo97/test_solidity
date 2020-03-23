/*
      Mezzanotti Luca
      L'accesso alla funzione è consentito solo in un intervallo di tempo.
*/

pragma solidity >=0.4.0 <0.7.0;

contract MyContract {
    uint256 public peopleCount;
    //Array di Person - con mappatura ID [UINT è la key]
    mapping(uint => Person) public people;
    
    //Il tempo è espresso in secondi come epoch time. 
    uint256 openingTime = 1584959289; 
    
    //Se il tempo attuale è maggiore di openingTime si ha il permesso
    modifier onlyWhileOpen() {
        require(block.timestamp >= openingTime); //come if: se true continua else error
        _;
    }
    
    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }
    
    // onlyWhileOpen significa che si può accedere a tale funzione solo in una finestra temporale specifica
    function addPerson(string memory _firstName, string memory _lastName) public onlyWhileOpen {
        contaPeople();
        people[peopleCount] = Person(peopleCount ,_firstName, _lastName);
    }
    
    function contaPeople() internal {
        peopleCount += 1;
    }
    
}
