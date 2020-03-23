/*
      Mezzanotti Luca
      Costruzione di wallet e registro transazione
*/

pragma solidity >=0.4.0 <0.7.0;

contract MyContract {
    mapping(address => uint256) public balances;
    address payable wallet;

    // Tengo traccia della transazione
    event Purchase(address indexed _buyer, uint256 _amount);
    
    constructor(address payable _wallet) public{
        wallet = _wallet;
    }

    //External permette ad una funzione di essere richiamata da tutti (come se fosse public),
    // TRANNE DAL PROPRIETARIO
    function externalBuy() external payable{
        buyToken();
    }

   function buyToken() public payable{
       // Compra un token
       balances[msg.sender] += 1;
        // mandalo nel wallet
       wallet.transfer(msg.value);
       emit Purchase (msg.sender,1);
   }
}
