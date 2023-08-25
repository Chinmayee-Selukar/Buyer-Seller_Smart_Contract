pragma solidity ^0.5.0;

contract Seller{
    struct Product{
        string title;
        uint256 productId;
        uint256 price;
        bool delivered;
        uint256 itemsAvailable;
        uint256 BuyerWants;
    }
    uint counter = 1;
    Product[] public products;
    // mapping(string => uint) goods;
    mapping(string => uint) checkID;
    address public wallet;
    function fetchAddr(address addr) external payable{
        wallet=addr;
    }
    function checkBalance() view public returns(uint){
        return wallet.balance;
    }
    function getAmountOfProduct(string memory _product) view public returns(uint){
        return products[checkID[_product]-1].itemsAvailable;
    }
    function addNewProduct(string memory _product, uint _price, uint _itemsAvailable) public{
        Product memory temp;
        temp.title = _product;
        temp.price = _price; //converting into wei from ether
        temp.productId = counter;
        checkID[temp.title] = temp.productId; 
        counter++;
        // goods[_product]+=_itemsAvailable;
        temp.itemsAvailable += _itemsAvailable;
        products.push(temp);
    }
    function sellProduct(string memory _product,uint _buyerAsk) public{
        products[checkID[_product]-1].BuyerWants=_buyerAsk;
        products[checkID[_product]-1].itemsAvailable-=_buyerAsk;        
        // goods[_product]-=_buyerAsk;
    }
    function getProductPrice(string memory _product) view public returns(uint){
        return products[checkID[_product]-1].price;
    }
    function concludeOnSellerSide(string memory _product,uint status) public{
        if(status==2){
            products[checkID[_product]-1].delivered=true;
        }else{
            products[checkID[_product]-1].itemsAvailable+=products[checkID[_product]-1].BuyerWants;
        }
        products[checkID[_product]-1].BuyerWants=0;

        
    }
}

contract User{
    uint Userbalance;
    address payable wallet;
    mapping(string=>uint) userStuff;
    address public currentSeller;
    address payable ReturnDuesAddr;
    uint dues=0;
    address myConv;
    uint keepThisCount;
    constructor(uint balance) public{
        Userbalance=balance;
    }
    function checkProductInventory(string memory _product) view public returns(uint){
        return userStuff[_product];
    }
    function checkUserBalance() view public returns(uint){
        return Userbalance;
    }
    function checkAvailbility(string memory _product,address _sellerAddress) view public returns(string memory){
        Seller s = Seller(_sellerAddress);
        if(s.getAmountOfProduct(_product)>0) return "Available!";
        else return "Not Available!";
    }
    function deliveryStatus(string memory _product,uint status) public{
        if(status==2) {                            // 0 means item not delivered  1 means in transit and 2 means delivered
            userStuff[_product]+=keepThisCount;     //update user inventory
            wallet.transfer(dues);          //transfer money to seller's wallet
            dues=0;
            Seller s = Seller(myConv);
            s.concludeOnSellerSide(_product,status);
            // completion();            // send money to seller
        }    
        if(status==0){                                 //if deliver fails:
            Userbalance+=dues;                             // return user's money
            ReturnDuesAddr.transfer(dues);
            dues=0;
            Seller s = Seller(myConv);
            s.concludeOnSellerSide(_product,status);
        }    
    }
    function completion() public payable{
        wallet.transfer(dues);          //transfer money to seller's wallet
        dues=0;
    }
    function buyProduct(string memory _product,address _sellerAddress,address payable walletAddr, uint BuyerWants) public payable{
        Seller s= Seller(_sellerAddress);
        myConv = _sellerAddress;
        keepThisCount = BuyerWants;
        require(s.getAmountOfProduct(_product)>BuyerWants,"Product Not Available!");
        require((msg.value<=Userbalance && msg.value>0),"Insufficient Funds!");        //checking validity of transaction
        require(msg.value==s.getProductPrice(_product)*BuyerWants,"Please provide exact amount");
        ReturnDuesAddr=msg.sender;
        s.fetchAddr(walletAddr);                  //make the address provided by user to seller's wallet 
        currentSeller=_sellerAddress;
        wallet=walletAddr;
        Userbalance-=msg.value;                  //update user's balance
        if(msg.value>0){
            s.sellProduct(_product,BuyerWants);           //OFF-LOADING
            dues=msg.value;
        }      
    }
}