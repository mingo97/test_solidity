# Blind Auction - Asta cieca
> Descrizione algoritmo e metodi \
> mingo97

## Note sul codice (https://solidity.readthedocs.io/en/v0.6.4/solidity-by-example.html)
La precedente asta aperta è estesa a un'asta cieca di seguito. Il vantaggio di un'asta cieca è che non vi è alcuna pressione temporale verso la fine del periodo di offerta. Creare un'asta cieca su una piattaforma informatica trasparente potrebbe sembrare una contraddizione, ma la crittografia viene in soccorso.

Durante il periodo di offerta, un offerente non invia effettivamente la propria offerta, ma solo una versione con hash. Dato che attualmente è praticamente impossibile trovare due valori (sufficientemente lunghi) i cui valori hash sono uguali, l'offerente si impegna a fare un'offerta. Dopo la fine del periodo di offerta, gli offerenti devono rivelare le loro offerte: inviano i loro valori non crittografati e il contratto verifica che il valore di hash sia uguale a quello fornito durante il periodo di offerta.

Un'altra sfida è come rendere all'asta vincolante e allo stesso tempo cieca: l'unico modo per impedire all'offerente di non inviare i soldi dopo aver vinto l'asta è farli spedire insieme all'offerta. Poiché i trasferimenti di valore non possono essere accecati in Ethereum, chiunque può vedere il valore.

Il seguente contratto risolve questo problema accettando qualsiasi valore superiore all'offerta più alta. Dal momento che questo può ovviamente essere verificato solo durante la fase di rivelazione, alcune offerte potrebbero non essere valide, e questo è di proposito (fornisce anche un flag esplicito per piazzare offerte non valide con trasferimenti di valore elevato): gli offerenti possono confondere la concorrenza piazzando diversi offerte basse non valide.
## Costruttore

```solidity

```
