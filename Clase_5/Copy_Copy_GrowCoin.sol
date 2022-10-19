//SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

//1. constructor para pasar el nombre y el simbolo 
//2. metodos para proteger: mint y burn (creacion de modifiers)

contract ERC20Generic{

    // 1.-
    string nameCrypto = "GrowCoin";
    function name () public view returns (string memory){
        return nameCrypto;
    }

    // 2.-
    string symbolCrypto = "GCOIN";
    function symbol () public view returns (string memory){
        return symbolCrypto;
    }

    // 3.-
    function decimals() public pure returns (uint256){
        return 18;
    }

    // 4.-
    mapping (address => uint256) balances;

    // 5.-
    uint256 totalSupply;

    // 6.- 
    function mint (address _account, uint256 _amount) public {
        balances[_account] += _amount;
        totalSupply += _amount;

        emit Transfer (address(0),_account,_amount);
    }

    // 7.-
    function burn (address _account, uint256 _amount) public{
        balances[_account] -= _amount;
        totalSupply -= _amount;

        emit Transfer (_account,address(0),_amount);
    }

    // 8.-
    function transfer (address _to, uint256 _amount) public{
        balances[msg.sender] -= _amount;
        balances[_from] += _amount;

        emit Transfer (msg.sender,_to,_amount);
    }

    // 9.- 
    // owner => spender => Q de tokens
    mapping (address => mapping (address => uint256)) _allowances;

    // 10.-
    function transferFrom (address _from, address _to, uint256 _amount) public{
        uint256 permisoParaGastar = _allowances[_from][msg.sender];
        verify(_monto - _amount >= 0; "No tiene fondos suficientes");
        balances[_from] -= _amount;
        balances[_to] += _amount;

        emit Transfer (_from,_to,_amount);
    }

    //    11. Definir métodos para incrementar el permiso de gastar tokens de otra persona
    
    function approve (address _spender, uint256 _amount) public {
        _allowances [msg.sender][_spender] += _amount;
    }

    // 12. Disparar eventos de Transferencia cada vez que se transfieren tokens de un lado a otro.
    // Dispararar eventos de Aprobación cada vez que una cuenta le da permiso a otra para gastar 
    // sus tokens 

    event transfer (address _from, address _to, uint256 _amount);
    
    // 13. Método para visualizar el total de tokens de una cuenta
    function balanceOf(address _dir) public view returns (uint256){
        CantidadTokens = balances[_dir];
        return CantidadTokens;
    }

    // 14. Método para visualizar la cantidad de tokens a 
    // gastar en nombre de otra persona con su previo permiso
    function allowance (address _owner, address _spender) public view returns (uint256){
        CantidadTokens = _allowances[_owner][_spender];
        return CantidadTokens;
    }
}