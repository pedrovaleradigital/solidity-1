// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract A {
    //1
    // 'public'
    // llamado por EOA y SC
    // heredable
    // de uso interno en el contrato
    // ABI
    // sobreescribible
    function funcHeredablePublicaEInterna() public virtual {}

    // 2
    // 'internal'
    // heredable
    // de uso interno en el contrato y en derivados
    // sobreescribible
    function funcHeredableEInterna() internal virtual {}

    // 3
    // 'private'
    // de uso interno en el contrato únicamente
    // no sobreescribible: no soporta 'virtual'
    function funcInterna() private {}

    // 4
    // 'external'
    // llamado por EOA y SC
    // heredable
    // sobreescribible
    function funcExternaYHeredable() external {}
}

// SOBRE EL GAS:
// Funciones PUBLIC implica que se pueden usar dentro como fuera del smart contract
// Por ello PUBLIC es más costosa y se puede optimizar el GAS definiendo exactamente si
// el método será solo internal o external

contract B is A {
    // 1
    // function funcHeredablePublicaEInterna heredada en B
    // 2
    // function funcHeredableEInterna heredada en B
    // 3
    // function funcInterna NO heredada en B
    // 4
    // function funcExternaYHeredable heredada en B
}