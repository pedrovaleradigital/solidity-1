// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Humano {
    string description;
    string origin;
    uint256 year;

    constructor (
        string memory _description, 
        string memory _origin, 
        uint256 _year
    ) {
        // constructor no vacio
        description = _description;
        origin = _origin;
        year = _year;
    }

}
// 1. Directamente en la lista de herencia
//    definiendo los valores a priori
contract Hombre is Humano("homo sapiens", "planeta tierra", 2022) {}

// 2. Inicializar en el "modifier" del constructor derivado
//    Manera más dinámica de inicializar
contract HombreV2 is Humano {
    constructor(
        string memory _description, 
        string memory _origin, 
        uint256 _year,
        string memory _name
    ) Humano(_description, _origin, _year) {
        // constructor vacio - sin cuerpo
    }

}

// MULTIPLE HERENCIA
contract HombreV3 {
        uint256 altura;
        constructor(uint256 _altura) {
            altura = _altura;
        }

        function updateHeight(uint256 _nuevaAltura) internal {
            altura = _nuevaAltura;
        }
}
