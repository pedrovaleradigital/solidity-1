// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
//import "hardhat/console.sol";

contract TokenAIRDRP is ERC20, ERC20Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() ERC20("Token para Airdrop", "TAIRDRP") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public onlyRole(BURNER_ROLE) {
        _burn(from, amount);
    }
}

interface ITokenAIRDRP {
    function mint(address to, uint256 amount) external;

    function burn(address from, uint256 amount) external;

    function balanceOf(address account) external returns (uint256);
}

contract Airdrop is AccessControl {
    address tokenAIRDRPAddress;
    uint256 constant prizeTokensBlueList = 10000 * 10**18;
    uint256 constant amntTokensToBurn = 1000 * 10**18;

    struct Participante {
        address cuentaParticipante;
        uint256 participaciones;
        uint256 ultimaVezParticipado;
    }
    mapping(address => Participante) participantes;

    constructor(address _tokenAddress) {
        tokenAIRDRPAddress = _tokenAddress;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    mapping(address => bool) public _whiteList;
    mapping(address => bool) public _blueList;

    function addToWhiteListBatch(address[] memory _addresses) public onlyRole(DEFAULT_ADMIN_ROLE)
    {
        uint256 _length = _addresses.length;
        address _address;
        for (uint256 i = 0; i < _length; i++) {
            _address = _addresses[i];
            _whiteList[_address] = true;

            Participante memory participante = Participante({
                cuentaParticipante: _address,
                participaciones: 0,
                ultimaVezParticipado: block.timestamp
            });
            participantes[_address] = participante;
        }
    }

    function mintWithWhiteList() external {
        require(_whiteList[msg.sender], "Participante no esta en whitelist");
        Participante memory participante = participantes[msg.sender];
        require(block.timestamp - participante.ultimaVezParticipado <= 1 days  , "Pasaron mas de 24 horas");

        uint256 _amntTokens = _getRandom(1000);
        ITokenAIRDRP(tokenAIRDRPAddress).mint(msg.sender, _amntTokens);

        _whiteList[msg.sender] = false;
        participante.participaciones++; 
        participante.ultimaVezParticipado = block.timestamp;
    }

    function addToBlueListBatch(address[] memory _addresses)
        public 
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        uint256 _length = _addresses.length;
        address _address;
        for (uint256 i = 0; i < _length; i++) {
            _address = _addresses[i];
            _blueList[_address] = true;

            Participante memory participante = Participante({
                cuentaParticipante: _address,
                participaciones: 99,
                ultimaVezParticipado: block.timestamp
            });
            participantes[_address] = participante;
        }
    }

    function GETultimaVezParticipado() public view returns (uint256){
        Participante memory participante = participantes[msg.sender];
        return participante.ultimaVezParticipado;
    }

    function GETlocalTime() public view returns (uint256){
        return block.timestamp;
    }

    function GETTokensBasedOnTime() public view returns (uint256)
    {
        uint256 totalTime = 60 * 60;
        uint256 timePased = block.timestamp - block.timestamp; 
        require(totalTime > timePased, "Pasaron mas de 60 minutos");

        uint256 remainingTime = totalTime - timePased; 
        uint256 tokens = (remainingTime * prizeTokensBlueList)/ (timePased + remainingTime);
        return tokens;
    }

    function mintWithBlueList() external {
        require(_blueList[msg.sender],"Participante no esta en bluelist");
        
        uint256 tEnQueIngresoMsgSender; 
        Participante memory participante = participantes[msg.sender];
        tEnQueIngresoMsgSender = participante.ultimaVezParticipado;

        uint256 _amntTokens = _getTokensBasedOnTime(tEnQueIngresoMsgSender);
        ITokenAIRDRP(tokenAIRDRPAddress).mint(msg.sender, _amntTokens);

        _blueList[msg.sender] = false;
        
        participante.participaciones++; 
        participante.ultimaVezParticipado = block.timestamp;
    }

    function burnMyTokensToParticipate() external {
        uint256 bal = ITokenAIRDRP(tokenAIRDRPAddress).balanceOf(msg.sender);
        require(bal >= amntTokensToBurn, "No tiene suficientes tokens para quemar");
        require(_whiteList[msg.sender]==false, "Esta en lista blanca");

        ITokenAIRDRP(tokenAIRDRPAddress).burn(msg.sender, amntTokensToBurn);
        _whiteList[msg.sender]=true;

        Participante memory participante = Participante({
            cuentaParticipante: msg.sender,
            participaciones: 0,
            ultimaVezParticipado: block.timestamp
        });
        participantes[msg.sender] = participante;
    }

    //////////////////////////////////////////////////
    //////////            HELPERS           //////////
    //////////////////////////////////////////////////

    function _getTokensBasedOnTime(uint256 _enterTime)
        internal
        view
        returns (uint256)
    {
 
        uint256 totalTime = 60 * 60; 
        uint256 timePased = block.timestamp - _enterTime; 
        require(timePased < totalTime, "Pasaron mas de 60 minutos");

        uint256 remainingTime = totalTime - timePased;
        uint256 tokens = (remainingTime * prizeTokensBlueList)/ (timePased + remainingTime);
        return (tokens);
    }

    function _getRandom(uint maxtokens) internal view returns (uint256) {
        uint256 random = uint256(keccak256(abi.encodePacked(msg.sender, address(this), block.timestamp))) % maxtokens + 1; //1 a 1000
        return random * 10**18;
    }
}