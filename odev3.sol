//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Marketplace {
    struct Store {
        uint256 storeId;
        address storeOwner;
        mapping(uint256 => Item) inventory;
        uint256 itemCount;
    }

    struct Item {
        uint256 itemId;
        string itemName;
        uint256 price;
        address owner;
    }

    Store[] public stores;
    mapping(address => mapping(uint256 => bool)) public itemExists;
    mapping(address => uint256) public storeIdByOwner;

    // Diğer fonksiyonlar

    function viewStoreItems(uint256 storeId) public view returns (Item[] memory) {
        require(storeId < stores.length, "Invalid Store ID");
        Store storage currentStore = stores[storeId];
        uint256 itemCount = currentStore.itemCount;
        Item[] memory itemsInStore = new Item[](itemCount);
        for (uint256 i = 0; i < itemCount; i++) {
            itemsInStore[i] = currentStore.inventory[i];
        }
        return itemsInStore;
    }

    function purchaseItem(uint256 storeId, uint256 itemId) public payable {
        require(storeId < stores.length, "Invalid Store ID");
        Store storage currentStore = stores[storeId];
        require(itemId < currentStore.itemCount, "Invalid Item ID");

        Item storage itemToPurchase = currentStore.inventory[itemId];
        require(msg.value >= itemToPurchase.price, "Insufficient funds");

        itemToPurchase.owner = msg.sender;
        currentStore.itemCount--;
        payable(currentStore.storeOwner).transfer(msg.value); 

        itemExists[currentStore.storeOwner][itemId] = false;
        itemExists[msg.sender][itemId] = true;
    }

    function addItem(uint256 storeId, string memory _itemName, uint256 _price) public {
        require(storeId < stores.length, "Invalid Store ID");
        require(storeIdByOwner[msg.sender] == storeId, "You are not the store owner");

        Store storage currentStore = stores[storeId];
        uint256 newItemId = currentStore.itemCount;

        currentStore.inventory[newItemId] = Item(newItemId, _itemName, _price, msg.sender);
        itemExists[msg.sender][newItemId] = true;
        currentStore.itemCount++;
    }
}
