pragma solidity ^0.8.0;

contract MarketPlace{

    //manager takes a %2 fee.
    uint constant FEE = 2;
    
    //items that users can buy/list
    struct Item {
        string name;
        string description;
        uint price;
        string condition;
        address owner;
    }

    //keeps track of the users activity.
    struct User {
        address account;
        Item[] orders;
        Item[] purchaseHistory;
        Item[] selling;
    }

    //keeps track of all the users and items
    mapping(address => User) public users;
    address[] usersList;
    Item[] items;

    //manager is the one that deploys the contract
    address manager; 

    constructor () {
        manager = msg.sender;
    }

    /**
    *@dev returns list of items for sale
    *@return list of items for sale
    */
    function getItems() public view returns(Item[] memory){
        return items;
    }

    /*
    *@dev returns the user
    *@return the user
    *@param users address
    */
    function getUser(address add) public view returns(User memory){
        return users[add];
    }

    /**
     *@dev returns the amount of users there are
     *@return amount of users
     */
    function getUserCount() public view returns (uint){
        return usersList.length;
    }

    /**
     *@dev user must have listed/bought and item to be in the user list
     *@return list of users
     */
    function getUsers() public view returns (address[] memory){
        return usersList;
    }

    /*
    *@dev allows user to list an item for sale 
    *@param name name of the item
    *@param description decsiption of the item
    *@param price how much the item costs.
    *@param condition the condition of the item
    */
    function listItem(string calldata name, string calldata description, uint price, string calldata condition) public {
        Item memory item = Item({
            name: name,
            description: description,
            price: price,
            condition: condition,
            owner: msg.sender
        });
        items.push(item);

        //add a user in if its its first time listing
        if(users[msg.sender].account != msg.sender){
            users[msg.sender].account = msg.sender;
            usersList.push(msg.sender);
        }
        //add item to users list of items he/she is selling
        users[msg.sender].selling.push(item);
    }
}