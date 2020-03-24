/*
        Mezzanotti Luca
        Classe e sotto classe. Ereditarietà
        Tengo conto un registro con l'idirizzo di chi ha fatto la transazione.
*/

pragma solidity >=0.4.0 <0.7.0;

// Con lo stesso account creo 2 contratti. Il token serve a legare i 2 contratti.
// Si vede com dal MyContract posso chiamare la funzione mint() che si trova in OtherContract

contract OtherContract {
    string public name;
    mapping(address => uint256) public balances;
    
    function mint() public virtual{
        //tx.origin indica l'indirizzo di chi ha chiamato inizialmente il contratto
        balances[tx.origin] ++;
    }
    
    constructor(string memory _name) public {
        name = _name;
    }
}

//costruisco un MyToken di tipo OtherContract
contract MyToken is OtherContract {
    string public symbol;
    address[] public owners;
    uint256 ownerCount;
   
   constructor(string memory _name, string memory _symbol) OtherContract(_name) public{
       symbol = _symbol;
   }
   
   //Aggiungendo override, eredito il metodo dal padre e lo posso modificare
   function mint() public override {
       //con super si chiama il metodo della classe padre
       super.mint();
       //Tengo conto di tutti gli account che premono mint
       ownerCount++;
       owners.push(msg.sender);
   }
}
