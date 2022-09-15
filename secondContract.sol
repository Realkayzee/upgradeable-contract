// SPDX-License-Identifier: GPL-3.0


pragma solidity 0.8.9;

import "./proxiable.sol";

contract Token2 is Proxiable {
    uint256 TotalSupply;
    string TokenName;
    string TokenSymbol;
    bool public initialized;
    address owner;


    mapping(address => uint256) balances;
    //Approver to aprovee to amount approved
    mapping(address => mapping(address => uint256)) Approve;  


    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner is allowed to perform this action");
        _;
    }

    function initialize() public{
        require(!initialized, "Contract already initialized");
        initialized = true;
        TokenName = "firstToken";
        TokenSymbol = "FST";
        TotalSupply = 2000 * (10**18);
        mint(0x924843c0c1105b542c7e637605f95F40FD07b4B0);
        setOwner(msg.sender);
    }

    function ConstructData() public pure returns(bytes memory data ){

        data = abi.encodeWithSignature("initialize()");
    }

    function setOwner(address _owner) internal {
        owner = _owner;
    }

    function mint(address _addr) internal {
        balances[_addr] += TotalSupply;
    }
    function balanceOf(address _addr) public view returns(uint256){
       return balances[_addr];
    } 
    function transfer(address _address, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient Fund");
        balances[msg.sender] -= amount;
        balances[_address] += amount;
    }

    function approve(address to, uint256 amount) public{
        require(balanceOf(msg.sender) >= amount, "You can't approve what you don't have");
        Approve[msg.sender][to] = amount;
    }

    function TransferFrom(address from, address to, uint256 amount) public {
        uint256 initBal = Approve[from][to];
        require(initBal >= amount, "Amount not approved");
        Approve[from][to] -= amount;
        balances[from] -= amount;
        balances[to] += amount;
    }

    function allowance(address _addr) public view returns(uint256){
        return(Approve[msg.sender][_addr]);
    }

    function burn(address _addr) public onlyOwner{
        uint256 amount = 1 * (10**18);
        balances[_addr] -= amount;
    }

    function upgradeable(address _newAddress) public {
        require(msg.sender == owner, "You are not allowed to upgrade");
        updateCodeAddress(_newAddress);
    }
}