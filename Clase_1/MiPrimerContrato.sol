//SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

    contract MiPrimerContrato {
    string saludo;

    function fijarSaludo(string memory _saludo) public{
        saludo = _saludo;
    }

    function leerSaludo() public view returns(string memory){
        return saludo;
    }

    mapping(address => uint256) addressToInteger;

}