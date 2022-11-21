// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// 8.
import "./AccessControlLearning.sol";
//import "@openzeppelin/contracts/access/AccessControl.sol";
//import "hardhat/console.sol";

interface IERC20Metadata{ 

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint256);
}

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

/**is IERC20, IERC20Metadata */
contract TokenERC20_1 is IERC20, IERC20Metadata, AccessControlLearning{

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256 totalMinted;

    mapping (address=>uint256) _balances;
    mapping (address => mapping(address=>uint256)) _permisos;

    string myname;
    string mysymbol;
    uint256 mydecimals;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _decimals
    ) {
        myname = _name;
        mysymbol = _symbol;
        mydecimals = _decimals;
    }

    /////////////////////////////////////////////////////////////////////////////
    ///////////     2. Heredar la interface IERC20Metadata            ///////////
    /////////////////////////////////////////////////////////////////////////////
 
    function name() public view returns (string memory) {
        return myname;
    }

    function symbol() public view returns (string memory){
        return mysymbol;
    }

    function decimals() public view returns (uint256){
        return mydecimals;
    }

    /////////////////////////////////////////////////////////////////////////////
    ///////////         1.  Heredar la interface IERC20               ///////////
    /////////////////////////////////////////////////////////////////////////////

    uint256 TokenTotalSupply;    
    uint256 MAX_TOTAL_SUPPLY = 10**6 * 10**18; // 6 o 18 , USDC tiene 6 decimales

    function totalSupply() public view returns (uint256) {
        return TokenTotalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {     
        return transferFrom(msg.sender,to,amount);
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _permisos[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0),"Spender no puede ser zero");
        _permisos[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        if (from == msg.sender){
            require(from != address(0), "Enviado desde address zero");
            require(to != address(0), "Enviado a address zero");
        }
        else {
            uint256 permisoParaGastar = _permisos[from][msg.sender];
            require(permisoParaGastar >= amount, "No tengo suficiente permiso");
            _permisos[from][msg.sender] = permisoParaGastar - amount;
        }
        uint256 balanceFrom = balanceOf(from);
        require(balanceFrom >= amount, "Insuficientes tokens");

        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);   
        return true;
    }

    /////////////////////////////////////////////////////////////////////////////
    ///////////                     Mint and Burn                     ///////////
    /////////////////////////////////////////////////////////////////////////////

    function mint(address to, uint256 amount) public {
        require(to != address(0), "Mint a favor del address zero");

        _balances[to] += amount;
        TokenTotalSupply += amount;
        require(TokenTotalSupply <= MAX_TOTAL_SUPPLY, "Supera el MAX TOTAL SUPPLY");
        emit Transfer(address(0), to, amount);       
    }

    function burn(uint256 amount) public {
        address _account=msg.sender;
        require(_account != address(0), "Quemando de address 0");

        uint256 miBalance = balanceOf(_account);
        require(miBalance >= amount, "Insuficientes tokens para quemar");

        _balances[_account] -= amount;
        TokenTotalSupply -= amount;

        emit Transfer(_account, address(0), amount);
    }

    /////////////////////////////////////////////////////////////////////////////
    ///////////                     EXTRA                             ///////////
    /////////////////////////////////////////////////////////////////////////////

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool){
        require(spender != address(0),"Spender es direccion zero");
        _permisos[msg.sender][spender] += addedValue;
        emit Approval(msg.sender, spender, _permisos[msg.sender][spender]);
        return true;
    }   

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool){
        require(spender != address(0),"Spender es direccion zero");
        _permisos[msg.sender][spender] -= subtractedValue;
        emit Approval(msg.sender, spender, _permisos[msg.sender][spender]);
        return true;
    } 

    function mintProtected(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        mint(to,amount);
    }
}