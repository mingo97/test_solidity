/*
        Mezzanotti Luca
        Librerie - Uso delle stesse funzioni in più posti
        Creo una libreria matematica
*/

pragma solidity >=0.4.0 <0.7.0;

import "./SafeMath.sol";

contract Mycontract {
    using SafeMath for uint256;
    uint256 public value;
    
    function calculate(uint256 _value1, uint256 _value2) public {
        value = _value1.div(_value2);
    }
}
