/*
        Mezzanotti Luca
        Solo colui che compila il contratto e lo carica sulla BC può caricare persone.
*/

pragma solidity >=0.4.0 <0.7.0;

contract MyContract {
    uint256 public peopleCount;
    //Array di Person - con mappatura ID [UINT è la key]
    mapping(uint => Person) public people;
    
    //Devo confrontare chi chiama la funzione (guardo i metadati con msg) vs me (owner)
    address owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner); //come if: se true continua else error
        _;
    }
    
    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }
    
    // Al lancio del codice parte il costruttore e mi identifico come proprietario.
    constructor() public {
        owner = msg.sender;
    }
    
    // onlyOwner significa che solo il creatore di tale contract (NOI) possiamo chiamare 
    // tale funzione, nessun altro nella BC può farlo!
    function addPerson(string memory _firstName, string memory _lastName) public onlyOwner {
        contaPeople();
        people[peopleCount] = Person(peopleCount ,_firstName, _lastName);
    }
    
    function contaPeople() internal {
        peopleCount += 1;
    }
    
}
