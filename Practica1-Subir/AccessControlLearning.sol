// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
//import "hardhat/console.sol";

contract AccessControlLearning {
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    modifier onlyRole(bytes32 _role) {
        require(hasRole(msg.sender,_role), "Cuenta no tiene el rol necesario");
        _;
    }

    mapping(address => mapping(bytes32 => bool)) _roles;

    constructor() {
        _roles[msg.sender][DEFAULT_ADMIN_ROLE] = true;
    }

    function hasRole(address _account, bytes32 _role) public view returns (bool){
        return _roles[_account][_role];
    }

    function grantRole(address _account, bytes32 _role) public onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _roles[_account][_role] = true;

        uint256 _limit = _rolesTempLimit[msg.sender][DEFAULT_ADMIN_ROLE];
        if(_limit == 1){
            _roles[msg.sender][DEFAULT_ADMIN_ROLE] = false;
            _rolesTempLimit[msg.sender][DEFAULT_ADMIN_ROLE]--;
        }
        if(_limit>1){
            _rolesTempLimit[msg.sender][DEFAULT_ADMIN_ROLE]--;
        }
    }

    event TransferOwnership(address _prevOwner, address _newOwner);
    event RenounceOwnership(address renounceOwner);

    function transferOwnership(address _newOwner) public onlyRole(DEFAULT_ADMIN_ROLE){
        _roles[_newOwner][DEFAULT_ADMIN_ROLE] = true;
        _roles[msg.sender][DEFAULT_ADMIN_ROLE] = false;
        emit TransferOwnership(msg.sender, _newOwner);
    }

    function renounceOwnership() public onlyRole(DEFAULT_ADMIN_ROLE){
        _roles[msg.sender][DEFAULT_ADMIN_ROLE] = false;
        emit RenounceOwnership(msg.sender);
    }   


    mapping(address => mapping(bytes32 => uint256)) _rolesTempLimit;

    function grantRoleTemporarily(address _account, bytes32 _role, uint256 _limit) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_limit >= 1, "El limite es mayor a 1");
        _roles[_account][_role] = true;
        _rolesTempLimit[_account][_role] = _limit;
    }

    function hasTemporaryRole(address _account, bytes32 _role) public view returns (bool, uint256)
    {
        uint256 _limit = _rolesTempLimit[_account][_role];
        if (_limit>0) {
            return (true,_limit);
        }
        else {
            return (false, 0);
        }
        
    }
}