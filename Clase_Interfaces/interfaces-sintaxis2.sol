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
    IElQueSeraLlamado llamadoAInterface;

    constructor (address dir){
        llamadoAInterface = IElQueSeraLlamado(dir);
    }
    
    function LlamarAOtroContrato() public view returns (string memory) {
        return llamadoAInterface.saludo();
    }
}