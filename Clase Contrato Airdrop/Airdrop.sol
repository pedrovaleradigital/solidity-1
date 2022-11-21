// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

interface IToken{
    function mint (address _account, uint256 _amount) external;
    function burn (address _account, uint256 _amount) external;
}

/*
1. LISTA BLANCA Y NÚMERO ALEATORIO

Se necesita ser parte de la lista blanca para poder participar del Airdrop
Los participantes podrán solicitar un número rándom de tokens de 1-1000 tokens. Crear método participateInAirdrop.
Total de tokens a repartir es 10 millones
Solo se podrá participar una sola vez
Si el usuario permite que el contrato airdrop queme 10 tokens, el usuario puede volver a participar una vez más
El contrato Airdrop tiene el privilegio de poder llamar mint del token
*/

contract Airdrop is Pausable, AccessControl {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant LISTA_BLANCA = keccak256("LISTA_BLANCA");

    mapping (address => bool) ListaBlanca;
    mapping (address => bool) Recibido;
    address DirContrato;
    uint256 CantidadTokensMaximo = 10 * 10 ** 18;
    uint256 CantidadTokensRepartidos;

    function setListaBlanca(address _account, bool _incluir) public onlyRole(LISTA_BLANCA){
        ListaBlanca[_account]=_incluir;
    }

    function participarAirdrop(bool quemar) public{
        require(ListaBlanca[msg.sender]==true,"No pertenece a Lista Blanca");
        uint256 tokensganados = _getRadomNumber();
        require(!Recibido[msg.sender],"Ya recibio");
        require(CantidadTokensRepartidos<=CantidadTokensMaximo,"Supero maximo tokens repartidos");
        IToken(DirContrato).mint(msg.sender,tokensganados);
        Recibido[msg.sender]=true;
        CantidadTokensRepartidos+=tokensganados;
        if (quemar){
            IToken(DirContrato).burn(msg.sender,10);
            CantidadTokensRepartidos-=10;
            Recibido[msg.sender]=false;
        }
    }

    function quieroparticiparotravez() public{
        IToken(DirContrato).burn(msg.sender,10);
        CantidadTokensRepartidos-=10;
        Recibido[msg.sender]=false;
    }

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _getRadomNumber() internal view returns (uint256) {
        return
            uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 1000 + 1;
    }
}