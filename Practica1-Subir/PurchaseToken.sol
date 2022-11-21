// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract USDC is ERC20, ERC20Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() ERC20("UDS Coin", "USDC") {
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

interface IUSDC {

    function balanceOf(address account) external returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external;

    function allowance(address owner, address spender)
        external
        returns (uint256);
}

contract MiTokenParaVenta is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    IUSDC usdc; 
    uint256 public constant exchangeRate = 25;

    constructor(address _usdcAddress) ERC20("Mi Token Para Venta", "MTPV") {
        usdc = IUSDC(_usdcAddress);

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function purchaseFixRate(uint256 _usdcAmount) external returns (uint256){
        require(usdc.balanceOf(msg.sender)>=_usdcAmount, "No tiene suficiente UDSC");
        require(usdc.allowance(msg.sender, address(this)) >= _usdcAmount, "No tiene suficiente permiso");
        usdc.transferFrom(msg.sender, address(this), _usdcAmount);
        uint256 mtpvTokens = _getTokensByRate(_usdcAmount);
        _mint(msg.sender, mtpvTokens);
        return mtpvTokens;
    }

    function purchaseVariableRate(uint256 _usdcAmount) external {
        require(usdc.balanceOf(msg.sender)>=_usdcAmount, "No tiene suficiente UDSC");
        require(usdc.allowance(msg.sender, address(this)) >= _usdcAmount, "No tiene suficiente permiso");
        usdc.transferFrom(msg.sender, address(this), _usdcAmount);
        uint256 mtpvTokens = _getTokensByChange(_usdcAmount);
        _mint(msg.sender, mtpvTokens);
    }

    //////////////////////////////////////////////////
    //////////            HELPERS           //////////
    //////////////////////////////////////////////////

    function _getTokensByRate(uint256 _usdcAmount)
        internal
        pure
        returns (uint256)
    {
        return _usdcAmount*25;
    }

    function _getTokensByChange(uint256 _usdcAmount)
        internal
        view
        returns (uint256)
    {
        uint256 ts = totalSupply() / 10**18;
        uint256 price = ts**2 - 2 * ts + 1000;
        return _usdcAmount / price;
    }
}