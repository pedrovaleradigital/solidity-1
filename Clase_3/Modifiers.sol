//SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

contract Modifier{

    address admin = 0x890ECD3d23Ff71c58Fd1E847dCCAf0bC601a3cd3;

    modifier verificarAdmin {
        require (msg.sender == admin,"No es admin");
        _;
    }

    function mint (address _account, uint256 _amount) internal {
        requiere(_account != address(0), "address es zero");
        balances[_account] += _amount;
        totalSupply += _amount;

        emit Transfer (address(0),_account,_amount);
    }

    function mintProtegidoPorModifier (address _account, uint256 _amount) public verificarAdmin {
        mint(_account, _amount);
    }
}
