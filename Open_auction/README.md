# Open Auction - Asta libera
> Descrizione algoritmo e metodi \
> mingo97

## Costruttore
Colui che fa il deploy del codice sulla BC, deve indicare in secondi la durata dell'asta.
Il parametro ``` address payable _beneficiary ``` indica l'address a cui andrà trasferito il denaro, finita l'asta.
```solidity
    constructor(uint _biddingTime, address payable _beneficiary) public {
        beneficiary = _beneficiary;
        auctionEndTime = now + _biddingTime;
    }
```

## Bid (offerta)
Nota il modificatore ``` payable ```, esso servere per consentire lo scambio di denaro.
Per poter fare un offerta, l'asta deve essere aperta (primo ``` require ```).
L'offerta del sender, il cui valore è contenuto nella struct ``` msg.value ```, deve essere maggiore dell'offerta in quell'istante maggiore (secondo ``` require ```). 
La condizione if va così interpretata: il sender ha un bid più alto di ``` highestBid ``` (e diverso da zero), quindi nell' array ``` pendingReturns ``` alla posizione di ``` highestBidder ``` (cioè colui che aveva l'offerta più alta in precedenza) va a sommare il vecchio valore di ``` highestBid ```.
Successivamente si setta il nuovo valore ottimo e l'address del sender.
La linea ``` emit HighestBidIncreased(msg.sender, msg.value); ``` permette di scrivere una transazione legata all'evento "l'offerta è aumentata".

NOTA: non è sicuro restituire direttamente i soldi all'address, se l'offerta viene superata. Conviene che sia lui, tramite la funzione WHITDRAW recuperare i propri soldi dalla struct ``` pendingReturns ```.

```solidity
function bid() public payable {
    require(
             now <= auctionEndTime,
             "Auction already ended."
    );
     require(
            msg.value > highestBid,
            "There already is a higher bid."
    );
    if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
     }
    highestBidder = msg.sender;
    highestBid = msg.value;
    emit HighestBidIncreased(msg.sender, msg.value);
 }
```
## Withdraw - recupero denaro
Lo scopo di tale metodo è permettere al sender di riprendere una sua offerta che è stata superata da qualcun'altro.
La prima istruzione all'interno dell' if ci tutela dal fatto che il metodo possa essere richiamato più volte e dunque restituire più volte del dovuto l'amount.
Nel secondo if, si usa l'istruzione ``` msg.sender.send(amount) ``` per rispedire i soldi. Se questa va a buon fine, il metodo torna TRUE. Altrimenti non è necessario causare qualche eccezione ma solo ripristinare il vecchio stato, quello in cui al sender devono essere ancora corrisposto l'amount.
```solidity
function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
                pendingReturns[msg.sender] = 0;
                if (!msg.sender.send(amount)) {
                         pendingReturns[msg.sender] = amount;
                         return false;
                }
        }
        return true;
}
```
## Auction End
Si chiude l'asta e si recapita il denaro al benificiaro, cioè colui che ha fatto il deploy dello smart contract.
Per poter eseguire tale metodo è necessario che il tempo sia scaduto e che tale metodo non sia già stato invocato (variabile ended a false). Nota che il metodo è pubblico, quidi invocabile da tutti. Nonostante ciò i soldi vanno comunque a finire al benificiario e non al sender.
Se le condizioni sono verificate, si emette la transazione dovuta all'evento "Asta conclusa" in cui si scrive l'address di chi ha offerto di più e la cifra. 
L'ultima istruzione trasferisce il denaro al benificiario.
```solidity
function auctionEnd() public {
        // 1. Conditions
        require(now >= auctionEndTime, "Auction not yet ended.");
        require(!ended, "auctionEnd has already been called.");

        // 2. Effects
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Interaction
        beneficiary.transfer(highestBid);
    }
```

## NOTA:
E' buona norma suddividere le funzioni che interagiscono con altri contratti, in 3 parti:
1) Condizioni
2) Effetti
3) Interazione

Un esempio si vede nella funzione  ``` auctionEnd()``` .
