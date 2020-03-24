/*
    Sostituendo in NOME1, NOME2 ecc si ottiene un vettore con la conversione.
    A questo vanno aggiunte le [] e ad ogni stringa di 32 bit "".
*/

pragma solidity >=0.4.22 <0.7.0;

contract String2Bytes32 {
    
    function getBytes32Array() pure public returns (bytes32[3] memory b32Arr) {
        b32Arr = [bytes32("NOME1"), bytes32("NOME2"), bytes32("NOME3")];
    }
}
