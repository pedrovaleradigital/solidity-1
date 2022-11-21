//SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

contract structs {

    struct EstadoCuenta{
        uint256 monto;
        uint256 fecha;
        string nombres;
        string apellidos;
    }

    mapping(address => EstadoCuenta) public listaEstadosCuenta;

    function guardar() public {

        EstadoCuenta memory estadoCuenta = EstadoCuenta({
            monto: 1000,
            fecha: 1234,
            nombres: "Pedro Guillermo",
            apellidos: "Valera Lalangui"
        });

        listaEstadosCuenta[msg.sender] = estadoCuenta;
    }

    function variar() public{
        listaEstadosCuenta[msg.sender].nombres = "Luis Fernando";
    }

}