pragma solidity ^0.8.0;

contract MarketPlace{

    //id of the item
    uint id;
    
    //items that users can buy/list
    struct Item {
        string name;
        string description;
        uint id;
        uint price;
        string condition;
        address owner;
        bool sold;
    }

    //keeps track of the users activity.
    struct User {
        address account;
        Item[] orders;
        Item[] selling;
    }

    //keeps track of all the users and items
    mapping(address => User) public users;
    mapping(uint => Item) public items;
    address[] usersList;

    //manager is the one that deploys the contract
    address manager; 

    constructor () {
        manager = msg.sender;
        id = 0;
    }

    /**
    *@dev returns items id listed for sale
    *@return items with id
    */
    function getItems(uint itemID) public view returns(Item memory){
        return items[itemID];
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
            id: id,
            condition: condition,
            owner: msg.sender,
            sold: false
        });
        items[id]  =  item;
        id++;

        //add a user in if its its first time listing
        if(users[msg.sender].account != msg.sender){
            users[msg.sender].account = msg.sender;
            usersList.push(msg.sender);
        }
        //add item to users list of items he/she is selling
        users[msg.sender].selling.push(item);
    }

    /*
    *@dev allows user to buy a listed item and add to users list and map
    *param id id of item
    */
    function buyItem(uint itemID, address payable itemOwner) payable public {
        Item storage i = items[itemID];

        require(i.sold == false, "Item is already sold");
        //buyer cannot buy his own items
        require(i.owner != msg.sender, "you cannot buy your own listed items");
        //buyer needs to provide atleast the item price amount note: can include more if buyer wants though
        require(msg.value >= i.price);

        itemOwner.transfer(msg.value); //2000000000000000000 wei = 2 eth
        i.sold = true;

        //updating the user struct
        usersList.push(msg.sender);
        users[msg.sender].orders.push(i);
    }
}