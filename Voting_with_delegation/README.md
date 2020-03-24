# Voting with delegation
> Descrizione algoritmo e metodi \
> mingo97


## Costruttore
Chi fa il deploy del codice sulla BC, diventa chairman (presidente del voto). L'istruzione `voters[chairperson].weight = 1;` va così interpretata: l'array `voters` è indicizzato con l'indirizzo del singolo `Voter`; l'attributo `weight` indica quante deleghe da parte di altri si hanno, per tale motivo nel momento del deploy il chairman lo ha pari a 1. \
Il ciclo `for` serve ad organizzare nella lista `proposals` gli attributi passati al costruttore. Il metodo `push` permette di aggiungere un elemento alla coda. La lista è indicizzata da 0 a n candidati.

```solidity
constructor(bytes32[] memory proposalNames) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
```

## Give Right To Vote
Da il diritto di voto agli account in BC. Tale funzione può essere chiamata solo dal chairman, come si vede sul primo `require`. Come parametro si passa un address.  
Se tale address ha gia votato si esce, se deve ancora farlo si attribuisce peso (weigth) al suo voto con l'istruzione `voters[voter].weight = 1;`. Se il peso è diverso da 0 significa che ha gia ricevuto il diritto di voto.

```solidity
    function giveRightToVote(address voter) public {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }
```

## Delegate
Un account può decidere di non votare e delegare il proprio voto all'address `to` passato come parametro.
Si crea un `Voter` temporaneo che conterrà l'account di colui che ha invocato la funzione, cioè il delegante. Se questo ha gia votato si esce. Se questo vuol delegare se stesso si esce. 
Il ciclo while evita che si formino cicli di deleghe: A->B->C->D->A.
L'istruzione `sender.voted = true;` mi impedirà di votare in quanto ho delegato. Nota che se il delegato ha già votato, vado direttamente ad aggiungere il voto. In caso contrario aggiungo i pesi del delegante al delegato.
```solidity
function delegate(address to) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Found loop in delegation.");
        }
        // Since `sender` is a reference, this
        // modifies `voters[msg.sender].voted`
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        
        if (delegate_.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate_.weight += sender.weight;
        }
    }
```

## Vote
Se si ha il diritto di voto (vedi primo `require`) e non si ha già votato, si setta il voto a TRUE, si registra l'address di chi si vuole votare nel campo `vote` e si assegnano i weight al `proposal`.
``` solidity
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }
```

## Winning Proposal
Si valuta tra i `proposal` chi ha maggiori voti. La funzione restituisce l'indice della struttura `proposals` a cui corrisponde il vincitore.
``` solidity
function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }
```

## Winner Name
Restituisce il nome in bytes32 del vincitore, individuato all'interno della struttura `proposals` tramite `winningProposal()`.
``` solidity
function winnerName() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
```
