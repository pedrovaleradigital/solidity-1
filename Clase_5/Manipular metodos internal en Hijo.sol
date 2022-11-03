// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Admin{

    address owner;

    constructor {
        owner = msg.sender;
    }

    modifier onlyAdmin{
        require (msg.sender == owner, "No es admin");
        _;
    }
}

contract Pausar{
    bool Pausar;

    function _pause() internal{
        Pausar = true;
    }

    function _unpause() internal{
        Pausar = false;
    }
}

contract Hijo is Admin,Pausar{

    function pause() public onlyAdmin{
        _pause();
    }

    function unpause() public onlyAdmin{
        _unpause();
    }
}