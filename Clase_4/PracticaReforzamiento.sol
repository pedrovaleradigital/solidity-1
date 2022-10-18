
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract PracticaReforzamiento{
    /*

    1.  Crear un sistema de contabilidad para una empresa que permita llevar una cuenta de 
        todo lo gastado por cada uno de sus clientes. Para cada cuenta (address), 
        vincular lo gastado por dicho cliente en una lista.

    2.  Cada cliente puede consultar la cantidad gastada hasta el momento.

    3.  Se creará un lista blanca de cuentas de administrador que tendrán el privilegio de 
        actualizar la lista de cuentas. Antes de actualizar la lista de saldos, se corroborará 
        que dicha cuenta sea parte de la lista blanca.

    4.  Nuevas cuentas de pueden incluir en la lista blanca de administradores. Este método 
        también debe estar protegido para ser llamado solo por admins.

    5.  Cada vez que se guarda o actualiza información de la lista, se disparará un evento 
        con información relevante a la transacción.

    6.  Cada usuario puede decidir incluirse en una lista negra para no monitorear sus gastos 
        en el sistema

    */

    constructor (){
        listaBlanca[msg.sender] = true;
    }

    //1.
    mapping (address => uint256) cuentas;



    //2.
    function ConsultarGasto (address _cuenta) public view returns (uint256) {
        return cuentas[_cuenta];
    }

    /*
    3.  Se creará un lista blanca de cuentas de administrador que tendrán el privilegio de 
        actualizar la lista de cuentas. Antes de actualizar la lista de saldos, se corroborará 
        que dicha cuenta sea parte de la lista blanca.
    */

    mapping (address => bool) listaBlanca;
    mapping (address => bool) listaPermisos;

    modifier compruebaListaBlanca{
        require (listaBlanca[msg.sender],"No esta en la lista blanca");
        _;
    }

    modifier compruebaPermisoOtorgado(address cliente){
        require (listaPermisos[cliente]==true,"No ha dado permiso de ser monitoreado");
        _;
    }

    function SistemaContable (address cliente, uint256 cuenta) public compruebaListaBlanca {
        cuentas[cliente] += cuenta;
    }

    /*
        4.  Nuevas cuentas de pueden incluir en la lista blanca de administradores. Este método 
        también debe estar protegido para ser llamado solo por admins.
    */
    function AgregarListaBlanca (address cuenta) public compruebaListaBlanca{
        listaBlanca[cuenta]=true;
        emit ListaBlancaActualizada (cuenta);
    }

    /*
    5.  Cada vez que se guarda o actualiza información de la lista, se disparará un evento 
        con información relevante a la transacción.
    */
    event ListaBlancaActualizada (address direccion);

    /*
    6.  Cada usuario puede decidir incluirse en una lista negra para no monitorear sus gastos 
        en el sistema
    */
    function AgregarPermisos () public {
        listaPermisos[msg.sender]=true;
    }

}