//SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

contract ElQueSeraLlamado{
    function saludo() external pure returns (string memory){
        return "Hola soy Pedro V";
    }
}

interface IElQueSeraLlamado{
    function saludo() external pure returns (string memory);
}

contract ElQueLlama{
    address dirContractLlamado;

    constructor (address dir){
        dirContractLlamado = dir;
    }
    
    function LlamarAOtroContrato() public view returns (string memory) {
        return IElQueSeraLlamado(dirContractLlamado).saludo();
    }
}