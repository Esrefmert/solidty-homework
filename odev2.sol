//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Marketplace {
    struct Store {
        uint256 storeId;
        address storeOwner;
        uint256[] itemIds; // Eşya ID'lerini tutacak dizi
    }

    struct Item {
        uint256 itemId;
        string itemName;
        uint256 price;
        address owner;
    }

    Store[] public stores;
    mapping(address => uint256) public userBalances;
    mapping(uint256 => Item) public items;

    // Mağaza eklemek için fonksiyon
    function addStore() public {
        stores.push(Store(stores.length, msg.sender, new uint256[](0)));
    }

    // Mağazaların sayısını döndüren fonksiyon
    function getStoreCount() public view returns (uint256) {
        return stores.length;
    }

    // Yeni bir eşya eklemek için fonksiyon
    function addItem(uint256 storeId, string memory _itemName, uint256 _price) public {
        require(storeId < stores.length, "Invalid Store ID");
        Store storage currentStore = stores[storeId];
        
         // Yeni eşya ID'si
        uint256 newItemId = stores.length;
        currentStore.itemIds.push(newItemId);
         // Eşya ID'sini mağazaya ekle
        
        items[newItemId] = Item(newItemId, _itemName, _price, msg.sender); // Yeni eşya oluştur
    }

    // Eşyanın sahibini değiştiren fonksiyon
    function transferItemOwnership(uint256 itemId, address newOwner) public {
        Item storage currentItem = items[itemId];
        require(currentItem.owner == msg.sender, "You don't own this item");
        
        currentItem.owner = newOwner;
    }

    // Kullanıcı bakiyesini artıran fonksiyon
    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }

    // Kullanıcı bakiyesini azaltan fonksiyon
    function withdraw(uint256 amount) public {
        require(amount <= userBalances[msg.sender], "Insufficient balance");
        userBalances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // Mağaza ID'sine göre eşyaları döndüren fonksiyon
    function getItemsInStore(uint256 storeId) public view returns (Item[] memory) {
        require(storeId < stores.length, "Invalid Store ID");
        Store storage currentStore = stores[storeId];
        uint256 itemCount = currentStore.itemIds.length;
        Item[] memory storeItems = new Item[](itemCount);
        for (uint256 i = 0; i < itemCount; i++) {
            storeItems[i] = items[currentStore.itemIds[i]];
        }
        return storeItems;
    }
}
