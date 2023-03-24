// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol';
import "@openzeppelin/contracts/utils/EnumerableSet.sol";

contract Venice is ERC20Burnable, Ownable{

    EnumerableSet.AddressSet private _minters;

    uint256 private constant maxSupply = 100000000 ether;     // the total supply

    event NewMinter(address indexed _operator, address indexed newMinter);
    event DelMinter(address indexed _operator, address indexed delMinter);

    /**
     * @notice Constructs the FERC-20 contract.
     */
    constructor() public ERC20('Venice Token', 'VENI') {}

    function addMinter(address _addMinter) external onlyOwner returns (bool) {
        require(_addMinter != address(0), "Venice: _addMinter is the zero address");
        emit NewMinter(msg.sender, _addMinter);
        return EnumerableSet.add(_minters, _addMinter);
    }

    function delMinter(address _delMinter) external onlyOwner returns (bool) {
        require(_delMinter != address(0), "Venice: _delMinter is the zero address");
        emit DelMinter(msg.sender, _delMinter);
        return EnumerableSet.remove(_minters, _delMinter);
    }

    function getMinterLength() public view returns (uint256) {
        return EnumerableSet.length(_minters);
    }

    function getMinter(uint256 _index) external view returns (address){
        require(_index <= getMinterLength() - 1, "Venice: index out of bounds");
        return EnumerableSet.at(_minters, _index);
    }

    function isMinter(address account) public view returns (bool) {
        return EnumerableSet.contains(_minters, account);
    }
    
    function mintTo(address _to, uint256 _amount) external onlyMinter{
        require(totalSupply().add(_amount) <= maxSupply, "Venice: is greater than maxSupply");
        _mint(_to, _amount);
    }

    // modifier for mint function
    modifier onlyMinter() {
        require(isMinter(msg.sender), "Venice: caller is not the minter");
        _;
    }
}