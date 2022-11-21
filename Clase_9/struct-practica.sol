// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

contract practica {
    struct DNI{
        uint256 numero;
        string dueno;
    }

    string _nameCollection;
    address _dircontract;

    constructor (string memory _name, address _dir){
        _nameCollection=_name;
        _dircontract=_dir;
    }

    mapping (address=>DNI) public ListaDNIs;

    function setDNI() public{
        DNI memory nuevoDNI = DNI({
            numero: 43942559,
            dueno: "Pedro Valera"
        });
        ListaDNIs[msg.sender] = nuevoDNI;
    }

    function getname() public view returns (string memory){
        bool hola = true;
        bool nuevo = false;
        require (hola || nuevo,"No es true");
        return _nameCollection;
    }

    function getadress() public view returns (address){
        return _dircontract;
    }

    function getduenoDNI() public view returns (string memory){
        DNI storage _miDNI = ListaDNIs[msg.sender];
        return _miDNI.dueno;
    }

    function getnumeroDNI() public view returns (uint256){
        DNI storage _miDNI = ListaDNIs[msg.sender];
        return _miDNI.numero;
    }

    function _getRadomNumberOne2() public view returns (uint256) {
        //random entre 0 a 10
        return
            uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 10 +1;
    }

}