// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract EjecucionRolAdmin{

    address admin;
    string mensaje = "Hola Pedro!!! genial";
    bytes32 public DEFAULT_ADMIN_ROLE = keccak256("PEDRO");

    constructor () {
        admin = msg.sender;
    }
    modifier onlyAdmin(){
        require(msg.sender == admin,"No es admin");
        _;
    }
    function MuestraMensaje() public view returns (string memory) {
        return mensaje;
    }

    function MuestraAddress() public view returns (address) {
        return admin;
    }
}