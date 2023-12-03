// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    struct Item {
        uint256 id;
        string name;
        uint256 price;
        address owner;
        bool isSold;
    }

    struct Store {
        address storeOwner;
        uint256 storeId;
        uint256[] itemIds;
        mapping(uint256 => Item) items;
        mapping(address => uint256) balances;
    }

    mapping(address => Store) public stores;
    address[] public storeList;

    event ItemAdded(uint256 storeId, uint256 itemId, string name, uint256 price, address owner);
    event ItemPurchased(uint256 storeId, uint256 itemId, string name, uint256 price, address owner);

    function createNewStore() external {
        require(stores[msg.sender].storeOwner == address(0), "Store already exists");
        
        uint256 newStoreId = storeList.length;
        storeList.push(msg.sender);
       
    }

    function addItem(uint256 _storeId, string memory _name, uint256 _price) external {
        Store storage store = stores[msg.sender];
        require(store.storeOwner == msg.sender, "You are not the store owner");
        
        uint256 newItemId = store.itemIds.length;
        store.itemIds.push(newItemId);
        store.items[newItemId] = Item(newItemId, _name, _price, msg.sender, false);
        emit ItemAdded(_storeId, newItemId, _name, _price, msg.sender);
    }

    function viewStoreItems(uint256 _storeId) external view returns (Item[] memory) {
        Store storage store = stores[storeList[_storeId]];
        Item[] memory items = new Item[](store.itemIds.length);
        
        for (uint256 i = 0; i < store.itemIds.length; i++) {
            items[i] = store.items[store.itemIds[i]];
        }
        return items;
    }

    function purchaseItem(uint256 _storeId, uint256 _itemId) external payable {
        Store storage store = stores[storeList[_storeId]];
        Item storage item = store.items[_itemId];
        
        require(msg.value >= item.price, "Insufficient funds");
        require(!item.isSold, "Item already sold");
        
        item.isSold = true;
        store.balances[item.owner] += msg.value;
        payable(item.owner).transfer(msg.value);
        emit ItemPurchased(_storeId, _itemId, item.name, item.price, item.owner);
    }
}
