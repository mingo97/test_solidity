/*
      Mezzanotti Luca
      Due contratti creati dallo stesso account e scambio di token.
*/


pragma solidity >=0.4.0 <0.7.0;

// Con lo stesso account creo 2 contratti. Si usa l'address del token per legarli.
// Si vede com dal MyContract posso chiamare la funzione mint() che si trova in OtherContract

contract OtherContract {
    string public name;
    mapping(address => uint256) public balances;
    
    function mint() public{
        //tx.origin indica l'indirizzo di chi ha chiamato inizialmente il contratto
        balances[tx.origin] ++;
    }
}

contract MyContract {
    address payable wallet;
    address public token;

    constructor(address payable _wallet, address _token) public{
        wallet = _wallet;
        token = _token;
    }

    function externalBuy() external payable{
        buyToken();
    }

   function buyToken() public payable{
       OtherContract _token = OtherContract(address(token));
       _token.mint();
       wallet.transfer(msg.value);
   }
}
