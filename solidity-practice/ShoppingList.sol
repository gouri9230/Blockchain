// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.12;

contract ShoppingList {

    mapping(address => User) users;
    
    struct shoppingList {
        string name;
        Item[] items;
    } 
    struct User {
        mapping (string => shoppingList) lists;
        string[] listNames;
    }
    struct Item {
        string name;
        uint256 quantity;
    }
    function createList(string memory name) public {
        require(bytes(users[msg.sender].lists[name].name).length == 0, "list already created");
        require(bytes(name).length > 0);
        //add the list name to array listNames
        users[msg.sender].listNames.push(name);
        // add list name to the shoppingList name
        users[msg.sender].lists[name].name = name;
    }
    function getListNames() public view returns (string[] memory) {
        return users[msg.sender].listNames;
    }
    function getItemNames(string memory listName) public view returns (string[] memory) {
        require(bytes(users[msg.sender].lists[listName].name).length != 0, "no list with this name");
        string[] memory names = new string[](users[msg.sender].lists[listName].items.length);
        for (uint256 idx; idx<names.length;idx++) {
            names[idx] = users[msg.sender].lists[listName].items[idx].name;
        }
        return names;

    }
    function addItem(string memory listName, string memory itemName, uint256 quantity) public {
        require(bytes(users[msg.sender].lists[listName].name).length != 0, "no list with this name");
        users[msg.sender].lists[listName].items.push(Item(itemName, quantity));
    }
}