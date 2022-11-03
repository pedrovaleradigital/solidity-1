
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract PracticaReforzamiento-round2{
    /*
    1.  Crear un sistema de contabilidad para una empresa que permita llevar una cuenta de 
        todo lo gastado por cada uno de sus clientes. Para cada cuenta (address), 
        vincular lo gastado por dicho cliente en una lista. */

    mapping (address => uint256) MontoGastadoClientes;

/*
    2.  Cada cliente puede consultar la cantidad gastada hasta el momento. */

    function ConsultarSaldo public view returns (uint256){
        return MontoGastadoClientes[msg.sender];
    }

/*
    3.  Se creará un lista blanca de cuentas de administrador que tendrán el privilegio de 
        actualizar la lista de cuentas. Antes de actualizar la lista de saldos, se corroborará 
        que dicha cuenta sea parte de la lista blanca. */
    function actualizarSaldo(address _cuenta, uint256 _monto) public verificarAdmin{
        MontoGastadoClientes[_cuenta]=_monto;
    }

    mapping (address => bool ) ListaBlanca;

    modifier verificarAdmin{
        require (ListaBlanca[msg.sender],"No es admin");
        _;
    }

/*
    4.  Nuevas cuentas de pueden incluir en la lista blanca de administradores. Este método 
        también debe estar protegido para ser llamado solo por admins. */

        

/*
    5.  Cada vez que se guarda o actualiza información de la lista, se disparará un evento 
        con información relevante a la transacción. */

/*
    6.  Cada usuario puede decidir incluirse en una lista negra para no monitorear sus gastos 
        en el sistema */