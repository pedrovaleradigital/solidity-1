//SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

contract ERC20Generic{
    /**
      1. Una criptomoneda debería tener un <u>nombre</u> que lo identifique
      2. Una criptomoneda debería tener un <u>símbolo</u> que lo identifique
      3. Definir la cantidad de <u>decimales</u> del token (normalmente hay 18 pero otros tokens tienen 6, como el USDC)
      4. Internamente debería llevar la <u>cuenta de los balances</u> de cada persona que tiene criptomoneda
      5. Llevar la <u>cuenta del total de tokens</u> repartidos
      6. Método que permite la <u>acuñación</u> de tokens a favor de una cuenta en particular (`mint`)
      7. Método que permite <u>quemar</u> (burn) tokens. La lógica detrás de esto es que genera deflación (menos dinero en la economía)
      8. Método que permite <u>transferir</u> tus propios tokens a una segunda persona (método `transfer`)
          * Internamente validar que el usuario tiene más tokens de los que quiere enviar
      9. Llevar la cuenta de los balances de tokens a gastar que los mismos dueños (del token) han <u>autorizado a otras cuentas para gastar</u> en su representación
      10. Método que permite <u>transferir tokens en nombre</u> de una segunda persona con previa aprobación de la segunda persona (método `transferFrom`)
          * Validar que esa segunda persona tiene más tokens de lo que se planea enviar
      11. Definir métodos para incrementar el permiso de gastar tokens de otra persona
      12. Disparar eventos de Transferencia cada vez que se transfieren tokens de un lado a otro. Dispararar eventos de Aprobación cada vez que una cuenta le da permiso a otra para gastar sus tokens 
      13. Método para visualizar el total de tokens de una cuenta
      14. Método para visualizar la cantidad de tokens a gastar en nombre de otra persona con su previo permiso
   */

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