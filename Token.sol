pragma solidity 0.5.12;
import "./Ownable.sol";
import "./SafeMath.sol";
// Checks - Effects - Interactions
contract ERC20 is Ownable {
    using SafeMath for uint256;
    //using Address for address;
    
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    
    mapping(address => uint256) private _balances; // holds the total balance of the token that the contract have
    
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    // to initialise the contract
    constructor(string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        
    } 
    
    function name() public view returns (string memory){
        return _name;
    }
    
    function symbol() public view returns (string memory){
        return _symbol;
    }
    
    function decimals() public view returns (uint8){
        return _decimals;
    }
    
    function totalSupply() public view override returns (uint256){
        return _totalSupply;
    }
    
    function balanceOf(address account) public view override returns(uint256){
        return _balances[account];
    }
    
    function mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0), "mint to the zero address");

        //_beforeTokenTransfer(address(0), account, amount);

        //_totalSupply = _totalSupply.add(amount);
        //_balances[account] = _balances[account].add(amount);
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        //emit Transfer(address(0), account, amount);
    }

    function transfer(address _to, uint256 _value) public override returns (bool success){
        //_transfer(_msgSender(), recipient, amount);//////
        //require(msg.sender != address(0), "transfer from the zero address");
        require(recipient != address(0), "transfer to the zero address");
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        return true;
    }
}