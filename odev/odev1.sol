 //SPDX-License-Identifier: UNLICENSED
 pragma solidity ^0.8.0;

// Base contract for individual store contracts
contract Store {
    
    struct Item {
        uint256 itemId;
        string itemName;
        uint256 price;
        // Add other relevant item details here
    }

    mapping(uint256 => Item) public inventory; 
    uint256 public itemCount;

    // Function to add items to the store's inventory
    function addItem(string memory _itemName, uint256 _price) public {
        itemCount++;
        inventory[itemCount] = Item(itemCount, _itemName, _price);
    }

    // Function to get the details of an item by ID
    function getItem(uint256 _itemId) public view returns (uint256, string memory, uint256) {
        Item memory currentItem = inventory[_itemId];
        return (currentItem.itemId, currentItem.itemName, currentItem.price);
    }

    
}

// Marketplace contract handling dynamic creation of store contracts
contract Marketplace {
    mapping(address => address) public storeContracts; // Mapping to store store contracts by owner address

    // Function to create a new store contract
    function createNewStore() public {
        Store newStore = new Store();
        storeContracts[msg.sender] = address(newStore);
    }

    // Function to get the address of a store contract by owner address
    function getStoreAddress(address _owner) public view returns (address) {
        return storeContracts[_owner];
    }
}
