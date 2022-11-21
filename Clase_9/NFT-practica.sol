pragma solidity >=0.4.16 <0.9.0;

interface IERC721 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function approve(address to, uint256 tokenId) external;

    function setApprovalForAll(address operator, bool _approved) external;

    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

contract MiPrimerNFT is IERC721{
    //1: balanceof: lleva la cuenta de los NFTs con arugmento addreess
    //2: name deuelve nombre de la colección
    //3: symbol devuelve simbolo de la coleccion
    //4: burn quema el NT lo pasa al address 0, un arugmento tokenID(uint256)
        //si otra persona tiene persmiso, lo puede quemar
    //5: safeMint: acuña un NFT a un address secuencial, un argumento to (address)
    //6: transferFrom: transfiere un NFT usando el tokenId, de una cuenta from a una cuenta to
        // 3 argumentos: from(address), to(addresss), toenId(uint256)
    //7: safetransferfrom: transfiere un NFT usando el tokenId, de una cuenta from a una cuenta to
        // 3 argumentos: from(address), to(address), tokenI(uint256)
        // además de transferir, revisa que el recipiente pueda manejar NFTs
    //8: safetransferfrom: transfiere un NFT usando el tokenId, de una cuenta from a una cuenta to
        // 4 argumentos: from(address), to(address), tokenI(uint256), bytes
        // además de transferir, revisa que el recipiente pueda manejar NFTs
    //9:safetransferfrom
    //10: set aprovvealforall: otorga el ppermiso a todos los NFTs de una cuenta
        //2 argumentos: operator (address), aporovae(bool)

    //1: balanceof:
    // address => uint256

    mapping (address=>uint256) _balances;
    function balanceof(address owner) public view returns (uint256){
        return _balances[owner];
    }

    string _symbol;
    string _nombre;

    constructor (string memory symbol, string memory nombre){
        _symbol=symbol;
        _nombre=nombre;
    }

    function symbol() public view returns (string memory){
        return "MysNFTs";
    }

    mapping (uint256=>address) aprobados;
    function approve (uint256 tokenID, address operator) public returns bool{
        require (msg.sender==_owners[tokenID]), "No eres el owner");
        require (msg.sender!=operator,"No puedes darte permiso a ti mismo");
        aprobados[tokenID]=operator;
        emit Approval(msg.sender,operator,tokenID);

    }

    mapping (address =>uint256) public _balances;
    function balanceOf(address owner) public view returns(uint256){
        return _balances[owner]
    }

    string _nameCollection;
    string _symbolColection;

    constructor(string memory _name, string memory _symbol){
        _nameCollection = _name;
        _symbolColection = _symbol;
    }

    //2: name: veuelve el nombre de la coleccion
    function name() public view returns(string memory){
        return _nameCollection;
    }

    //3: symbol
    function symbol() public view returns (string memory){
        return _symbolColection;
    }

    mapping(uint256 => address) _owners;
    uint256 counter;
    function safeMint(address to)public{
        uint256 tokenId = getCurrentCounter();

        _owners[tokenId] = to;
        _balances[to]++;
        incCounter();

        //hacer el checking
        require(_checkOnERC721Received(address(0),to,tokenId,""),"El recipiente no soporta NFTs");
        
        emit Transfer(address(0),to,tokenId);
    }

    function getCurrentCounter() internal view returns(uint256){
        return counter;
    }

    function incCounter() internal {
        counter++;
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.code.length > 0) {
            try
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC721: transfer to non ERC721Receiver implementer"
                    );
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

}